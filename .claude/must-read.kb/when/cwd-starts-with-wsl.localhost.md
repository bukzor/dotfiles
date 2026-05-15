Claude is running on Windows (MSYS/MINGW bash); dev files live in WSL and
are reached via 9P. Crossing that boundary trips:

- `safe.directory` dubious-ownership (owner SID from 9P != Windows user SID)
- phantom "modified" status on ext4-executable files (9P hides the exec bit)
- worktree `.git` files with UNC `gitdir:` pointers Linux git can't resolve

For POSIX work on WSL-hosted files (git, `.sh`, POSIX tools), route through
WSL with a heredoc. Take the distro name from the path segment right after
`wsl.localhost`:

    wsl.exe -d <distro> -- bash <<'BASH'
    cd /home/<user>/<project>/...
    git status
    BASH

Do NOT run MSYS git against `//wsl.localhost/...` paths -- use WSL.

Keep on the Windows side (this is why you're on this harness):
- Windows-MCP, FileSystem-MCP, PowerShell-MCP
- `Read`/`Edit`/`Write`/`Grep` -- filesystem APIs, not a shell; cross fine.
