---
cwd: /home/bukzor/claude/homedir-archeology
session:
  uuid: 6e8223d3-e99c-4f60-b5a4-1035c95a8f59
  started: 2026-05-16T17:39:01-05:00
  ended: null
---
# Bash heredoc instruction regression (2026-05-16)

Detour from a `find ~` iteration session: noticed Claude still
hand-wraps every Bash call in `bash <<'BASH' ... BASH`, even though
the PreToolUse hook at `~/.claude/hooks/bash-preamble.py` already
does that wrapping. Traced it to a stale instruction in
`~/.claude/must-read.kb/before/using-claude-code-tool/Bash.md`.

## Facts established

- The hook is live: `~/.claude/settings.json` registers
  `.claude/hooks/bash-preamble.py` as a PreToolUse on Bash. Its
  output is the `+$ bash` line you see prepended to every Bash
  tool result.
- `a66e11c` (2026-03-10 11:54) introduced the hook and made two
  doc changes:
  - REMOVED `### heredocs` from `Bash.md` (now redundant with hook).
  - ADDED `### Redirects` to `ANY-shell-commands.md` capturing
    `cmd 2>&1 | pipe` being broken in claude-code.
- `acd7a5a` (2026-03-10 12:08) follow-up to the hook: enforce
  deny/ask permissions, add doctests. Code only. Good.
- `287c1fb` (2026-03-10 16:16) **byte-perfect undo of a66e11c's
  doc changes**:
  - RE-ADDED the `### heredocs` block to `Bash.md`
    (`index d3bb656..eecd947` reverses morning's `eecd947..d3bb656`).
  - REMOVED the `### Redirects` block from `ANY-shell-commands.md`
    (`index aa2a08b..e654fc9` reverses morning's `e654fc9..aa2a08b`).
  - Commit message frames both as new ("drop redirect section, add
    heredoc requirement"). No acknowledgment of morning's changes.
  - Author signature "Claude" (not "Claude Opus 4.6" like morning) --
    suggests a different session that didn't see the morning's work.
- `64efc6c` (2026-03-10 16:16:29) -- 3 seconds after 287c1fb, same
  "Claude" signature -- adds Python type annotation norms. Different
  scope, no reverts. Cursory read: fine.

## Verdict

Both halves of 287c1fb are wrong. The afternoon session reverted
a66e11c's doc changes without seeing them, presumably because it
read the docs in their pre-hook state and applied "common sense"
fixes that contradict the hook architecture.

## Resolution

- 2026-05-16: Reverted both halves of 287c1fb in
  `~/.claude/must-read.kb/`. Committed as `a4d0113` in `~/`.
- Audit of adjacent commits (Mar 9-12 window in `~/`): a66e11c,
  acd7a5a, 287c1fb, 64efc6c. Only 287c1fb is bad. 64efc6c
  (Python conventions, +3s after 287c1fb, same "Claude" co-author)
  is a separate scope -- not reverted; cursory review fine.
- Transcript forensics attempted via
  `grep -Rl 287c1fb ~/.claude/projects/`. Originating transcript is
  purged. Oldest match is from 2026-04-29, six weeks after the
  commit. The transcripts that DO match are downstream sessions
  that later referenced the commit, not the originator.

## What we still don't know

The prompt that triggered the bad session is lost. We can't tell
whether the user asked for "improve shell docs" or Claude proposed
the changes. The session's cwd is unknown. The session's model is
unknown (co-author was just "Claude", suggesting a model that
didn't write its name into the trailer).

Future recurrence prevention: when changing must-read docs, first
`git log -p` on the file to see recent edits in case a prior
session removed the very thing you're about to add back.

## Notes

- The parent session work (`find ~` find-command iteration in
  `/home/bukzor/claude/homedir-archeology`) is paused, not abandoned.
