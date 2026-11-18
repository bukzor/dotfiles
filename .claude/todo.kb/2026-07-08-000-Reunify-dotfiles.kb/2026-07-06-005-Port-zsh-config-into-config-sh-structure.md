---
managed-by: Skill(llm-subtask)
status: done
---

# Port zsh config into config-sh structure

**Priority:** Medium (user opted in: "Yes, wire it")
**Complexity:** Medium
**Branch:** author on svelte-crostini (live `~`, testable), mirror to main
**Context:** main's .zshrc (170 lines, most-evolved), .zsh_completion/ (10 completers),
.zkbd/, docs/annoyances/zsh; 2017 origin readable via `git show origin/zsh-support:.zshrc`

## Problem Statement

svelte-crostini has no zsh support (only a cargo line in .zshenv). main holds a mature
zsh setup wired to the old .sh_* family. Port it onto the unified ~/.config/sh
structure (todo 000) instead of resurrecting .sh_rc.

## Implementation Steps

- [x] unit tests first: `zsh-startup_check.sh` (run-once, native zsh -i/-lc,
      not the harness's `zsh --emulate sh` cell). Caught two real bugs before
      they'd have shipped: zkbd's wizard needs a real tty (stalls ~10s then
      breaks keybindings without one -- gated on `tty -s`); direnv.sh's zsh
      precmd_functions guard errored when the array was never declared.
- [x] prerequisite: todo 000 structure landed on svelte
- [x] new ~/.config/sh/zshrc.d/ (sibling of bashrc.d): 010-options, 020-history,
      030-zkbd (tty-gated), 040-keybindings (every zkbd-derived binding
      guarded via a bindkey_zkbd helper), 050-completion
- [x] .zshrc: interactive guard → functions.d → env.d → zshrc.d → rc.d
- [x] .zshenv: functions.sh + env.d (keep cargo line)
- [x] delete .zsh_profile (zsh never reads that filename; it was a debug artifact)
- [x] verify rc.d/ files are zsh-clean: direnv.sh got a zsh branch (native
      precmd_functions), bash branch untouched byte-for-byte
- [x] port cross-shell PS1 from main's .sh_rc into rc.d -- **scope widened by
      user decision**: replaces bashrc.d/prompt.sh entirely (both shells share
      it now), rather than leaving bash's prompt untouched. Asked explicitly
      since this conflicted with this file's own "bash unchanged" criterion
      below; user chose the shared prompt.
- [x] bring over .zsh_completion/ and .zkbd/ from main (they're main-only paths —
      marked KEEP in todo 003)
- [x] smoke test: `zsh -i` on this machine, both hermetically and live
- [x] mirror all of it to main; retire main's .sh_env/.sh_rc/.sh_advanced_rc/
      .sh_plugins.d -- **`.sh_lib` kept, not retired**: `bin/gcpenv` (byte-
      identical on both branches already) independently sources
      `.sh_lib/minimal.sh`. Deleting it would have broken a real, currently-
      working tool on main (it's already broken on svelte, which never had
      `.sh_lib` -- a pre-existing gap, unrelated to this task). Follow-up
      needed: fix gcpenv's dependency (port minimal.sh's tiny surface into
      functions.d, or rewrite gcpenv) before `.sh_lib` can retire too.

## Success Criteria

- [x] zsh interactive session: prompt, history, vi-mode, completions all work
- [x] bash behavior unchanged -- **superseded by user decision above**: bash's
      *prompt* now changes too (shares rc.d/prompt.sh with zsh); everything
      else (history, completion, keybindings, env) is unaffected, and the
      existing `.bashrc_test.sh`/`.profile_test.sh` suite stays green
- [x] zsh files byte-identical across branches -- verified via `diff -rq` on
      .zprofile/.zsh_completion/.zkbd before mirroring, and copying the
      authored content (.zshrc/.zshenv/zshrc.d/*/rc.d/*) identically to both

## Follow-up (new, found during this task)

- [ ] `bin/gcpenv` sources `$HOME/.sh_lib/minimal.sh`, which only exists on
      main. Already broken on svelte (pre-existing, unrelated to this task).
      Port `minimal.sh`'s `has`/`show`/`minimal_init` into `.config/sh/
      functions.d/` (or decide gcpenv doesn't need them) so `.sh_lib` can
      finally retire on main too.

## Notes

docs/annoyances/zsh lists known paper cuts (tmux TERM, cursor highlight, shared
history too eager) — check whether the port resolves or reproduces them.

**precmd/chpwd mechanism, found 2026-07-09 doing ../2026-07-06-000:**
svelte's `.config/sh/bashrc.d/050-precmd-functions.sh` is a bespoke 6-line
`PROMPT_COMMAND` shim with its own `prompt_commands` array name (precmd
only). main's `.sh_advanced_rc`/`.sh_lib` instead vendors
`rcaloras/bash-preexec` (`precmd_functions`/`preexec_functions` via a
DEBUG trap) plus a `bash-chpwd.sh` adding `chpwd_functions` — zsh has all
three natively, by those exact names. Worth adopting main's naming (at
minimum) so rc.d content can register hooks the same way under both
shells; direnv.sh's `PROMPT_COMMAND`-splicing hook is the concrete thing
in rc.d that would need converting to `precmd_functions+=(...)` either way.
