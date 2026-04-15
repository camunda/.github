#!/usr/bin/env bash
#
# Camunda MCP Configuration Setup
# Installs company-wide MCP server configurations into local IDE settings.
#
# Usage: ./setup.sh [--vscode] [--claude] [--jetbrains] [--all] [--dry-run]
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "  $*"; }
success() { echo -e "${GREEN}✔${NC} $*"; }
warn()    { echo -e "${YELLOW}⚠${NC} $*"; }
error()   { echo -e "${RED}✘${NC} $*" >&2; }

DRY_RUN=false

# ---------------------------------------------------------------------------
# Merge source JSON into target file (deep merge, with backup).
# Usage: merge_json <target_file> <source_file> [wrapper_key]
# ---------------------------------------------------------------------------
merge_json() {
  local target_path="$1" source_path="$2" wrapper_key="${3:-}"

  # Back up existing file
  if [[ -f "$target_path" ]]; then
    cp -p "$target_path" "${target_path}.bak.$(date +%Y%m%d_%H%M%S)"
  fi

  local target
  target=$(if [[ -f "$target_path" ]] && [[ -s "$target_path" ]]; then cat "$target_path"; else echo '{}'; fi)
  local source
  source=$(cat "$source_path")

  # If wrapper key specified, nest the source under that key
  if [[ -n "$wrapper_key" ]]; then
    source=$(jq -n --argjson s "$source" --arg k "$wrapper_key" '{($k): $s}')
  fi

  # Deep merge and write
  local result
  result=$(jq -s '.[0] * .[1]' <(echo "$target") <(echo "$source"))

  if $DRY_RUN; then
    echo "$result" | jq '(.mcp // .mcpServers // .)'
    return
  fi

  mkdir -p "$(dirname "$target_path")"
  echo "$result" > "$target_path"
}

# ---------------------------------------------------------------------------
# OS detection & config paths
# ---------------------------------------------------------------------------
case "$(uname -s)" in
  Darwin*)               OS=macos ;;
  Linux*)                OS=linux ;;
  MINGW*|MSYS*|CYGWIN*) OS=windows ;;
  *)                     OS=unknown ;;
esac

vscode_settings() {
  case "$OS" in
    macos)   echo "$HOME/Library/Application Support/Code/User/settings.json" ;;
    linux)   echo "$HOME/.config/Code/User/settings.json" ;;
    windows) echo "${APPDATA:-}/Code/User/settings.json" ;;
  esac
}

# ---------------------------------------------------------------------------
# Installers
# ---------------------------------------------------------------------------
install_vscode() {
  command -v jq &>/dev/null || { error "jq is required — install via: brew install jq (macOS) / apt install jq (Linux)"; return 1; }
  local target; target="$(vscode_settings)"
  [[ -z "$target" ]] && { error "Unsupported OS for VS Code"; return 1; }
  if $DRY_RUN; then
    info "Would merge into: $target"
    [[ -f "$target" ]] || info "(file does not exist yet — would create)"
    merge_json "$target" "$SCRIPT_DIR/vscode.json" "mcp"
    return
  fi
  mkdir -p "$(dirname "$target")"
  [[ -f "$target" ]] || echo '{}' > "$target"
  merge_json "$target" "$SCRIPT_DIR/vscode.json" "mcp"
  success "VS Code: $target"
}

install_claude() {
  command -v claude &>/dev/null || { error "Claude CLI not found — install from https://docs.anthropic.com/en/docs/claude-code"; return 1; }

  local pat="${GITHUB_PERSONAL_ACCESS_TOKEN:-}"

  if $DRY_RUN; then
    info "Would run:"
    info "  claude mcp add --transport http --scope user camunda-docs https://camunda-docs.mcp.kapa.ai"
    info "  claude mcp add-json --scope user github '<config with GitHub PAT>'"
    return
  fi

  # camunda-docs — no auth required
  local add_output
  if add_output=$(claude mcp add --transport http --scope user camunda-docs https://camunda-docs.mcp.kapa.ai 2>&1); then
    success "Claude: camunda-docs added"
  elif [[ "$add_output" == *"already exists"* ]]; then
    info "Claude: camunda-docs already configured (skipped)"
  else
    error "Claude: camunda-docs failed — $add_output"; return 1
  fi

  # github — requires a GitHub Personal Access Token
  if claude mcp get github 2>/dev/null | grep -q "githubcopilot"; then
    info "Claude: github already configured (skipped)"
  else
    if [[ -z "$pat" ]]; then
      read -rsp "GitHub Personal Access Token (for GitHub MCP server, Enter to skip): " pat
      echo ""
    fi
    if [[ -n "$pat" ]]; then
      if add_output=$(claude mcp add-json --scope user github \
        "{\"type\":\"http\",\"url\":\"https://api.githubcopilot.com/mcp\",\"headers\":{\"Authorization\":\"Bearer $pat\"}}" 2>&1); then
        success "Claude: github added"
      elif [[ "$add_output" == *"already exists"* ]]; then
        info "Claude: github already configured (skipped)"
      else
        error "Claude: github failed — $add_output"; return 1
      fi
    else
      warn "Skipped github MCP server (no PAT provided)"
    fi
  fi
}

install_jetbrains() {
  command -v jq &>/dev/null || { error "jq is required — install via: brew install jq (macOS) / apt install jq (Linux)"; return 1; }

  # Copilot for IntelliJ – merge into ~/.config/github-copilot/intellij/mcp.json
  local copilot_target="$HOME/.config/github-copilot/intellij/mcp.json"
  if $DRY_RUN; then
    info "Would merge into: $copilot_target"
    [[ -f "$copilot_target" ]] || info "(file does not exist yet — would create)"
    merge_json "$copilot_target" "$SCRIPT_DIR/vscode.json"
  else
    mkdir -p "$(dirname "$copilot_target")"
    [[ -f "$copilot_target" ]] || echo '{}' > "$copilot_target"
    merge_json "$copilot_target" "$SCRIPT_DIR/vscode.json"
    success "JetBrains Copilot: $copilot_target"
  fi
}

# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------
usage() {
  cat << 'EOF'
Usage: setup.sh [--vscode] [--claude] [--jetbrains] [--all] [--dry-run] [-h|--help]

Install Camunda MCP server configurations into your IDE(s).
If no options are given, the script runs interactively.

  --dry-run   Show what would be changed without modifying any files.
EOF
}

run_selected() {
  local any=false
  if $do_vscode;    then any=true; install_vscode;    fi
  if $do_claude;    then any=true; install_claude;    fi
  if $do_jetbrains; then any=true; install_jetbrains; fi
  $any || { error "No IDEs selected"; return 1; }
  echo ""
  if $DRY_RUN; then
    warn "Dry run — no files were modified."
  else
    success "Done — restart your IDE(s) to pick up the new MCP servers."
  fi
}

interactive() {
  echo ""
  echo -e "${BOLD}Camunda MCP Configuration Setup${NC}"
  echo ""
  echo "  1) VS Code"
  echo "  2) Claude Code"
  echo "  3) JetBrains (IntelliJ, WebStorm, …)"
  echo "  a) All    q) Quit"
  echo ""
  read -rp "Choose (comma-separated, e.g. 1,3): " choice
  [[ "$choice" == [qQ] ]] && exit 0

  do_vscode=false; do_claude=false; do_jetbrains=false
  if [[ "$choice" == [aA] ]]; then
    do_vscode=true; do_claude=true; do_jetbrains=true
  else
    IFS=',' read -ra sel <<< "$choice"
    for s in "${sel[@]}"; do
      case "$(echo "$s" | tr -d ' ')" in
        1) do_vscode=true ;; 2) do_claude=true ;; 3) do_jetbrains=true ;;
        *) warn "Unknown: $s" ;;
      esac
    done
  fi
  run_selected
}

main() {
  do_vscode=false; do_claude=false; do_jetbrains=false
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --vscode)    do_vscode=true ;;
      --claude)    do_claude=true ;;
      --jetbrains) do_jetbrains=true ;;
      --all)       do_vscode=true; do_claude=true; do_jetbrains=true ;;
      --dry-run)   DRY_RUN=true ;;
      -h|--help)   usage; exit 0 ;;
      *)           error "Unknown option: $1"; usage; exit 1 ;;
    esac
    shift
  done

  # No IDE selected — go interactive
  if ! $do_vscode && ! $do_claude && ! $do_jetbrains; then
    interactive; exit 0
  fi

  run_selected
}

main "$@"
