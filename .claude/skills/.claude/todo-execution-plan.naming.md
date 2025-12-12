# Work Stream: naming

Unblock and complete skill/script naming refactor.

## Usage

**This file is ephemeral context.** The source of truth is the todo files listed below.

As you complete work:
1. Update the source todo.md / todo.d/ files (mark items `[x]`, add notes)
2. Do NOT update this file — it may be deleted/regenerated anytime

## Source Files

**todo.d/ (detailed breakdowns):**
- `~/.claude/skills/.claude/todo.d/2025-12-09-000-skill-and-script-naming-normalization.md`
- `~/.claude/skills/llm-collab-docs/.claude/todo.d/2025-12-03-000-pivot-from-d-to-kb-naming-convention-for-llmd-skill.md`

**todo.md line items:**
- `~/.claude/skills/.claude/todo.md` — "Rename llm.d → llm.kb"
- `~/.claude/skills/llm.d/.claude/todo.md` — "Pivot to .kb naming"

## Blocker

**Decision required:** `llm.kb` or `kb`?

## Scope

| Current | Target |
|---------|--------|
| llm-collab-docs/ | llm-collab/ |
| subtask/ | llm-subtask/ |
| llm.d/ | (decision)/ |
| .d/ convention | .kb/ convention |

Scripts in interim state — see table in todo.d/2025-12-09-000.

## Tasks

1. [ ] Get user decision: `llm.kb` vs `kb`
2. [ ] Rename skill directories
3. [ ] Rename `.d/` → `.kb/` throughout
4. [ ] Finalize script names
5. [ ] Convert docs-session-start → /session-start
6. [ ] Update all internal references
7. [ ] Update must-read-before triggers
8. [ ] Update skeleton templates

## Verification

```bash
grep -rE "(llm-collab-docs|/subtask/|llm\.d|\.d/)" ~/.claude/skills/ --include="*.md" | grep -v todo-execution
```
