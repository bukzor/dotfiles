# LLM Document Consumption Patterns

## Session Coordination

**Problem:** Agent picks up mid-project, doesn't know context.

**Solutions:**

**Option A: Session start script**
- Run script that reads key files
- Display context at session start
- **Helper available:** `scripts/session-start.sh`

**Option B: Manual reading** (recommended)
- Agent reads CLAUDE.md for orientation
- Check latest devlog for "Next Session" handoff
- Load `subtask` skill for task management if needed
- Follows links to ADRs, architecture docs as needed
- No script dependencies

**Option C: Prompt the agent**
- User says "Read the docs to orient yourself"
- Agent finds what it needs
- Most flexible

**Choose based on:** Preference for scripts vs manual flow.

## First Session on Project

Read in order:
1. `CLAUDE.md` - Quick reference, architecture overview
2. `.claude/todo.md` - Current tasks and priorities
3. `docs/dev/devlog/YYYY-MM-DD.md` - Last session details
4. Task-specific docs as needed

## Starting a New Task

Read:
1. `.claude/todo.md` - Verify this is the right task
2. `docs/dev/design/` - Understand relevant subsystem
3. Previous devlog entries about this component

## Investigating a Design

Read:
1. `docs/dev/design/` - Current design knowledge (why and what)
2. `docs/dev/adr/` - Decision history if needed
3. Relevant devlog entries - Historical context
