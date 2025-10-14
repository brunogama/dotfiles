# Code Review: Edge Cases and Issues Found

## Critical Issues

### 1. Missing/Broken Shebangs
**Files affected:**
- `scripts/core/branches-current-branch` - NO SHEBANG
- `scripts/core/e` - NO SHEBANG
- `scripts/core/p` - NO SHEBANG  
- `scripts/core/r` - NO SHEBANG
- `scripts/git/git-add-only-changed-today.sh` - TYPO: `#!/usr/bin env bash` (missing `/`)

**Impact:** Scripts won't execute correctly when called directly
**Fix:** Add proper shebangs

### 2. Makefile Path Quoting
**Issue:** Variables not quoted, will break with spaces in paths
**Lines:** Multiple (HOME_DIR, CONFIG_DIR, etc.)
**Fix:** Quote all variable expansions: `"$(VAR)"`

### 3. Script Installation Name Conflicts
**Issue:** `make install-scripts` flattens all scripts to ~/.local/bin
- Could have conflicts (e.g., scripts/git/cm vs scripts/core/cm)
- Loses organizational structure

**Fix:** Either:
- Keep directory structure with subdirs
- Add prefixes (git-cm, core-cm)
- Check for conflicts before linking

### 4. Unlink Target Danger
**Issue:** `find ~/.local/bin -type l -exec rm` removes ALL symlinks
- Could delete user's own symlinks
- No check if they're from dotfiles

**Fix:** Only remove symlinks pointing to SCRIPTS_DIR

## Medium Priority Issues

### 5. Backup Error Masking
**Makefile backup target:**
```makefile
@test -f $(HOME_DIR)/.zshrc && cp ... || true
```
**Issue:** `|| true` masks copy errors
**Fix:** Check if backup succeeded

### 6. No Rollback on Failure
**install script:**
- If installation fails midway, system is inconsistent
- No cleanup or restoration

**Fix:** Add error trap with rollback

### 7. chsh Without Error Handling
**install script:**
```bash
chsh -s "$(which zsh)"
```
**Issue:** 
- Requires password (interactive)
- Could fail if user lacks permission
- No check if `which zsh` is empty

**Fix:** Add error handling and verification

### 8. PATH Not Verified
**Issue:** Scripts installed to ~/.local/bin but no check if it's in PATH
**Fix:** Warn user or add to shell rc files

### 9. Prezto Clone No Error Handling
**Makefile:**
```makefile
git clone --recursive https://github.com/sorin-ionescu/prezto.git ...
```
**Issue:** No check for:
- Network failure
- Git not installed
- Clone permission denied

**Fix:** Add error checking

### 10. dump-macos Not Checked
**Makefile dump-macos target:**
```makefile
@$(SCRIPTS_DIR)/macos/dump-macos-settings ...
```
**Issue:** Doesn't check if script exists or is executable
**Fix:** Add verification

## Low Priority Issues

### 11. Binary File in Scripts
**File:** `scripts/core/createproject` (119KB binary)
**Issue:** Should binaries be in scripts/? Consider bin/ or libexec/
**Fix:** Document or relocate

### 12. Inconsistent Shebang Styles
**Mix of:**
- `#!/bin/bash`
- `#!/usr/bin/env bash`
- `#!/usr/bin env bash` (BROKEN)

**Fix:** Standardize on `#!/usr/bin/env bash` (more portable)

### 13. set -e in Makefile Recipes
**Issue:** Makefile uses `@` prefix which hides errors
**Fix:** Consider adding error checking or removing @

### 14. Timestamp Generation
**Makefile:**
```makefile
BACKUP_DIR := $(HOME)/.dotfiles-backup-$(shell date ...)
```
**Issue:** Evaluated at parse time, not runtime
- Multiple backups in same session use same timestamp
- Could cause overwrites

**Fix:** Generate timestamp per backup operation

### 15. clean Target Too Aggressive
**Makefile:**
```makefile
find $(HOME_DIR) -maxdepth 1 -name ".dotfiles-backup-*" -type d -mtime +30 -exec rm -rf {} \;
```
**Issue:** Silently deletes all 30+ day old backups
**Fix:** Add confirmation or list first

## Recommended Fixes Priority

1. **CRITICAL** - Fix shebangs (can't execute scripts)
2. **CRITICAL** - Fix Makefile path quoting
3. **HIGH** - Fix unlink to only remove dotfiles symlinks
4. **HIGH** - Add error handling to Prezto setup
5. **MEDIUM** - Add rollback to install script
6. **MEDIUM** - Fix PATH verification
7. **LOW** - Standardize shebangs
8. **LOW** - Add timestamp fix for backups
