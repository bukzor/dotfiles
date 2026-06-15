# Ideal Path

Existing tests are adequate - no strengthening needed.

## Starting conditions

- Mutation selected with status: todo
- Existing test suite catches this bug
- Test is specific enough (no buggy-passing variants)

## Trace

```
Procedure 4: Pick mutation
Procedure 5: Inject bug
Procedure 6 → Harden Tests:
  Step 0: Run tests → FAIL ✓
  Step 1: Try buggy-passing → can't create
  Step 2: Revert bug, run tests → PASS ✓
         git add, mark status: done
         document ## Test Coverage
Procedure 7: Repeat
```

## Outcome

status: done

## Notes

Fastest path. Test existed, caught the bug, was specific enough. No new code written.
