# Remove Stow References from Documentation

## Why

The project migrated from Stow to Makefile-based installation in commit `f54bc7a` (October 2024), but documentation still contains 100+ references to the old Stow system.

**Current Problems:**
- [NO] Users try to run `./stow-install.sh` (script doesn't exist)
- [NO] Instructions say `brew install stow` (not needed anymore)
- [NO] Documentation references "stow-packages/" directory (removed)
- [NO] Confusion between documented and actual installation process

**Impact:**
- New users fail installation following documented instructions
- Support burden from outdated documentation
- Loss of trust in documentation accuracy

## What Changes

**Remove/Replace ALL references to:**
- "stow" and "Stow" (case-insensitive)
- "stow-packages" directory structure
- `./stow-install.sh` script
- `./install.sh --packages` command
- Stow package management sections

**Files to Update:**
- `README.md` - Remove ~200 lines of Stow content, update installation
- `docs/guides/README.md` - Remove Stow references
- `docs/guides/README.old.md` - **DELETE** (entirely Stow-based, obsolete)

**Replace with:**
- Makefile-based installation commands (`make install`)
- Current directory structure (`config/`, `scripts/`)
- Accurate installation prerequisites (no Stow)

## Impact

**Affected Files:**
- `README.md` - Major content removal and updates
- `docs/guides/README.md` - Minor updates
- `docs/guides/README.old.md` - Delete entire file

**Breaking Changes:**
- None (documentation only)

**Benefits:**
- [YES] Accurate installation instructions that work
- [YES] No confusion about non-existent scripts
- [YES] Documentation matches actual codebase
- [YES] Reduced support burden

**Risks:**
- None (documentation cleanup only)
