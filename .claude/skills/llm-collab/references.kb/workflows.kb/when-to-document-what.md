# When to Document What

Decision guide for choosing between ADRs, devlog, and other documentation types.

## Use ADR for

Significant architectural/design decisions with rationale:

- Extract a new user-facing command from internal logic
- Choose between competing implementation approaches
- Adopt a new technology or pattern
- Deprecate or remove functionality

**Captures:** Decision, context, alternatives considered, consequences

## Use Devlog for

Session work with tactical implementation details:

- What was explored/implemented in this session
- Specific commands run, tests performed
- Issues encountered and how resolved
- Handoff context for next session

**Captures:** Focus, what happened, next steps

## Use Both ADR + Devlog for

Significant changes that need both perspectives:

- ADR documents the decision and "why" (durable reference)
- Devlog documents the session and "how it went" (temporal record)
- Devlog references the ADR for decision rationale

**Example:** Extract a new subsystem - ADR captures why, devlog captures implementation journey.

## See Also

- [file-types.d/ADRs.md](../file-types.d/ADRs.md) - ADR structure and format
- [file-types.d/devlog.md](../file-types.d/devlog.md) - Devlog structure and format
