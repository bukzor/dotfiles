# Four-Tier Task Decomposition System

Work decomposition operates at four granularities, each optimized for different scopes and persistence needs.

## Tier 0: Conversational Preemption

**Pattern:** When user asks a question, finish answering before resuming previous work. If answer rejected, question remains top-of-stack until resolved.

**Scope:** Single conversational exchange

**Persistence:** None (control flow only)

**Example:**
```
User: "How do I rotate a PDF?"
Assistant: [answers]
User: "That doesn't work"
Assistant: [doesn't resume previous work, keeps working on PDF rotation until resolved]
```

**Implementation:** Behavioral pattern, not a tool or command.

## Tier 1: Ephemeral Subtasks

**Pattern:** Session work tracked in conversation context via marker commands.

**Scope:** Single conversation

**Persistence:** Conversation history (lost when conversation ends)

**Commands:**
- `subtask list:` - Agent enumerates pending work from context
- `subtask prepend: DESC` - Shift priority to new work stream
- `subtask push: DESC` - Add subtask to working memory
- `subtask pop:` - Complete current subtask

**Example:**
```
User: "Refactor the auth module"
Assistant: [recognizes multi-step work]
subtask push: Extract authentication logic
subtask push: Create new auth service class
subtask push: Update imports
subtask push: Run tests

[works on first item]
subtask pop:
[works on second item]
```

**When conversation ends:** Important incomplete items promoted via `todo push:` to tactical tier.

## Tier 2: Tactical Todos

**Pattern:** Cross-conversation checkboxes in `.claude/todo.md`.

**Scope:** Multiple conversations, same session/day/sprint

**Persistence:** Git-controlled file with markdown checkboxes

**Format:**
```markdown
- [ ] Refactor session-start.sh
- [ ] Update SKILL.md references
- [x] Fix type errors
```

**Commands:**
- `todo push: DESC` - Append `- [ ] DESC`
- `todo pop:` - Mark first `[ ]` as `[x]`
- `todo list:` - Display file contents
- `todo clear:` - Remove completed `[x]` items

**Session start:** `subtask load:` reads this file and enumerates pending items.

**Session end:** `subtask save:` promotes incomplete ephemeral items here.

**Characteristics:**
- One-line descriptions
- Fast to scan
- User-editable (direct vim access)
- Zero-token overhead (markers processed during file read)

## Tier 3: Strategic Todos

**Pattern:** Planning files in `.claude/todo.d/YYYY-MM-DD-NNN-title.md`.

**Scope:** Cross-session, needs planning/design

**Persistence:** Git-controlled markdown files with full context

**Format:**
```
.claude/todo.d/
├── 2025-11-25-000-create-subtask-skill.md
└── 2025-11-25-001-fix-authentication-bug.md
```

**Creation:** `~/.claude/skills/llm-subtask/bin/llm-subtask-todo "Task title"`

**File structure:** Each file contains:
- Problem statement and context
- Proposed solution(s)
- Implementation steps
- Open questions
- Dependencies/blockers

**When to use:**
- Task needs detailed planning
- Multiple approaches need evaluation
- Dependencies or blockers exist
- Handing off work with full context to future session

**Discovery:** `ls -t .claude/todo.d/` shows chronologically, `grep -l "keyword" .claude/todo.d/*.md` finds specific items.

## Tier Selection Guide

| Need | Tier | Tool |
|------|------|------|
| Answer question before resuming | 0: Conversational | Pattern |
| Track work in current conversation | 1: Ephemeral | `subtask push:`/`pop:` |
| Remember across conversations | 2: Tactical | `todo push:` |
| Plan complex multi-session work | 3: Strategic | `bin/llm-subtask-todo` |

## Promotion Flow

Work naturally flows from fine → coarse grain as importance/complexity increases:

1. **Ephemeral work** during conversation
2. Conversation ending? Important items → `todo push:` (tactical)
3. Tactical item needs planning? → `bin/llm-subtask-todo` (strategic)

Demotion also occurs:
- Strategic planning complete → decompose to tactical checkboxes
- Tactical checkbox active → ephemeral subtasks during execution

## Design Rationale

**Why four tiers?**

Each tier optimizes for different constraints:
- **Conversational:** Zero overhead, pure control flow
- **Ephemeral:** Fast manipulation, no filesystem I/O
- **Tactical:** Persistent but lightweight, quick scanning
- **Strategic:** Full context, supports complex planning

Collapsing tiers would compromise these optimizations. Unified interface (`subtask`/`todo` commands) provides coherence while preserving tier-specific benefits.
