---
label: REVIEW_SCALES_WITH_ARTIFACT
standing: agent
why:
  - ./review-is-a-real-cost-of-delegating.md
  - ./the-checkpoint-interval-is-constant-in-task-size.md
---

# Review cost follows the artifact, which is why long delegations pay

Agent cost grows linearly with turns. Review cost grows with the *result*
— a diff, a summary, an answer — which grows far more slowly. A five-turn
delegation and a fifty-turn delegation both hand back one thing to read.

That asymmetry is the real argument for delegating, and it is stronger
than the token argument. Tokens are the small term against `HUMAN_RATE`:
27 turns of Opus is $2.35 against a single minute of operator attention at
$2.50. What delegation actually buys is **fewer readings of intermediate
state**, and intermediate state is where the operator's minutes go.

It also explains the shape of `CHECKPOINT_INTERVAL`. Review enters the
cost as `H.r.k` — proportional to the *number* of checkpoints and not to
the work between them — and that is exactly the assumption that makes the
optimal interval constant.

The assumption has a limit worth naming: it holds while the artifact
stays reviewable. A delegation returning a 2,000-line diff has an `r`
that is no longer constant, and has quietly moved the cost back into the
term delegation was supposed to avoid.
