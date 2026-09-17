---
label: SHELL_START_WARNING
standing: bare
verify: grep -n 'case \$- in' ~/.bashrc ~/.zshrc
why:
  - ../principles.kb/trigger-decay-with-session-age.md
  - ../principles.kb/no-channel-covers-every-population.md
---

# Shell-Start Warning

`.config/sh/rc.d/cron-status.sh`, sourced from `.bashrc`/`.zshrc` only
for interactive shells (`case $- in *i*)`) and only once, at init. A
trigger channel (`TRIGGER_DECAY` applies directly): covers the instant
a shell is born, silent for the rest of that shell's life. Kept
deliberately (`NO_SINGLE_CHANNEL`) rather than retired when
`TMUX_STATUS_POLL` was added, because it's the only channel that
reaches a session with no always-on surface to poll -- a plain SSH
shell, say.
