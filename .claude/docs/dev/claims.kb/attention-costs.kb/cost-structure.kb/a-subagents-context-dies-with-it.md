---
label: DELEGATION_TRUNCATES_R
standing: bare
why:
  - ./what-adding-a-token-actually-costs.md
---

# Delegation is cheap because it truncates remaining turns

A subagent's context is its own and ends when it returns. Tokens read
inside it therefore carry a small `R` — bounded by the subagent's own
length rather than the parent session's — and by `STRIP_PRICE` their cost
falls in proportion.

This is the mechanism behind the observation that delegated work is
several times cheaper per token of instruction than the same work done
in-session. It is not that subagents are more efficient per turn; the
per-turn rates are the same model at the same prices. It is that the
parent never replays what the subagent read.

The corollary is the useful part: **the saving comes from the context not
returning, so it survives only if the subagent reports a summary rather
than its transcript.** A delegation that hands back everything it read has
moved the tokens, not avoided them.
