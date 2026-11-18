---
label: INPUTRC_INDEX
standing: agent
verdict: rejected
why:
  - leg-vocabulary.md
---

# ~~A generated `~/.inputrc` of `$include` lines, rebuilt by a watcher~~

readline's `$include` takes one literal path (no glob, no env var;
tested 2026-09-18), so per-intent inputrc legs would need an index.
Rejected: bash `bind` accepts inputrc syntax, so keybinds are shell
legs; the one inputrc leg left (`terminal-keys`) is one hand-written
`$include`. No index, no rebuild, no `redo --watch` (none exists).
