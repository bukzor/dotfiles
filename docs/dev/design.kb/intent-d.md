---
label: INTENT_D
standing: agent
why:
  - ../sh-config-loading.claims.md
ontology:
  - intent
  - leg
  - context
  - prerequisite
  - rank
  - root
non-claim-tokens:
  - PATH
  - EDITOR
  - TERM
  - HOME
stale-when: "`~/.config/sh` has a directory the six words above cannot name, or a leg name outside LEG_VOCAB"
---

# intent.d -- the interactive shell environment, organized by intent

`~/.config/sh` is loaded as a tree of **intents** (directories, one per
behavior of the environment), each expressed by **legs** (files whose
names are the **contexts** they apply in), ordered by **prerequisite**
(`Y requires X`), spelled either by nesting or by **rank** (a numeric
prefix), with the **root** intent (`functions.d/`) sourced by the entry
points by hand. What is true of that structure and why is the flat
ledger `../sh-config-loading.claims.md`; this record is what the dotfiles
commit to, on four rungs: `goals`, `requirements`, `architecture`,
`components`. Deliverables are tracked as work, not design:
`~/.claude/todo.kb/`.

Origin: session `df89c432` (2026-09-18/19), entry
`~/.claude/sessions.kb/penguin.kb/shell-config-intent-first-loader.md`.
