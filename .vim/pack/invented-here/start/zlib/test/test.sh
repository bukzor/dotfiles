#!/usr/bin/env bash
set -euo pipefail

TEST_DIR="$(cd "$(dirname "$0")" && pwd)"
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

cd "$TMPDIR"

# Create clean test fixtures
printf "line1\nline2\nline3\n" > test-with-eol.txt
printf "line1\nline2\nline3" > test-without-eol.txt
zlib-flate -compress < test-with-eol.txt > test-with-eol.zlib
zlib-flate -compress < test-without-eol.txt > test-without-eol.zlib

# Test file WITH eol
echo ""
echo "=== Testing test-with-eol.zlib ==="
vim -u NONE -N -S "$TEST_DIR/test-with-eol.vim" 2>&1 | grep -E '(eol=|converted|noeol|written)'

echo "Hex dump (should end with 0a):"
zlib-flate -uncompress < test-with-eol.zlib | od -An -tx1z | tail -1

# Test file WITHOUT eol
echo ""
echo "=== Testing test-without-eol.zlib ==="
vim -u NONE -N -S "$TEST_DIR/test-without-eol.vim" 2>&1 | grep -E '(eol=|converted|noeol|written)'

echo "Hex dump (should end with 33, no trailing newline):"
zlib-flate -uncompress < test-without-eol.zlib | od -An -tx1z | tail -1
