---
managed-by: Skill(llm-subtask)
status: active
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
- [ ] claude config: .claude/CLAUDE.md, .claude/settings.json,
      .claude/commands/curl.md, .claude/.gitignore
    - [ ] authored / [ ] svelte / [ ] main
- [ ] git config: .gitconfig, .gitignore, .config/git/ignore, .config/.gitignore,
      repo/.gitignore, bin/.gitignore, .vim/.gitignore
    - [ ] authored / [ ] svelte / [ ] main
- [ ] vim: .vim/lazy-lock.json, .vim/lua/bukzor/{lsp,plugins,tree-sitter,which-key}.lua,
      .vim/pack/invented-here/start/diffmode/plugin/diffmode.vim
    - [ ] authored / [ ] svelte / [ ] main
- [ ] terminal: .tmux.conf
    - [ ] authored / [ ] svelte / [ ] main
- [ ] bin: bin/brew-desc, bin/colortest17x17, bin/osc52
    - [ ] authored / [ ] svelte / [ ] main
- [ ] misc: .config/gcloud/.gitignore etc. — anything escalated from 002

## Success Criteria

- [ ] `git diff main svelte-crostini` shows only paths owned by other groups (or nothing)

## Notes

- `.bashrc`/`.profile` are OWNED BY todo 000 — do not touch here.
- macOS-vs-crostini differences resolve via OSTYPE guards (pattern in main's .sh_env),
  not by picking a side.
- vim lazy-lock.json: prefer svelte's (currently exercised plugin set); reconcile
  plugins.lua first, then regenerate lock on this machine rather than hand-merging.
