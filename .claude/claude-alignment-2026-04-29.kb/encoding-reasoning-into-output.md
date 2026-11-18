---
source: user
status: exploratory
see-also:
  - spectrum-not-singular.md
---

# Encoding reasoning into output (backlog idea)

**Status: noted by user near session end as a direction worth exploring,
not yet designed.**

The underlying problem: when asked later "why did you parse X as Y?",
the prior Claude generates a hypothesis from visible context rather
than recalling internal state. There is no internal state to recall —
the computation that produced the output is not preserved between
turns. Cause-stories generated this way are plausible but not
verified, and the prior Claude was observed to default to plausibility
without flagging that distinction.

The user's proposed direction: encourage agents to encode the
reasoning ("because Z") into output **while they're still live** —
during the same turn that produces the parse or action — rather than
relying on later reconstruction. The phrase the user used:
"*simulating* memory."

The mechanism is externalization. If the agent writes "I am parsing X
as Y, because Z" as part of the same turn that acts on the parse,
then the next turn (or any future agent) can recover Z from the
visible transcript instead of fabricating it. The cause becomes part
of the durable record, not an interpretation of behavior.

This is distinct from the existing "Before your first tool call,
state in one sentence what you're about to do" rule (which captures
*what*, not *why*). It is also distinct from `spectrum-not-singular`
(which captures *the candidate set*, not the *cause* of the chosen
candidate). All three principles point in the same direction —
encoding decision-relevant state into the visible transcript — but
each captures a different kind of state.

The user did not specify a mechanism for inducing this behavior
(prompt rule, skill, hook, response-template, etc.), nor whether it
should apply universally or only on costly inferences. Both are open.
