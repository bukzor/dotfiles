#!/sourceable/bash
# bootstrap a shell with no environment with reasonable defaults
# this needs to be compatible with all shells I might use (busybox, dash, etc.)
# shellcheck disable=SC2006  # allow backticks for hecka-ancient shells
# test: exec env -i $SHELL -l
export PATH LOGNAME USER HOME LANG TERM SHELL
if ! command -v sh > /dev/null; then
  PATH="$(/usr/bin/getconf PATH)"
fi
# these have only one correct value
LOGNAME="$(whoami)"
USER="$LOGNAME"
HOME=`sh -c "unset HOME; echo ~$USER"`
if [ -z "$LANG" ]; then
  LANG='en_US.UTF-8'
fi
if ! [ "$TERM" ]; then
  TERM=xterm-256color
fi
if ! [ "$SHELL" ]; then
  set -x  # this should be exceptional
  if [ -d /proc ]; then
    SHELL="$(readlink /proc/$$/exe)"
  elif ! SHELL="$(ps -o exe= -p $$ 2>&1)"; then
    : 'macos: I am not a fan: SHELL='"'$SHELL'"
    unset SHELL
  fi
  set +x
fi
