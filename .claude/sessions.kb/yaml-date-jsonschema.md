---
cwd: /home/bukzor/repo/github.com/bukzor/bukzor-agent-skills/llm-kb
session:
  uuid: 9dcb2df1-1f06-4bc2-b5c8-b3e634e3065e
  started: null
  ended: null
---
# yaml-date-jsonschema (2026-05-15)

The session that bootstrapped this collection. Started from the
question "is there any 'good' way to jsonschema a yaml datetime?"
and expanded into a rename and an index.

## Completed

- KbValidator extended with `date` and `instant` custom types
  (commit 5d64413 in bukzor-agent-skills/llm-kb). Naive datetime
  is intentionally rejected; the rationale is in
  `lib/python/llmd/frontmatter_validate.py`.
- `.d/` → `.kb/` rename across complete-example and the devlog
  tools dir (commit 799eb02). 7 directories renamed, 18 reference
  files updated.
- Rename todo updated with progress (commit d59458b).
- `.claude/ideas.jsonschema.yaml` committed (commit cb315b3); the
  schema was already in use on disk but untracked. Done on a
  branch session (uuid dca7da65-d65c-43de-b345-87fa6518d630).
- This collection's `CLAUDE.md` opening reframed: dropped the
  contradictory `one file = one session` axiom so the judgment
  criteria are primary.
- This collection (`~/.claude/sessions.kb/`) created and seeded
  with five follow-up entries (commit d288b9a in bukzor/dotfiles).
- Schema grew a `session: { uuid, started, ended }` block. `started`
  and `ended` accept `[instant, "null"]` -- the new `instant` type
  put to immediate use. Top-level `session-uuid` removed; `uuid`
  lives inside `session` now (committed in ba089e8, dotfiles).
- `commands/session-{start,end}.md` amended with sessions.kb
  maintenance steps (find-or-create entry, propose new entries
  for surfaced follow-ups, rules of thumb for when to capture)
  (committed in ba089e8, dotfiles).
- Validator (`lib/python/llmd/frontmatter_validate.py`) now skips
  dotfiles (`.template.md` etc.) in addition to `CLAUDE.md`
  (committed in ecfb6fd, bukzor-agent-skills).
- Authored Task file
  `~/.claude/CLAUDE.integrate-sessions-kb-into-llm-subtask.Task.md`
  for a follow-up session to integrate sessions.kb into
  Skill(llm-subtask) and evaluate relocating
  `/session-{start,end}` into the skill (commit 5a5f54a, dotfiles).

## Live Follow-Ups

Sibling entries in this directory derived from this session:

- `rename-rollup-d-to-kb-doc-references.md`
- `auto-migrate-scripts-for-kb-dirs.md`
- `schema-migrate-string-pattern-to-date.md`
- `finish-debolding-cleanup.md` (pre-existing work surfaced here)

(`finish-skill-kb-refactor.md` was a fifth seed entry; absorbed
elsewhere and deleted.)

## Minor noted

- `sessions.jsonschema.yaml` `session.uuid` description currently
  reads "Absent for planned or proposed sessions that have not been
  started yet." Since the strict shape made `session.started: null`
  the canonical "planned but not begun" signal, the uuid wording is
  no longer load-bearing -- could be tightened to just "absent until
  the session is actually run." Left as a doc nit, not behavior.

Delete this entry once those follow-ups are absorbed and there is
no remaining reason to point back at the originating session.
