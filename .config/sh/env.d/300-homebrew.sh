#!/not/executable/sh
export HOMEBREW
HOMEBREW="$(command -v brew)"
export HOMEBREW_VERBOSE=1
export HOMEBREW_DEVELOPER=1
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX"

# this makes brew-desc not complain:
export HOMEBREW_EVAL_ALL=1

export HOMEBREW_PREFIX=/opt/homebrew
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew"
path prepend PATH "$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin"
path prepend MANPATH "$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}:";
path prepend INFOPATH "$HOMEBREW_PREFIX/share/info:${INFOPATH:-}";

export HOMEBREW_CC=clang
