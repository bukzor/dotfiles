# Clarify the relationship between todo.md and todo.d in subtask skill

**Priority:** Medium
**Complexity:** Low
**Context:** llm-collab-docs demonstrates the pattern in `.claude/todo.md`

## Problem Statement

The subtask skill documentation doesn't clearly explain how todo.md and todo.d/ work together. They're complementary but docs treat them separately.

## Current Situation

Subtask skill has:
- Tier 2 (tactical): `.claude/todo.md` with markdown checkboxes
- Tier 3 (strategic): `.claude/todo.d/YYYY-MM-DD-NNN-title.md` planning files

But it doesn't show how they integrate in practice.

## Proposed Solution

Add section showing how strategic todos are referenced from todo.md using relative paths.

**Example pattern from llm-collab-docs `.claude/todo.md`:**
```markdown
- [ ] todo.d/2025-11-26-000-destructure-must-read-beforedcreating-documentationmd-into-referencesd-llmd-structure.md
  - [ ] Finalize references.kb/ categorization structure
  - [ ] Split content into small focused files
```

Key points:
- todo.md contains tactical tasks (inline text) AND strategic references (paths to todo.d/*.md)
- Checkbox sub-bullets are subtasks that contribute to parent
- Non-checkbox sub-bullets provide clarifying context

## Implementation Steps

1. [ ] Add "Integration: todo.md + todo.d/" section to subtask/SKILL.md
2. [ ] Show example snippet from llm-collab-docs
3. [ ] Explain checkbox vs non-checkbox sub-bullets

## Success Criteria

- [ ] Relationship between todo.md and todo.d/ is documented
- [ ] Example demonstrates the pattern
- [ ] Stays terse (subtask skill style)

## Notes

llm-collab-docs `.claude/todo.md` serves as reference implementation.
