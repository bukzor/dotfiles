---
filename: docs/devlog/YYYY-MM-DD-NNN-slug.md
audience: Future sessions
purpose: Historical record of what happened
---

# devlog/ (The "When")

**Audience:** Future you, future Claude sessions

**Purpose:** Document "what happened" (historical record)

**Must contain:**
- What was attempted
- What worked / what didn't
- Decisions made
- Open questions
- Next session starting point

**Integration with task tracking:** Devlogs document work history. For active task tracking ("what's next"), use the subtask skill.

**File naming:** `YYYY-MM-DD-NNN-slug.md`
- `NNN` - Auto-incrementing 3-digit sequence (000, 001, ...)
- `slug` - Lowercase hyphenated title (e.g., `claude-md-instruction-optimization`)

**Create via:** `llm-collab-devlog "Entry title"`

**devlog/README.md:**
Index of entries organized chronologically and by topic.

**Templates:**
- [skeleton/docs/devlog/YYYY-MM-DD-000-example-entry.md](../../skeleton/docs/devlog/YYYY-MM-DD-000-example-entry.md)
- [skeleton/docs/devlog/README.md](../../skeleton/docs/devlog/README.md) - Index
