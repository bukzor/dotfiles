#!/bin/bash
#
# bash-preexec.sh -- Bash support for ZSH-like 'preexec' and 'precmd' functions.
# https://github.com/rcaloras/bash-preexec
#
#
# 'preexec' functions are executed before each interactive command is
# executed, with the interactive command as its argument. The 'precmd'
# function is executed before each prompt is displayed.
#
# Author: Ryan Caloras (ryan@bashhub.com)
# Forked from Original Author: Glyph Lefkowitz
#
# V0.3.6
#

# General Usage:
#
#  1. Source this file at the end of your bash profile so as not to interfere
#     with anything else that's using PROMPT_COMMAND.
#
#  2. Add any precmd or preexec functions by appending them to their arrays:
#       e.g.
#       precmd_functions+=(my_precmd_function)
#       precmd_functions+=(some_other_precmd_function)
#
#       preexec_functions+=(my_preexec_function)
#
#  3. Consider changing anything using the PROMPT_COMMAND
#     to use precmd instead. Preexisting usages will be
#     preserved, but doing so manually may be less surprising.
#
#  Note: This module requires one Bash feature: the "PROMPT_COMMAND" variable.
#  If you override this after bash-preexec has been installed it will most
#  likely break.

# Avoid duplicate inclusion
if [[ "$__bpc_imported" == "defined" ]]; then
    return 0
fi
__bpc_imported="defined"

__bpc_inside_precmd=0

# This function is installed as part of the PROMPT_COMMAND.
# It will invoke any functions defined in the precmd_functions array.
__bpc_precmd_invoke_cmd() {
    # Don't invoke precmds if we are inside an execution of an "original
    # prompt command" by another precmd execution loop. This avoids infinite
    # recursion.
    if (( __bpc_inside_precmd > 0 )); then
      return
    fi
    local __bpc_inside_precmd=1

    # Invoke every function defined in our function array.
    local precmd_function
    for precmd_function in "${precmd_functions[@]}"; do
        # Only execute this function if it actually exists.
        if declare -f "$precmd_function" 1>/dev/null; then
            $precmd_function
        fi
    done
}

__bpc_install() {
    # Make sure this is bash that's running this and return otherwise.
    if [[ -z "$BASH_VERSION" ]]; then
        return 1;
    fi

    # Exit if we already have this installed.
    if [[ "$PROMPT_COMMAND" == *"__bpc_precmd_invoke_cmd"* ]]; then
        return 1;
    fi

    # If there's an existing PROMPT_COMMAND capture it and convert it into a function
    # So it is preserved and invoked during precmd.
    if [[ -n "$PROMPT_COMMAND" ]]; then
      eval '__bpc_original_prompt_command() {
        '"$PROMPT_COMMAND"'
      }'
      precmd_functions+=(__bpc_original_prompt_command)
    fi

    PROMPT_COMMAND="__bpc_precmd_invoke_cmd"
}

__bpc_install
