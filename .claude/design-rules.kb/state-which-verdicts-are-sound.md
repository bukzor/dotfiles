# State which verdicts are sound

A check that approximates its predicate must say, in its own docstring, which
direction of its output is trustworthy. Over-approximate and the negatives are
sound; under-approximate and the positives are. Compose one of each and the
verdict has no sound direction at all.

Diagnostic: the docstring describes what the check looks for but not what it
misses or over-counts. Then no caller can tell which half of the output is
evidence.

This presumes the predicate is **monotone** in the approximated quantity, which
membership and threshold predicates are. A goldilocks predicate -- "within ten
percent", "the right size" -- has no sound direction from any one-sided
approximation, and must say *neither*, not pick the one that would have applied.

Two consequences worth designing for:

- **A check may not report a fact it did not probe.** An assertion about a
  location nobody looked at is not an approximation in either direction; it is
  a bug that reads like a measurement.
- **Choose the direction by the cost of being wrong.** For an irreversible act,
  aim both approximations the same way -- under-count the reason to act,
  over-count the reason to refrain -- and the result is a lower bound: sound
  evidence to act, never sound evidence to skip. For a cheaply reversible act,
  aim them the other way and let the revert be the check.

Beware a measure whose corpus grows when you use it -- studying a thing writes
evidence about that thing into the record, which destroys exactly the
over-approximating direction. Stratify by something you cannot influence: a
timestamp, counting only what predates the study. Stratifying by *topic* instead
inverts the direction you were protecting, because an analyst also runs what they
study -- dropping the "meta" records drops real uses and manufactures the zeros
the check was hunting for.
