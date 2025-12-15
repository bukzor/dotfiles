# Gap - Over-Constrained

Test catches bug but also rejects correct code.

## Starting conditions

- Mutation selected
- Test written that fails with buggy code
- But test also fails with correct code (false positive)

## Trace

```
Procedure 5: Inject bug
Procedure 6 → Harden Tests:
  Step 0: Add test, run → FAIL ✓
  Step 1: Try buggy-passing → can't create
  Step 2: Revert bug, run tests → FAIL (rejects correct code!)
         revert test changes, mark status: gap
         document ## Test Result: "test over-constrained"
Procedure 7: Repeat
```

## Outcome

status: gap

## Notes

Test is too strict - asserts something that varies legitimately (platform-dependent, timing, etc.). Step 2's "should pass" check catches this.
