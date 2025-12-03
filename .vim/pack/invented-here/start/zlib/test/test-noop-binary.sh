#!/usr/bin/env bash
set -euo pipefail

TEST_DIR="$(cd "$(dirname "$0")" && pwd)"
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

cd "$TMPDIR"

echo "=== Testing noop-save with git object (guaranteed to have 0x0a in compressed) ==="

# Create a git object similar to what caused the original corruption
# Git commit objects have this format: "commit <size>\0<content>"
cat > test-commit.txt <<'EOF'
tree 4b825dc642cb6eb9a060e54bf8d69288fbee4904
author Test User <test@example.com> 1234567890 +0000
committer Test User <test@example.com> 1234567890 +0000

(empty)
EOF

# Add git object header
SIZE=$(wc -c < test-commit.txt)
printf "commit %d\0" "$SIZE" > test-git-object.bin
cat test-commit.txt >> test-git-object.bin

# Compress it with zlib
zlib-flate -compress < test-git-object.bin > test-git-object.zlib
cp test-git-object.zlib test-git-object.zlib.orig

echo ""
echo "Compressed git object size: $(wc -c < test-git-object.zlib) bytes"
echo ""
echo "Checking for 0x0a bytes in compressed data:"
COUNT=$(xxd test-git-object.zlib | grep -c ' 0a ' || true)
echo "Found $COUNT occurrences of 0x0a in compressed stream"

if [ "$COUNT" -gt 0 ]; then
  echo "✓ Good test case - has 0x0a bytes in compressed data"
  xxd test-git-object.zlib | grep ' 0a ' | head -3
else
  echo "⚠ Warning: No 0x0a bytes found"
fi

echo ""
echo "Original md5: $(md5sum test-git-object.zlib.orig | awk '{print $1}')"

# Open and save without changes
vim -u NONE -N -c "set runtimepath^=$HOME/.vim/pack/invented-here/start/zlib" \
    -c "runtime plugin/zlib.vim" \
    -c "edit ./test-git-object.zlib" \
    -c "write" \
    -c "qall!" 2>&1 | grep -E '(written|zlib:)' || true

echo ""
echo "After noop-save md5: $(md5sum test-git-object.zlib | awk '{print $1}')"
echo "Size after: $(wc -c < test-git-object.zlib) bytes"

echo ""
if cmp -s test-git-object.zlib.orig test-git-object.zlib; then
  echo "✓ PASS: Files are identical after noop-save"
  exit 0
else
  echo "✗ FAIL: Binary corruption detected after noop-save"
  echo ""
  echo "Size comparison:"
  echo "  Before: $(wc -c < test-git-object.zlib.orig) bytes"
  echo "  After:  $(wc -c < test-git-object.zlib) bytes"
  echo ""

  # Check if the saved file is even valid zlib
  if zlib-flate -uncompress < test-git-object.zlib > /dev/null 2>&1; then
    echo "✓ File is still valid zlib (but different bytes)"
  else
    echo "✗ File is CORRUPTED - invalid zlib stream"
  fi

  echo ""
  echo "Hex diff:"
  diff -u <(xxd test-git-object.zlib.orig) <(xxd test-git-object.zlib) | head -40

  exit 1
fi
