# Camunda Agent Skills

This directory contains organization-wide [Agent Skills](https://agentskills.io) that extend AI coding agents with Camunda-specific capabilities.

## Quick start

```bash
git clone https://github.com/camunda/.github.git
cd .github/skills
./setup.sh              # interactive — choose which agents to configure
```

Or pass flags directly:

```bash
./setup.sh --agent claude-code    # Claude Code only
./setup.sh --all                  # all supported agents
```

If you run `./setup.sh` from inside a git checkout that contains these skills, the script automatically installs from that local checkout.

## Available skills

| Skill | Description |
|---|---|
| `check-architecture-principles` | Validates structural/foundational changes against Camunda architecture principles |
| `check-camunda-docs` | Searches Camunda 8 docs for domain knowledge needed during implementation |
| `create-architecture-decision` | Creates an Architecture Decision Record (ADR) in Markdown format from a design discussion (e.g. Google Drive document, github issue) |

## Prerequisites

- **GitHub CLI** v2.90.0+ with the `gh skill` extension
- **MCP servers** configured via [`mcp/setup.sh`](../mcp/README.md) — the skills depend on the `github` and `camunda-docs` MCP servers

## Keeping skills up to date

Skills are checked for freshness by the agent at the start of every session (see [AGENTS.md](../AGENTS.md#tooling-preconditions)). When updates are available, the agent will nudge you to run:

```bash
gh skill update --all
```

## Adding a new skill

1. Create a new directory under `skills/` matching the skill name (lowercase, hyphens only).
2. Add a `SKILL.md` with the required frontmatter (`name`, `description`) and instructions.
3. Update the table above.
4. Commit — others can then install via `gh skill install camunda/.github <skill-name>`.
