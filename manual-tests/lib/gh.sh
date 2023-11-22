#!/sourceme/bash

gh::assert_matching_comment() {
  expected_comment="$1"
  since="$2"

  # Fetch the comments on the PR
  comments="$(gh pr view --json comments -q '.comments.[] | {body, createdAt}')"

  # Parse the comments and their creation times
  while read -r comment; do
    body="$(jq -n --argjson comment "$comment" -r '$comment.body')"
    comment_timestamp="$(jq -n --argjson comment "$comment" -r '($comment.createdAt | fromdateiso8601)')"

    if [[ "$comment_timestamp" -ge "$since" ]]; then
      if [[ "$body" == *"$expected_comment"* ]]; then
        return 0
      fi
    fi
  done <<< "$comments"

  return 1
}
