# Work Stream: wins

Quick, low-effort improvements with immediate value.

## Usage

**This file is ephemeral context.** The source of truth is the todo files listed below.

As you complete work:
1. Update the source todo.md / todo.d/ files (mark items `[x]`, add notes)
2. Do NOT update this file — it may be deleted/regenerated anytime

## Source Files

**todo.d/ (detailed breakdowns):**
- `~/.claude/skills/llm-collab-docs/.claude/todo.d/2025-11-26-002-update-devlog-template-to-remove-task-management-pure-history--idea-capture-to-ideasd.md`

**todo.md line items:**
- `~/.claude/skills/.claude/todo.md` — "Refine load triggers for llm.d and subtask skills"
- `~/.claude/skills/llm-collab-docs/.claude/todo.md` — "Replace heredocs in bin/ scripts with skeleton/ copies"

## Tasks

### 1. Remove "Next Session" from devlog template (5min)
- Edit `skeleton/docs/devlog/YYYY-MM-DD.md`
- Remove "Next Session" section
- Redundant with .claude/todo.md from subtask skill

### 2. Refine skill load triggers
- Audit current triggers in must-read-before.d/
- Identify why llm.d and subtask don't load reliably
- Fix trigger conditions

### 3. Replace heredocs with skeleton/ copies
Sub-items from todo.md:
- [ ] init-docs: CLAUDE.md heredoc → skeleton/CLAUDE.md
- [ ] init-docs: docs/dev/ structure
- [ ] Scan for other heredocs that should use skeleton/

## Verification

```bash
# Check devlog template
grep -A5 "Next Session" ~/.claude/skills/llm-collab-docs/skeleton/docs/devlog/*.md

# Check for heredocs in bin/
grep -l "<<" ~/.claude/skills/*/bin/*
```
