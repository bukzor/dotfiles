# Implicit Flow

Don't state "continue to next step" - it's implicit.

## Pattern

```
1. Do thing A
2. Do thing B
   - If condition: handle it
```

Not:

```
1. Do thing A
   - Continue to step 2
2. Do thing B
   - If condition: handle it
   - Otherwise: continue to step 3
```

## When to apply

Sequential steps where the normal flow is to proceed to the next step.

## Rationale

Numbered steps imply sequential flow. Only state exceptions (branches, loops, early returns). Stating the obvious adds noise.

## Example

tdd-posthoc Harden Tests:
- "If tests pass: ..." states the exception
- Normal flow (tests fail) proceeds to step 1 implicitly
