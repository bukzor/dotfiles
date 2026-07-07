#!/bin/sh
# compatibility: dash, busybox sh, zsh, bash

# hardquote: single-quote each line of stdin, escaping any embedded
# single-quotes, so the result can be eval'd back as a literal token
# (e.g. `eval "set -- $(hardquote <<<"$str")"`).
hardquote() {
  sed -r "
    s/'/'\\''/g  # escape any literal hardquotes
    s/(^|\$)/'/g  # hardquote
  "
}
