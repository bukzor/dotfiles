from lib import sh
from lib import wait
from lib.functions import now

from manual_tests.lib import gha

# FIXME: use a more specific type than str for URL
URL = str

### gh::assert_matching_comment() {
###   expected_comment="$1"
###   since="$2"
###
###   # Fetch the comments on the PR
###   comments="$(gh pr view --json comments -q '.comments.[] | {body, createdAt}')"
###
###   # Parse the comments and their creation times
###   while read -r comment; do
###     body="$(jq -n --argjson comment "$comment" -r '$comment.body')"
###     comment_timestamp="$(jq -n --argjson comment "$comment" -r '($comment.createdAt | fromdateiso8601)')"
###
###     if [[ "$comment_timestamp" -ge "$since" ]]; then
###       if [[ "$body" == *"$expected_comment"* ]]; then
###         return 0
###       fi
###     fi
###   done <<< "$comments"
###
###   return 1
### }


def open_pr(branch: str) -> str:
    return sh.stdout(("gh", "pr", "create", "--fill-first", "--head", branch))


def close_pr(pr_url: URL):
    sh.banner("cleaning up:")
    since = now()

    if sh.success(("gh", "pr", "edit", "--add-label", ":taco::unlock")):
        sh.banner("waiting for unlock...")
        wait.for_(lambda: gha.assert_ran("terraform_unlock", since))
        sh.banner("unlocked.")

    sh.banner("deleting branch:")
    sh.run(
        ("gh", "pr", "close", "--comment", "test cleanup", "--delete-branch", pr_url)
    )
