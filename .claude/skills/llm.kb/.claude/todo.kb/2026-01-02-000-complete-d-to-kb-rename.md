<anthropic-skill-ownership llm-subtask />

---
required-reading:
  - ~/.claude/skills/llm.kb/docs/adr/2025-12-03-000-pivot-from-d-to-kb-naming-convention.md
  - ~/.claude/skills/llm.kb/SKILL.md
suggested-reading:
  - ~/.claude/skills/llm.kb/references/pattern-guide.md
related-effort: ~/repo/github.com/bukzor/prototype.chatfs/.claude/todo.kb/2026-01-02-000-harmonize-with-llm-skills.md
---

# Complete .d → .kb Rename in llm.kb

**Priority:** High
**Complexity:** Low
**Context:** Part of prototype.chatfs harmonization effort

## Problem Statement

The `.d → .kb` naming convention pivot (ADR 2025-12-03-000) is partially implemented:
- Done: `todo.kb/`, `ideas.kb/`, `references.kb/`
- Not done: `complete-example/` still uses `.d/` (guests.d/, food.d/, etc.)
- Not done: docs/references still reference `.d/`
- ADR status still "Proposed" (should be "Accepted")

## Current Situation

```
complete-example/
├── guests.d/      ← needs rename to guests.kb/
├── food.d/        ← needs rename to food.kb/
│   └── cake.d/    ← needs rename to cake.kb/
├── games.d/       ← needs rename to games.kb/
├── decorations.d/ ← needs rename to decorations.kb/
└── timeline.d/    ← needs rename to timeline.kb/
```

Docs referencing `.d/`:
- references/pattern-guide.md
- references/splitting-large-docs.md
- references/complete-example.md
- docs/documentation-conventions.md

## Implementation Steps

- [ ] Rename complete-example directories: `*.d/ → *.kb/`
- [ ] Update complete-example/*.md files (references to .d/)
- [ ] Update complete-example/*.jsonschema.yaml (descriptions)
- [ ] Update complete-example/CLAUDE.md
- [ ] Update references/pattern-guide.md
- [ ] Update references/splitting-large-docs.md
- [ ] Update references/complete-example.md
- [ ] Update docs/documentation-conventions.md
- [ ] Mark ADR 2025-12-03-000 as Accepted
- [ ] Verify: `grep -r '\.d/' .` shows only acceptable uses (CLAUDE.d/ pattern is separate)

## Success Criteria

- [ ] No `.d/` directories in complete-example/
- [ ] All docs reference `.kb/` pattern
- [ ] ADR status is "Accepted"
- [ ] SKILL.md examples use `.kb/`
