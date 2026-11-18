#!/not/executable/sh
# wslview (wslu 3.2.4) opens File Explorer instead of a browser: it expects
# `wslpath -w ""` to fail, but this WSL build returns "." (cwd).
# ~/bin/wslbrowse calls the Windows default-browser handler directly.
if [ -n "${WSL_DISTRO_NAME:-}" ]; then
  export BROWSER=wslbrowse
fi
