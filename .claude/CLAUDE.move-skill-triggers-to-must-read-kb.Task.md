--- # workaround: anthropics/claude-code#13003
requires:
  - ./must-read.kb/before/git/commit.md
cost-benefit-sweh:
  timebox:
    "@value": 2.0
    rationale: |
      5 user-owned skills × ~20 min each (extract trigger from
      description: frontmatter, write must-read.kb file, verify load
      behavior). Beyond 2h, a skill has unusual trigger shape worth
      pausing on.
  benefit-2w:
    "@value": 2.5
    rationale: |
      Collapses two trigger surfaces to one. Removes the
      scan-description-prose-AND-scan-must-read-kb cost every session
      start; estimate ~5 min saved per session × frequent sessions
      over 2 weeks.
---

# Task: Move skill auto-load triggers from SKILL.md descriptions to `~/.claude/must-read.kb/`

## Problem

Several skills carry imperative auto-load text in their `description:`
frontmatter — e.g. *"Agent MUST load for .kb/ directories…"*,
*"Agent MUST load on user aggravation…"*. The host CLAUDE.md has no
parallel protocol bound to those imperatives, so they form a second
trigger surface the agent has to remember to scan, separate from
`~/.claude/must-read.kb/`.

This is structurally asymmetric:

| Surface | Trigger shape | Bound by CLAUDE.md? |
|---|---|---|
| `must-read.kb/{before,when,after}/<trigger>.md` | filename | Yes — `Required Reading` step 1–3 |
| `description:` "Agent MUST load when X" | free-text prose | No |

The fix: collapse to one surface. Auto-load wiring becomes a
must-read.kb concern; skill `description:` reverts to pure capability /
author-intent prose, with imperative phrasing removed. The
description's "when to use" guidance remains — it's no longer
load-bearing, just informative, which is how community/Anthropic skill
descriptions are typically read.

Steps:

- [ ] Re-verify the inventory against a fresh session's available-skills listing
- [ ] Author `~/.claude/must-read.kb/when/<trigger>.md` entries for each imperative-trigger skill (before stripping descriptions)
- [ ] Rewrite each user-owned skill's `description:` to drop imperative MUST-load phrasing, retain capability statement
- [ ] Extend `~/.claude/CLAUDE.md` Required Reading with the skill-invocation clause
- [ ] Commit per logical unit (must-read.kb files, skill descriptions, CLAUDE.md extension)
- [ ] Test in a fresh session: provoke one trigger, confirm the skill loads via must-read.kb

## Constraints

- `~/.claude/must-read.kb/` is the **sole source of truth** for runtime
  auto-load conditions. No back-references from SKILL.md (no `triggers:`
  field). Discoverability of "what fires this skill" is by
  `grep -rl 'Skill(name)' ~/.claude/must-read.kb/`.
- `~/.claude/CLAUDE.md` is shared with the sister "must-read-kb"
  session. If both sessions land edits to it, coordinate; otherwise
  this one-clause extension is small and easy to reconcile.
- User-owned skills (in `~/.claude/skills/` and
  `~/repo/.../bukzor-agent-skills/<skill>/SKILL.md`, possibly
  symlinked) can have their descriptions rewritten. Plugin-provided
  skills (descriptions upstream-controlled) cannot — for those, only
  the must-read.kb side gets authored.
- The new must-read.kb entries should follow the existing `before/`,
  `when/`, `after/` naming convention. Filename names the trigger;
  body contains the directive (`Invoke \`Skill(name)\`` plus any
  brief context).

## Inventory (current state, re-verify before acting)

Re-run before acting. Skills surface in the system reminder; the
canonical list is whatever a fresh session sees. The set below is the
snapshot at task-write time.

```bash
# Skills currently carrying imperative MUST-load in description.
# Re-derive from the available-skills system reminder of a fresh session.
```

**Imperative-trigger skills (at write time):**

| Skill | Trigger sentence (paraphrased) | Likely must-read.kb path |
|---|---|---|
| `llm-kb` | for `.kb/` directories and structured multi-agent knowledge bases | `when/in-a-kb-directory.md` |
| `llm-design-kb` | for `design.kb/` directories and layered design documentation | `when/in-a-design-kb-directory.md` |
| `llm-collab` | when dealing with ADRs, devlogs, or multi-session documentation | `when/dealing-with-adrs-or-devlogs.md` |
| `llm-subtask` | for 'subtask'/'todo' commands, multi-task work, or mid-task questions | `when/subtask-or-todo-work.md` |
| `claude-realignment` | on user aggravation (SHOUTING, pejoratives, sarcasm), repeated corrections, persistent frustration | `when/user-aggravation.md` (consider splitting into multiple files if conditions diverge in behavior) |

Trigger sentences with "or" / multiple alternatives may warrant
multiple must-read.kb files (one per disjunct) so each filename names a
single, narrow condition — see the existing `must-read.kb/before/git/`
tree as the shape to imitate.

**Non-imperative skills (no change needed):** the bulk of the listing —
`artifacts-builder`, `webapp-testing`, `mutation-testing`, etc. These
already use descriptive language and load on user invocation.

## Procedure

### 1. Re-verify the inventory

Read the available-skills system reminder of a fresh session. Cross-check
against the table above. New imperative descriptions → add; resolved
ones → strike. Skip plugin skills (their `description:` is
upstream-controlled).

### 2. Author the must-read.kb entries first

Forward direction: create the must-read.kb files **before** stripping
imperatives from the skill descriptions. This way, no session is left
unable to discover the trigger during the window between the two
edits.

For each row in the inventory table:

```bash
$EDITOR ~/.claude/must-read.kb/when/<trigger-name>.md
```

Body shape (kept short — the file's job is to fire a load, not to
document the skill):

```markdown
Invoke `Skill(<skill-name>)` before continuing.

<one-sentence reason / context, optional>
```

Multi-condition triggers (e.g. claude-realignment's "SHOUTING +
pejoratives + sarcasm + repeated corrections") may split into separate
filenames so each names one narrow condition. Per llm-kb's
"single-topic file" principle.

### 3. Rewrite skill descriptions

Open each user-owned imperative-trigger skill's `SKILL.md`. Locate the
canonical file — if `~/.claude/skills/<skill>/SKILL.md` is a symlink
into `~/repo/.../bukzor-agent-skills/<skill>/SKILL.md`, edit the repo
copy. Verify with `ls -L`.

Rewrite the `description:` to drop the imperative wiring directive and
keep only the descriptive / capability statement. Example transform:

- **Before:** `Agent MUST load for .kb/ directories and structured multi-agent knowledge bases`
- **After:**  `Knowledge-base pattern for .kb/ directories. Use when authoring or maintaining structured multi-agent knowledge bases.`

The "when to use" guidance is retained but reframed as advisory, not
imperative. This matches how community/Anthropic skills typically
phrase descriptions.

### 4. Extend `~/.claude/CLAUDE.md` Required Reading

One-clause extension to step 3. Current text:

```
3. when a trigger condition matches, you MUST read that file
   - `before/` creates a dependency: the read MUST complete before related actions. These operations are NOT independent — they MUST be executed sequentially.
```

Append:

```
   - if the must-read.kb file directs you to invoke a skill, that invocation
     is part of honoring the trigger — call `Skill(<name>)` before
     proceeding. The authoritative auto-load conditions live here; skill
     descriptions are informative only.
```

This makes the Required Reading protocol the sole protocol for
triggered loading. No separate "Skill Triggers" section needed.

### 5. Commit

One commit per logical unit. Suggested grouping:

- `must-read.kb/when/<trigger>.md` files: one commit per skill (path-scoped via `git commit-files`)
- `bukzor-agent-skills/<skill>/SKILL.md` description rewrites: per-skill, in that repo's branch / PR workflow
- `~/.claude/CLAUDE.md` extension: standalone commit

Dry-run first per the `requires:` commit guide:

```bash
git -C ~ commit-files -n .claude/must-read.kb/when/<trigger>.md
```

Summary line shape: `must-read.kb: <trigger> → Skill(<name>)`.
Description rewrites: `<skill>: drop imperative MUST-load, retain capability statement`.
CLAUDE.md: `CLAUDE.md: honor skill invocation directives in must-read.kb triggers`.

### 6. Test (fresh session)

Start a new session. Verify the must-read.kb scan picks up each new
`when/<trigger>.md` file. Provoke one trigger (e.g. start work in a
`.kb/` directory) and confirm the agent invokes the relevant skill via
the must-read.kb entry rather than via the description.

If a skill fails to auto-load when its trigger fires, the relevant
must-read.kb file is either missing, mis-named, or the body doesn't
clearly direct `Skill()` invocation.

## Rollback

**Before commit:** undo selectively with `git restore` and `rm` the new
must-read.kb files.

**After commit:** `git revert` the relevant commits. The description
rewrites and the must-read.kb entries are loosely coupled — reverting
one without the other leaves the system in a defined state:

- must-read.kb entry present, description still imperative → both
  surfaces describe the trigger; agent has two ways to find it. Mild
  redundancy, not broken.
- must-read.kb entry absent, description rewritten to descriptive →
  trigger only fires on user invocation. Equivalent to most
  community/Anthropic skills. Quiet, not broken.

Either partial state is recoverable.

## Risks

- **Trigger-condition translation loss.** Some skill descriptions
  pack rich conditions into one sentence ("on SHOUTING, pejoratives,
  sarcasm, repeated corrections, OR persistent frustration after a
  prior realignment pass"). Decomposing into must-read.kb filenames
  may either over-split (one file per disjunct, many files) or
  under-capture (one filename can't name all conditions). Lean toward
  splitting — the filename is the trigger, so naming a narrower
  condition makes the match clearer.

- **Plugin skills out of reach.** Any imperative MUST-load in a plugin
  skill description stays in place; only the user-owned half of the
  refactor is achievable. The CLAUDE.md extension explicitly calls
  must-read.kb authoritative; plugin description imperatives are
  treated as informative.

- **Skill-description recommendations have a slight gravity to be
  re-promoted to imperative.** Authoring a new skill, the natural urge
  is to write "Agent MUST load when…" in the description. Document the
  convention in the skill-authoring guide (if one exists) or in a kb
  entry near where new skills are scaffolded.

- **Coordination with the sister session.** `~/.claude/CLAUDE.md`
  edits race with the "must-read-kb" session's parallel work. Sequence
  the CLAUDE.md extension after the other session quiesces, or hand
  the draft to that session.

## Out of scope

- **`triggers:` frontmatter field** in SKILL.md. Considered and
  rejected — must-read.kb is the sole source of truth; back-references
  duplicate that and rot without a validator. Revisit only if a
  consumer (validator, installer, doc-generator) demands structured
  trigger data.

- **Validator for `Skill(name)` references inside must-read.kb.**
  Useful eventually (catches Skill renames / removals that leave
  dangling triggers). Belongs in the new `llm-must-read-kb` skill or
  `bin/llm.kb-validate`, not here.

- **Plugin skill description rewrites.** Upstream-controlled. Track
  separately if a plugin's MUST-load text becomes an obstacle.

- **A jsonschema for must-read.kb file frontmatter.** Most must-read.kb
  files are prose-only and don't need it. Add only if structured
  metadata becomes necessary.

## Retention

Git history is the retention mechanism. The CLAUDE.md extension and
each must-read.kb addition are small, atomic commits — easy to revert
individually. No separate backup needed.

If the refactor is partially landed and then paused, the system stays
in a coherent intermediate state (see Rollback). Resuming the task
later just means picking up the inventory from where it stopped.
