#!/usr/bin/env bash
set -euo pipefail

TEST_DIR="$(cd "$(dirname "$0")" && pwd)"
TMPDIR=$(mktemp -d)
trap "rm -r $TMPDIR" EXIT

cd "$TMPDIR"

echo "=== Testing that non-zlib files starting with 0x78 are left alone ==="

# 'x-anthropic' starts with 0x78 — the zlib CMF byte
printf 'x-anthropic-billing\nsome header data\n' > false-positive.dat
cp false-positive.dat false-positive.dat.orig

echo ""
echo "File starts with 0x78 ('x'):"
xxd false-positive.dat | sed -n '1p'

# Open in vim, save, quit — plugin should ignore this file
vim -u NONE -N \
    -c "set runtimepath^=$HOME/.vim/pack/invented-here/start/zlib" \
    -c "runtime plugin/zlib.vim" \
    -c "edit ./false-positive.dat" \
    -c "write" \
    -c "qall!" 2>&1

echo ""
if cmp -s false-positive.dat.orig false-positive.dat; then
  echo "✓ PASS: File unchanged — plugin correctly ignored non-zlib file"
  exit 0
else
  echo "✗ FAIL: File was modified"
  diff <(xxd false-positive.dat.orig) <(xxd false-positive.dat)
  exit 1
fi
