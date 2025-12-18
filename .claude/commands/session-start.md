--- # workaround: anthropics/claude-code#13003
depends:
  - skills/llm-collab
---

# Session Start

Orient to the current project by reading key context files.

## Workflow

1. Bash(date -Is)
2. **List pending TODOs** from `.claude/todo.d/`:
   - Show title and filename for each
   - Sort by date (most recent first)
3. **Read latest devlog** from `docs/dev/devlog/` (skip README)
4. **List recent ADRs** from `docs/dev/adr/`:
   - Show 3 most recent (by filename date)
   - Title and filename only

## Output Format

Use clear section headers. Be concise — this is orientation, not deep analysis.
