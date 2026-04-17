---
name: check-ui-design-guidance
description: Provides Camunda brand and UI design guidance and validates developed UI against it. Use when building, reviewing, or modifying any user-facing interface — web apps, dashboards, forms, or task applications.
compatibility: Requires gh CLI (preferred) or the Camunda Company Handbook MCP server as fallback
metadata:
  author: camunda
---

# Check UI Design Guidance

## When to use

Use this skill when:

- Building a new user-facing interface (web app, dashboard, task application, form)
- Modifying existing UI components (layout, colors, typography, copy)
- Reviewing UI code for brand conformance

## Procedure

### 1. Fetch design guidance from the Company Handbook

The authoritative source for Camunda design guidance is the Company Handbook at `camunda/company-handbook`. Always fetch it fresh — do not rely on cached or inlined copies.

**Primary — `gh` CLI:**

```bash
# Core brand guidelines (visual identity, principles, rules)
gh api repos/camunda/company-handbook/contents/company/marketing/branding/branding.md --jq '.content' | base64 -d

# Color palette
gh api repos/camunda/company-handbook/contents/company/marketing/branding/references/colors.md --jq '.content' | base64 -d

# Typography
gh api repos/camunda/company-handbook/contents/company/marketing/branding/references/typography.md --jq '.content' | base64 -d

# Graphic elements and layout patterns
gh api repos/camunda/company-handbook/contents/company/marketing/branding/references/graphic-elements.md --jq '.content' | base64 -d

# Writing style (for UI copy)
gh api repos/camunda/company-handbook/contents/company/marketing/writing-style/writing-style.md --jq '.content' | base64 -d

# Formatting rules
gh api repos/camunda/company-handbook/contents/company/marketing/writing-style/references/formatting.md --jq '.content' | base64 -d

# Product naming and terminology
gh api repos/camunda/company-handbook/contents/company/marketing/terminology/references/camunda-product-naming.md --jq '.content' | base64 -d
```

Fetch only what is relevant to the current task. For a simple color check, fetching `colors.md` alone is sufficient.

**Fallback — Camunda Company Handbook MCP server:**

Use `mcp__claude_ai_Camunda_Company_Handbook__read_page` to read handbook pages when `gh` is not available. Relevant paths:

- `company/marketing/branding/branding.md`
- `company/marketing/branding/references/colors.md`
- `company/marketing/branding/references/typography.md`
- `company/marketing/branding/references/graphic-elements.md`
- `company/marketing/writing-style/writing-style.md`
- `company/marketing/writing-style/references/formatting.md`
- `company/marketing/terminology/references/camunda-product-naming.md`

### 2. Apply guidance during development

Based on the fetched guidance, apply the brand rules to the UI being built. Pay particular attention to:

- **Colors:** Use only Camunda palette colors. Apply theme guidance (light/dark) correctly.
- **Typography:** Use the correct font family and weight scale.
- **Writing style:** Apply the handbook's rules for UI copy (case, voice, formatting).
- **Layout:** Follow the graphic elements guidance for spacing, shapes, and component patterns.

### 3. Validate developed UI

After building or modifying UI, check each item against the fetched guidance:

```
UI Design Conformance:
- [ ] Colors: only Camunda palette colors used, accent colors applied correctly
- [ ] Typography: correct font family loaded and applied with proper weight scale
- [ ] Writing style: sentence case headers, active voice, no Latin abbreviations
- [ ] UI element references in copy use bold formatting
- [ ] Layout: follows graphic elements guidance (spacing, rounded corners, component patterns)
- [ ] Links: descriptive text, accessible color per theme
- [ ] Product naming: follows terminology guidelines
```

If any item fails, fix it before proceeding.
