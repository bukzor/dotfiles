# Test Not Specific

Test catches bug but accepts buggy-passing variant.

## Starting conditions

- Mutation selected
- Test fails with injected bug (good)
- But a different buggy variant passes (test too weak)

## Trace

```
Procedure 5: Inject bug
Procedure 6 → Harden Tests:
  Step 0: Run tests → FAIL ✓
  Step 1: Try buggy-passing → SUCCESS (found variant)
         → repeat from 0
  Step 0: Tighten test, run tests → FAIL ✓
  Step 1: Try buggy-passing → can't create
  Step 2: Revert, run tests → PASS ✓
         git add, mark status: done
Procedure 7: Repeat
```

## Outcome

status: done (after tightening)

## Notes

Test existed but wasn't precise. Step 1's buggy-passing check caught this. One tightening iteration needed.
