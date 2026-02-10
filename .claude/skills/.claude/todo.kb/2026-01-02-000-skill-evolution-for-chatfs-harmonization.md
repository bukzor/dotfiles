<anthropic-skill-ownership llm-subtask />

---
requested-by: ~/repo/github.com/bukzor/prototype.chatfs/.claude/todo.kb/2026-01-02-000-harmonize-with-llm-skills.md
---

# Skill Evolution for chatfs Harmonization

**Priority:** High
**Complexity:** Low
**Context:** Unblocks prototype.chatfs harmonization with llm-* skill conventions

## Problem Statement

prototype.chatfs wants to adopt llm-* skill conventions, but the skills themselves have incomplete evolution:
- llm.kb: `.d → .kb` rename partial (complete-example still uses `.d/`)
- llm-collab: skeleton needs `milestones.kb/` and `design.kb/` patterns

## Subtasks

**Recommended order:** llm-collab first (makes llm.kb rename patterns clearer)

1. [ ] [llm-collab: Update skeleton](../llm-collab/.claude/todo.kb/2025-12-11-000-update-skeleton-to-match-docsdev-pattern-from-git-partial.md)
2. [ ] [llm.kb: Complete .d → .kb rename](../llm.kb/.claude/todo.kb/2026-01-02-000-complete-d-to-kb-rename.md)

## Verification

```bash
# llm.kb: No .d/ directories in complete-example
ls -d ~/.claude/skills/llm.kb/complete-example/*.d/ 2>/dev/null && echo "INCOMPLETE" || echo "DONE"

# llm.kb: ADR status updated to Accepted
grep -A1 "^## Status" ~/.claude/skills/llm.kb/docs/adr/2025-12-03-000-*.md
```

## On Completion

Notify upstream: prototype.chatfs can proceed with Phase 2 of harmonization.
