---
label: REVIEW_COSTS_HUMAN
standing: user
authority:
  address: aa519804
  words: >-
    there's a hidden human-cost there. It takes effort to review and/or
    validate subagent work. And there's opportunity costs to account for if
    agent was wrong and we've already acted on it.
  about: what a cost model of delegation must include beyond tokens
---

# Delegated work must be reviewed, and acting on it early costs more

A cost model of delegation must count the operator's minutes spent
reviewing what came back, and the damage from having acted on a wrong
answer before finding out — not only the agent's tokens.

> [!@bukzor] aa519804
>
> there's a hidden human-cost there. It takes effort to review and/or
> validate subagent work. And there's opportunity costs to account for if
> agent was wrong and we've already acted on it.

A cost model counting only tokens concludes "delegate almost always",
and it reaches that conclusion by omitting two terms:

- **review** — the operator's minutes spent reading and validating what
  came back, paid on every delegation whether or not anything was wrong;
- **damage** — the cost of unwinding work that was acted on before the
  error was found, paid only sometimes and unbounded when it is.

Both are the operator's attention, so both are priced by `HUMAN_RATE` and
belong in the same arithmetic as the tokens. The first is what makes the
checkpoint interval finite; the second is what `REVERSIBILITY_GATES`
takes out of the arithmetic altogether.
