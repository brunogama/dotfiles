# Git Automation Specification

## MODIFIED Requirements

### Requirement: Worktree Feature Branch Integration

The git-worktree-feature-py tool SHALL use git-smart-merge for intelligent branch integration, providing automatic conflict detection and fallback strategies when merging feature branches.

#### Scenario: Clean feature rebase using git-smart-merge
- **WHEN** user runs `git-worktree-feature-py merge <slug>` and feature has no conflicts with base
- **THEN** the tool invokes `git-smart-merge` which performs a rebase
- **AND** user sees combined output from worktree tool and git-smart-merge
- **AND** success message indicates rebase was used
- **AND** exit code is 0

#### Scenario: Conflicting feature requires merge fallback
- **WHEN** user runs `git-worktree-feature-py merge <slug>` and git-smart-merge detects conflicts
- **THEN** git-smart-merge automatically falls back to `git merge --no-ff`
- **AND** user sees "Merge strategy chosen: conflicts detected, rebase not safe"
- **AND** feature is integrated using merge commit
- **AND** exit code is 0 if merge succeeds

#### Scenario: Force rebase mode in worktree
- **WHEN** user runs `git-worktree-feature-py merge <slug> --force-rebase`
- **THEN** the tool passes `--force-rebase` flag to git-smart-merge
- **AND** rebase is attempted without conflict detection
- **AND** if rebase fails, user must manually resolve (no automatic fallback)

#### Scenario: Force merge mode in worktree
- **WHEN** user runs `git-worktree-feature-py merge <slug> --force-merge`
- **THEN** the tool passes `--force-merge` flag to git-smart-merge
- **AND** merge strategy is used without attempting rebase
- **AND** user sees "Force merge mode: skipping rebase analysis"

#### Scenario: Dry-run preview of merge strategy
- **WHEN** user runs `git-worktree-feature-py merge <slug> --dry-run`
- **THEN** base branch is updated from origin (not dry-run)
- **AND** git-smart-merge is called with `--dry-run` flag
- **AND** user sees which strategy would be used without executing
- **AND** repository state is unchanged by feature integration attempt

#### Scenario: git-smart-merge not found
- **WHEN** git-smart-merge script is not in PATH or expected location
- **THEN** git-worktree-feature-py displays error: "git-smart-merge not found"
- **AND** provides installation instructions or path to script
- **AND** exits with code 1 without attempting merge

#### Scenario: Base branch update before feature integration
- **WHEN** user runs merge command
- **THEN** base branch is checked out
- **AND** origin is fetched
- **AND** base is rebased onto origin/base (if remote exists)
- **AND** ONLY THEN is git-smart-merge invoked for feature integration
- **AND** this ensures base is current before merging feature

### Requirement: Error Code Mapping

git-worktree-feature-py SHALL correctly interpret git-smart-merge exit codes and map them to appropriate worktree exit codes.

#### Scenario: git-smart-merge success
- **WHEN** git-smart-merge exits with code 0
- **THEN** git-worktree-feature-py continues with success path
- **AND** displays "Next steps" guidance
- **AND** exits with ExitCode.SUCCESS

#### Scenario: git-smart-merge detects user error
- **WHEN** git-smart-merge exits with code 1 or 2 (user error)
- **THEN** git-worktree-feature-py displays the error from git-smart-merge
- **AND** exits with ExitCode.ERROR
- **AND** does not suggest "git rebase --continue" (git-smart-merge handles guidance)

#### Scenario: git-smart-merge conflict resolution needed
- **WHEN** git-smart-merge exits with code 1 due to conflicts during merge
- **THEN** git-worktree-feature-py recognizes conflicts occurred
- **AND** preserves git-smart-merge's conflict resolution instructions
- **AND** adds worktree-specific next step: "After resolving: git-worktree-feature-py cleanup <slug>"

### Requirement: Consistent User Experience

The worktree tool SHALL maintain its Rich console styling while integrating git-smart-merge output.

#### Scenario: Styled output integration
- **WHEN** git-smart-merge produces output during merge
- **THEN** git-worktree-feature-py preserves its Rich panel headers
- **AND** git-smart-merge plain text output is displayed inline
- **AND** success indicators use Rich green checkmarks
- **AND** warnings use Rich yellow formatting

#### Scenario: Progress indication during merge
- **WHEN** merge command executes multi-step process
- **THEN** user sees Rich status spinner for "Fetching latest changes..."
- **AND** user sees Rich status spinner for "Updating base branch..."
- **AND** git-smart-merge output appears with its own progress indicators
- **AND** final success/error uses Rich formatting

## ADDED Requirements

### Requirement: Optional Merge Strategy Flags

git-worktree-feature-py merge command SHALL support optional flags for controlling merge strategy.

#### Scenario: Help text includes strategy flags
- **WHEN** user runs `git-worktree-feature-py merge --help`
- **THEN** help text documents `--force-rebase` flag
- **AND** help text documents `--force-merge` flag
- **AND** help text documents `--dry-run` flag
- **AND** examples show usage of each flag

#### Scenario: Conflicting flags rejected
- **WHEN** user runs `git-worktree-feature-py merge <slug> --force-rebase --force-merge`
- **THEN** tool displays error: "Cannot use --force-rebase and --force-merge together"
- **AND** exits with usage error code (2)
- **AND** suggests using one flag or none for automatic detection

### Requirement: git-smart-merge Path Resolution

The tool SHALL locate git-smart-merge script using multiple fallback strategies.

#### Scenario: Script in PATH
- **WHEN** git-smart-merge is in system PATH
- **THEN** tool executes it directly via subprocess

#### Scenario: Script in same bin directory
- **WHEN** git-smart-merge is not in PATH but exists in `../git-smart-merge` relative to worktree script
- **THEN** tool resolves absolute path and executes it
- **AND** logs: "Using git-smart-merge from: <path>"

#### Scenario: Script not found anywhere
- **WHEN** git-smart-merge is not in PATH or relative location
- **THEN** tool displays error with installation instructions
- **AND** suggests: "Install git-smart-merge or add bin/ directory to PATH"
- **AND** exits with error code 1
