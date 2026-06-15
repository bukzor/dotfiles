# bash-preamble.py — Tests

## Doctests

```bash
python3 -m doctest ~/.claude/hooks/bash-preamble.py -v
```

Run before committing. All changes must include doctest updates.

## Manual Tests (Bash tool)

Run each command via the Claude Code Bash tool and verify the expected output.

## Basic functionality

```bash
echo hi
```
Expected: `+$ echo hi` trace, then `hi`. Single `+$` prefix (not `++$`).

```bash
echo 'he said "hi"' "she said 'bye'"
```
Expected: correct output `he said "hi" she said 'bye'`. Quotes survive.

```bash
x="hello world" && echo "$x" && echo "${x^^}"
```
Expected: variable assignment, `hello world`, `HELLO WORLD`. Dollar expansion works.

```bash
echo "dollar $HOME and backtick `echo nested`"
```
Expected: `$HOME` expands to home path, backtick subshell runs. Not suppressed by `<<'BASH'`.

## Pipes

```bash
echo hi | cat
```
Expected: `hi`. No mangled braces, no `command not found`.

```bash
true | true
```
Expected: clean exit, no errors.

```bash
echo start && echo hi | cat && echo done
```
Expected: all three succeed. Pipe mid-chain works.

## Heredocs (nested)

```bash
cat <<'EOF'
heredoc with $VAR and "quotes" and 'apostrophes'
EOF
```
Expected: literal output, `$VAR` not expanded (user's heredoc is quoted).

## Error handling

```bash
false || echo "caught failure: $?"
```
Expected: `caught failure: 1`. `set -e` doesn't kill `||` short-circuits.

```bash
false
```
Expected: non-zero exit code surfaced (not swallowed).

## Shell syntax

```bash
{ echo inside braces; }
```
Expected: `inside braces`. Brace groups work in user commands.

## Trace suppression

All tests above: no `+$ set +x` line, no `+$ pwd -P` line at the end.

---

## Design decisions

### Why `bash <<'BASH'`

Claude Code's Bash tool uses a JavaScript `shell-quote` library to parse
commands into tokens, then reconstructs them. This library doesn't understand
shell keywords like `{` `}` — it quotes them as literal strings (`'{' cmd '}'`).
This only manifests when pipes are present, because simple commands bypass the
reconstruction path.

Wrapping in `bash <<'BASH' ... BASH` means `shell-quote` only sees `bash` and a
heredoc redirect — no pipes, braces, or special syntax to mangle. The inner bash
receives raw shell source via stdin.

See: https://github.com/anthropics/claude-code/issues/4711 (closed, `2>&1` fix)
See: https://github.com/anthropics/claude-code/issues/32879 (open, `{ }` and heredoc marker fix)

### When #32879 is fixed

The heredoc wrapper becomes unnecessary — commands could be passed directly
without `shell-quote` mangling braces or `$`. At that point:

- Remove the `bash <<'MARKER' ... MARKER` wrapper
- Inline the preamble and epilogue directly into the command
- The UUID marker trick becomes unnecessary
- Hyphenated heredoc markers should work again

### Why the UUID in the heredoc marker

A plain `BASH` marker would collide if the user's command contained the word
`BASH` on a line by itself (e.g. in a heredoc example or documentation string).
A fixed UUID suffix (`BASH_7acb2d94_...`) makes collision effectively impossible.

Underscores instead of hyphens: `shell-quote` splits tokens on hyphens
(treating `BASH-7acb...` as separate tokens `BASH`, `-`, `7acb...`), but
treats `[A-Za-z0-9_]` as a single word. This is itself a `shell-quote` bug
(heredoc markers can legally contain any characters), reported in #32879.

### Why quoted heredoc (`<<'MARKER'` not `<<MARKER`)

The *outer* bash (claude-code's shell) must not expand `$` in the heredoc body.
The *inner* bash (our `bash` invocation) handles all expansion after reading stdin.
This is correct because Python's f-string interpolation inserts the user's command
literally, then the inner bash interprets it.

### Why `{ set +x; } 2>/dev/null` (not alternatives)

The goal: disable xtrace without the `set +x` itself appearing in the trace.

- `set +x 2>/dev/null` — doesn't work. The redirect applies to the forked
  process, but xtrace output comes from the shell itself.
- `(set +x) 2>/dev/null` — suppresses the trace, but `set +x` runs in a
  subshell and doesn't affect the parent. The outer shell's xtrace remains on,
  leaking claude-code's internal `pwd -P` command.
- `eval 'set +x' 2>/dev/null` — the `eval` itself is traced before the redirect
  applies.
- `{ set +x; } 2>/dev/null` — correct. The brace group redirects the *current*
  shell's stderr for the duration of the group, suppressing the trace of `set +x`,
  and `set +x` takes effect in the current shell. This only works inside the
  heredoc because `shell-quote` would mangle the braces in a direct command.

### Why `export PS4='+$ '` (leading `+`)

Bash prepends one `+` per level of eval/source nesting. Our inner bash is one
level deep, so the default `+$ ` becomes `++$ ` without the export. But with
`export PS4='+$ '`, subshells and nested evals show `++$ `, `+++$ `, etc.,
making nesting depth visible while keeping the common case (`+$`) clean.

### Why `set -euo pipefail`

- `-e`: surface failing commands immediately instead of silently continuing.
- `-u`: catch typos in variable names.
- `-o pipefail`: a failing command in a pipeline fails the whole pipeline.
  Without this, `false | cat` succeeds (exit code from `cat`).

These are safe defaults. User commands using `||` or `if` short-circuits still
work — `set -e` only kills unhandled failures.
