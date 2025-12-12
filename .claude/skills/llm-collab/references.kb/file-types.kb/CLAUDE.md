--- # workaround: anthropics/claude-code#13003
filename: CLAUDE.md
audience: LLMs
purpose: Quick-ref, current focus, architecture
---

# CLAUDE.md (LLM-Facing)

**Audience:** Claude (or other LLM development assistant)

**Purpose:** "How to work on this project" (architecture, conventions, common tasks)

**Critical requirements:**
- **Front-loads most important info** (common tasks, quick ref)
- **Terse summaries with links** for deep dives
- **Never just links** (always include 1-2 sentence summary before link)
- **References .claude/todo.md** for current tasks (don't duplicate)

**Must contain:**
1. **Quick Reference** - Most common development tasks
2. **Current State Reference** - Link to .claude/todo.md (don't duplicate tasks)
3. **Architecture** - Terse overview with links
4. **Data Flow** - How information moves through the system
5. **Key Files** - Where to find critical code/config

**Should contain:**
- Links to .claude/todo.md, latest devlog entry
- Common gotchas or constraints
- Testing shortcuts
- Conventions (naming, style)

**Should NOT contain:**
- Full duplication of other docs (use summaries + links)
- Historical information (that's devlog)
- Exhaustive details (link to docs/dev/)

**Template:** See [skeleton/CLAUDE.md](../../skeleton/CLAUDE.md)
