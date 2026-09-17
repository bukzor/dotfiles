---
label: POLL_BEATS_TRIGGER
standing: agent
why:
  - trigger-decay-with-session-age.md
  - long-lived-panes-are-the-population.md
---

# Polling an Always-On Surface Beats a Trigger, for Long-Lived Sessions

Where a population's sessions are long-lived, a polling channel tied
to a surface that's continuously visible regardless of what the
session is doing -- a status line redrawn on a timer, not a shell
prompt that only redraws on use -- reaches that population where a
trigger channel (`TRIGGER_DECAY`) can't. The cost is a bounded delay
(one polling interval) in place of trigger's bounded miss (everything
after the triggering instant); for a nightly job, seconds of delay
against days of silence is not a close call.

Grounds: `docs/dev/adr/2026-09-10-001-tmux-status-bar-cron-alerting.md`
-- tmux's `status-right`, redrawn every `status-interval` (15s)
independent of pane activity, closes exactly the gap `TRIGGER_DECAY`
names for this machine's tmux-pane population.

This doesn't require the surface be a terminal status line
specifically -- any continuously-rendered, timer-refreshed surface
qualifies (a window-manager bar, a desktop widget). tmux's status line
is what this machine has.
