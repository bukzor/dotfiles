---
label: LONG_LIVED_PANES
standing: bare
verify: tmux list-panes -a -F '#{pane_pid}' | xargs -r ps -o etime= | sort -r | head -1
---

# Long-Lived Panes Are the Population

The sessions this machine's attention channels actually have to reach
are, overwhelmingly, tmux panes running `-bash` or `-zsh` for days to
weeks without a restart -- not freshly-started shells. Measured
2026-09-10 via `tmux list-panes -a` cross-referenced with
`ps -o pid,lstart,etime,cmd`: the panes in daily use were 6-17+ days
old. `verify:` re-checks the current longest-lived pane's elapsed time;
a healthy re-run still reports days, not minutes.

This is the fact a trigger-channel design has to be checked against,
not assumed compatible with.
