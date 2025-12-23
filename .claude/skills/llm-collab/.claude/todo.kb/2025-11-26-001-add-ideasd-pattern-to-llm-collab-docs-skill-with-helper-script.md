---
cost-benefit-sweh:
  timebox:
    @value: 0.5
    rationale: |
      Template already exists (just created). Need helper script (new-idea.sh)
      and SKILL.md documentation. ~30 min work.
  benefit-2w:
    @value: 2.0
    rationale: |
      Prevents "jump into great idea before I forget" context-switching during
      focused work. Just demonstrated: had cost-benefit-sweh idea mid-task,
      spent ~20 min on it immediately. With ideas.kb/, that's <2 min to capture.
      Expect dozens more ideas during hearts project. Each disruption costs
      ~15-20 min. Preventing 6-8 disruptions = 2 SWEh saved.
---

# Add ideas.kb/ pattern to llm-collab-docs skill with helper script

**Priority:** Medium
**Complexity:** Low
**Context:** Like todo.kb/ but for unprioritized ideas

## Problem Statement

No home for unprioritized ideas. They either clutter devlogs, get lost in chat history, or are never captured at all.

## Current Situation

Ideas are scattered or lost. No structured pattern for capturing half-baked thoughts that might become todos later (or might not).

## Proposed Solution

Add `.claude/ideas.kb/YYYY-MM-DD-NNN-title.md` pattern following same structure as todo.kb/:
- Date-based naming with auto-increment
- Template file for consistency
- Helper script: `scripts/new-idea.sh`
- Document lifecycle in SKILL.md

**Ideas lifecycle:**
1. **Promoted** → becomes todo.kb/ entry, then completed
2. **Rejected** → rationale documented in ADR, file deleted
3. **Forgotten** → acceptable; important ideas resurface naturally
4. **Elaborated** → refined over time to aid promotion/rejection decision

## Implementation Steps

1. [x] Create `.claude/ideas.kb/` directory (skeleton has it)
2. [x] Create template file (similar to todo.kb/ template)
3. [x] Create `bin/llm-collab-idea` helper script
   - Auto-increment YYYY-MM-DD-NNN pattern
   - Create from template
   - Support DATE= for backdating
4. [x] Update SKILL.md to document ideas.kb/ pattern and lifecycle
5. [x] Add example idea file for reference (skeleton has it)

## Open Questions

- Should ideas.kb/ template match todo.kb/ template exactly, or simplified?
- Where to document the lifecycle (SKILL.md, ideas.kb/README.md, or both)?

## Success Criteria

- [x] ideas.kb/ directory exists with template
- [x] new-idea.sh script works (creates dated, numbered files)
- [x] SKILL.md documents the pattern
- [x] Clear guidance on when to use ideas.kb/ vs todo.kb/

## Notes

This is separate from devlog. Devlog = what happened. Ideas.d/ = what might happen.
