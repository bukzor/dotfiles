#!/sourceme/bash

tacos-demo::clone() {
  local test_name="$1"

  rm -rf tacos-demo
  git clone git@github.com:getsentry/tacos-demo
  cd tacos-demo/terraform/env/prod/ || return 1
}

tacos-demo::new-pr() {
  # returns: the URL of the new PR
  test_name="$1"

  local branch
  branch="$USER/$test_name/$(tr : _ <<< "$NOW")"
  # NB: setting an upstream tracking branch makes `gh pr` stop working well
  git checkout -b "$branch"

  # edit one or more slices
  slice::edit-random

  git commit -am "test: $test_name ($NOW)"
  git push origin "$branch:$branch"

  pr_url="$(gh::open-pr "$branch")"
  banner PR opened: "$pr_url"

  # this callback is defined in test-environ.sh
  # shellcheck disable=SC2317 # command appears unreachable
  onexit() {
    gh::close-pr "$pr_url"
  }

  echo "$pr_url"
}


