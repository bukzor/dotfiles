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
