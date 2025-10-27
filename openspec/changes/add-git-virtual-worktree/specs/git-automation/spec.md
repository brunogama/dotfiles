# Git Automation Specification

## ADDED Requirements

### Requirement: Virtual Worktree Creation with Shallow Clones

The system SHALL create isolated feature branches using shallow Git clones instead of worktrees, optimized for large monorepos with minimal disk usage and fast setup.

#### Scenario: Create virtual worktree with depth 1
- **WHEN** user runs `git-virtual-worktree create <slug>` in a large monorepo
- **THEN** system performs shallow clone: `git clone --depth 1 --single-branch`
- **AND** clone is created at `../<parent>-<slug>` directory
- **AND** new feature branch `feature/<slug>` is created and checked out
- **AND** metadata is saved in parent repo's `.git/virtual-worktree-<slug>.json`
- **AND** setup completes in <10 seconds for repos >1GB

#### Scenario: Create with custom depth
- **WHEN** user runs `git-virtual-worktree create <slug> --depth 5`
- **THEN** shallow clone fetches last 5 commits instead of 1
- **AND** provides more commit history for context
- **AND** still faster than full worktree

#### Scenario: Remote URL detection
- **WHEN** virtual worktree is created
- **THEN** system detects origin URL from parent repo
- **AND** uses same authentication method (SSH/HTTPS)
- **AND** preserves credential helpers
- **AND** logs: "Cloning from: <url>"

#### Scenario: Virtual worktree directory exists
- **WHEN** user creates virtual worktree but directory already exists
- **THEN** error displayed: "Directory already exists: <path>"
- **AND** exit code 5 (WORKTREE_EXISTS)
- **AND** no partial clone created

#### Scenario: Feature branch already exists
- **WHEN** feature branch exists in parent repo before creation
- **THEN** error displayed: "Branch already exists: feature/<slug>"
- **AND** exit code 6 (BRANCH_EXISTS)
- **AND** suggests using different slug

### Requirement: Virtual Worktree Merge with Smart Integration

The system SHALL integrate feature branches from virtual worktrees back into parent repo using git-smart-merge.

#### Scenario: Fetch and merge feature branch
- **WHEN** user runs `git-virtual-worktree merge <slug>`
- **THEN** feature branch is fetched from virtual worktree directory
- **AND** base branch is updated from origin in parent repo
- **AND** git-smart-merge is invoked to integrate feature
- **AND** automatic conflict detection determines strategy
- **AND** exit code 0 on success

#### Scenario: Merge with force-rebase
- **WHEN** user runs `git-virtual-worktree merge <slug> --force-rebase`
- **THEN** flag is passed to git-smart-merge
- **AND** rebase attempted without conflict detection
- **AND** no fallback to merge if conflicts occur

#### Scenario: Merge with dry-run
- **WHEN** user runs `git-virtual-worktree merge <slug> --dry-run`
- **THEN** base branch updates are performed
- **AND** git-smart-merge shows which strategy would be used
- **AND** no actual merge/rebase is executed
- **AND** parent repo state unchanged by feature integration

#### Scenario: Virtual worktree not found during merge
- **WHEN** merge command runs but virtual worktree directory missing
- **THEN** error displayed: "Virtual worktree not found: <path>"
- **AND** suggests checking with: `git-virtual-worktree status <slug>`
- **AND** exit code 1

#### Scenario: Fetch from virtual worktree
- **WHEN** merge command needs to fetch feature branch
- **THEN** runs in parent repo: `git fetch <virtual-worktree-path> feature/<slug>:feature/<slug>`
- **AND** imports commits from virtual worktree
- **AND** creates/updates feature branch in parent repo
- **AND** logs: "Fetching feature branch from virtual worktree..."

### Requirement: Virtual Worktree Cleanup

The system SHALL safely remove virtual worktree directories and associated branches with appropriate warnings.

#### Scenario: Clean cleanup of virtual worktree
- **WHEN** user runs `git-virtual-worktree cleanup <slug>`
- **THEN** virtual worktree directory is removed: `shutil.rmtree()`
- **AND** feature branch is deleted from parent repo
- **AND** metadata file is removed: `.git/virtual-worktree-<slug>.json`
- **AND** confirmation displayed: "✓ Cleanup complete!"

#### Scenario: Uncommitted changes in virtual worktree
- **WHEN** cleanup runs and virtual worktree has uncommitted changes
- **THEN** warning displayed: "⚠ Virtual worktree has uncommitted changes!"
- **AND** user prompted: "Continue with removal? This will lose uncommitted work!"
- **AND** waits for confirmation (default: No)
- **AND** if declined, cleanup cancelled with message

#### Scenario: Force delete unmerged branch
- **WHEN** feature branch has unmerged commits during cleanup
- **THEN** normal delete fails: `git branch -d feature/<slug>`
- **AND** warning: "Failed to delete branch (might have unmerged commits)"
- **AND** user prompted: "Force delete branch?"
- **AND** if confirmed: `git branch -D feature/<slug>`

#### Scenario: Orphaned metadata cleanup
- **WHEN** virtual worktree directory doesn't exist but metadata does
- **THEN** metadata file is still removed
- **AND** feature branch deletion attempted
- **AND** logs: "Virtual worktree directory not found: <path>"

### Requirement: Virtual Worktree Listing and Status

The system SHALL provide visibility into all active virtual worktrees and their states.

#### Scenario: List all virtual worktrees
- **WHEN** user runs `git-virtual-worktree list`
- **THEN** reads all `.git/virtual-worktree-*.json` files
- **AND** displays Rich table with columns: Slug, Base Branch, Directory, Status
- **AND** Status shows: "Active", "Missing", "Error"
- **AND** Active = directory exists, Missing = directory gone

#### Scenario: Status of specific virtual worktree
- **WHEN** user runs `git-virtual-worktree status <slug>`
- **THEN** displays Rich table with metadata:
  - Base Branch
  - Created At
  - Created By
  - Remote URL
  - Clone Depth
  - Feature Branch
  - Virtual Worktree Path
- **AND** shows directory existence: "✓ Virtual worktree exists" or "✗ Not found"
- **AND** shows git status from virtual worktree if exists
- **AND** shows commits ahead of base branch

#### Scenario: Status with missing virtual worktree
- **WHEN** status command runs but directory missing
- **THEN** displays metadata from JSON file
- **AND** shows: "✗ Virtual worktree not found"
- **AND** suggests: "Run cleanup to remove orphaned metadata"

### Requirement: Performance Optimization for Large Repositories

The system SHALL optimize clone operations for minimal disk usage and maximum speed.

#### Scenario: Shallow clone with single branch
- **WHEN** virtual worktree is created
- **THEN** uses: `git clone --depth 1 --single-branch --branch <base>`
- **AND** only fetches specified branch
- **AND** skips all other branches/tags
- **AND** minimizes network transfer

#### Scenario: Skip submodules by default
- **WHEN** parent repo has submodules
- **THEN** submodules are NOT initialized in virtual worktree
- **AND** logs: "Skipping submodules for fast clone"
- **AND** user can manually init if needed: `git submodule update --init`

#### Scenario: Network timeout handling
- **WHEN** clone operation takes >5 minutes
- **THEN** operation times out
- **AND** partial clone is cleaned up
- **AND** error: "Clone operation timed out"
- **AND** suggests checking network or using --depth with smaller value

#### Scenario: Disk space validation
- **WHEN** virtual worktree creation starts
- **THEN** estimates space needed (e.g., repo size / 10 for depth 1)
- **AND** checks available disk space
- **AND** warns if insufficient space
- **AND** aborts before clone if space critically low

### Requirement: Authentication and Remote URL Management

The system SHALL handle Git authentication seamlessly using parent repo's configuration.

#### Scenario: SSH authentication preservation
- **WHEN** parent repo uses SSH URL (git@github.com:...)
- **THEN** virtual worktree clones using same SSH URL
- **AND** uses SSH keys from parent environment
- **AND** no additional authentication required

#### Scenario: HTTPS credential helper usage
- **WHEN** parent repo uses HTTPS with credential helper
- **THEN** virtual worktree inherits credential.helper config
- **AND** credentials are reused automatically
- **AND** no password prompt if cached

#### Scenario: Custom remote URL override
- **WHEN** user runs `git-virtual-worktree create <slug> --url <custom-url>`
- **THEN** uses custom URL instead of detecting from parent
- **AND** useful for testing different remotes
- **AND** metadata stores custom URL

#### Scenario: Authentication failure during clone
- **WHEN** clone fails due to auth error
- **THEN** error displayed: "Authentication failed"
- **AND** suggests: "Check SSH keys or HTTPS credentials"
- **AND** suggests: "Try: git clone <url> manually to test"
- **AND** exit code 1

### Requirement: Metadata Persistence and Recovery

The system SHALL maintain metadata in parent repo for tracking and recovery.

#### Scenario: Metadata saved atomically
- **WHEN** virtual worktree is created successfully
- **THEN** metadata written to temp file first
- **AND** atomic rename to `.git/virtual-worktree-<slug>.json`
- **AND** prevents partial writes
- **AND** metadata includes: base_branch, created_at, created_by, remote_url, depth

#### Scenario: Metadata loaded on merge
- **WHEN** merge command loads metadata
- **THEN** reads from `.git/virtual-worktree-<slug>.json`
- **AND** uses base_branch from metadata (not current branch)
- **AND** validates base branch still exists
- **AND** falls back to current branch if base deleted

#### Scenario: Missing metadata file
- **WHEN** merge or status command runs without metadata
- **THEN** logs: "No metadata found, using current branch"
- **AND** operation continues with fallback values
- **AND** warns user to check virtual worktree path

### Requirement: User Experience Consistency

The system SHALL provide UX consistent with git-worktree-feature-py using Rich console styling.

#### Scenario: Rich panel headers
- **WHEN** any command executes
- **THEN** displays Rich panel with blue border
- **AND** title matches operation: "Virtual Worktree Creation", "Feature Merge", "Cleanup"
- **AND** content uses dim style for labels, bold for values

#### Scenario: Progress indicators
- **WHEN** long operations execute (clone, fetch, merge)
- **THEN** displays Rich status spinner
- **AND** messages: "Cloning repository...", "Fetching latest changes...", "Integrating feature branch..."
- **AND** spinner stops on completion

#### Scenario: Success and error styling
- **WHEN** operations complete
- **THEN** success uses green checkmark: "[green]✓[/green]"
- **AND** errors use red: "[red]Error:[/red]"
- **AND** warnings use yellow: "[yellow]Warning:[/yellow]"
- **AND** info uses blue: "[blue]Info:[/blue]"

#### Scenario: Next steps guidance
- **WHEN** commands complete successfully
- **THEN** displays "[bold]Next steps:[/bold]"
- **AND** provides actionable commands
- **AND** includes comments explaining each step
- **AND** matches format of worktree script

## MODIFIED Requirements

None (this is a new capability, no modifications to existing specs)

## REMOVED Requirements

None

## RENAMED Requirements

None
