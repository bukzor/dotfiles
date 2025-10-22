#!/bin/sh
set -eEuo pipefail
HERE="$(cd "$(dirname "$0")"; pwd)"

set -x
export _PYTHON_HOST_PLATFORM=1
export CC='gcc --sysroot=/opt/homebrew'
export PATH="$HERE/toolchain:$PATH"
pyenv install -vvv --skip-existing
