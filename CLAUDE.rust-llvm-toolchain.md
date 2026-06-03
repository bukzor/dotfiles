# Building a Pure LLVM Rust Toolchain

**Goal**: Create a complete pure LLVM Rust cross-compilation target that eliminates all GCC dependencies from final binaries.

**Prerequisites**: Stow-based toolchain management system (see `~/CLAUDE.stow.md`)

## Overview

With the stow system handling toolchain switching, this document covers building the actual LLVM-only Rust target specification and validation process.

## Component Requirements

### 1. Custom Target Specification

**Purpose**: Define a Rust target that uses pure LLVM runtime instead of GCC runtime.

**Key differences from `x86_64-unknown-linux-gnu`**:
- `"rtlib": "compiler-rt"` instead of linking libgcc
- `"unwindlib": "libunwind"` instead of libgcc_s
- Explicit library search paths for LLVM libraries
- Modified link arguments to avoid GCC-specific flags

### 2. Linker Wrapper Enhancement

**Current wrapper** (`~/bin/alternatives/cc`) needs modifications:
- ✅ Already sets `--rtlib=compiler-rt`
- ✅ Already has correct GCC installation path
- ❌ **Remove** the `-L"/opt/homebrew/opt/gcc/lib/gcc/current"` workaround
- ➕ **Add** explicit LLVM library paths
- ➕ **Add** validation that no GCC libraries are linked

### 3. Build Validation Suite

**Critical**: Comprehensive testing to ensure pure LLVM compilation.

## Implementation Details

### Target Specification: `x86_64-linux-llvm.json`

```json
{
  "arch": "x86_64",
  "cpu": "x86-64",
  "crt-static-respected": true,
  "data-layout": "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128",
  "dynamic-linking": true,
  "env": "gnu",
  "has-rpath": true,
  "has-thread-local": true,
  "llvm-target": "x86_64-unknown-linux-gnu",
  "max-atomic-width": 64,
  "os": "linux",
  "plt-by-default": false,
  "position-independent-executables": true,

  "pre-link-args": {
    "gcc": [
      "-m64",
      "-rtlib=compiler-rt",
      "--unwindlib=libunwind",
      "-L/opt/homebrew/opt/llvm/lib"
    ]
  },

  "post-link-args": {
    "gcc": [
      "-Wl,--as-needed",
      "-Wl,--gc-sections"
    ]
  },

  "late-link-args": {
    "gcc": [
      "-lunwind",
      "-lpthread",
      "-lc",
      "-lm",
      "-ldl"
    ]
  },

  "relro-level": "full",
  "stack-probes": {
    "kind": "inline-or-call",
    "min-llvm-version-for-inline": [16, 0, 0]
  },
  "static-position-independent-executables": true,
  "supported-sanitizers": [
    "address", "cfi", "leak", "memory", "thread", "safestack"
  ],
  "supported-split-debuginfo": ["packed", "unpacked", "off"],
  "supports-xray": true,
  "target-family": ["unix"],
  "target-pointer-width": "64"
}
```

### Enhanced Linker Wrapper

**Modifications to the cc wrapper**:

```bash
#!/bin/bash
# Enhanced LLVM-only cc wrapper
set -eEuo pipefail

BREW=/opt/homebrew
LINUXBREW=/home/linuxbrew/.linuxbrew
CLANG_XX=$(ls "$BREW/opt/llvm/lib/clang/")

# Validation mode - check for GCC dependencies
VALIDATE_LLVM_ONLY=${VALIDATE_LLVM_ONLY:-false}

# ... existing sysroot setup ...

config=(
  --start-no-unused-arguments

  # Pure LLVM configuration
  --sysroot="$BREW"
  -rtlib=compiler-rt
  --unwindlib=libunwind
  --gcc-install-dir="$BREW/opt/gcc/lib/gcc/current/gcc/x86_64-pc-linux-gnu/15"

  # Linking configuration
  -Wl,--dynamic-linker="$BREW/lib/ld.so"
  -Wl,--rpath="$BREW"/lib

  # Include paths
  -nostdinc
  -I"$BREW/lib/clang/$CLANG_XX/include"
  -I"$BREW/include"

  # Library and object paths
  -B"$BREW/lib"
  -L"$BREW/lib"
  -L"$BREW/opt/llvm/lib"

  # NOTE: Deliberately NOT including GCC lib path:
  # -L"$BREW/opt/gcc/lib/gcc/current"
)

# Validation: Check if we're trying to link libgcc_s
if [[ "$VALIDATE_LLVM_ONLY" == "true" ]]; then
  for arg in "$@"; do
    if [[ "$arg" == "-lgcc_s" ]]; then
      echo "ERROR: Attempted to link libgcc_s in LLVM-only mode" >&2
      echo "Arguments: $*" >&2
      exit 1
    fi
  done
fi

# ... rest of wrapper ...
exec clang-$CLANG_XX "${config[@]}" "$@"
```

### Cargo Configuration

**For cross-compilation projects**:

```toml
# .cargo/config.toml
[build]
target = "x86_64-linux-llvm"

[unstable]
build-std = ["std", "panic_abort"]
build-std-features = ["llvm-libunwind"]

[target.x86_64-linux-llvm]
rustflags = [
  "--cfg", "feature=\"llvm-libunwind\"",
  "-C", "target-feature=+crt-static"  # Optional: static linking
]

# Validation environment
[env]
VALIDATE_LLVM_ONLY = "true"
```

## Testing & Validation

### 1. Dependency Analysis

**Test script**: `validate-llvm-binary.sh`
```bash
#!/bin/bash
# Validate that a binary uses only LLVM/system libraries

BINARY="$1"
if [[ ! -f "$BINARY" ]]; then
  echo "Usage: $0 <binary>"
  exit 1
fi

echo "=== Analyzing binary: $BINARY ==="

# Check dynamic dependencies
echo "Dynamic dependencies:"
ldd "$BINARY" | tee /tmp/deps.txt

# Look for problematic dependencies
echo -e "\n=== Validation ==="
if grep -q "libgcc_s" /tmp/deps.txt; then
  echo "❌ FAIL: Found libgcc_s dependency"
  exit 1
fi

if grep -q "libstdc++" /tmp/deps.txt; then
  echo "❌ FAIL: Found libstdc++ dependency"
  exit 1
fi

# Check for expected LLVM libraries
if grep -q "libunwind" /tmp/deps.txt; then
  echo "✅ PASS: Using libunwind"
else
  echo "⚠️  WARNING: No libunwind found (might be statically linked)"
fi

# Verify libc source
if grep -q "/opt/homebrew" /tmp/deps.txt; then
  echo "✅ PASS: Using homebrew libc"
else
  echo "❌ FAIL: Not using homebrew libc"
  exit 1
fi

echo "✅ PASS: Binary validates as LLVM-only"
```

### 2. Compilation Test Suite

**Test different Rust features**:

```rust
// tests/llvm-validation/src/main.rs
fn main() {
    println!("=== LLVM-only Binary Test ===");

    // Test unwinding
    test_panic_catch();

    // Test threading
    test_threading();

    // Test heap allocation
    test_allocation();

    // Test standard library
    test_std_features();

    println!("All tests passed!");
}

fn test_panic_catch() {
    use std::panic;

    let result = panic::catch_unwind(|| {
        panic!("Test panic");
    });

    assert!(result.is_err());
    println!("✅ Panic/unwind test passed");
}

fn test_threading() {
    use std::thread;

    let handle = thread::spawn(|| {
        42
    });

    let result = handle.join().unwrap();
    assert_eq!(result, 42);
    println!("✅ Threading test passed");
}

fn test_allocation() {
    let vec: Vec<i32> = (0..1000).collect();
    assert_eq!(vec.len(), 1000);
    println!("✅ Allocation test passed");
}

fn test_std_features() {
    use std::collections::HashMap;

    let mut map = HashMap::new();
    map.insert("key", "value");
    assert_eq!(map.get("key"), Some(&"value"));
    println!("✅ Standard library test passed");
}
```

**Cargo.toml for test**:
```toml
[package]
name = "llvm-validation"
version = "0.1.0"
edition = "2021"

[[bin]]
name = "test-unwinding"
path = "src/main.rs"

[[bin]]
name = "test-static"
path = "src/main.rs"

[profile.release]
panic = "unwind"  # Test unwinding explicitly

[profile.test-static]
inherits = "release"
panic = "abort"   # Test static linking
```

### 3. Build Process Validation

**Complete test workflow**:

```bash
#!/bin/bash
# complete-llvm-test.sh

set -eEuo pipefail

echo "=== LLVM-only Rust Toolchain Validation ==="

# 1. Setup
echo "1. Setting up toolchain..."
cd ~/.local/alternatives
stow -D toolchain-* 2>/dev/null || true
stow -t ~/.local toolchain-brew-llvm
export VALIDATE_LLVM_ONLY=true

# 2. Build test project
echo "2. Building test project..."
cd ~/test-llvm-rust
cargo +nightly clean
cargo +nightly build --target x86_64-linux-llvm --release

# 3. Validate binary
echo "3. Validating binary..."
./validate-llvm-binary.sh target/x86_64-linux-llvm/release/llvm-validation

# 4. Runtime test
echo "4. Runtime testing..."
target/x86_64-linux-llvm/release/llvm-validation

# 5. Standard library verification
echo "5. Verifying standard library..."
cargo +nightly build --target x86_64-linux-llvm --unit-graph | \
  jq '.units[] | select(.pkg_id | test("(std|unwind)")) | {pkg_id, features}' | \
  grep -q "llvm-libunwind" || {
    echo "❌ FAIL: std not built with llvm-libunwind"
    exit 1
  }

echo "✅ SUCCESS: LLVM-only toolchain fully validated!"
```

## Known Limitations & Edge Cases

### 1. C++ Interop
- **Issue**: C++ code may still require libstdc++
- **Solution**: Use libc++ instead, or isolate C++ to separate compilation units

### 2. Third-party Dependencies
- **Issue**: Crates with C dependencies may link system libraries
- **Solution**: Audit dependencies, prefer pure-Rust alternatives

### 3. Proc Macros
- **Issue**: Proc macros are host executables, use system toolchain
- **Impact**: Not a problem - they don't affect final binary

### 4. Build Scripts with Native Code
- **Issue**: Build scripts that compile C code may use system toolchain
- **Solution**: Cross-compilation approach handles this correctly

## Success Criteria

A successful LLVM-only toolchain should produce binaries that:

1. ✅ **No libgcc_s dependencies**: `ldd binary | grep -v libgcc_s`
2. ✅ **Use LLVM unwind**: Links libunwind instead of libgcc_s
3. ✅ **Use homebrew libc**: All system libraries from /opt/homebrew
4. ✅ **Runtime functional**: All std library features work correctly
5. ✅ **Unwinding works**: Panic/catch_unwind functions properly
6. ✅ **Thread-safe**: Threading and synchronization work
7. ✅ **Performance**: No significant performance regression vs GCC build

## Troubleshooting

### Common Issues

**"cannot find library -lgcc_s"**
- Check that wrapper doesn't include GCC lib path
- Verify VALIDATE_LLVM_ONLY catches this case
- Ensure build-std is working properly

**"undefined symbol: _Unwind_*"**
- Verify libunwind is linked
- Check target spec has correct unwindlib setting
- Ensure LLVM libunwind is available

**Runtime crashes in unwinding**
- Test panic handling specifically
- Verify same unwind library used throughout
- Check for mixed LLVM/GCC object files

---
**Related**:
- See `~/CLAUDE.stow.md` for toolchain management setup
- See `~/claude/research.config-templating/hello/CLAUDE.md` for background investigation