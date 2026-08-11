# State which verdicts are sound

A check that approximates its predicate must say, in its own docstring, which
direction of its output is trustworthy. Over-approximate and the negatives are
sound; under-approximate and the positives are. Compose one of each and the
verdict has no sound direction at all.

Diagnostic: the docstring describes what the check looks for but not what it
misses or over-counts. Then no caller can tell which half of the output is
evidence.

Two consequences worth designing for:

- **A check may not report a fact it did not probe.** An assertion about a
  location nobody looked at is not an approximation in either direction; it is
  a bug that reads like a measurement.
- **For a destructive verdict, aim both approximations the same way.**
  Under-count the reason to act, over-count the reason to refrain, and the result
  is a lower bound: sound evidence to act, never sound evidence to skip.

Beware a measure whose corpus grows when you use it -- studying a thing writes
evidence about that thing into the record, which destroys exactly the
over-approximating direction. Partition the corpus into "about the object" and
"using the object" and drop the former.
