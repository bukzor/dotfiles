---
name: llm-collab
description: "Agent MUST load when:\n\n1. After making significant decisions (to document as ADR)\n2. Before ending a work session (to document in devlog)\n3. When setting up documentation for a multi-session project\n4. When user asks about coordinating work across sessions"
---
--- # workaround: anthropics/claude-code#13005
setup: |
    All projects that depend on this skill should have as `CLAUDE.md` frontmatter:

    ```yaml
    --- # workaround: anthropics/claude-code#13003
    depends:
        - skills/llm-collab
    ```
---

# LLM-Collaborative Documentation

Principles and helpers for human-LLM agent swarm collaboration on long-running projects. Provides documentation patterns for coordination across agents, temporal conflict resolution, and just-in-time context loading through structured files (ADRs, devlogs, ideas), progressive-detail guides, and optional scripts.

**Note:** This skill focuses on documentation patterns. For task management across sessions, use the `llm-subtask` skill which handles ephemeral, tactical, and strategic task tracking.

> **Status:** Locally maintained, iteratively improving. Expect rough edges.

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
│   ├── todo.d/               # Detailed task breakdowns
│   └── ideas.d/              # Unprioritized ideas (may become todos)
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
references.kb/: [Categorized guides: file-types.kb/, guidelines.kb/, workflows.kb/]
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
- When to document what: <https:references.kb/workflows.kb/when-to-document-what.md>
- Session coordination: <https:references.kb/workflows.kb/llm-document-consumption-patterns.md>

**Key file types:**
- ADRs: <https:references.kb/file-types.kb/ADRs.md>
- Devlogs: <https:references.kb/file-types.kb/devlog.md>
- CLAUDE.md: <https:references.kb/file-types.kb/CLAUDE.md>
- Browse all: <https:references.kb/file-types.kb/>

**Common tasks:**
```bash
# Orient yourself at session start
~/.claude/skills/llm-collab/bin/llm-collab-session-start

# Document a significant decision
~/.claude/skills/llm-collab/bin/llm-collab-adr "Decision title"

# Capture an idea for later
~/.claude/skills/llm-collab/bin/llm-collab-idea "Idea title"

# Record what happened this session
~/.claude/skills/llm-collab/bin/llm-collab-devlog

# Backdate an entry (works with any date-based script)
DATE=2025-11-19 ~/.claude/skills/llm-collab/bin/llm-collab-adr "Decision title"

# Set up docs for new project
~/.claude/skills/llm-collab/bin/llm-collab-init
```

All scripts support `--help` for details.

## Ideas Pattern

`.claude/ideas.d/` captures unprioritized ideas without disrupting focused work.

**When to use:** Mid-task inspiration that deserves capture but not immediate pursuit.

**Lifecycle:**
1. **Exploring** — Initial capture, may be refined over time
2. **Promoted** → Becomes `todo.d/` entry when ready for action
3. **Rejected** → Document reasoning (optionally as ADR), delete file
4. **Forgotten** — Acceptable; important ideas resurface naturally

**Key distinction:**
- `todo.d/` = committed work, will be done
- `ideas.d/` = speculative, might never happen

## Detailed References

Browse <https:references.kb/> for categorized guides:
- **file-types.kb/** - What each doc type should contain
- **guidelines.kb/** - How to write effective docs
- **workflows.kb/** - How to use and maintain docs

## Success Indicators

These patterns are working when:
- Agents orient quickly (<1 minute)
- "What's next?" has clear answer
- Multiple daily sessions stay aligned
- Conflicts resolve through temporal ordering
- Context loading feels efficient
- Both human and agents can drop in/out

## Design Goals

These patterns address:
- Projects with 10-20+ agent sessions per day
- Parallel exploration creating conflicting partial implementations
- Agents needing to hand off work to each other
- User frequently asking "What's next?" or losing thread
- Context waste from loading irrelevant documentation
