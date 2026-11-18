---
label: NO_SINGLE_CHANNEL
standing: agent
why:
  - poll-beats-trigger-for-long-sessions.md
---

# No Single Channel Covers Every Population

A machine's sessions aren't one population. At minimum: tmux-attached
(where an always-on polling surface exists) and not (a plain SSH
shell, a script, a cron job's own subshell -- nothing to poll). An
attention design keeps at least one trigger channel, which covers a
session's birth regardless of whether it ever gets an always-on
surface, alongside at least one polling channel, which covers a
session's entire life where such a surface exists. Neither replaces
the other; `POLL_BEATS_TRIGGER` says polling wins where both are
available, not that triggers are obsolete.

Grounds: `docs/dev/adr/2026-09-10-001-tmux-status-bar-cron-alerting.md`
kept `.config/sh/rc.d/cron-status.sh` running alongside the new tmux
poll rather than retiring it, on exactly this reasoning.
