---
name: create-architecture-decision
description: |
  Create an Architecture Decision Record (ADR) as a Markdown file.
  Triggers on: "write an ADR", "capture this decision", "migrate this doc into an ADR",
  architecture folder, decision records, ADR numbering/renumbering, and requests to
  turn a Google Doc / kickoff note / conversation outcome into a durable decision record.

  Use when user: asks to create or migrate an ADR, records a just-made architectural
  decision, adds a decision to an existing ADR folder (e.g. docs/adrs/),
  or needs to align a draft with the house ADR format.
---

# Create an Architecture Decision Record

Capture a lasting architectural decision as an ADR in a git repository. To be stored in a repository-specific path.

## When to use

- The user asks to write, migrate, or capture an ADR.
- A conversation has produced a concrete architectural decision worth preserving.
- The user points at a source document (Google Doc, kickoff note, Slack thread) and asks for an ADR version.
- The user may provide the location where to put the ADR.

## What belongs in an ADR (and what does not)

An ADR records **fundamental, lasting** architectural choices. Write it so a future engineer, PM, or AI agent can orient in two minutes.

Include:
- The problem being solved and the final outcome.
- The decisions themselves, numbered (`D1`, `D2`, …) so they can be referenced.
- Alternatives considered — but only architectural-level options on the same impact level as the accepted decisions, and only where understanding the alternative materially explains why the decision was taken. Implementation-level variants, rejected-for-scope items, and non-serious contenders do not belong here. If nothing clears this bar, omit the section entirely.
- Consequences that follow — trade-offs accepted, downstream constraints, migration impact.
- A link back to the primary source document.

Exclude (keep out of the ADR; let them live in kickoff docs, epics, code, or release notes):
- Low-impact or implementation-level alternatives (e.g. API payload shape, caching TTLs, module splits) — only architectural alternatives make the cut.
- Customer names and their business data. Never mention a specific customer by name in an ADR, even when a source document does. Generalize to "some customers" / "existing customers" / "customers with workflow X" so the ADR stays durable and neutral.
- Implementation steps, timelines, work breakdowns.
- Status updates, progress reports, open questions.
- Persona tables, migration scripts, UI copy, endpoint paths — unless they _are_ the decision.
- Narration of *how* the decision was reached.

If the decision isn't final, don't write the ADR yet.

## Workflow

Follow these steps in order. Do not skip the review step — this skill's value is in producing tight, high-signal ADRs, which requires the user's judgment before writing.

### 1. Locate and read the source

- If the user points at a Google Doc, fetch its content via the available Drive tools.
- If the user points at a GitHub issue or PR, read it via `gh`.
- If the decision came from conversation only, work from the conversation.

### 2. Propose a review summary

Before drafting any ADR content, post a short review message with:

1. **Title** of the source and a clickable link.
2. **Candidate decisions** — `D1`, `D2`, … phrased as they would appear in the ADR, with one sentence of elaboration each.
3. **Candidate alternatives considered** — architectural-level options that were weighed against the decisions and meet the bar described above, each phrased as it would appear in the ADR with the one- or two-sentence rationale for rejection. If no alternatives in the source clear the bar, say so explicitly and recommend omitting the section. Do the alternatives review as part of this initial pass — do not defer it to a second pass after the ADR is written.
4. **Exclusions** — things in the source you plan to leave out, with a one-line reason (e.g. "persona mapping — operational guidance, likely to evolve"; "customer name X — never mentioned in ADRs, generalized to 'some customers'").
5. **Open questions** for the user — DRI, release status, whether to bundle or split, whether to keep a borderline decision or alternative.

Then wait for the user to respond. Do not start writing the ADR file yet.

### 3. Draft and get approval

Once the user answers the questions, post the full ADR content inline (not as a file write) so they can review structure, wording, and cross-references. Wait for explicit approval ("approve", "sounds good", or an edit instruction).

Only after approval, write the file.

### 4. Write the file

- Directory: The user-provided ADR location. If not known, prompt the user to specify it.
- Filename: `NNNN-VVV-title.md`.
  - `NNNN` — zero-padded, globally increasing sequence in that component's folder.
  - `VVV` — the release the decision was accepted in, without the dot (`89` for 8.9, `810` for 8.10).
  - `title` — short, lowercase, hyphen-separated, reflecting the decision (not the doc title).
  - 8.X ADRs come before 8.(X+1) ADRs in the sequence. Earlier releases use lower numbers.
- If the new ADR needs to slot in before existing ones of a later release, renumber the later ones upward. Update cross-references in renumbered files **before** renaming. Rename from highest number to lowest to avoid collisions.

### 5. Update cross-references and the README

- If the new ADR relates to existing ADRs (supersedes, depends on, extends, constrains), cross-link in both directions using relative paths.
- Add a row to the location's `README.md` table (if exists) under the correct release section. Match the one-line summary style used for existing rows.

## ADR structure

Every ADR file follows this structure. Match it exactly — readers and tooling rely on the shape.

```markdown
# <Short title — states the decision, not the topic>

**DRI**: <Name of the decision-responsible individual>

**Status**: Accepted (<release>)   <!-- e.g. Accepted (8.10) -->

**Purpose**: <One sentence: what this ADR defines for the reader.>

**Audience**: <Who should read this — specific roles/teams, not "everyone".>

## Context

<Describe the problem and its final outcome. Keep it to 1–3 short paragraphs. Do NOT narrate the process of getting to the decision. If one ruled-out alternative is essential context, mention it in a single sentence; otherwise leave alternatives out.>

## Decision

**D1. <Decision, phrased as a short declarative headline.>**
<One short paragraph elaborating the decision — just enough that a reader understands what is being committed to.>

**D2. <Next decision.>**
<Elaboration.>

<!-- Add D3, D4, … as needed. Only include decisions that are architectural and lasting. Implementation details go elsewhere. -->

## Alternatives considered

<!--
Optional. Include this section only when there are architectural-level alternatives on the same impact level as the accepted decisions AND understanding them materially explains why the decisions were taken. Omit the section entirely otherwise — do not add placeholder bullets.
-->

- **<Alternative, phrased as a short headline.>** <One or two sentences: what the alternative is and why it was rejected. Be concrete about the trade-off that tipped the decision.>
- **<Next alternative.>** <Same shape.>

## Consequences

- <Trade-off, downstream constraint, migration impact, or capability unlocked.>
- <One bullet per consequence. Bullets are short.>

## Source

- [<Source doc title>](<url>) (internal)
- <Additional references: kickoff docs, epics, related external standards.>
```

## House style

- **Context**: problem + outcome. No process narration. No "we considered X, Y, Z and chose Y because…" — that belongs in Alternatives considered.
- **Decisions**: headline in bold with `D<n>.` prefix. Body is one short paragraph at most. The body should describe the decision, not the reasoning for choosing it over alternatives — that reasoning belongs in Alternatives considered.
- **Alternatives considered**: each bullet is a short bold headline plus one or two sentences of rejection rationale. Keep the focus on the architectural trade-off that tipped the decision; do not catalogue every variant the source discussed.
- **No customer names.** Never reference a specific customer by name, even when the source does. Generalize to "some customers", "existing Console SM customers", "customers with a git-based workflow", etc. This applies to Context, Decisions, Alternatives considered, Consequences, and Sources alike.
- **One ADR per coherent decision bundle.** If two decisions always travel together (e.g. "use a monorepo" and "with Turborepo"), bundle them. If they can stand independently, split them.
- **Cross-reference, don't duplicate.** If another ADR covers a related decision, link to it rather than restating.
- **Markdown links for sources.** Google Docs, GitHub issues, external specs. Mark internal-only links with `(internal)`.
- **No emojis.** Not in titles, not in bullets.
- **Concise.** A typical ADR is 20–60 lines excluding Sources. If it is longer, the Context or Decision sections probably contain implementation detail that should move out.

## Examples in this repo

In the [Camunda-Hub repo](https://github.com/camunda/camunda-hub/), see `docs/adrs/` for accepted ADRs covering a range of decision shapes:

- Single-decision ADR with tight trade-off framing: `0001-89-remove-webapp-component.md`.
- Multi-decision ADR with numbered `D1..D6`: `0002-89-cluster-apis-proxied-through-hub-backend.md`.
- ADR that cross-references a related ADR in both Context and Consequences: `0008-810-hub-catalog-asset-definition.md` ↔ `0009-810-hub-catalog-submitted-from-customer-source-via-api.md`.
- ADR where a borderline alternative was explicitly excluded to keep focus on the user-visible decision: `0012-810-unified-navigation-across-hub-and-oc-apps.md`.

## Decision-framing checklist

Before writing, confirm each:

- [ ] The decision is final, not under active debate.
- [ ] The DRI is named and known to own this decision.
- [ ] The release is committed (use `Accepted (<release>)` status).
- [ ] The Context describes problem + outcome only.
- [ ] Each `D<n>` is an architectural decision, not an implementation step.
- [ ] Alternatives considered were evaluated in the same pass as the decisions (not deferred to a later review), and the section is included only when at least one alternative meets the impact bar — otherwise omitted entirely.
- [ ] No customer is named anywhere in the ADR; customer-specific workflows and data are generalized.
- [ ] Consequences call out at least one trade-off the decision accepts.
- [ ] Source links are present and point at the authoritative documents.
- [ ] Related ADRs are cross-linked both ways.
- [ ] The component's `README.md` has a new row with a one-line summary.
