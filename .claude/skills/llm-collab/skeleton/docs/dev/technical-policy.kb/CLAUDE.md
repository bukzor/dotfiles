--- # workaround: anthropics/claude-code#13003
requires:
    - Skill(llm-collab)/references/how-to-document-design-knowledge.md
---

# Technical Policy

Cross-cutting normative guidance. How we achieve requirements — means, not ends.

## What Belongs

- Design rules and constraints
- Performance guidelines
- Style and convention decisions
- Policies that span multiple components

One file per policy, with `why[]` linking to what it serves.

## What Does NOT Belong

- Requirements (those trace to goals, live in design/030-requirements.kb/)
- Component-specific details (those live in design/050-components.kb/)
- Decisions with alternatives (those are ADRs)

## When to Update

- When establishing a new cross-cutting constraint
- After an ADR that introduces a policy
- When a policy is violated and needs reinforcement
