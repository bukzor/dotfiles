# normally ctrl-s tells the terminal to pause, which gets really confusing:
if tty -s; then
  stty -ixon
fi
