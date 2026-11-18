---
label: HOURLY_COMPARISON
standing: bare
why:
  - ./the-operator-bills-at-150-an-hour.md
  - ../estimation.kb/the-model-is-the-one-parameter-worth-keeping.md
verify: "claude-tokens | claude-tokens-cost | claude-tokens-params --rates"
---

# An agent hour against an operator hour

**An Opus agent costs about $21/hr against the operator's $150, so it
may take seven times as long and still be the cheaper route.**

Quoted per hour, agent and operator become directly comparable, and the
threshold is a time ratio rather than a dollar total:

| model | $/hr of session | may take up to |
|---|---|---|
| sonnet-5 | $9 | **16.5x** your own time |
| opus-5 | $21 | **7.0x** |
| haiku-4-5 | $17 | 8.7x |
| fable-5 | $31 | 4.8x |
| fable-5-1 | $36 | 4.2x |

**An Opus agent may take seven times as long as you and still be the
cheaper route.**

Two readings of "agent hour" exist and answer different questions. Per
hour of *session* — the table above — includes the operator's own typing,
which is right for "what will an hour of us working together cost". Per
hour of *generation* excludes it and runs higher (Opus $31/hr), which is
right for "what did the agent's work cost". The first is the one the
delegate-or-not decision wants.

The p10–p90 spread on these rates is 2–4x, so the ratios are good to
about ±50% — enough for a 7x threshold, not enough to rank Haiku against
Opus on price.
