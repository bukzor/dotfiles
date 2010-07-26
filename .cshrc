#ALWAYS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#source Gilles' stuff
setenv MINIMALIST 1
source /tool/aticad/1.0/src/sysadmin/cpd.cshrc
module load aticad/1.2


if ($INTERACTIVE == 0) exit 0
#INTERACTIVE SETTINGS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#unmap CTRL-S and CTRL-Q
stty -ixon -ixoff

#tricky stuff to get vnc hostname in prompt
setenv hostname $HOST
if ($?DISPLAY == 1) then
    set display=`echo $DISPLAY | sed -re "s/localhost|$HOST|$hostname//" -e "s/\.0//"`
    setenv hostname $hostname$display
endif
setenv hostname `echo $hostname | sed -re "s/\.ca\.atitech\.com|\.amd\.com//g"`

set prompt="$ATICAD_PLATFORM> [%n@$hostname] [%d %t] %c02/ %?%# "

#command shortcuts
set color
set nobeep
set visiblebell
setenv savehist "5000 merge"
setenv EDITOR vim
setenv P4EDITOR vim
alias ls 'ls-F'
alias grep 'grep --color'
alias login 'source ~/.cshrc'
alias lt "ls -lthr --time-style=+'[%D %r]'"
alias la "ls -lAh --time-style=+'[%D %r]'"
alias ll "ls -lh --time-style=+'[%D %r]'"
alias lS "ls -lShr --time-style=+'[%D %r]'"
alias sql_metrics "ssh -t root@pdsql nice --20 mysql -D ati_metrics -u metricsu -pUM.ic4%"
alias sql_sb2     "ssh -t root@svcpdweb2 nice --20 mysql -D sharedbook_auth -u SBapache -pwobble!"
alias sql_root    "ssh -t root@pdsql nice --20 mysql -u root -p4sVc\\\\!2Oa"
alias sql_volusage 'ssh -t pdsql2 mysql -utbvurw -pWe\\\$7End -Dvolusage2'
alias easy_install "easy_install --always-unzip"
alias newpy 'cp /home/bgolemon/python/blank_template.py'
alias lslogin 'lsload -R "select[interactive&&(type==RHEL4_64||type==RHEL5_64)]order[r15m]"'

#directories
setenv ATICAD /home/bgolemon/tool/aticad/1.0
setenv src $ATICAD/src
setenv sysadmin $src/sysadmin
setenv fctiming $src/webapps/fctiming
setenv misc $src/misc
setenv mod $ATICAD/mod
setenv bin $ATICAD/bin
setenv flow $ATICAD/flow
setenv FLOW_DIR $flow/TileBuilder
setenv metrics $FLOW_DIR/metrics
setenv util $FLOW_DIR/util
setenv packages /proj/fcfp2-archive-nobackup/bgolemon/packages
setenv rootflow /tool/aticad/1.0/flow/TileBuilder/metrics/scripts

#commands I don't want to remember
alias testSO 'py.test -D mysql://tester:@pdsql/test'
alias cronpd 'ssh cronpd@svvgcron01.amd.com'
alias bukzor 'ssh -t AMD+bgolemon@svlssh ssh -t golemon@bukzor.hopto.org'

#site-specific machines
alias sshcvd "ssh mkdcgar01"
alias sshhyd "ssh lhlogin10"
alias findcvd 'ypcat hosts | grep "\<ltis" | awk '"'"'{print $2}'"'"' | xargs --replace bash -c "(rsh {} echo {} &) < /dev/null  &"'

#lets me install things to my homedir
envv add PYTHONPATH      ~/python
envv add PYTHONPATH      ~/lib/python
envv add PYTHONPATH      ~/lib/python2.4/site-packages
envv add PYTHONPATH      ~/tool/aticad/1.0/mod
envv add PATH            ~/bin
envv add CPATH           ~/include
envv add MANPATH         ~/man
envv add LIBRARY_PATH    ~/lib

alias svn ~/bin/svn

setenv P4PORT terra.ca.atitech.com:1666
setenv P4CLIENT bgolemon_tools

#nice tab-completion stuff
source ~/.csh.completions

# vim: syntax=tcsh
