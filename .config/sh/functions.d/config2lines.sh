#!/bin/sh
# compatibility: dash, busybox sh, zsh, bash

# config2lines: strip leading/trailing whitespace, unescaped comments,
# and blank lines from stdin -- for reading a human-authored config
# format into plain data lines.
config2lines() {
  sed -r '
    # delete all:
    s/^ +//             # leading whitespace
    s/(^|[^\\])#.*/\1/  # comments
    s/\\#/#/g           # comment-escapes
    s/ +$//             # trailing whitespace
    /^$/ d              # empty lines
  '
}
