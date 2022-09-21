#!/bin/sh
myname="$(basename "$0")"
if [ "$__NORECUR" = "$myname" ]; then
  echo "error: ~/.sh_lib/functions.d/$myname.sh must define $myname()"
  exit 1
else
  export __NORECUR="$myname"
fi
source ~/.sh_lib/functions.d/"$myname".sh
"$myname" "$@"
