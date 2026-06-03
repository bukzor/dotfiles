---
managed-by: Skill(llm-subtask)
status: planned
---

# Migrate topic-reference docs from must-read.kb to reference.kb

**Priority:** Medium
**Complexity:** Medium
**Context:** Continues the `reference.kb` extraction begun with
`ANY-shell-commands.md` → `reference.kb/bash-conventions.md` and
`when/rust/arc-seems-unnecessary.md` → `reference.kb/rust/arc-seems-unnecessary.md`.

## Problem Statement

`reference.kb` is newer than `must-read.kb` and defines a clean split:
- **`must-read.kb`** = the *trigger system* — fires automatically on a situation
  (`before`/`when`/`after`); body is a thin imperative for that moment.
- **`reference.kb`** = authoritative knowledge about a scoped *topic* (a noun),
  pulled in on demand via `requires:`.

Several `before/` docs have trigger-shaped names but topic-corpus bodies. They
should follow the bash precedent: move the knowledge to `reference.kb`, leave a
thin trigger that `requires:` it.

**Discriminator:** name points to a situation + body says what to do now →
stays. Body is a corpus of facts about a tool/format/language → knowledge moves.

## Decisions (resolved with user 2026-06-03)

- **Wholesale vs. split:** split only files with a *clean recurring* auto-trigger
  worth its slot in start-of-session `ls -RF`. Strained / low-value / infrequent
  triggers just move wholesale; references get fixed as-needed.
- **Layout:** mixed flat+subdir is fine. Prefer a subdir over repeated file
  prefixes once a domain has (or will plausibly have) ≥3 files. Inside a subdir,
  drop the redundant domain prefix from filenames (dir already states scope):
  `reference.kb/python/style.md`, not `python/python-style.md`.
- A `reference.kb` file `requires:` other *references* (e.g. `bash-conventions.md`),
  never a `must-read.kb` trigger (that arrow points the wrong way).

## Implementation Steps (ordered by certainty — highest first)

### Tier A — clear movers (bash-precedent shape, high confidence) — DONE 2026-06-03

Staged (working tree; not committed — awaiting user). All `requires:` verified resolving.

Wholesale (no stub left):

- [x] Move `before/toon-format.md` → `reference.kb/toon-format.md`
    - [x] Fix external referrer: `~/lib/pythonpath/bukzor/to_toon.py:17` hardcoded path
- [x] Move `before/bukzor-python-tdd.md` → `reference.kb/python/tdd.md`
    - [x] Update referrer: `before/writing-tests.md:3` → `reference.kb/python/tdd.md`
- [x] Move `before/writing-redo-or-.do-scripts.md` → `reference.kb/redo-do-scripts.md`
    - [x] Repoint `requires:` to `reference.kb/bash-conventions.md`; de-triggered header

Split (thin stub stays, `requires:` the reference):

- [x] Split `before/writing-python-code.md` → `reference.kb/python/style.md`
    - [x] Thin stub `requires:` it; testing-linkage kept in stub (was reference→trigger)
- [x] Split `before/rust-programming.md` → `reference.kb/rust/tooling.md`
    - [x] Thin stub `requires:` it; updated `before/lazy-loading/mcp.md` referrer
- [x] Split `before/git/ANY-git-command.md` → `reference.kb/git/conventions.md`
    - [x] Stub stays at same path; `commands/` frontmatter referrers still resolve
- [x] Split `before/git/commit.md` → `reference.kb/git/commit.md`
    - [x] Stub keeps pre-commit checklist + untracked-file disposition; reference
      `requires:` `git/conventions.md` (was the backwards `./ANY-git-command.md`)

### Tier B — partial extraction (core stays a trigger; medium confidence)

- [ ] `before/making-code-changes.md`: keep workflow steps 1–6 as trigger;
  extract "Language-Agnostic Style" → `design-rules.kb`, "Bulk Operations cost
  optimization" → `reference.kb`
- [ ] `before/claude-code-development.md`: extract CLAUDE.md frontmatter-stripping
  bug (anthropics/claude-code#13003) → `reference.kb`; skill-loading pointer stays

### Tier C — borderline / low confidence (decide, may leave as-is)

- [ ] `before/using-claude-code-tool/Bash.md`: tool conventions (subshells,
  `parallel`) → fold into bash reference vs. leave
- [ ] `before/using-claude-code-tool/Edit.md` (24w): tiny quirk — likely leave
- [ ] `before/lazy-loading/{commands,mcp,skills}.md`: catalog tables are
  reference-ish but harness-flow-bound — lean leave

## Stays (genuine triggers — firing IS the value; no action)

- All of `when/`: contested-position, inconsistent-instructions,
  wanting-to-comply-but-cannot, why-claude-behavior, cwd-wsl.localhost
- All of `after/`: Bash-call-failure, proc-transport-endpoint
- `before/creating-visual-art.md` (already a thin stub)
- `before/writing-tests.md` (red-green is an at-the-moment procedure)
- `before/writing-bash-scripts.md` (already split — the model)

## Open Questions

(both resolved 2026-06-03 — see Decisions above)

## Success Criteria

- [ ] Every moved topic body is the single authority in `reference.kb`; name = scope
- [ ] Every remaining `before/` trigger is thin and `requires:` its reference
- [ ] No broken `requires:`/"see"/frontmatter pointers (grep clean across
  `must-read.kb`, `reference.kb`, `commands/`, `skills/`)

## Notes

Lowest-ripple first: `toon-format` (no referrers), `bukzor-python-tdd` (one
referrer). Highest-ripple: the two `git/` files (referenced from `commands/`
frontmatter). Related theme — see
`todo.kb/2026-05-15-000-rename-outmoded-d-dirs-to-kb-case-by-case-eval.md`.
