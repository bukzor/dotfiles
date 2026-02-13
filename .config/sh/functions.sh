#!/sourceme/sh
for i in ~/.config/sh/functions.d/*.sh; do
  . $i
done
unset i
