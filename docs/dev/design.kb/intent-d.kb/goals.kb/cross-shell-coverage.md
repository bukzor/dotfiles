---
label: COVERAGE_GOAL
standing: user
why:
  - ../goals.md
authority: "session df89c432, 2026-09-18: \"I plan to move back to zsh someday soon. Figure out a cross-shell solution\""
---

# Every behavior is expressed for every shell it applies to

An intent that applies in bash and zsh has a leg for each, and an
intent with a leg missing is a visible gap, listable as
`ls intent.d/*/zshrc` against `ls intent.d/`. The shell migration is
that diff.
