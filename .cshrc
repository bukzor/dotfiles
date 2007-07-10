#source things
source ~/.csh.completions
set cpd_cshrc=/tools/aticad/1.0/src/sysadmin/cpd.cshrc
if ( -e $cpd_cshrc ) then
    source $cpd_cshrc
endif
unset cpd_cshrc

#fix bad keyboard stuff
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
unset vnchost

#environment prompts
setenv MYTREE '-' #indicates current p4 tree
setenv MYPROJ '-' #indicates last setproj
setenv MYENV '-'  #indicates other misc stuff
#environment aliases
alias reprompt 'set prompt="$MYENV/$MYPROJ/$MYTREE %n@$host %d:%t %c2%#"; localroot'
alias tools 'setenv P4PORT terra.ca.atitech.com:1666; setenv P4CLIENT bgolemon_tools; setenv ROOT ~/trees/tools; setenv MYTREE TOOLS; reprompt'
alias sivcad 'setenv P4PORT terra.ca.atitech.com:1666; setenv P4CLIENT sivcad; setenv ROOT /tools; setenv MYTREE SIVCAD; reprompt'
alias boom 'setproj boom; setenv MYPROJ BOOM; reprompt;';
alias test 'setenv MYSQL_NOTOUCH "TRUE"; setenv MYENV TEST; reprompt;';
alias notest 'unsetenv MYSQLNOTOUCH; setenv MYENV -; reprompt;'


#lets me install things to my homedir
if (-x ~/bin/envv ) then
    alias envv ~/bin/envv
endif

if { which envv >& /dev/null } then
    alias localroot 'eval `envv add PYTHONPATH  ~/python`; \
                    eval `envv add PATH    ~/bin 1`;\
                    eval `envv add MANPATH ~/man 1`;\
                    eval `envv add LD_LIBRARY_PATH ~/lib 1`'
else
    alias localroot ""
endif


#command shortcuts
set color=""
alias ls 'ls-F'
alias grep 'grep --color'
alias login 'source ~/.cshrc'
alias lt "ls -lthr --time-style=+'[%D %r]'"
alias la "ls -lah --time-style=+'[%D %r]'"
alias ll "ls -lh --time-style=+'[%D %r]'"
alias lS "ls -lShr --time-style=+'[%D %r]'"

#directories
setenv newflow ~/wc/tools/aticad/1.0/flow/TileBuilder/metrics
setenv oldflow ~/wc/tools/aticad/1.0/src/metrics
setenv rootflow /tools/aticad/1.0
if ( $?physDir == 1 ) then
    alias testdir $physDir/tiles/routed/vmt

#default environment
test
boom
tools
echo "Be Happy!"

