---
label: DECISION
standing: agent
ontology:
  - mode
  - checkpoint
  - checkpoint interval
  - review
  - debt
  - reversibility
why:
  - ./estimation.md
  - ./measurement.md
stale-when: review stops being the operator's own job, or agent errors stop being caught by reading the result
---

# decision — spending agent attention instead of the operator's

A task can be attacked three ways, and the operator named them: hand it to
a subagent, ask the operator for the whole answer, or work it turn by turn
in session.

> [!@bukzor] aa519804
>
> when considering a task, there's three ways it might be attacked:
> 1. a subagent call — zero (immediate) user cost, only llm costs
> 2. a monolithic elicitation of user response — only human-effort costs,
>    no (additional) llm costs
> 3. a session-setting — a back-and-forth between user and llm

These are not three kinds of thing. A **checkpoint** is a point where a
person reads what the agent produced and can stop it; the three **modes**
differ only in how many there are, and `MODES_ARE_REVIEW_RATE` is that
identification. So the real variable is the **checkpoint interval** —
turns of agent work per **review** — and choosing a mode is choosing a
value for it.

Cost has four terms, not one: the agent's tokens, the operator's review
minutes, the work thrown away when a checkpoint catches an error, and the
damage when none does. The first is the smallest. The last is unbounded
where the work cannot be taken back, which is what **reversibility**
grades, and is why `REVERSIBILITY_GATES` overrides the arithmetic rather
than feeding into it.

**Debt** is expected future work, in the same minutes and dollars as
everything else, which is what lets a prospective action be judged against
it at all. Estimating it is harder than estimating cost, and that
asymmetry is the theory's last claim (`DEBT_DOMINATES`) and its practical
upshot: spend estimation effort on the debt side.
