---
label: ALERT_LOG_DESYNC
standing: agent
verify: grep -q 'could not write alert log' ~/bin/alert && grep -q flock ~/bin/alert && echo present
why:
  - ../principles.kb/logged-attempts-audit-push-delivery.md
---

# A Logging Failure Warns; It Never Fails a Delivered Alert

`log_alert` runs after the notification has already gone out. Formerly,
under `set -e`, a failing `mkdir`, `jq`, or append made `bin/alert` exit
non-zero on an alert that *did* reach the user -- and the callers (LLM
tool calls, backgrounded jobs) see only the exit status. Resolved
2026-11-18: `log_alert` returns on any step's failure and the caller
turns that into a stderr warning, naming the transport that delivered;
the exit status stays 0. Tested with an unwritable `HOME` and with `jq`
hidden from `PATH`.

What remains true: a failed write still leaves that delivery
unrecorded, so the log can be missing an entry for a delivered alert --
but the warning on stderr is now the trace, and the failure no longer
spreads to the caller.

Retention, same change: past 256 KiB (about 1000 lines) the log is cut
to its newest 500 lines; append and trim share one `flock`, the trim is
tmp-file + rename. Tested with 3000 appends at 8-way parallelism: file
stayed under the bound, every line valid JSON, none lost below the
bound. `PUSH_ATTEMPTS_LOGGED` therefore promises the recent past, not
all history.

[!DRAFT] 2026-11-18, agent-authored; the retention numbers are
vetoable.
