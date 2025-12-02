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
```
project/
├── README.md                 # Users: what it does, how to use
├── HACKING.md                # Contributors: how to develop
├── CLAUDE.md                 # Agents: architecture, conventions
├── .claude/
│   ├── todo.md               # Current tasks (via subtask skill)
│   └── todo.d/               # Detailed task breakdowns
├── docs/
│   ├── adr/                  # Why: decision rationale
│   ├── architecture/         # What/how: technical design
│   ├── dev/
│   │   ├── design-rationale.md
│   │   ├── technical-design.md
│   │   ├── development-plan.md
│   │   └── devlog/           # When: session history
│   └── examples/             # Usage recipes
└── design-incubators/        # Unsolved design problems
```

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
references.d/: [Categorized guides: file-types.d/, guidelines.d/, workflows.d/]
```

### 3. Temporal Ordering

**Problem:** With 20+ sessions/day exploring ideas in parallel, codebase contains conflicting partial implementations. Which decision is current?

**Pattern:** Date-based naming provides temporal ordering:
- ADRs: `YYYY-MM-DD-NNN-title.md`
- Devlog: `YYYY-MM-DD.md` (or `YYYY-MM-DD-HHMM.md`)
- When conflicts found, newest decision wins

### 4. Baton-Passing

**Problem:** Agent swarm loses alignment between sessions.

**Pattern:** Explicit handoffs via devlog "Next Session" sections:
- Each session documents: Focus, What Happened, Decisions, Next Session
- "Next Session" section explicitly says what to do next
- Latest devlog provides immediate context for incoming agent

**For task tracking:** Use the `subtask` skill for managing ephemeral, tactical, and strategic tasks.

### 5. Living Documentation

**Problem:** Docs become stale and lie.

**Pattern:** Use directory listings as the source of truth:
- `docs/adr/` directory contains decisions—`ls -t` to see chronologically
- `docs/devlog/` directory contains session history—directory itself is the index
- Avoid maintaining separate index files that can drift

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

**Common workflows:**
- When to document what: <https:references.d/workflows.d/when-to-document-what.md>
- Session coordination: <https:references.d/workflows.d/llm-document-consumption-patterns.md>

**Key file types:**
- ADRs: <https:references.d/file-types.d/ADRs.md>
- Devlogs: <https:references.d/file-types.d/devlog.md>
- CLAUDE.md: <https:references.d/file-types.d/CLAUDE.md>
- Browse all: <https:references.d/file-types.d/>

**Common tasks:**
```bash
# Orient yourself at session start
~/.claude/skills/llm-collab-docs/bin/session-start

# Document a significant decision
~/.claude/skills/llm-collab-docs/bin/new-adr "Decision title"

# Record what happened this session
~/.claude/skills/llm-collab-docs/bin/new-devlog

# Backdate an entry (works with any date-based script)
DATE=2025-11-19 ~/.claude/skills/llm-collab-docs/bin/new-adr "Decision title"

# Set up docs for new project
~/.claude/skills/llm-collab-docs/bin/init-docs
```

All scripts support `--help` for details.

## Detailed References

Browse <https:references.d/> for categorized guides:
- **file-types.d/** - What each doc type should contain
- **guidelines.d/** - How to write effective docs
- **workflows.d/** - How to use and maintain docs

## Adopting in Projects

Add to your project's CLAUDE.md (see <https:skeleton/CLAUDE.md>):

```markdown
## Documentation System

This project uses llm-collab-docs patterns:
- ADRs in docs/adr/ (date-based)
- Devlogs in docs/devlog/

Load the llm-collab-docs skill for helper scripts and pattern details.
```

## Success Indicators

These patterns are working when:
- Agents orient quickly (<1 minute)
- "What's next?" has clear answer
- Multiple daily sessions stay aligned
- Conflicts resolve through temporal ordering
- Context loading feels efficient
- Both human and agents can drop in/out
