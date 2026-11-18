---
source: user
status: tentative
see-also:
  - user-conventions.kb/surety-threshold-and-posterior-updates.md
  - failure-modes.kb/eyes-shut-guessing-under-rejection.md
  - proposal-realignment-via-subtask-list.md
  - open-questions.kb/codify-spectrum-not-singular.kb/CLAUDE.md
---

# Spectrum, not singular

The proposed principle: in the face of uncertainty, treat answers,
parses, and inferences as a *spectrum* — a distribution over
candidates — rather than as a *singular* point estimate. Narrow the
spectrum to a single candidate only when posterior on that candidate
exceeds threshold (the user's stated threshold elsewhere is 80%).

The principle is offered as a meta-rule that subsumes several
existing rules and failure modes. The 80% threshold becomes the
threshold for collapsing a distribution to a point estimate.
Rejection lowers posterior on the rejected candidate; the natural
follow-up is to recompute the distribution before committing — a
confident second guess is a fresh collapse, fine when posterior
justifies it, wrong when it's momentum. Listing alternatives under
uncertainty is making the distribution visible; picking one without
listing is an unearned collapse.

The session evidence for what the principle would catch is in
`failure-modes.kb/eyes-shut-guessing-under-rejection.md`. The
principle's codification location is open; candidates and tradeoffs
are enumerated in
`open-questions.kb/codify-spectrum-not-singular.kb/`.
