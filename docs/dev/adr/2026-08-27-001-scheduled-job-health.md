# Scheduled job health

**Date:** 2026-08-27
**Status:** Accepted

## Context

[2025-11-21-000] put daily maintenance on user-space anacron. Two of those jobs
then failed every run for months without anyone noticing:

- `pnpm-update` exited non-zero 35 consecutive times, starting the run after it
  upgraded pnpm past its own configuration.
- Both jobs then stopped running entirely when an errexit bug in `.profile`
  killed them before they reached their logging wrapper.

Nothing in the system could have said so. anacron writes its timestamp whether
the job succeeded or not, so its state directory reports "ran today" for a job
that has never worked. `logrotate-cron` captures output faithfully, but into a
file whose only reader is someone already suspicious. The failure was found by
typing an unrelated command at a shell prompt, three and a half months in.

## Decision

**A scheduled job records its exit status where something else can read it.**
`logrotate-cron` writes `~/.local/state/cron/<job>.status` after the run. It no
longer `exec`s the job, because it has to outlive it.

**A failing job is reported at shell start.** `.config/sh/rc.d/cron-status.sh`
warns about any non-zero status file. A daily job that breaks is seen the next
time a terminal opens, not the next time someone goes looking.

**Job health is a test.** `.config/anacron/cron-health_check.sh` asserts that
every job in the anacrontab has a status file, that each records 0, and that
none is older than a week -- a job that stopped running looks identical to a
job that runs and fails, from the log. It joins the `*_check.sh` fan-out, so
`redo test` fails on rot that no one has looked at yet.

**The log stays an archive, not an alarm.** It was never going to be read in
time, and that is fine as long as it isn't the only record.

**A job not worth fixing is deleted, not tolerated.** A red status that nobody
intends to act on trains everyone to ignore the yellow line at login.

## Alternatives Considered

### Mail on failure
The traditional cron answer, and the reason cron failures are ignored
everywhere. There is no mail spool being read on this machine.

### Trust anacron's timestamp
It's already there, and it's already the thing that lied. anacron has no
concept of job outcome, so making it the signal would require patching anacron
rather than the wrapper.

## Consequences

**Positive:**
- The three-month blind spot closes to about one day (login) or one test run.
- The status files are trivially machine-readable by anything else later.

**Negative:**
- Adding a job makes `cron-health_check.sh` fail until that job first succeeds.
  That is accurate, and clears itself.
- A machine left off for over a week fails the staleness assertion.

## Related

- Extends: `docs/dev/adr/2025-11-21-000-user-space-anacron-for-laptop-scheduling.md`
- Motivating failure: [2026-08-27-000] -- the pnpm upgrade that broke itself
- Implements: `bin/logrotate-cron`, `.config/sh/rc.d/cron-status.sh`,
  `.config/anacron/cron-health_check.sh`

[2025-11-21-000]: 2025-11-21-000-user-space-anacron-for-laptop-scheduling.md
[2026-08-27-000]: 2026-08-27-000-pnpm-11-global-tooling-mechanism.md
