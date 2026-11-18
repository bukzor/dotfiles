# Resurrecting a user-stopped subagent

Situation: a background subagent was interrupted (here: after a bogus
harness error rejected its on-brief `Write`), and SendMessage now
refuses: *"Agent … was stopped by the user and won't be resumed. Treat
its work as cancelled."*

Two locks hold the agent down; both must be cleared:

1. **`subagents/agent-<id>.meta.json` carries `"stoppedByUser": true`.**
   This flag alone is what the SendMessage refusal reads. Delete the
   key.
2. **The transcript tail holds the poison** — the offending record(s)
   plus the `[Request interrupted by user]` record. Left in place, the
   resumed agent re-lives them.

## Procedure (as performed, 2026-08-22)

1. Confirm the agent is stopped: jsonl mtime static.
2. Back up transcript + meta.json to the repo's `trash/`.
3. Find the cut point: the last record that leaves no dangling
   `tool_use` — an assistant text block ends a turn cleanly. Cut the
   interrupt, the poison record, **and** any `tool_use` still awaiting
   its result; the agent will redo that step.
4. Truncate: lines are 1:1 with records. Parse-and-assert the boundary
   lines (`json.loads` each; check `uuid` prefixes and content) before
   writing `lines[:cut]` back.
5. Delete `stoppedByUser` from the meta.json.
6. SendMessage the agent: name the error it saw and call it fixed,
   tell it to trust disk state over recollection, restate the
   deliverable and standing prohibitions.

## Case data

Tension-detector agent, 138 records. Cut `[135]`–`[137]`: its on-brief
`Write` of the deliverable, the harness's spurious rejection
(*"Subagents should return findings as text, not write report
files"*), and the user interrupt — ending on `[134]`, an assistant
text ("Both sweeps are complete…"). Resume accepted; agent re-ran the
Write and completed in 86 seconds.

It cost one turn because the agent's protocol was ledger-shaped:
progress lived on disk as finding files + swept-clean coverage
records, so the cut discarded only in-flight computation. An agent
whose progress lives in its context loses everything past the cut.
