---
managed-by: Skill(llm-subtask)
status: active
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

- [ ] A1 Vim/Neovim cleanup (part 2)
    - mods: `.vimrc.d/{copy-paste,default-mappings,finger-savers,linting,lsp,multiple-files}.vim`, `.config/nvim-dap-lua/init.lua`, `lvim/config`
    - deletions: `.vimrc.d/{basics,plugins}.vim`, `bin/vim`, `.config/.luarc.json`
    - new: `bin/{vim-lazy,nvim-lazy,nvim-dap-lua}`, `.config/nvim-lazy/`, `.config/{lvim,nvim-dap-lua}/.luarc.json`, `bin/alternatives/alternatives/vim/`
- [ ] A2 Terminal & git config
    - `.tmux.conf`, `.inputrc`, `.config/hterm/{README.md,custom-css-inline-text.css}`, `.config/zellij/config.kdl`
    - new: `.config/zellij/{config.tmux-ish.kdl,layouts/}`
    - `.gitconfig`, `.gitconfig.d/vimdiff.conf`, `.config/git/ignore`
- [ ] A3 bin maintenance
    - mods: `autoreconf brew-desc brew-handle-gnubin claude-workspace-merge CLAUDE.claude-workspace-merge.md colortest17x17 osc52 re-escape terminal tmux-cd tmux-pwd uncolor`
    - deletions: `bin/CLAUDE.md`, `bin/alternatives/ar`, `bin/toolchains/homebrew-clang-16/dropbox`
- [ ] A4 bin: new scripts
    - `claude-branch-extract claude-branch-list claude-open-tasks claude-plan claude-s claude-uncolor uncolor-jsonl git-submodule-add glyphs logrotate-cron regex-escape rustdoc-json sample systemd-user-enable`
- [ ] A5 .claude knowledge (April vintage)
    - mods: `design-rules.kb/rust.kb/*` (5), `commands/founder-coach.md`, `skills/CLAUDE.md`
    - new: `design-rules.kb/rust.kb/{expect-not-allow-for-lint-suppression,return-result-from-tests}.md`, skill symlinks `llm-discourse-graph`, `llm-vitals` (→ bukzor-agent-skills repo)
- [ ] A6 Toolchain misc
    - `Brewfile`, `pants.toml`, `lib/rustdoc-json/{CLAUDE.md,rustdoc_json_index.py,rustdoc_json_index_test.py}`
- [ ] A7 systemd user units (new): `.config/systemd/user/{default.target.wants/,homebrew.podman.service}`

### B. May singles

- [ ] B1 pnpm: `package.json`, `.config/pnpm/5/package.json`, `pnpm-lock.yaml` (05-08)
- [ ] B2 Python: `pyproject.toml`, `uv.lock`, `.python-version` (05-12)
- [ ] B3 Shell env: `.profile` (05-13) — review alongside untracked `.envrc`, `.zsh_profile` (ask)
- [x] B4 `.gitignore` — committed with D1 (`7b452ea`)

### C. Late-May .claude

- [ ] C1 mutation-testing: `skills/mutation-testing/SKILL.md` + root task file `CLAUDE.promote-mutation-testing-skill.task.md` (05-21)
- [ ] C2 default-context doc: `docs/default-context/tools.d/...investigate-non-substitutability...md` (05-22)
- [ ] C3 sessions.kb sweep (05-27): mods `CLAUDE.md`, `personal-attention-system.md`, `samsung-mom-phone-forensics-and-debloat.md`; deletion `document-managed-by-in-skill-md.md`; new `apply-migrations-kb-backlog.md`, `har-browse-rust-port-pre-port-infrastructure.md`, `reconcile-sessions-kb-schema-drift.md`, `review-global-claude-md-restructure.md`, `rust-port-kb-scope-refactor.md`
- [ ] C4 `bin/md-frontmatter-set` (05-27)
- [ ] C5 hook: `.claude/hooks/bash-preamble.py` (05-28)
- [ ] C6 `.claude/ideas.kb/`, `.claude/llm-hash.md`, `.claude/llm-vitals/` — review contents, likely commit
- [ ] C7 `trash/sessions-finish-skill-kb-refactor.md` mod — review; trash/ tracked?

### D. Untracked triage

- [x] D1 gitignore housekeeping — `7b452ea`: claude-code runtime → `.claude/.gitignore`; `.agents/`, `**/.claude/settings.local.json`, `.copilot/`, `.mitmproxy/`, chrome-for-testing, pulse, `node_modules/` → root; `bin/trash/` re-ignored (negation bug); `claude/.gitignore` (`*/`, mirrors `repo/`)
- [x] D1b settings.local.json delocalized → settings.json — `1f4e474`
- [x] D2 trashed → `trash/untracked-triage-2026-06-03/`: `claude-md.list skill-md.list date-Is.txt empty.bin empty.txt config.default.2.lua .claude/tools/`
- [ ] D3 root docs — commit after skim: `README.md`, `CLAUDE.stow.md`, `CLAUDE.rust-llvm-toolchain.md`, `CLAUDE.Task.retrofit-devlog-naming.md`, `.claude/CLAUDE.rename-must-read-d-to-must-read-kb.Task.md` (staleness check)
- [ ] D4 keys/identity: `.ssh/id_ed25519.pub` (pubkey, safe), `.config/mimeapps.list`, `.config/litellm/config.yaml`
- [ ] D5 commit `repo/anthropic-skills` gitlink — `.gitmodules` entry already committed (path `repo/anthropic-skills`)
- [ ] D6 USER REVIEW (held):
    - `claudesh` — wrapper pinning claude-code 2.0.1 with SSLKEYLOGFILE (mitmproxy-debugging relic; rec: trash)
    - `finder.sh` — one-off depth-glob `*fs*` search (rec: trash)
    - `scratch/python/`, `empty/` (read-only dir containing only `.git` — deliberate fixture?), `bin/colortest17x17.{new,new2,sh}` (review during A3)
    - `.envrc`, `.zsh_profile`, `profile.env` (review with B3)
    - `lib/pythonpath/{bukzor/claude/,pyrightconfig.json}`
    - `.claude/claude-alignment-2026-04-29.{jsonschema.yaml,kb/}` — commit or trash?
- [ ] D7 `claude/` holder follow-through (new task): promote active projects to their own repos/gitlinks symmetric to `repo/`; triage loose files (`standing-desk-research.md`, dir symlinks)

## Open Questions

- April-29 16:54 identical mtimes across ~50 files — single bulk event
  (restore/stow/alignment session?). Diffs may predate that date; review
  confirms grouping.
- `repo/scratch` submodule: dirty content only, or ref change to commit?

## Success Criteria

- [ ] `git status -s .` shows only intentionally-ignored or other-session files
- [ ] Each commit single-topic, message explains why
- [ ] No today-in-flight files swept into my commits

## Follow-on Cleanup (carried from prior doc)

- [ ] `.config/env/env.d/300-homebrew.sh` — duplicate HOMEBREW_* declarations; consolidate
