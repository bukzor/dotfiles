---
managed-by: Skill(llm-subtask)
status: open
blocked-by:
  - ./2026-11-18-008-merge-and-buck-win10-pull.md  # main must contain svelte-crostini
required-reading:
  - ./CLAUDE.md
  - ../CLAUDE.md  # the merged/ rule, topology
  - ../2026-07-06-006-Final-merge-and-home-switchover.md  # per-host steps, smoke test, penguin checklist
  - ./2026-11-18-000-switch-buck-win10-home-to-main.md  # how buck-win10 did it; reuse its preflight
---

# penguin: switch live `~` to main, retire `svelte-crostini`

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (penguin's
per-host steps, all of them in one sitting)

## Problem Statement

Run this on **penguin**, in its live `~` (today a `svelte-crostini`
checkout). `buck-win10` can't reach penguin, so every penguin step is in
this one brief and the user launches it once there.

First check the blocker. Run `git -C ~ fetch`. Then check that main
contains the reunify merge: `git merge-base --is-ancestor ff853dc
origin/main`. If it doesn't, stop and report. If `origin/svelte-crostini`
has commits that main lacks (`git log origin/main..origin/svelte-crostini`):
- **They touch only `.claude/todo.kb/`** (handoff records): merge them into
  main with an ordinary merge, in a scratch clone or penguin's main clone,
  and push.
- **Anything else** (real penguin work): merge it the same way, and list it
  in your report.
- **Except:** svelte's root `CLAUDE.md` says (2026-11-22) that main work
  happens in a `dotfiles--main` clone, not in `~`. That was true only while
  `~` was on svelte-crostini. [!@bukzor] 2026-11-24: "`main` is the working
  branch in `~` ... that working copy is cutting-edge, and it's
  dotfiles--main that's obsolete". Leave that paragraph out of the merge
  result; `.claude/must-read.kb/before/dotfiles-repo/committing.md` on main
  carries the current rule.

1. **Scratch:** in `~/repo/scratch` (unit 004/005's Open Questions), find
   out whether `b45a792` holds work that isn't on `bukzor/scratch`. If it
   does, push it to a branch there. Then `git -C ~ submodule sync
   repo/scratch`.
2. **Uncommitted state in `~`:** commit or park it, following the parent's
   step (it links `../2026-06-03-001-commit-accumulated-dotfiles-changes.md`).
   Anything that is a judgment call goes under Open Questions; park it in
   a stash with a descriptive message rather than committing it.
3. **Switch:** follow buck-win10's preflight (back up the ignored files that
   main would overwrite into `~/trash/switch-to-main/`, and list what the
   checkout deletes), then check out `main`. After pulling, run `ln -s
   id_ed25519.pub.bukzor.chromebook ~/.ssh/id_ed25519.pub` (unit 007
   renamed the tracked key).
4. **Rename:** rename `svelte-crostini` to `merged/svelte-crostini`, locally
   and on origin, as buck-win10 did for its branch.
5. **Main clone:** once `~` is on main, penguin's main clone is obsolete
   ([!@bukzor] 2026-11-24, see the merge note above). If it is clean and
   fully pushed, move it to `~/trash/`; if not, push what it holds first
   and list it in your report.
6. **Smoke test** (the parent's list, plus kitty and nvim, which buck-win10
   couldn't run): new login shell, `bash -i`, `zsh -i`, vim, nvim (a
   `:checkhealth` excerpt, `:Lazy` sync, which also writes the new
   `lazy-lock.json` entries), tmux, kitty config load, `~/bin/has`,
   `~/bin/bootstamp`. Commit and push whatever lockfile churn nvim produces.

Rollback: `git -C ~ switch merged/svelte-crostini`.

Commit this handoff file on whichever branch `~` is on at the time, and
push.

**Scope (only these):** penguin's `~` checkout, branch refs, the scratch
submodule, penguin's dotfiles clones, `~/trash/`, this handoff file.

## Steps

## Decisions

## Open Questions

## Final report
