#!/bin/sh
# Every anacron job must have succeeded, recently. anacron's own timestamp is
# written whether the job worked or not, so it cannot answer this; the status
# files written by logrotate-cron can. A job whose status file is missing has
# never completed since the machinery was added.
set -eu
here=$(dirname "$0")
repo=$(cd "$here/../.." && pwd)
. "$repo/lib/sh/assert.sh"

state="$HOME/.local/state/cron"
if [ ! -d "$state" ]; then
  echo "skip: no scheduled-job state at $state" >&2
  exit 0
fi

anacrontab="$here/anacrontab"
jobs=$(awk '/^[0-9]/ {n++} END {print n + 0}' "$anacrontab")
statuses=$(find "$state" -name '*.status' | awk 'END {print NR + 0}')
assert_eq "every anacrontab job has a status file" "$jobs" "$statuses"

if [ "$statuses" -gt 0 ]; then
  failed=$(awk 'FNR == 1 && $0 != "0" {print FILENAME}' "$state"/*.status)
  assert_eq "every scheduled job last exited 0" "" "$failed"
fi

# A daily job that hasn't run in a week is as broken as one that exits 1,
# and looks identical from the log.
stale=$(find "$state" -name '*.status' -mtime +7)
assert_eq "every scheduled job ran within the last week" "" "$stale"

assert_done
