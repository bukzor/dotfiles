# Devlog: 2026-07-07 — shell PATH-prepend: eliminate eval/array-emulation with a heredoc-fed line iterator

## Focus

`~/.profile`'s PATH-prepend block (`.config/sh/functions.d/path.sh`) had
drifted mid-refactor into a broken state: `.profile` called `path_stdin`, a
function that no longer existed. Root cause turned out to be much more
interesting than the typo: the whole `dehumanize`/`hardquote`/`stdin_to_argv`
apparatus existed only to fake an array in POSIX sh, and a real, independent
bug (`for arg in "${args[@]}"` instead of `"${oldargs[@]}"`) had silently
disabled the stdin-substitution feature entirely — zero output, zero error,
since `nounset` wasn't on. Session scope grew from "fix the typo" to "redesign
the primitive," per explicit direction: this is meant to be a general,
reusable "human-authored heredoc config → per-item processing" mechanism used
across many call sites in this repo, not a PATH-specific hack.

## Decisions

### Heredoc-fed `while read`, not piped, as the iteration primitive

**Rationale:** A pipe's right-hand side (`cmd | while read ...; do ...; done`)
runs in a subshell in POSIX sh — any mutation to the calling shell's variables
inside that loop is silently lost when it exits. A heredoc-fed loop
(`while read ...; do ...; done <<EOF ... EOF`) is a redirection, not a pipe,
so it runs in the *same* shell — no subshell, no lost mutations, and (bonus)
no quoting/escaping needed at all, since `read` takes a whole line as one
value regardless of embedded spaces. Verified empirically (not just reasoned
about) side-by-side under `dash`, `bash`, and `busybox ash`: the piped version
reliably came back empty, the heredoc-fed version reliably preserved the
mutation, identically across all three shells.

**Alternatives considered:**
- **Bash arrays** (`readarray`/real `${arr[@]}` slicing) — rejected outright:
  busybox support is a hard, stated requirement (`.profile` must work under
  busybox), not aspirational, so bash-only features are off the table for
  anything `.profile`/`functions.d` sources.
- **One awk/sed pass doing the whole prepend+dedup+reorder** — rejected: would
  have collapsed the existing well-decomposed, individually-testable
  functions (`__sh_functions_d_path__{prepend,append,remove,cleanup}`) into
  one dense, hard-to-debug script. Correctly called out as a real regression
  in debuggability, not a false concern.
- **`tty -s` auto-detection of stdin vs. argv** (the original pre-breakage
  design) — replaced with explicit dispatch on `$#` (zero trailing args ⇒
  read stdin). `tty -s` is an oracle consulted at call time (external
  terminal state), which is exactly the anti-pattern flagged in
  `design-rules.kb/deterministic-by-construction.md`; dispatching on argument
  count is a property of the call itself, and is one less token
  (`-` sentinel) at every call site than the intermediate WIP had.

### Split into single-concern files, not one bundled file

**Rationale:** `config2lines` (text transform: strip comments/whitespace/
blank-lines) and `each_config_line` (control-flow: call FUNC once per line,
subshell-safe) are different concerns with different reuse profiles —
someone might want decluttered config text without per-line dispatch. `hardquote`
(safely round-trip a string through `eval`) also turned out to be
independently valuable on its own, unrelated to this pipeline, and was
restored as its own file after initially being deleted as apparently-dead
code.

### Naming

- `dehumanize` → `config2lines` (says what survives — clean lines — not a cute
  metaphor).
- `each_line` (initial rename) → `each_config_line` (the first name was
  flagged as "too generic" — it lost the fact that the line specifically
  comes from a human-authored config heredoc, which is the whole point of
  the comment/whitespace stripping step it wraps).

## Conventions Established

- **When faking "an array" in POSIX sh, don't.** `shift n` is a genuine,
  native, zero-trick equivalent of Python's `arr[n:]`; there is no equivalent
  for `arr[:n]` (must loop). But most cases that reach for array semantics in
  sh actually want per-item *dispatch*, not storage — reach for a heredoc-fed
  `while read` calling a callback, not an eval/quote reconstruction of `"$@"`.
- **A piped `while read` silently drops mutations; a heredoc-fed one doesn't.**
  This distinction is easy to get backwards by eyeballing "looks about
  right" — it needs an actual counter-example test, not a read-through. (See
  the new todo for turning this into a real regression test.)
- Function-name convention for this kind of primitive: name the *thing that
  survives / the specific source*, not the mechanism (`config2lines`, not
  `dehumanize`; `each_config_line`, not `each_line`).

## Open Questions

- [ ] See `.claude/todo.kb/2026-07-07-001-shell-function-unit-testing-and-ci-regression-harness.md`
      — none of this has automated regression coverage yet, and two silent
      regressions shipped in this exact subsystem within this one session.
- Framework/CI-mechanism choice for that harness is explicitly left open in
  that todo file — not decided here.

## References

- `~/.config/sh/functions.d/{path,each_config_line,config2lines,hardquote}.sh`
- `~/.profile` (the `path prepend PATH <<EOF ... EOF` call site)
- `.claude/design-rules.kb/deterministic-by-construction.md` (motivates the
  `tty -s` → `$#`-dispatch decision)
- `.claude/design-rules.kb/count-data-variants.md`,
  `removable-means-remove.md` (motivated recognizing the argv-marshaling
  layer as removable complexity, not a fixed cost)
