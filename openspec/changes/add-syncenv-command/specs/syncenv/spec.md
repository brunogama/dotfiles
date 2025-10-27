# syncenv

Environment-aware dotfiles synchronization with marvelous developer experience.

## ADDED Requirements

### REQ-SYNCENV-001: Command-Line Interface
**Priority:** Critical
**Status:** Added

The system MUST provide a clean, intuitive command-line interface for syncing dotfiles.

**Command Syntax:**
```bash
syncenv [environment] [options]
```

**Arguments:**
- `environment` (optional): Target environment (`work`, `personal`, or `current`)
  - Default: Auto-detect from `DOTFILES_ENV` or `.zshenv`

**Options:**
- `--dry-run`: Preview operations without executing
- `--verbose, -v`: Show detailed git output
- `--force, -f`: Auto-commit uncommitted changes
- `--no-push`: Skip push after pull
- `--status, -s`: Display sync status only
- `--help, -h`: Show help message

#### Scenario: Sync current environment
**Given** user is in personal environment (DOTFILES_ENV=personal)
**When** user runs `syncenv`
**Then** system syncs personal dotfiles repository
**And** uses smart pull strategy (rebase → merge fallback)
**And** pushes changes after successful pull

#### Scenario: Sync specific environment
**Given** user wants to sync work environment
**When** user runs `syncenv work`
**Then** system syncs work dotfiles regardless of current environment
**And** completes pull and push operations

#### Scenario: Dry-run mode
**Given** user wants to preview sync operations
**When** user runs `syncenv --dry-run`
**Then** system shows what would be done without executing
**And** displays: repo path, branch, pull strategy, push intention

### REQ-SYNCENV-002: Environment Detection
**Priority:** Critical
**Status:** Added

The system MUST automatically detect the target environment using a clear priority system.

**Detection Priority:**
1. Command-line argument (`syncenv work`)
2. `DOTFILES_ENV` environment variable
3. Parse from `~/.zshenv` file
4. Default to `personal`

**Validation:**
- Only accept `work` or `personal` values
- Show clear error for invalid environments
- Display detected environment in verbose mode

#### Scenario: Detect from command argument
**Given** user provides environment argument
**When** user runs `syncenv personal`
**Then** system uses `personal` environment regardless of other settings

#### Scenario: Detect from environment variable
**Given** `DOTFILES_ENV=work` is set
**And** no command-line argument provided
**When** user runs `syncenv`
**Then** system detects and uses `work` environment

#### Scenario: Detect from .zshenv file
**Given** `~/.zshenv` contains `export DOTFILES_ENV=personal`
**And** DOTFILES_ENV variable not set in current shell
**When** user runs `syncenv`
**Then** system parses .zshenv and uses `personal` environment

#### Scenario: Default environment
**Given** no environment specified anywhere
**When** user runs `syncenv`
**Then** system defaults to `personal` environment
**And** displays warning about using default

### REQ-SYNCENV-003: Smart Git Pull Strategy
**Priority:** Critical
**Status:** Added

The system MUST implement a smart git pull strategy with automatic fallback.

**Pull Strategy:**
1. **Attempt rebase:** `git pull --rebase origin <branch>`
   - Success → Clean linear history
   - Failure → Proceed to step 2

2. **Fallback to merge:** `git pull --no-ff origin <branch>`
   - Creates merge commit
   - Success → Continue to push
   - Failure → Report conflicts

3. **Handle conflicts:**
   - Display conflict files
   - Provide resolution guide
   - Exit with actionable error

**Pre-flight Checks:**
- Repository exists and is valid git repo
- Branch has upstream tracking
- Remote is reachable
- Working directory clean (or --force flag provided)

#### Scenario: Successful rebase
**Given** clean repository with linear history
**And** remote has new commits
**When** sync pulls with rebase
**Then** local commits rebased on top of remote
**And** no merge commits created
**And** displays "Successfully rebased X commits"

#### Scenario: Rebase failure → merge fallback
**Given** rebase would create conflicts
**When** sync attempts rebase
**Then** rebase automatically aborted
**And** system tries pull with merge
**And** creates merge commit on success
**And** displays "Rebased failed, merged successfully"

#### Scenario: Merge conflicts
**Given** both rebase and merge have conflicts
**When** sync attempts both strategies
**Then** system reports conflict files in a table
**And** displays resolution steps
**And** exits with error code
**And** suggests: git status, conflict resolution, re-run syncenv

#### Scenario: Repository up-to-date
**Given** no new commits on remote
**When** sync attempts pull
**Then** system reports "Already up-to-date"
**And** skips push operation
**And** shows success message

### REQ-SYNCENV-004: Git Push After Pull
**Priority:** High
**Status:** Added

The system MUST push local changes to remote after successful pull (unless --no-push specified).

**Push Behavior:**
- Push to same remote and branch used for pull
- Handle push rejection (non-fast-forward)
- Report push success with commit count
- Skip if --no-push flag provided

**Push Failures:**
- Upstream diverged → Suggest pull again
- Network error → Retry suggestion
- Permission denied → Check credentials
- Unknown error → Show git output

#### Scenario: Successful push
**Given** successful pull completed
**And** local commits exist
**When** system pushes to remote
**Then** commits uploaded successfully
**And** displays "Pushed X commits to origin/<branch>"

#### Scenario: Push with --no-push flag
**Given** successful pull completed
**And** --no-push flag provided
**When** sync completes pull
**Then** system skips push operation
**And** displays "Push skipped (--no-push)"

#### Scenario: Push rejection
**Given** remote has commits not in local
**When** system attempts push
**Then** push rejected as non-fast-forward
**And** displays error: "Remote has changed, please sync again"
**And** suggests re-running syncenv

### REQ-SYNCENV-005: Beautiful Terminal Output
**Priority:** High
**Status:** Added

The system MUST provide rich, colorful terminal output for excellent UX.

**Using Rich library for:**
- Color-coded messages (success, info, warning, error)
- Spinners for long operations
- Progress indicators for multi-step operations
- Tables for status display
- Formatted panels for summaries

**Color Scheme:**
- Green [OK] - Success messages
- Blue ℹ - Information messages
- Yellow [WARNING] - Warnings
- Red [X] - Errors
- Cyan - Spinners and progress

**Output Components:**
- Operation headers with icons
- Real-time spinners during git operations
- Success/failure indicators
- Summary panels with statistics
- Error messages with suggestions

#### Scenario: Rich sync output
**Given** user runs sync command
**When** operations execute
**Then** display shows:
- Header: " Syncing personal environment..."
- Status checks with checkmarks
- Spinner: " Pulling from remote..."
- Success: "[OK] Successfully rebased 3 commits"
- Spinner: " Pushing to remote..."
- Success: "[OK] Pushed to origin/main"
- Summary panel with statistics

#### Scenario: Error with suggestions
**Given** sync operation fails
**When** error occurs (e.g., merge conflict)
**Then** display shows:
- Red error icon and message
- Table of conflict files
- Step-by-step resolution guide
- Command suggestions
- Exit with non-zero code

### REQ-SYNCENV-006: Status Display
**Priority:** Medium
**Status:** Added

The system MUST provide comprehensive status information with --status flag.

**Status Information:**
- Current environment (work or personal)
- Repository path
- Current branch and tracking info
- Uncommitted changes count
- Commits ahead/behind remote
- Last sync timestamp
- Remote URL and connectivity

**Display Format:**
- Rich table with columns: Item, Value
- Color-coded values (green=ok, red=issue, yellow=warning)
- Clear section separators

#### Scenario: Display status
**Given** user wants to check sync status
**When** user runs `syncenv --status`
**Then** system displays table with:
- Environment: personal
- Repository: ~/.config-fixing-dot-files-bugs
- Branch: main (tracking origin/main)
- Status: Clean working directory
- Ahead/Behind: 0 ahead, 2 behind
- Last Sync: 2 hours ago
- Remote: Connected

### REQ-SYNCENV-007: Python Implementation with uv
**Priority:** Critical
**Status:** Added

The system MUST be implemented in Python using uv for dependency management.

**Requirements:**
- Python 3.11+ (for modern syntax)
- uv shebang: `#!/usr/bin/env -S uv run`
- Inline script metadata with dependencies
- Self-contained (no separate requirements.txt)

**Dependencies:**
- `rich>=13.7.0` - Terminal UI
- `click>=8.1.0` - CLI framework
- `gitpython>=3.1.0` - Git operations

**Script Structure:**
```python
#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "rich>=13.7.0",
#     "click>=8.1.0",
#     "gitpython>=3.1.0",
# ]
# ///
```

#### Scenario: Script execution with uv
**Given** syncenv script with inline dependencies
**When** user runs `syncenv`
**Then** uv automatically installs dependencies if needed
**And** executes script with correct Python version
**And** completes in reasonable time (<5s for clean sync)

### REQ-SYNCENV-008: Error Handling and Recovery
**Priority:** High
**Status:** Added

The system MUST provide comprehensive error handling with actionable guidance.

**Error Categories:**
1. **Repository errors:** Not found, not a git repo, corrupted
2. **Git errors:** Rebase/merge conflicts, detached HEAD, invalid branch
3. **Network errors:** Remote unreachable, timeout, authentication
4. **Environment errors:** Invalid environment, missing config
5. **Permission errors:** File access denied, git operation denied

**Error Response:**
- Clear error message explaining what went wrong
- Root cause if determinable
- Step-by-step resolution guide
- Command suggestions to fix issue
- Links to documentation (if applicable)
- Non-zero exit code

#### Scenario: Repository not found
**Given** dotfiles repository doesn't exist
**When** user runs syncenv
**Then** system displays error: "Dotfiles repository not found"
**And** lists checked locations
**And** suggests: "Run 'make install' to set up dotfiles"
**And** exits with code 1

#### Scenario: Uncommitted changes without --force
**Given** repository has uncommitted changes
**And** --force flag not provided
**When** sync attempts pull
**Then** system displays warning: "Uncommitted changes detected"
**And** lists modified files
**And** suggests: "Commit changes or use --force to auto-commit"
**And** exits with code 1

## Dependencies

**System Requirements:**
- Python 3.11 or higher
- Git 2.30 or higher
- uv package manager

**Python Dependencies (auto-managed by uv):**
- rich - Terminal formatting
- click - CLI framework
- gitpython - Git operations wrapper

## Testing

**Unit Tests:**
- Test environment detection logic
- Test git repository finding
- Test error handling paths
- Mock git operations for testing

**Integration Tests:**
- Full sync workflow (pull + push)
- Rebase success scenario
- Rebase failure → merge fallback
- Conflict handling
- All CLI flags

**Performance Tests:**
- Sync time on clean repo (<2s)
- Sync time with large repo
- Environment detection speed
- Repository finding speed

## Security

**Git Credentials:**
- Use system git credential helper
- Never store passwords in script
- Respect SSH key authentication

**File Permissions:**
- Script executable by owner only
- Respect repository permissions
- No temporary file leaks

**Input Validation:**
- Sanitize all user inputs
- Validate environment names
- Prevent command injection in git operations
