# Open Questions

Design questions that the user and prior Claude identified during the
session as needing decisions, but did not finalize. Each open
question is itself a sub-kb, because each has multiple candidate
answers — a spectrum — and the spectrum is part of the knowledge.
Each candidate gets its own file so the alternatives can be
considered side-by-side rather than buried in prose.

## What belongs here

A question belongs here when (a) it is genuinely open — no committed
direction yet — and (b) it has at least two candidate answers that
have been considered. A question with no candidates yet is closer
to a structural observation; capture it in the relevant
content-area file (e.g., `../rule-architecture.md` mentions the
"redesign must-read trigger mechanism" invitation without
enumerating candidates).

A question whose candidates are all clearly bad except one is no
longer open — close it by recording the conclusion as a decision
note in the appropriate location and remove the open-question entry.

## What does NOT belong

- Proposals with a chosen direction and uncertainty only on details
  (those go at parent root as `proposal-*.md`)
- Questions whose answer requires research outside this kb's scope
  (e.g., "what does pyright do under condition X" — that's a
  research question, not a design question)
- Action items disguised as questions ("should we do X?" where the
  answer is obviously yes and the question is timing) — those go in
  `.claude/todo.md`
