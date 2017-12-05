# ~/.profile: executed by the command interpreter for login shells.

preferred_shell=/usr/bin/zsh
if [[ "$SHELL" != "$preferred_shell" ]]; then
  SHELL="$preferred_shell" exec "$preferred_shell" -l
fi

# General shell environment, shared by zsh
. ~/.sh_env

# if running bash
if [ -n "$BASH_VERSION" ]; then
    . "$HOME/.bashrc"
fi
