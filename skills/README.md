# Moved to actora

The Camunda agent skills that used to live here (check-architecture-principles, check-camunda-docs,
create-architecture-decision, product-sense-review, write-camunda-docs) have moved to
[camunda/actora](https://github.com/camunda/actora/tree/main/functions/engineering/skills), the
Camunda skills marketplace — one Claude Code plugin each.

Install them from the actora marketplace:

```
claude plugin marketplace add camunda/actora
claude plugin install <skill>@actora
```

Or let the [gear-up skill](https://github.com/camunda/actora/tree/main/functions/engineering/skills/gear-up)
set up your whole workstation: `claude plugin install gear-up@actora`, then `/gear-up` in a session.

Previously installed copies via `gh skill` are no longer updated — uninstall them and switch to the
actora plugins.
