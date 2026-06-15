---
cwd: /home/bukzor/repo/github.com/bukzor/bukzor-agent-skills/llm-kb
color: green
session:
  uuid: a4c67e67-cbc2-405c-ae75-2c81c5d609d8
  started: 2026-05-13T21:30:43-05:00
  ended: 2026-05-15T18:41:27-05:00
---
# skeleton-default (2026-05-13 → 2026-05-15)

## Through-line

Canonical schemas live in `llm-subtask/skeleton/.claude/`; consuming
skills hand-copy from there. The SKILL.md gained a recovery line that
makes this the default behavior when a `.kb/` is missing its schema.

## Completed

- Meta-review of `docs/dev/procedures.kb/post-mortem.md` produced 9
  critiques; 4 generalizable ones distilled into `SKILL.kb/`'s
  must-read triggers + audits + procedures.
- `git mv` `post-mortem.md` from `docs/dev/procedures.kb/` to
  `SKILL.kb/procedures.kb/` (consumer-facing). Inbound references
  updated.
- `git mv` `llm-collab/{idea,todo}.jsonschema.yaml` to
  `llm-subtask/skeleton/.claude/{ideas,todo}.jsonschema.yaml`
  (consolidating canonical home; rename `idea → ideas` for plural
  match with the `.kb/` dir).
- Installed schema copies at each consuming skill's `.claude/`
  (llm-kb, llm-subtask, llm-collab).
- Quoted `@value` everywhere it was unquoted (skeleton template + 3
  pre-existing llm-collab entries).
- Added `__pycache__/` and `*.pyc` to top-level `.gitignore`; trashed
  the stray `lib/python/llmd/__pycache__/`.
- Added recovery line to `llm-kb/SKILL.md`:
  > "No schema found" for `ideas.kb`/`todo.kb`: copy from
  > `llm-subtask/skeleton/.claude/`.
- Migrated `sessions.kb/` corpus to the `session: { uuid, started,
  ended }` nested shape; `session` + `{started, ended}` now required
  with load-bearing null. Filled all entries.

## Live Follow-Ups

- `reconcile-seed-case-study.md` (sibling sessions.kb entry) — the
  consequential next session; the originating distillation work the
  May 13 devlog flagged. Strategic todo at
  `llm-kb/.claude/todo.kb/2026-05-15-000-reconcile-seed-case-study-may-13-har-browse-rust-port.md`.
- Tactical follow-ups in `llm-kb/.claude/todo.md` (move
  reconcile-case-study.md into SKILL.kb, verify tests/, etc.).
- Drift risk from per-skill schema copies is enumerated in
  `llm-kb/.claude/todo.kb/2026-02-09-000-schema-reuse-with-ref.md`
  ("Drift surface" section).

## Notes

- Session spans two days because of an idle period; `started` is when
  I first oriented to the work, not when the user first messaged.
- Final validator state: 94 files / 0 errors across llm-{kb,
  subtask, collab} + `~/.claude/{sessions,ideas,todo}.kb/`.
- All work committed and pushed (5 commits in bukzor-agent-skills,
  2 in dotfiles).
- Devlog: `llm-kb/docs/dev/devlog/2026-05-15-000-skeleton-default-schema-centralization.md`.

## Postscript (2026-05-21)

The "Installed schema copies" line above is true literally — copies
were placed at each consuming skill's `.claude/`. But the copies
shipped **permissive**: they lack the `managed-by` block (so
`managed-by` was not required), they don't define the cross-skill
fields (`required-reading`, `suggested-reading`, `related-effort`)
that real downstream files use, and they set
`additionalProperties: true`. That made the schemas unable to
enforce the design intent ("`managed-by` is fully
jsonschema-controlled and required via a const definition") and let
deprecated fields like `anthropic-skill-ownership: llm-subtask`
persist in two `llm-kb/.claude/ideas.kb/` files unnoticed.

The remaining work — strict `managed-by` const everywhere, schema
propagation byte-identical from the skeleton, and 8 data-file
migrations — is captured at
`~/.claude/sessions.kb/strict-managed-by-schema-propagation.md`.
