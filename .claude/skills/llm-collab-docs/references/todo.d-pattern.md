# Persistent TODOs

Date-based TODO files for cross-session task tracking: `YYYY-MM-DD-NNN-title.md`

## Purpose

Track tasks that span multiple sessions or need detailed planning. Each TODO file contains:
- Problem statement and context
- Proposed solution
- Implementation steps
- Open questions

## When to Use

Create a TODO file when:
- Task needs detailed planning or multiple sessions
- Multiple approaches need evaluation
- Task has dependencies or blockers
- You want to hand off work with full context

## Quick Commands

```bash
# Create new TODO
~/.claude/skills/llm-collab-docs/scripts/new-todo.sh "Task title"

# Set priority
PRIORITY=high ~/.claude/skills/llm-collab-docs/scripts/new-todo.sh "Task title"

# List all TODOs
ls -1t .claude/todo.d/*.md | grep -v README

# Find specific TODO
grep -l "keyword" .claude/todo.d/*.md
```

## Active TODOs

- [2025-11-21-000-rename-project.md](2025-11-21-000-rename-project.md) - Rename project to git-restore-repo
- [2025-11-21-001-guardrails-ambiguous-references.md](2025-11-21-001-guardrails-ambiguous-references.md) - Consider communication guardrails
