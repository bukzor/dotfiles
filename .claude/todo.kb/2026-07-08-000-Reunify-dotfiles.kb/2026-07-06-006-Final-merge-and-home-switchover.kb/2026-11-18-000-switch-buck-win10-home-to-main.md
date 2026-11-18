---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []  # main's .claude/CLAUDE.md is svelte's since 6bfc6f4
required-reading:
  - ./CLAUDE.md
  - ../CLAUDE.md  # the merged/ branch ruling, topology
  - ../2026-07-06-006-Final-merge-and-home-switchover.md  # per-host steps, smoke test, rollback
---

# buck-win10: switch live `~` to main, retire `wsl-buck-win10`

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (the
buck-win10 rows of its per-host steps, brought ahead of the merge)

## Problem Statement

> [!@bukzor] 2026-11-18: rename `wsl-buck-win10` to `merged/wsl-buck-win10`,
> locally and on origin, and swap `~` to main as soon as possible.

`wsl-buck-win10` is fully contained in main. Its tip `fa3f7c7` is an ancestor
of `origin/main`. Main is not yet merged with svelte-crostini; that doesn't
block this host.

1. **Preflight, before touching `~`:**
   - Record the pre-switch commit.
   - List the paths that `origin/main` tracks and `HEAD` does not, but that
     already exist in `~` (they are ignored under the old branch's
     deny-first scheme). Checkout silently overwrites ignored files. Copy
     every one whose content differs into
     `~/trash/switch-to-main/clobbered/`, and list them.
   - List the paths that checkout will delete: tracked on `HEAD`, absent
     from `origin/main`.
   - Leave `.claude/sessions.kb`'s modified gitlink alone. It is lazily
     bumped.
   - Peer Claude sessions sit idle in `~`. Don't wait for them.
2. **Switch:** create a local `main` tracking `origin/main` and check it
   out in `~`.
3. **Rename:** rename the local `wsl-buck-win10` to `merged/wsl-buck-win10`.
   On origin, create `merged/wsl-buck-win10` at the same commit and delete
   `wsl-buck-win10`. Set the renamed branch's upstream to the renamed
   remote branch. Run `git fetch --prune` in every other clone of this repo
   on this host.
4. **Review:** report `git -C ~ status`. Main uses allow-by-default
   ignores, so expect new untracked files: report them grouped by
   top-level directory, with proposed ignore entries. **Edit no ignore file**.
   Ignore files must land byte-identical on both branches, so that is a
   later unit.
5. **Smoke test** (006's list): new login shell, `bash -i`, `zsh -i`,
   headless vim startup, tmux on a scratch socket (`-L`), `~/bin/has`,
   `~/bin/bootstamp`, `jq` on `~/.claude/settings.json`. Also check that
   `/etc/service` → `~/.config/runit/buck-win10/` still resolves, and that
   `findmnt ~/.config/windows` still shows the mount.

Rollback, if a smoke test breaks something you can't fix inside this scope:
`git -C ~ switch merged/wsl-buck-win10`. Then report.

**Scope (only these):** `~`'s checkout, branch refs locally and on origin,
`~/trash/switch-to-main/`, this handoff file. No edits to tracked content.

## Steps

- [x] preflight: pre-switch `fa3f7c7`; lists in `~/trash/switch-to-main/`
- [x] switch `~` to main (`6bfc6f4`)
- [x] rename branch locally and on origin; prune the 3 other clones
- [x] review `git -C ~ status`
- [x] smoke test

## Decisions

- Stayed on main despite github ssh breaking (OQ1): not a listed smoke
  test, a no-file workaround exists, and a peer had already edited on main.
- Pushed the rename with `GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa -o IdentitiesOnly=yes'`
  (env only; no file touched). `id_ed25519` is not authorized on GitHub.

## Open Questions

1. **GitHub ssh is broken in `~` on main.** Main's
   `.ssh/config.d/github.sshconfig` pins `IdentityFile ~/.ssh/sentry-github`,
   absent here, so ssh stops trying default keys. Options: (a) local
   untracked `~/.ssh/config.d/local.sshconfig` adding `IdentityFile
   ~/.ssh/id_rsa` for github.com (IdentityFile accumulates); (b) drop the
   pin from the tracked file, on both branches. Recommend (b): the pin names
   a key from a past employer.
2. **Nix dropped from PATH.** The old `.profile` and live `.zshenv` sourced
   `~/.nix-profile/etc/profile.d/nix.sh`; main sources neither, so `direnv`
   (which main's `rc.d/direnv.sh` hooks) and `nix` vanish. Keep nix?
3. **Untracked secrets.** `private-dotfiles/ant/{admin-key,claude-code.credentials.json}`
   are untracked and not ignored in a public repo. Ignore `private-dotfiles/` first.
4. Proposed ignore entries (no ignore file edited), by top-level directory:
   - `.local/` (32934 files), all under `.local/share/`: `pnpm/`, `direnv/`,
     `uv/`, `delta/`, `apktool/`, `bukzor.deadlock-data/`, `applications/`,
     `man/` (git-partial's generated `git-commit-*.1`)
   - `prefix/` (2631): `prefix/` (brew, npm-global, rbenv, ruby26)
   - `claude/` (7 dirs), `deadlock-builds-recovery/`: scratch, ignore
   - host-local: `.aws`, `.azure`, `winhome` (symlinks into `/mnt/c`),
     `.nix-profile`, `.nix-channels`, `.nix-defexpr/`, `.ash_history`
   - `.ssh/*.pub` (`id_ed25519.pub`, `id_rsa.pub`): track or ignore? user call
   - stray files: `apk.dot*`, `install.sh`, `rustup.sh`, `package*.json`,
     `willy-practice.txt`: move to `~/trash/` rather than ignore
   - `.themes/gruvbox-dark-gtk/`: old gitlink git couldn't rmdir (main has
     `.themes/Gruvbox-GTK`); delete or ignore. (`scratch/`, same case, is ignored.)
   - `bin/alert-wsl`: a peer session's new file, theirs to commit

## Final report

- Pre-switch commit `fa3f7c7`. Clobbered: only `.zshenv` (it differed: the
  Nix installer line), backed up to `~/trash/switch-to-main/clobbered/.zshenv`;
  `data/gcloud` (plain dir where main has a gitlink, untouched) copied too.
  Deleted by checkout: 171 blobs + 2 gitlinks, listed in `deleted.paths`.
- `~` on local `main` tracking `origin/main` (`6bfc6f4`). `.claude/sessions.kb`
  left modified. `bin/alert` shows modified: a peer session's edit at 16:06,
  after the switch, not mine.
- `merged/wsl-buck-win10` at `fa3f7c7`, local and origin, upstream set;
  `origin/wsl-buck-win10` deleted; `dotfiles`, `dotfiles--main`,
  `dotfiles--svelte-crostini` pruned.
- Smoke, all pass (clean `env -i`; `~/trash/switch-to-main/smoke-*.txt`):
  bash/zsh login + interactive (also under a pty), vim, tmux `-L`, `has`,
  `bootstamp`, `jq`, `/etc/service` (4 services), `findmnt` (9p drvfs).
- Not smoke-listed but broken: GitHub ssh, nix PATH (Open Questions 1-2).
