---
managed-by: Skill(llm-subtask)
status: active
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

- [ ] unit tests first: extend the todo-000 startup-invariant matrix with zsh
      columns (zsh -i, zsh -lc): clean startup (no error output), prompt set,
      completions initialized, env.d exports present; run per commit
      (shape: these need *native* zsh, not the harness's `zsh --emulate sh`
      matrix cell — run-once `X_check.sh` invoking zsh directly; -i needs
      the pty allowance — see ../2026-07-07-000)
- [ ] prerequisite: todo 000 structure landed on svelte
- [ ] new ~/.config/sh/zshrc.d/ (sibling of bashrc.d): setopts, history, vi-mode +
      bindkeys, zkbd handling, completion init (fpath includes .zsh_completion)
- [ ] .zshrc: interactive guard → functions.d → env.d → zshrc.d → rc.d
- [ ] .zshenv: functions.sh + env.d (keep cargo line)
- [ ] delete .zsh_profile (zsh never reads that filename; it was a debug artifact)
- [ ] verify rc.d/ files are zsh-clean (direnv.sh uses PROMPT_COMMAND — needs a
      zsh equivalent: precmd hook or `eval "$(direnv hook zsh)"` in zshrc.d)
- [ ] port cross-shell PS1 from main's .sh_rc into rc.d (it already speaks zsh)
- [ ] bring over .zsh_completion/ and .zkbd/ from main (they're main-only paths —
      mark KEEP in todo 003)
- [ ] smoke test: `zsh -i` on this machine (install zsh if absent)
- [ ] mirror all of it to main; then retire main's .sh_env/.sh_rc/.sh_advanced_rc/
      .sh_lib/.sh_plugins.d (with todo 000)

## Success Criteria

- [ ] zsh interactive session: prompt, history, vi-mode, completions all work
- [ ] bash behavior unchanged
- [ ] zsh files byte-identical across branches

## Notes

docs/annoyances/zsh lists known paper cuts (tmux TERM, cursor highlight, shared
history too eager) — check whether the port resolves or reproduces them.
