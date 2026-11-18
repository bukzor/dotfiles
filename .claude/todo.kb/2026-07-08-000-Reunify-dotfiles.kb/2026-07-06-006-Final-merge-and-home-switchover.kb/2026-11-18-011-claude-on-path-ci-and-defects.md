---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-18-010-buck-win10-post-merge-cleanup.md  # Open Questions 1-3
---

# `claude` on fresh shells' PATH; CI hang; small main defects

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (after the merge)

## Problem Statement

Tentative rulings (user, 2026-11-18: "infer intent, tentative judgments").
The branches have been merged since `ff853dc`. Commit on **main** in
`dotfiles--main` and push. The plan's kb on svelte-crostini is the one
exception: your handoff file still lives there.

1. **Urgent: `claude` is not found in a fresh login shell** (verified:
   `env -i HOME=$HOME bash -lc 'command -v claude'` fails). Running
   sessions use `~/.local/share/pnpm/claude`.
   - Find the mechanism penguin uses to get `claude`: read
     `.config/sh/env.d/claude.sh`, `900-path.sh`, the pnpm global manifest
     `.config/pnpm/global/package.json`, and `d1b633a`'s "route claude
     through the proxy".
   - Make this host match it. If that mechanism means a manifest entry,
     add it. If it means a host install, do it. If nothing on main covers
     it, use Anthropic's native installer into `~/.local/bin`.
   - Don't disturb the running sessions' binary.
   - Prove it: `env -i HOME=$HOME bash -lc 'claude --version'` works, and
     the same under `zsh -l`.
2. **CI starvation.** Every Check sh run since 11-11 hangs until the
   6-hour default timeout.
   - Add `timeout-minutes` (5) to the Check workflows' jobs.
   - Find the hanging test: run the matrix locally under `timeout`, or
     read a run's last log lines. Fix it if the cause is clear; otherwise
     record it.
   - Then cancel the stale queued and in-progress Check runs with
     `gh run cancel` (they are rerunnable).
   - Report the first full run after the fix.
3. **`.config/sh/rc.d/upstream-replies.sh`** prints "command not found"
   when its tool is absent, contrary to its own comment. Make it silent in
   that case.
4. **`docs/ideas/never?`:** that name can't exist on NTFS, so the Windows
   checkout shows it as deleted. Rename it to a portable name and update
   any links to it.
5. **`init.templateDir`** names a directory that this host's
   git-localhost-store install provides, but the Windows home lacks it.
   Fix it the cheapest correct way: a guard, a conditional include, or
   installing it there too. Explain why.

6. **`lint-lua.yml`: a smoke test, not deleted** (added 2026-11-18).
   > [!@bukzor] 2026-11-18: much prefer a non-failing stub to deletion;
   > better, a very simple Lua smoke test.

   Unit 010 deleted it (main `208ca09`). Bring it back as a small workflow
   that runs on push, for example `luac -p` (or `luajit -bl`) over every
   tracked `*.lua`. Keep it minimal, and give it the same timeout as item
   2. Prove two things: a deliberately broken `.lua` fails it locally, and
   its first CI run on main passes.

Afterwards: `git -C ~ pull --ff-only` and `git -C /mnt/c/Users/worki pull
--ff-only` (WSL git for the latter, as unit 010 did).

**Scope (only these):** the files each item names, on main; host
installs for item 1; `gh run cancel`; the two pulls; this handoff file.

## Steps

- [x] 1 native `claude` in `~/.local/bin`; fresh `bash -l`/`zsh -l` find it
- [x] 2 CI: `timeout-minutes`, hanging test fixed, stale runs cancelled
- [x] 3 `upstream-replies.sh` silent when tool absent
- [x] 4 rename `docs/ideas/never?`
- [x] 5 `init.templateDir` on the Windows home
- [x] 6 `lint-lua.yml` as a LuaJIT parse check
- [x] pulls: `~`, `/mnt/c/Users/worki`

## Decisions

- 1: penguin uses the native installer (unit 003: `~/.local/bin/claude` ->
  `versions/2.1.207`); `900-path.sh` already has `~/.local/bin`. The pnpm
  manifest and `d1b633a` (only `ANTHROPIC_BASE_URL`) don't install it. Ran
  `claude.ai/install.sh`. It deleted the tracked dangling symlink
  `.claude/local` (`0acda47`); restored. `~/.local/share/pnpm/claude`
  (2.1.316, running sessions) untouched.
- 2: the hang was `zsh-startup_check.sh`'s `zsh -i` under `script`. The
  zkbd seed was named from zsh's built-in `$OSTYPE` (`linux-gnu`), but
  `env.d/010-ostype.sh` rewrites it to `linux`, so the zkbd wizard ran,
  then compinit's insecure-dirs prompt; CI's pty reads never return.
  Fix: name the seed after `.zshenv` runs; the workflow chmods the runner's
  group-writable `/usr/share/zsh{,/vendor-completions}`. Guards kept:
  `with_pty` stdin `/dev/null`, a 20s bound, transcript + compaudit on fail.
- 4: `probably-never`. Nothing links to it.
- 5: an empty `C:/Users/worki/.local/share/git-localhost-store/template-repo`
  (host mkdir, no repo change). Git has no "if exists" include, and a
  missing templateDir already means "no hooks", right for a host without
  git-localhost-store; the empty dir keeps that and drops the warning.

## Open Questions

1. Check Vim and Check Neovim never finish. Their `macos-12` jobs stay
   queued (the label is retired; `timeout-minutes` doesn't cover queue
   time), and the ubuntu/windows jobs exit 127, because they run
   `~/lib/ci/check-*.sh` but the checkout is `$GITHUB_WORKSPACE`, not `~`.
   Recommend: `./lib/ci/...` and `macos-latest`. Outside this brief.
2. The installer set `~/.claude.json` `installMethod` `global` -> `native`
   (backup in `~/trash/merge-011/`). Recommend keeping it, as on penguin,
   and retiring the pnpm and `npm-global` `claude` once those sessions end.

## Final report

- 1: `env -i HOME=$HOME {bash,zsh} -lc 'claude --version'` gives
  `~/.local/bin/claude` 2.1.327. Host install only. Handoff commit 24c93e1.
- 2 (main): `e56f200` timeouts + `with_pty` stdin; `398251d` bound and
  transcript; `bb3c7f9` zkbd seed; `2727b00`/`749cac2`/`3a77bd5`
  compaudit diagnosis and runner chmod. 199 stale runs cancelled, plus
  later superseded ones. First full Check sh pass since 07-12:
  run 44358892940 on `3a77bd5`, all steps green in 2 min.
- 3 `9c4d4ee`, 4 `1fb2705`, 6 `b4cc8b9` (main). 6: a broken `.lua` fails
  it locally (luajit via `nix shell`, xargs 123); Lint Lua passed on
  `b4cc8b9`, and again on `3a77bd5`.
- 5: `git.exe init` warned before the mkdir and is silent after
  (`/mnt/c/Users/worki/trash/merge-011/`).
- Pulls: `~` and `/mnt/c/Users/worki` (WSL git) at `3a77bd5`; `git.exe
  status docs/ideas` clean. Scratch: `~/trash/merge-011/`.
