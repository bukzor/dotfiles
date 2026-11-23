#!/not/executable/sh
export HOMEBREW_VERBOSE=1
export HOMEBREW_DEVELOPER=1
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX"

export HOMEBREW_PREFIX=/opt/homebrew
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew"
path prepend PATH "$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin"
path prepend MANPATH "$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}:";
path prepend INFOPATH "$HOMEBREW_PREFIX/share/info:${INFOPATH:-}";
# Alpine's homebrew runs under a locally built ruby (setup/alpine/homebrew-ruby.sh).
# Appended, so `ruby` stays the system one: brew takes the first PATH ruby new
# enough for it. Elsewhere the directory is absent, and PATH lookup skips it.
path append PATH "$PREFIX/homebrew-ruby/bin"

export HOMEBREW_CC=clang
