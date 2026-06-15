---
cwd: /home/bukzor
color: pink
session:
  uuid: 7e61d259-3c6c-4c3d-9786-7d7cdb4caa07
  started: 2026-05-15T12:45:00-05:00
  ended: null
---
# Rename must-read.d → must-read.kb (personal home, 2026-05-15)

Executed the .d → .kb rename per
`~/.claude/CLAUDE.rename-must-read-d-to-must-read-kb.Task.md`.
The originating skill design lives at `must-read-kb-skill.md`
(bukzor-agent-skills cwd); this session is the personal-home rollout.

## Completed

- Pre-rename housekeeping: three focused commits absorbing in-flight
  unrelated edits in target files (`eaea88d` CLAUDE.md refinements,
  `72fd86b` settings.json refactor, `acfdade` session-end ARGUMENTS,
  `d9a1aa1` must-read.d content overhaul continuation).
- Rename itself: `21f8179` (added new `must-read.kb/` paths + updated
  8 operational references) and `d9d7617` (pruned old `must-read.d/`
  paths — split from 21f8179 because `commit-staged` with only the
  destination path included only the addition half of each rename).
- Step 4 reload + trigger-firing test passed via
  `claude --model haiku --print` — fresh session sees `must-read.kb/`
  at the allowed path; `before/ANY-shell-commands.md` fires from the
  new path on shell-tool invocation.
- Indexed both Task.md artifacts under `~/.claude/`
  (committed `dfc047f`): `restructure-must-read-dirs.md` for the
  earlier `bfdb5cb` restructure, and updated `must-read-kb-skill.md`
  to move the rename from Live Follow-Ups to Completed.
- Workflow improvements committed by parallel session as `ba089e8`
  ("sessions.kb: schema strict-shape, normalized session.uuid,
  command integration") — absorbed my edits to
  `commands/session-start.md` (`$ARGUMENTS` taskfile branch,
  `.template.md` reference, search recipes), `commands/session-end.md`
  (mangled-list repair, `.template.md` reference), and the new
  `sessions.kb/.template.md`.

## Live Follow-Ups

- `extract-sessions-kb-to-private-repo.md` — planned session entry
  for isolating sessions.kb churn from the dotfiles repo.
- `fix-git-partial-commit-staged-rename-pair.md` — tool bug surfaced
  by this session's rename (forced the d9d7617 follow-up commit).
- `settle-sessions-kb-conventions.md` — design questions surfaced
  during the workflow polish (`session.ended` workflow, Task.md
  tracking convention, slug-match prefix variants).

## Notes

- Existing `must-read-kb-skill.md` (cwd:
  `/home/bukzor/repo/github.com/bukzor/bukzor-agent-skills`) covers
  the skill design + lists this rename as a completed follow-up. This
  entry is the personal-home cwd's mirror, capturing the execution
  and the emergent workflow polish.
- `session.uuid` matches `$CLAUDE_CODE_SESSION_ID` at session-end.
