---
label: ALERT_PUSH
standing: bare
verify: grep -q log_alert ~/bin/alert && grep -q notify_hterm ~/bin/alert && echo present
why:
  - ../principles.kb/push-coverage-is-instrumentation-bound.md
  - ../principles.kb/logged-attempts-audit-push-delivery.md
---

# `bin/alert`: a Push Channel With Transport Fallback

`bin/alert` is invoked by whatever command wants attention -- an LLM
tool call finishing, a long-running build, a backgrounded job -- and
tries three transports in order until one succeeds: `notify-send`
(dbus, crostini's route to the ChromeOS notification center),
`notify_hterm` (OSC 777 written to each tmux client's tty), then the
terminal bell. `alert-slack` is deliberately excluded from the
fallback chain -- leaving the machine is a decision, not a fallback
(commit `d47ccda`).

Its population is `PUSH_BOUNDED_BY_CALLSITES`'s: whoever calls
`alert`, not any structural set of sessions. Real usage so far
(`~/.local/state/alert.jsonl`, 3 entries, all 2026-09-10) shows only
the `notify-send` transport exercised in practice.

The title identifies the caller by reading `#{window_name}` back out
of tmux, deferring to whatever the window-naming precedence ladder
(`docs/dev/devlog/2026-09-10-001-tmux-window-naming--a-precedence-ladder--not-a-program-list.md`)
already resolved, rather than re-deriving a second, possibly-disagreeing
answer.
