# Action-based load triggers for skills

**Date:** 2025-12-03
**Status:** Accepted

## Context

Skill descriptions include "Load when:" triggers that tell agents when to load the skill. Original triggers were subjective and undetectable:

- "Working on projects with 10-20+ agent sessions per day"
- "Parallel explorations create conflicting implementations"
- "Agents need structured handoffs between sessions"

An agent cannot detect these conditions programmatically.

## Decision

Skill descriptions should use action-based, detectable triggers:

```yaml
description: "Load when:\n\n1. After making significant decisions (to document as ADR)\n2. Before ending a work session (to document in devlog)\n3. When setting up documentation for a multi-session project\n4. When user asks about coordinating work across sessions"
```

Good triggers are:
- **Action-based**: Tied to specific user actions or requests
- **Detectable**: Agent can recognize the condition
- **Specific**: Clear when they apply

Bad triggers are:
- **Subjective**: "complex project", "many sessions"
- **Undetectable**: "needs coordination", "parallel exploration"
- **Vague**: "when appropriate"

## Alternatives Considered

### Keep subjective triggers, rely on skill description visibility
- **Pros:** Simpler, no change needed
- **Cons:** Agents can't act on undetectable conditions

### Automatic detection via file patterns
- **Pros:** No agent judgment needed
- **Cons:** Only works for existing patterns, not first-time use

## Consequences

**Positive:**
- Agents can reliably decide when to load skills
- Triggers are testable and unambiguous
- Better user experience (skills load when actually needed)

**Negative:**
- Requires thinking carefully about what triggers are detectable

**Neutral:**
- Old "design goals" criteria moved to separate section in SKILL.md
