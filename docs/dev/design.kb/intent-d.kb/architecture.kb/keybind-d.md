---
label: KEYBIND_D
standing: user
verdict: superseded
why:
  - ../goals.kb/intent-first-axis.md
authority: "session df89c432, 2026-09-19: \"I'd like to not have both inputrc.d and keybind.d if we can help it. They have the same purpose, no?\""
---

# ~~A `keybind.d/` beside the shell rc directories~~

The first intent-first proposal, scoped to keybindings (20 counted,
7 both-shell). Superseded by `intent.d/`: a keybind is an intent like
any other, and a separate directory for one kind of intent is the
consumer-first axis returning.
