source /tools/aticad/1.0/src/sysadmin/cpd.cshrc

if ($term == "xterm" || $term == "vt100" \
    || $term == "vt102" || $term !~ "con*") then
        # bind keypad keys for console, vt100, vt102, xterm
        bindkey "\e[1~" beginning-of-line  # Home
        bindkey "\e[7~" beginning-of-line  # Home rxvt
        bindkey "\e[2~" overwrite-mode     # Ins
        bindkey "\e[3~" delete-char        # Delete
        bindkey "\e[4~" end-of-line        # End
        bindkey "\e[8~" end-of-line        # End rxvt
endif

setenv MYTREE '^_^'
alias reprompt 'set prompt="$MYTREE %%%T %c2 %h%#"'
alias tools 'setenv P4PORT terra.ca.atitech.com:1666; setenv P4CLIENT bgolemon_tools; setenv ROOT ~/trees/tools; setenv MYTREE TOOLS; reprompt'
alias boom 'setenv MYTREE BOOM; setenv ENV boom; proj_env';

alias newflow 'cd ~/wc/tools/aticad/1.0/flow/TileBuilder/metrics/'
alias oldflow 'cd ~/wc/tools/aticad/1.0/src/metrics/'

reprompt
