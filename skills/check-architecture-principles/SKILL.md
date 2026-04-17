---
name: check-architecture-principles
description: Validates structural or foundational code changes against Camunda architecture principles. Use when a change alters module boundaries, APIs, data flows, core architecture, domain models, or protocols.
compatibility: Requires gh CLI (preferred) or the `github` MCP server as fallback
metadata:
  author: camunda
---

# Check Architecture Principles

## When to use

Use this skill before implementing any **structural** or **foundational** change:

- **Structural:** Refactors that change module boundaries, APIs, data flows, or responsibilities
- **Foundational:** Changes to core architecture, domain model, protocols, or persistence

Do not use for linear changes (flags, constants, simple feature tweaks).

## Procedure

### 1. Fetch the architecture principles

Try `gh` first. Fall back to GitHub MCP if `gh` is unavailable or returns an error (e.g., 404 may indicate missing authentication).

**Primary — `gh` CLI:**

```bash
# List principle documents
gh api repos/camunda/product-development/contents/architecture/principles --jq '.[].name'

# Read a specific principle
gh api repos/camunda/product-development/contents/architecture/principles/{filename} --jq '.content' | base64 -d
```

**Fallback — `github` MCP server:**

Use the `github` MCP server to read the contents of `architecture/principles` in the `camunda/product-development` repo. Use this when `gh` is not available (e.g., web UI environments).

Read each principle document found.

### 2. Evaluate conformance

For each principle, evaluate whether the planned change conforms or conflicts. Produce a checklist:

```
Architecture Conformance:
- [ ] Principle: [name] — [conformant / not applicable / conflict]
```

### 3. Handle conflicts

If any principle conflicts with the planned change:
- Stop and report the conflict to the engineer
- Suggest an alternative approach that conforms
- Do not proceed with implementation until the engineer explicitly approves the deviation

### 4. Proceed

If all principles are conformant or not applicable, proceed with implementation.
