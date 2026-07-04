---
managed-by: Skill(llm-subtask)
cost-benefit-sweh:
  timebox:
    '@value': 3
    rationale: remaining clusters after A1–A3 landed; triage is the work, each commit mechanical
    confidence: unsure
  benefit-2w:
    '@value': 0.5
    rationale: clean git status restores signal; until then every session skims past the noise
    confidence: unsure
  cost-of-delay-2w:
    '@value': 0.5
    rationale: uncommitted work is at-risk, and this is the exact silently-stale pattern that has bitten before
    confidence: tentative
---

# Commit accumulated dotfiles changes

**Priority:** Medium
**Complexity:** Medium — many small commits, each mechanical; triage is the work
**Context:** Supersedes `~/CLAUDE.commit.todo.md` (migrated 2026-06-03, original in `trash/`)

## Problem Statement

`svelte-crostini` has ~70 modified/deleted tracked files and ~100 untracked
paths spanning 2026-04-29 → today. Commit in reviewable single-topic units;
triage untracked into commit/gitignore/trash.

## Ground Rules

- `git commit-files <paths> -- -m "..."` per group; review full diff first
- Oldest-first; mtime clusters: bulk 04-29T16:54 event, then May singles, then late-May `.claude/`
- **Do not touch today's in-flight files** — another session is actively
  committing must-read/reference work (HEAD was seconds old at planning time):
  `.claude/settings.json`, `.claude/reference.kb/bash-conventions.md`,
  `.claude/system-prompt-patches.d/strip-git-status/` (match.md → match.d/ rename),
  `.claude/todo.kb/CLAUDE.md`, `profile.env`
- Policy: note issues found during diff review under Follow-on; don't fix inline

## Completed (prior sessions)

- ~~Shell config~~ — `0e511ad`
- ~~.gitignore updates~~ — `8eac748`
- ~~.claude/ reference rename~~ — `42fe109`
- ~~Vim / Neovim overhaul (part 1)~~ — `49d45db`

## Implementation Steps

### A. April-29 cluster (single mtime event, split topically)

- [x] A1 Vim/Neovim cleanup (part 2) — `9d951e3`; nvim-lazy inner `.git`
      (upstream LazyVim/starter clone, no local commits) → `trash/untracked-triage-2026-06-03/nvim-lazy.git`;
      `lazy-lock.json` stays untracked per `.config/.gitignore:20`
    - mods: `.vimrc.d/{copy-paste,default-mappings,finger-savers,linting,lsp,multiple-files}.vim`, `.config/nvim-dap-lua/init.lua`, `lvim/config`
    - deletions: `.vimrc.d/{basics,plugins}.vim`, `bin/vim`, `.config/.luarc.json`
    - new: `bin/{vim-lazy,nvim-lazy,nvim-dap-lua}`, `.config/nvim-lazy/`, `.config/{lvim,nvim-dap-lua}/.luarc.json`, `bin/alternatives/alternatives/vim/`
- [x] A2 Terminal & git config — `79ed8fb`; stray `layouts/vim.log` → trash
    - `.tmux.conf`, `.inputrc`, `.config/hterm/{README.md,custom-css-inline-text.css}`, `.config/zellij/config.kdl`
    - new: `.config/zellij/{config.tmux-ish.kdl,layouts/}`
    - `.gitconfig`, `.gitconfig.d/vimdiff.conf`, `.config/git/ignore`
- [x] A3 bin maintenance — `2f4e887`; colortest drafts `.new/.new2/.sh` → trash;
      **`bin/CLAUDE.md` deletion HELD** → moved to D6: doc was created 05-21 with the
      md-frontmatter tools (98a7945, not April vintage); tools+tests all tracked and
      alive; no relocated copy found — deletion looks accidental or an unfinished
      rename to `CLAUDE.md-frontmatter.md`
- [x] A4 bin: new scripts — `c8350a1`; pulled `lib/pythonpath/bukzor/claude/` +
      `pyrightconfig.json` out of D6 into this commit (launchers exec those modules;
      skimmed clean, no secrets)
- [x] A5 .claude knowledge (April vintage) — `edf8512`
    - mods: `design-rules.kb/rust.kb/*` (5), `commands/founder-coach.md`, `skills/CLAUDE.md`
    - new: `design-rules.kb/rust.kb/{expect-not-allow-for-lint-suppression,return-result-from-tests}.md`, skill symlinks `llm-discourse-graph`, `llm-vitals` (→ bukzor-agent-skills repo)
- [x] A6 Toolchain misc — `3c6af89`; rustdoc-json tests verified (33 pass)
- [x] A7 systemd user units — `3c0835f`

### B. May singles

- [x] B1 pnpm — `15e1ea2`
- [x] B2 Python — `6a55101`
- [x] B3 Shell env: `.profile` — `c475f7c`; `.envrc`/`.zsh_profile`/`profile.env` stay held in D6
      (findings: `profile.env` is login-regenerated output → rec gitignore; `.zsh_profile` is
      1-line `env > ~/zsh_profile.env` instrumentation; `.envrc` looks legit, litellm+path config)
- [x] B4 `.gitignore` — committed with D1 (`7b452ea`)

### C. Late-May .claude

- [x] C1 mutation-testing: SKILL.md — `40cac64`; the root task file
      `CLAUDE.promote-mutation-testing-skill.task.md` no longer exists (resolved since planning)
- [x] C2 default-context doc — `02681f2`
- [x] C3 sessions.kb sweep — `024fd03`
- [x] C4 `bin/md-frontmatter-set` — `cd0cf24`
- [x] C5 hook: `.claude/hooks/bash-preamble.py` — `278a320`
- [x] C6 ideas.kb, llm-hash.md, llm-vitals — `ca3bfa6`
- [x] C7 — `8c77f65`: file was accidentally tracked (swept into 98a7945); untracked via
      `git rm --cached`, stays on disk; trash/ confirmed otherwise ignored

### D. Untracked triage

- [x] D1 gitignore housekeeping — `7b452ea`: claude-code runtime → `.claude/.gitignore`; `.agents/`, `**/.claude/settings.local.json`, `.copilot/`, `.mitmproxy/`, chrome-for-testing, pulse, `node_modules/` → root; `bin/trash/` re-ignored (negation bug); `claude/.gitignore` (`*/`, mirrors `repo/`)
- [x] D1b settings.local.json delocalized → settings.json — `1f4e474`
- [x] D2 trashed → `trash/untracked-triage-2026-06-03/`: `claude-md.list skill-md.list date-Is.txt empty.bin empty.txt config.default.2.lua .claude/tools/`
- [x] D3 root docs — `b4089f5` (stow + rust-llvm design docs); trashed: empty `README.md`,
      `CLAUDE.Task.retrofit-devlog-naming.md` (verified done: no old-pattern devlogs remain),
      `.claude/CLAUDE.rename-must-read-d-to-must-read-kb.Task.md` (status: done, must-read.d gone)
- [x] D4 keys/identity — `81f5e75`; litellm config verified secret-free (env-refs only)
- [x] D5 — already done: gitlink committed at `c74d647` (= inner HEAD), `.gitmodules` entry
      present (submodule name `.claude/skills/anthropic-skills`); status `?` is just inner
      untracked `__pycache__`
- [ ] D6 USER REVIEW (held):
    - `bin/CLAUDE.md` deletion (see A3 note) — restore, or finish rename per
      `CLAUDE.<tool>.md` convention?
    - `claudesh` — wrapper pinning claude-code 2.0.1 with SSLKEYLOGFILE (mitmproxy-debugging relic; rec: trash)
    - `finder.sh` — one-off depth-glob `*fs*` search (rec: trash)
    - `scratch/python/`, `empty/` (read-only dir containing only `.git` — deliberate fixture?), `bin/colortest17x17.{new,new2,sh}` (review during A3)
    - `.envrc`, `.zsh_profile`, `profile.env` (review with B3)
    - ~~`lib/pythonpath/{bukzor/claude/,pyrightconfig.json}`~~ — committed with A4 (`c8350a1`)
    - `.claude/claude-alignment-2026-04-29.{jsonschema.yaml,kb/}` — commit or trash?
- [ ] D7 `claude/` holder follow-through (new task): promote active projects to their own repos/gitlinks symmetric to `repo/`; triage loose files (`standing-desk-research.md`, dir symlinks)

## Open Questions

- ~~April-29 16:54 identical mtimes~~ — groupings confirmed by diff review; all committed
- ~~`repo/scratch`~~ — same ref (`b45a792`), `-dirty` content only; nothing to commit here

## Strays found after planning (2026-06-03 session)

- [x] `.claude/commands/session-end.md` loose-end-sweep procedure — `71ecdb9`
- [x] dead files: empty `env.sh`, defunct `git/.gitignore`, 2023 RSA pubkey — `cee35cd`
- [x] `.claude/CLAUDE.promote-mutation-testing-skill.task.md` — status: done, verified
  (mutation-testing lists as skill); → trash (C1's "root task file", found at `.claude/`)

## Success Criteria

- [ ] `git status -s .` shows only intentionally-ignored or other-session files
- [ ] Each commit single-topic, message explains why
- [ ] No today-in-flight files swept into my commits

## Follow-on Cleanup (carried from prior doc)

- [ ] `.config/env/env.d/300-homebrew.sh` — duplicate HOMEBREW_* declarations; consolidate
- [ ] `.config/git/ignore:1` — stale broken pattern `**/.claude\settings.local.json` (backslash typo); delete, superseded by corrected line
- [ ] `.config/zellij/config.kdl` — `bind "4" { GoToTab 5; }` typo (should be `GoToTab 4`)
- [ ] `bin/claude-plan` — no shebang, not executable; inert as a PATH command (add `#!/bin/sh` + `chmod +x`, with `"$@"` passthrough)
- [ ] `pants.toml` — pythonpath references `lib/pants-plugins`, which doesn't exist; create or drop
