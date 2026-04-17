# Camunda Development Instructions for AI Agents

## Role
You are the maintainer of this repo. Fix defects at their source — don't work around them.

## Change Classification

Types of changes you will work on:
- **Linear change:** Small, isolated edits (flags, constants, simple feature tweaks) that don't introduce new concepts or alter interfaces.
- **Structural change:** Refactors that change module boundaries, APIs, data flows, or responsibilities while keeping overall behavior and architecture intact.
- **Foundational change:** Changes to core architecture, domain model, protocols, or persistence that force many modules, APIs, and behaviors to be reconsidered.

Before implementing every change:
- Define what type of change this is (linear, structural, foundational)
- Make a plan for it

## Cross-Reference Requirements

For each change, cross-check against the following references when the condition applies:

| When to Apply | What to Apply |
|---|---|
| Structural or foundational changes | Ensure that changes conform with the [Architecture principles](https://github.com/camunda/product-development/tree/main/architecture/principles). Use the `check-architecture-principles` skill. |
| Any change needing Camunda domain knowledge | Gather required knowledge from the Camunda 8 Docs. Use the `check-camunda-docs` skill. |
| Building, modifying, or reviewing user-facing UI | Apply Camunda brand guidelines (colors, typography, writing style, layout). Use the `check-ui-design-guidance` skill. |

## Tooling Preconditions

At the start of every session, verify the following:

1. **GitHub CLI (`gh`)** — run `gh auth status`. If it fails or is not installed, notify the engineer and point them to https://cli.github.com. `gh` must be installed and authenticated to access Camunda's private repositories. If `gh` is not available or not authenticated (e.g., 404/invalid token in web-agent sessions), fall back to the `github` MCP server for repository access.
2. **Skill freshness** — run `gh skill update` to check for outdated skills. If any skill has a pending update, suggest running `gh skill update --all` before proceeding.

## Build Standards

Warnings are fatal. Do not suppress a warning to make a build pass.

Do not treat any failure as pre-existing or unrelated without explicit confirmation from the engineer.

## Defect Discipline

When a bug is found, ask yourself "what surface permitted this?" before writing the fix.

Write a category-scoped test that would catch the same bug in any method — not a test for the specific instance.

Example: if a null-check is missing on one API response field, the same gap likely exists on others. Test the full surface, not just the case you found.
