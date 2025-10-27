# home-sync

Home environment synchronization and credential management across machines.

## MODIFIED Requirements

### REQ-HSYNC-001: Git Repository Auto-Detection
**Priority:** Critical
**Status:** Modified

The system MUST automatically detect the dotfiles git repository location.

**Previous Behavior:**
- Hard-coded to `$HOME/.config`
- Failed if repository in different location

**New Behavior:**
- Check multiple common locations in order:
  1. `$HOME/.config-fixing-dot-files-bugs`
  2. `$HOME/.config`
  3. `$HOME/.dotfiles`
  4. `~/dotfiles`
- Return first directory containing `.git` subdirectory
- Support `DOTFILES_DIR` environment variable override
- Fail with clear error listing checked locations if not found

#### Scenario: Auto-detect repository in custom location
**Given** dotfiles repository at `~/.config-fixing-dot-files-bugs`
**When** user runs `home-sync sync`
**Then** script detects correct repository path automatically
**And** performs sync operations in that directory

#### Scenario: Repository not found
**Given** no git repository in common locations
**When** user runs `home-sync sync`
**Then** script displays error message
**And** lists all locations checked
**And** suggests initialization command

### REQ-HSYNC-002: Git Repository Validation
**Priority:** Critical
**Status:** Added

The system MUST validate git repository exists before executing git commands.

**Behavior:**
- Check `git rev-parse --git-dir` succeeds
- Validate before any git operation
- Show clear error if not a git repository
- Suppress verbose git error messages

#### Scenario: Valid git repository
**Given** user in valid git repository
**When** home-sync performs git operations
**Then** operations execute successfully
**And** no validation errors shown

#### Scenario: Not a git repository
**Given** target directory is not a git repository
**When** home-sync attempts git operations
**Then** script shows clear error message
**And** suggests initialization with `git init`
**And** does not show verbose git help output

### REQ-HSYNC-003: Script Auto-Installation
**Priority:** High
**Status:** Added

The system MUST automatically install/update scripts when shell starts.

**Behavior:**
- Check if scripts directory modified since last install
- Compare timestamps of `scripts/` vs `~/.local/bin/.scripts-updated` marker
- Run `make install-scripts` silently if update needed
- Create/update timestamp marker file
- Complete check in <20ms to avoid shell startup delay

#### Scenario: Scripts need update
**Given** scripts directory newer than last install marker
**When** user starts new shell
**Then** scripts automatically reinstall to `~/.local/bin`
**And** marker file updated with current timestamp
**And** shell startup completes without noticeable delay

#### Scenario: Scripts already current
**Given** scripts already installed and current
**When** user starts new shell
**Then** timestamp check completes quickly
**And** no reinstallation occurs
**And** shell startup has minimal overhead

#### Scenario: New script added to repository
**Given** new script added to `scripts/` directory
**When** user starts new shell
**Then** new script automatically installed to `~/.local/bin`
**And** available in PATH immediately
**And** home-sync dependency check passes

## MODIFIED Requirements

### REQ-HSYNC-004: Dependency Management
**Priority:** Critical
**Status:** Modified

The system MUST check for required command dependencies before execution.

**Previous Behavior:**
- Checked for commands in PATH
- Failed if scripts not installed
- No automatic remediation

**New Behavior:**
- Check for required commands: `git`, `stow`, `store-api-key`, `dump-api-keys`, `credmatch`
- Auto-install scripts if missing via shell startup hook
- Clear error message if system tools missing (git, stow)
- Suggest installation commands for missing tools

#### Scenario: All dependencies available
**Given** all required commands in PATH
**When** home-sync checks prerequisites
**Then** check passes without errors
**And** sync operations proceed

#### Scenario: Scripts missing but auto-recoverable
**Given** script commands not in PATH
**And** dotfiles repository available
**When** user starts new shell
**Then** scripts automatically install
**And** subsequent home-sync command succeeds

## REMOVED Requirements

### REQ-HSYNC-005: sync.sh Integration
**Priority:** N/A
**Status:** Removed

**Previous Behavior:**
- Called `./sync.sh --restow` for package management
- Called `./sync.sh --push` for pushing changes
- Called `./sync.sh --status` for status display

**Reason for Removal:**
- `sync.sh` script does not exist in repository
- Created hard dependency on non-existent file
- Caused failures in multiple commands

**Replacement:**
- Direct `git push` for pushing changes
- Direct `git status --short` for status display
- Remove or replace restow functionality with appropriate command

#### Scenario: Push changes without sync.sh
**Given** user has local changes committed
**When** user runs `home-sync push`
**Then** changes pushed using `git push` directly
**And** no sync.sh dependency error occurs

## Dependencies

**Required System Tools:**
- `git` - Version control operations
- `stow` - Symlink management (if used)

**Required Project Scripts:**
- `store-api-key` - Keychain credential storage
- `dump-api-keys` - Credential retrieval
- `credmatch` - Credential pattern matching

**Auto-installed:**
All project scripts auto-install via shell startup hook if missing.

## Testing

**Unit Tests:**
- Test `detect_dotfiles_dir()` with various repository locations
- Test `is_git_repo()` with valid and invalid directories
- Test script auto-install timestamp comparison logic

**Integration Tests:**
- Test complete sync workflow with auto-detected repository
- Test fresh installation with auto-install
- Test script updates trigger reinstallation
- Test error handling when git not available

**Performance Tests:**
- Measure shell startup time with auto-install check (<20ms overhead)
- Measure sync operation time with validation checks

## Security

- Script installation only from trusted dotfiles repository location
- No execution of arbitrary scripts from untrusted paths
- Timestamp check prevents unnecessary reinstalls
- Git operations only in validated repositories
