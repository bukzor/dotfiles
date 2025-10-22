#!/sourceme/sh
for i in ~/.sh/rc.d/*.sh; do
  . $i
done
unset i
