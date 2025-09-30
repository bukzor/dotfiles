# XDG-Compliant Alternatives Management

This directory contains GNU Stow packages for managing alternative implementations of system tools using the XDG Base Directory Specification.

## Directory Structure

### Two-Level Organization

**First Level**: Categories of alternatives
- `vi/` - Text editors
- `cc-toolchain/` - C/C++ compilation toolchains
- `gzip/` - Compression tools
- `npm/` - Package managers

**Second Level**: Specific alternative implementations within each category
- `vi/nvim/` - Neovim editor configuration
- `vi/system/` - System vim
- `cc-toolchain/system/` - System GCC toolchain
- `cc-toolchain/brew-llvm/` - Custom LLVM toolchain
- `gzip/pigz/` - Parallel gzip implementation
- `npm/pnpm/` - PNPM with npm compatibility layer

## Usage with GNU Stow

```bash
# Navigate to alternatives directory
cd ~/.local/share/alternatives

# Activate a specific alternative
stow -t ~/.local cc-toolchain/system

# Switch alternatives (deactivate current, activate new)
stow -D cc-toolchain/system
stow -t ~/.local cc-toolchain/brew-llvm

# List what's currently stowed
stow -t ~/.local --verbose=2 cc-toolchain/system 2>&1 | grep "LINK:"
```

## Package Structure

Each alternative package should follow this structure:
```
category/implementation/
├── bin/           # Executable binaries/scripts
├── share/         # Shared data files
└── etc/           # Configuration files (if needed)
```

## Benefits

- **XDG Compliant**: Follows standard directory conventions
- **Clean Organization**: Tools grouped by purpose, implementations by name
- **Easy Switching**: Standard GNU stow commands
- **Modular**: Add new categories and implementations easily
- **Reversible**: Always can return to system defaults