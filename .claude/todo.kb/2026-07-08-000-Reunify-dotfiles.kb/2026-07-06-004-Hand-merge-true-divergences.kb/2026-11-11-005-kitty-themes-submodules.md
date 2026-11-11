---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-07-06-004-Hand-merge-true-divergences.md  # "kitty.conf + .gitmodules"; ".themes/"
  - ../2026-07-06-002-Stale-seed-adjudication.md  # its kitty.conf/.gitmodules findings
  - ../2026-11-10-000-Fold-wsl-buck-win10-into-main.md  # merge step: `.gitmodules` gained `.claude/sessions.kb`
---

# Kitty config, `.themes/`, and the merged submodule set

**Parent:** <../2026-07-06-004-Hand-merge-true-divergences.md> (wave 1, escalated from 002)

## Problem Statement

Linked: main's `.config/kitty/kitty.conf` `include`s a theme from main-only
submodule `kitty-gruvbox-theme`, so the conf and `.gitmodules` merge
together. The parent gives the shape: union of main's kitty customization
and svelte's `linux_display_server x11`; a merged submodule set (svelte's
plus main's, checking `scratch`'s two remotes for which is current).

Decided (user, 2026-11-10): `.themes/` is svelte's `Gruvbox-GTK`; main's
`gruvbox-dark-gtk` submodule goes, entry and gitlink.

Every submodule in the merged `.gitmodules` must exist as a gitlink on both
branches at the same commit, and each recorded commit must be on its
remote (`git ls-remote`). Adding a gitlink on a branch that lacks it is
`git update-index --add --cacheinfo 160000,<sha>,<path>` plus the
`.gitmodules` entry; no checkout needed.

No kitty here: check `kitty.conf` statically (every `include` resolves to a
tracked file on both branches).

**Scope (only these files):** `.config/kitty/` (conf and theme submodule),
`.themes/`, `.gitmodules`, and the gitlinks it names, in both workspaces;
this handoff file.

## Steps

- [x] inventory: both `.gitmodules`, gitlinks, `ls-remote` + treeless
      fetch of every submodule remote (`~/trash/kitty-005/`)
- [x] author merged `.gitmodules` and `kitty.conf` once (`~/trash/kitty-005/`)
- [x] main: apply; gitlinks +7 (svelte's set, `repo/scratch`), −2
      (`scratch`, `.themes/gruvbox-dark-gtk`); commit, push
- [x] svelte: apply; gitlinks +2 (`kitty-gruvbox-theme`, `data/gcloud`),
      `repo/scratch` repointed; commit, push
- [x] checks: `git config -f .gitmodules -l`, gitlink/entry parity, include
      resolves, `git diff origin/main origin/svelte-crostini` empty

## Decisions

- `scratch` → path `repo/scratch`, url `git@github.com:bukzor/scratch.git`,
  commit `9f62277`. Not a judgment call. Svelte's path move (`scratch` →
  `repo/scratch`, `5a87c42` 2025-10-22) is newer than main's path, and it
  follows the `repo/` clone convention both branches' `repo/.gitignore` share.
  Svelte's url `/home/bukzor/scratch/` is local to one host, and its commit
  `b45a792` is on no GitHub ref, which breaks the brief's "on its remote"
  rule. GitHub's `tmp` tip `9f62277` (2025-08-21) is the newest scratch work.
  It descends from `master` (`e196083`, 2023).
- Svelte-only gitlinks go onto main at svelte's commits, not bumped to
  upstream tips. Main-only gitlinks go onto svelte at main's commits.
- `kitty.conf`: main's file, with its commented default
  `# linux_display_server auto` (line 1517) set to `x11`. No reason comment
  added, because neither branch recorded one. The setting is ignored on macOS.

## Open Questions

- **Penguin, before 006 switchover (action, not ruling):** `b45a792` exists
  only in penguin's local scratch repo. Check whether it holds unpushed work,
  and push it to `bukzor/scratch` if so. Then run `git submodule sync
  repo/scratch` in penguin's `~`.
- **Out of scope, found here:** main has two gitlinks that `.gitmodules`
  doesn't name: `data/gcloud-private` (`8ac44c1`) and `docs/private`
  (`0357379`, added in `e864155` as "private bukzor-docs"). Both exist only on
  main, so 006 merges them clean. `git submodule` commands still warn "no
  mapping". Options: add `.gitmodules` entries pointing at their private
  remotes, or drop the gitlinks. Recommend adding the entries. They are
  intentional private submodules, and an entry costs nothing for public
  clones that never init them.

## Final report

- main `ec53378`, svelte-crostini `b7d49b5`, both pushed. Authored copies:
  `~/trash/kitty-005/{gitmodules.merged,kitty.conf.merged}`. Treeless remote
  fetches: `~/trash/kitty-005/*.git`.
- Checks: `git config -f .gitmodules -l` parses. `.gitmodules` is
  byte-identical on both branches. All 10 entries are gitlinks on both
  branches at the same commit, and each commit is on a branch of its remote
  (treeless fetch plus `branch -r --contains`; lazy and skills are on
  `main`). `include ./kitty-gruvbox-theme/gruvbox_dark_soft.conf` resolves
  in `b60d532`. `git diff origin/main origin/svelte-crostini` over
  `.gitmodules`, `.config/kitty`, `.themes`, and every gitlink path is empty.
- Not run: `kitty` isn't installed here, so `kitty.conf` was checked only
  statically.
- Deviations: none. The two private gitlinks above were left untouched.
