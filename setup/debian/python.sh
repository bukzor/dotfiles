#!/bin/bash
set -euxo pipefail
sudo apt-get install --yes \
  libc6-dev \
  clang-13 \
  llvm-13 \
  make \
  pkg-config \
  libbz2-dev \
  libffi-dev \
  libgdbm-compat-dev \
  libgdbm-dev \
  lzma \
  lzma-dev \
  liblzma-dev \
  libncurses-dev \
  libncurses5-dev \
  libreadline-dev \
  libreadline6-dev \
  libsqlite3-dev \
  libssl-dev \
  tcl8.6-dev \
  tk-dev \
  tk8.6-dev \
  uuid-dev \
  zlib1g-dev \
;

pythonsrc="$HOME/repo/cpython"
if ! [ -d "$pythonsrc"/.git ]; then
  git clone --filter=blob:none https://github.com/python/cpython 
fi
cd "$pythonsrc"
git remote update
latest_tag=$(git tag | grep -E '^v[0-9]+(\.[0-9]+)*$' | sort -rV | head -n1)
version="$(echo "$latest_tag" | tr -d v)"
dst="$HOME/prefix/python$version"

orig_path="$PATH"
export MAKEFLAGS PATH LLVM_PROFILE_FILE LLVM_PROF_FILE
MAKEFLAGS="-j $(($(nproc) * 2))"
PATH="/usr/lib/llvm-13/bin:$orig_path"
LLVM_PROFILE_FILE="code-%p.%m.profclangr"
LLVM_PROF_FILE="code-%p.%m.profclangr"

export CC CXX CPP AR
CC="$(which clang)"
CXX="$(which clang++)"
CPP="$(which clang-cpp)"
AR="$(which llvm-ar)"


git checkout "$latest_tag"
configure_opts=(
  --with-pydebug
  --with-assertions
  --with-lto=thin
  --enable-optimizations
)

# regular cpython
./configure --prefix="$dst" "${configure_opts[@]}"
make
make install
find "$dst"/bin -xtype f |
  grep -Ev '/(idle|2to3|pip)|3.11d' |
  xargs ln -sft ~/bin
ln -sf python3 -T ~/bin/python
ln -sf pydoc3 -T ~/bin/pydoc
