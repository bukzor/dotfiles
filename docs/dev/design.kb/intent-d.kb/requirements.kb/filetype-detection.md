---
label: FT_DETECT
standing: user
why:
  - ../requirements.md
verify: "nvim --headless -c 'echo &ft' -c q <file> for each leg name in LEG_VOCAB, all non-empty"
authority: "session df89c432, 2026-09-19: \"filenames TBD, mainly I'd want vim filetype to Just Work on them\""
---

# Every leg name is detected by nvim without local ftdetect

Measured 2026-09-19: `inputrc` -> readline, `bashrc` -> sh, `zshrc` ->
zsh, `rc.sh`/`env.sh`/`login.sh` -> sh, `tmux.conf` -> tmux,
`init.lua` -> lua. Bare `profile`, `bash`, `shrc`, and `*.inputrc`
detect nothing and are excluded from the vocabulary.
