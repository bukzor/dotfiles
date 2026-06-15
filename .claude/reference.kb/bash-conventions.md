# Bash conventions

For both `Bash()` tool commands and `*.sh` scripts. Only non-obvious or
house-specific choices — bash basics are assumed.

## Non-default bash behavior

### errexit — a non-zero exit ends the line

Lean on it: let a failing command end the line; prefer `producer | xargs
consumer` over capturing to a variable and testing.

    # not this
    FILES=( $(list-files) ); for f in "$FILES[@]"; do test -f "$f" && echo "$f"; done
    # this — the failure itself does the work
    list-files | xargs ls -ld

Allow a *genuinely expected* failure explicitly — `( cmd || : "why this can fail: $?" )`
— never a blind `|| true`, `2>/dev/null`, or `-f`. Don't drive control flow with
`grep` (no match = exit 1 = abort); use `sed -n`, or `if grep -q …`.

### nounset — an unset variable reference ends the line

Default a maybe-unset variable up front: `${VAR:-}`, `${VAR:-fallback}`.

### pipefail — a pipeline fails if any stage does

Don't `head` a pipe to truncate: it exits early, SIGPIPEs the producer, and that
failure ends the line. Use `sed -n '1,Np'`.

### failglob — a glob matching nothing is an error

Don't glob for file operations; `find … -print0 | xargs -r0 …`.

### xtrace — each command prints before it runs

Always under `Bash()`; in scripts only when `DEBUG>0`.

- No `echo`/`printf` to label commands — the trace is the label. For a
  trace-only note, use the noop: `: "what the next step does"`.
- `xargs -t` to print each command it runs.

## Composition & style

Multi-line pipeline: `|` at line end (so you can `# comment` between stages).
Feed shared downstream processing once via a subshell, and close a long pipeline
explicitly with ` \` then `;`:

    ( x
      y
    ) |
      a |
      b \
    ;

Prefer a parent-shell redirect (`exec 2>&1`) over per-command (`cmd 2>&1`) where
practical.

`rm -r`, never `rm -rf`; `rmdir -p` for empty trees; read a directory before
removing it.

Simple substitution: parameter expansion (`${var//a/b}`), not `sed`.
