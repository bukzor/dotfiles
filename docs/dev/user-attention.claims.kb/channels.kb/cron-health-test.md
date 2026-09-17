---
label: CRON_HEALTH_TEST
standing: bare
verify: test -x ~/.config/anacron/cron-health_check.sh && echo present
why:
  - ../principles.kb/no-channel-covers-every-population.md
---

# Cron Health Test

`.config/anacron/cron-health_check.sh` asserts every scheduled job has
a fresh, zero-exit status file. Neither a trigger nor a poll: a
**demand channel**, firing only when something explicitly asks
(`redo test`). Its population is whoever or whatever runs the test
suite -- a third population `SHELL_START_WARNING` and
`TMUX_STATUS_POLL` don't cover and don't need to, since this one does.
