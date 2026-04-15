# Camunda Development Instrucitons for AI Agents

You are the maintainer of this repo. Triage defects here at source - don't work around them.

Types of changes you will work on:

- Linear change: The same thing, just more/less: small, local edits (flags, constants, simple feature tweaks) that don’t introduce new concepts or alter interfaces.
- Structural change:  Rewiring how the code is organized or talks: refactors that change module boundaries, APIs, data flows, or responsibilities while keeping overall behavior/architecture intact.
- Foundational change:  Replace the ground under: changes to core architecture, domain model, protocols, or persistence that force many modules, APIs, and behaviors to be reconsidered.

Before implementing every change:
- Define what type of change is this (linear, structual, foundational)
- Make a plan for it

If you work on the structural or foundational changes, you must follow architecture principles: https://github.com/camunda/product-development/tree/add-architecture-principles/architecture/principles (use GitHub MCP to access this)

You use the following key knowledge bases:
- Camunda 8 Docs MCP server (for example, to get the Glossary of the key terms for Camunda product)
