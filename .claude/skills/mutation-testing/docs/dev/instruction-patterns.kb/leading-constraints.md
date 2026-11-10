# Leading Constraints

Put Principles/constraints before Procedure.

## Pattern

```markdown
## Principles
- Constraint A
- Constraint B

## Procedure
1. Step one
2. Step two
```

Not:

```markdown
## Procedure
1. Step one
2. Step two

## Principles
- Constraint A
- Constraint B
```

## When to apply

When an agent (especially Haiku) tends to jump into action before reading constraints.

## Rationale

LLMs read top-to-bottom. Constraints after procedure get skipped when agent is eager to execute. Leading with constraints forces reading them first.

## Example

tdd-posthoc: Haiku would skip to writing tests immediately. Moving "Inject bug first" to leading Principles section fixed this.
