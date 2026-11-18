---
label: ALERT_LOG_DESYNC
standing: open
why:
  - ../principles.kb/logged-attempts-audit-push-delivery.md
---

# Does the Audit Log Stay True When Logging Itself Fails?

`log_alert` runs after the notification has already gone out, under
`set -e`: if `mkdir`, `jq`, or the append itself fails, `bin/alert`
exits non-zero on an alert that *did* reach the user, and that
delivery leaves no record. `PUSH_ATTEMPTS_LOGGED` assumes the log is
what's left to ask afterward -- untested here is whether the log can
itself go missing exactly when the thing it exists to audit
succeeded. Noted as an open question at introduction (same devlog as
`ALERT_PUSH`), not yet resolved either way.
