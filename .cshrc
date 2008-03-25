#NON-INTERACTIVE~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if ($?term == 0) then
    #source Gilles' stuff
    source $ATICAD_DISK/src/sysadmin/cpd.cshrc

    #tcsh likes to print to stderr after long commands...
    #try this: 'set time=0'
    unset time

    module load aticad 
    exit 0
endif


#INTERACTIVE~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

setenv save_term $term
setenv term "BEGterm" #prevent Gilles from clobbering my terminal title
#source Gilles' stuff
source $ATICAD_DISK/src/sysadmin/cpd.cshrc
setenv term $save_term




#fix bad keyboard stuff
if ($term == "xterm" || $term == "vt100" \
|| $term == "vt102" || $term !~ "con*") then
    # bind keypad keys for console, vt100, vt102, xterm
    bindkey "\e[1~" beginning-of-line  # Home
    bindkey "\e[7~" beginning-of-line  # Home rxvt
    bindkey "\e[2~" overwrite-mode	   # Ins
    bindkey "\e[3~" delete-char	   # Delete
    bindkey "\e[4~" end-of-line	   # End
    bindkey "\e[8~" end-of-line	   # End rxvt
endif


#tricky stuff to get vnc hostname in prompt
setenv hostname `basename $HOST .ca.atitech.com`
if ($?DISPLAY == 1) then
    set display=`echo $DISPLAY | sed -e "s/localhost//" -e "s/\.0//"`
    setenv hostname $hostname$display
endif

#command shortcuts
set color=""
setenv EDITOR vim
setenv P4EDITOR vim
alias ls 'ls-F'
alias grep 'grep --color'
alias login 'source ~/.cshrc'
alias lt "ls -lthr --time-style=+'[%D %r]'"
alias la "ls -lAh --time-style=+'[%D %r]'"
alias ll "ls -lh --time-style=+'[%D %r]'"
alias lS "ls -lShr --time-style=+'[%D %r]'"
alias sql_metrics "mysql -D ati_metrics -u metricsu -pUM.ic4%"
alias sql_sb2     "mysql -D sharedbook_auth -u SBapache -pwobble!"
alias sql_root    "mysql -u root -p4sVc\\!2Oa"

#directories
setenv newflow /home/bgolemon/wc/tools/aticad/1.0/flow/TileBuilder/metrics/scripts
setenv fct /proj/mario-pd9/fctiming/
setenv oldflow /home/bgolemon/wc/tools/aticad/1.0/src/metrics
setenv rootflow /tools/aticad/1.0/flow/TileBuilder/metrics/scripts
if ( $?physDir == 1 ) then
    alias testdir $physDir/tiles/routed/vmt
endif


#environment prompts
setenv MYTREE '-' #indicates current p4 tree
setenv MYPROJ '-' #indicates last setproj

#environment aliases
alias reprompt 'set prompt="$MYPROJ-$MYTREE> [%n@$hostname] [%d %t]  %~%#"; localroot'
alias tools 'setenv P4PORT terra.ca.atitech.com:1666; setenv P4CLIENT bgolemon_tools; setenv ROOT ~/trees/tools; setenv MYTREE TOOLS; reprompt'
alias sivcad 'setenv P4PORT terra.ca.atitech.com:1666; setenv P4CLIENT sivcad; setenv ROOT /tools; setenv MYTREE SIVCAD; reprompt'

#various project environments
alias boom 'setproj boom; setenv MYPROJ BOOM; reprompt;';
alias mario 'setproj mario; setenv MYPROJ MARIO; reprompt;';
alias walden 'setproj walden; setenv MYPROJ WALDEN; reprompt;';
alias luigi 'setproj luigi; setenv MYPROJ LUIGI; reprompt;';
alias cypress 'setproj cypress; setenv MYPROJ CYPRESS; reprompt;';
alias kong 'setproj kong; setenv MYPROJ KONG; reprompt;';

alias pthuge 'ptver; title "Primetime: $cwd"; bsub -Ip -q fc_timing_96G -R "rusage[pt=1:mem=85000]" pt_shell'
alias ptbig 'ptver; title "Primetime: $cwd"; bsub -Ip -q fc_timing_96G -R "rusage[pt=1:mem=46000]" pt_shell'
alias ptmed 'ptver; title "Primetime: $cwd"; bsub -Ip -q fc_timing_96G -R "rusage[pt=1:mem=14000]" pt_shell'
alias ptsmall 'ptver; title "Primetime: $cwd"; bsub -Ip -q fc_timing_96G -R "rusage[pt=1:mem=6000]" pt_shell'
alias ptscan 'ptver; title "Primetime: $cwd"; bsub -Ip -q fc_timing_96G -R "rusage[pt=1:mem=22000]" pt_shell'
alias ptver 'module switch primetime primetime/2007.06-SP3'

#lets me install things to my homedir
if (-x ~/bin/envv ) then
    alias envv ~/bin/envv
endif
if { which envv >& /dev/null } then
    alias localroot eval `envv add PYTHONPATH	~/python`; \
		    eval `envv add PYTHONPATH	~/lib/python/`; \
		    eval `envv add PYTHONPATH	~/lib/python2.4/site-packages/`; \
		    eval `envv add PATH    ~/bin 1`;\
		    eval `envv add MANPATH /tools/lsf/6.1/man`;\
		    eval `envv add LD_LIBRARY_PATH ~/lib`;
else
    alias localroot ""
endif

#default environment
if ( "$SITE" == "sj" ) then
    kong
else if ( "$SITE" == "cvd" ) then
    walden
else if ( "$SITE" == "hyd" ) then
    luigi
endif

tools
#echo "Be Happy!"

#nice tab-completion stuff
source ~/.csh.completions

# vim: syntax=tcsh
