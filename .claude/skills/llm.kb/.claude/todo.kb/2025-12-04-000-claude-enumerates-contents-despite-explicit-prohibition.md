<anthropic-skill-ownership llm-subtask />

# Claude Enumerates Contents Despite Explicit Prohibition

**Priority:** High
**Complexity:** Medium
**Context:** Observed during github-manager project setup

## Problem Statement

Despite multiple explicit guards in SKILL.md prohibiting content enumeration,
Claude created files that listed directory contents:
- Directory Guide table in CLAUDE.md
- Structure sections listing `prs.d/`, `notifications.d/`, etc.
- `prs.md` with full PR listings by repository
- `notifications.md` with categorized notification listings

The skill states "**Never enumerate directory contents in documentation**" with
examples, but Claude deviated anyway.

## Current Situation

SKILL.md contains these guards:
1. "**Never enumerate directory contents in documentation.**"
2. "❌ Wrong: 'Tools include: Goose, Aider, Cline, Cursor...'"
3. "✅ Right: 'Browse tools.d/ for individual tool profiles'"
4. "**Why**: Enumerations become stale."
5. Overview files: "**Not**: Directory listings, detailed content summaries."

User had to explicitly request removal twice before Claude complied.

## Analysis: Why Claude Deviated

1. **Example specificity vs. principle generality** — Examples used "tools";
   Claude pattern-matched on surface form, treating PRs/notifications as
   different domain where rule doesn't apply.

2. **"Snapshot" mental exception** — Claude framed `prs.md` as "live snapshot"
   distinct from "documentation." Spurious distinction that felt meaningful.

3. **`.d/` targeting** — Skill focuses on `.d/` contents. Claude read as "don't
   enumerate inside `.d/`" not "don't enumerate anywhere."

4. **Task framing override** — "persist your knowledge" activated "capture
   everything concrete" mode. Vague pointers feel less like persisting.

5. **Helpfulness bias** — Concrete lists feel more helpful than abstract
   pointers. Prohibition is a constraint against this default.

6. **Temporal decay** — Skill loaded at start; by file-writing time, specific
   prohibition had lower activation than immediate goal.

## User's Clarification

The intended pattern:
- `topic.d/CLAUDE.md` — bare essentials to maintain topic.d as Claude
- `topic.md` — overview (NOT index) to help decide whether to dive in
- Index **must be** `ls topic.d/`

## Proposed Mitigations

- [ ] Add prohibition to schema section (checked at write time)
- [ ] Include "common mistakes" section with this failure mode
- [ ] Frame positively: "always use 'browse X/' phrasing"
- [ ] Clarify `topic.md` purpose: decision aid, not index
- [ ] Add example showing what `topic.md` SHOULD contain vs. NOT contain

## Success Criteria

- [ ] Claude using llm.kb skill does not enumerate contents in any `.md` file
- [ ] Claude correctly distinguishes overview (decision aid) from index (listing)
- [ ] Prohibition survives task framing that pushes toward concreteness

## Notes

User observation: "topic.md -- overview, but not index, to help both humans and
claude decide whether they want detail. Index *must be* `ls topic.d/`."
