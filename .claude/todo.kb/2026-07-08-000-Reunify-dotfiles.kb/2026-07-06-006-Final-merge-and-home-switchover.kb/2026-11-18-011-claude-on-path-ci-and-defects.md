---
managed-by: Skill(llm-subtask)
status: open
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
- [ ] 2 CI: `timeout-minutes`, hanging test, cancel stale runs
- [ ] 3 `upstream-replies.sh` silent when tool absent
- [ ] 4 rename `docs/ideas/never?`
- [ ] 5 `init.templateDir` on the Windows home
- [ ] pulls: `~`, `/mnt/c/Users/worki`

## Decisions

- Penguin's mechanism is the native installer: unit 003 recorded
  `~/.local/bin/claude` -> `~/.local/share/claude/versions/2.1.207` there,
  and `900-path.sh` already puts `~/.local/bin` on PATH. Nothing in the pnpm
  manifest or `d1b633a` (which only sets `ANTHROPIC_BASE_URL`) installs it.
  So: ran `claude.ai/install.sh` here, no repo change. 2.1.327 installed.
- The installer deleted the tracked dangling symlink `.claude/local`
  (-> `../.local/share/claude-code`, "force xdg", `0acda47`) as an old local
  install; restored with `git checkout`. It also set `~/.claude.json`
  `installMethod` from `global` to `native` (backup:
  `~/trash/merge-011/claude.json.before-native-install`).
  `~/.local/share/pnpm/claude` (2.1.316, the running sessions') untouched.

## Open Questions

## Final report
