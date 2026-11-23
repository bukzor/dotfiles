#!/bin/bash
# Build the Ruby that ~/bin/brew runs homebrew under. Homebrew's portable ruby
# is glibc-only, and apk's ruby lags homebrew's requirement.
# Bump to match /opt/homebrew/Homebrew/Library/Homebrew/.ruby-version;
# checksums: https://cache.ruby-lang.org/pub/ruby/index.txt
set -euo pipefail
shopt -s failglob
export DEBUG="${DEBUG:-0}"

onerror() {
  error="$?"
  echo >&2 "ERROR($error)"
  exit "$error"
}
trap onerror ERR

RUBY_VERSION=4.0.10
RUBY_SHA256=1537f7a6003c436546ecab6b48b6e7725a9af2328f45a8af7f42f41c5df90ab8
PREFIX="$HOME/prefix/homebrew-ruby"
BUILD="$PREFIX.build"

if (( DEBUG > 0 )); then
  set -x
fi

sudo apk add \
  build-base \
  gdbm-dev \
  libffi-dev \
  linux-headers \
  ncurses-dev \
  openssl-dev \
  readline-dev \
  yaml-dev \
  zlib-dev \
;

mkdir -p "$BUILD"
cd "$BUILD"
curl -fsSLo ruby.tar.xz "https://cache.ruby-lang.org/pub/ruby/${RUBY_VERSION%.*}/ruby-$RUBY_VERSION.tar.xz"
echo "$RUBY_SHA256 *ruby.tar.xz" | sha256sum --check --strict
tar -xJf ruby.tar.xz --strip-components=1
./configure --prefix="$PREFIX" --disable-install-doc
make -j"$(nproc)"
make install
cd /
rm -r "$BUILD"

"$PREFIX/bin/ruby" --version
