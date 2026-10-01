---
label: PRIVATE_OVERLAY
standing: agent
todo: true
why:
  - ../components.md
  - ../architecture.kb/prerequisite.md
  - ../../../sh-config-loading.claims.md
---

# `private-dotfiles` is an ordinary intent with named outputs

`login.sh` mounts; `env.sh` sources the private env. Intents that
need a private value `require private-dotfiles`; nothing else does. An
overlay that may override anything cannot be required for anything in
particular, which is why it is demoted.
