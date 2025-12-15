# Positive Framing

State conditions as what IS true, not what ISN'T.

## Pattern

```
If you can only pass tests with correct code: done
```

Not:

```
If you can't pass tests without correct code: done
```

## When to apply

- Double negatives ("can't... without")
- Conditions that check absence rather than presence

## Rationale

Positive framing reduces cognitive load. "Can only X with Y" is one mental operation. "Can't X without Y" requires negating twice.

## Example

tdd-posthoc Harden Tests step 2:
- Before: "If you can't pass tests without correct code"
- After: "If you can only pass tests with correct code"

Same meaning, easier to parse.
