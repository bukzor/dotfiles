---
source: user
status: exploratory
see-also:
  - spectrum-not-singular.md
---

# Proposal: realignment via subtask-list

The proposal: as an early step in the `claude-realignment` skill, load
`Skill(llm-subtask)` and run a `subtask list` scoped to disputed
turns. Add explicit emphasis on enumerating all potential
interpretations of the disputed directive — not work items, but
candidate parses of what the user might have meant.

The reasoning grounds this in the spectrum-not-singular principle
(see `spectrum-not-singular.md`). The act of writing a list of
candidates externalizes the distribution that ought to inform any
interpretation under uncertainty. With the candidates externalized,
the user can correct the *list* rather than the action — a much
cheaper and clearer correction loop. Without the list, the
realigning Claude tends to fire a new confident guess, which is
exactly the failure mode (eyes-shut guessing under rejection) that
realignment is supposed to interrupt.

The user's exact phrasing of the proposal: "I think loading
skill(llm-subtask) will be a good thing to do at any rate. But then
we can request a 'subtask list' scoped to the 'between good/bad'
section, with added emphasis listing all potential interpretations.
maybe."

The "between good/bad section" refers to the realignment skill's
existing procedure: bound the breakdown by identifying the last
functional state and the failure point, then trace the turns
between. The proposal narrows the subtask-list scope to that
between-region rather than enumerating arbitrary work.
