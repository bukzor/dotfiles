---
managed-by: Skill(llm-subtask)
status: done
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

Committed `d24a3b1`. The seeding bash-conventions split (the model — see Stays)
committed separately in `f3939d9`. All `requires:` verified resolving.

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

### Tier B — partial extraction (core stays a trigger; medium confidence) — DONE 2026-06-03

- [x] `before/making-code-changes.md`: workflow steps 1–6 stay as the trigger;
  "Inline Trivial Wrappers" + "Comments Target a Cold Reader" →
  `design-rules.kb/{inline-trivial-wrappers,comments-target-a-cold-reader}.md`
  (one principle per file); "Bulk Operations" → `reference.kb/bulk-edits.md`.
  Trigger `requires:` all three — `design-rules.kb` has no auto-load path, so the
  explicit requires preserves the at-the-moment guarantee. Broadened
  `design-rules.kb/CLAUDE.md` scope line to cover code-craft, not only API/type.
- [x] `before/claude-code-development.md`: `#13003` frontmatter-stripping bug →
  `reference.kb/claude-md-frontmatter.md`; skill-loading pointer stays as the
  thin trigger, `requires:` the reference.

### Tier C — borderline / low confidence — RESOLVED: leave as-is 2026-06-03

Decision (user's "your call"): none clear the bar of a clean recurring trigger
whose body is a portable topic corpus. All three are harness-flow-bound, so they
stay where they fire.

- [x] `before/using-claude-code-tool/Bash.md`: subshell/`parallel` notes are
  tool-usage at-the-moment guidance, not a portable bash corpus — leave.
  (Superseded 2026-06-03: folded into `before/running-ANY-Bash-commands.md` —
  two triggers were splitting the match for the same moment.)
- [x] `before/using-claude-code-tool/Edit.md` (24w): tiny quirk — leave.
- [x] `before/lazy-loading/{commands,mcp,skills}.md`: catalog tables are bound to
  harness loading flow; not standalone topic references — leave.

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

- [x] Every moved topic body is the single authority in `reference.kb`; name = scope
- [x] Every remaining `before/` trigger is thin and `requires:` its reference
- [x] No broken `requires:`/"see"/frontmatter pointers (grep clean across
  `must-read.kb`, `reference.kb`, `commands/`, `skills/`)

## Notes

Lowest-ripple first: `toon-format` (no referrers), `bukzor-python-tdd` (one
referrer). Highest-ripple: the two `git/` files (referenced from `commands/`
frontmatter). Related theme — see
`todo.kb/2026-05-15-000-rename-outmoded-d-dirs-to-kb-case-by-case-eval.md`.
