# Unknown command -> bin/command-not-found-hook (Alpine's apk
# command-not-found, else `brew which-formula`). WSL-only for now: penguin's
# Debian ships its own handler, which this would replace. The `has` check is
# load-bearing: if the hook is missing, calling it re-enters the handler, and
# bash forks forever.
if [ -n "${WSL_DISTRO_NAME:-}" ] && has command-not-found-hook; then
  if [ -n "${BASH_VERSION:-}" ]; then
    command_not_found_handle() { command-not-found-hook "$1"; }
  elif [ -n "${ZSH_VERSION:-}" ]; then
    command_not_found_handler() { command-not-found-hook "$1"; }
  fi
fi
