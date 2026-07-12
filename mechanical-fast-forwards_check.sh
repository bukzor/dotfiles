#!/bin/sh
# Regression for reunify-dotfiles task 001: 26 paths were mechanically
# fast-forwarded to whichever branch was ahead. Guards they stay
# byte-identical across main and svelte-crostini until the branches merge
# (task 006) and this check stops making sense.
set -eu
redo-always
here=$(dirname "$0")
. "$here/lib/sh/assert.sh"

case $(git rev-parse --abbrev-ref HEAD) in
  main) other=svelte-crostini ;;
  svelte-crostini) other=main ;;
  *)
    echo "skip: HEAD is neither main nor svelte-crostini" >&2
    exit 0
    ;;
esac

paths='
bin/alert-slack
bin/deinterlace
bin/gcloud-dump-roles
bin/gcloud-logging-cat
bin/gcloud-python
bin/gcpenv
bin/git-main
bin/git-prune-branches
bin/git-upstream
bin/groupby
bin/json-to-jq
bin/mangrep
bin/strace-defaults
bin/tf-graph
bin/tmux-color
bin/unescape
bin/vimmerge
.pythonrc.py
.vim/lua/bukzor/aerial.lua
bin/brew-handle-gnubin
bin/terminal
bin/tmux-cd
bin/uncolor
Brewfile
.inputrc
.vim/lua/bukzor/unload.lua
'

for p in $paths; do
  d=$(git diff --stat HEAD "origin/$other" -- "$p")
  assert_eq "byte-identical across branches: $p" "" "$d"
done

assert_done
