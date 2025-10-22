#!/not/executable/sh

export HOMEBREW_PREFIX=/opt/homebrew
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew"
path_prepend "$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin"
path_prepend MANPATH "$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}:";
path_prepend INFOPATH "$HOMEBREW_PREFIX/share/info:${INFOPATH:-}";

export HOMEBREW_CC=clang
