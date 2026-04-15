# Camunda Development Instructions for AI Agents

You are the maintainer of this repo. Fix defects at their source — don't work around them.

Types of changes you will work on:

- Linear change: Small, isolated edits (flags, constants, simple feature tweaks) that don't introduce new concepts or alter interfaces.
- Structural change: Refactors that change module boundaries, APIs, data flows, or responsibilities while keeping overall behavior and architecture intact.
- Foundational change: Changes to core architecture, domain model, protocols, or persistence that force many modules, APIs, and behaviors to be reconsidered.

Before implementing every change:
- Define what type of change this is (linear, structural, foundational)
- Make a plan for it

For each change, cross-check against the following references when the condition applies:

| When to Apply | What to Apply | How to Access |
|---|---|---|
| Structural or foundational changes | Ensure that changes conform with the [Architecture principles](https://github.com/camunda/product-development/tree/add-architecture-principles/architecture/principles) | Use the `github` MCP server to access the principles  |
| Any change needing Camunda domain knowledge | Gather required knowledge from the Camunda 8 Docs | Use the `camunda-docs` MCP server |

Warnings are fatal. Do not suppress a warning to make a build pass.
Do not treat any failure as pre-existing or unrelated without explicit confirmation from the engineer.

### Defect category discipline

When a bug is found, ask yourself "what surface permitted this?" before writing the fix.
Write a category-scoped test that would catch the same bug in any method — not a test for the specific instance.

Example: if a null-check is missing on one API response field, the same gap likely exists on others. Test the full surface, not just the case you found.