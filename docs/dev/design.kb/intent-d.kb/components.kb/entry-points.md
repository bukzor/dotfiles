---
label: ENTRY_POINTS
standing: agent
todo: true
why:
  - ../components.md
  - ../architecture.kb/root-intent.md
  - ../requirements.kb/reentry.md
---

# Each entry point sets its context list, resets the loaded-set, and requires the tree

`.profile`: `env.sh login.sh` (then `.bashrc` if bash). `.zshenv`:
`env.sh`. `.bashrc`: `env.sh rc.sh bashrc`. `.zshrc`: `env.sh rc.sh
zshrc`. Each sources `functions.sh` first (ROOT_INTENT); HOME/USER
bootstrap stays inline in `.profile` as the root's own prerequisite.
`profile.d/` is deleted; its PATH default is `path/env.sh`'s first line.
