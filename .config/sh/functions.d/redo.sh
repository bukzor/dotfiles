#!/bin/sh
# compatibility: dash, busybox sh, zsh, bash

# redo: parallelize by default.
redo() {
  command redo -j"$(nproc)" "$@"
}
