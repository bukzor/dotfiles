#!/bin/sh
# Scheduled jobs die where nobody looks: anacron writes its timestamp whether
# the job worked or not, and logrotate-cron's log only ever grows. Report a
# non-zero last exit when a shell starts, which is somewhere you do look --
# though only once, at init, so a pane that outlives this check (tmux panes
# routinely run for days) won't see a job that fails later. tmux's status-right
# covers that gap by polling the same data continuously; see
# docs/dev/adr/2026-09-10-001-tmux-status-bar-cron-alerting.md.
"$HOME/bin/cron-status" | while read -r cron_code cron_job cron_log; do
  warn "cron job failed ($cron_code): $cron_job -- $cron_log"
done
:
