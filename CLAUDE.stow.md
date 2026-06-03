# Stow-Based Alternative Tools Management System

**Goal**: Replace the ad-hoc `~/bin/alternatives/` directory with a clean, modular stow-based system for managing alternative implementations of system tools.

## Problem Context

**Current state**: `~/bin/alternatives/` contains various tool alternatives:
- **Toolchain**: `cc`, `g++`, `ar`, `ld` (custom LLVM wrappers)
- **Editor**: `vim` → `lazyvim`
- **Package manager**: `npm` → `pnpm` (with argument transformation)
- **Applications**: `dropbox`, etc.

**Issues with current approach**:
- Hard to switch between alternative implementations
- Mixed purposes in single directory
- No clean way to activate/deactivate tool sets
- Difficult to share configurations across environments

## Solution Strategy: Stow-Based Organization

**Key Insight**: Use GNU Stow to organize alternatives by **purpose** and **implementation**, enabling clean switching.

### Architecture
1. **Tool categories**: Group related tools (toolchain, editors, package managers)
2. **Implementation variants**: Multiple alternatives per category
3. **Clean switching**: Stow manages symlink activation/deactivation

## Implementation Plan

### 1. Directory Structure
```
~/.local/alternatives/
├── toolchain-system/          # System GCC toolchain
│   └── bin/
│       ├── cc -> /usr/bin/gcc
│       ├── c++ -> /usr/bin/g++
│       ├── ar -> /usr/bin/ar
│       └── ld -> /usr/bin/ld
├── toolchain-brew-llvm/       # Custom LLVM toolchain
│   ├── bin/
│   │   ├── cc                 # From ~/bin/alternatives/g++
│   │   ├── c++                # From ~/bin/alternatives/g++
│   │   ├── ar                 # From ~/bin/alternatives/ar
│   │   └── ld                 # From ~/bin/alternatives/ld
│   └── share/
│       └── cargo-targets/
│           └── x86_64-linux-llvm.json
├── editor-system/             # System vim
│   └── bin/
│       └── vim -> /usr/bin/vim
├── editor-lazy/               # LazyVim setup
│   └── bin/
│       └── vim                # From ~/bin/alternatives/vim
├── pkgmgr-npm/               # Standard npm
│   └── bin/
│       └── npm -> /usr/bin/npm
├── pkgmgr-pnpm/              # PNPM with npm compatibility
│   └── bin/
│       └── npm                # From ~/bin/alternatives/npm
└── apps-custom/              # Custom applications
    └── bin/
        └── dropbox            # From ~/bin/alternatives/dropbox
```

### 2. Stow Integration
```bash
# Install stow
brew install stow  # or apt/pacman install stow

# Activate a toolchain
cd ~/.local/alternatives
stow -t ~/.local toolchain-system     # Host: GCC toolchain
stow -t ~/.local toolchain-brew-llvm  # Target: Pure LLVM

# Switch toolchains
stow -D toolchain-system             # Deactivate current
stow -t ~/.local toolchain-brew-llvm # Activate new
```

### 3. Management Script: `~/.local/bin/alt`
```bash
#!/bin/bash
# Alternative tools management using stow

ALT_ROOT="$HOME/.local/alternatives"
STOW_TARGET="$HOME/.local"

list_categories() {
    ls "$ALT_ROOT" | cut -d'-' -f1 | sort -u
}

list_implementations() {
    local category="$1"
    ls "$ALT_ROOT" | grep "^${category}-" | sed "s/^${category}-//"
}

case "$1" in
    --config)
        if [[ -n "$2" ]]; then
            category="$2"
        else
            echo "Available categories:"
            list_categories | sed 's/^/  /'
            echo -n "Choose category: "
            read category
        fi

        echo "Available ${category} implementations:"
        list_implementations "$category" | sed 's/^/  /'
        echo -n "Choose implementation: "
        read impl

        cd "$ALT_ROOT"
        stow -D "${category}"-* 2>/dev/null  # Remove all in category
        stow -t "$STOW_TARGET" "${category}-${impl}"
        echo "Activated: ${category}-${impl}"
        ;;
    --list)
        if [[ -n "$2" ]]; then
            list_implementations "$2"
        else
            echo "Categories:"
            for cat in $(list_categories); do
                echo "  $cat:"
                list_implementations "$cat" | sed 's/^/    /'
            done
        fi
        ;;
    --current)
        category="${2:-toolchain}"
        case "$category" in
            toolchain) readlink "$HOME/.local/bin/cc" 2>/dev/null || echo "none" ;;
            editor) readlink "$HOME/.local/bin/vim" 2>/dev/null || echo "none" ;;
            pkgmgr) readlink "$HOME/.local/bin/npm" 2>/dev/null || echo "none" ;;
            *) echo "Unknown category: $category" ;;
        esac
        ;;
    *)
        echo "Usage: alt --config [category] | --list [category] | --current [category]"
        echo "  --config   Interactive selection menu"
        echo "  --list     Show available implementations"
        echo "  --current  Show currently active implementation"
        echo ""
        echo "Categories: $(list_categories | tr '\n' ' ')"
        ;;
esac
```

### 4. Target Specification and Configuration

**Note**: Detailed target spec and cargo configuration are covered in `~/CLAUDE.rust-llvm-toolchain.md`.

The stow package should include:
- `share/cargo-targets/x86_64-linux-llvm.json` - Custom target specification
- `share/cargo-config/config.toml` - Cross-compilation cargo config

## Migration from ~/bin/alternatives/

### 1. Setup Stow Structure
```bash
# Create base directory
mkdir -p ~/.local/alternatives

# Migrate toolchain tools
mkdir -p ~/.local/alternatives/toolchain-brew-llvm/bin
mv ~/bin/alternatives/{cc,c++,gcc,g++,g++-11,gcc-11} ~/.local/alternatives/toolchain-brew-llvm/bin/
mv ~/bin/alternatives/{ar,ld} ~/.local/alternatives/toolchain-brew-llvm/bin/

# Migrate editor
mkdir -p ~/.local/alternatives/editor-lazy/bin
mv ~/bin/alternatives/vim ~/.local/alternatives/editor-lazy/bin/

# Migrate package manager
mkdir -p ~/.local/alternatives/pkgmgr-pnpm/bin
mv ~/bin/alternatives/npm ~/.local/alternatives/pkgmgr-pnpm/bin/

# Migrate custom apps
mkdir -p ~/.local/alternatives/apps-custom/bin
mv ~/bin/alternatives/dropbox ~/.local/alternatives/apps-custom/bin/
```

### 2. Create System Alternatives
```bash
# System toolchain
mkdir -p ~/.local/alternatives/toolchain-system/bin
cd ~/.local/alternatives/toolchain-system/bin
ln -s /usr/bin/gcc cc
ln -s /usr/bin/g++ c++
ln -s /usr/bin/ar ar
ln -s /usr/bin/ld ld

# System editor
mkdir -p ~/.local/alternatives/editor-system/bin
cd ~/.local/alternatives/editor-system/bin
ln -s /usr/bin/vim vim

# System package manager
mkdir -p ~/.local/alternatives/pkgmgr-npm/bin
cd ~/.local/alternatives/pkgmgr-npm/bin
ln -s /usr/bin/npm npm
```

## Usage Examples

### Basic Usage
```bash
# List all categories
alt --list

# Configure toolchain
alt --config toolchain    # Interactive menu

# Configure editor
alt --config editor       # Choose between system/lazy

# Check what's active
alt --current toolchain
alt --current editor
```

### Development Workflows

**LLVM Development**:
```bash
alt --config toolchain    # Choose: brew-llvm
alt --config editor       # Choose: lazy
cargo build                # Uses LLVM toolchain
```

**System Development**:
```bash
alt --config toolchain    # Choose: system
alt --config editor       # Choose: system
make                       # Uses system GCC
```

**Web Development**:
```bash
alt --config pkgmgr       # Choose: pnpm
npm install                # Actually runs pnpm
```

## Benefits

1. **Clean organization**: Tools grouped by purpose, not mixed together
2. **Easy switching**: Change entire tool categories with one command
3. **Standard tooling**: Uses established GNU stow + familiar update-alternatives interface
4. **Modular**: Easy to add new tool variants or categories
5. **Portable**: Works across distros, no system modification required
6. **Reversible**: Always can go back to system defaults
7. **Shareable**: Stow packages can be version controlled and shared

## Advanced Features

### Profile Management
```bash
# Create development profiles
mkdir -p ~/.local/alternatives/profile-rust-dev/
echo "toolchain-brew-llvm editor-lazy pkgmgr-pnpm" > ~/.local/alternatives/profile-rust-dev/tools

# Activate a complete profile
alt --profile rust-dev  # Activates all tools in profile
```

### Environment Isolation
```bash
# Project-specific alternatives
cd my-project
echo "toolchain-system editor-system pkgmgr-npm" > .alt-profile
alt --project            # Reads .alt-profile and activates
```

## Tool Categories

### Toolchain (`toolchain-*`)
- **system**: System GCC/binutils
- **brew-llvm**: Custom LLVM toolchain (see `~/CLAUDE.rust-llvm-toolchain.md`)
- **llvm-system**: System LLVM packages

### Editor (`editor-*`)
- **system**: System vim/nvim
- **lazy**: LazyVim configuration
- **minimal**: Minimal vim setup

### Package Manager (`pkgmgr-*`)
- **npm**: Standard npm
- **pnpm**: PNPM with npm compatibility layer
- **yarn**: Yarn with npm compatibility

### Applications (`apps-*`)
- **custom**: User-specific applications
- **minimal**: Lightweight alternatives

## Migration Checklist

- [ ] Install GNU stow: `brew install stow`
- [ ] Create `~/.local/alternatives/` structure
- [ ] Migrate tools from `~/bin/alternatives/`
- [ ] Create system alternative packages
- [ ] Implement `alt` management script
- [ ] Test tool switching functionality
- [ ] Update PATH to include `~/.local/bin`
- [ ] Remove old `~/bin/alternatives/` (backup first!)
- [ ] Document any custom tool configurations

---
**Related**:
- See `~/CLAUDE.rust-llvm-toolchain.md` for toolchain-specific technical details
- See `~/claude/research.config-templating/hello/CLAUDE.md` for the investigation background