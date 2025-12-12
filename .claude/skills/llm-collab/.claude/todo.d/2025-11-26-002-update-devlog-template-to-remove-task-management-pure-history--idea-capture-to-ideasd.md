---
cost-benefit-sweh:
  timebox:
    @value: 0.08
    rationale: |
      Delete "Next Session" section from template (4 lines). Trivial change.
  benefit-2w:
    @value: 0.5
    rationale: |
      Removes duplication with .claude/todo.md from subtask skill. Each new
      devlog session saves ~5 min of "wait, do I update both?" confusion.
      ~6 sessions over 2 weeks = 30 min saved.
---

# Update devlog template to remove task management redundancy

**Priority:** Medium
**Complexity:** Low
**Context:** subtask skill handles task tracking; devlog should avoid time-wasting redundancy

## Problem Statement

Devlog template (skeleton/docs/devlog/YYYY-MM-DD.md) has "Next Session" section that duplicates `.claude/todo.md` purpose from subtask skill. This creates time-wasting redundancy.

## Current Situation

Template includes:
- Focus (goal for session)
- Completed/Attempted/Discovered
- Decisions Made
- Open Questions
- **Next Session** (with "Start here" and "Blockers") ← REDUNDANT
- Links

## Proposed Solution

Remove "Next Session" section from `skeleton/docs/devlog/YYYY-MM-DD.md`. Task tracking lives in `.claude/todo.md` (subtask skill), not devlog.

**Note:** Broader devlog reevaluation is a separate strategic todo (see todo.d/2025-11-29-000).

## Implementation Steps

1. [x] Edit `skeleton/docs/devlog/YYYY-MM-DD.md`
2. [x] Remove "Next Session" section (lines 33-36)
3. [x] Verify template still makes sense without it

## Open Questions

None. This is a tactical fix, not strategic reevaluation.

## Success Criteria

- [x] "Next Session" section removed from template
- [x] No time-wasting duplication with .claude/todo.md

## Notes

User doesn't love current devlog sections overall, but complete reevaluation is separate work (todo.d/2025-11-29-000). This task is just the immediate redundancy fix.
