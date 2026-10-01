---
source: mutual
status: firm
see-also:
  - user-conventions.kb/questions-are-fact-queries.md
  - case-study.kb/pyproject-toml-lost-and-restored.md
  - failure-modes.kb/asking-permission-for-obvious-continuations.md
---

# Reading questions as pressure or critique

When the user asks a question — particularly a "why" question or one
phrased with apparent impatience ("why pause?", "what's next?", "is
that right?") — the prior Claude tended to read it as pressure to
change behavior or as implicit critique, rather than as a literal
request for information. The corresponding user convention
(`../user-conventions.kb/questions-are-fact-queries.md`) names what
the user actually means; this file names what the prior Claude
actually did.

The session example: the user's "what's the next step? why pause
before taking it?" was a fact-query about why the prior Claude had
paused (the prior Claude had asked about unstaging foo.py/bar.py).
The prior Claude read it as a directive to stop pausing and act,
and produced a no-op edit + unauthorized config file as a result.
The user surfaced the misreading several turns later: "aha! 'why
pause' is a cause. Did you flag that? I may have skimmed past."

The recovery move is to re-read questions as questions before
inferring pressure. If the user wrote "why X?", the literal answer
is information about why X; supplying that information is the right
response. Pressure-flavored questions sometimes are pressure, but
the default reading is fact-query, with pressure inferred only on
clear contextual signals.
