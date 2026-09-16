---
label: TRIANGULATION
standing: bare
why:
  - ./one-response-is-many-records.md
  - ./price-multipliers-on-the-base-rate.md
verify: "claude-tokens-cost vs `npx ccusage@latest --json` per closed day; claude-tokens-wire vs claude-tokens on shared request ids"
---

# The totals agree three ways

The arithmetic is confirmed by three checks that fail independently:

- **against `ccusage`**, exactly, on every closed day. The only
  discrepancy was a live-data race on the current day.
- **against the wire**, exactly, on requests both sides saw. The capture
  is an independent observer: it reads the API's own response bodies, not
  the client's record of them.
- **against the published rates**, by recovering each model's rate from
  `ccusage`'s own totals. All five in use reproduce to four decimals.

One earlier version of the wire check was circular and was discarded: it
validated a request/response pairing by comparing `output` tokens, which
both sides read from the same response body. The pairing was removed
entirely, and `claude-tokens-wire` now reads responses only — a response
states its own request id, model and usage, so nothing needs pairing.
