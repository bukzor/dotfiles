---
label: PUSH_ATTEMPTS_LOGGED
standing: agent
why:
  - push-coverage-is-instrumentation-bound.md
---

# Every Push Attempt Is Logged, Whether Or Not It Landed

A push channel fires from inside the process raising the event, which
has no way to confirm the user actually saw it -- `notify-send`
returning success means dbus accepted it, not that anyone read it
before dismissing it. Logging every attempt, tagged with which
transport carried it, is what makes `PUSH_BOUNDED_BY_CALLSITES`'s gap
askable after the fact: not just "did this fire" but "from where, by
what path, and did it reach a live transport."

`bin/alert` logs every call to `~/.local/state/alert.jsonl` regardless
of which transport succeeded, precisely for this reason
(commit `f2b773d`, rationale in
`docs/dev/devlog/2026-09-10-001-tmux-window-naming--a-precedence-ladder--not-a-program-list.md`).

The log is bounded (newest ~500-1000 lines, `ALERT_LOG_DESYNC`), so
"after the fact" means the recent past, not all history.
