---
managed-by: Skill(llm-subtask)
status: done
blocked-by:
  - ./2026-11-18-006-claude-tokens-prices-and-breakdown.md
  - ./2026-11-18-007-pre-merge-followups.md
required-reading:
  - ./CLAUDE.md
  - ../2026-07-06-006-Final-merge-and-home-switchover.md  # Implementation Steps: tests first, preflight, merge, review
  - ./2026-11-18-004-ignores-and-gitmodules.md  # Open Question 2: what the merge will collide with in ~
  - ../2026-07-07-000-CI-and-testing-foundations.md  # the X_check.sh shape
---

# The 006 merge, and buck-win10's `~` taking it

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md>

## Problem Statement

Main and svelte-crostini now merge with zero conflicts (2026-11-18). Do the
parent's steps up to and including "push main", then bring this host's `~`
onto the merged main. Penguin's switch is the user's, on penguin, and is
out of scope.

1. **Tests first:** a run-once `X_check.sh` asserting the merge-tree
   conflict count is 0 (the parent's first step). Then run the merged-tree
   suite in a scratch checkout, as the parent says. Show the suite failing
   on a deliberately conflicting scratch pair, so you know it can fail.
2. **Merge** svelte-crostini into main in `dotfiles--main` with
   `--allow-unrelated-histories`, using a message that names both
   lineages. Review: `git diff main svelte-crostini` should show only the
   paths that exist only on main. Spot-check that they survived. Push main.
3. **Pull into `~`.** The fast-forward will refuse over the four
   untracked-but-incoming paths that the ignores unit listed (`.aws/`,
   `.azure/`, `package.json`, and `.ssh/id_ed25519.pub` is resolved by unit
   007). For each:
   - **`.aws` and `.azure`** are symlinks into Windows here, and svelte
     tracks a `.gitignore` inside each. Pick a layout where `git status` is
     clean and the AWS and Azure CLIs still read the Windows-side files.
     For example, a real directory with the tracked `.gitignore`, plus
     per-file symlinks into `/mnt/c`. Prove it: `aws configure list`, or
     whatever exists, still works.
   - **`package.json`:** diff it against svelte's. Move the local copy to
     `~/trash/` and record what differed.
   Then pull, and rerun the parent's smoke test on this host.

   Also (unit 007's Open Question; tentative judgment, user 2026-11-18): this
   host's `~/.ssh/id_rsa.pub` (`worki@buck-win10`) is a real file that the
   new `/id_*.pub` rule hides. Track it on main as
   `.ssh/id_rsa.pub.worki.buck-win10`, and make the plain name a link to it.

Record the merge commit and the pre-pull commit in your Final report, and
the rollback for each.

**Scope (only these):** the merge commit and the check script in
`dotfiles--main`; `.ssh/id_rsa.pub.worki.buck-win10` on main; moves and
symlinks in `~` for the paths above; `git pull`
in `~`; this handoff file.

## Steps

- [x] 1 `final-merge_check.sh` on main; merged-tree suite in a scratch
      checkout; the check failing on a conflicting scratch pair
- [x] 2 merge, review, push main
- [x] 3 `~`: `.aws`/`.azure` layout, `package.json` aside, ignored-file
      collisions backed up; pull; `id_rsa.pub` tracked and linked; smoke test

## Decisions

- Check: root `final-merge_check.sh`, shaped like `mechanical-fast-forwards_check.sh`.
  Asserts `merge-tree --write-tree` exits 0 *and* prints no `CONFLICT` line
  (a fatal merge-tree error can't pass as "0 conflicts"). Skips when
  `origin/<other>` is gone, so the `merged/` rename won't turn it red.
- Merged-tree suite runs in a clean `env -i bash -l`. In the agent's stale
  PATH, pnpm 10 (`~/prefix/npm-global/bin`) fails `pnpm starts` on the merged
  `package.json`'s pnpm 12.8.1 pin (see OQ 3); the tree is not at fault.
- `.aws`, `.azure`: plain directories holding the tracked `.gitignore`, no
  links. The Windows-side dirs hold only that same `.gitignore`
  (`diff -r` identical), and no AWS or Azure CLI exists on either side, so
  there is nothing to link. A dangling per-file link (`.aws/config`) would
  show untracked under the opt-out `.gitignore`.
- Collision sweep before pulling: of 823 incoming paths, only `.aws/.gitignore`,
  `.azure/.gitignore`, `package.json` existed in `~` (no ignored file overwritten).

## Open Questions

1. `/mnt/c/Users/worki` (Windows `$HOME`) is itself a `svelte-crostini`
   checkout of dotfiles, missing from the topology table. Recommend deciding
   its fate (switch to main, or retire) before 009 renames `svelte-crostini`.
2. `~/.aws`/`~/.azure` no longer share with Windows. If a CLI is ever
   installed, point it at Windows by env (`AWS_CONFIG_FILE`,
   `AWS_SHARED_CREDENTIALS_FILE`, `AZURE_CONFIG_DIR`) in a host env file.
3. Shells started before the pull still resolve pnpm 10 from
   `~/prefix/npm-global/bin`, which fails in `~` on the 12.8.1 pin ("Failed
   to switch pnpm", ENOEXEC). Fresh login shells get 12.8.1. Recommend
   removing that pnpm 10 (`npm-global` also holds `claude`; keep that).
4. Old `package.json` dependency `@anthropic-ai/claude-code ^1.0.67` leaves
   `~/node_modules/` and `~/pnpm-lock.yaml` (2025-09) orphaned. Recommend
   trash.
5. CI on main now runs svelte's workflows: `lint-lua.yml` fails (known
   broken, 2026-07-07-000); Check sh/Vim/Neovim were still queued at handoff.

## Final report

- main (`dotfiles--main`, pushed): `0390a5a` check script; merge
  **`ff853dc`** (parents `0390a5a`, `fd57095`); `5a36dab` `.ssh/id_rsa.pub.worki.buck-win10`.
- Check: green on pre-merge main and on the merged scratch tree; on a
  scratch pair with an `.inputrc` add/add it fails both asserts and the
  suite exits 1 (`CONFLICT (add/add): Merge conflict in .inputrc`).
- Merged-tree suite (`do -c test`, scratch clone): 150 ok, 0 not ok;
  dash absent here (7 skips). Scratch merge tree `466aba0` == pushed tree.
- Review: `diff-tree origin/svelte-crostini ff853dc` is 319 `A` paths, every
  one main-only and byte-unchanged from `0390a5a`; main side gained 821 `A`, no M/D.
- `~`: pre-pull **`c0370d0`**, now `5a36dab`. Moved to `~/trash/merge-008/`:
  `aws.symlink`, `azure.symlink`, `package.json` (had the claude-code dep,
  no `packageManager` pin), `id_rsa.pub` (now a link, `cmp`-identical,
  matches `ssh-keygen -y id_rsa`). `git status`: only the pre-existing
  `.claude/sessions.kb`, `.boon/`, `deadlock-builds-recovery/`, `willy-practice.txt`.
- Smoke (`env -i`): `bash -l` (pnpm 12.8.1, `has`, `bootstamp`), `bash -i`,
  `bash -li`, `zsh -i`, `zsh -li` under a pty: no stray output; vim 9.2
  `:messages` empty; `tmux -f ~/.tmux.conf` loads. nvim, kitty absent here.
- Rollback, `~`: `git -C ~ reset --keep c0370d0`, then move the four
  trash items back. Rollback, merge: `git push --force-with-lease=main:5a36dab
  origin 0390a5a:main`, then re-apply `5a36dab` if wanted.
