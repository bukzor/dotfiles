#!/not/executable/sh
if [ -n "${WSL_DISTRO_NAME:-}" ]; then
  # wslview (wslu 3.2.4) opens File Explorer instead of a browser: it expects
  # `wslpath -w ""` to fail, but this WSL build returns "." (cwd).
  # ~/bin/wslbrowse calls the Windows default-browser handler directly.
  export BROWSER=wslbrowse

  # commands that would shadow a native one elsewhere (e.g. macOS `open`)
  path prepend PATH "$HOME/bin/wsl-only"
fi
