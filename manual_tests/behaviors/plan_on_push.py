#!/bin/bash
source "$REPO_TOP/manual-tests/lib/test-environ.sh"

main() {
  base::strict-mode
  tacos-demo::clone "$TEST_NAME"

  since="$(date +%s)"
  tacos-demo::new-pr "$TEST_NAME"

  gha::assert-eventual-success terraform_plan "$since"
  gh::assert_matching_comment "Execution result of" "$since"

  # edit one or more slices (again)
  slice::edit-random

  since="$(date +%s)"
  git commit -am "test: behaviors/plan-on-push ($NOW) - more code"
  git push origin "$branch:$branch"

  gha::assert-eventual-success terraform_plan "$since"
  gh::assert_matching_comment "Execution result of" "$since"

  banner PASS
}


main
