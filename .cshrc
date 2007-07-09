set cpd_cshrc=/tools/aticad/1.0/src/sysadmin/cpd.cshrc
if ( -e $cpd_cshrc ) then
    source $cpd_cshrc
endif
unset cpd_cshrc

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


#tricky stuff to get vnc hostname in prompt
set vnchost=`vncconfig -get desktop | sed "s/ .*//"`
if `echo $vnchost | sed "s/:.*//"` == `hostname` then
    setenv host $vnchost
else
    setenv host `hostname`
endif

#environment prompts
setenv MYTREE '-' #indicates current p4 tree
setenv MYPROJ '-' #indicates last setproj
setenv MYENV '-'  #indicates other misc stuff
#environment aliases
alias localroot 'setenv PATH /user/golemon/bin:$PATH'
#alias localroot 'setenv PYTHONPATH /user/bgolemon/lib/python:$PYTHONPATH; setenv PATH /user/golemon/bin:$PATH'
alias reprompt 'set prompt="$MYENV/$MYPROJ/$MYTREE %n@$host %d:%t %c2%#"; localroot'
alias tools 'setenv P4PORT terra.ca.atitech.com:1666; setenv P4CLIENT bgolemon_tools; setenv ROOT ~/trees/tools; setenv MYTREE TOOLS; reprompt'
alias sivcad 'setenv P4PORT terra.ca.atitech.com:1666; setenv P4CLIENT sivcad; setenv ROOT /tools; setenv MYTREE SIVCAD; reprompt'
alias boom 'setproj boom; setenv MYPROJ BOOM; reprompt';
alias test 'setenv MYSQL_NOTOUCH "TRUE"; setenv MYENV TEST; reprompt';
alias notest 'unsetenv MYSQLNOTOUCH; setenv MYENV -; reprompt'

#shortcuts
alias grep 'grep --color'
alias ls 'ls --color'
alias startvnc 'vncserver -geometry 2500x1000'
alias login 'source ~/.cshrc'
setenv newflow ~/wc/tools/aticad/1.0/flow/TileBuilder/metrics
setenv oldflow ~/wc/tools/aticad/1.0/src/metrics

#default environment
test; boom; tools;

source ~/.csh.completions

reprompt
