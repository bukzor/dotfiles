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
├── background.kb/               # Foundational context other layers assume
├── design.md                    # Summary of design/
├── design/
│   ├── CLAUDE.md                # Breadcrumb to this document
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

## Background

Foundational context that other layers assume. Lives at `docs/dev/background.kb/`.

- Domain concepts and terminology
- Relevant technology background
- Constraints imposed by environment
- Prior art and alternatives

One file per concept. No `why[]` links (nothing depends on background; background informs everything).

## Abstraction Levels

Design knowledge forms a stack. Each layer justifies the one below and realizes the one above.

Entries link upward via `why[]` frontmatter.

### 010-mission.kb/

- What do we want out of this project?
- Why do we have these goals?
- The problem being solved
- Who benefits and how
- What success looks like

### 020-goals.kb/

- How do we accomplish the mission?
- Why do we have these requirements?
- Aspirational but achievable
- Stable over the project lifetime

### 030-requirements.kb/

- Verifiable by end-users
- How do we validate the goals are achieved?
- Justifies design decisions (layer below)

### 040-design.kb/

- How do we satisfy the requirements?
- Why do we have these components?
- Major abstractions and their relationships
- Distilled from ADRs — outcomes, not decision journeys

### 050-components.kb/

- How do we implement the design?
- Why do we have these deliverables?
- Responsibility and scope
- Interface (how to use it)
- Data representations and algorithm choices

### 060-deliverables.kb/

- How do we build the components?
- Key implementation details
- Build/deploy considerations

## Technical Policy

Cross-cutting normative guidance. Lives at `docs/dev/technical-policy.kb/`.

- How we achieve requirements (means, not ends)
- Design rules and constraints
- Style and convention decisions
- Performance guidelines

One file per policy. Links to some part of the design via `why[]`.

## Creating Content

When creating a design "from whole cloth", pause after each layer to
provide an opportunity for review and/or correction from the user.

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
