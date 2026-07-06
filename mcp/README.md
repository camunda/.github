# Moved to actora

The company-wide MCP setup that used to live here has moved to the
[gear-up skill](https://github.com/camunda/actora/tree/main/functions/engineering/skills/gear-up)
in [camunda/actora](https://github.com/camunda/actora).

For Claude Code, run `/gear-up` (or the skill's bundled `scripts/setup-mcp.sh`) to configure the
`github` MCP server:

```bash
claude plugin marketplace add camunda/actora
claude plugin install gear-up@actora
```

For Claude Desktop, connect the org-provided GitHub connector under Settings → Connectors.
