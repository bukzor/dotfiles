---
managed-by: Skill(llm-subtask)
status: done
---

# Main-only path triage

**Priority:** Medium (must precede final merge; independent of other groups)
**Complexity:** Medium (bulk decisions, low per-item effort)
**Branch:** main only (delete-commits in the clone: ~/repo/github.com/bukzor/dotfiles--main-reunify)
**Context:** 371 paths exist only on main; a no-base merge resurrects all of them as adds

## Problem Statement

Merging unrelated histories auto-adds every main-only path into the merged tree.
Obsolete work/macos material must be deleted on main *before* the merge so the
merged tree is born clean; wanted material stays and arrives for free.

## Current Situation

Main-only paths by top-level dir:
.claude/ 53, bin/ 48, docs/ 40, .config/ 35, lib/ 26, .weechat/ 17, .vim/ 17,
.sh_lib/ 17, .ssh/ 15, .zkbd/ 13, repo/ 11, .zsh_completion/ 10, .sh_plugins.d/ 7,
Library/ 6, .local/ 5, libexec/ 5, .jq/ 3, .bash_completion/ 3, .subversion/ 2,
setup/ 2 (+ a few singletons).

## Implementation Steps

- [x] ~~unit tests first (vague reminder): a dangling-reference sweep... shape:
      run-once `X_check.sh`~~ — **dropped 2026-07-12 (user decision).** Ad hoc
      dangling-ref greps were done before each actual deletion (all clean, see
      commit messages); a *permanent* regression script wasn't built. Not worth
      it: the main-only/svelte-only distinction this would guard is inherently
      temporary (gone once 006's final merge lands), and the main-reunify clone
      itself is a short-lived, single-purpose checkout — not worth standing up
      CI infrastructure for a comparison that's going away soon.
- [x] audit .ssh/ (15 files) first — already public on origin, but confirm nothing
      sensitive; document findings. Done 2026-07-11 (as a side effect of 002's
      `.ssh/.gitignore` investigation): `authorized_keys`, `config`, `config.d/`
      (colima.sshconfig, github.sshconfig), `current/` (a tree of pubkey
      symlinks), and 7× `id_rsa.pub.*`/`id_dsa.pub.*` — every content-checked
      file is a public key (`ssh-rsa`/`ssh-dss` prefix) or non-secret ssh-client
      config. No secrets found. `.ssh/config` hardcodes macOS paths
      (`/Users/buck/.config/colima/ssh_config`, `/Users/buck/.colima/ssh_config`)
      — originally flagged as needing an OSTYPE guard; **corrected 2026-07-12**
      (verified empirically + via ssh_config(5)) that `Include` of a nonexistent
      path is a silent noop, not an error — safe to keep verbatim, no guard
      needed (see Notes; also fixed in 004's task file).
- [x] KEEP (feeds other groups — do not delete): .zsh_completion/, .zkbd/,
      .sh_lib/, .sh_plugins.d/, docs/ (incl. docs/annoyances/zsh) — never a
      deletion candidate, just a guardrail note; nothing to execute
- [x] triage per directory — swept 2026-07-12 (full findings in Notes below);
      resolved to keep-by-default with four flagged exceptions:
    - [x] Library/ — keep, fully inert
    - [x] .weechat/ — keep, weechat not installed, inert
    - [x] work-era tooling in bin/ — keep 46, delete 2 (user decision
          2026-07-12): **`bin/claude`: delete** (breaks live `claude` CLI, see
          Notes); **`bin/vim`: delete** ("avoid/remove; merge svelte-crostini →
          main for that aspect" — svelte has no `bin/vim`, so deleting main's
          makes main match svelte exactly on this path). Committed+pushed
          `1b59dd1` (main-reunify clone).
    - [x] .config/ main-only subset — keep 34, delete 1 (user decision
          2026-07-12): **`.config/direnv/lib/stdlib.sh`: delete** (broken
          symlink, direnv actively hooked, see Notes); real sibling
          `.config/direnv/stdlib.sh` stays. Committed+pushed `1b59dd1`.
    - [x] lib/, libexec/, .local/ — keep 35, delete 1: **`.local/bin/claude`:
          delete** (paired with `bin/claude` above, user decision 2026-07-12).
          Committed+pushed `1b59dd1`. `bukzor.readline` (main-only
          `lib/python/bukzor/`, 23 files) — **keep-and-rename-into
          `lib/pythonpath/bukzor/`, decided 2026-07-12** ("I do want that in
          svelte, as an improvement"): ported to svelte, `PYTHONSTARTUP=
          ~/.pythonrc.py` set (previously unset, so `.pythonrc.py`'s
          `import bukzor.readline` never fired despite the file existing on
          both branches since task 001). First landed as a second PYTHONPATH
          entry (`lib/python` alongside `lib/pythonpath`) — user caught the
          redundancy (both dirs exist solely to be PYTHONPATH entries, same
          idea under two names) and asked which name should win. Folded into
          the established `lib/pythonpath/bukzor/` instead (zero filename
          overlap between the two `bukzor/` trees, confirmed clean merge);
          `lib/python` no longer exists on either branch. PYTHONPATH is back
          to a single entry. Verified at each step: merged-tree import works
          (`bukzor.readline` + svelte's existing `bukzor.claude.session`
          both importable from one `bukzor.__path__`), PYTHONSTARTUP fires in
          a real `python3 -i` session, full shell test harness green on both
          branches throughout. Committed+pushed: svelte `0682a9f` (initial
          port) + `732f73b` (fold into lib/pythonpath), main `c2b8389`
          (initial wiring) + `23cb2ea` (rename lib/python → lib/pythonpath).
    - [x] .jq/, .bash_completion/, .subversion/, setup/, repo/ — keep, all
          verified inert (see Notes for per-dir reasoning)
    - [x] .claude/ main-only subset (53 files, archived docs/old commands) —
          keep all; only root `CLAUDE.md` (separately tracked above) is a
          delete. **Correction:** `.claude/CLAUDE.md` (nested) is NOT
          main-only — same-path divergence, belongs to 004, not here.
    - [x] .vim/ main-only subset — keep all 17, no exceptions. **Correction
          2026-07-12:** the `pack/invented-here/start/{cursorline,diffmode,
          osc52}/` flag below was wrong — verified directly (`comm -23` +
          content diff) that these are NOT main-only; `cursorline.vim`/
          `osc52.vim` are byte-identical on both branches already (live on
          this system today), `diffmode.vim` has a trivial same-path
          divergence (svelte's version is slightly ahead — `<Cmd>call` vs.
          `:call`, a merged autocmd), bounced to 004 as a non-urgent item. The
          actual main-only 17: `autoload/bukzor/{mason,plug}.vim`,
          `autoload/plug.vim`, `data/{lazy,plugged}/.empty`, `ftplugin/rust.vim`,
          `lua/bukzor/nvim-init.lua`, `neoconf.json`, `neovim.yaml`,
          `pack/{lazy,plugged}/start` (empty-placeholder symlinks), `queries/`,
          `selene.toml`, `syntax/jq.vim`, three `treesitter-queries/
          sql*bigquery*` spelling variants — no `plugin/*.vim` auto-loaded
          files among them, all autoload/filetype-scoped/dev-config/empty. No
          startup behavior change. Safe keep, no exceptions.
- [x] full list: regenerated 2026-07-12 with
      `comm -23 <(git ls-tree -r --name-only main | sort) <(git ls-tree -r --name-only origin/svelte-crostini | sort)`
      (caught and refetched a stale `origin/svelte-crostini` ref on the first
      attempt). Final reconciliation, exact: 373 original main-only paths − 5
      deleted (`bin/claude`, `.local/bin/claude`, `.config/direnv/lib/stdlib.sh`,
      `bin/vim`, root `CLAUDE.md`) − 25 converged (the whole ported
      `bukzor.readline` package, now byte-identical on both branches under
      `lib/pythonpath/bukzor/`) = **343 remaining main-only, all accounted for
      as deliberately kept.** Nothing missed, nothing stray.

## Success Criteria

- [x] every main-only path is either deliberately kept or deleted on main
- [x] no secrets in the surviving set — swept 2026-07-12 across all ~371
      main-only files (`.ssh/` 2026-07-11 + the rest 2026-07-12), zero found

## Notes

Bias reversed 2026-07-12 (user decision): **keep by default.** Reasoning: main-only
paths are inert additions (no filename collisions with svelte, by definition), and
`bukzor/dotfiles` is already public on GitHub, so nothing gains new exposure by
surviving into the merged tree — it's already permanent in `main`'s history either
way (no history rewrite planned). Delete only what demonstrably breaks something
(e.g. active convention/config conflicts) — not on staleness or macOS-only origin
alone. Supersedes the earlier "subtract, delete when unsure" bias below, which is
kept for context on why the per-directory sections above still exist as an
audit/exception list rather than a keep list.

Concrete outcome so far: root `CLAUDE.md` (main-only) — **deleted, committed+
pushed `9534d37`** (main-reunify clone, user decision 2026-07-12): self-declares
override-everything precedence with an old,
incompatible convention set (TodoWrite-disabled, `bin/trash`, "REVIEW NEEDED:"
prefix), a genuine functional conflict alongside the current `~/.claude` system —
not merely stale. **Correction 2026-07-12:** `.claude/CLAUDE.md` (nested) is
**not main-only** — verified via `git ls-tree` it exists on both branches with
different blob hashes, i.e. a same-path divergence already tracked under 004
("claude config"), not 003's call; only root `CLAUDE.md` is 003's to delete.
`.ssh/config`'s hardcoded macOS `Include` paths were flagged as a landmine
needing an "OSTYPE guard" — corrected 2026-07-12: verified empirically
(`ssh -F <cfg> -G host`, exit 0) and via ssh_config(5) that `Include` of a
nonexistent path/glob is a silent noop, not an error. No guard needed; keep
verbatim (also fixed in 004's task file).

**Full sweep completed 2026-07-12** (all remaining main-only dirs, bar: does it
actually break/conflict, not just stale/macOS-authored):

- **Confirmed break — deleted (user decision 2026-07-12):** `bin/claude` + `.local/bin/claude` — verified live
  (`type -a claude` → `~/.local/bin/claude` → real, working
  `~/.local/share/claude/versions/2.1.207`). Main's `.local/bin/claude` is a
  symlink to `/Users/buck/.local/share/claude/versions/1.0.107` (nonexistent on
  Linux); main's `bin/claude` wrapper execs through to the same broken path, and
  `~/bin` precedes `~/.local/bin` in PATH (verified), so it'd be hit first.
  Net effect if kept: the `claude` command breaks on this machine after merge.
  `.local/share/claude-bin/{pgrep,sed}` shims `bin/claude` also PATHs in are
  harmless (symlink to real `/usr/bin/*`) but orphaned either way — fine either
  way, not blocking.
- **Confirmed break — deleted (user decision 2026-07-12):**
  `.config/direnv/lib/stdlib.sh` — symlink to `/Users/buck/.config/direnv/
  stdlib.sh` (nonexistent). direnv is installed (`/opt/homebrew/bin/direnv`)
  and actively hooked on every prompt via svelte's `.config/sh/rc.d/direnv.sh`;
  direnv's docs confirm `lib/*.sh` loads before every `.envrc`. Whole
  `.config/direnv/` tree is main-only (doesn't exist on svelte at all yet), so
  merging it in would've introduced this broken symlink alongside a working
  sibling `.config/direnv/stdlib.sh` (real ~2.5KB vendored file, no `lib/`) —
  the likely intended target, which stays. Deleted rather than relativized —
  simpler, and `lib/` matching zero files is itself an established-safe
  pattern (same as the `.ssh/config` Include finding above).
- **Behavior change — resolved, deleted (user decision 2026-07-12):** `bin/vim`
  — symlink to `/opt/homebrew/bin/nvim`, doesn't error (linuxbrew is installed
  here), but `~/bin` precedes `~/.local/bin` (verified), so it would have
  shadowed svelte's existing alternatives-managed `~/.local/bin/vim` launcher.
  User: "avoid/remove; merge svelte-crostini → main for that aspect" — svelte
  has no `bin/vim` at all, so deleting main's is exactly that.
- ~~`.vim/pack/invented-here/start/{cursorline,diffmode,osc52}/`~~ — **retracted
  2026-07-12, this was a sweep error.** User correctly challenged it ("don't we
  have a lot of that in svelte-crostini? I thought we did") — verified directly
  and they were right: these are not main-only. See the corrected `.vim/`
  Implementation Steps entry above for the real finding.
- **Everything else swept clean, safe to keep:** `Library/` (6, fully inert —
  macOS-only paths nothing on Linux reads), `.weechat/`+`.subversion/` (weechat/
  svn not installed, inert regardless of content), `.jq/` (jq installed, but
  `~/.jq` is only consulted via explicit `import`/`include` in a jq program —
  none found in svelte's scripts), `.bash_completion/` (bash-completion package
  sourced on svelte, but its legacy hook requires `-f ~/.bash_completion` as a
  *file*; main-only version is a *directory*, so the hook's `-f` test never
  fires), `setup/`, `repo/` (both standalone manually-invoked, no auto-source
  found), rest of `bin/` (48 total, only `claude`/`vim` flagged above), `.config/`
  (35, only `direnv/lib/` flagged above), `lib/`+`libexec/`+`.local/` (36, incl.
  the already-known-inert `bukzor.readline` package; nothing else new), `.claude/`
  main-only subset (53, all archived docs/old commands, nothing live-authoritative
  besides root `CLAUDE.md` already flagged). No embedded secrets found anywhere
  in the ~225 files checked in this pass (a few grep hits were false positives).
  `fish/` main-only files hardcode macOS paths too but fish isn't wired into
  svelte's shell matrix at all — inert.
- **Dangling-reference check:** zero hits grepping the KEEP dirs
  (`.zsh_completion/`, `.zkbd/`, `.sh_lib/`, `.sh_plugins.d/`, `docs/`) plus the
  rest of the main-only tree for references to root `CLAUDE.md` — clean to
  delete it.

Prior bias (superseded, kept for context): subtract. When unsure and the file is
recoverable from history, delete — resurrection is one `git checkout main~N --
path` away.

Execution: keep/delete decisions are the user's; once decided, the per-directory
delete-commits + dangling-ref sweeps are independent — fan out as parallel subagents.
