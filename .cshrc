#ALWAYS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#trivial comment
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

#commands I don't want to remember
alias testSO 'py.test -D mysql://tester:@pdsql/test'
alias cronpd 'ssh cronpd@svvgcron01.amd.com'
alias bukzor 'ssh -t AMD+bgolemon@svlssh ssh -t golemon@bukzor.hopto.org'

#site-specific machines
alias sshcvd "ssh mkdcgar01"
alias sshhyd "ssh lhlogin10"
alias findcvd 'ypcat hosts | grep "\<ltis" | awk '"'"'{print $2}'"'"' | xargs --replace bash -c "(rsh {} echo {} &) < /dev/null  &"'

if ( -e ~/.alias ) then
    source ~/.alias
endif

# vim: syntax=tcsh
