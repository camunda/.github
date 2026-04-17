---
name: check-camunda-docs
description: Searches Camunda 8 documentation for domain knowledge needed during implementation. Use when a change involves Camunda-specific concepts, APIs, configuration, or behavior — such as BPMN, DMN, Zeebe, Connectors, Operate, Tasklist, Identity, or any Camunda platform component.
compatibility: Requires the `camunda-docs` MCP server configured via camunda/.github/mcp/setup.sh
metadata:
  author: camunda
---

# Check Camunda Docs

## When to use

Use this skill when implementing any change that involves Camunda domain knowledge:

- Camunda platform components (Zeebe, Operate, Tasklist, Identity, Optimize, Connectors, Console)
- BPMN or DMN modeling concepts
- Camunda APIs, SDKs, or client libraries
- Configuration, deployment, or operational behavior
- Error codes, status types, or domain-specific enumerations

## Procedure

### 1. Identify relevant concepts

Identify the Camunda concepts relevant to the current change.

### 2. Search documentation

Query the `camunda-docs` MCP server with a focused search term.

- Prefer specific terms over broad ones (e.g., "Zeebe gateway timeout configuration" over "Zeebe config")
- If the first query returns insufficient results, refine and retry with alternative terms

### 3. Extract relevant knowledge

From the returned documentation, extract:
- Correct API signatures, configuration keys, or behavioral guarantees
- Constraints or limitations that affect the implementation
- Recommended patterns from the official docs

### 4. Apply and flag discrepancies

Apply what you learned to the implementation. If the documentation contradicts the current code, flag the discrepancy to the engineer before changing behavior.
