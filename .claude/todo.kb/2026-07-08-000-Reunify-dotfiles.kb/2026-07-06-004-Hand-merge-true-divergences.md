---
managed-by: Skill(llm-subtask)
status: open
---

# Hand-merge true divergences

**Priority:** Medium (the real merge work; after 000/001/002 shrink the surface)
**Complexity:** High
**Branch:** both — author merged content once, apply+commit identically to each branch
**Context:** classifier "diverged" verdicts minus stale-seed (002) minus shell trio (000)

## Problem Statement

~21 files where both branches genuinely evolved. Each needs a human-judgment merge;
the result must land byte-identical on both branches (the pre-merge ideal).

## Implementation Steps

Author merged content per theme; per theme: `- [ ] merged content authored`,
`- [ ] applied+committed on svelte (~)`, `- [ ] applied+committed on main (clone)`.

- [ ] unit tests first, where appropriate (vague reminder): the merged bin/ scripts
      are the testable surface (brew-desc, colortest17x17, osc52) — a smoke
      invocation each; for configs, a parse/load check (git config -l, vim headless
      startup, tmux -f … validity) beats nothing
      (shape: run-once `X_check.sh`, skip-if-absent — see ../2026-07-07-000)
- [ ] claude config: .claude/CLAUDE.md, .claude/settings.json,
      .claude/commands/curl.md, .claude/.gitignore
    - [ ] authored / [ ] svelte / [ ] main
- [x] git config: .gitconfig, .gitignore, .config/git/ignore, .config/.gitignore,
      repo/.gitignore, bin/.gitignore, .vim/.gitignore — done 2026-07-13.
      Resolved the ignore-scheme question flagged as deferred in 000/CI-
      foundations: **user decision — keep svelte's allow-by-default scheme**
      over main's deny-by-default + opt-in scheme (rationale: allow-first
      surfaces anomalies as untracked-in-status; deny-first would silently
      swallow them). main's whole deny-first apparatus (root `*`/`**/*`,
      `!**/`, `!**/.gitignore`, and the narrow opt-in exceptions it required)
      dropped as now-unnecessary. `.gitconfig`: union of settings/aliases;
      kept svelte's `l`/`xl` (this project's own git-conventions depend on
      them) over main's same-named-but-different upstream-diffing versions;
      dropped main's inline `feature` alias (was shadowing a more capable
      same-named `bin/git-feature` script); dropped `core.excludesfile` in
      favor of the XDG default, matching svelte. `.gitconfig.d/vimdiff.conf`
      (svelte-only file): kept as sole source — fixes two real bugs main's
      inline difftool block had (bad $MERGED path on renames,
      GIT_EXTERNAL_DIFF not unset). `.config/git/ignore`: was a dead
      symlink to `.hgignore_global` on main (shadowed by the excludesfile
      setting just dropped) — now a plain file on both, content unioned
      with main's actually-active `.gitignore_global` (retired, absorbed
      here). Validated: `git config --list` + alias resolution on both;
      confirmed `repo/mine/`'s tracked content and `.zkbd/`'s tracked
      content are unaffected by the scheme switch.
    - [x] authored / [x] svelte (`9cb75f1`) / [x] main (`59082f3`)
- [ ] vim: .vim/lazy-lock.json, .vim/lua/bukzor/{lsp,plugins,tree-sitter,which-key}.lua,
      .vim/pack/invented-here/start/diffmode/plugin/diffmode.vim
    - [ ] authored / [ ] svelte / [ ] main
- [x] terminal: .tmux.conf — done 2026-07-13, union of real functionality
      (main's display-time/base-index/ctrl-hold binding layer,
      svelte's mouse-wheel scroll speed, pane-nav union), dead
      commented-out experiments dropped, default-terminal kept at
      svelte's xterm-256color pending the terminfo todo (main's
      xterm-kitty intent recorded as a comment). User decision: keep
      main's `base-index 5`. Validated via `tmux -f .tmux.conf
      new-session`.
    - [x] authored / [x] svelte (`8c98844`) / [x] main (`159393f`)
- [x] bin: bin/brew-desc, bin/colortest17x17, bin/osc52 — done 2026-07-13:
      brew-desc adopts main's simpler `brew desc --eval-all --search`;
      colortest17x17 adopts svelte's python3 rewrite wholesale (main's bash
      version was the older precursor); osc52 combines main's strict-mode
      conventions with svelte's `tr -d '\n'` fix for a real bug in main's
      version (base64's default 76-col line-wrap breaks the OSC-52 escape
      for any payload longer than a couple dozen bytes) — smoke-tested.
    - [x] authored / [x] svelte (`dce294f`) / [x] main (`1579524`)
- [ ] escalated from 002 (stale-seed adjudication turned out mostly *not*
      stale-seed — see that task file's per-item notes for full findings):
    - [ ] .config/kitty/kitty.conf + .gitmodules (linked: main's kitty.conf
          `include`s a theme from main-only submodule `kitty-gruvbox-theme`) —
          union: main's font/theme/ligature/scrollback/keybind customization +
          svelte's `linux_display_server x11` (crostini-specific, don't drop) +
          a merged submodule set (svelte's session.kb/vim-plugin submodules +
          main's theme/scratch/gcloud-data submodules, checking `scratch`'s two
          different remotes for which is current)
        - [ ] authored / [ ] svelte / [ ] main
    - [ ] .vimrc — diff main's 526-line monolithic file against svelte's 19
          `.vimrc.d/*.vim` files (actively maintained, most recent edit
          2026-05-12); port anything main has that svelte's modular set lacks,
          discard the rest. Do not just take main's file — it would silently
          disable all 19 modular files by replacing the loader.
        - [ ] authored / [ ] svelte / [ ] main
    - [x] .vim/init.lua (symlink) + its target: svelte's `init-nvim.lua`
          (rewritten 2026-05-05, "nvim 0.11 modernization") already beats main's
          stale `nvim-init.lua` (2023-05-25) — no content merge needed, just
          decide the final filename (svelte's name, main's, or a third) and land
          svelte's content + symlink under it on both branches. Done
          2026-07-13: kept svelte's name (already the name `.vim/CLAUDE.md`
          documents); main's `nvim-init.lua` renamed+content-replaced to match.
        - [x] authored / [x] svelte (already correct, no new commit needed) / [x] main (`d5f4220`)
    - [x] .config/gh/config.yml — trivial union, no real judgment call: svelte's
          `markdown-preview: '!grip "$@"'` alias (matches active untracked
          `.grip/` in svelte's tree) + main's `"pr co": pr checkout` alias, both
          alongside the existing shared `co: pr checkout`. Done 2026-07-13.
        - [x] authored / [x] svelte (`003aae4`) / [x] main (`d994562`)
    - [x] .config/gcloud/.gitignore — union: main's improved secret/cache/config
          split (`configurations/`, `*_configs.db`, `cache/`, `logs/`,
          `application_default_credentials.json`, `*credential*`) + svelte's 5
          gcloud-transient patterns main dropped (`config_sentinel`, `gce`,
          `.last_opt_in_prompt.yaml`, `.last_survey_prompt.yaml`,
          `.metricsUUID`). Also `git rm --cached
          .config/gcloud/configurations/config_default` on svelte (currently
          tracked, contents are just `account = buck.evan@sentry.io` — not a
          secret, but shouldn't be tracked under the merged policy). Done
          2026-07-13; also untracked main's now-redundantly-ignored
          `config_sentinel`/`gce` (same rationale, not previously called out).
        - [x] authored / [x] svelte (`003aae4`) / [x] main (`d994562`)
    - [x] .ssh/.gitignore — union of svelte's `!*.pub` (needed — narrower than
          main's `!*.pub.*`, which wouldn't match svelte's plain-named keys) with
          main's `!authorized_keys`/`!.gitignore`/`!*.pub.*`/`!current`
          allowances. Coordinate with 003's `.ssh/` main-only-path audit
          (authorized_keys, config, config.d/, current/, 7× id_rsa.pub.* —
          content-checked 2026-07-11, all public keys/non-secret client config.
          main's `.ssh/config` hardcodes macOS paths like
          `/Users/buck/.config/colima/ssh_config` — verified 2026-07-12
          (empirical `ssh -F ... -G host` test + ssh_config(5)) that `Include`
          of a nonexistent glob/path is a silent noop, not an error, so this
          is safe to take verbatim, no OSTYPE guard needed). Done 2026-07-13;
          main's own main-only ssh paths untouched (003's job, already done —
          they'll fold in at 006's merge, no conflict since svelte lacks them).
        - [x] authored / [x] svelte (`003aae4`) / [x] main (`d994562`)

## Success Criteria

- [ ] `git diff main svelte-crostini` shows only paths owned by other groups (or nothing)

## Notes

- **Resolved narrowly, 2026-07-09** (was flagged as a blocking dependency
  when found doing ../2026-07-07-000): that task needed root-`.gitignore`
  opt-ins for six new harness files on main, and root `.gitignore` is this
  group's file to own. Rather than block CI-foundations on this group's
  turn in the execution order, added just the narrow `!` opt-ins needed
  (four root files; two new nested `.gitignore`s for `.github/` and
  `.local/share/redo/`, both `!*` matching the existing `lib/.gitignore`
  pattern) — see commit `b59d84f` in `dotfiles--main-reunify`. This is a
  strict subset of what this group's actual job is here: **the full
  ignore-scheme reconciliation is still open** — main's deny-first scheme
  vs. svelte's allowlist-of-ignores hasn't been decided, and everything
  else under `.gitignore`/`.config/.gitignore`/etc. in this theme is
  untouched. The lesson: task ownership in these files is a
  concurrent-edit heuristic, not a permission gate — a narrow, additive,
  non-preempting slice needed by an earlier task doesn't have to wait for
  a later one's turn.
- `.bashrc`/`.profile` are OWNED BY todo 000 — do not touch here.
- macOS-vs-crostini differences resolve via OSTYPE guards (pattern in main's .sh_env),
  not by picking a side.
- vim lazy-lock.json: prefer svelte's (currently exercised plugin set); reconcile
  plugins.lua first, then regenerate lock on this machine rather than hand-merging.
