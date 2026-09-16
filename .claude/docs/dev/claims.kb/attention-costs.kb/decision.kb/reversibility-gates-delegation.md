---
label: REVERSIBILITY_GATES
standing: agent
why:
  - ./review-is-a-real-cost-of-delegating.md
  - ./the-checkpoint-interval-is-constant-in-task-size.md
---

# Reversibility, not size, is what decides whether to delegate

The dropped term in `CHECKPOINT_INTERVAL` is `d(k).D` — the chance an
error escapes every checkpoint, times the damage once it has been acted
on. It has no interior optimum, because `D` is not bounded by anything in
the cost model.

What bounds it is whether the work can be taken back:

- **reversible** — anything under version control, a scratch directory, a
  draft. `D` is a `git reset`, so the term vanishes and the arithmetic
  governs. Delegate freely.
- **irreversible** — an outward send, a deletion, a deploy, a published
  message. `D` is unbounded and no size estimate touches it. Confirm
  first, whatever the cost model says.

So the operative rule is not about task size at all, and reading it off
the cost model is how an agent talks itself into a bad delegation:
**delegate by reversibility, and let size decide only the interval.**

This is the quantitative reading of a convention already in force —
confirm before irreversible or outward-facing actions — and the two
agreeing is mild evidence for both. Signed because the partition into
reversible and not is a judgment applied case by case, not a measurement.
