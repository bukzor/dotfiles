---
cost-benefit-sweh:
  timebox:
    @value: 0.33
    rationale: |
      Add section with examples to subtask skill. Confusion is fresh in
      working memory - explaining "what was confusing and why" is easy now,
      nearly impossible in 3 weeks. Should take ~20 min.
  benefit-2w:
    @value: 1.5
    rationale: |
      Prevents confusion that happened 3x this session. Will happen again
      for both me and Claude agents. Estimate ~15 min saved per occurrence,
      ~6 occurrences over 2 weeks = 90 min saved.
---

# Document blocking pattern in subtask skill

**Priority:** High
**Complexity:** Low
**Context:** Blocking relationships in todo.md caused confusion; needs clear documentation

## Problem Statement

The blocking/dependency pattern in todo.md is counterintuitive. When A blocks B, the natural instinct is to nest B under A (blocker first), but the correct pattern is to nest A under B (goal first, with prerequisites as children).

This caused repeated confusion during this session.

## Current Situation

The subtask skill documents todo.md and todo.d/ patterns but doesn't explain how to represent blocking/dependency relationships using nesting.

## Proposed Solution

Add clear documentation to subtask skill explaining the blocking pattern:

**Key principle:** Goal is parent, prerequisites/blockers are children.

**Example:**
```markdown
- [ ] make a sandwich
  - [ ] buy bread
```

Not:
```markdown
- [ ] buy bread
  - [ ] make a sandwich
```

**Rationale:** You check off children first (buy bread), then parent (make sandwich). This matches the execution order and completion flow.

## Implementation Steps

1. [ ] Add section to subtask skill documentation
2. [ ] Include clear examples (positive and negative)
3. [ ] Explain the rationale (execution order, completion flow)
4. [ ] Add guidance on when to use nesting vs inline notes

## Open Questions

- Should this go in SKILL.md or references/todo.d-pattern.md?
- Should we show multi-level blocking chains?

## Success Criteria

- [ ] Clear explanation of goal-first nesting pattern
- [ ] Examples showing correct and incorrect usage
- [ ] Rationale documented so pattern makes sense

## Notes

Session evidence: This pattern was explained three times before understanding clicked. Good documentation prevents this confusion for future agents.
