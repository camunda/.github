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
./setup.sh --vscode --claude  # only VS Code and Claude Desktop
```

## What gets installed

| MCP Server | Description | VS Code | Claude Desktop | JetBrains |
|---|---|:---:|:---:|:---:|
| `camunda-docs` | Camunda 8 documentation search via [kapa.ai](https://camunda-docs.mcp.kapa.ai) | ✔ | ✔ | ✔ |
| `github` | GitHub tools via Copilot MCP proxy | ✔ | — | — |

> **Note:** The `github` MCP server requires GitHub Copilot and is only available in VS Code (where authentication is handled by the Copilot extension).

## Target config paths

| IDE | Config file | Action |
|---|---|---|
| **VS Code** | `~/Library/Application Support/Code/User/settings.json` (macOS) | Merges servers into the `mcp.servers` key |
| | `~/.config/Code/User/settings.json` (Linux) | |
| **Claude Desktop** | `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) | Merges servers into the `mcpServers` key |
| | `~/.config/Claude/claude_desktop_config.json` (Linux) | |
| **JetBrains** | Configured via IDE Settings UI | Prints step-by-step instructions |

The script **backs up** any existing config file before modifying it (`<file>.bak.<timestamp>`).

## Prerequisites

- **jq** on `PATH` — install via `brew install jq` (macOS) or `apt install jq` (Linux)
- No other dependencies

## CLI reference

```
Usage: setup.sh [OPTIONS]

Options:
  --vscode      Configure VS Code
  --claude      Configure Claude Desktop
  --jetbrains   Configure JetBrains IDE (prints manual steps)
  --all         Configure all supported IDEs
  -h, --help    Show this help message
```

## Adding a new MCP server

1. Add the server to each IDE-specific config file in this directory:
   - `vscode.json` — uses `servers` key with `"type": "http"`
   - `claude-desktop.json` — uses `mcpServers` key
   - `jetbrains.json` — uses `mcpServers` key
2. Update the table in this README.
3. Commit and let others re-run `./setup.sh`.

## Troubleshooting

| Problem | Fix |
|---|---|
| `jq is required` | Install jq (`brew install jq` / `apt install jq`) |
| VS Code comments lost after merge | VS Code settings.json must be valid JSON (not JSONC) for the merge to work. Back up is always created first. |
| Changes not visible in IDE | Restart the IDE (or reload the VS Code window: `Cmd+Shift+P` → *Reload Window*). |
| Claude Desktop config dir missing | Install and launch Claude Desktop at least once to create the config directory. |
