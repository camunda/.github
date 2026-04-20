#!/usr/bin/env bash
#
# Camunda Agent Skills Setup
# Installs organization-wide agent skills into your local agent configuration.
#
# Usage: ./setup.sh [--agent <name>] [--all] [--dry-run] [-h|--help]
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="camunda/.github"
SOURCE="$REPO"
SOURCE_IS_LOCAL=false

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

SUPPORTED_AGENTS="claude-code cursor codex gemini"

# ---------------------------------------------------------------------------
# Portable semver comparison (sort -V is not available on macOS by default)
# ---------------------------------------------------------------------------
version_ge() {
  local a="$1" b="$2"
  local a_major a_minor a_patch b_major b_minor b_patch

  IFS='.' read -r a_major a_minor a_patch <<< "$a"
  IFS='.' read -r b_major b_minor b_patch <<< "$b"

  (( a_major > b_major )) && return 0
  (( a_major < b_major )) && return 1
  (( a_minor > b_minor )) && return 0
  (( a_minor < b_minor )) && return 1
  (( a_patch >= b_patch )) && return 0
  return 1
}

# ---------------------------------------------------------------------------
# Discover skills — each subdirectory containing a SKILL.md
# ---------------------------------------------------------------------------
discover_skills() {
  local base_dir="${1:-$SCRIPT_DIR}"
  local skills=()
  for dir in "$base_dir"/*/; do
    [[ -f "$dir/SKILL.md" ]] && skills+=("$(basename "$dir")")
  done
  for dir in "$base_dir"/skills/*/; do
    [[ -f "$dir/SKILL.md" ]] && skills+=("$(basename "$dir")")
  done
  echo "${skills[@]}"
}

# Prefer local checkout when running inside a git worktree with skills.
auto_detect_local_source() {
  local repo_root
  repo_root=$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || true)
  [[ -n "$repo_root" ]] || return 1

  local found
  found="$(discover_skills "$repo_root")"
  [[ -n "$found" ]] || return 1

  SOURCE="$repo_root"
  SOURCE_IS_LOCAL=true
  return 0
}

# ---------------------------------------------------------------------------
# Install a single skill
# Usage: install_skill <skill_name> [agent_name]
#   If agent_name is empty, installs for GitHub Copilot (default).
# ---------------------------------------------------------------------------
install_skill() {
  local skill="$1"
  local agent="${2:-}"
  local label="${agent:-github-copilot}"

  local cmd=(gh skill install "$SOURCE" "$skill" --scope user)
  $SOURCE_IS_LOCAL && cmd+=(--from-local)
  if [[ -n "$agent" ]]; then
    cmd+=(--agent "$agent")
  fi

  if $DRY_RUN; then
    info "Would run: ${cmd[*]}"
    return
  fi

  local output
  if output=$("${cmd[@]}" 2>&1); then
    success "$skill installed ($label)"
  elif [[ "$output" == *"already"* ]]; then
    info "$skill already installed ($label) (skipped)"
  else
    error "$skill failed ($label) — $output"
    return 1
  fi
}

# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------
usage() {
  cat << 'EOF'
Usage: setup.sh [OPTIONS]

Install Camunda agent skills into your local agent configuration.
If no options are given, the script runs interactively.

Options:
  --agent <name>   Install for a specific agent (claude-code, cursor, codex, gemini)
                   Can be specified multiple times. Default: installs for GitHub Copilot.
  --all            Install for all supported agents
  --dry-run        Show what would be done without installing
  -h, --help       Show this help message

Examples:
  ./setup.sh                          # Interactive
  ./setup.sh --agent claude-code      # Claude Code only
  ./setup.sh --all                    # All agents
  ./setup.sh --dry-run                # Preview
EOF
}

interactive() {
  echo ""
  echo -e "${BOLD}Camunda Agent Skills Setup${NC}"
  echo ""

  local skills
  local discovery_root="$SCRIPT_DIR"
  $SOURCE_IS_LOCAL && discovery_root="$SOURCE"
  read -ra skills <<< "$(discover_skills "$discovery_root")"
  echo "  Skills to install:"
  for s in "${skills[@]}"; do
    echo "    - $s"
  done
  echo ""
  echo "  1) GitHub Copilot / VSCode (default)"
  echo "  2) Claude Code"
  echo "  3) Cursor"
  echo "  4) Codex"
  echo "  5) Gemini CLI"
  echo "  a) All    q) Quit"
  echo ""
  read -rp "Choose agents (comma-separated, e.g. 1,2): " choice
  # Default to Copilot on empty input
  if [[ -z "${choice//[[:space:]]/}" ]]; then
    choice="1"
  fi
  [[ "$choice" == [qQ] ]] && exit 0

  local agents=()
  if [[ "$choice" == [aA] ]]; then
    agents=("" "claude-code" "cursor" "codex" "gemini")
  else
    IFS=',' read -ra sel <<< "$choice"
    for s in "${sel[@]}"; do
      case "$(echo "$s" | tr -d ' ')" in
        1) agents+=("") ;;
        2) agents+=("claude-code") ;;
        3) agents+=("cursor") ;;
        4) agents+=("codex") ;;
        5) agents+=("gemini") ;;
        *) warn "Unknown: $s" ;;
      esac
    done
  fi

  for agent in "${agents[@]}"; do
    for skill in "${skills[@]}"; do
      install_skill "$skill" "$agent"
    done
  done

  echo ""
  if $DRY_RUN; then
    warn "Dry run — nothing was installed."
  else
    success "Done. Skills will be checked for updates by the agent at session start."
  fi
}

main() {
  local agents=()
  local install_all=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --agent)
        shift
        if [[ $# -eq 0 ]]; then
          error "Missing value for --agent"
          usage
          exit 1
        fi
        agents+=("$1")
        ;;
      --all)      install_all=true ;;
      --dry-run)  DRY_RUN=true ;;
      -h|--help)  usage; exit 0 ;;
      *)          error "Unknown option: $1"; usage; exit 1 ;;
    esac
    shift
  done

  command -v gh &>/dev/null || { error "GitHub CLI (gh) is required — install from https://cli.github.com"; exit 1; }

  # gh skill requires v2.90.0+
  local gh_version
  gh_version=$(gh --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || true)
  local required="2.90.0"

  if [[ -z "$gh_version" || ! "$gh_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    error "Could not determine GitHub CLI version"
    info "Expected 'gh --version' to contain a semantic version like X.Y.Z"
    info "See https://cli.github.com"
    exit 1
  fi

  if ! version_ge "$gh_version" "$required"; then
    error "GitHub CLI v${required}+ is required for 'gh skill' (found v${gh_version})"
    info "Upgrade with: brew upgrade gh (macOS) or see https://cli.github.com"
    exit 1
  fi

  if ! $SOURCE_IS_LOCAL; then
    auto_detect_local_source || true
  fi

  if $SOURCE_IS_LOCAL; then
    [[ -d "$SOURCE" ]] || { error "Local source directory not found: $SOURCE"; exit 1; }
  fi

  local skills
  if $SOURCE_IS_LOCAL; then
    read -ra skills <<< "$(discover_skills "$SOURCE")"
  else
    read -ra skills <<< "$(discover_skills "$SCRIPT_DIR")"
  fi

  if [[ ${#skills[@]} -eq 0 ]]; then
    error "No skills found in $SCRIPT_DIR"; exit 1
  fi

  # No agents or --all specified and not dry-run-only — go interactive
  if ! $install_all && [[ ${#agents[@]} -eq 0 ]] && ! $DRY_RUN; then
    interactive; exit 0
  fi

  if $install_all; then
    agents=("" "claude-code" "cursor" "codex" "gemini")
  fi

  # Default to Copilot if only --dry-run was passed
  [[ ${#agents[@]} -eq 0 ]] && agents+=("")

  for agent in "${agents[@]}"; do
    for skill in "${skills[@]}"; do
      install_skill "$skill" "$agent"
    done
  done

  echo ""
  if $DRY_RUN; then
    warn "Dry run — nothing was installed."
  else
    success "Done. Skills will be checked for updates by the agent at session start."
  fi
}

main "$@"
