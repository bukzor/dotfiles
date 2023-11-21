#!/sourceme/bash

gha::get-check() {
  # get the most recent run of the named check
  check_name="$1"
  gh pr status \
    --json statusCheckRollup \
    --jq '# TODO: where are these fields documented??
        .currentBranch.statusCheckRollup[]
      | select(.name == "'"$check_name"'")
    ' \
  ;
}

gha::assert-ran() {
  # success if a specified github-actions job ran
  check_name="$1"
  since="$2"
  check="$(gha::get-check "$check_name")"
  success="$(jq \
    <<< "$check" \
    --argjson since "$since" \
    ' select( .completedAt > "0001-01-01T00:00:00Z")
    | .completedAt
    | fromdateiso8601 > $since
    '
  )"
  test "$success" = "true"
}

gha::assert-success() {
  # success if a specified github-actions job ran
  check_name="$1"
  check="$(gha::get-check "$check_name")"
  conclusion="$(
    jq <<< "$check" '.conclusion' --raw-output
  )"
  test "$conclusion" = "SUCCESS"
}
