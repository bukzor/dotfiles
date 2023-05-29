#!/bin/sh
set -eux
sudo usermod "$(whoami)" \
  --add-subuids 10000-69999 \
  --add-subgids 10000-69999 \
;
