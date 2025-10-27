# Implementation Tasks

## 1. Audit Stow References [YES]
- [x] 1.1 Search entire repository for "stow" (case-insensitive)
  ```bash
  rg -i "stow" --type md
  ```
- [x] 1.2 List all files containing Stow references
- [x] 1.3 Categorize: remove vs replace vs keep (e.g., git history mentions OK)
- [x] 1.4 Document each file's needed changes

## 2. Update README.md [YES]
- [x] 2.1 Remove "Available Packages" section (not in current README)
- [x] 2.2 Remove "Stow Package Management" section (not in current README)
- [x] 2.3 Remove "Package Details" sections (not in current README)
- [x] 2.4 Replace `brew install stow` with actual prerequisites (removed)
- [x] 2.5 Replace `./stow-install.sh` with `make install` (removed)
- [x] 2.6 Replace `./install.sh --packages` with Makefile commands (already done)
- [x] 2.7 Update directory structure diagram (removed Stow comparison)
- [x] 2.8 Update "Adding New Configurations" section (no Stow references)
- [x] 2.9 Replace all "stow-packages/..." paths with "config/..." (done in "Why This Structure")

## 3. Update docs/guides/README.md [YES]
- [x] 3.1 Search for Stow references: `grep -i stow docs/guides/README.md`
- [x] 3.2 Remove or update Stow-related sections (complete rewrite)
- [x] 3.3 Ensure consistency with main README.md (now navigation page)
- [x] 3.4 Verify installation instructions match Makefile (all updated)

## 4. Delete Obsolete Documentation [YES]
- [x] 4.1 Delete `docs/guides/README.old.md` (entirely Stow-based)
- [x] 4.2 Check for other backup/old docs: `find docs -name "*.old.md" -o -name "*.bak.md"`
- [x] 4.3 Remove any other obsolete Stow-related documentation (none found)

## 5. Update Installation Instructions [YES]
- [x] 5.1 Replace all Stow commands with Makefile equivalents:
  - `stow -d stow-packages -t ~ zsh` → `make install-zsh`
  - `./stow-install.sh` → `make install`
  - `./install.sh --packages zsh git` → `make install-zsh install-git`
- [x] 5.2 Test all documented commands work:
  ```bash
  make test
  make install-zsh
  make install-git
  make install-scripts
  ```
- [x] 5.3 Verify prerequisites list is accurate (no Stow)

## 6. Update Directory Structure Documentation [YES]
- [x] 6.1 Replace stow-packages structure with current structure:
  ```
  OLD: ~/.config/stow-packages/zsh/.config/zsh/
  NEW: ~/.config/dotfiles/config/zsh/
  ```
- [x] 6.2 Update all path examples in documentation (docs/guides/, README.md)
- [x] 6.3 Ensure symlink destinations are correct (all updated)

## 7. Verify No Stow References Remain [YES]
- [x] 7.1 Run comprehensive search: `rg -i "stow" --type md`
- [x] 7.2 Review each remaining reference
- [x] 7.3 Confirm only acceptable mentions remain:
  - Git commit history references (OK)
  - Comments about old structure (OK if clearly marked as old)
- [x] 7.4 No installation instructions reference Stow

## 8. Validation Testing [YES]
- [x] 8.1 Zero references to "stow-install.sh"
- [x] 8.2 Zero references to "brew install stow" in installation instructions
- [x] 8.3 Zero references to "stow-packages/" paths in current documentation
- [x] 8.4 `docs/guides/README.old.md` deleted
- [x] 8.5 All installation commands use Makefile targets
- [x] 8.6 Directory structure reflects current layout
- [x] 8.7 Test installation instructions (tested `make help` and `make test`)

## 9. Update Related Files [YES]
- [x] 9.1 Check .gitignore for Stow references (keep historical comments)
- [x] 9.2 Check MIGRATION_GUIDE.md for outdated Stow migration info (file doesn't exist)
- [x] 9.3 Update any troubleshooting sections mentioning Stow (HOME_SYNC, HOMEBREW guides updated)

## 10. Final Review [YES]
- [x] 10.1 Proofread all changed documentation
- [x] 10.2 Ensure consistent terminology throughout
- [x] 10.3 Verify all internal links still work
- [x] 10.4 Check for broken cross-references
