---
label: INPUTRC_RESIDUAL
standing: agent
todo: true
why:
  - ../components.md
  - ../architecture.kb/generated-inputrc-index.md
---

# `~/.inputrc` is hand-written: readline settings plus one `$include`

Settings (`bell-style`, the 8-bit flags) and
`$include ~/.config/sh/intent.d/terminal-keys/inputrc`. The eight
lines restating readline defaults are dropped; semantic bindings live
in shell legs.
