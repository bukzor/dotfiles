# Attempt Limits

Use concrete counts, not vague words.

## Pattern

```
after 2-5 attempts: mark gap
```

Not:

```
if repeatedly unable: mark gap
```

## When to apply

Any loop that could run indefinitely needs an exit condition.

## Rationale

"Repeatedly" is subjective. One agent's "repeatedly" is 2 tries, another's is 10. Concrete range (2-5) sets shared expectation.

Range rather than exact number gives flexibility while bounding effort.

## Example

tdd-posthoc Harden Tests step 0:
- Before: "If strengthening repeatedly fails"
- After: "after 2-5 attempts"
