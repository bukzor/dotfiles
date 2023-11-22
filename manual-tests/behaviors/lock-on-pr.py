#!/bin/bash
source "$REPO_TOP/manual-tests/lib/test-environ.sh"

main() {
  base::strict-mode
  tacos-demo::clone "$TEST_NAME"

  since="$(date +%s)"
  tacos-demo::new-pr "$TEST_NAME"

  gha::assert-eventual-success terraform_lock "$since"

  for slice in 1 2 3; do
    if array::in "$slice" "${slices[@]}"; then
      # relevant slice is locked
      slice::assert-locked "$slice"
    else
      # irrelevant slice is not locked
      slice::assert-not-locked "$slice"
    fi
  done

  banner PASS
}


main
