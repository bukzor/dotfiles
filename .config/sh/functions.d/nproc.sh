#!/bin/sh

if ! has nproc; then
  # nproc doesn't exist in macos
  nproc() { sysctl -n hw.physicalcpu; }
fi
