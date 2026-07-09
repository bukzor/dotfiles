---
managed-by: Skill(llm-subtask)
status: done
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

Own drop-in / mechanically-applied convention (resolves the
`match.d/` open question below — same pattern, same verdict):

- `~/.claude/system-prompt-patches.d/` (+ nested `*/match.d/`,
  `*/search.d/`) — each subdir is a patch consumed by
  `~/claude/mitmproxy/syspatch.py`; README documents the file-format
  table itself ("each file is applied"). Mechanically loaded/applied,
  not an LLM-browsed corpus. Textbook drop-in signal.
- `~/.claude/tool-description-patches.d/` (+ nested
  `SendMessage/upstream.d/`) — same pattern, consumed by
  `~/claude/mitmproxy/toolpatch.py`. `upstream.d/*.md` = coexisting
  accepted-wording variants, drop-in not KB.
- `~/.claude/docs/default-context/tools.kb/{WebFetch,Write}.examples.d/`
  — fixed 2-file `{with,before}.md` example pair per tool, a data
  fixture shape the parent README names explicitly as `X.examples.d/`
  convention, not a growable browsed corpus. Left as `.d` even though
  the parent is now `.kb`.

### Resolved — deleted

- `~/.claude/builtin-context.d/` — single orphaned file
  (`tools/ExitPlanMode.md`), one commit (2025-11-24), never touched
  since, no operational references, superseded by
  `~/.claude/docs/default-context/tools.kb/`. Confirmed dead by user;
  deleted (commit `57f9498` in the `~` repo), not renamed.

### Resolved — renamed

- `~/.claude/docs/default-context/tools.d/` → `tools.kb/` (+ nested
  `.claude/todo.d/` → `.claude/todo.kb/`). Commit `8e46c6b` in the
  `~` repo. Strong KB: per-tool cost/benefit corpus queried via
  `bin/tool-scores-*`, README describes it as an analysis store.
- `~/claude/research.llm-filesystem-collab/{criteria,decision-goals,problem-statement,requirements,research-data,research-execution-constraints,research-goals,research-methodology}.d/`
  → `*.kb/` (all 8). Commit `4a0fd2c` in that repo. Textbook KB:
  per-item `CLAUDE.md`, sibling summary `.md` for every one, two
  already had `*.jsonschema.yaml`. Updated operational path
  references throughout (root `CLAUDE.md`/`README.md`/`CLAUDE.todo.md`,
  jsonschema descriptions, `docs/principles`, `docs/procedures`,
  `docs/lessons-learned`, `research-results`); left
  `docs/dev/devlog/*.md` untouched (historical). Did not restructure
  into a single `research.kb/` — deferred per the (now-resolved)
  Open Question below.

- `~/claude/ai-coding-tools-facts.d/` (own repo root) — **resolved.**
  The apparent "two `dot-dee` trees" were not a duplication bug: `dot-dee.d/`
  is a factual KB about the `.d` naming pattern in general (systemd,
  apt, etc.); `dot-dee/` (no suffix) is design requirements/principles
  for building the tool that became this whole `.d`→`.kb` convention
  — genuinely different content sharing a name prefix. Repo had only
  an empty initial commit despite ~8.7k lines on disk; committed as-is
  first (`c38e516`), then renamed (`ce2cb4a`): `tools.d`, `features.d`,
  `providers.d`, `architectures.d`, `workflows.d`, `comparisons.d`,
  and `dot-dee/{implementations,patterns,principles,requirements}.d`
  → `.kb`. **Left as `.d` deliberately:** `dot-dee.d/` and all its
  nested children — it specifically documents the `.d` convention
  itself and is explicitly self-referential in its own README
  ("this facts database itself uses the `.d` pattern... a
  self-referential demonstration"); renaming would falsify its own
  subject matter. Historical/quoted `.d/` mentions inside
  `dot-dee/*.kb/` (verbatim founding user-requirements, design docs
  describing the project's own original structure) left untouched —
  they describe past state. Repo root itself (`ai-coding-tools-facts.d`)
  **not renamed** — same rationale as `build-system.d` (no clean
  git-mv for a repo root; referenced by absolute path from
  `~/claude/aider-expert/.claude/settings.local.json`). Per user
  decision, not executed at all here (even pending "go-ahead") —
  instead left as a first-priority `.claude/todo.md` entry in that
  repo (commit `cbc0e50`), since the user may never revisit it and an
  undone todo is fine for that.

- `~/repo/github.com/bukzor/build-system.d/` — own repo root (created
  2025-09-11, last commit 2025-09-13 — predates the `.kb` anchor by 3
  months, stale ~10 months, likely abandoned/completed). Contents are
  a genuine LLM-authored/read research corpus (per-build-system
  `synthesis.md`, `decision-matrix.yaml` produced by Claude via
  `bin/claude-research`) — primary test says KB. But every build
  system subdir also has its own `claude-args.d/` (hierarchical
  argument-discovery files, mechanically walked/read by
  `bin/claude-args`, genuinely drop-in-style — those correctly stay
  `.d/` regardless of what happens to the repo name). Renaming the
  *repo root* itself has no clean `git mv` — bigger blast radius than
  a subdir rename. Per user decision, not executed here at all —
  instead left as a first-priority `.claude/todo.md` entry in that
  repo (commit `bedd062`), since the user may never revisit it and an
  undone todo is fine for that.

### Resolved — renamed (continued)

- `~/claude/bug--parallel-path-contamination/{evidence,hypotheses}.d/`
  → `.kb/`. Gitignored (`~/claude/.gitignore` blanket-ignores `*/`
  under `~/claude/`), so plain `mv`, no `git mv`/commit. Textbook KB:
  own `CLAUDE.md` says "For Agents: when adding evidence...". Newly
  discovered on re-inventory, not in original snapshot.
- `~/claude/.claude/ideas.d/` → `ideas.kb/`. Same gitignore situation
  as above; matches the ADR's own worked example. Newly discovered.
- `~/repo/claude-code-reverse-ng/.claude/todo.d/` → `todo.kb/` (+
  sibling `todo.jsonschema.yaml` copied from the `llm-subtask` skill
  skeleton). Commit `8ee5e1f` in that repo. Only held `.gitkeep`, but
  is the ADR's own worked example.
- `~/claude/fixing-claude-introspection/.claude/todo.d/` → `todo.kb/`
  (+ sibling `todo.jsonschema.yaml`). Commit `fd44bac` in that repo.
  Entries carry `cost-benefit-sweh` frontmatter (llm-subtask
  convention) — clear KB. Newly discovered, not in original snapshot.
- `~/claude/github-manager/` (own repo): `principles.d/`, `goals.d/`,
  `maintenance-actions.d/`, `github.d/{prs,notifications}.d/`,
  `.claude/todo.d/` → `.kb/` (all 6). Commit `06474ee` in that repo.
  Textbook KB: per-collection `CLAUDE.md`, structured frontmatter
  cross-refs between collections (`goal:`/`principle:` fields),
  sibling `*.md` summaries at parent scope. `github.d/` **itself**
  left as `.d` — mixed container directly holding
  mechanically-refreshed live snapshots (`prs.md`/`notifications.md`
  via `lib/gh/` fetch scripts) alongside its now-`.kb` curated
  subcollections, not a homogeneous corpus on its own. Repo had
  unrelated pre-existing uncommitted edits (`CLAUDE.md` Quick Start
  section, `lib/gh/action-items`, `lib/gh/my-items`); stashed before
  the rename commit and restored after — untouched, still uncommitted,
  not mine to commit. Also noted but left alone (out of my scope):
  root `CLAUDE.md` frontmatter has a stale `depends: - skills/llm.d`
  reference (predates the `llm.d`→`llm.kb` rename entirely) — separate
  bug, not part of this sweep.

### Out of scope

- `~/.claude/must-read.d/` — covered by
  `~/.claude/CLAUDE.rename-must-read-d-to-must-read-kb.Task.md`.
- Anything under `~/tmp/`, `~/.cache/`, build/scratch dirs, including
  `~/tmp/touchpad_activity_log.d/` and `~/tmp/git-test/.git/hunks.d/`
  (the latter is inside a `.git/`, tool-internal regardless).
- `~/.claude/projects/`, `~/.claude/sessions/`, `~/.claude/backups/`
  (transient session state).
- `~/claude/cultist-simulator/extracted/*.d/` — game-data extraction
  output, not agent-authored/read content.

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

**Primary test:** is an LLM a primary participant in *authoring or
reading* these entries? If yes, KB. If no (humans/tools author and
read it; an LLM at most executes against it), keep `.d/`.

The signals below are heuristics for that underlying test, not the
test itself — jsonschema presence in particular is a symptom
(structured data implies a reader that parses it), not the
criterion. Per the convention-pivot ADR, schema-presence alone was
explicitly rejected as the differentiator.

**Yes, KB**, signals:

- Has (or wants) a sibling `*.jsonschema.yaml` validating entries
- Has a CLAUDE.md describing it as an agent-discoverable collection
- Contents are markdown entries the agent treats as a corpus (browse
  + load on demand)
- A sibling summary file (e.g. `food.md` next to `food.d/`) summarizes
  it for parent-level reading

**No, keep as `.d/`**, signals:

- Third-party convention (systemd, conf.d, gnupg, terraform, pants, …)
- Code/script bag with no agent-discovery semantics
- External consumers (other machines, deploy tooling, dotfile mirrors)
  rely on the exact path
- Renaming would invalidate a published interface

When unsure: a frontmatter `requires:`/`depends:` pointing in or an
agent-readable CLAUDE.md saying "browse this dir" is a strong KB
signal. A `conf.d`/`profile.d`-style "every file is sourced/loaded"
semantic is a strong drop-in signal.

**Tiebreaker for genuinely ambiguous cases:** age relative to when
the `.kb` convention started (see Notes below for the anchor date
once found). A `.d/` created *before* that date and unmigrated is
legacy debt — judge on the primary test above. A `.d/` created
*after* that date, where `.kb` was an available option, is more
likely a deliberate choice to stay `.d` — lean toward leaving it.

## Implementation Steps

- [x] Re-run inventory: `find ~ -maxdepth 4 -type d -name '*.d' | sort`
- [x] Diff against the lists above; record additions/removals here
- [x] For each candidate, classify and either:
    - [x] Rename + update operational references + commit, **or**
    - [x] Add to the "Leave alone" list with a one-line reason
- [x] Specifically address:
    - [x] `~/.claude/builtin-context.d/` — confirmed dead by user,
          deleted (commit `57f9498`)
    - [x] `~/.claude/docs/default-context/tools.d/` — renamed
    - [x] `~/.claude/system-prompt-patches.d/` (+ nested `match.d/`)
          — leave alone, drop-in convention
    - [x] `~/.claude/tool-description-patches.d/` (+ nested
          `SendMessage/upstream.d/`) — leave alone, drop-in
          convention (found on re-inventory, not in original list)
    - [x] `~/claude/research.llm-filesystem-collab/*.d/` (group) —
          all 8 renamed, commit `4a0fd2c`
    - [x] `~/claude/ai-coding-tools-facts.d/` (group, deeply nested) —
          10 renamed (commits `c38e516`, `ce2cb4a`); `dot-dee.d/`
          subtree deliberately left `.d` (self-referential); repo root
          left un-renamed by user decision, first-priority
          `.claude/todo.md` entry added instead (commit `cbc0e50`);
          follow-up commit `ce04673` added 4 missing jsonschema files
          for the newly `.kb`'d `dot-dee/*` dirs and fixed a
          pre-existing type bug (`release_date: 2024` unquoted)
          surfaced by `llm.kb-validate` — clean, 0 errors
    - [x] `~/repo/claude-code-reverse-ng/.claude/todo.d/` — renamed,
          commit `8ee5e1f`
    - [x] `~/repo/github.com/bukzor/build-system.d/` — left un-renamed
          by user decision (repo-root rename, bigger blast radius),
          first-priority `.claude/todo.md` entry added instead
          (commit `bedd062`)
    - [x] `~/claude/bug--parallel-path-contamination/{evidence,hypotheses}.d/`
          — renamed to `.kb/` (plain `mv`, gitignored, no commit);
          CLAUDE.md/README.md structure sections updated. Textbook
          KB: own CLAUDE.md says "For Agents: when adding evidence...".
    - [x] `~/claude/.claude/ideas.d/` — renamed to `ideas.kb/` (plain
          `mv`, gitignored). Matches the ADR's own worked example.
    - [x] `~/claude/github-manager/` cluster — all 6 renamed, commit
          `06474ee`; `github.d/` outer container left as `.d`
    - [x] `~/claude/fixing-claude-introspection/.claude/todo.d/` —
          renamed, commit `fd44bac`
- [x] Final sweep: re-ran `find ~ -maxdepth 4 -type d -name '*.d'` —
      every remaining hit is accounted for above (third-party,
      deliberate drop-in, out-of-scope, or explicitly flagged for
      user go-ahead). Spot-checked `~` repo for stray `tools\.d`/
      `ideas\.d` references — clean.

## Open Questions

- ~~`~/.claude/system-prompt-patches.d/` nested `match.d/`: should
  both be `.kb/`~~ — **Resolved:** leave both as `.d/`. Same for
  `tool-description-patches.d/`. See "Leave alone" list above.
- ~~`~/claude/ai-coding-tools-facts.d/dot-dee.d/` — the name suggests
  self-aware reference to the `.d/` convention~~ — **Resolved:** it's
  meta-content (documents the `.d/` convention itself, deliberately
  self-referential per its own README), not a duplication bug and not
  a regular KB in disguise. Left as `.d`. See "Resolved — renamed"
  above.
- ~~For `~/claude/research.llm-filesystem-collab/`: each subtopic is
  its own `.d/`. Is the right move per-subdir rename, or a structural
  rethink~~ — **Resolved:** per-subdir rename, no restructure. See
  "Resolved — renamed" above.

## Success Criteria

- [x] Every `.d/` under `~` is either renamed to `.kb/` or recorded
      here with a one-line "legitimately `.d/`" justification
- [x] No operational references to renamed paths remain unupdated
      (verified by `git grep` from each affected repo root)
- [x] Convention-pivot ADR cited in each rename commit body

Fully closed. `~/.claude/builtin-context.d/` was confirmed dead and
deleted. The two repo-root renames (`build-system.d`,
`ai-coding-tools-facts.d`) were, per user decision, deliberately left
un-renamed rather than executed on a "go-ahead" — each instead got a
first-priority `.claude/todo.md` entry in its own repo (`Skill(llm-subtask)`
Tier 2), acceptable to leave undone indefinitely if that repo isn't
revisited.

## Notes

- The classification is judgment-based; resist bulk `find … | xargs mv`.
- **`.kb` convention anchor date: 2025-12-11** (repo
  `git-partial.prototyping`, commit `726dd039`, "Add design knowledge
  base for git-partial" — first `.kb/` dirs actually created on
  disk). The decision predates this: an earlier ADR,
  `docs/adr/2025-12-03-000-pivot-from-d-to-kb-naming-convention.md`
  (added 2025-12-03, itself still under a `.d`-suffixed path at the
  time), documents the original `.d`→`.kb` pivot; the
  `2025-12-11-001--unify-directory-naming-to-kb-suffix.md` ADR cited
  above in Context extended it to `todo.d`/`ideas.d`/`references.d`
  specifically. Use 2025-12-11 as the tiebreaker cutoff (see
  Classification heuristic above) — that's when `.kb` became an
  actual precedent on disk, not just a stated intent. A `.d/` dir
  created 2025-12-03–2025-12-11 is a gray zone: decision existed but
  no worked example yet.
- Cross-machine sync: if `~/.claude/` or `~/claude/` is mirrored
  (chezmoi, stow, manual rsync) to other hosts, each rename has to
  propagate. Out of scope here — flag per-rename if applicable.
- `must-read.d/` task is the canonical worked example for this kind
  of rename; cross-reference its Risks/Rollback sections when in doubt.
