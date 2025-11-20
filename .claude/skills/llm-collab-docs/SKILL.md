---
name: llm-collab-docs
description: Principles and helpers for human-LLM agent swarm collaboration on long-running projects. Use when working on projects with multiple daily sessions (10-20+) that need coordination across agents, temporal conflict resolution, and just-in-time context loading. Provides progressive-detail documentation guide and optional scripts for common patterns.
---

# LLM-Collaborative Documentation

## Purpose

Support effective human-LLM agent swarm collaboration through documentation patterns that enable:

- **Just-in-time expertise** - Agents discover and load exactly what they need
- **Multi-agent coordination** - Many daily sessions stay aligned through explicit handoffs
- **Temporal conflict resolution** - When parallel explorations create conflicts, recency helps resolve
- **Bidirectional alignment** - Both human and agents can recover shared state
- **Variable-fidelity access** - Load appropriate detail level on demand

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
- .claude/README.md or docs/CLAUDE.md → agents (architecture, conventions)
- STATUS.md → current state (where we are, what's next)
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
docs/adr/README.md: "Date-based ADRs with auto-increment. See references/creating-documentation.md for rationale"
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
- Next agent reads STATUS.md → points to latest devlog
- "Next Session" section explicitly says what to do

**Alternative:** STATUS.md manually maintained, or just use git commit messages.

**Tradeoff:** Devlog maintenance overhead vs explicit coordination.

### 5. Living Documentation

**Problem:** Docs become stale and lie.

**Pattern:** Auto-generate coordination files from source of truth:
- STATUS.md generated from latest devlog
- ADR index generated from adr/*.md files
- Devlog index generated from entries

**Alternative:** Manual maintenance, accept some staleness.

**Tradeoff:** Automation complexity vs guaranteed freshness.

## Common Patterns

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

### Status Tracking

**Problem:** Starting a session, agent doesn't know current focus.

**Solution:** STATUS.md as entry point.

**Variation 1: Auto-generated pointer**
```markdown
# Status
Last Session: [2025-11-19](docs/devlog/2025-11-19.md)
Milestone: See ROADMAP.md
Next Actions: [extracted from devlog]
```
- Always fresh (generated from devlog)
- Minimal duplication
- Requires automation

**Variation 2: Manual maintenance**
- Full details in STATUS.md
- Edit after each session
- Simple, no automation needed
- Can get stale

**Variation 3: No STATUS.md**
- Just read latest devlog directly
- One less file to maintain
- Less obvious entry point

**Choose based on:** How much automation do you want?

**Helper available:** `scripts/update-status.sh` - Generate STATUS.md from latest devlog

### Session Coordination

**Problem:** Agent picks up mid-project, doesn't know context.

**Solutions:**

**Option A: Session start/end scripts**
- Run script that reads key files
- Display context at session start
- Update coordination at end
- **Helpers available:** `scripts/session-start.sh`, `scripts/session-end.sh`

**Option B: Manual reading**
- Agent reads STATUS.md
- Follows links to devlog, ADRs, etc.
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
- Updating index

**Use if:** You want date-based ADRs and don't want to manage numbers manually.

**Skip if:** Using standard ADR numbering, or manual file creation is fine.

### scripts/new-devlog.sh

Creates devlog entry from template with sections: Focus, What Happened, Decisions, Next Session.

**Use if:** You want consistent devlog format.

**Skip if:** Freeform devlog or git commits work better for you.

### scripts/update-status.sh

Generates STATUS.md from latest devlog entry (extracts "Next Session" section).

**Use if:** You want STATUS.md as auto-generated pointer.

**Skip if:** Manual STATUS.md or no STATUS.md works better.

### scripts/update-adr-index.sh

Generates docs/adr/README.md index (recent ADRs, by status, quick search examples).

**Use if:** You want auto-maintained ADR index.

**Skip if:** Manual index or no index is fine.

### scripts/session-start.sh

Reads and displays: CLAUDE.md, STATUS.md, latest devlog, recent ADRs.

**Use if:** You want scripted orientation at session start.

**Skip if:** Manual reading or agent decides what to read works better.

### scripts/session-end.sh

Updates STATUS.md, ADR index, shows git status.

**Use if:** You want scripted coordination updates.

**Skip if:** Manual updates or git hooks work better.

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

### With Git

**Option:** Git hooks for auto-updates
```bash
# .git/hooks/post-commit
#!/bin/bash
.claude/update-status.sh
.claude/update-adr-index.sh
```

**Option:** Manual commit workflow
```bash
# Work happens
.claude/session-end.sh  # Updates docs
git diff               # Review
git commit -m "..."    # Commit
```

**Choose based on:** How much automation do you want?

### With Existing Projects

**Adopt gradually:**
1. Add STATUS.md (manual or generated)
2. Start using ADRs for new decisions
3. Add devlog when valuable
4. Create .claude/README.md as agent quick-ref
5. Restructure existing docs as needed

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
# With scripts
.claude/session-start.sh

# Manual
# Read STATUS.md, latest devlog, .claude/README.md
```

**Creating ADR:**
```bash
# Date-based with script
.claude/new-adr.sh "Decision title"

# Manual
# Create docs/adr/YYYY-MM-DD-NNN-title.md or docs/adr/0001-title.md
```

**Ending session:**
```bash
# With scripts
.claude/session-end.sh

# Manual
# Update STATUS.md, commit changes
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
