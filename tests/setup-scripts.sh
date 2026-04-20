#!/usr/bin/env bash
#
# Smoke tests for mcp/setup.sh and skills/setup.sh
# Runs both scripts in dry-run / error paths only — no files are modified.
#
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

PASS=0
FAIL=0

pass() { PASS=$((PASS + 1)); echo "  ✔ $1"; }
fail() { FAIL=$((FAIL + 1)); echo "  ✘ $1"; }

assert_exit() {
  local expected="$1" actual="$2" label="$3"
  if [[ "$actual" -eq "$expected" ]]; then pass "$label"; else fail "$label (expected exit $expected, got $actual)"; fi
}

assert_contains() {
  local needle="$1" haystack="$2" label="$3"
  if echo "$haystack" | grep -q "$needle"; then pass "$label"; else fail "$label (expected '$needle' in output)"; fi
}

# =========================================================================
echo ""
echo "=== skills/setup.sh ==="
echo ""

SKILLS="$REPO_ROOT/skills/setup.sh"

# -- dry-run defaults to Copilot, no interactive prompt
out=$($SKILLS --dry-run 2>&1) ; rc=$?
assert_exit 0 "$rc" "--dry-run exits 0"
assert_contains "Would run" "$out" "--dry-run prints planned commands"
assert_contains "check-architecture-principles" "$out" "--dry-run discovers architecture skill"
assert_contains "check-camunda-docs" "$out" "--dry-run discovers docs skill"

# -- dry-run with specific agent
out=$($SKILLS --dry-run --agent claude-code 2>&1) ; rc=$?
assert_exit 0 "$rc" "--dry-run --agent claude-code exits 0"
assert_contains "claude-code" "$out" "--agent claude-code appears in output"

# -- dry-run with --all
out=$($SKILLS --dry-run --all 2>&1) ; rc=$?
assert_exit 0 "$rc" "--dry-run --all exits 0"
assert_contains "claude-code" "$out" "--all includes claude-code"
assert_contains "cursor" "$out" "--all includes cursor"
assert_contains "gemini" "$out" "--all includes gemini"

# -- --agent without value
out=$($SKILLS --agent 2>&1 || true)
assert_contains "Missing value" "$out" "--agent without value shows error"

# -- unknown option
out=$($SKILLS --bogus 2>&1 || true)
assert_contains "Unknown option" "$out" "unknown option shows error"

# -- help
out=$($SKILLS --help 2>&1) ; rc=$?
assert_exit 0 "$rc" "--help exits 0"
assert_contains "Usage" "$out" "--help shows usage"

# =========================================================================
echo ""
echo "=== mcp/setup.sh ==="
echo ""

MCP="$REPO_ROOT/mcp/setup.sh"

# -- dry-run with --vscode (requires jq)
if command -v jq &>/dev/null; then
  out=$($MCP --dry-run --vscode 2>&1) ; rc=$?
  assert_exit 0 "$rc" "--dry-run --vscode exits 0"
  assert_contains "Would merge" "$out" "--dry-run --vscode previews merge"
else
  echo "  ⊘ skipped --vscode tests (jq not installed)"
fi

# -- dry-run with --jetbrains (requires jq)
if command -v jq &>/dev/null; then
  out=$($MCP --dry-run --jetbrains 2>&1) ; rc=$?
  assert_exit 0 "$rc" "--dry-run --jetbrains exits 0"
  assert_contains "Would merge" "$out" "--dry-run --jetbrains previews merge"
else
  echo "  ⊘ skipped --jetbrains tests (jq not installed)"
fi

# -- unknown option
out=$($MCP --bogus 2>&1 || true)
assert_contains "Unknown option" "$out" "unknown option shows error"

# -- help
out=$($MCP --help 2>&1) ; rc=$?
assert_exit 0 "$rc" "--help exits 0"
assert_contains "Usage" "$out" "--help shows usage"

# =========================================================================
echo ""
echo "--- Results: $PASS passed, $FAIL failed ---"
echo ""
[[ "$FAIL" -eq 0 ]]
