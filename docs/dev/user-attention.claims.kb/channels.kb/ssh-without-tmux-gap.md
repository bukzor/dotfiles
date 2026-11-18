---
label: SSH_GAP
standing: open
why:
  - ../principles.kb/no-channel-covers-every-population.md
---

# Is a Plain-SSH, No-tmux, Long-Lived Session a Real Population Here?

`NO_SINGLE_CHANNEL` names this as the population `SHELL_START_WARNING`
alone would have to cover: a session with no always-on surface to
poll, that also outlives its shell-start trigger. Whether that
population actually occurs on this machine -- an SSH session left open
for days without tmux -- was never measured, unlike `LONG_LIVED_PANES`
for the tmux case. If it doesn't occur in practice, this is a
non-issue; if it does, it's a coverage gap no current channel closes.
