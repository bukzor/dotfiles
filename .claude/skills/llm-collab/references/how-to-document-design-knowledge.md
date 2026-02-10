---
requires:
  - Skill(llm.kb)
---

# How to Document Design Knowledge

Living design documentation using the llm.kb pattern. Deeper than CLAUDE.md,
more distilled than raw ADRs/devlogs, optimized for reference.

## Structure

```
docs/dev/
├── design.md                    # Summary of design/
├── design/
│   ├── CLAUDE.md                # Points here
│   ├── 000-background.kb/
│   ├── 010-mission.kb/
│   ├── 020-goals.kb/
│   ├── 030-requirements.kb/
│   ├── 040-design.kb/
│   ├── 050-components.kb/
│   └── 060-deliverables.kb/
├── technical-policy.md          # Summary of technical-policy.kb/
└── technical-policy.kb/
```

All `.kb/` directories are optional. Create as needed.

## Abstraction Levels

Numbered levels form a stack. "Why?" traverses up, "how?" traverses down.

### 000-background.kb/

Context an outsider needs to understand the project.

- Domain concepts and terminology
- Relevant technology background
- Constraints imposed by environment
- Prior art and alternatives in the space

One file per concept. Reader should understand the landscape after reading.

### 010-mission.kb/

Why this project exists. Often a single file.

- The problem being solved
- Who benefits and how
- What success looks like

### 020-goals.kb/

Objectives the project aims to achieve. One file per goal.

In OKR terms, these are *objectives* — qualitative outcomes that key results
(requirements) make measurable.

- Aspirational but achievable
- Stable over the project lifetime
- Each spawns one or more requirements that prove achievement

### 030-requirements.kb/

Key results and acceptance criteria. One file per requirement.

If goals are *objectives*, requirements are *key results* — the measurable
outcomes that demonstrate goal achievement.

Each requirement MUST trace to at least one goal via `why[]`. If it doesn't
trace to a goal, it's probably a technical policy, not a requirement.

- Verifiable by running or testing the system
- Stakeholders could confirm satisfaction
- Constrains behavior, not implementation

### 040-design.kb/

Architectural structures and key decisions. One file per design element.

- Major abstractions and their relationships
- Data representations
- Algorithm choices
- Integration patterns

Distilled from ADRs. Captures outcomes, not decision journeys.

### 050-components.kb/

Pieces of the system. One file per component or module.

- Responsibility and scope
- Interface (how to use it)
- Key implementation details
- Relationships to other components

More detailed than 040-design, less detailed than code.

### 060-deliverables.kb/

Artifacts that map to source code. One file per deliverable.

- What it produces
- Where it lives in the source tree
- Build/deploy considerations

Should align with actual source structure.

## Technical Policy

Cross-cutting normative guidance. Lives at `docs/dev/technical-policy.kb/`.

- How we achieve requirements (means, not ends)
- Design rules and constraints
- Style and convention decisions
- Performance guidelines

One file per policy. Links to whatever level it serves via `why[]`.

## The why[] Frontmatter

Every file can declare its parent(s) in the abstraction hierarchy:

```yaml
---
why:
  - 020-goals.kb/performant
  - 020-goals.kb/portable
---
```

This enables:
- Rationale traversal (why is this here?)
- Impact analysis (what depends on this?)
- Consistency checking (does this still serve its parent?)

Optional by default. Mature projects can make it required via schema.

## What Goes Where

| Content | Home | Not here |
|---------|------|----------|
| Domain concepts | 000-background.kb/ | Not code docs |
| Project purpose | 010-mission.kb/ | Not goals |
| Desired outcomes | 020-goals.kb/ | Not requirements |
| Must-achieve conditions | 030-requirements.kb/ | Not policies |
| Structures and decisions | 040-design.kb/ | Not decision journeys |
| System pieces | 050-components.kb/ | Not code-level detail |
| Source artifacts | 060-deliverables.kb/ | Not design rationale |
| Normative guidance | technical-policy.kb/ | Not requirements |
| Decision journeys | docs/adr/ | Not design.kb |
| Narrative history | docs/devlog/ | Not design.kb |

## Creating Content

1. Identify which level the content belongs to
2. Check if a file for this item already exists
3. Create file with appropriate frontmatter (including `why[]`)
4. Keep it focused -- one item per file
5. Link to related items in other levels

## Relationship to Other Artifacts

**ADRs** capture decision points with alternatives and rationale. Design.kb
distills the outcomes -- what was decided, not how we got there.

**Devlogs** capture narrative journey. Design.kb distills the understanding --
current state, not history.

**CLAUDE.md** gives high-level orientation. Design.kb provides depth when
needed.

**Code** is the implementation. Design.kb bridges intent and implementation.

## When to Update

- After writing an ADR that affects design
- After significant architectural changes
- When onboarding reveals missing context
- During session-end review

If design.kb contradicts code or ADRs, one of them is stale.
