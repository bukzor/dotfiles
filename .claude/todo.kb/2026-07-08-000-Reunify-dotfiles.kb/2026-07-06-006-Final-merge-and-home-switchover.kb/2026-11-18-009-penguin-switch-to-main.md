---
managed-by: Skill(llm-subtask)
status: done
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

- [x] blocker: `ff853dc` in origin/main; 10 svelte-only commits merged
- [x] scratch: 2 unpushed 2023 commits → `bukzor/scratch` branch `penguin-wgpu-2023-07`; submodule synced (now ssh)
- [x] uncommitted state: carried across the checkout (Decisions)
- [x] switch: `~` on `main`; ssh `.pub` symlink made
- [x] rename: `merged/svelte-crostini`, local and origin, upstream set
- [x] main clones trashed
- [x] smoke test

## Decisions

- Merge `CLAUDE.md`: kept main's copy, so svelte's whole "Branches" section
  is gone, the push paragraph included. Main's "git policy: push once stable;
  hold dotfiles commits till session end" commit already moved that rule
  into `git/conventions.md`, and `~`'s working copy had dropped both. So the
  006 push-vs-hold item may be moot: both texts come from that one commit,
  and both call commits made while iterating churn.
- `bash-preamble.py` conflict: both sides had the same fix; took svelte's
  doctested `hook_output` (doctests pass).
- Step 2: no stash (user rule: never `git stash`), and no commit of peers'
  work. A peer edited `~` at 13:05 and 13:09, minutes before the switch.
  `checkout -m` carried every edit across. The 3 files main also changed
  were each merged ahead of time with `git merge-file`, all clean, and they
  matched afterwards. Backups: `~/trash/switch-to-main/dirty-backup/`.
- `~/.local/share/nvim` was a 1.1G real dir (mason, tree-sitters), and main
  tracks that path as a symlink to `../../.vim/data`. I moved it aside,
  checked out, and moved its contents into `~/.vim/data/` (ignored on main).
- Untracked `.claude/must-read.kb/before/dotfiles-repo/committing.md` was
  main's file minus its 2026-11-24 superseding ruling, and it blocked the
  checkout. Moved to `~/trash/switch-to-main/untracked-stale/`.
- Trashed both main clones: `dotfiles--main` and `dotfiles--main-reunify`
  (869 behind). Both were clean, with nothing unpushed. Their git dirs stay
  in git-localhost-store, because `dotfiles--ci-vim-config-tests` is a
  worktree of `dotfiles--main`'s store (verified working after the move).
- Out of scope, fixed (one word): `.sh_lib/functions-cli.sh` used `source`
  under `#!/bin/sh`. Penguin's `/bin/sh` is dash, so `has` and `bootstamp`
  failed. Now `.`; passes under dash, busybox sh, and bash.

## Open Questions

1. Check sh on main has been red since 2026-11-22:
   `mechanical-fast-forwards_check.sh` (`Brewfile` differs from svelte).
   It has no skip-if-absent guard, so with `origin/svelte-crostini` gone it
   now errors instead. Recommend deleting it: its header says it lasts until
   006. Also delete `final-merge_check.sh`, which now always skips, and the
   `fetch-depth` comment in `check-sh.yml`.
2. `~` still carries peers' uncommitted WIP (vim config tests, skill-uri,
   tmux-color, pnpm config, conventions.md). It belongs to its sessions, so
   006's "`git status` clean" waits on them. Some of it mirrors
   `ci-vim-config-tests` (006's open ruling).
3. The general clone `~/repo/github.com/bukzor/dotfiles` sits on a local
   `svelte-crostini` whose upstream is gone. It also has `orphan-recovery`
   and `pre-swap` branches. Leave it, or rename the branch to `merged/…`?

## Final report

- Pre-switch commit `d321e1f`. Merge `f490451` (parents `99a8bf8`, `d321e1f`)
  pushed to main; `origin/svelte-crostini` is an ancestor of origin/main.
- Checkout: 323 adds, 28 modifications, 0 deletions. The only ignored file
  it clobbered was `.local/share/nvim` (handled above). Lists are in
  `~/trash/switch-to-main/`.
- Renamed to `merged/svelte-crostini` at `d321e1f`. The push started
  svelte's old CI; I cancelled all 3 runs. Pruned the 3 other clones.
- Smoke (`~/trash/switch-to-main/smoke-*.txt`), clean `env -i`: login bash,
  `bash -i`, `zsh -il`, vim (0 errors), tmux `-L`, `has`, `bootstamp` (after
  the fix): pass. nvim: `:Lazy! sync` updated 7 plugins, lockfile committed.
  `:checkhealth` showed zsh treesitter query errors, fixed by a zsh parser
  update. Its `$TERM` error comes from the headless run. kitty: not
  installed on penguin, not run. Login shells under `env -i` print a
  systemd user-bus warning; none when `XDG_RUNTIME_DIR` is set.
- Main's Check Vim, Check Neovim, and Lint Lua: green on `f490451`.
