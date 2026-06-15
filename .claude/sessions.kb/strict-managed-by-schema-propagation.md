---
cwd: /home/bukzor/repo/github.com/bukzor/bukzor-agent-skills
session:
  uuid: null
  started: null
  ended: 2026-05-21T11:55-05:00
parent: skeleton-default.md
---
# Strict `managed-by` + Skeleton Schema Propagation

Planned. Spun out 2026-05-21 during the wsjf-rank tool-gap cleanup,
after the user clarified that:

- `managed-by` is intended to be **fully jsonschema-controlled and
  required via a `const` definition**.
- `anthropic-skill-ownership` is deprecated and replaced by
  `managed-by`.

The `skeleton-default.md` session (2026-05-13 → 2026-05-15) installed
schema copies at each consuming skill's `.claude/` but shipped them as
**permissive** (no `managed-by` block, `additionalProperties: true`)
rather than strict-with-const. This planned session closes that gap
and migrates the remaining data files to match.

## Why the gap matters

Without `managed-by` required-via-const, schemas can't enforce the
"this file follows the `llm-subtask` todo-file convention" contract.
With `additionalProperties: true`, schemas can't catch typos or
deprecated field names. Both leave the validator unable to flag the
exact drift this work is meant to prevent.

## Scope

### 1. Skeleton schemas (canonical)

`llm-subtask/skeleton/.claude/{todo,ideas}.jsonschema.yaml` —
update to the strict shape:

- Add `status` property (oneOf: `open`/`done`/`template`) with a
  per-const description so the lifecycle states are
  self-documenting.
- Add `required-reading`, `suggested-reading`, `related-effort`
  property definitions (these fields are already in real files;
  3 occurrences each across llm-collab/llm-kb todo+ideas).
- `required: ["managed-by"]` (already present in skeleton).
- `additionalProperties: false` (currently `true`).
- todo and ideas schemas should be byte-identical to each other.

### 2. Downstream copies

`llm-subtask/.claude/ideas.jsonschema.yaml`,
`llm-kb/.claude/ideas.jsonschema.yaml`,
`llm-collab/.claude/todo.jsonschema.yaml` —
replace contents byte-identical to the skeleton. The `managed-by`
const value is **invariant**: `Skill(llm-subtask)` everywhere, since
llm-subtask owns the todo/ideas file-format convention regardless of
which skill hosts the files.

### 3. Data-file migration

Two classes of fix, 8 files total:

**A. `anthropic-skill-ownership: llm-subtask` → `managed-by: Skill(llm-subtask)`** (2 files):

- `llm-kb/.claude/ideas.kb/2026-04-17-000-design-process-for-new-kb-structures.md`
- `llm-kb/.claude/ideas.kb/2026-04-17-001-codify-tables-lists-smell-as-kb-promotion-heuristic.md`

**B. Add `managed-by: Skill(llm-subtask)` to files that have other
frontmatter but lack the field** (6 files):

- `llm-collab/.claude/todo.md`
- `llm-collab/.claude/todo.kb/2025-11-26-001-add-ideasd-pattern-to-llm-collab-docs-skill-with-helper-script.md`
- `llm-collab/.claude/todo.kb/2025-11-26-003-clarify-the-relationship-between-todomd-and-todod-in-subtask-skill.md`
- `llm-collab/.claude/todo.kb/2025-11-29-000-reevaluate-devlog-purpose-and-structure.md`
- `llm-collab/.claude/todo.kb/2025-11-29-001-document-blocking-pattern-in-subtask-skill.md`
- `llm-collab/.claude/todo.kb/2025-12-03-000-pivot-from-d-to-kb-naming-convention-for-llmd-skill.md`

(Empty-frontmatter files are not affected — the validator skips
files without frontmatter, so no `managed-by` is required there.)

### 4. Validation

`llm-kb/bin/llm.kb-validate llm-subtask llm-collab llm-kb` should
report 0 errors when the migration is complete.

### 5. Drift-surface note

Update the `Drift surface` section of
`llm-kb/.claude/todo.kb/2026-02-09-000-schema-reuse-with-ref.md`:

- Record that 5 schemas are now byte-identical (was: 2 hash families,
  skeleton-with-managed-by + skill-local-without).
- Pre-existing pressure for `$ref` work intensifies: any further field
  addition now requires 5 hand-edits instead of 5 different surgeries.

## Current state (2026-05-21)

Partial work-in-progress in the bukzor-agent-skills working tree
(uncommitted):

- `llm-subtask/skeleton/.claude/todo.jsonschema.yaml`: status block
  added, `additionalProperties: false` set. Missing required-reading
  / suggested-reading / related-effort additions.
- `llm-subtask/skeleton/.claude/ideas.jsonschema.yaml`: same.

These edits are a subset of step 1 and can be discarded or built
upon. The schemas they produce are coherent in isolation (the
skeleton's example files have only `managed-by` + `status`, so they
validate under `additionalProperties: false`), but they don't
acknowledge the cross-skill fields that real downstream files use.

## Field landscape (2026-05-21)

Frontmatter field counts across todo+ideas in llm-subtask, llm-collab,
llm-kb (from `awk` over all `.claude/{todo,ideas}{,.kb/*}.md`):

| Field | Count | Status |
|-------|-------|--------|
| `cost-benefit-sweh` | 14 | in schema |
| `managed-by` | 11 | in schema (const) |
| `suggested-reading` | 3 | needs schema definition |
| `status` | 3 | added by this session |
| `required-reading` | 3 | needs schema definition |
| `related-effort` | 3 | needs schema definition |
| `anthropic-skill-ownership` | 2 | deprecated → migrate |

## Suggested execution order

1. Update skeleton schemas (1 commit per skeleton file or one for both).
2. Migrate 8 data files in one commit.
3. Propagate skeleton → 3 downstream copies in one commit.
4. Validate as the final step; if green, update the drift surface
   note in a separate commit.

Splitting commits this way lets a partial revert keep the most
valuable piece (schema improvement) while undoing the more invasive
piece (data migration) if needed.

## Related

- Parent: `~/.claude/sessions.kb/skeleton-default.md` (predecessor that
  installed the permissive copies).
- Related-effort: `~/.claude/sessions.kb/schema-reuse-with-ref.md`
  (planned $ref work that would obsolete the hand-propagation done
  here).
- Todo file: `bukzor-agent-skills/llm-kb/.claude/todo.kb/2026-02-09-000-schema-reuse-with-ref.md`
  ("Drift surface" section).
- Decision: `bukzor-agent-skills/llm-kb/.claude/decision.kb/agent-skill-uri-scheme.md`
  (the URI scheme for the eventual cross-skill $ref).

## Result (2026-05-21)

Completed. Four commits on `main`:

- `24850a9` — llm-subtask/skeleton: strict managed-by + status/reading
  fields (step 1: skeleton schemas, byte-identical todo+ideas)
- `c61191c` — todo,ideas: migrate frontmatter to managed-by:
  Skill(llm-subtask) (step 3: 8 data files)
- `7612398` — llm-{subtask,collab,kb}/.claude: propagate strict schema
  (step 2: 4 downstream copies, byte-identical to skeleton)
- `3bea19d` — todo.kb/schema-reuse-with-ref: drift surface — six
  byte-identical copies (step 5)

Validation (step 4): `llm-kb/bin/llm.kb-validate llm-subtask llm-collab
llm-kb` → 81 files, 0 errors.

### Brief vs reality

- Brief listed **3** downstream copies (`llm-subtask/.claude/ideas`,
  `llm-kb/.claude/ideas`, `llm-collab/.claude/todo`); actual count was
  **4** — `llm-kb/.claude/todo.jsonschema.yaml` has lived in the repo
  since the original centralization commit. Counted as 6 byte-identical
  copies in the drift-surface note (was 5 in the brief's estimate).
- WIP described in the brief ("status block added,
  `additionalProperties: false` set on the skeleton schemas") was
  effectively the whole step 1 + much of steps 2/3/5 — by the time the
  session resumed, the working tree already contained the full
  migration; only commit splitting and validation remained.
- Asymmetry preserved: `llm-subtask/.claude/` still has no
  `todo.jsonschema.yaml`, `llm-collab/.claude/` still has no
  `ideas.jsonschema.yaml`. Not blocking and not addressed here.

### Follow-ups

- `$ref` consolidation: drift pressure is strictly worse per change
  now (6 hand-edits per field addition vs. prior 2-shape surgery). The
  mitigation is tracked in
  `bukzor-agent-skills/llm-kb/.claude/todo.kb/2026-02-09-000-schema-reuse-with-ref.md`
  (decision B: stub-`$ref` resolution).
