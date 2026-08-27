#!/bin/sh
# Scheduled jobs die where nobody looks: anacron writes its timestamp whether
# the job worked or not, and logrotate-cron's log only ever grows. Report a
# non-zero last exit when a shell starts, which is somewhere you do look.
# (`status` is read-only in zsh -- hence the prefixed names.)
__cron_status_report() {
  cron_dir="$HOME/.local/state/cron"
  for cron_file in "$cron_dir"/*.status; do
    [ -e "$cron_file" ] || continue # glob matched nothing
    cron_code=''
    read -r cron_code < "$cron_file" || :
    if [ -n "$cron_code" ] && [ "$cron_code" != 0 ]; then
      cron_job=${cron_file##*/}
      cron_job=${cron_job%.status}
      warn "cron job failed ($cron_code): $cron_job -- $cron_dir/$cron_job.log"
    fi
  done
  unset cron_dir cron_file cron_code cron_job
  return 0
}
__cron_status_report
unset -f __cron_status_report
