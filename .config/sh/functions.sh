#!/sourceme/sh
for i in ~/.config/sh/functions.d/*.sh; do
  case "$i" in
    *_test.sh) ;; # tests live beside the code; never source them
    *) . "$i" ;;
  esac
done
unset i
