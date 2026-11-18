---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-18-000-switch-buck-win10-home-to-main.md  # Open Questions: GitHub ssh, Nix
  - ./2026-11-18-001-config-references-missing-on-main.md  # Open Questions 2-4
---

# buck-win10 host fixes after the switch

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (switch fallout)

## Problem Statement

Tentative rulings (user, 2026-11-18: "infer intent, tentative judgments"):

1. **GitHub ssh.** `.ssh/config.d/github.sshconfig` exists only on main. It
   pins `IdentityFile ~/.ssh/sentry-github`, a key from a past employer that
   this host doesn't have. Remove the pin on main so ssh falls back to its
   default keys. Prove it: `ssh -T git@github.com` authenticates with no
   `GIT_SSH_COMMAND`. If the file then does nothing at all, delete it.
2. **Nix.** Port svelte's `.config/sh/env.d/400-nix.sh` to main, unchanged.
   If it doesn't work on this host (the Nix install path differs), say why
   under Open Questions, and land nothing. Prove it: a new login shell has
   `nix` and `direnv` on PATH. Compare against the old `.zshenv` saved in
   `~/trash/switch-to-main/clobbered/`.
3. **`init.templateDir`.** Find out what git-localhost-store is (look for
   it under `~/repo/`, and in `.gitconfig`'s history on both branches). If
   it's the user's own tool with a cheap install, install it here.
   Otherwise, record the facts and your recommendation under Open
   Questions; `.gitconfig` is shared, so don't edit it.
4. **Host installs:** `pnpm add -g prettier`, then show that
   `prettier-markdown` works on a sample.
5. **Added 2026-11-18,** from the Open Questions of
   `./2026-11-18-002-commands-agents-are-told-to-run.md`. This host is
   Alpine.
   - Run `apk add findutils zstd`, then show that `claude-open-tasks-list`
     gets past `find` and that `zstd --version` works. If apk needs sudo
     and you get a permission prompt, the user answers it; never work
     around a denial.
   - Install the user's bukzor-tools here (it provides `claude-path` and
     `claude-search`; see main `922d325`), following its own install
     instructions. Then show that `claude-jsonl-path` prints a slug.
   - Clone `private.meta-reasoning-corpus` to the path that the dangling
     `~/.claude/{sessions,todo}.kb` symlinks expect, and show those links
     now resolve. It is private: clone it, never publish anything from it.

Commits push main (and svelte, if anything shared changes), then `git -C ~
pull --ff-only`. Until item 1 lands, use unit 001's ssh workaround.

**Scope (only these):** `.ssh/config.d/github.sshconfig` and
`.config/sh/env.d/400-nix.sh` on main; host-local installs; `git pull` in
`~`; this handoff file.

## Steps

- [x] 1 GitHub ssh: drop the pin (or the file); push; pull `~`; prove `ssh -T`
- [x] 2 Nix: port `env.d/400-nix.sh` if it works here; prove login PATH
- [x] 3 `init.templateDir`: identify git-localhost-store; install or record
- [x] 4 `pnpm add -g prettier`; prove `prettier-markdown`
- [x] 5a `apk add findutils zstd`; prove `claude-open-tasks-list`, `zstd`
- [x] 5b install bukzor-tools; prove `claude-jsonl-path`
- [x] 5c clone `private.meta-reasoning-corpus`; prove `~/.claude/{sessions,todo}.kb`

## Decisions

- Deleted `github.sshconfig`: without the pin it only restated defaults
  (every github remote here is `git@`/https; GitHub offers only publickey).
- Item 3 is item 5b: git-localhost-store is a bukzor-tools package (its
  dotfiles copy retired in main `749fd5f`). Its installer always runs
  `git config --global init.templateDir <absolute path>`, which would rewrite
  the shared `.gitconfig`'s `~/...` value. Ran it with
  `GIT_CONFIG_GLOBAL=~/trash/gitconfig-for-glhs-install`; `~/.gitconfig`
  is byte-unchanged.
- Also cloned `2026-05-19--task-archeology` (private): 4 of the 7 dangling
  `sessions.kb` links point there, only 3 into the corpus.
- prettier: pnpm 10 here ignores main's `.config/pnpm/rc` `prefix=`
  (`ERR_PNPM_NO_GLOBAL_BIN_DIR`), so I passed svelte's layout on the command
  line: `--config.global-bin-dir=~/prefix/pnpm/bin --config.global-dir=~/prefix/pnpm/global`.
  No config file edited.

## Open Questions

1. **pnpm is not on main's login PATH here.** The only pnpm is
   `~/prefix/npm-global/bin/pnpm` (10.14, from the old `.npmrc` prefix).
   Svelte self-hosts pnpm 11 in `~/prefix/pnpm/bin` and configures it in
   `.config/pnpm/config.yaml`, which main lacks (svelte ADR 2026-08-27-000).
   svelte's suite fails `stale-seed-adjudication: pnpm starts` here for
   this reason. Recommend: 004/006 lands `config.yaml` on main, then a
   host-local `pnpm add -g pnpm` self-hosts it here.
2. **`claude-open-tasks-list` still exits 1 on a full run.** GNU `find`
   now parses the query; it exits 1 on the root-owned 0700
   `~/repo/AlpineWSL/src_x64/rootfs/root` (llm-kb todo `2026-08-27-001`).
3. **bukzor-tools:** `git-localhost-store-install` should skip the write
   when `init.templateDir` already resolves to its template.

## Final report

- main `9e35234`: deleted `.ssh/config.d/github.sshconfig`. With no
  `GIT_SSH_COMMAND`, `ssh -T git@github.com` prints "Hi bukzor!".
- main `fee1e01`: `.config/sh/env.d/400-nix.sh`, svelte's blob (644).
  `git diff origin/main origin/svelte-crostini` is empty for both paths.
  `env -i` `bash -l`, `zsh -l`, and `zsh -i` find `~/.nix-profile/bin/{nix,direnv}`. The
  old `.zshenv`'s other line (`.cargo/env`) is already covered:
  `900-path.sh` puts `~/.cargo/bin` on PATH. `~` fast-forwarded to `fee1e01`.
- `sh -n` passes. `redo -k test` fails only on `pnpm starts` (OQ1).
- `sudo apk add findutils zstd`: GNU find 4.10.0, zstd 1.5.7.
  `claude-open-tasks-list` with its roots narrowed past the unreadable
  dir exits 0 (1212 lines); the full run fails as OQ2 says.
- bukzor-tools cloned to `~/repo/github.com/bukzor/bukzor-tools`;
  `uv tool install --editable .` (15 commands in `~/.local/bin`). The
  installer created the template and relocator. `git init` no longer
  warns. A scratch commit relocated `.git` into the store.
  `claude-jsonl-path ~` prints `~/.claude/projects/-home-bukzor`.
- `private.meta-reasoning-corpus` and `2026-05-19--task-archeology` cloned
  under `~/repo/github.com/bukzor/` (relocated by the new hooks). No
  dangling links remain in `~/.claude/{sessions,todo}.kb`.
- prettier 3.10.1 in `~/prefix/pnpm/bin`. On a sample, a login shell's
  `prettier-markdown` exits 0 and rewraps the text to 80 columns.
- Scratch is in `~/trash/`: `glhs-proof/` (its store
  `-home-bukzor-trash-glhs-proof`), `open-tasks*`, `prettier-sample.md`,
  `gitconfig-for-glhs-install`.
