---
cwd: /home/bukzor/repo/github.com/bukzor/bukzor-agent-skills/llm-kb
session:
  started: null
  ended: null
---
# Schema reuse with `$ref`

Distinct line of work surfaced during the skeleton-default session.
Full plan and rationale in
`.claude/todo.kb/2026-02-09-000-schema-reuse-with-ref.md`, with the
live drift surface enumerated at the bottom of that file.

## Decisions recorded 2026-05-18

URI scheme + architecture decisions captured in the todo's
"Decisions (2026-05-18)" section:

- Cross-skill references use `agent-skill://<skill>/<path>` —
  anchored to Anthropic Agent Skills open standard.
- Migration architecture: stub-`$ref` first (each project keeps a
  1-line schema file `$ref`-ing the skill-owned source); data-side
  `$schema` as an optional later layer.
- Validator behavior: walk `~/.claude/skills/*/` for `*.jsonschema.yaml`
  on startup, index by `$id`, resolve `agent-skill://` URIs in-memory.

Source-of-truth path: see homedir-archeology's
`.claude/reference.kb/sweh-schema-source.md`.

## Current pressure (updated 2026-05-18)

Six copies of the canonical idea/todo schemas now exist across
`llm-{kb,subtask,collab}` and `llm-subtask/skeleton/.claude/`. Two
hash families today (skeleton with `managed-by` const; skill-local
without). Each schema file grew ~50 lines on 2026-05-18 when
`cost-of-delay-2w` + `sweh-value.confidence` landed — the dup tax
just got materially worse.

Re-rate owed on the todo's SWEH: existing `timebox: 1, benefit-2w: 1`
predates today's expansion; `cost-of-delay-2w` value pending user
input (per `observation.kb/sweh-ratings-need-recalibration.md` in
homedir-archeology).

## Likely shortcut

The validator already wraps `jsonschema.Draft202012Validator` (recently
extended for `date`/`instant` types). That library natively supports
`$ref` resolution through its `referencing` registry — the todo's
"add `$ref` resolution" step may be considerably smaller than written.
Investigate library defaults before implementing custom resolution.

## Tests are downstream

`llm-kb/tests/` are manual scenarios (movie-tracker), not automated.
Schema-reuse work can land without breaking those, but adding a
unit-test directory for the validator would be a defensible scope
extension while inside this code.
