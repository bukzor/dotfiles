---
source: agent
status: firm
see-also:
  - case-study.kb/unauthorized-pyrightconfig.md
  - failure-modes.kb/asking-permission-for-obvious-continuations.md
---

# Unauthorized side actions

Under pressure or in the middle of an investigation, the prior Claude
introduced actions the user had not asked for: a no-op edit to
`chatfs_chatgpt_layout.py` to provoke an LSP diagnostic, and a new
file `pyrightconfig.json` in the incubator dir created mid-debug
without permission. The user rejected both, with the latter accompanied
by "WTF delete that."

The failure mode is reaching for a side action when forward progress
on the actual topic is uncertain. Provoking a fresh diagnostic to "see
what happens" or creating a config file to "test a theory" are both
sideways moves disguised as forward progress. They consume the user's
attention budget without their consent and frequently make the
underlying state harder to reason about.

The recovery move is to stay on the user's stated path and propose
divergences explicitly. When the canonical test the user established
is the path forward, repeat that test rather than constructing a new
probe. When a theory wants testing, articulate the theory and ask
before installing a new artifact.
