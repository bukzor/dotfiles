#!/sourceme/bash
# shared boilerplate/prelude for manual-tests; no functions here, please
source "$REPO_TOP/lib/base.sh"

# NB: aliases must be defined before their call-site is *parsed*
shopt -s expand_aliases
alias banner=': "'$'\033[92;1m'"=======> "$'\033[m'\"
export DEBUG=1
# otherwise `gh` sees $DEBUG and becomes verbose
export GH_DEBUG=

# slightly more readable xtrace log
PS4="+ \033[36;1m$\033[m "

# `onexit` to by (re)defined by tests
onexit() { : onexit noop; }
trap onexit EXIT

source "$REPO_TOP/lib/array.sh"
source "$REPO_TOP/lib/wait.sh"
source "$REPO_TOP/manual-tests/lib/slice.sh"
source "$REPO_TOP/manual-tests/lib/gha.sh"
source "$REPO_TOP/manual-tests/lib/gh.sh"
source "$REPO_TOP/manual-tests/lib/tacos-demo.sh"

HERE="$(cd "$(dirname "$0")"; pwd)"
SCRIPT="$HERE/$(basename "$0")"
TEST_NAME="$(sed 's@'"$REPO_TOP"'/@@; s@\.sh$@@' <<< "$SCRIPT")"

# trivial usage, for debug (and shellcheck)
: TEST_NAME: "$TEST_NAME"
