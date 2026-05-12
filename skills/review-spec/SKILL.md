---
name: review-spec
description: |
  Review an engineering spec, design doc, or WIP RFC before implementation.
  Applies a PM/architect lens, surfaces forks, gaps, dependencies, and
  strategic-fit questions. Output is a structured review posted inline in
  the conversation — does NOT write files to the working directory.
  Triggers on: "review this spec", "review this RFC", "review this design",
  "PM review", "spec review", a GitHub issue/PR link containing a spec body,
  a Google Doc design doc link, or a pasted spec.

  Use when user: asks for a structured review of an engineering proposal
  before Define/build; needs to surface cross-product dependencies or
  hidden deferrals; wants to validate problem framing, scope, and edge
  states before committing to implementation; or wants a second opinion
  on a colleague's spec.
---

# Review an Engineering Spec

Review a work-in-progress engineering spec, design doc, or RFC. Make implicit things explicit, surface forks rather than block momentum, apply a PM/architect lens — *not* gatekeep ship-readiness.

The bar is not "is this complete." The bar is: **are we solving the right problem, in roughly the right way, with the right things made visible to the team?**

## When to use

- The user posts a link to a spec (GitHub issue/PR, Google Doc, Figma, etc.) or pastes spec text and asks for a review.
- A colleague has shared a design doc and the user wants a structured second opinion before signing off.
- A spec is approaching a phase gate (e.g. Discovery → Define) and the author wants pre-gate scrutiny.

## What this skill does NOT do

- Does **not** write files to the working directory. Output is posted in the conversation. The user routes it (GitHub comment, Slack, save to a doc).
- Does **not** maintain cross-spec memory. If you want accumulating per-epic memory across reviews, see the PM toolkit version of this skill in [camunda/camunda-ai-pm-toolkit](https://github.com/camunda/camunda-ai-pm-toolkit).
- Does **not** auto-post the review anywhere — the user decides where it goes.

## Input

The skill accepts:

- A GitHub issue or PR link (read via the `github` MCP / `gh`)
- A Google Doc link (read via the Google Drive MCP, if configured)
- A Figma link (read via the Figma MCP, if configured)
- A file path
- Pasted spec content

If nothing is provided, ask: *"What spec would you like reviewed? Paste a link, path, or the spec content."*

If the source can't be fetched, ask the user to paste it.

## Workflow

### 1. Read the spec

Fetch the full content. Read fully before reviewing — skimming produces shallow reviews.

### 2. Gather context (conditional)

Only read sources that the spec actually touches. Don't dump findings; use context to inform the review and cite where relevant.

| Source | Read when |
|---|---|
| `camunda/product-hub` issues | Related epics, engineering comments on prior decisions/constraints (via `github` MCP) |
| `camunda/camunda-hub` PRs/issues | Implementation already in flight, parallel work |
| `camunda/product-development/strategy/` | Spec touches a strategic bet or cross-domain coherence is in question |
| `camunda/product-development/research/personas/` | Spec names personas or makes behavioral claims about users |
| Camunda Docs (via `camunda-docs` MCP) | Current product state — what already ships, terminology, behavior reference |
| Asana (Hub board), Google Drive, Figma, Company Handbook | Optional — read only if the corresponding MCP is configured and the spec calls for it |

### 3. Confirm framing (only if needed)

Ask only what you genuinely need answered. Skip any dimension that's obvious from the spec or context. If multiple are unclear, ask them together in one short message.

Candidate questions:
- **Origin**: Where did this work originate? (Field-driven ask, PM-identified, bug, internal eng need.) Framing should match: field-driven asks need evidence of breadth, PM-identified needs a strategic thesis, bugs should explain why this one now.
- **Ambition**: What's the ambition level? *"Good enough"* vs. *"make-or-break for adoption"* changes the review depth.
- **Focus**: Any specific area to push on, or a general review?

If all are clear, skip step 3 entirely.

### 4. Apply the review lens

Use the mandatory checks every time. Use the menu as a *menu* — pick 3–6 items that genuinely apply. Mentioning all of them is a failure mode; selectivity is the value.

#### Mandatory (every review)

- **Problem framing.** Is the user problem clearly and correctly scoped? Why now? Does the framing match its source (field evidence, strategic thesis, bug priority)?
- **Summary test.** Restate the spec in one paragraph in your own words. If you can't, say so and point to what's muddled.
- **Unstated assumptions.** What's the spec assuming about scale, audience, infrastructure, identity, migration, rollback, licensing, defaults, the median user? Frame as questions.
- **Empty and edge states.** What does the UI/system say when there's nothing to show, or when things break? Specs almost always under-specify this.

#### Menu — pick what applies

**Is this the right thing?**

- **Capability fit — should this exist?** Who is this for, and does enabling it conflict with how we want users to work? *"Why would we allow X from here when the intended path is Y?"* is a valid question.
- **Workflow friction.** For core user actions, count the clicks/screens. Is the action discoverable from where the user already is?
- **JTBD and personas.** What jobs-to-be-done? Which personas? Are any explicitly out of scope or being silently dropped? Does behavior differ by user type, and is that called out?
- **User journey.** Where does the user come from? Where do they go after? What knowledge do they bring in, and is it enough?
- **Investment level.** Is the spec's ambition matched to its level of detail? If not explicit, ask.
- **Cross-product coherence.** Is this consistent with other Camunda work — Web Modeler, Console, Optimize, Operate, Tasklist, Hub? Name specific other epics, owners, or in-flight work — generic *"consider other domains"* isn't enough.
- **Happy path and edge cases.** Both covered? SaaS and Self-Managed aligned, or deliberately different? If different, is the divergence named?
- **Scope discipline.** What's the minimum viable version to learn from? Default to the simplest version that ships value. *It's always harder to remove something we shipped than to add something we didn't.*

**Is it framed well enough for the team to act on?**

- **Buried lede.** Does the spec answer the reader's first question early?
- **Terminology landmines.** Words reused with new meanings, new terms introduced without grounding, overloaded terms (Project, Workspace, package, cluster, scope). See **Camunda terminology** section below.
- **Multi-purpose controls.** Does any UI element or API do more than one thing? Often it's doing two unrelated jobs and surfacing that exposes a real product question.
- **Microcopy.** For any UI string in the spec, would a user understand it cold? Propose replacements, don't only flag.
- **Pattern consistency.** Is this consistent with the rest of the product, or introducing a new pattern? New patterns need a reason.
- **Helper text in context.** Where the UI doesn't explain itself, propose the missing in-context string.
- **Layer separation.** Runtime vs. design-time. Infrastructure vs. product. Governance vs. execution. Blocking vs. informational.
- **Edges, not median.** Regulated/banking customers, Self-Managed users, IDP-only orgs. Concrete edges, not generic *"consider security."*
- **Deferred work, logged.** Deferring is fine. *Unlogged* deferring is the problem. If a deferral isn't captured (what, why safe now, future trigger), surface it.
- **Out-of-box defaults.** Defaults rarely match real org structures. Ask what's customizable beyond them.

### 5. Post the review

Post the review directly in chat as your reply. **Do not write any files to the working directory.** The user decides where the review goes (GitHub comment, Slack, save manually).

Use the priority markers `[Must]` / `[Should]` / `[Nit]` in front of every actionable item. Lead with a **TL;DR** listing the Musts so the reader can triage in 30 seconds. Skip any section that has no content.

#### Output template

```markdown
# Review: [Spec title]
**Source**: [link]
**Lens applied**: [one line — what you covered and what you deliberately skipped]

## TL;DR — Resolve before Define
[List only the Must items, one line each with the one-line reason. If no Musts, write "No blockers." Aim for 3–6 max — more than that means the review is mis-prioritized.]

## Summary
[One paragraph: what this spec proposes, in your own words. If you can't summarize it, say so and point to what's muddled.]

## What's working
[0–4 bullets. Skip the section entirely if nothing genuinely strong.]

## Decision points
[Forks where the spec picked a path. For each: what was chosen, the alternative, the tradeoff, my ranked preference + one-line reason (vote, don't only ask). Skip the section if no clear forks.]

## Findings
[Priority-marked. Include a concrete scenario as an inline sub-bullet when one illustrates the problem. Narrate user mental model in plain language when relevant: "(why is this greyed out? ah, because…)".]
- **[Must] [Short title]** — [the finding, framed as a question when possible]
  - *Scenario:* [specific user path with real names/numbers/timing]
- **[Should] [Short title]** — [the finding]
- **[Nit] [Short title]** — [the finding]

## Empty / edge states
[Specific states the spec under-specifies. Propose the missing copy or behavior. Skip if not relevant.]

## Cross-product impact
[Named other epics, owners, in-flight work. Priority-marked. Skip if nothing relevant.]
- **[Must] [Name + issue/task ID]** — [the dependency or conflict]

## Hidden deferrals
[Things the spec is silently leaving out without logging as future work. Either resolve, or add to the spec's Future Considerations. Format: "[What's deferred] — suggested future trigger." Skip if none.]

## Questions for the author
[3–5 ranked questions that would resolve the most uncertainty. Skip if no open questions.]

## Open for someone else
[Things to delegate explicitly. Format: "[Concern] — for [role/person]." Skip if none.]

## Suggested next steps
[Concrete follow-ups. Skip if none.]
```

End the review with: *"Reply with feedback on this review and I'll refine it."*

## Camunda terminology to check against

Inline reference so the skill doesn't depend on an external file. Flag any of the following in the spec being reviewed:

- Use **"agentic orchestration"** (lowercase) as a category. Capitalize only in proper titles.
- Use **"Business Orchestration Platform (BOP)"** for the architectural vision only, not to describe Camunda today.
- Use **"orchestration layer"** when describing Camunda's current role within the BOP.
- Use **"platform"** when referring to the BOP. Never use "layer" or "architecture" as substitutes.
- **Never** use "workflow tool," "automation platform," or "BPM suite" to describe Camunda. Zeebe can be called a "workflow engine."
- Do not refer to Camunda as "The Orchestration Company."
- Spell out "line of business" and "line-of-business leader" on first use. Abbreviate as LoB only after first use.

## Reviewer discipline

These shape the *voice and method*, not just the content. Apply throughout.

- **Walk through it like a user, in plain language.** When critiquing UX, narrate what a user would think on first encounter. Use parentheses for the internal monologue: *"(why is this greyed out? ah, because these aren't deleted, ok…)"*. If the feature requires the user to learn something to make sense of it, that's a flag.
- **Concrete scenarios, with numbers and named entities.** Edge cases must be specific paths. *"A file deleted today, container deleted in 5 days"* beats *"time-handling could be confusing."*
- **Vote when there's a choice.** State a ranked preference with a one-line reason. *"I vote A or B — A keeps it dumb and simple, B is a bit nicer."* No hedging.
- **Floor-first.** Default to the simplest version that ships value. The bar to add complexity is evidence of need, not anticipation.
- **Try to break it on paper.** If a constraint isn't stated, name a path that violates it and ask. *"Can I save V1, then V2, then V1 again? If yes, is that the intent?"*
- **Probe what controls actually do.** When a UI element or API method's purpose isn't self-evident, ask. Often it's doing two things at once.
- **Suggest, don't only object.** When flagging unclear UI, propose the replacement copy or alternative path. *"I would have a helper text there like: 'When you compare 2 versions this window will list all the changes'."*
- **Name names for cross-product impact.** Specific other epics, owners, issues — not generic *"consider other domains."* If you can't name them, the dependency isn't real.
- **Surface absences, not just critique presence.** *"Where can I see the 'missing parent' flow?"* — the gap is part of the review.
- **Delegate explicitly when you don't have the answer.** *"Design should weigh in on placement."* *"Engineering should confirm whether project-ID rename is feasible."* These are valid review outputs.
- **Frame unstated assumptions as questions.** *"Is this assuming X?"* beats *"This assumes X."*
- **When the spec is solid on a dimension, say so plainly.** Don't pad. Don't invent problems to justify the review.
- **Disengage cleanly once convinced.** If the author addresses a concern in the review thread, mark it resolved and move on.
- **Short and selective beats long and checklist-y.** Selectivity is the value.

## For richer use (cross-spec memory)

If you review many specs over time and want accumulating per-epic memory so the second review of related work flags inconsistencies the first one logged, use the PM toolkit version of this skill from [camunda/camunda-ai-pm-toolkit](https://github.com/camunda/camunda-ai-pm-toolkit). The toolkit version writes an `epic-context/[slug].md` file per epic and a feedback log for periodic skill improvement.
