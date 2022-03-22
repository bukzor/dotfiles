# ~/.profile: executed by the command interpreter for login shells.
. ~/.sh_basics

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

preferred_shell=/usr/bin/zsh
if [ ! "$SHELL" -ef "$preferred_shell" -a -x "$preferred_shell" ]; then
  SHELL="$preferred_shell" exec "$preferred_shell" -l
fi

# General shell environment, shared by zsh
. ~/.sh_env

# if running bash
if [ -n "${BASH_VERSION:-}" ]; then
    . "$HOME/.bashrc"
elif [ "$ZSH_VERSION" ]; then
    : good to go.
else
    . "$HOME/.sh_rc"
fi
