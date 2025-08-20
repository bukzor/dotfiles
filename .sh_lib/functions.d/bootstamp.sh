#!/bin/sh
bootstamp() {
  if [ -r /proc/stat ]; then
    sed 's/^btime //; t; d' /proc/stat
  elif echo "${OSTYPE:-}" | grep -q '^darwin'; then
    # remove the cruft from the struct to get an int:
    sysctl -n kern.boottime | sed -r 's/^\{ sec = ([^,]+), usec = ([^ ]+) .*$/\1\2/'
  else
    echo "bootstamp: unknown OS" >&2
    return 1
  fi
}
