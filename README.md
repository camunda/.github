# Default Organizational Resources

## This repository contains the default organizational resources for the [Camunda GitHub organization](https://github.com/camunda).

### Help Resources

* [GitHub: Creating default community health file for your organization](https://help.github.com/en/github/building-a-strong-community/creating-a-default-community-health-file-for-your-organization)
* [GitHub: Configure issue templates for your repository](https://help.github.com/en/github/building-a-strong-community/configuring-issue-templates-for-your-repository)
* [GitHub: Sharing Workflows with your organization](https://docs.github.com/en/actions/learn-github-actions/sharing-workflows-with-your-organization)

### AI Agent Instructions (`AGENTS.md`)

[`AGENTS.md`](AGENTS.md) provides development instructions for AI coding agents working in Camunda repositories. It defines how agents should classify changes (linear, structural, foundational), plan before implementing, and cross-check against key references such as architecture principles and Camunda 8 documentation.

### Developer Setup

Set up your local environment for AI-assisted development in two steps:

1. **MCP servers and agent skills** — give agents access to Camunda docs, GitHub tools, and Camunda-specific capabilities via [camunda/actora](https://github.com/camunda/actora)
   ```bash
   claude plugin marketplace add camunda/actora
   claude plugin install gear-up@actora
   ```
   Then run `/gear-up` in a Claude Code session to complete the setup.
   See [`mcp/README.md`](mcp/README.md) and [`skills/README.md`](skills/README.md) for details.

2. **Token-reduction tools** — cut context token usage
   - **rtk** — CLI proxy compacting git/gh/ls/grep/test output, see [rtk-ai/rtk](https://github.com/rtk-ai/rtk#installation) for how to install.
   - **caveman** — ultra-compressed assistant output mode, see [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman#install) for how to install.

   Verify: `rtk init -g` in terminal and `/caveman-help` inside Claude Code.

### Onboarding a Repository

Follow the instructions in https://github.com/camunda/ai-first-template for how to onboard your repo for using this AI-First framework.