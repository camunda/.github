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

1. **MCP servers** — give agents access to Camunda docs and GitHub tools
   ```bash
   cd mcp && ./setup.sh
   ```
   See [`mcp/README.md`](mcp/README.md) for details.

2. **Agent skills** — give agents Camunda-specific capabilities
   ```bash
   cd skills && ./setup.sh
   ```
   See [`skills/README.md`](skills/README.md) for details.

### Onboarding a Repository

Follow the instructions in https://github.com/camunda/ai-first-template for how to onboard your repo for using this AI-First framework.