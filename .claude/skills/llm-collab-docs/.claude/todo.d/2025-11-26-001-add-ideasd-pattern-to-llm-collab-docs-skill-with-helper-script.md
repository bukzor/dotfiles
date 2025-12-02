# Add ideas.d/ pattern to llm-collab-docs skill with helper script

**Priority:** Medium
**Complexity:** Low
**Context:** Like todo.d/ but for unprioritized ideas

## Problem Statement

No home for unprioritized ideas. They either clutter devlogs, get lost in chat history, or are never captured at all.

## Current Situation

Ideas are scattered or lost. No structured pattern for capturing half-baked thoughts that might become todos later (or might not).

## Proposed Solution

Add `.claude/ideas.d/YYYY-MM-DD-NNN-title.md` pattern following same structure as todo.d/:
- Date-based naming with auto-increment
- Template file for consistency
- Helper script: `scripts/new-idea.sh`
- Document lifecycle in SKILL.md

**Ideas lifecycle:**
1. **Promoted** → becomes todo.d/ entry, then completed
2. **Rejected** → rationale documented in ADR, file deleted
3. **Forgotten** → acceptable; important ideas resurface naturally
4. **Elaborated** → refined over time to aid promotion/rejection decision

## Implementation Steps

1. [ ] Create `.claude/ideas.d/` directory
2. [ ] Create template file (similar to todo.d/ template)
3. [ ] Create `scripts/new-idea.sh` helper script
   - Auto-increment YYYY-MM-DD-NNN pattern
   - Create from template
   - Support DATE= for backdating
4. [ ] Update SKILL.md to document ideas.d/ pattern and lifecycle
5. [ ] Add example idea file for reference

## Open Questions

- Should ideas.d/ template match todo.d/ template exactly, or simplified?
- Where to document the lifecycle (SKILL.md, ideas.d/README.md, or both)?

## Success Criteria

- [ ] ideas.d/ directory exists with template
- [ ] new-idea.sh script works (creates dated, numbered files)
- [ ] SKILL.md documents the pattern
- [ ] Clear guidance on when to use ideas.d/ vs todo.d/

## Notes

This is separate from devlog. Devlog = what happened. Ideas.d/ = what might happen.
