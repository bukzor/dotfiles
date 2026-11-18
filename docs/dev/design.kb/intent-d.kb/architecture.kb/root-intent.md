---
label: ROOT_INTENT
standing: agent
why:
  - ../architecture.md
  - ../../../sh-config-loading.claims.md
---

# `functions.d/` is the root intent, sourced by hand

Every intent requires the function library, so `~/.config/sh/` is
that intent and `intent.d/` its children. The entry points source
`functions.sh` themselves because the loader is defined inside it. Its
leg is a directory of one-function files, kept for the per-function
test harness.
