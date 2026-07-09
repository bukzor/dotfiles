#!/not/executable/sh
# migrated from inline .profile exports 2026-07-09 (task 000); HOMEBREW_CC
# lives in 300-homebrew.sh only now -- it was set inline here too, verbatim
export CLICOLOR=truecolor
export COLORTERM=truecolor
export EDITOR=vim
export MAKEFLAGS="-j $(($(nproc) * 3))"

# set claude to always ultrathink
# any higher value sets 21332 as the number...
# https://github.com/anthropics/claude-code/issues/11211
export MAX_THINKING_TOKENS=63999

export VOLTA_HOME="$HOME/.volta"
export PYTHONPATH="$HOME/lib/pythonpath${PYTHONPATH:+:$PYTHONPATH}"
