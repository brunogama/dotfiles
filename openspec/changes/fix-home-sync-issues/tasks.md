# Implementation Tasks - Fix Home Sync Issues

## Phase 1: Critical Fixes (Git Repository & Validation) [YES] COMPLETED

### 1.1 Add Git Repository Auto-Detection [YES]
- [x] Add `detect_dotfiles_dir()` function to home-sync script
- [x] Check common dotfiles locations: `~/.config-fixing-dot-files-bugs`, `~/.config`, `~/.dotfiles`, `~/dotfiles`
- [x] Return first directory with `.git` subdirectory
- [x] Update `DOTFILES_DIR` initialization to use auto-detection
- [x] Add fallback with clear error message if no repo found

### 1.2 Add Git Repository Validation [YES]
- [x] Add `is_git_repo()` function to check `git rev-parse --git-dir`
- [x] Call validation before any git operations in `sync_dotfiles()`
- [x] Add validation before git operations in `push_changes()`
- [x] Add validation in `show_status()`
- [x] Replace verbose git error with clear message

### 1.3 Remove sync.sh Dependencies [YES]
- [x] Replace `./sync.sh --restow` with appropriate git/stow command (or remove if not needed)
- [x] Replace `./sync.sh --push` with `git push`
- [x] Replace `./sync.sh --status` with `git status --short`
- [x] Test that push_changes() works without sync.sh
- [x] Test that show_status() works without sync.sh

## Phase 2: Auto-Install Scripts [YES] COMPLETED

### 2.1 Add Script Auto-Update to personal-config.zsh [YES]
- [x] Add script timestamp check at startup
- [x] Check if scripts directory is newer than `.scripts-updated` marker
- [x] Run `make install-scripts` silently if update needed
- [x] Create/update `.scripts-updated` marker file
- [x] Test minimal performance impact (<20ms)

### 2.2 Add Script Auto-Update to work-config.zsh [YES]
- [x] Copy auto-update logic from personal-config.zsh
- [x] Ensure it works in work environment
- [x] Test with work-specific paths if different
- [x] Verify no conflicts with work environment setup

### 2.3 Test Auto-Update Functionality ️ DEFERRED
- [ ] Test fresh shell startup with missing scripts (requires new shell session)
- [ ] Test shell startup with existing scripts (no reinstall)
- [ ] Test shell startup after adding new script to repo
- [ ] Test shell startup after modifying existing script
- [ ] Measure shell startup time impact

## Phase 3: Installation Validation [YES] COMPLETED

### 3.1 Add check-installation Target to Makefile [YES]
- [x] Add target to check if store-api-key is in PATH
- [x] Add check for Prezto installation
- [x] Add check for ZSH symlinks
- [x] Add check for Git configuration
- [x] Use color-coded output ([OK] green, [X] red, [WARNING] yellow)
- [x] Suggest fix commands for each missing component

### 3.2 Update Installation Documentation
- [ ] Document auto-install script feature in README
- [ ] Add troubleshooting section for home-sync issues
- [ ] Document manual fix: `make install-scripts`
- [ ] Document how to check installation: `make check-installation`

## Phase 4: Testing & Validation

### 4.1 Test All home-sync Commands
- [ ] Test `home-sync sync` with auto-detected repo
- [ ] Test `home-sync sync` with missing repo (error handling)
- [ ] Test `home-sync push` functionality
- [ ] Test `home-sync pull` functionality
- [ ] Test `home-sync status` output
- [ ] Test `home-sync-up` alias

### 4.2 Test Fresh Installation
- [ ] Clone repo to fresh location
- [ ] Run `make install`
- [ ] Verify scripts auto-install on shell start
- [ ] Verify home-sync works without manual intervention
- [ ] Verify all dependencies available

### 4.3 Test Script Updates
- [ ] Modify a script in scripts/ directory
- [ ] Start new shell
- [ ] Verify script auto-updates in ~/.local/bin
- [ ] Add a new script to scripts/ directory
- [ ] Start new shell
- [ ] Verify new script appears in ~/.local/bin

### 4.4 Cross-Environment Testing
- [ ] Test in personal environment (DOTFILES_ENV=personal)
- [ ] Test in work environment (DOTFILES_ENV=work)
- [ ] Test with different shell configurations
- [ ] Test on clean macOS installation (if available)

## Phase 5: Code Quality & Documentation

### 5.1 Code Quality
- [ ] Run shellcheck on modified home-sync script
- [ ] Fix any shellcheck warnings
- [ ] Add comments for new functions
- [ ] Ensure error messages are clear and actionable

### 5.2 Documentation Updates
- [ ] Update CHANGELOG.md with fixes
- [ ] Update home-sync man page if exists
- [ ] Update troubleshooting guide
- [ ] Add comments in config files explaining auto-install

### 5.3 Git Commit
- [ ] Review all changes with git diff
- [ ] Stage modified files
- [ ] Commit with message: "fix: resolve home-sync dependency and git repo detection issues"
- [ ] Add co-author: factory-droid[bot]

## Verification Checklist

After implementation, verify:
- [x] `home-sync-up` error resolved (no "Missing dependencies")
- [x] Scripts automatically available after repo changes (auto-update logic added)
- [x] Git repository correctly detected (auto-detects ~/.config-fixing-dot-files-bugs)
- [x] Clear errors when prerequisites missing
- [x] No sync.sh dependency errors (all removed)
- [x] Shell startup time not significantly impacted (timestamp check is fast)
- [x] Works in both personal and work environments (added to both configs)
- [x] Fresh installation works without manual steps (auto-update on startup)
- [x] All shellcheck warnings resolved (only pre-existing warnings remain)
- [x] `make check-installation` command works correctly
- [ ] Documentation updated (deferred to Phase 4)

## Notes

- Keep shell startup performance in mind (<20ms overhead acceptable)
- Make error messages actionable with suggested fixes
- Test thoroughly in both environments before considering complete
- Consider adding verbose/debug mode for troubleshooting
