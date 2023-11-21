#!/bin/bash
source "$REPO_TOP/lib/base.sh"
base::strict-mode

source "$REPO_TOP/lib/array.sh"
source "$REPO_TOP/manual-tests/lib/slice.sh"
source "$REPO_TOP/manual-tests/lib/wait.sh"
source "$REPO_TOP/manual-tests/lib/gha.sh"

# NB: aliases must be defined before their call-site is *parsed*
shopt -s expand_aliases
alias banner=': "'$'\033[92;1m'"=======> "$'\033[m'\"
DEBUG=1

open-pr() {
  branch="$1"
  gh pr create --fill-first --head "$branch"
}

cleanup() {
  banner cleaning up:
  since="$(date +%s)"
  if gh pr edit --add-label ":taco::unlock"; then
    banner waiting for unlock...
    wait::for gha::assert-ran terraform_unlock "$since"
    banner unlocked.
  fi
  banner deleting branch:
  gh pr close --comment "test cleanup" --delete-branch "$pr_url"
}

main() {
  set -x
  rm -rf tacos-demo
  git clone git@github.com:getsentry/tacos-demo
  cd tacos-demo/terraform/env/prod/

  trap cleanup EXIT

  branch="$USER/scenario/happy-path/$(tr : _ <<< "$NOW")"
  # NB: setting upstream tracking branch makes `gh pr` stop working well
  git checkout -b "$branch"

  # edit one or more slices
  slice::edit-random

  git commit -am "test: behaviors/lock-on-pr ($NOW)"
  git push origin "$branch:$branch"

  since="$(date +%s)"
  pr_url="$(open-pr "$branch")"
  banner PR opened: "$pr_url", waiting for lock...

  wait::for gha::assert-ran terraform_lock "$since"
  banner lock ran
  gha::assert-success terraform_lock
  banner lock succeeded

  for slice in 1 2 3; do
    if array::in "$slice" "${slices[@]}"; then
      # relevant slice is locked
      slice::assert-locked "$slice"
    else
      # irrelevant slice is not locked
      slice::assert-not-locked "$slice"
    fi
  done
}


main
