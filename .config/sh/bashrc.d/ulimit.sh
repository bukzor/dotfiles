# raise the open-files soft limit, clamped to the hard limit:
# restricted environments (e.g. CI containers) cap the hard limit lower,
# and asking beyond the cap errors at every login
hard=$(ulimit -Hn)
[ "$hard" = unlimited ] && hard=$((2**18))
ulimit -n $((hard < 2**18 ? hard : 2**18))
unset hard
