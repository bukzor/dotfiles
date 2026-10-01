---
source: user
status: firm
see-also:
  - failure-modes.kb/additive-rather-than-revisionary-editing.md
  - case-study.kb/additive-vs-revisionary-skill-edit.md
---

# Benefit-per-token as the edit quality criterion

When the user asks for an edit, the user evaluates the result by the
ratio of (information value of the document) to (token count). A good
edit raises the ratio; an acceptable edit holds it constant; an edit
that lowers the ratio fails the criterion regardless of whether the
new content was correct in isolation.

Operationally: an edit that *adds* content typically lowers the
ratio (the document gets longer; if the new content shares territory
with existing prose, value rises less than length). An edit that
*revises* — rebalances structure, removes duplication, tightens
prose — typically raises the ratio. Adding will rarely meet the
criterion; revising usually does.

The user's framing this session: "what's the benefit-per-token ratio
of this edit? of the skill as a whole before and after? It's lower.
It should be higher, or at least not-lower. As such (and this
*really should go without saying, and normally does when you're not
in low-iq mode) *adding* text will never meet criteria. Evaluate
the document, holistically, and consider *revision* that meets
requirements."

The convention applies to all document-editing tasks the user
delegates. It is not negotiable on a per-edit basis — the criterion
is consistent. A future Claude evaluating its own edit against the
criterion before submitting can catch additive-style failures
preemptively.
