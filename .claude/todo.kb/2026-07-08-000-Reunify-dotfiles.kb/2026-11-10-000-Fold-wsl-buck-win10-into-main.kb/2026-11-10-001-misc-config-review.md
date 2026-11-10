---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-11-10-000-Fold-wsl-buck-win10-into-main.md  # "commit or park", "review the rest"
---

# Misc config in `~`: review, commit on wsl-buck-win10, carry real intent to svelte

**Parent:** <../2026-11-10-000-Fold-wsl-buck-win10-into-main.md> (wave 1, "commit or park")

## Problem Statement

`~` holds uncommitted edits to general config files and two dirty
submodules. For each: read the diff, commit it on `wsl-buck-win10` (one
commit per coherent change, so the merge into main carries it), and decide
whether it is host-local (stop there) or cross-host intent that svelte lacks
(author it once on `svelte-crostini` too). Check svelte's current version
first; much of `~` lags svelte, and a lagging hunk is not intent.

Dirty submodules (`.config/kitty/kitty-gruvbox-theme` is bumped *and* dirty,
`.themes/gruvbox-dark-gtk` is dirty): report what the inner changes are.
Commit the kitty pointer bump if the target commit is pushed upstream; don't
commit inside a submodule.

Untracked: `.zkbd/xterm-256color-*` (zsh key maps per terminal; check how
svelte's `.config/sh/zshrc.d/030-zkbd.sh` and `.gitignore` treat `.zkbd/`),
`.config/fish/conf.d/`.

Settle and report: the svelte commit ids; anything you judge stale and
did not commit (Open Questions, with a recommendation).

**Scope (only these files):**
- in `~`: `.gitconfig`, `.gitignore_global`, `.hgignore_global`, `bin/brew`,
  `bin/yesno`, `setup/alpine/homebrew.sh`, `TODO.md`, `.config/gh/config.yml`,
  `.config/kitty/kitty-gruvbox-theme`, `.themes/gruvbox-dark-gtk`,
  `.zkbd/xterm-256color-*`, `.config/fish/conf.d/`
- in the svelte workspace: the same paths
- this handoff file

(Root `.gitignore` belongs to unit 002.)

## Steps

- [x] read diffs in `~`; compare each path against svelte's current version
- [x] wsl commits, oldest first: alpine homebrew via ruby26; `.gitconfig`
      delta; `TODO.md`; ignore `settings.local.json`; `gh` config;
      `bin/brew` exit fix; `bin/yesno` stderr; kitty bump; zkbd map; fish nix hook
- [x] svelte commits: `bin/brew` exit fix, `bin/yesno` stderr
- [x] Final report, `status: done`, commit this file

## Decisions

- Svelte's `bin/brew`, `bin/yesno` equal wsl's base, so their live edits
  are new intent, not lag. Cross-host: `brew` `return 1`→`exit 1`;
  `yesno` `exec >&2`. Host-local: `brew`'s ruby26 `PATH` (with
  `setup/alpine/homebrew.sh`, one commit), delta, `gh` ssh/wslbrowse,
  `TODO.md`, fish hook, zkbd map.
- `yesno`: dropped the live `tty -s` guard before committing; it duplicated
  the loop's `[ -t 0 ]` branch (tested: `</dev/null` → stderr
  `Proceed? [y/n]: no`, rc 1, stdout empty).
- `.hgignore_global`: live file had the `settings.local.json` entry appended
  36× (2025-09-13); committed it once (live file rewritten to match; hg is
  not installed). Svelte already has the entry in `.config/git/ignore`.
- Kitty bump committed: `b60d532` is upstream `master` (`ls-remote`).

## Open Questions

- `.zkbd/xterm-256color-alpine-linux-musl` (untracked, 19 bytes): an aborted
  zkbd run, header only. It is the file this host's zsh reads
  (`$VENDOR-$OSTYPE` is now `alpine-linux-musl`), so its 0 keys fail the
  24-key check. Recommend replacing it with a relative symlink to
  `xterm-256color-alpine-linux` (as `ubuntu`→`debian`) and committing.
- `.zkbd/xterm-256color-:0` (untracked): absolute symlink zkbd's final `mv`
  left behind, because zkbd names its output `$TERM-${DISPLAY:t}` and
  `~/.zshrc` pre-links `$TERM.tmp` to the real map. Nothing reads it.
  Recommend `mv` to `~/trash/`.
- Both submodule checkouts are empty: only `.git`, every file staged as
  deleted in the inner index (HEAD = recorded commit; `.git` files dated
  2025-08-10, so likely an interrupted init). `~/.config/kitty/kitty.conf`
  includes a theme file that is therefore missing (kitty is not installed
  here). Recommend `git -C <sub> reset --hard` in each, a user act.
- `.themes`: svelte replaced `gruvbox-dark-gtk` (jmattheis) with
  `Gruvbox-GTK` (Fausto-Korpsvart) on 2025-10-22; the main↔svelte merge
  needs to pick one. Recommend svelte's.
- `gh` `browser: wslbrowse` breaks off WSL once main is shared. Unit 000
  sets `BROWSER` WSL-guarded, which gh honors; recommend blanking `browser:`.
  `git_protocol: ssh` vs svelte's https: user preference.
- delta config and `TODO.md` items: carry to svelte? Recommend delta only if
  penguin has delta; the TODO items are this host's symptoms, leave them.

## Final report

All scoped paths in `~` committed and pushed except the two untracked zkbd
paths and the inner submodule state (Open Questions).

`wsl-buck-win10`: `4250cc6` alpine ruby26 homebrew, `a60d2a6` delta,
`cc6c022` TODO.md, `fe9ec9b` global ignores, `d23c0d4` gh, `4fdfe43` brew
exit, `6cd5be6` yesno, `720e6ed` kitty bump, `99877e8` zkbd map,
`898e58e` fish nix hook.

`svelte-crostini`: `b37db34` brew exit, `2b532c1` yesno (counterparts of
`4fdfe43`, `6cd5be6`; files now identical across branches).

Deviation: `bin/yesno` and `.hgignore_global` were simplified in the live
tree before committing (Decisions). Pre-edit copies: `~/trash/misc-config-review/`.
