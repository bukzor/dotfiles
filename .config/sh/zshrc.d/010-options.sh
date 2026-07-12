# allow $var/`cmd`/$((expr)) interpolation in PS1 to be re-evaluated on
# each prompt redraw
setopt PROMPT_SUBST

setopt COMPLETE_IN_WORD          # tab in the middle of a word works correctly!
setopt ALWAYS_TO_END
setopt INTERACTIVE_COMMENTS      # sometimes I copy-paste comments
setopt NOMATCH                   # refuse to use ambiguous globs
setopt CHASE_DOTS                # resolve ".." paths textually, not physically
setopt AUTO_CD                   # using a directory as a command implies "cd"

unsetopt EXTENDED_GLOB           # weird zsh-specific globbing
unsetopt BEEP                    # no, thanks
unsetopt NOTIFY                  # background jobs' status waits for prompt
