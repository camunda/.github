# Camunda MCP Server Setup

This directory contains company-wide [MCP (Model Context Protocol)](https://modelcontextprotocol.io/) server configurations and an installer script that copies them into your local IDE settings.

## Quick start

```bash
git clone https://github.com/camunda/.github.git
cd .github/mcp
./setup.sh          # interactive – choose which IDEs to configure
```

Or pass flags directly:

```bash
./setup.sh --all              # configure everything
./setup.sh --vscode --claude  # only VS Code and Claude Code
```

## What gets installed

| MCP Server | Description | VS Code | Claude Code | Claude Desktop | JetBrains |
|---|---|:---:|:---:|:---:|:---:|
| `github` | GitHub tools via [GitHub MCP Server](https://github.com/github/github-mcp-server) | ✔ | ✔ | ✔ | — |

> **Note:** In VS Code the `github` MCP server authenticates via the Copilot extension. In Claude Code it requires a [GitHub Personal Access Token](https://github.com/settings/personal-access-tokens/new). In Claude Desktop, authenticate via Settings → Connectors.

## Target config paths

| IDE | Config file | Action |
|---|---|---|
| **VS Code** | `~/Library/Application Support/Code/User/settings.json` (macOS) | Merges servers into the `mcp.servers` key |
| | `~/.config/Code/User/settings.json` (Linux) | |
| **Claude Code** | n/a (uses `claude mcp add` CLI commands) | Adds servers via the Claude CLI with `--scope user` |
| **Claude Desktop** | n/a (manual via Settings UI) | Prints step-by-step instructions |
| **JetBrains** | Configured via IDE Settings UI | Prints step-by-step instructions |

The script **backs up** any existing config file before modifying it (`<file>.bak.<timestamp>`).

## Prerequisites

- **jq** on `PATH` — install via `brew install jq` (macOS) or `apt install jq` (Linux) (required for VS Code and JetBrains)
- **claude** CLI on `PATH` (required for Claude Code) — install from [docs.anthropic.com](https://docs.anthropic.com/en/docs/claude-code)
- No other dependencies

## CLI reference

```
Usage: setup.sh [OPTIONS]

Options:
  --vscode          Configure VS Code
  --claude          Configure Claude Code
  --claude-desktop  Configure Claude Desktop (prints manual steps)
  --jetbrains       Configure JetBrains IDE (prints manual steps)
  --all             Configure all supported IDEs
  -h, --help        Show this help message
```

## Adding a new MCP server

1. Add the server to each IDE-specific config file in this directory:
   - `vscode.json` — uses `servers` key with `"type": "http"`
   - `jetbrains.json` — uses `mcpServers` key
   - For Claude Desktop, update the manual instructions in `install_claude_desktop()` in `setup.sh`
2. Update the table in this README.
3. Commit and let others re-run `./setup.sh`.

## Troubleshooting

| Problem | Fix |
|---|---|
| `jq is required` | Install jq (`brew install jq` / `apt install jq`) — needed for VS Code and JetBrains only |
| VS Code comments lost after merge | VS Code settings.json must be valid JSON (not JSONC) for the merge to work. Back up is always created first. |
| Changes not visible in IDE | Restart the IDE (or reload the VS Code window: `Cmd+Shift+P` → *Reload Window*). |
| Claude CLI not found | Install the Claude Code CLI from [docs.anthropic.com](https://docs.anthropic.com/en/docs/claude-code) |
