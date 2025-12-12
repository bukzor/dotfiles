--- # workaround: anthropics/claude-code#13003
requires:
    - Skill(llm-collab)
---

# Architecture Decision Records

Significant architectural and design decisions for this project.

## What Belongs

Each ADR documents:
- The decision made
- Context and problem statement
- Alternatives considered
- Rationale and tradeoffs
- Consequences and implications

## What Does NOT Belong

- Implementation details (→ code/tests)
- Task tracking (use TodoWrite for active work)
- Development history (→ docs/devlog/)
- General design docs (→ docs/design.kb/ if using llm.kb pattern)

## Creating ADRs

Use: `llm-collab-adr "Decision title"`
