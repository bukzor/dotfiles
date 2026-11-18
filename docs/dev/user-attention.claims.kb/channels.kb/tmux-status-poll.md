---
label: TMUX_STATUS_POLL
standing: bare
verify: tmux show -g status-right; tmux show -g status-interval
why:
  - ../principles.kb/poll-beats-trigger-for-long-sessions.md
---

# tmux Status-Line Poll

`.tmux.conf`'s `status-right` embeds `#(~/bin/cron-status --tmux)`,
redrawn every `status-interval` (15s) for every attached client,
independent of any pane's shell activity. A polling channel tied to
tmux's status line, the always-on surface `POLL_BEATS_TRIGGER`
describes -- added 2026-09-10 specifically to close the gap
`SHELL_START_WARNING` leaves for `LONG_LIVED_PANES`. Not
screen-verified end-to-end at introduction (`tmux display-message -p`
can't observe a `#()` job's output synchronously); `verify:` here
checks the wiring is live, not that the glyph has been seen.
