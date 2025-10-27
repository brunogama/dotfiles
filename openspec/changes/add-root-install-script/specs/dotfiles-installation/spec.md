# Dotfiles Installation Specification

## ADDED Requirements

### Requirement: One-Command Installation
The repository SHALL provide an `install` script at the root that orchestrates the complete dotfiles setup process.

#### Scenario: Fresh installation on clean macOS
- **WHEN** user runs `./install` on a new macOS system
- **THEN** script detects platform as darwin
- **AND** checks for Homebrew, offers to install if missing
- **AND** installs required dependencies (jq)
- **AND** runs brew bundle for packages
- **AND** creates all symlinks via link-dotfiles
- **AND** reports success with next steps

#### Scenario: Re-run on already configured system
- **WHEN** user runs `./install` on system where dotfiles are already installed
- **THEN** script detects existing installation
- **AND** reports "already installed" for each completed step
- **AND** skips unnecessary operations
- **AND** exits with code 0
- **AND** completes in under 10 seconds

### Requirement: Idempotent Execution
The install script SHALL be safe to run multiple times without causing issues or errors.

#### Scenario: Partial installation completion
- **WHEN** previous installation was interrupted
- **AND** some steps completed, others didn't
- **THEN** script detects what's already done
- **AND** continues from where it left off
- **AND** completes missing steps only

#### Scenario: Update existing installation
- **WHEN** LinkingManifest.json is updated with new links
- **AND** user runs `./install` again
- **THEN** script creates new symlinks
- **AND** leaves existing correct symlinks unchanged
- **AND** reports what was added

### Requirement: Non-Interactive Mode
The install script SHALL support fully automated installation without user prompts.

#### Scenario: CI/automated setup with --yes flag
- **WHEN** user runs `./install --yes`
- **THEN** script proceeds without any prompts
- **AND** assumes "yes" to all confirmations
- **AND** installs Homebrew if missing (without prompt)
- **AND** overwrites existing files without asking
- **AND** completes without user interaction

### Requirement: Dry-Run Preview
The install script SHALL support previewing actions without executing them.

#### Scenario: Preview installation with --dry-run
- **WHEN** user runs `./install --dry-run`
- **THEN** script shows DRY RUN banner
- **AND** displays what would be done in each phase
- **AND** shows which packages would be installed
- **AND** shows which symlinks would be created
- **AND** exits without making any changes
- **AND** exit code is 0

### Requirement: Platform Detection
The install script SHALL detect the operating system and perform platform-specific setup.

#### Scenario: macOS-specific setup
- **WHEN** running on macOS (darwin)
- **THEN** script checks for Homebrew
- **AND** runs brew bundle install
- **AND** creates darwin-specific symlinks only

#### Scenario: Linux setup
- **WHEN** running on Linux
- **THEN** script skips Homebrew installation
- **AND** detects Linux package manager (apt/yum/dnf)
- **AND** shows commands for manual dependency installation
- **AND** creates linux-specific symlinks only

### Requirement: Dependency Management
The install script SHALL verify and install required dependencies before proceeding.

#### Scenario: Missing jq dependency
- **WHEN** jq is not installed
- **AND** platform is macOS
- **THEN** script installs jq via Homebrew
- **AND** verifies jq installation succeeded
- **AND** continues with installation

#### Scenario: Missing jq on Linux
- **WHEN** jq is not installed
- **AND** platform is Linux
- **THEN** script detects package manager
- **AND** shows installation command (e.g., "sudo apt install jq")
- **AND** waits for user to install manually
- **AND** verifies installation before continuing

### Requirement: Homebrew Bundle Installation
The install script SHALL install packages from Brewfile using Homebrew bundle.

#### Scenario: Install packages from Brewfile
- **WHEN** running on macOS
- **AND** Brewfile exists at packages/homebrew/Brewfile
- **THEN** script runs `brew bundle install --file=packages/homebrew/Brewfile`
- **AND** reports number of packages installed
- **AND** reports number already present
- **AND** continues even if some packages fail

#### Scenario: Skip package installation
- **WHEN** user runs `./install --skip-packages`
- **THEN** script skips brew bundle phase entirely
- **AND** continues with symlink creation
- **AND** reports packages were skipped

### Requirement: Symlink Integration
The install script SHALL call the link-dotfiles script to create all symlinks.

#### Scenario: Create symlinks via link-dotfiles
- **WHEN** reaching symlink creation phase
- **THEN** script calls `bin/core/link-dotfiles --apply`
- **AND** passes --yes flag if install was called with --yes
- **AND** captures link-dotfiles output
- **AND** reports linking results (created/skipped counts)

#### Scenario: Link-dotfiles not found
- **WHEN** bin/core/link-dotfiles does not exist
- **THEN** script reports error
- **AND** suggests running from dotfiles repository root
- **AND** exits with code 2

### Requirement: Progress Reporting
The install script SHALL provide clear feedback about installation progress.

#### Scenario: Display phase progress
- **WHEN** installation is running
- **THEN** each phase shows:
  - Phase number and name
  - Actions being performed
  - Success/failure indicators ([OK] [X])
  - Summary of phase results

#### Scenario: Final summary
- **WHEN** installation completes
- **THEN** script displays summary:
  - Total time taken
  - What was installed/configured
  - What was skipped
  - Any errors encountered
  - Next steps for user

### Requirement: Error Handling
The install script SHALL handle errors gracefully and provide actionable messages.

#### Scenario: Homebrew installation fails
- **WHEN** Homebrew installation is attempted
- **AND** installation fails
- **THEN** script reports error with details
- **AND** suggests manual installation
- **AND** exits with code 1

#### Scenario: Symlink creation fails
- **WHEN** link-dotfiles exits with error code
- **THEN** install script captures the error
- **AND** displays link-dotfiles error output
- **AND** continues with remaining phases
- **AND** includes failure in summary

#### Scenario: User cancels during prompt
- **WHEN** user responds 'n' to confirmation prompt
- **OR** user presses Ctrl+C
- **THEN** script displays "Installation cancelled by user"
- **AND** shows what was completed before cancellation
- **AND** exits with code 3

### Requirement: Shell Configuration Guidance
The install script SHALL detect the current shell and provide appropriate configuration guidance.

#### Scenario: zsh detected
- **WHEN** $SHELL environment variable contains zsh
- **THEN** script reports "Current shell: zsh"
- **AND** verifies ~/.zshrc symlink exists
- **AND** reminds user to restart shell or run "exec zsh"

#### Scenario: bash detected
- **WHEN** $SHELL environment variable contains bash
- **THEN** script reports "Current shell: bash"
- **AND** provides bash-specific configuration notes

### Requirement: Skip Flags
The install script SHALL allow users to skip specific installation phases.

#### Scenario: Skip Homebrew with --skip-brew
- **WHEN** user runs `./install --skip-brew`
- **THEN** script skips Homebrew check/installation
- **AND** skips brew bundle install
- **AND** continues with other phases

#### Scenario: Multiple skip flags
- **WHEN** user runs `./install --skip-brew --skip-links`
- **THEN** script skips both specified phases
- **AND** executes only remaining phases
- **AND** reports skipped phases in summary

## MODIFIED Requirements
None - this is a new capability.

## REMOVED Requirements
None - this is a new capability.
