#
# Executes commands at the start of any interactive session.
# Shell options, functions, and aliases go here!
# Environment variables do *not* go here. They go in .zprofile.
#

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

setopt PROMPT_SUBST

. ~/.sh_rc
