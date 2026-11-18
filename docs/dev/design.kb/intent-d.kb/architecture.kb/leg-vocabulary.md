---
label: LEG_VOCAB
standing: agent
why:
  - ../architecture.md
  - ../../../sh-config-loading.claims.md
  - ../requirements.kb/filetype-detection.md
---

# A leg is a file named for its context, from a closed list

`env.sh` (every invocation) · `login.sh` (login shells) · `rc.sh`
(interactive, any shell) · `bashrc` · `zshrc` · `inputrc` ·
`tmux.conf` · `init.lua`. A leg may require only legs whose context
contains its own (GUARD_MONO): `bashrc` may require `env.sh`; `env.sh`
may not require `bashrc`. `login.sh` replaces the earlier `profile`,
which nvim does not detect (FT_DETECT).
