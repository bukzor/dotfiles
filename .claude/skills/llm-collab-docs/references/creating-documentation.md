# Documentation Structure for LLM-Collaborative Projects

This guide establishes a standard documentation structure optimized for:
- Human users (README)
- Human contributors (HACKING)
- LLM development assistants (CLAUDE.md)
- Multi-session project continuity
- Efficient context loading

## The Core Structure

```
project/
├── README.md              # Users: what this does, how to install/use
├── HACKING.md             # Contributors: how to develop, test, contribute
├── CLAUDE.md              # LLMs: quick-ref, current focus, architecture
├── STATUS.md              # Current milestone, blockers, next actions
├── docs/
│   ├── dev/
│   │   ├── design-rationale.md        # Why decisions were made
│   │   ├── design-rationale/          # Deep dives on specific choices
│   │   ├── technical-design.md        # What the system is/does
│   │   ├── technical-design/          # Subsystem details
│   │   ├── development-plan.md        # How we build it, milestones
│   │   ├── development-plan/          # Per-milestone breakdowns
│   │   └── devlog/
│   │       ├── README.md              # Index of entries
│   │       └── YYYY-MM-DD.md          # Daily/session logs
│   └── examples/                      # Usage recipes, tutorials
└── design-incubators/                 # Unsolved design problems
    └── problem-name/                  # Each gets its own subdirectory
        ├── CLAUDE.md                  # Problem framing
        └── ...                        # Explorations, prototypes
```

## File Purposes

### README.md (User-Facing)

**Audience:** People who want to use the software

**Must contain:**
- One-sentence description
- Installation instructions
- Basic usage examples
- Current status ("alpha", "not ready", "stable")
- Link to HACKING.md for contributors

**Should contain:**
- Prerequisites/dependencies
- Quick-start guide
- Common troubleshooting
- Link to docs/examples/ for advanced usage

**Should NOT contain:**
- Implementation details
- Development history
- Design rationale
- Long explanations (link to docs/ instead)

**Template:**
```markdown
# Project Name

[One-sentence description]

## Status

⚠️ **Alpha:** Not ready for production use. See [HACKING.md] if you want to contribute.

## Installation

[Quick install steps]

## Usage

[Basic example]

See [docs/examples/] for more.

## Contributing

See [HACKING.md].
```

### HACKING.md (Contributor-Facing)

**Audience:** People who want to modify the code

**Must contain:**
- Development setup (dependencies, environment)
- How to run tests
- Project structure overview
- How to add new features (with examples)
- Contribution workflow (if applicable)

**Should contain:**
- Code style guidelines
- Architecture overview (brief, link to docs/dev/technical-design.md)
- Common development tasks ("How do I add a new command?")
- Debugging tips

**Should NOT contain:**
- Why decisions were made (that's design-rationale.md)
- Complete API documentation (that's docs/dev/)
- User-facing documentation

**Template:**
```markdown
# Hacking on [Project]

## Setup

[Dependencies, environment setup]

## Project Structure

[Brief overview, link to technical-design.md]

## Running Tests

[How to test]

## Common Tasks

### Adding a new [component type]
[Step-by-step guide]

### Debugging [common issue]
[Tips and tools]

## Architecture

See [docs/dev/technical-design.md] for details.

## Design Decisions

See [docs/dev/design-rationale.md] for why things are the way they are.
```

### CLAUDE.md (LLM-Facing)

**Audience:** Claude (or other LLM development assistant)

**Purpose:** "How to work on this project" (architecture, conventions, common tasks)

**Critical requirements:**
- **Front-loads most important info** (common tasks, quick ref)
- **Terse summaries with links** for deep dives
- **Never just links** (always include 1-2 sentence summary before link)
- **References STATUS.md** for current state (don't duplicate)

**Must contain:**
1. **Quick Reference** - Most common development tasks
2. **Current State Reference** - Link to STATUS.md (don't duplicate milestone/blockers)
3. **Architecture** - Terse overview with links
4. **Data Flow** - How information moves through the system
5. **Key Files** - Where to find critical code/config

**Should contain:**
- Links to STATUS.md, latest devlog entry
- Common gotchas or constraints
- Testing shortcuts
- Conventions (naming, style)

**Should NOT contain:**
- Full duplication of other docs (use summaries + links)
- Historical information (that's devlog)
- Exhaustive details (link to docs/dev/)

**Template:**
```markdown
# [Project] - Development Guide for Claude

## Quick Reference

**Implementing new [component]:**
[2-3 sentence summary] → See [HACKING.md#section](HACKING.md#section)

**Understanding [key concept]:**
[Brief explanation] → See [docs/dev/technical-design.md#concept](docs/dev/technical-design.md#concept)

**Current state:** See [STATUS.md] for milestone, blockers, and next actions.

## Architecture Overview

[3-5 sentence summary of how the system works]

**Key subsystems:**
- [Subsystem 1]: [One sentence] → [Link to docs/dev/technical-design/subsystem-1.md]
- [Subsystem 2]: [One sentence] → [Link to docs/dev/technical-design/subsystem-2.md]

## Data Flow

[Brief description or ASCII diagram showing how data moves through system]

See [docs/dev/technical-design.md#data-flow](docs/dev/technical-design.md#data-flow) for details.

## Key Files

- `[path]` - [What it does]
- `[path]` - [What it does]

## Conventions

- [Style/naming/organization conventions]

## Testing

[How to run tests, what to check]

See [HACKING.md#testing](HACKING.md#testing) for details.
```

### STATUS.md (Current State)

**Audience:** Both humans and LLMs starting a new session

**Purpose:** "Where we are now" (high-level snapshot, not detailed tracking)

**Must contain:**
- Current Focus: milestone, last session, blockers
- Next Actions: 3 concrete tasks
- Progress Summary: brief status + link to devlog for details

**Should NOT contain:**
- Blow-by-blow session details (that's devlog)
- How to work on the project (that's CLAUDE.md)
- Why decisions were made (that's design-rationale.md)
- Per-task checkboxes (that's development-plan.md - link to it instead)

**Template:**
```markdown
# Project Status

**Last Updated:** YYYY-MM-DD

## Current Focus

- **Milestone:** [Milestone N: Name](docs/dev/development-plan.md#milestone-N) - **Status**
- **Last Session:** [devlog/YYYY-MM-DD](docs/dev/devlog/YYYY-MM-DD.md)
- **Blockers:** [None / List specific blockers]

## Progress Summary

See [docs/dev/devlog/] for session details.

**Milestone Status:** [Brief 1-2 sentence summary of progress]

## Next Actions

[Brief context line]

1. [Specific next task]
2. [Specific next task]
3. [Specific next task]
```

### docs/dev/design-rationale.md (The "Why")

**Audience:** Developers who need to understand why decisions were made

**Must contain:**
- Key architectural decisions
- Alternatives considered
- Tradeoffs and reasoning

**Structure:**
```markdown
# Design Rationale

## Core Decisions

### [Decision Name]

**Decision:** [What we chose]

**Alternatives Considered:**
- Option A: [Pros/cons]
- Option B: [Pros/cons]

**Rationale:** [Why we chose this]

**Tradeoffs:** [What we gave up, what we gained]

See [design-rationale/decision-name.md] for detailed analysis.

## Related Documents

- [Link to technical-design.md sections affected by these decisions]
```

**When to use subdirectory:**
- If rationale is >200 lines
- If it includes diagrams, examples, prototypes
- If multiple people will reference it frequently

### docs/dev/technical-design.md (The "What")

**Audience:** Developers who need to understand how the system works

**Must contain:**
- System architecture overview
- Component responsibilities
- Data structures
- APIs/interfaces

**Structure:**
```markdown
# Technical Design

## System Overview

[High-level description of what the system is]

## Architecture

[Diagram or description of major components and relationships]

## Components

### [Component Name]

**Responsibility:** [What it does]

**Interface:** [How to interact with it]

**Implementation:** [Key details] → See [technical-design/component-name.md]

## Data Structures

### [Structure Name]

[Description, fields, relationships]

## Data Flow

[How information moves through the system]

## Testing Strategy

[How components are tested]
```

**When to use subdirectory:**
- If component documentation is >100 lines
- If it includes implementation details, examples
- If it's referenced frequently by itself

### docs/dev/development-plan.md (The "How")

**Audience:** Developers who need to know what to build and in what order

**Purpose:** Living document tracking milestone progress with detailed task checklists

**Must contain:**
- Milestones with clear deliverables
- Dependencies between milestones
- Success criteria for each milestone
- **Checkboxes for deliverables** (updated as work progresses)
- **Status field per milestone** (Not Started / In Progress / Blocked / Complete)

**Structure:**
```markdown
# Development Plan

## Milestones

### Milestone 1: [Name]

**Status:** In Progress / Blocked / Not Started

**Goal:** [What this milestone achieves]

**Deliverables:**
- [ ] Task 1 - [Brief description]
- [x] Task 2 - [Brief description]
- [ ] Task 3 - [Brief description]

**Dependencies:** [What must be done first]

**Success Criteria:** [How we know it's done]

**Estimated Effort:** [Rough estimate]

See [development-plan/milestone-1-details.md] for task breakdown.

### Milestone 2: [Name]
...
```

**Living document practice:**
- Check boxes as tasks complete during session
- Update milestone Status field when status changes
- Link from STATUS.md to active milestone for detailed progress

**When to use subdirectory:**
- If milestone has >20 tasks
- If milestone needs its own design docs
- If multiple sessions will focus on one milestone

### docs/dev/devlog/ (The "When")

**Audience:** Future you, future Claude sessions

**Must contain:**
- What was attempted
- What worked / what didn't
- Decisions made
- Open questions
- Next session starting point

**File naming:** `YYYY-MM-DD.md` (or `YYYY-MM-DD-session-N.md` for multiple sessions/day)

**Template:**
```markdown
# Devlog: YYYY-MM-DD

## Focus

[What was the goal today?]

## What Happened

### Completed
- [Task] - [Outcome]

### Attempted
- [Task] - [What went wrong / why stopped]

### Discovered
- [Finding] - [Implication]

## Decisions Made

### [Decision]
**Rationale:** [Why]
**Alternatives:** [What we didn't choose]
**Impact:** [What this affects]

## Open Questions

- [Question] - [Context, why it matters]

## Next Session

**Start here:** [Specific task or file to open]
**Blockers:** [Anything preventing progress]

## Links

- [Related devlog entries]
- [Design docs updated/created]
```

**devlog/README.md:**
```markdown
# Development Log

Chronological record of development sessions.

## Recent Entries

- [YYYY-MM-DD](YYYY-MM-DD.md) - [Brief description]
- [YYYY-MM-DD](YYYY-MM-DD.md) - [Brief description]

## By Topic

### [Feature/Component Name]
- [YYYY-MM-DD](YYYY-MM-DD.md)
- [YYYY-MM-DD](YYYY-MM-DD.md)
```

## Design Incubators

**Purpose:** Isolated spaces for unsolved design problems

**When to create:**
- Problem affects multiple components
- Multiple viable approaches need exploration
- Solution isn't obvious
- Prototyping will take multiple sessions

**Structure:**
```
design-incubators/
└── problem-name/
    ├── CLAUDE.md              # Problem framing, constraints, candidates
    ├── README.md              # Investigation plan, status
    ├── investigate-X.py       # Exploration scripts
    ├── prototype-A/           # Approach A implementation
    ├── prototype-B/           # Approach B implementation
    └── DECISION.md            # Final choice (when resolved)
```

**Lifecycle:**
1. Create incubator when problem identified
2. Explore approaches, document findings
3. Make decision (write DECISION.md)
4. Merge lessons into main docs
5. Archive or delete incubator

## Guidelines

### Linking Conventions

**Always provide context when linking:**
```markdown
❌ Bad: See [technical-design.md](docs/dev/technical-design.md)
✅ Good: See [technical-design.md](docs/dev/technical-design.md) for data flow details
```

**Use relative links:**
```markdown
From CLAUDE.md: [devlog](docs/dev/devlog/2025-01-30.md)
From devlog:    [design](../technical-design.md#caching)
```

### Keeping Docs DRY

**Hierarchy of detail:**
1. CLAUDE.md: 1-2 sentence summary + link
2. Main doc: 1 paragraph + link to subdirectory
3. Subdirectory doc: Full details

**Example:**
```markdown
# CLAUDE.md
Plumbing tools use JSONL for stdin/stdout. See [technical-design.md#data-format].

# technical-design.md
## Data Format
Plumbing tools communicate via JSONL (one JSON object per line). This enables:
- Streaming processing
- Easy composition with jq
- Future capnproto migration

See [technical-design/jsonl-format.md] for schema details.

# technical-design/jsonl-format.md
## JSONL Format Specification
[Full schema, examples, edge cases, 200+ lines]
```

### When to Use Subdirectories

**Use subdirectories when:**
- Content exceeds ~200 lines
- Topic is independently referenceable
- Multiple related documents exist
- Content is consulted frequently by itself

**Don't use subdirectories for:**
- Short subsections (<100 lines)
- Content rarely accessed independently
- Topics better understood in context

**Placeholder files:** Acceptable as explicit next-up action items. Mark with "TODO" status and populate before milestone completion.

### Updating STATUS.md

**Update after every session:**
```bash
# At end of session
1. Update "Last Updated" date
2. Move completed items from "Next Actions" to "Recent Completions"
3. Add new blockers if discovered
4. Write 3 new "Next Actions"
```

**Link from devlog:**
```markdown
# In devlog/YYYY-MM-DD.md
## Session End
Updated [STATUS.md](../../STATUS.md):
- Completed: [task]
- Next: [task]
```

### Entry Points for Common Questions

Each major doc should have "When to read this" section at top:

```markdown
# design-rationale.md

**Read this when:**
- Questioning why a design decision was made
- Considering changing a core architectural choice
- Onboarding new contributors who ask "why?"
```

## LLM Consumption Patterns

### First Session on Project

**Claude should read in order:**
1. `CLAUDE.md` - Quick reference, architecture overview
2. `STATUS.md` - Current milestone, blockers, next actions
3. Active milestone in `development-plan.md` - Detailed task checklist
4. `docs/dev/devlog/YYYY-MM-DD.md` - Last session details
5. Task-specific docs as needed

### Starting a New Task

**Claude should read:**
1. `STATUS.md` - Verify this is the right task
2. Relevant section of `development-plan.md` - Check off completed tasks, understand remaining work
3. Relevant section of `technical-design.md` - Understand subsystem
4. Previous devlog entries about this component

### Investigating a Design

**Claude should read:**
1. `design-rationale.md` - Why current design exists
2. `technical-design.md` - What current design is
3. Related `design-incubators/` - If problem unsolved
4. Relevant devlog entries - Historical context

## Anti-Patterns

### ❌ Don't Do This

**Redundant duplication:**
```markdown
# CLAUDE.md
Plumbing tools use JSONL. One object per line. This enables streaming...
[30 lines of explanation]

# technical-design.md
[Exact same 30 lines]
```

**Broken links with no context:**
```markdown
See [this](design.md)
```

**Hidden information:**
```markdown
# README.md
This project does things. See docs/ for more.
[No indication of what things or where to start]
```

**Stale documentation:**
```markdown
# STATUS.md
Last Updated: 2024-06-15
[6 months out of date]
```

**Design docs in wrong place:**
```markdown
# Some random .py file
# DESIGN NOTE: We chose this approach because of X, Y, Z considerations
# and evaluated alternatives A, B, C before deciding...
[300 line comment that should be in design-rationale.md]
```

### ✅ Do This

**Tiered detail:**
```markdown
# CLAUDE.md
Plumbing uses JSONL (one object/line) for streaming and jq compatibility.
See [technical-design.md#jsonl](docs/dev/technical-design.md#jsonl).

# technical-design.md
## JSONL Format
One JSON object per line enables streaming, composition, future migration.
See [technical-design/jsonl-format.md] for schema.

# technical-design/jsonl-format.md
[Full specification]
```

**Contextual links:**
```markdown
See [caching strategy](technical-design/caching.md) for lazy-loading implementation.
```

**Progressive disclosure:**
```markdown
# README.md
claifs provides lazy filesystem access to claude.ai conversations.

**Status:** Alpha (not ready for use)

Install: [Quick steps]
Usage: [Basic example]

For development: See [HACKING.md]
For architecture: See [docs/dev/technical-design.md]
```

**Living documentation:**
```markdown
# At end of every session
git add STATUS.md docs/dev/devlog/YYYY-MM-DD.md
git commit -m "Update status and devlog"
```

**Extracted design docs:**
```python
# In code:
# Data format: See docs/dev/technical-design/jsonl-format.md
def parse_jsonl(line):
    ...
```

## Checklist for New Projects

Starting a new project? Create these files:

```bash
# Core files
- [ ] README.md (user-facing, mark status)
- [ ] HACKING.md (contributor setup)
- [ ] CLAUDE.md (LLM quick-ref)
- [ ] STATUS.md (current milestone)

# docs/dev/ structure
- [ ] docs/dev/design-rationale.md (why decisions)
- [ ] docs/dev/technical-design.md (what system is)
- [ ] docs/dev/development-plan.md (how to build)
- [ ] docs/dev/devlog/README.md (index)
- [ ] docs/dev/devlog/YYYY-MM-DD.md (first entry)

# Optional (create as needed)
- [ ] docs/examples/ (usage recipes)
- [ ] design-incubators/ (unsolved problems)
```

## Reference Implementation

See `~/claude/claude-api/` for a project following this structure.

## When to Deviate

This structure works well for:
- Multi-session projects
- Complex systems with multiple subsystems
- Projects with LLM collaboration
- Projects with multiple contributors

Consider simpler structure for:
- Tiny projects (<500 lines)
- Single-session prototypes
- Pure exploratory work

When deviating, keep principles:
- **Separate user/contributor/LLM docs**
- **Track current state explicitly**
- **Link with context, not just URLs**
- **Tier detail levels (summary → deep dive)**

## Maintenance

**After every session:**
1. Update STATUS.md
2. Create/update devlog entry
3. Update CLAUDE.md "Last Session" link
4. Update relevant design docs if decisions made

**After milestone completion:**
1. Update development-plan.md
2. Update STATUS.md for next milestone
3. Create devlog summary entry
4. Archive/resolve any design-incubators

**Monthly:**
1. Review and prune stale design-incubators
2. Consolidate related devlog entries into design docs
3. Update README/HACKING if APIs changed

[HACKING.md]: HACKING.md
[STATUS.md]: STATUS.md
[docs/dev/technical-design.md]: docs/dev/technical-design.md
[docs/dev/design-rationale.md]: docs/dev/design-rationale.md
[docs/examples/]: docs/examples/
[design-rationale/decision-name.md]: design-rationale/decision-name.md
[technical-design/component-name.md]: technical-design/component-name.md
[development-plan/milestone-1-details.md]: development-plan/milestone-1-details.md
[technical-design/jsonl-format.md]: technical-design/jsonl-format.md
