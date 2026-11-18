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

First check the blocker: `git -C ~ fetch` and `git merge-base --is-ancestor
origin/svelte-crostini origin/main`. If it fails, stop and report.

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
5. **Workspace names:** rename penguin's main clone to
   `~/repo/github.com/bukzor/dotfiles--main` (plan item), or delete it if
   it is clean and fully pushed, since `~` is main now.
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
