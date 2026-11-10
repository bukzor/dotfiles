---
managed-by: Skill(llm-subtask)
cost-benefit-sweh:
  timebox:
    "@value": 1.5
    rationale: |
      ~15 .d/ candidates × ~5 min decide+rename+grep-references = ~1.25h.
      Beyond 1.5h, you've hit edge cases that deserve case-specific ADRs
      rather than rushing past them.
  benefit-2w:
    "@value": 2.0
    rationale: |
      Unblocks rust-port kb scope refactor (multi-h work that lands next).
      Removes recurring .d-vs-.kb naming ambiguity that costs ~5 min per
      occurrence × frequent over 2 weeks.
---

# Rename outmoded .d dirs to .kb (case-by-case eval)

**Priority:** Medium
**Complexity:** Medium
**Context:**
- `~/repo/github.com/bukzor/bukzor-agent-skills/docs/dev/adr/2025-12-11-001--unify-directory-naming-to-kb-suffix.md`
  (the ADR codifying the `.d/` → `.kb/` pivot)
- `~/.claude/CLAUDE.rename-must-read-d-to-must-read-kb.Task.md`
  (sibling task — `must-read.d/` rename is **out of scope here**)
- `~/repo/github.com/bukzor/bukzor-agent-skills/llm-kb/.claude/todo.kb/2026-01-02-000-complete-d-to-kb-rename.md`
  (in-repo equivalent for the `llm-kb` skill)

## Problem Statement

The convention for hive-partition-style knowledge collections has
pivoted from `*.d/` to `*.kb/`. Several directories at `~` scope still
use the legacy `.d/` suffix. Some of these *should* be renamed (they
are KB-style collections); others are legitimately `.d/` (systemd/
conf.d-style drop-in dirs, tool-imposed conventions). The work is to
walk every `.d/` under our control, classify it, and act.

## Current Situation

Inventory snapshot (re-run before acting; `find ~ -maxdepth 4 -type d
-name '*.d'`):

### Legitimately `.d/` — leave alone

Third-party / drop-in config conventions:

- `~/.vimrc.d/`, `~/.gitconfig.d/`
- `~/.config/sh/{rc,bashrc,functions,profile}.d/`
- `~/.config/cni/net.d/`, `~/.config/env/env.d/`
- `~/.gnupg/{public-keys,private-keys-v1,crls}.d/`
- `~/.terraform.d/`, `~/.pants.d/`
- `~/repo/git/terraform-provider-google/META.d/` (upstream)

### Candidate KB-style — evaluate and likely rename

Under `~/.claude/`:

- `~/.claude/builtin-context.d/`
- `~/.claude/docs/default-context/tools.d/`
- `~/.claude/system-prompt-patches.d/` (and nested `*/match.d/`)

Under `~/claude/` (research/notes):

- `~/claude/research.llm-filesystem-collab/{criteria,research-goals,decision-goals,problem-statement,requirements,research-methodology,research-data,research-execution-constraints}.d/`
- `~/claude/ai-coding-tools-facts.d/` and its nested children
  (`tools.d/`, `features.d/`, `providers.d/`, `architectures.d/`,
  `workflows.d/`, `comparisons.d/`, `dot-dee.d/`, `dot-dee.d/origins.d/`, …)

Under repos we own:

- `~/repo/github.com/bukzor/build-system.d/` (verify intent)
- `~/repo/claude-code-reverse-ng/.claude/todo.d/` (almost certainly
  should be `.claude/todo.kb/` per current `llm-subtask` convention)

### Out of scope

- `~/.claude/must-read.d/` — covered by
  `~/.claude/CLAUDE.rename-must-read-d-to-must-read-kb.Task.md`.
- Anything under `~/tmp/`, `~/.cache/`, build/scratch dirs.
- `~/.claude/projects/`, `~/.claude/sessions/`, `~/.claude/backups/`
  (transient session state).

## Proposed Solution

For each candidate:

1. **Classify.** Apply the heuristic below. If genuinely `.d/`-style,
   note it in the "Leave alone" list and move on.
2. **Rename.** `git mv old.d new.kb` if inside a git repo;
   plain `mv` otherwise. Prefer renaming between sessions when the
   path is referenced in settings/config that's read at startup.
3. **Update references.** `git grep -l '<name>\.d'` (from the
   containing repo root or `~` for the home tree). Skip historical
   references (ADRs, devlogs, task files describing past state); edit
   operational references (frontmatter `requires:`/`depends:`,
   hardcoded path constants in code, README/CLAUDE.md path mentions).
4. **Commit per path scope**, summary line `rename <name>.d → <name>.kb`,
   body referencing the convention-pivot ADR.

### Classification heuristic — "is this really a `.kb/`?"

**Yes, KB**, if any of:

- Has (or wants) a sibling `*.jsonschema.yaml` validating entries
- Has a CLAUDE.md describing it as an agent-discoverable collection
- Contents are markdown entries the agent treats as a corpus (browse
  + load on demand)
- A sibling summary file (e.g. `food.md` next to `food.d/`) summarizes
  it for parent-level reading

**No, keep as `.d/`**, if:

- Third-party convention (systemd, conf.d, gnupg, terraform, pants, …)
- Code/script bag with no agent-discovery semantics
- External consumers (other machines, deploy tooling, dotfile mirrors)
  rely on the exact path
- Renaming would invalidate a published interface

When unsure: a frontmatter `requires:`/`depends:` pointing in or an
agent-readable CLAUDE.md saying "browse this dir" is a strong KB
signal. A `conf.d`/`profile.d`-style "every file is sourced/loaded"
semantic is a strong drop-in signal.

## Implementation Steps

- [ ] Re-run inventory: `find ~ -maxdepth 4 -type d -name '*.d' | sort`
- [ ] Diff against the lists above; record additions/removals here
- [ ] For each candidate, classify and either:
    - [ ] Rename + update operational references + commit, **or**
    - [ ] Add to the "Leave alone" list with a one-line reason
- [ ] Specifically address:
    - [ ] `~/.claude/builtin-context.d/`
    - [ ] `~/.claude/docs/default-context/tools.d/`
    - [ ] `~/.claude/system-prompt-patches.d/` (+ nested `match.d/`)
    - [ ] `~/claude/research.llm-filesystem-collab/*.d/` (group)
    - [ ] `~/claude/ai-coding-tools-facts.d/` (group, deeply nested)
    - [ ] `~/repo/claude-code-reverse-ng/.claude/todo.d/`
    - [ ] `~/repo/github.com/bukzor/build-system.d/`
- [ ] Final sweep: `git -C ~ grep -l '\.d/' | …` — review remaining
      hits, confirm each is historical or legitimately third-party

## Open Questions

- `~/.claude/system-prompt-patches.d/` nested `match.d/`: should both
  be `.kb/`, or does `match.d/` encode different semantics (e.g.,
  "every file is a match-pattern, drop-in style")? Inspect contents
  before renaming the inner one.
- `~/claude/ai-coding-tools-facts.d/dot-dee.d/` — the name suggests
  self-aware reference to the `.d/` convention. Verify whether it's
  meta-content (about `.d/`) or a regular KB.
- For `~/claude/research.llm-filesystem-collab/`: each subtopic is its
  own `.d/`. Is the right move per-subdir rename, or a structural
  rethink (e.g., promote to a single `research.kb/` with subdirs)?
  Defer the structural call; just rename suffixes for now if so.

## Success Criteria

- [ ] Every `.d/` under `~` is either renamed to `.kb/` or recorded
      here with a one-line "legitimately `.d/`" justification
- [ ] No operational references to renamed paths remain unupdated
      (verified by `git grep` from each affected repo root)
- [ ] Convention-pivot ADR cited in each rename commit body

## Notes

- The classification is judgment-based; resist bulk `find … | xargs mv`.
- Cross-machine sync: if `~/.claude/` or `~/claude/` is mirrored
  (chezmoi, stow, manual rsync) to other hosts, each rename has to
  propagate. Out of scope here — flag per-rename if applicable.
- `must-read.d/` task is the canonical worked example for this kind
  of rename; cross-reference its Risks/Rollback sections when in doubt.
