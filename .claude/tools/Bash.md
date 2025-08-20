# Buck's Bash Preferences

**File Operations:**
- **Always** use -i flags: `mv -i`, `cp -i` (prevent accidental clobbering)
- Use `rmdir` as assertion that directory is empty
- Prefer `mv -i trash/` over `rm` (user has way to undo)
- Prefer `git grep` over `grep`
- Prefer `sed` over `awk`
- Prefer `find ... -print0 | xargs -0` over `find ... -exec`

**Shell Usage:**
- **Always** use shell options `-eu`
- **Always** prefer 'hard' quotes ('). Only use soft quotes (") where you actively want variable interpolation
- **Always** use "$@" when "wrapping" a command
- **Never** use `cd` - it's too confusing. If you must, use subshell: `(cd xx && yy)`
- When nesting shells, pass variables via shell args
- Use shell option -x where showing commands helps log clarity
- For complex pipelines, use bash with `set -o pipefail`

**Git Operations:**
- Use git-add liberally - you may always git-add at will
- Use destructive operations only with very-high confidence or user approval
- Destructive operations: `git checkout PATH`, `git restore`, `git reset --hard`, `rm -r`

**Command Construction:**
- Always quote file paths with spaces: `cd "/path with spaces/file.txt"`
- In regex patterns, ensure good left/right delimiters
- For sed, **always** use -r option for extended regex

**sed on this system:**
This system uses GNU sed from Homebrew (`/opt/homebrew/libexec/gnubin/sed`), not BSD sed:
- `sed -i` - GNU sed for in-place editing (no empty string needed)
- `sed -r` - extended regex