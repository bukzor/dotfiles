---
managed-by: Skill(llm-subtask)
status: active
---

# Main-only path triage

**Priority:** Medium (must precede final merge; independent of other groups)
**Complexity:** Medium (bulk decisions, low per-item effort)
**Branch:** main only (delete-commits in the clone: ~/repo/github.com/bukzor/dotfiles)
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

- [ ] unit tests first (vague reminder): a dangling-reference sweep — after each
      delete-commit, grep the surviving tree for mentions of deleted paths
      (bin names, sourced files); zero hits expected
- [ ] audit .ssh/ (15 files) first — already public on origin, but confirm nothing
      sensitive; document findings
- [ ] KEEP (feeds other groups — do not delete): .zsh_completion/, .zkbd/,
      .sh_lib/, .sh_plugins.d/, docs/ (incl. docs/annoyances/zsh)
- [ ] triage per directory, delete-commit per decision group:
    - [ ] Library/ (macOS-only — presumed delete)
    - [ ] .weechat/ (still used?)
    - [ ] work-era tooling in bin/ (gcloud-*, sentry-adjacent) — keep/delete per file
    - [ ] .config/ main-only subset
    - [ ] lib/, libexec/, .local/
    - [ ] .jq/, .bash_completion/, .subversion/, setup/, repo/
    - [ ] .claude/ main-only subset (old commands/context — much superseded by svelte)
    - [ ] .vim/ main-only subset
- [ ] full list: regenerate with
      `comm -23 <(git ls-tree -r --name-only main | sort) <(git ls-tree -r --name-only svelte-crostini | sort)`

## Success Criteria

- [ ] every main-only path is either deliberately kept or deleted on main
- [ ] no secrets in the surviving set

## Notes

Bias per user values: subtract. When unsure and the file is recoverable from history,
delete — resurrection is one `git checkout main~N -- path` away.

Execution: keep/delete decisions are the user's; once decided, the per-directory
delete-commits + dangling-ref sweeps are independent — fan out as parallel subagents.
