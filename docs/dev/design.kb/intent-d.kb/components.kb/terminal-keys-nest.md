---
label: TERMINAL_KEYS
standing: agent
todo: true
why:
  - ../components.md
  - ../architecture.kb/rank-rule.md
  - ../../../sh-config-loading.claims.md
---

# `terminal-keys/` resolves sequences to named keys; every keybind that uses them is its child

Legs: `inputrc` (the `\e[1~`-style normalization block) and `zshrc`
(today's `030-zkbd.sh`, and the `bindkey_zkbd` helper, kept defined).
Children: one intent per binding intent (`home-end/`, `backspace/`,
`up-down-local-history/`, ...), each with a `zshrc` and, where bash
needs more than a readline default, a `bashrc`. `edit-line-in-editor/`
(ctrl-g, vicmd `v`) needs no terminal keys and sits at top level.
