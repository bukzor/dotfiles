## Shell Commands

Guidelines for any shell command — one-liners, pipelines, or script content.

### Error Handling

Never suppress errors. These patterns hide failures and lose diagnostic information:

```bash
# Bad - swallows stderr and masks exit code
cmd 2>/dev/null || echo "failed"

# Bad - converts failure to success
cmd || true
```

Equivalent to Python's `try: ...; except: print(...)` — obviously wrong there, equally wrong here.

Avoid `-f` flags — they suppress errors. Use `rm -r` not `rm -rf`.

For empty directory trees, use `rmdir -p` — fails safely if non-empty. Never `rm -rf` without reading contents first.

### Redirects

Prefer shell-scope redirects over per-process redirects:

```bash
# Bad - per-process, and broken in claude-code with pipes
cmd 2>&1 | other

# Good - shell-scope, affects all subsequent commands
exec 2>&1
```

### Pipelines

Long pipelines: newline-indent after pipe operators.

```bash
find . -print0 |
  xargs -r0 command
```

Never use globbing for file operations — use `find -print0 | xargs -r0` instead.

### Command Selection

Avoid `head` — causes SIGPIPE. Use `sed -n '1,Np'` instead.

Avoid `grep` for control flow — returns failure on no match. Use `sed -n` instead.

Prefer bash parameter expansion over `sed` for simple substitutions:
`${var//search/replace}`
