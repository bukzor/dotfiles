---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-07-06-004-Hand-merge-true-divergences.kb/2026-11-18-003-vimrc-d-rulings.md  # Open Questions 1-2
  - ./2026-11-18-004-ignores-and-gitmodules.md  # Open Questions 1-4
  - ./2026-11-18-005-buck-win10-host-fixes.md  # Open Question 1
---

# Pre-merge follow-ups from the vimrc.d, ignores and host-fixes units

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (switch fallout)

## Problem Statement

Tentative rulings (user, 2026-11-18: "infer intent, tentative judgments").
Unless an item says "on main" only, land each change byte-identical on
both branches.

1. **Dead vim files, main only:** delete `.vim/autoload/plug.vim` and
   `.vim/autoload/bukzor/mason.vim`. First confirm nothing calls them.
2. **`<C-K>` clash:** `which-key.lua` binds `<C-K>` to signature help, which
   in nvim overrides `multiple-files.vim`'s `<C-K>` (window above). Move
   signature help to a free key, preferring one nvim's defaults or LSP
   conventions already suggest, and check that it is free.
3. **Penguin's public key under main's naming:** svelte tracks
   `.ssh/id_ed25519.pub`, whose comment is `bukzor@chromebook`. Main names
   per-host keys `id_*.pub.<name>`, and this host's plain `id_ed25519.pub`
   is an untracked symlink to its own named key. So:
   - Rename svelte's file to `.ssh/id_ed25519.pub.bukzor.chromebook`.
   - In `.ssh/.gitignore`, ignore the plain `/id_*.pub` names, which are
     per-host links.

   Before the rename, add this step to the parent plan's penguin checklist
   (the coordinator allows this one edit outside your scope): "after
   pulling, `ln -s id_ed25519.pub.bukzor.chromebook ~/.ssh/id_ed25519.pub`".
   Pulling the rename deletes penguin's plain file.
4. **`data/gcloud-private`, main only:** drop the gitlink. Its commit is on
   no remote anyone can find.
5. **pnpm:** port svelte's `.config/pnpm/config.yaml` to main, unchanged.
   Then find out why pnpm is not on main's login PATH here, and fix it in
   whatever svelte file already handles that, if one exists. Prove it:
   `pnpm --version` in a clean `bash -l`.
6. **Junk in `~`:** move `apk.dot*`, `install.sh`, `rustup.sh`,
   `package-lock.json` and `.themes/gruvbox-dark-gtk/` into
   `~/trash/home-junk/`. Leave `willy-practice.txt` and `package.json`
   alone.

Afterwards: push, `git -C ~ pull --ff-only`, `git -C ~ status --short`,
and confirm merge-tree still reports 0 conflicts.

**Scope (only these):** the paths named above in both workspaces; that
one line in the parent plan; moves within `~`; this handoff file.

## Steps

- [x] 1 delete dead `.vim/autoload/{plug,bukzor/mason}.vim` on main
- [x] 2 move signature help off `<C-K>`
- [x] 3 penguin checklist line; rename key; `.ssh/.gitignore`
- [x] 4 drop `data/gcloud-private` gitlink on main
- [x] 5 port `.config/pnpm/config.yaml`; fix pnpm on login PATH
- [x] 6 move `~` junk to `~/trash/home-junk/`
- [x] push; pull `~`; status; merge-tree 0 conflicts

## Decisions

- Signature help → `gK`: pairs with `K` (hover), is LazyVim's key for
  it, and is unbound in vim 9.2's `index.txt`, nvim 0.11's LSP defaults
  (`gr*`, `gO`, `i_CTRL-S`) and every plugin under `~/.local/share/nvim/lazy`.
- `.ssh/.gitignore` gains `/id_*.pub` after `!*.pub.*`. It also matches
  svelte's `id_ed25519_abby-tablet.pub`, which stays tracked (ignores
  never touch tracked paths). The key file also lands on main, so both
  branches match.
- pnpm: both branches' `env.d/900-path.sh` already put `~/prefix/pnpm/bin`
  on PATH. The directory held no pnpm because this host never bootstrapped
  svelte's mechanism (ADRs 2026-08-27-000 and 2026-09-10-000), so no shell
  file needed a change. The fix was a host install. pnpm 10 (which ignores
  `config.yaml`) ran `pnpm add -g corepack` with svelte's dirs passed as
  flags. corepack's own `pnpm` bin then runs pnpm 12.21.0, which reads
  `config.yaml`. Under pnpm 12, `pnpm add -g --allow-build=bun corepack prettier`
  reinstalled both into `global/v11`, using `pnpm-upgrade-g`'s flag list so a
  later upgrade run lands in the same dir. pnpm 10's `global/5` went to
  `~/trash/pnpm-bootstrap/`.

## Open Questions

1. `~/.ssh/id_rsa.pub` (`worki@buck-win10`) is a real file, not a link,
   and no tracked `id_*.pub.*` holds it. The new ignore hides it.
   Recommend tracking it as `.ssh/id_rsa.pub.worki.buck-win10` and making
   the plain name a link, as `id_ed25519.pub` already is.
2. corepack 0.36.0 warns that it wants node `^24.15.0`, and Alpine's node
   here is 24.14.1. It works anyway. Check again after `apk upgrade`.
3. `~/package.json` here has no `packageManager` pin, so corepack runs
   its default pnpm (12.21.0). The pin arrives with 008's `package.json`.

## Final report

- main: `63209a9` (delete `plug.vim`, `bukzor/mason.vim`; no callers),
  `7978b36` (which-key `gK`), `9d0c945` (`.ssh` key and ignore),
  `5b58306` (drop `data/gcloud-private`), `c0370d0` (`config.yaml`).
  svelte: `1d80013` (which-key), `5bb3900` (parent plan: penguin
  `ln -s` step), `2e2828c` (`.ssh`). All pushed. `git diff origin/main
  origin/svelte-crostini` is empty for which-key.lua, `.ssh/.gitignore`,
  both key paths and `config.yaml`.
- which-key.lua parses (vim 9.2 `+lua` `loadfile`). No nvim here: `gK` is untested live.
- In `env -i` `bash -l` and `zsh -l`, `pnpm --version` prints 12.21.0
  (`~/prefix/pnpm/bin/pnpm`), and `pnpm bin -g` is `~/prefix/pnpm/bin`.
  `prettier` still works; `~/package.json` is byte-unchanged. In a clean
  `bash -l`, svelte's `redo -k test` is all green, `pnpm starts` included.
- Moved all six junk paths into `~/trash/home-junk/`.
- `~` pulled to `c0370d0`. `git -C ~ status --short` shows 7 entries:
  `.claude/sessions.kb`, `.aws`, `.azure`, `.boon/` (new, not mine),
  `deadlock-builds-recovery/`, `package.json`, `willy-practice.txt`.
- `merge-tree --write-tree --allow-unrelated-histories origin/main
  origin/svelte-crostini` exits 0 with 0 CONFLICT lines (tree `f70f342`).
  The plain `.ssh/id_ed25519.pub` clash from 004's OQ2 is gone.
