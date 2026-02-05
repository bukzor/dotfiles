---
filename: docs/devlog/YYYY-MM-DD-NNN-slug.md
audience: Future sessions
purpose: Capture reasoning, principles, and conventions that diffs can't
---

# devlog/ (The "When")

**Audience:** Future you, future Claude sessions

**Purpose:** Capture what diffs can't — reasoning, principles, conventions

**Must contain:**
- Decisions and their rationale (especially rejected alternatives)
- Conventions established and principles discovered
- Tradeoffs that shaped the approach

**Integration with task tracking:** Devlogs document work history. For active task tracking ("what's next"), use the subtask skill.

**File naming:** `YYYY-MM-DD-NNN-slug.md`
- `NNN` - Auto-incrementing 3-digit sequence (000, 001, ...)
- `slug` - Lowercase hyphenated title (e.g., `claude-md-instruction-optimization`)

**Create via:** `llm-collab-devlog "Entry title"`

**Templates:**
- [skeleton/docs/devlog/YYYY-MM-DD-000-example-entry.md](../../skeleton/docs/devlog/YYYY-MM-DD-000-example-entry.md)
- [skeleton/docs/devlog/CLAUDE.md](../../skeleton/docs/devlog/CLAUDE.md) - Directory guide
