#!/bin/bash
source "$REPO_TOP/lib/base.sh"
source "$REPO_TOP/manual-tests/lib/slice.sh"
source "$REPO_TOP/manual-tests/lib/wait.sh"
strict_mode



open-pr() {
  branch="$1"

  git add slice*/*.tf
  git commit -m 'scenario: happy-path'
  git checkout origin/main -b "$branch"
  #git push origin HEAD
  gh pr create
}

assert-gha-lock-ran() {
  # true when GHA has run its lock action for this branch
  branch="$1"
  gh action -e pull_request -b "$branch"
}



acquire-lock() {
  timeout -s SIGSTOP 1 terraform plan --lock=true --var sleep=9999
}
assert-slice-locked() {(
  slice_number="$1"
  cd slice-"$slice_number"*/
  if ! terraform plan --lock=true; then
    : ok
  else
    echo >&2 "AssertionError: slice $slice_number should be locked!"
    return 1
  fi
)}


main() {
  git clone git@github.com:getsentry/tacos-demo
  cd sut/terraform/env/prod/

  # edit one or more slices
  random-slices | read -ra slices
  for slice in "${slices[@]}"; do
    edit-slice "$slice"
  done

  branch="$USER/scenario/happy-path/$NOW"
  pr_number="$(open-pr "$branch")"

  wait-for assert-gha-lock-ran "$pr_number"

  for slice in "${slices[@]}"; do
    assert-slice-locked "$slice"
  done

  # TODO: the rest
}

set -x
main
