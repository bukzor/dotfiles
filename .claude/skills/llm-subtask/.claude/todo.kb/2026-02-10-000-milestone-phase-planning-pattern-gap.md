# Milestone/Phase Planning Pattern Gap

**Priority:** Low
**Complexity:** Medium (design discussion)
**Context:** Emerged from llm-collab stale path cleanup

## Problem Statement

llm-collab removed static templates for `development-plan.md` and `docs/milestones/`. These covered:
- Numbered project phases with clear deliverables
- Dependencies between phases
- Success criteria per milestone
- Status tracking (Not Started / In Progress / Blocked / Complete)

The new design.kb pattern covers *design knowledge* well but doesn't address *project planning*.

## Current Situation

llm-subtask has:
- `todo.md` — tactical checkboxes
- `todo.kb/` — strategic task breakdowns

Neither explicitly supports milestone/phase structure:
- Phases as time-ordered planning units
- Phase dependencies ("Phase 2 requires Phase 1 complete")
- Phase-level success criteria distinct from individual task completion

## Open Questions

1. **Is this a real gap?** Were milestones actually used in practice, or were they stale templates nobody touched?

2. **If real, where should it live?**
   - llm-subtask (extends task system upward to phases)
   - llm-collab (project-level planning documentation)
   - Separate skill (project-management focused)

3. **What's the minimal viable pattern?**
   - Just a naming convention in todo.kb/ (e.g., `PHASE-01-*.md`)?
   - Dedicated `phases.kb/` directory?
   - Frontmatter schema with `phase:` and `depends-on-phase:`?

4. **Integration with design.kb?**
   - 030-requirements.kb/ could serve as phase acceptance criteria
   - Or requirements are orthogonal to phases (what vs when)

## Discussion Invited

This is exploratory. If you have opinions or experience with milestone planning in LLM-assisted workflows, please contribute.

## Related

- llm-collab's removed `skeleton/docs/dev/development-plan.md`
- llm-collab's removed `skeleton/docs/milestones/`
- llm-collab's todo.kb/2026-02-09-001 (stale path cleanup — surfaced this gap)
