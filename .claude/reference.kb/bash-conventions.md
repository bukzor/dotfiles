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

## Quoting

**Single quotes by default.** Reach for double quotes only when you actually
want expansion of a `$var` you wrote on purpose. For a literal single quote
inside, end the quote, add an escaped one, reopen: `'"'"'`.

    -m 'a message mentioning `import gzip` and $HOME'   # literal, always
    -m "a message mentioning `import gzip` and $HOME"   # runs import, expands HOME

Quoting a heredoc delimiter protects the body from the shell reading it, not
from a shell you then hand the body to.

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

Per-item shell logic: never loop (`for …; do`, `while read`) over a long list —
xtrace traces every command of every iteration, and the `IFS=`/`-r` quoting is
easy to fumble. `xargs` traces once for the whole run. Filter with
`exists` (test(1) predicate over stdin paths, default `-e`), then one bash per
item via xargs. Both flags are load-bearing: without `-r`, GNU xargs runs once
even on empty input; without `-d'\n'`, `-L1` still word-splits within each line
and treats quote chars specially (`unmatched single quote`).

    # not this
    list-files | while IFS= read -r f; do
      test -f "$f" && printf '%s\t%s\n' "$(date -Im -r "$f")" "$f"
    done
    # this
    list-files | exists -f |
      xargs -d'\n' -rL1 bash -ec 'printf "%s\t%s\n" "$(date -Im -r "$1")" "$1"' -

Prefer a parent-shell redirect (`exec 2>&1`) over per-command (`cmd 2>&1`) where
practical.

`rm -r`, never `rm -rf`; `rmdir -p` for empty trees; read a directory before
removing it.

Simple substitution: parameter expansion (`${var//a/b}`), not `sed`.
