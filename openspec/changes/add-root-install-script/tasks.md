# Implementation Tasks

## 1. Script Foundation
- [ ] 1.1 Create `install` file at repository root
- [ ] 1.2 Add shebang: #!/usr/bin/env bash
- [ ] 1.3 Add set -euo pipefail for safety
- [ ] 1.4 Add color constants (GREEN, BLUE, YELLOW, RED, NC)
- [ ] 1.5 Add script version and metadata
- [ ] 1.6 Make script executable (chmod +x install)

## 2. Argument Parsing
- [ ] 2.1 Parse --dry-run flag
- [ ] 2.2 Parse --yes flag (non-interactive)
- [ ] 2.3 Parse --skip-brew flag
- [ ] 2.4 Parse --skip-packages flag
- [ ] 2.5 Parse --skip-links flag
- [ ] 2.6 Parse --verbose flag
- [ ] 2.7 Parse --help flag
- [ ] 2.8 Set default values

## 3. Helper Functions
- [ ] 3.1 log() - General logging with color support
- [ ] 3.2 log_info() - Blue info messages
- [ ] 3.3 log_success() - Green success messages
- [ ] 3.4 log_warning() - Yellow warnings
- [ ] 3.5 log_error() - Red error messages
- [ ] 3.6 confirm() - Prompt for y/n confirmation (respect --yes)
- [ ] 3.7 phase_header() - Print phase banners
- [ ] 3.8 check_command() - Test if command exists

## 4. Phase 1: Pre-flight Checks
- [ ] 4.1 Detect platform (uname -s: Darwin/Linux)
- [ ] 4.2 Verify we're in a git repository
- [ ] 4.3 Check git is installed
- [ ] 4.4 Detect DOTFILES_ROOT (current directory)
- [ ] 4.5 Verify key files exist (LinkingManifest.json, bin/core/link-dotfiles)
- [ ] 4.6 Display platform and repository path

## 5. Phase 2: Package Manager Setup (macOS)
- [ ] 5.1 Check if platform is darwin
- [ ] 5.2 Check if brew command exists
- [ ] 5.3 If missing, prompt to install Homebrew
- [ ] 5.4 If confirmed, download and run Homebrew installer
- [ ] 5.5 Verify brew installation succeeded
- [ ] 5.6 Check brew health (brew doctor warnings)
- [ ] 5.7 Skip this phase on Linux (log info message)

## 6. Phase 2: Package Manager Setup (Linux)
- [ ] 6.1 Check if platform is linux
- [ ] 6.2 Detect package manager (apt, yum, dnf, pacman)
- [ ] 6.3 Log which package manager was detected
- [ ] 6.4 Skip if not detected (user must install manually)

## 7. Phase 3: Dependency Installation
- [ ] 7.1 Check if jq is installed
- [ ] 7.2 If missing on macOS, install via brew install jq
- [ ] 7.3 If missing on Linux, show install command for detected PM
- [ ] 7.4 Verify jq version
- [ ] 7.5 Check for other optional dependencies (tree, rg, etc.)
- [ ] 7.6 Report dependency status

## 8. Phase 4: Homebrew Bundle (macOS)
- [ ] 8.1 Skip if --skip-packages or --skip-brew flag set
- [ ] 8.2 Skip if platform is not darwin
- [ ] 8.3 Check if Brewfile exists at packages/homebrew/Brewfile
- [ ] 8.4 Run brew bundle install --file=packages/homebrew/Brewfile
- [ ] 8.5 Capture and parse brew bundle output
- [ ] 8.6 Report packages installed/already present
- [ ] 8.7 Handle brew bundle errors gracefully

## 9. Phase 5: Symlink Creation
- [ ] 9.1 Skip if --skip-links flag set
- [ ] 9.2 Verify bin/core/link-dotfiles exists
- [ ] 9.3 Build command: bin/core/link-dotfiles --apply
- [ ] 9.4 Add --yes flag if --yes was passed to install
- [ ] 9.5 Add --verbose flag if --verbose was passed
- [ ] 9.6 Execute link-dotfiles command
- [ ] 9.7 Capture exit code and output
- [ ] 9.8 Report linking results (created/skipped counts)

## 10. Phase 6: Shell Configuration
- [ ] 10.1 Detect current shell ($SHELL environment variable)
- [ ] 10.2 Check which shell RC files are linked
- [ ] 10.3 Display current shell information
- [ ] 10.4 Show reminder to restart shell or source config
- [ ] 10.5 Suggest work-mode status command

## 11. Phase 7: Summary
- [ ] 11.1 Display completion banner
- [ ] 11.2 List what was installed/configured
- [ ] 11.3 List what was skipped (with reasons)
- [ ] 11.4 Show any errors that occurred
- [ ] 11.5 Provide next steps
- [ ] 11.6 Show helpful commands

## 12. Dry-Run Mode
- [ ] 12.1 Check if --dry-run flag is set
- [ ] 12.2 Display DRY RUN banner at start
- [ ] 12.3 For each phase, show what would be done
- [ ] 12.4 Skip actual execution (only detection/reporting)
- [ ] 12.5 Show summary of planned actions
- [ ] 12.6 Exit with code 0

## 13. Error Handling
- [ ] 13.1 Trap errors and clean up (trap 'error_handler' ERR)
- [ ] 13.2 Provide helpful error messages
- [ ] 13.3 Suggest solutions for common errors
- [ ] 13.4 Exit with appropriate exit codes
- [ ] 13.5 Handle user cancellation gracefully (Ctrl+C)

## 14. Idempotency
- [ ] 14.1 Check if already installed before each action
- [ ] 14.2 Skip completed steps with "already installed" message
- [ ] 14.3 Ensure script can be re-run safely
- [ ] 14.4 Don't fail if everything is already set up
- [ ] 14.5 Return exit code 0 for "already complete" scenarios

## 15. Help and Documentation
- [ ] 15.1 Implement --help flag handler
- [ ] 15.2 Display usage information
- [ ] 15.3 Document all flags and options
- [ ] 15.4 Show examples
- [ ] 15.5 Document exit codes

## 16. Testing
- [ ] 16.1 Test on clean macOS system
- [ ] 16.2 Test on system with Homebrew already installed
- [ ] 16.3 Test with existing dotfiles/symlinks
- [ ] 16.4 Test --dry-run mode
- [ ] 16.5 Test --yes (non-interactive) mode
- [ ] 16.6 Test --skip-* flags
- [ ] 16.7 Test re-running after successful install (idempotency)
- [ ] 16.8 Test error scenarios (missing dependencies)
- [ ] 16.9 Test user cancellation (Ctrl+C or 'n' responses)
- [ ] 16.10 Run shellcheck validation

## 17. Integration
- [ ] 17.1 Update AGENTS.md with installation instructions
- [ ] 17.2 Update README.md with quick start
- [ ] 17.3 Ensure script works from any directory
- [ ] 17.4 Test with relative vs absolute paths
- [ ] 17.5 Verify git clone → install workflow

## 18. Polish
- [ ] 18.1 Add progress indicators for long operations
- [ ] 18.2 Improve output formatting/alignment
- [ ] 18.3 Add emoji/symbols for visual clarity ([OK] [X] →)
- [ ] 18.4 Ensure colors work in different terminals
- [ ] 18.5 Test output with and without TTY
