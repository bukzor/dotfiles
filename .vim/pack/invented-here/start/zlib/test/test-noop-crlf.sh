#!/usr/bin/env bash
set -euo pipefail

TEST_DIR="$(cd "$(dirname "$0")" && pwd)"
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

cd "$TMPDIR"

echo "=== Testing noop-save with CRLF line endings ==="

# Create file with CRLF line endings
printf "line1\r\nline2\r\nline3\r\n" > test-crlf.txt
echo "Original text file:"
od -An -tx1z test-crlf.txt

# Compress it
zlib-flate -compress < test-crlf.txt > test-crlf.zlib
cp test-crlf.zlib test-crlf.zlib.orig

echo ""
echo "Compressed file contains these byte patterns:"
xxd test-crlf.zlib | head -5

echo ""
echo "Checking for 0x0a and 0x0d bytes in compressed data:"
if xxd test-crlf.zlib | grep -E ' (0a|0d) '; then
  echo "✓ Found CR/LF bytes in compressed stream"
else
  echo "⚠ No CR/LF bytes in compressed stream"
fi

echo ""
echo "Original md5: $(md5sum test-crlf.zlib.orig | awk '{print $1}')"

# Open and save without changes
vim -u NONE -N -c "set runtimepath^=$HOME/.vim/pack/invented-here/start/zlib" \
    -c "runtime plugin/zlib.vim" \
    -c "edit ./test-crlf.zlib" \
    -c "echomsg 'Loaded: eol=' . &eol . ' ff=' . &ff" \
    -c "write" \
    -c "qall!" 2>&1 | grep -E '(Loaded:|eol=|written)'

echo ""
echo "After noop-save md5: $(md5sum test-crlf.zlib | awk '{print $1}')"

echo ""
if cmp -s test-crlf.zlib.orig test-crlf.zlib; then
  echo "✓ PASS: Files are identical after noop-save"
  exit 0
else
  echo "✗ FAIL: Files differ after noop-save"
  echo ""
  echo "Size comparison:"
  ls -l test-crlf.zlib.orig test-crlf.zlib
  echo ""
  echo "Hex diff (first 20 lines):"
  diff <(xxd test-crlf.zlib.orig) <(xxd test-crlf.zlib) | head -20
  exit 1
fi
