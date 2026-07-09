#!/sourceme/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# all new functionality should be added in ~/.config/sh/*.d/ directories

# return early for noninteractive shells. Inlined (not delegated to a
# sourced file): a `return` inside a *sourced* file only unwinds that `.`
# invocation, not this one -- that's what made the old interactive_only.sh
# a no-op guard.
case $- in
  *i*) ;;
  *) return ;;
esac

# get source_dir, path, has, nproc, ... (functions.d)
. ~/.config/sh/functions.sh

# environment variables (idempotent; .profile also sources these for
# noninteractive login shells -- this covers interactive-only invocations,
# e.g. a fresh shell inside tmux, that never go through .profile at all)
source_dir ~/.config/sh/env.d
# bash-specific shell settings
source_dir ~/.config/sh/bashrc.d
# generic shell startup, shared with zsh
source_dir ~/.config/sh/rc.d

export TZ="America/Chicago"
