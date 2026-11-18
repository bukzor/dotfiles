---
label: SETUP_IS_NEGLIGIBLE
standing: bare
why:
  - ../cost-structure.kb/what-adding-a-token-actually-costs.md
  - ./the-operator-bills-at-150-an-hour.md
---

# Setup and bookkeeping costs never decide anything

Every mode's setup overhead is under **5% of one operator minute**, so
no choice between modes can turn on it.

Each mode carries some overhead before any work happens. Priced by
`STRIP_PRICE` at Opus rates with 25 turns remaining:

- **briefing a subagent** — agent-composed messages run ~2,966 characters
  (~1,020 tokens), replayed in the parent, plus the subagent's own
  cold-start turn: **~$0.12**;
- **asking the operator** — a question and a ~293-character reply
  entering context: **~$0.002**;
- **continuing in session** — nothing.

Against a single operator minute at $2.50, the largest of these is **5% of
one minute**. No choice between modes has ever turned on them, and none
can: the spread between modes is a factor of 60 on a quantity that is
itself two orders of magnitude below the human term.

Worth stating because bookkeeping overhead is an intuitive thing to worry
about and a measurably wrong one. An agent hesitating to delegate because
writing the brief costs tokens has mispriced the brief by about 20x
relative to the minute it saves.
