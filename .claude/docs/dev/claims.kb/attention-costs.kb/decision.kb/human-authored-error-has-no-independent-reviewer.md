---
label: HUMAN_ERROR_UNCATCHABLE
standing: agent
why:
  - ./review-is-a-real-cost-of-delegating.md
---

# Asking the operator converts catchable error into uncatchable error

Content the operator authored is often treated as needing no review, on
the grounds that they approved it by writing it. That is true of *intent*
and not of *consequence*: they wrote what they meant, and may have meant
something wrong.

The difference from agent error is not rate but **who can catch it**.
Agent output has an independent reviewer — the operator. Operator output
has none, and re-reading one's own text is not review; the same model that
produced the error evaluates it.

So asking does not remove error from the system. It moves error from a
channel with a checker to a channel without one, and for some classes of
mistake — a wrong assumption, a misremembered constraint — that is the
worse trade.

Signed and unmeasured. The corpus contains no ground truth about which
party was right, so the relative rates are unknown; what is claimed here
is the asymmetry in detectability, which follows from there being one
reviewer rather than from any count.
