---
label: ATTENTION_COST
standing: user
authority:
  address: aa519804
  words: >-
    What i'm trying to get to is (to enable) a system that estimates the
    change in overall cost and/or debt of various actions, and only taking
    those that have good likelihood of reducing debt by more than the cost.
  about: what this ledger is for
ontology:
  - attention
  - turn
  - episode
  - task
non-claim-tokens:
  - API
  - CLAUDE
  - TTL
  - HOME
why:
  - ../claims.md
stale-when: agent pricing or the caching model changes such that replayed context is no longer billed per turn
last-updated: 2026-09-16
---

# Attention costs

An agent and the person it works with spend the same thing in different
currencies. **Attention** is that thing: tokens the model reads and writes,
minutes the person reads and writes. Priced in dollars, the two become
comparable, and a choice between them becomes an arithmetic instead of a
posture.

This theory exists to make that arithmetic possible at the moment of
choice — before the work, when only a guess is available — and to say how
accurate the guess can be, which turns out to be the binding constraint.

Three words are stipulated here because all four theories below need them:

- a **turn** is one API request and its response, which is what gets
  billed; it is not a conversational exchange;
- an **episode** is one person-authored message and every turn the agent
  takes before yielding back — a median of 6.4 turns here;
- a **task** is the unit an agent contemplates delegating or doing, which
  may be an episode, a session, or a subagent run.

## The theories

```
measurement ──► cost-structure ──► estimation ──► decision
      └───────────────────────────────────────────────┘
```

| Theory | Holds | Stale when |
|---|---|---|
| `measurement` | how the corpus was obtained and what it does and does not see | the transcript format stops recording per-request usage |
| `cost-structure` | how a token's price depends on when it enters the context | context stops being replayed per turn |
| `estimation` | what can be predicted before acting, and how well | an estimator is fitted on predictions rather than outcomes |
| `decision` | when to spend agent attention instead of the operator's | review stops being the operator's job |

The order is the order of justification: nothing about structure is
claimed without the measurement that establishes it, and no decision rule
is stated without the estimator accuracy that bounds it.

## What the ledger concludes

Three findings carry the rest, and each cost a reversal to reach.

1. **Quote the strip, not the tip.** A token's real price is its entry
   cost plus its replay cost over every remaining turn — so the same
   context is several times more expensive read early than read late
   (`STRIP_PRICE`, `QUOTE_THE_STRIP`).
2. **The conversion is not the bottleneck.** Turning an estimated size
   into dollars is worth about two points of accuracy; estimating the
   size is worth forty. Every refinement past a coarse size call is
   effort spent on the wrong factor (`CONVERSION_IS_CHEAP`).
3. **Delegation is gated by reversibility, not by size.** The cost model
   says delegate almost always; what it does not price is damage already
   done when a wrong answer was acted on, and that term is unbounded for
   anything that cannot be undone (`REVERSIBILITY_GATES`).

Together they say: judge task size coarsely, convert cheaply, and spend
the saved effort on whether the work can be taken back.

## Making an estimate

The claims below are what is true; this is how to use them. Three tiers,
and the first is usually enough.

**Quick — no arithmetic.** Sort the task into one of four log-spaced
buckets by what it will cost: **under $0.50 / $0.50–3 / $3–15 / over
$15**. That is 43% error and two thirds of all available accuracy
(`TSHIRT_BOUND`). Between two buckets, take the smaller: overestimating
costs three times more than underestimating (`SIZE_ERROR_ASYMMETRY`).
Then compare against the operator's time at **$2.50/minute**
(`HUMAN_RATE`) — or skip the dollars entirely and ask whether the agent
will take less than **7x** as long as they would, on Opus
(`HOURLY_COMPARISON`).

**Better — one multiplication.** Estimate turns, then
`$/turn[model] x turns^1.13` (`MODEL_REQUIRED`, `SUPERLINEAR`). Estimate
for the whole task, never for one message (`TASK_SCALE`). Worth doing
only where the quick call landed near a threshold, since the conversion
is worth about two points and the size judgement is worth forty
(`CONVERSION_IS_CHEAP`).

**Best — start and watch.** Run it, measure the opening turns, extrapolate
the rest (`SELF_CALIBRATION`): 23% error and 91% within a factor of two.
After about twenty turns the task's own rate beats the table, so no
parameters are needed at all. Reserve this for the tail — the tasks over
$10, where being wrong costs more than the measuring.

Before any of it, check `REVERSIBILITY_GATES`: if the work cannot be
taken back, no estimate licenses delegating it.

Estimating a **new** input, rather than using these: report its oracle
accuracy *and* its guessability, never one alone
(`PREDICTABLE_ISNT_USEFUL`). Two candidates that pass the first test and
fail the second are already recorded, so they need not be rediscovered —
output tokens and generation time (`CLEAN_TIME_IS_OUTPUT`).

## Regenerating every number

No constant here is quoted from memory. `claude-tokens-params` emits all
of them, and each claim names the section that produces it:

```sh
claude-tokens | claude-tokens-cost > costed.tsv
claude-tokens-params --rates --warmup --estimators --rework < costed.tsv
```

The functional forms outlive the fit; the constants track this operator's
task mix, working-context size and `CLAUDE.md`, and drift as any of those
change. Re-run before leaning on a number, not before reading one.
