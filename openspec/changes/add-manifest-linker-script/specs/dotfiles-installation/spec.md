# Dotfiles Installation Specification

## ADDED Requirements

### Requirement: Manifest-Based Symlink Creation
The system SHALL provide a script that reads LinkingManifest.json and automatically creates all specified symlinks.

#### Scenario: User runs installation on clean system
- **WHEN** user runs `link-dotfiles --apply` on a system with no existing dotfiles
- **THEN** all symlinks from manifest are created at their target locations
- **AND** parent directories are created as needed
- **AND** executable permissions are set where specified
- **AND** success summary is displayed

#### Scenario: User previews installation without changes
- **WHEN** user runs `link-dotfiles` (without --apply flag)
- **THEN** script shows what would be created (dry-run mode)
- **AND** no actual files or symlinks are created
- **AND** summary shows count of links that would be created
- **AND** exit code is 0

### Requirement: Platform-Aware Linking
The script SHALL respect platform filters in the manifest and only create links appropriate for the current operating system.

#### Scenario: Darwin-only link on macOS
- **WHEN** running on macOS (darwin platform)
- **THEN** links with "platforms": ["darwin"] are created
- **AND** links with "platforms": ["linux"] are skipped
- **AND** links without platform filter are created (default to all)

#### Scenario: Darwin-only link on Linux
- **WHEN** running on Linux platform
- **THEN** links with "platforms": ["darwin"] are skipped
- **AND** links with "platforms": ["linux"] are created
- **AND** skipped links are reported in verbose mode

### Requirement: Safe Overwrite with Backup
The script SHALL backup existing files before overwriting them with symlinks.

#### Scenario: Existing file at target location
- **WHEN** target location already has a file (not a symlink)
- **THEN** script detects the conflict
- **AND** prompts user for confirmation (unless --yes flag)
- **AND** backs up existing file to ~/.dotfiles-backup-<timestamp>/
- **AND** creates the symlink after backup
- **AND** reports backup location

#### Scenario: Existing correct symlink
- **WHEN** target location already has a symlink pointing to the correct source
- **THEN** script detects it's already correct
- **AND** skips creation (no-op)
- **AND** reports "already linked" status

#### Scenario: Existing incorrect symlink
- **WHEN** target location has a symlink pointing to wrong source
- **THEN** script detects the mismatch
- **AND** prompts for confirmation to replace
- **AND** backs up the old symlink
- **AND** creates new symlink to correct source

### Requirement: Link Type Support
The script SHALL support all link types defined in the manifest: file, directory, and directory-contents.

#### Scenario: Single file link
- **WHEN** manifest specifies link type "file" (or default)
- **THEN** creates symlink from source file to target location
- **AND** creates parent directories if needed

#### Scenario: Directory link
- **WHEN** manifest specifies link type "directory"
- **THEN** creates symlink from source directory to target directory
- **AND** entire directory is accessible via single symlink

#### Scenario: Directory contents link
- **WHEN** manifest specifies link type "directory-contents"
- **THEN** iterates each file in source directory
- **AND** creates individual symlink for each file
- **AND** preserves subdirectory structure
- **AND** sets executable permissions on files marked as executable

### Requirement: Optional Link Handling
The script SHALL gracefully handle optional links where source files may not exist.

#### Scenario: Optional link with missing source
- **WHEN** link is marked as "optional": true
- **AND** source file does not exist
- **THEN** script skips the link without error
- **AND** reports "skipped (optional, source not found)" in verbose mode

#### Scenario: Required link with missing source
- **WHEN** link is NOT marked as optional
- **AND** source file does not exist
- **THEN** script reports error
- **AND** includes link in error summary
- **AND** continues processing other links (doesn't abort)

### Requirement: Prerequisite Validation
The script SHALL validate all prerequisites before attempting to create links.

#### Scenario: Missing jq dependency
- **WHEN** jq is not installed
- **THEN** script exits with error message
- **AND** instructs user to install jq (brew install jq)
- **AND** exit code is 2

#### Scenario: Missing manifest file
- **WHEN** LinkingManifest.json does not exist
- **THEN** script exits with error
- **AND** shows expected manifest location
- **AND** exit code is 2

#### Scenario: Invalid JSON in manifest
- **WHEN** LinkingManifest.json contains invalid JSON
- **THEN** script exits with error
- **AND** shows jq parse error
- **AND** exit code is 2

### Requirement: Idempotent Operation
The script SHALL be safe to run multiple times without causing issues.

#### Scenario: Re-run after successful installation
- **WHEN** all symlinks are already correctly created
- **THEN** script detects all links are up-to-date
- **AND** reports "already linked" for each
- **AND** no files are modified
- **AND** no backups are created
- **AND** exit code is 0

#### Scenario: Re-run after partial installation
- **WHEN** some symlinks exist and some don't
- **THEN** script creates only missing symlinks
- **AND** leaves existing correct symlinks unchanged
- **AND** reports mixed status (X created, Y already linked)

### Requirement: User Confirmation for Destructive Operations
The script SHALL prompt for user confirmation before overwriting existing files.

#### Scenario: Overwrite prompt without --yes flag
- **WHEN** existing file would be overwritten
- **AND** --yes flag is not provided
- **THEN** script shows file path and prompts for confirmation
- **AND** user can respond y/n
- **AND** file is overwritten only if user confirms

#### Scenario: Batch overwrite with --yes flag
- **WHEN** multiple files would be overwritten
- **AND** --yes flag is provided
- **THEN** script proceeds without prompting
- **AND** all files are backed up and overwritten
- **AND** reports all actions taken

### Requirement: Clear Status Reporting
The script SHALL provide clear feedback about what actions were taken.

#### Scenario: Successful installation with mixed results
- **WHEN** installation completes
- **THEN** summary shows:
  - Count of links created
  - Count of links skipped (already correct)
  - Count of links skipped (optional, missing)
  - Count of links skipped (platform mismatch)
  - Count of errors
  - Location of backups (if any)

#### Scenario: Dry-run mode output
- **WHEN** running in dry-run mode (default)
- **THEN** output clearly shows "DRY RUN - No changes will be made"
- **AND** each link shows action that would be taken:
  - "Would create: target -> source"
  - "Would skip: reason"
  - "Would backup and overwrite: target"

### Requirement: Error Recovery
The script SHALL handle errors gracefully and provide actionable error messages.

#### Scenario: Permission denied on target
- **WHEN** script cannot write to target location (permission denied)
- **THEN** reports error with file path
- **AND** suggests using sudo if needed
- **AND** continues with other links
- **AND** includes failed links in error summary

#### Scenario: Broken symlink cleanup
- **WHEN** target location has a broken symlink (pointing to non-existent source)
- **THEN** script detects the broken link
- **AND** removes broken symlink
- **AND** creates correct symlink
- **AND** reports "cleaned up broken link"

## MODIFIED Requirements
None - this is a new capability.

## REMOVED Requirements
None - this is a new capability.
