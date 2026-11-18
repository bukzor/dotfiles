---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-18-000-switch-buck-win10-home-to-main.md  # Final report and Open Questions: the state you start from
---

# Main's live config calls files main doesn't have

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (fallout
from buck-win10's switch to main)

## Problem Statement

The user reports that every Claude Code session on buck-win10 now errors on
`/home/bukzor/.claude/hooks/session-rename.py`.

Cause: main took svelte-crostini's `.claude/settings.json` (unit 004/002).
Its `UserPromptSubmit` hook calls `.claude/hooks/session-rename.py`
(svelte `edc7ee2`), which exists only on svelte. Since 2026-11-18, `~`
runs main.

Fix that first, then sweep for the rest of this class. Main carries
svelte's copy of many config files, but 838 svelte-only paths never came
along (list: `~/trash/svelte-only.paths`). Find every reference from main's
live config to a path that is missing on this host. Check at least these:
- hooks and other paths in `settings.json`;
- `.tmux.conf` (unit 004/000 named `bin/cron-status` and
  `bin/tmux-rename-window`);
- shell startup;
- `.vimrc.d`;
- whatever the scripts you port call in turn.

Then fix each one:

- **Svelte has the file:** add svelte's file to main unchanged, same mode,
  one commit naming svelte-crostini as counterpart. A path only one side
  has merges cleanly in 006, so this decides nothing new.
- **Neither branch tracks it.** For example, the `SessionStart` hook
  `~/claude/mitmproxy/lib/claude_mitmproxy/binpatch.py` belongs to a
  checkout that exists on penguin and not here. Land nothing. Record it
  under Open Questions with your recommendation: a guard in the shared
  config, a host-local install, or something else.

After pushing main, run `git -C ~ pull --ff-only` (the one allowed action
in `~`). Then prove each fix live, for example by piping a sample hook
payload into the hook and getting exit 0.

GitHub over ssh fails on this host: main's `.ssh/config.d/github.sshconfig`
pins a key that is missing here. For your git commands, use
`GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa -o IdentitiesOnly=yes'`. Don't edit
ssh config; that is the user's call.

**Scope (only these):** the svelte-only paths you port, added on main in
`dotfiles--main`; `git pull` in `~`; this handoff file.

## Steps

- [x] port `.claude/hooks/session-rename.py`; push; pull `~`; prove live
- [x] sweep: settings.json, `.tmux.conf`, shell startup, `.vimrc.d`,
  `.gitconfig`, `.ssh/config.d`, `.claude/{CLAUDE.md,must-read.kb}` triggers
- [x] port the rest: `bin/{cron-status,tmux-rename-window,prettier-markdown}`,
  `.claude/design-rules.kb/double-dash-not-emdash.md`,
  `.claude/must-read.kb/before/{git/staging-part-of-a-file--git-add-p,asserting-or-conceding-a-claim-of-judgment}.md`
- [x] push; pull `~`; prove each live

## Decisions

- Ported only paths that something *calls* or tells an agent to read.
  Left these svelte-only paths alone: nothing fails without them.
  - `bin/shim/`: a `PATH` entry in `env.d/900-path.sh`; `path prepend`
    tolerates absent dirs, and the shims would change what `pip` does here.
  - `.config/sh/rc.d/{cron-status,pane-title}.sh`, and
    `docs/dev/adr/2026-09-10-001-...`: named only in `.tmux.conf` comments.
- The `.claude/` files count as live config: `.claude/CLAUDE.md`'s `Jr?`
  and two `must-read.kb` triggers sent every agent to files that did not exist.

## Open Questions

1. **`SessionStart` → `~/claude/mitmproxy/.../binpatch.py`** (neither branch
   tracks it; exits 127 here). Recommend a guard in the shared
   `settings.json`: `f="$HOME"/claude/...binpatch.py; [ ! -e "$f" ] || exec "$f"`.
   The patcher is optional per host, so a guard fits better than a
   host-local install.
2. **`prettier` is not installed**, so `:ClaudeQuote` (via
   `bin/prettier-markdown`) exits 127. Recommend a host-local install
   (`pnpm add -g prettier`).
3. **`.gitconfig` `init.templateDir`** →
   `~/.local/share/git-localhost-store/template-repo`, which neither branch
   tracks. Every `git init` warns `templates not found`. Recommend
   installing git-localhost-store on this host. Or, if it is penguin-only,
   move the setting into `private-dotfiles/.gitconfig`.
4. Minor, not acted on: `~/.venv` (nvim's python3 host; moot without nvim);
   `filter.lfs.required` without `git-lfs`; main's dangling `bin/{bash,git}`
   and `.claude/skill-categories/*`. Nix (000's OQ2): svelte's `env.d/400-nix.sh`.

## Final report

- main `9802e13`: `.claude/hooks/session-rename.py` (svelte `edc7ee2`'s blob, 755).
- main `01792dd`: `bin/{cron-status,tmux-rename-window,prettier-markdown}`
  (755), and three `.claude/` md files (644). All byte-identical:
  `git diff origin/main origin/svelte-crostini -- <7 paths>` is empty.
- `~` pulled to `01792dd`, fast-forward only.
- Live proofs:
  - `session-rename.py` exits 0 on a payload with no request queued. With
    a queued request it emits `sessionTitle` and removes the request.
  - `cron-status` exits 0 and prints nothing when clean. Under a fake
    `HOME` with a failed job it prints the job, in both modes.
  - On a scratch tmux server (`-L`, live `.tmux.conf`):
    `tmux-rename-window` sets a name, and an empty name restores
    `automatic-rename=1`. `#(~/bin/cron-status --tmux)` renders.
  - The three `.claude/` refs now resolve.
  - `prettier-markdown` resolves on the login `PATH` but fails at
    `prettier` (OQ2).
- Everything else the sweep checked resolves, or is guarded
  (`trysource`, `filereadable`, `[ -e ]`) or a `PATH` entry.
