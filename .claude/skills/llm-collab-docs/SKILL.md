---
name: llm-collab-docs
description: "Load when:\n\n1. Working on projects with 10-20+ agent sessions per day OR\n2. Parallel explorations create conflicting implementations OR\n3. Agents need structured handoffs between sessions"
---

# LLM-Collaborative Documentation

Principles and helpers for human-LLM agent swarm collaboration on long-running projects. Provides documentation patterns for coordination across agents, temporal conflict resolution, and just-in-time context loading through structured files (ADRs, devlogs, ideas), progressive-detail guides, and optional scripts.

**Note:** This skill focuses on documentation patterns. For task management across sessions, use the `subtask` skill which handles ephemeral, tactical, and strategic task tracking.

> **Status:** Locally maintained, iteratively improving. Expect rough edges.

## When to Use

Consider these patterns when:
- Working with 10-20+ agent sessions per day
- Parallel exploration creates conflicting partial implementations
- Agents need to hand off work to each other
- User frequently asks "What's next?" or loses thread
- Context waste from loading irrelevant documentation

Skip for:
- Single-session or short-lived work
- Simple projects where coordination overhead exceeds value

## Core Principles

### 1. Separation of Concerns

**Problem:** Mixing audiences wastes everyone's time.

**Pattern:** Different files for different audiences/purposes:
- README.md → users (what it does, how to use)
- CONTRIBUTING.md → contributors (how to develop)
- CLAUDE.md → agents (architecture, conventions) - auto-loaded at root
- docs/adr/ → why (decision rationale)
- docs/architecture/ → what/how (technical design)
- docs/devlog/ → when (session history, handoffs)

**Tradeoff:** More files to maintain vs clearer purpose per file.

### 2. Tiered Detail

**Problem:** Loading full docs when you need a summary wastes context tokens.

**Pattern:** Three-level information hierarchy:
1. Top-level file: 1-2 sentence summary + link
2. Main doc: 1-paragraph summary + link to deep dive
3. Subdirectory: Full detail

**Example:**
```
CLAUDE.md: "Uses ADR format for decisions. See docs/adr/"
docs/adr/ directory: [Date-based ADRs, list with ls or grep]
references/creating-documentation.md: [Full 780-line guide]
```

**Tradeoff:** More navigation vs loading only what's needed.

### 3. Temporal Ordering

**Problem:** With 20+ sessions/day exploring ideas in parallel, codebase contains conflicting partial implementations. Which decision is current?

**Pattern:** Date-based naming provides temporal ordering:
- ADRs: `YYYY-MM-DD-NNN-title.md`
- Devlog: `YYYY-MM-DD.md` (or `YYYY-MM-DD-HHMM.md`)
- When conflicts found, newest decision wins

**Alternative:** Standard ADR numbering (0001, 0002) works fine if temporal conflicts rare.

**Tradeoff:** Date-based is longer but provides instant temporal context.

### 4. Baton-Passing

**Problem:** Agent swarm loses alignment between sessions.

**Pattern:** Explicit handoffs via devlog "Next Session" sections:
- Each session documents: Focus, What Happened, Decisions, Next Session
- "Next Session" section explicitly says what to do next
- Latest devlog provides immediate context for incoming agent

**For task tracking:** Use the `subtask` skill for managing ephemeral, tactical, and strategic tasks.

**Alternative:** Just use git commit messages for handoffs.

**Tradeoff:** Devlog maintenance overhead vs explicit coordination.

### 5. Living Documentation

**Problem:** Docs become stale and lie.

**Pattern:** Use directory listings as the source of truth:
- `docs/adr/` directory contains decisions—`ls -t` to see chronologically
- `docs/devlog/` directory contains session history—directory itself is the index
- Avoid maintaining separate index files that can drift

**Alternative:** Manual maintenance, accept some staleness.

**Tradeoff:** Automation complexity vs guaranteed freshness.

## Common Patterns

### When to Document What

**Use ADR for:** Significant architectural/design decisions with rationale
- Extract a new user-facing command from internal logic
- Choose between competing implementation approaches
- Adopt a new technology or pattern
- Deprecate or remove functionality
- Captures: Decision, context, alternatives considered, consequences

**Use Devlog for:** Session work with tactical implementation details
- What was explored/implemented in this session
- Specific commands run, tests performed
- Issues encountered and how resolved
- Handoff context for next session
- Captures: Focus, what happened, next steps

**Use Both ADR + Devlog for:** Significant changes that need both perspectives
- ADR documents the decision and "why" (durable reference)
- Devlog documents the session and "how it went" (temporal record)
- Devlog references the ADR for decision rationale
- Example: Today's git-restore-repo extraction

### Architecture Decision Records (ADRs)

**Problem:** Decisions lost in code comments or chat history. When conflicts found, unclear which decision is current.

**Solution:** Adopt ADR format (widely used standard).

**Variation 1: Standard numbering**
```
docs/adr/
  0001-use-postgres.md
  0002-graphql-over-rest.md
```
- Simple, established
- Sequential order
- Works with standard ADR tools

**Variation 2: Date-based numbering**
```
docs/adr/
  2025-11-19-000-use-postgres.md
  2025-11-19-001-graphql-over-rest.md
```
- Temporal ordering built-in
- Auto-increment within day (helper script available)
- When conflicts found, filename immediately shows recency
- Doesn't work with standard ADR tools

**Choose based on:** How often do you need temporal conflict resolution?

**Helper available:** `scripts/new-adr.sh` - Auto-increments date-based ADRs
- Usage: `new-adr.sh "Decision title"`
- Backdate: `DATE=YYYY-MM-DD new-adr.sh "Decision title"`

### Session Coordination

**Problem:** Agent picks up mid-project, doesn't know context.

**Solutions:**

**Option A: Session start script**
- Run script that reads key files
- Display context at session start
- **Helper available:** `scripts/session-start.sh`

**Option B: Manual reading**
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

## Available Helpers

These scripts implement common patterns. Use if helpful, ignore if not.

### scripts/init-docs.sh

Creates suggested directory structure for new projects. Opinionated starting point - adapt as needed.

### scripts/new-adr.sh

Creates ADR with date-based auto-incrementing (YYYY-MM-DD-NNN-title.md). Handles:
- Finding last ADR from today
- Incrementing number
- Creating from template

**Use if:** You want date-based ADRs and don't want to manage numbers manually.

**Skip if:** Using standard ADR numbering, or manual file creation is fine.

### scripts/new-devlog.sh

Creates devlog entry from template with sections: Focus, What Happened, Decisions, Next Session.

**Use if:** You want consistent devlog format.

**Skip if:** Freeform devlog or git commits work better for you.

### scripts/session-start.sh

Reads and displays: CLAUDE.md, latest devlog, recent ADRs.

**Use if:** You want scripted orientation at session start.

**Skip if:** Manual reading or agent decides what to read works better.

## Reference Material

### references/creating-documentation.md

Complete 780-line guide covering:
- Detailed file purposes and templates
- Linking conventions ("always provide context, never bare links")
- When to use subdirectories (">200 lines")
- Anti-patterns from experience
- LLM consumption patterns
- Maintenance checklists

**Load when:**
- Setting up documentation for first time
- Unsure where information belongs
- Want to understand full rationale
- Teaching the system to others

**Don't load when:**
- Just need quick reminder (use this SKILL.md instead)
- Already familiar with patterns

## Integration Patterns

### With Existing Projects

**Adopt gradually:**
1. Create CLAUDE.md at root for agent orientation
2. Start using ADRs for new decisions
3. Add devlog for session history and handoffs
4. Restructure existing docs as needed

**Make the skill discoverable:**

Once you've adopted these patterns (ADRs, devlogs, etc.), add a note to your project's CLAUDE.md so future agents know to load this skill:

```markdown
## Documentation System

This project uses llm-collab-docs patterns:
- ADRs in docs/adr/ (date-based)
- Devlogs in docs/devlog/

Load the llm-collab-docs skill for helper scripts and pattern details.
```

**Don't:** Feel obligated to follow every pattern.

## Adaptation Guidelines

**These are patterns, not rules.** Adapt based on:

- **Team size:** Solo vs multiple humans changes needs
- **Session frequency:** 5 sessions/day vs 20 changes patterns
- **Exploration style:** Serial vs parallel affects conflict frequency
- **Project phase:** Early exploration vs maintenance
- **Existing conventions:** Respect what team already uses

**Evolution is expected.** As you use these patterns:
- Keep what works
- Drop what doesn't
- Modify to fit your needs
- Share improvements

## Quick Reference

**Starting a session:**
```bash
# With script
~/.claude/skills/llm-collab-docs/scripts/session-start.sh

# Manual
# Read CLAUDE.md, check latest devlog
```

**Creating ADR:**
```bash
~/.claude/skills/llm-collab-docs/scripts/new-adr.sh "Decision title"

# Or backdate:
DATE=2025-11-19 ~/.claude/skills/llm-collab-docs/scripts/new-adr.sh "Decision title"
```

**Creating devlog:**
```bash
~/.claude/skills/llm-collab-docs/scripts/new-devlog.sh
```

## Success Indicators

These patterns are working when:
- Agents orient quickly (<1 minute)
- "What's next?" has clear answer
- Multiple daily sessions stay aligned
- Conflicts resolve through temporal ordering
- Context loading feels efficient
- Both human and agents can drop in/out

**If not working:** Adapt. These are guidelines, not requirements.
