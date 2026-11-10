# Haiku Opus role split

**Date:** 2025-12-15
**Status:** Accepted

## Context

Post-hoc TDD requires both mechanical execution (follow procedure, write straightforward tests) and complex reasoning (handle architectural gaps, design tricky tests). Different models excel at each.

## Decision

Split roles:
- **Haiku executes:** Follows procedure, writes/strengthens tests, marks done
- **Opus handles gaps:** When Haiku marks `status: gap`, Opus addresses later

## Alternatives Considered

### Haiku does everything
- **Pros:** Simpler, single model
- **Cons:** Haiku spins on complex gaps, wastes tokens

### Opus does everything
- **Pros:** Higher capability throughout
- **Cons:** Expensive for mechanical work Haiku handles fine

## Consequences

**Positive:**
- Cost-efficient (Haiku for bulk work)
- Quality where needed (Opus for hard cases)
- Clear handoff point (status: gap)

**Negative:**
- Two-model workflow more complex
- Gaps accumulate until Opus session

**Neutral:**
- Requires tracking gap items for Opus

## Related

- Related to: docs/dev/constraints.kb/defer-gaps-to-opus.md
