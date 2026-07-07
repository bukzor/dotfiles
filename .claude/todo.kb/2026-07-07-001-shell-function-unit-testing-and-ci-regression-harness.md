---
managed-by: Skill(llm-subtask)
status: open
cost-benefit-sweh:
  timebox:
    "@value": 0.5
    rationale: |
      Research + decide framework/CI-mechanism (bounded by Open Questions
      below), then backfill tests for the 4 files in scope. No new
      product code, just harness + assertions.
    confidence: tentative
  benefit-2w:
    "@value": 1.5
    rationale: |
      Two real regressions shipped silently in ~/.config/sh/functions.d/
      this session alone, undetected until manual use. This is personal
      login-shell infra with a hard cross-shell-compat requirement
      (busybox) that's easy to violate by accident and currently checked
      by hand, ad hoc, per session.
---

# Shell-function unit testing + CI regression harness

**Priority:** Medium
**Complexity:** Medium
**Context:** Surfaced during the 2026-07-06/07 session that rewrote
`~/.config/sh/functions.d/{path,each_config_line,config2lines,hardquote}.sh`
and audited `~/.profile`'s PATH-prepend call site.

## Problem Statement

`~/.config/sh/functions.d/*.sh` and `~/.profile` have zero automated tests.
They also carry a hard, easy-to-violate requirement: every function must work
identically under `dash`, `busybox ash`, and `bash` (the comment
`# compatibility: dash, busybox sh, zsh, bash` is a real constraint, not
decoration — busybox support is a stated hard requirement, not aspirational).
Nothing currently enforces either property except a human reading the diff.

This is not hypothetical risk. Two regressions shipped silently in this exact
subsystem within the same session, both invisible until a human happened to
exercise the code by hand:

- `.profile` called `path_stdin`, a function that had been renamed/removed;
  every login shell hit `path_stdin: not found` and the entire PATH-prepend
  block silently no-opped. No test caught it; it was found by manually
  sourcing `.profile` in an isolated subshell.
- A typo (`for arg in "${args[@]}"` instead of `"${oldargs[@]}"`) silently
  disabled `stdin_to_argv`'s entire stdin-substitution feature. Because
  `nounset` wasn't on, the bad array reference just expanded to nothing —
  zero output, zero error, the loop body simply never ran. Only running the
  script and reading its `set -x` trace revealed the "-" placeholder was
  passing straight through unprocessed.

A third failure mode found (and fixed by design, not by test) this session:
a piped `while read` loop *looks* correct but silently discards every
variable mutation inside it (pipeline components run in a subshell); only a
heredoc-fed loop is safe. This is exactly the class of bug a human
eyeballing "looks about right" will not reliably catch — it needs a
regression test with a real counter-example, not a read-through.

## Current Situation

All verification this session was manual and ephemeral: one-off scripts
written to `~/tmp/`, each interpreter (`dash`, `bash`, `busybox ash`) invoked
by hand, output eyeballed for equality across shells. None of that persists.
The next edit to `path.sh` has zero safety net and no CI to catch a repeat of
either regression above.

## Proposed Solution

Deferred to the implementing session. This file specifies **requirements
only** — what must be true when this is done. Framework choice, CI mechanism,
and test file layout are open decisions (see Open Questions) and should be
researched/decided when this is picked up, not prescribed here.

## Requirements

- [ ] A test runner exists that can execute the same test body under
      multiple `sh` implementations (at minimum `dash` and `busybox ash`;
      `bash` and `zsh` too if reasonably available) and report per-shell
      pass/fail — cross-shell parity must be a first-class harness
      capability, not something each test re-implements by hand.
- [ ] The harness/tests are wired into some form of regression gate that
      runs automatically on change to `~/.config/sh/functions.d/*.sh` or
      `~/.profile` (CI, pre-commit hook, pre-push hook — whichever fits;
      see Open Questions on whether this repo has anywhere for "CI" to
      run).
- [ ] Reintroducing either of the two concrete regressions described above
      (the `path_stdin` typo; the `${args[@]}`-vs-`${oldargs[@]}` typo)
      causes a test to fail. (Write these as literal regression tests, not
      just generic coverage — the whole point is these exact mistakes.)
- [ ] Test coverage exists for the current, live implementations of:
  - [ ] `config2lines` — comment stripping (incl. the `\#` escape),
        leading/trailing whitespace stripping, blank-line dropping.
  - [ ] `hardquote` — round-trips a string containing an embedded `'`
        back through `eval` unchanged.
  - [ ] `each_config_line` — calls its callback once per (decluttered)
        line, preserves embedded spaces without splitting, and — the
        load-bearing property — a mutation the callback makes to a
        caller-scope variable is visible *after* `each_config_line`
        returns (this is the heredoc-vs-pipe subshell distinction; assert
        it directly, don't just assume the heredoc form stays heredoc-fed).
  - [ ] `path` — `prepend`/`append` dedup semantics ("last wins" ordering
        on repeated entries), both call forms (heredoc/stdin vs. explicit
        argv args dispatched via `$#`), and cross-shell parity.
  - [ ] An end-to-end smoke test: sourcing the real `~/.profile` in an
        isolated environment (`env -i`) produces a `PATH` containing the
        expected prepended entries in the expected order.
- [ ] Out of scope: the exploratory demo scripts under `~/tmp/`
      (`stdin-to-argv*.sh`, `argv-slice*.sh`, `path-each-line-demo.sh`,
      `stdin-foreach-demo.sh`) were throwaway teaching artifacts, not
      shipped config — no requirement to cover them.

## Open Questions

- [ ] Framework: hand-rolled assertion script, `bats-core`, `shunit2`, or
      something else? Must run cleanly under all target shells (a
      bash-only framework like bats-core running the *tests* in bash is
      fine even if the *code under test* must also pass under
      dash/busybox — worth confirming which layer needs which shell).
- [ ] Where do tests live — beside the functions
      (`functions.d/path.test.sh`), or a parallel test tree? Precedent
      elsewhere in this repo, if any, should win.
- [ ] Does this repo have a GitHub remote / existing CI config to hook
      real CI into, or is "CI" here better read as a local git hook
      (pre-commit/pre-push), given this is a personal dotfiles repo that
      may not push anywhere that runs Actions?
- [ ] Should this harness generalize beyond `functions.d/` (i.e. become the
      standard way *any* shell script in this repo gets regression-tested),
      or stay scoped to `functions.d/*.sh` + `.profile` for now?

## Success Criteria

- [ ] Running the test suite locally catches both of today's regressions
      if deliberately reintroduced (verify by temporarily reverting each
      fix and confirming red, then restoring).
- [ ] The suite runs across the full shell matrix decided above with a
      single invocation, not one manual command per shell.
- [ ] Some automatic trigger (CI or local hook — per Open Questions) runs
      the suite on relevant changes without a human remembering to.

## Notes

Sibling effort: `reunify-dotfiles/2026-07-07-000-CI-and-testing-foundations.md`
plans the harness/CI system for the branch-reunification work — one harness
decision should serve both files (its survey table includes this file's needs).
Two of this file's open questions are answered there: the repo's origin is
`github.com/bukzor/dotfiles` and it is PUBLIC, so GitHub Actions is available.

The design work these tests cover: `~/.config/sh/functions.d/config2lines.sh`,
`hardquote.sh`, `each_config_line.sh`, `path.sh`, and the call site in
`~/.profile`. The heredoc-not-pipe subshell-safety property was verified by
hand this session with a throwaway script comparing piped-vs-heredoc-fed
`while read` loops across `dash`/`bash`/`busybox ash` — that comparison is a
good starting point for a real test, not just a one-off demo.
