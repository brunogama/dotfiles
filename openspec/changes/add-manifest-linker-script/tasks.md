# Implementation Tasks

## 1. Script Structure
- [ ] 1.1 Create `bin/core/link-dotfiles` file
- [ ] 1.2 Add shebang and set -euo pipefail
- [ ] 1.3 Add color constants for output
- [ ] 1.4 Add usage/help function
- [ ] 1.5 Add version information

## 2. Argument Parsing
- [ ] 2.1 Parse --dry-run flag (default mode)
- [ ] 2.2 Parse --apply flag
- [ ] 2.3 Parse --force flag
- [ ] 2.4 Parse --yes flag
- [ ] 2.5 Parse --verbose flag
- [ ] 2.6 Parse --help flag
- [ ] 2.7 Validate flag combinations

## 3. Prerequisite Checks
- [ ] 3.1 Check if jq is installed
- [ ] 3.2 Check if LinkingManifest.json exists
- [ ] 3.3 Validate JSON syntax with jq
- [ ] 3.4 Check DOTFILES_ROOT or auto-detect
- [ ] 3.5 Detect current platform (darwin/linux)

## 4. Manifest Parsing
- [ ] 4.1 Parse version field
- [ ] 4.2 Extract all links from nested structure
- [ ] 4.3 Filter by platform (skip non-matching platforms)
- [ ] 4.4 Handle optional links (skip if source missing)
- [ ] 4.5 Expand tilde (~) in target paths

## 5. Link Type Handlers
- [ ] 5.1 Implement file link handler (ln -s source target)
- [ ] 5.2 Implement directory link handler (ln -s dir target)
- [ ] 5.3 Implement directory-contents handler (iterate files, link each)
- [ ] 5.4 Handle executable permission flag (chmod +x)
- [ ] 5.5 Create parent directories as needed (mkdir -p)

## 6. Safety Features
- [ ] 6.1 Detect existing files/symlinks at target
- [ ] 6.2 Check if existing symlink points to correct source
- [ ] 6.3 Create backup directory ~/.dotfiles-backup-<timestamp>
- [ ] 6.4 Backup existing files before overwriting
- [ ] 6.5 Show backup location to user
- [ ] 6.6 Prompt for confirmation on overwrites (unless --yes)

## 7. Dry-Run Mode
- [ ] 7.1 Display "DRY RUN" banner
- [ ] 7.2 Show what would be created/changed
- [ ] 7.3 Show what would be skipped (optional, platform-specific)
- [ ] 7.4 Show summary statistics
- [ ] 7.5 Exit without making changes

## 8. Apply Mode
- [ ] 8.1 Show confirmation prompt with summary
- [ ] 8.2 Create backups of existing files
- [ ] 8.3 Create all symlinks
- [ ] 8.4 Set executable permissions where needed
- [ ] 8.5 Report success/failure for each link
- [ ] 8.6 Show final summary

## 9. Error Handling
- [ ] 9.1 Handle missing source files gracefully
- [ ] 9.2 Handle permission errors
- [ ] 9.3 Handle invalid JSON
- [ ] 9.4 Handle broken symlinks
- [ ] 9.5 Rollback on critical errors (if possible)
- [ ] 9.6 Exit with appropriate exit codes

## 10. Logging and Output
- [ ] 10.1 Implement log() function with levels (INFO, SUCCESS, WARN, ERROR)
- [ ] 10.2 Implement verbose logging (only shown with --verbose)
- [ ] 10.3 Show progress indicator for long operations
- [ ] 10.4 Colorize output (green=success, yellow=warning, red=error)
- [ ] 10.5 Summary at end (X created, Y skipped, Z errors)

## 11. Testing
- [ ] 11.1 Test dry-run mode
- [ ] 11.2 Test apply mode on clean system
- [ ] 11.3 Test with existing files (backup creation)
- [ ] 11.4 Test with existing correct symlinks (no-op)
- [ ] 11.5 Test with broken symlinks (cleanup and recreate)
- [ ] 11.6 Test platform filtering (darwin-only links)
- [ ] 11.7 Test optional links (missing sources)
- [ ] 11.8 Test directory-contents type
- [ ] 11.9 Test executable permissions
- [ ] 11.10 Run shellcheck validation

## 12. Documentation
- [ ] 12.1 Add comprehensive --help text
- [ ] 12.2 Document in AGENTS.md under "Dotfiles Management"
- [ ] 12.3 Add usage examples to README
- [ ] 12.4 Document exit codes
- [ ] 12.5 Document backup strategy

## 13. Integration
- [ ] 13.1 Make script executable (chmod +x)
- [ ] 13.2 Test from fresh clone scenario
- [ ] 13.3 Add to LinkingManifest.json itself (meta!)
- [ ] 13.4 Consider adding to installation flow
