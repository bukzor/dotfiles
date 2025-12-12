# Work Stream: docfix

Fix documentation gaps causing repeated confusion.

## Usage

**This file is ephemeral context.** The source of truth is the todo files listed below.

As you complete work:
1. Update the source todo.md / todo.d/ files (mark items `[x]`, add notes)
2. Do NOT update this file — it may be deleted/regenerated anytime

## Source Files

**todo.d/ (detailed breakdowns):**
- `~/.claude/skills/llm-collab-docs/.claude/todo.d/2025-11-29-001-document-blocking-pattern-in-subtask-skill.md`
- `~/.claude/skills/llm.d/.claude/todo.d/2025-12-04-000-claude-enumerates-contents-despite-explicit-prohibition.md`
- `~/.claude/skills/.claude/todo.d/2025-12-04-000-document-cost-saving-techniques-for-bulk-operations-sed-vs-haiku-task-vs-direct-edits.md`
- `~/.claude/skills/llm-collab-docs/.claude/todo.d/2025-11-26-001-add-ideasd-pattern-to-llm-collab-docs-skill-with-helper-script.md`

**todo.md line items:**
- (none — all items have todo.d/ breakdowns)

## Tasks

### 1. Document blocking pattern (High, 20min)
Add to subtask skill:
- Goal-first nesting principle
- Concrete examples (correct/incorrect)
- Rationale: children complete before parent

### 2. Fix enumeration prohibition (High)
Strengthen llm.d guards:
- Add to schema validation (write-time check)
- Add "common mistakes" section
- Clarify: `topic.md` = decision aid, not index

### 3. Cost-saving bulk ops doc (Medium)
Add to must-read-before.d:
- Decision matrix: 1-3 files (Edit), 4-10 (haiku Task), 10+ mechanical (sed)
- When each approach is appropriate
- Examples from real usage

### 4. ideas.d/ pattern (Medium, 30min)
Add to llm-collab-docs:
- `.claude/ideas.d/` directory structure
- Helper script
- Lifecycle: promoted → rejected → forgotten → elaborated

## Verification

After each task, check the source todo.d/ file and mark complete.
