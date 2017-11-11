# ~/.profile: executed by the command interpreter for login shells.

# General shell environment, shared by zsh
. ~/.sh_env

# if running bash
if [ -n "$BASH_VERSION" ]; then
    . "$HOME/.bashrc"
fi
