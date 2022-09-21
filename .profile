# ~/.profile: executed by the command interpreter for login shells.
. ~/.sh_basics

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# for preferred_shell in /usr/bin/zsh /bin/zsh; do
#   if [ ! "$SHELL" -ef "$preferred_shell" -a -x "$preferred_shell" ]; then
#     SHELL="$preferred_shell" exec "$preferred_shell" -xil
#   fi
# done

# General shell environment, shared by zsh
. ~/.sh_env

# if running bash
if [ -n "${BASH_VERSION:-}" ]; then
    . "$HOME/.bashrc"
elif [ "$ZSH_VERSION" ]; then
    : zsh will source .zshrc
else
    . "$HOME/.sh_rc"
fi
