---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-18-000-switch-buck-win10-home-to-main.md  # Open Questions: security, untracked noise, proposed entries
  - ../2026-07-06-004-Hand-merge-true-divergences.kb/2026-11-11-005-kitty-themes-submodules.md  # Open Questions: the two private gitlinks
  - ../2026-07-06-004-Hand-merge-true-divergences.md  # "git config": the allow-by-default ignore ruling
---

# Ignores for `~` on main; `.gitmodules` entries for the private gitlinks

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (switch fallout)

## Problem Statement

Tentative rulings (user, 2026-11-18: "infer intent, tentative judgments"):

1. **Security first.** Ignore `private-dotfiles/` before anything else.
   This host has keys and credentials there, untracked, in a public repo.
   Push that alone.
2. **Untracked noise.** The switch unit proposed ignore entries for about
   35.6k untracked paths in `~`. Apply them, keeping the scheme the user
   ruled: allow by default, so ignore what is machine state or
   tool-managed, and let real config stay visible as untracked. An entry
   that would hide something that looks like hand-written config goes
   under Open Questions instead. Use the `.gitignore` nearest the noise
   when one exists there.
3. **Private gitlinks.** Add `.gitmodules` entries for main's
   `data/gcloud-private` and `docs/private`, pointing at their private
   remotes (find the URLs from history, or from a local clone's config).
   No `init`.

Every ignore file and `.gitmodules` change lands byte-identical on both
branches. Then `git -C ~ pull --ff-only`, and report `git -C ~ status
--short | wc -l` before and after, plus what is left.

Same ssh workaround as unit 001.

**Scope (only these files):** `.gitignore` files and `.gitmodules`, in
both workspaces; `git pull` in `~`; this handoff file.

## Steps

- [x] security: `/private-dotfiles/` in root `.gitignore`, both branches,
      pushed alone; `~` pulled
- [x] untracked noise: root entries; svelte's `.local/share/`, `claude/`, `prefix/` ignores onto main
- [x] `.gitmodules`: `docs/private` entry
- [x] pull `~`; status counts; handoff record

## Decisions

- Nearest `.gitignore`: svelte already had `.local/share/`, `claude/` and
  `prefix/` ones (main's root even names `.local/share/.gitignore`), so main
  takes them verbatim, plus `!claude-bin/` for main's tracked shims.
  Root gains `.ash_history`, `/.nix-{profile,channels,defexpr/}`, `/winhome`.
- Not ignored, against unit 000's proposal: `.aws`, `.azure` (symlinks into
  `/mnt/c`). Tested in `~/trash/ignores-004/symtest/`: when a tracked file
  arrives under an *ignored* symlink, checkout silently replaces the symlink
  with a real directory; an untracked one makes checkout refuse. Svelte
  tracks `.aws/.gitignore` and `.azure/.gitignore`, so at the 006 merge,
  ignoring them would silently cut `~/.aws` loose from Windows.
- Not ignored: `deadlock-builds-recovery/` (568K of recovered Deadlock
  build snapshots: user data, not machine state); `.themes/gruvbox-dark-gtk/`
  and the stray files (deleting or moving them is outside this scope).
- `docs/private` → `git@github.com:bukzor/bukzor-docs.git`. Its gitlink
  `0357379` is that repo's `main` tip (`ls-remote`); commit `e864155` names
  "private bukzor-docs". Svelte gets the entry before the gitlink, which
  arrives cleanly with the 006 merge.

## Open Questions

1. **`data/gcloud-private` has no findable remote.** `8ac44c1` is in no
   `bukzor` repo (all 11 private ones probed), no org repo, no local clone,
   and no `.gitmodules` history. Recommend dropping the gitlink. It was
   probably never pushed off a work laptop. No entry added.
2. **006 merge vs buck-win10's `~`:** svelte tracks `.aws/.gitignore`,
   `.azure/.gitignore`, `.ssh/id_ed25519.pub` (penguin's key) and
   `package.json`, which here are a symlink into Windows (x2), a symlink to
   `id_ed25519.pub.buck-win10-wsl`, and an untracked file with different
   content. The merge will refuse (good). Options per path: make it a real
   directory, rename svelte's key to main's `.pub.<host>` form, or move
   it aside. Recommend renaming the key, and moving `~/.aws` and `~/.azure`
   aside until the merge lands, then re-linking them.
3. `.ssh/{id_ed25519,id_rsa}.pub` stay visible (`.ssh/.gitignore` opts `*.pub` in): track or delete?
4. Unit 000's leftovers, outside this scope: move `apk.dot*`, `install.sh`,
   `rustup.sh`, `package-lock.json`, `willy-practice.txt` to `~/trash/`;
   `rm -r .themes/gruvbox-dark-gtk/` (old gitlink checkout).

## Final report

- main: `b422b1b` (private-dotfiles), `64cff55` (ignores), `68cff5d`
  (`.gitmodules`). svelte-crostini: `eab0719`, `76e61a4`, `f08e738`. All
  pushed. `git diff origin/main origin/svelte-crostini` over `.gitignore`,
  `.gitmodules`, `{.local/share,claude,prefix}/.gitignore` is empty.
- Checks: `check-ignore -v` on each new pattern; `git config -f .gitmodules -l`
  parses; `git submodule status docs/private` maps (uninitialized, no `init`).
- `~` pulled to `68cff5d` (also brought peers' vim commits). `git status
  --short | wc -l`: 31 before, 14 after (`-uall`: 37108 → 18). Left:
  `.claude/sessions.kb` (lazy gitlink), and the paths in Decisions/OQ 2-4.
- Deviations: did not ignore `.aws`, `.azure`, `deadlock-builds-recovery/`
  (reasons above); no `data/gcloud-private` entry (OQ 1).
