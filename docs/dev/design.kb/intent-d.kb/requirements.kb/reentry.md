---
label: REENTRANT
standing: agent
why:
  - ../requirements.md
  - ../../../sh-config-loading.claims.md
---

# Every leg is idempotent and every entry point re-runs the loader

Contexts are re-entered (a tmux shell skips `.profile`;
`alias login="source ~/.profile"`), so the loader resets its
loaded-set on entry and legs tolerate a second sourcing.
