---
name: claude-code-surgery
description: "Agent MUST load on /claude-code-surgery, when a Claude Code session or subagent refuses to resume (SendMessage: stopped-by-user) or keeps dying on a poisoned transcript tail, or before hand-editing anything under ~/.claude/projects (transcripts, meta.json, session state)."
---

# Claude Code surgery

The write-side sibling of `Skill(claude-code-archeology)`: that skill
reads the record; this one alters it. Editing `~/.claude/projects` is
editing the harness's memory of what happened — done carelessly it
destroys the only durable record of the work, done well it revives
agents the harness has written off.

Read the patient first, with archeology's tools — never operate on a
transcript you haven't parsed.

## Tools

The `claude-code-archeology` package (bukzor-tools) carries the
write-side pair; prefer them over hand-rolled scripts — they encode
the iron rules below as refusals:

- `claude-jsonl-truncate FILE (REF | --match REGEX) [--write | --in-place]`
  — the tail cut. Dry-run by default; either mode refuses a cut that
  strands a `tool_use`, suggesting the nearest clean boundary.
  `--write` lands the kept prefix as a NEW session (fresh id, records
  retargeted, path on stdout) — safe even on a live session, since
  the original is never opened for writing. `--in-place` keeps the
  file's own id — required when the id is load-bearing (a subagent's
  `agentId`; a session whose `subagents/` must stay reachable) — with
  liveness guard, backup-first, byte-identical kept lines, and
  `--repoint-leaf` for a kept `last-prompt` anchored in the dropped
  era. `--check` diagnoses a tail without naming a cut.
- `claude-agent-unstop PATH` — clears `stoppedByUser` from an agent's
  meta.json (backup first) and reports whether the transcript tail is
  clean enough to resume.

Installed by `uv tool install bukzor-tools`; or run as
`uv run --project ~/repo/github.com/bukzor/bukzor-tools <cmd>`.

## Iron rules

- **Operate only on a stopped writer.** The jsonl must be mtime-static
  and the agent not running; the files are append-only and a live
  writer will corrupt or resurrect what you cut.
- **Back up before any edit** — transcript AND meta.json, to the repo's
  `trash/` (recoverable), not `/tmp`.
- **Records are 1:1 with lines.** Surgery is line surgery: parse and
  assert every line at the boundary (`json.loads`, check `uuid`,
  content) before writing anything. Never text-edit blind.
- **Never leave a dangling `tool_use`.** A cut must end on a clean
  record — assistant text, or a completed `tool_result`. When in doubt
  cut the whole turn; the agent redoes it from disk state.
- **Cut, don't rewrite.** Fabricating a `tool_result` the run never
  produced poisons the record; truncation only removes.
- **After surgery, brief the resume.** Name what the agent last saw
  ("that error was a harness bug, since fixed"), tell it to trust its
  on-disk state over recollection, restate the deliverable.

Surgery pays off in proportion to how ledger-shaped the agent's work
was: state on disk means a cut costs one turn, not the run.

## Worked cases

`ls skill.kb/` — one file per operation actually performed.
