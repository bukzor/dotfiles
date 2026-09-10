# Devlog: 2026-09-10 — claude-rename: a hook is the only way into a live session name

## Focus

Let an agent name the session it runs in. `/name` and `/rename` are
CLI-local commands no tool can submit, so `bin/claude-rename` had to find
another way in. Two sessions: `dc68d8a7` (Opus 5) did the discovery and
shipped a two-mechanism tool; `821c5c1c` (Fable 5.1) reviewed it, verified
the claims against the binary, and collapsed it to one mechanism.

## What `/rename` does (2.1.267, reverse-engineered)

Three writes, one routine (`RAe(name, source, ...)`): a `custom-title`
record and an `agent-name` record appended to the session jsonl,
`projects/<project>/<session-id>/custom-title.json` rewritten, and the
peer-registry entry `~/.claude/sessions/<pid>.json` updated with
`name`/`nameSource`. The TUI displays `currentSessionAgentName`, held in
process memory and re-stamped into the transcript on every metadata burst
-- so a record written by another process is overwritten within a turn.

## Decisions

### Rename through a `UserPromptSubmit` hook's `sessionTitle`

**Rationale:** the CLI applies a hook's `sessionTitle` through the same
`RAe` routine as `/rename` (log line `Hook sessionTitle applied`), so it
reaches the in-memory name. `claude-rename` writes
`~/.claude/rename-requests/<session-id>`; `.claude/hooks/session-rename.py`
consumes it at that session's next prompt. Verified live twice (once per
session; registry shows `nameSource: hook`).

**Alternatives considered:**

- *Headless resume*, `claude --resume ID -p '/rename NAME'` -- the first
  commit's whole mechanism. It updates what the `--resume` picker shows
  and nothing the live session displays. Kept for one commit as a
  "stopped session" branch behind a registry probe, then dropped: the hook
  path also covers a stopped session (the request waits for its next
  resume), and the original goal was never stopped sessions.
- *Peer socket* -- its message vocabulary has no set-name command.
- *CLI subcommand* -- none of the 15 names a session.
- *Direct transcript/registry writes* -- overwritten by the re-stamp.

### Accept that the rename lands at the next prompt

Only `SessionStart` and `UserPromptSubmit` accept `sessionTitle`, of 22
hook events; no tool-level hook does. Renaming mid-turn would mean
fabricating a prompt, which writes junk into the transcript. Structural,
not a shortcoming to fix.

## Conventions Established

- Hooks are captured at startup (`setup_hooks_captured`) -- yet a hook
  registered mid-session did fire here without restart. Don't rely on
  either belief without checking; the 45 MB `strings` dump of the binary
  answers such questions in seconds (`python -c` over it; `grep -o` with
  wide context backtracks for minutes on the minified lines).

## Open Questions

- `rename-requests/` entries for sessions never resumed accumulate.
  Harmless (one-line files) and not worth a sweep.

## References

- Commits `3499b1b` (headless resume) and `edc7ee2` (hook path) on
  `bin/claude-rename`.
- `docs/dev/devlog/2026-07-24-000-Claude-Code-branch-recovery--extract-by-leaf--not-by-carve.md`
  for the same reverse-engineering method on transcript loading.
