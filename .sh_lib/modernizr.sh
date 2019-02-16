# sh

myexe=/proc/$$/exe
if $myexe -xc 'x+=(1); [ "${x[*]}" = 1 ]'; then
  SH_MODERN_ARRAY=true
else
  SH_MODERN_ARRAY=false
fi

if $myexe -xc 'trap true DEBUG EXIT ERR TERM'; then
  SH_MODERN_TRAP=true
else
  SH_MODERN_TRAP=false
fi

if $myexe -xc 'unset x; [[ $x = "" ]]'; then
  SH_MODERN_COND=true
else
  SH_MODERN_COND=false
fi

unset myexe
