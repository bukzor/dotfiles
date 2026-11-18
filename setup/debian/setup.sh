#!/bin/sh
set -eu
HERE="$(cd "$(dirname "$0")"; pwd)"

set -x
cat "$HERE"/apt.list |
  sed -r 's/#.*$//' |
  xargs -tr \
    sudo apt-get install

"$HERE"/../setup-podman.sh
