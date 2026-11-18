---
managed-by: Skill(llm-subtask)
status: planned
cost-benefit-sweh:
  timebox:
    "@value": 6
    rationale: |
      Five milestones; the loader is an hour, the keybind split is the
      long one (13 intents, zsh-only testing until the zsh return).
  benefit-2w:
    "@value": 1
    rationale: |
      Nothing breaks today. Pays at the zsh return, and every time a
      behavior is added or hunted for after that.
---

# Migrate ~/.config/sh to intent.d

**Priority:** after the design rulings (`docs/dev/design.kb/intent-d.kb/`: `PATH_OWNER`, `BREW_READ`, `TREE_NAME`)
**Complexity:** medium -- mechanical moves, but every leg must stay idempotent and every shell must still start clean
**Context:** design `~/docs/dev/design.kb/intent-d.md`; basis `~/docs/dev/sh-config-loading.claims.md`; session `~/.claude/sessions.kb/penguin.kb/migrate-config-sh-to-intent-d.md`

## Problem Statement

The design is ruled (or `+`, awaiting veto); nothing is built. Design
content stays in the ledger; this file is only the work.

## Implementation Steps

Milestones in order; each leaves every shell starting clean
(`bash -ic true`, `zsh -ic true`, `.profile_test.sh`).

- [ ] M1 loader -- `require` in `functions.d/` (LOADER), entry points set
      context lists and call it (ENTRY_POINTS); `intent.d/` exists with
      `edit-line-in-editor/{bashrc,zshrc}` moved in from `rc.d/` as the
      first intent; both trees load side by side
- [ ] M2 rc layer -- `rc.d`, `bashrc.d`, `zshrc.d` → intents
      (`prompt`, `history`, `completion`, `glob`, `precmd-hooks`,
      `pane-title`, `direnv`, `cron-status`, `colors`, ...); `010-options`
      split by intent; `bindkey -d/-v` and MENU_COMPLETE stay zsh-only
      legs of `vi-mode`
- [ ] M3 env layer -- `env.d` → intents; `060-basics` dissolved
      (`editor`, `colors`, `make`, `claude`, `volta`, `python`);
      `path/env.sh` single owner per PATH_OWNER ruling; `ostype` → function;
      `profile.d` deleted; `private-dotfiles` demoted (PRIVATE_OVERLAY);
      `.zshenv`'s `~/.cargo/env` line → `cargo/env.sh`
- [ ] M4 keybinds -- `terminal-keys/{inputrc,zshrc}` + child intents
      from `040-keybindings.sh` (TERMINAL_KEYS); `.inputrc` shrunk to
      settings + one `$include` (INPUTRC_RESIDUAL); `bindkey_zkbd` kept
      defined in `terminal-keys/zshrc`
- [ ] M5 close -- old `*.d` directories removed; `no-dead-paths_check.sh`
      passes; `intent.d/CLAUDE.md` written in mode/criteria/tools shape;
      `todo: true` dropped from the built claims in `design.kb/intent-d.kb/`

## Open Questions

Ruled in the design ledger, not here: `PATH_OWNER`, `BREW_READ`,
`TREE_NAME` (`grep -rlE '^standing: open' ~/docs/dev/design.kb/`).

## Success Criteria

- [ ] `ls ~/.config/sh/intent.d/` names every interactive behavior; no `*.d` sibling remains
- [ ] `ls intent.d/*/zshrc` vs `ls intent.d/*/bashrc` is the bash/zsh coverage diff
- [ ] every shell starts with no stderr; `bind -X`/`bindkey` show the same bindings as before
- [ ] `llm-claims-kb-graph ~/docs/dev/design.kb` shows no `todo: true` under components
