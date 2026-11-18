---
label: PREDICTABLE_ISNT_USEFUL
standing: bare
why:
  - ./clean-agent-time-is-output-tokens-restated.md
verify: "context size at turn 1 against session cost, in costed.tsv: 11.9% predictable, 82.6% oracle error"
---

# An input that is easy to predict is usually easy because it never varies

Context size at the first turn is the most predictable quantity measured
here — **11.9% error** from a trailing median, because its p90/p10 spread
is only 2.5x. It is also the worst predictor of cost: **82.6% oracle
error**, barely better than guessing the mean.

It is predictable *because* it is nearly constant, and nearly constant is
the same thing as carrying no information.

The trap generalises, and it is the reason to look at two numbers rather
than one: **stability and informativeness pull in opposite directions**,
so an input recommended on either alone is being recommended on its worse
half. The pairing to look for is a quantity that varies a lot and can
still be judged — which is what turn count is, and why it wins despite
being neither the most stable nor the most informative input available.

Episode count fails the same way less obviously. Its spread is the
tightest of any candidate (40x, geometric sd 0.558) and its oracle error
is 69.4%, because turns-per-episode itself ranges from 1.2 to 29. Knowing
how many exchanges a task will take says almost nothing about its cost.
