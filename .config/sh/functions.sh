#!/sourceme/sh
for i in ~/.sh/functions.d/*.sh; do
  . $i
done
unset i
