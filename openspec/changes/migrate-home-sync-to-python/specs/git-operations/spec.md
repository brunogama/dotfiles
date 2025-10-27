# Capability: Git Operations

**Change ID**: `migrate-home-sync-to-python`
**Capability**: `git-operations`
**Priority**: Critical

## Overview

Implement safe, reliable git operations for dotfiles synchronization with proper error handling, rollback capabilities, and conflict detection. This replaces bash subprocess calls with Python's subprocess module and adds transaction-style rollback on failure.

---

## ADDED Requirements

### Requirement: Safe Subprocess Execution

**ID**: `git-001`
**Priority**: Critical

Git commands MUST be executed safely without shell injection vulnerabilities and with proper timeout handling.

#### Scenario: Execute git command successfully
**Given** a valid git repository at `/path/to/repo`
**When** executing `run_git(['status', '--short'], cwd='/path/to/repo')`
**Then** the command executes with `shell=False`
**And** output is captured as text
**And** return code is checked
**And** result contains stdout/stderr

#### Scenario: Git command times out
**Given** a git operation that hangs (e.g., network issue)
**When** the operation exceeds 30 seconds
**Then** `subprocess.TimeoutExpired` is raised
**And** the timeout is converted to `GitError`
**And** the error message indicates the command that timed out

#### Scenario: Git command fails with error
**Given** an invalid git operation
**When** git returns non-zero exit code
**Then** `subprocess.CalledProcessError` is raised
**And** stderr output is included in error message
**And** the error is wrapped in `GitError`

---

### Requirement: Repository Status Checking

**ID**: `git-002`
**Priority**: High

The system MUST accurately detect repository status including uncommitted changes, branch divergence, and conflicts.

#### Scenario: Clean repository
**Given** a git repository with no uncommitted changes
**And** the local branch matches remote
**When** checking `is_repo_clean()`
**Then** the function returns `True`
**And** no warnings are logged

#### Scenario: Dirty repository with uncommitted files
**Given** a git repository with modified files
**When** checking `is_repo_clean()`
**Then** the function returns `False`
**And** the list of modified files is available

#### Scenario: Repository ahead of remote
**Given** a git repository with local commits
**And** remote branch does not have these commits
**When** checking `get_branch_status()`
**Then** status is `BranchStatus.AHEAD`
**And** the commit count is accurate

#### Scenario: Repository behind remote
**Given** a git repository
**And** remote has commits not in local branch
**When** checking `get_branch_status()`
**Then** status is `BranchStatus.BEHIND`
**And** fast-forward is possible

#### Scenario: Repository diverged from remote
**Given** a git repository with local commits
**And** remote has different commits
**When** checking `get_branch_status()`
**Then** status is `BranchStatus.DIVERGED`
**And** automatic merge is NOT attempted
**And** error message suggests manual resolution

---

### Requirement: Transaction Rollback

**ID**: `git-003`
**Priority**: Critical

Git operations MUST support transaction-style rollback to prevent data loss when operations fail partway through.

#### Scenario: Successful operation with savepoint
**Given** a git repository at commit ABC123
**When** executing operations within `git_savepoint()` context
**And** all operations succeed
**Then** the final commit is preserved
**And** the savepoint is discarded
**And** no rollback occurs

#### Scenario: Failed operation triggers rollback
**Given** a git repository at commit ABC123
**When** executing operations within `git_savepoint()` context
**And** an operation raises `GitError`
**Then** `git reset --hard ABC123` is executed
**And** the repository is restored to original state
**And** no data is lost
**And** the exception is re-raised

#### Scenario: Rollback preserves untracked files
**Given** a git repository with untracked files
**When** a savepoint is created
**And** operations fail and rollback occurs
**Then** tracked files are restored to savepoint
**And** untracked files remain unchanged
**And** no untracked files are deleted

---

### Requirement: Safe Auto-Commit

**ID**: `git-004`
**Priority**: High

When auto-committing changes, the system MUST create a backup branch and only commit tracked files to prevent data loss.

#### Scenario: Auto-commit with backup branch
**Given** a git repository with uncommitted changes
**And** the `--force` flag is set
**When** auto-commit is triggered
**Then** a backup branch is created with name `backup-YYYYMMDD-HHMMSS`
**And** only tracked files are staged (`git add -u`)
**And** a commit is created with timestamp message
**And** the backup branch is not deleted

#### Scenario: Auto-commit without force flag fails
**Given** a git repository with uncommitted changes
**And** the `--force` flag is NOT set
**When** sync is attempted
**Then** `GitError` is raised
**And** no auto-commit occurs
**And** error message instructs user to commit manually or use --force

#### Scenario: Auto-commit excludes untracked files
**Given** a git repository with tracked and untracked files
**When** auto-commit is triggered with --force
**Then** only tracked files are committed
**And** untracked files remain untracked
**And** no new files are added to repository

---

### Requirement: Conflict Detection

**ID**: `git-005`
**Priority**: High

The system MUST detect merge conflicts and refuse to proceed with automatic resolution.

#### Scenario: Pull with fast-forward succeeds
**Given** a git repository behind remote
**And** no local changes exist
**When** executing `pull_changes()`
**Then** `git pull --ff-only` succeeds
**And** local branch is updated
**And** no merge conflicts occur

#### Scenario: Pull with conflicts fails gracefully
**Given** a git repository with local changes
**And** remote has conflicting changes
**When** executing `pull_changes()`
**Then** `git pull --ff-only` fails
**And** repository state is unchanged (no partial merge)
**And** `GitError` is raised with conflict description
**And** error message suggests manual resolution

#### Scenario: Diverged branches block sync
**Given** a git repository with diverged branches
**When** checking if sync is possible
**Then** `can_sync()` returns `False`
**And** error indicates branches have diverged
**And** manual merge/rebase is required

---

### Requirement: Remote Connectivity Check

**ID**: `git-006`
**Priority**: Medium

Before attempting push/pull operations, the system MUST verify remote connectivity to provide better error messages.

#### Scenario: Remote is reachable
**Given** a git repository with configured remote
**When** checking `is_remote_reachable()`
**Then** `git ls-remote` succeeds
**And** the function returns `True`

#### Scenario: Remote is unreachable
**Given** a git repository with configured remote
**And** network is disconnected
**When** checking `is_remote_reachable()`
**Then** `git ls-remote` times out or fails
**And** the function returns `False`
**And** error message indicates network issue

#### Scenario: Skip sync when offline
**Given** remote is unreachable
**When** sync is attempted
**Then** local operations complete (commit)
**And** push is skipped with warning
**And** sync continues without failure
**And** next sync will retry push

---

## MODIFIED Requirements

None (new capability)

---

## REMOVED Requirements

None (new capability)

---

## Implementation Notes

### Git Wrapper Function

```python
import subprocess
from pathlib import Path
from typing import List

def run_git(
    args: List[str],
    cwd: Path,
    check: bool = True,
    timeout: int = 30
) -> subprocess.CompletedProcess:
    """
    Execute git command safely.

    Args:
        args: Git arguments (without 'git' prefix)
        cwd: Working directory
        check: Raise exception on non-zero exit
        timeout: Command timeout in seconds

    Returns:
        CompletedProcess with stdout, stderr, returncode

    Raises:
        GitError: If command fails or times out
    """
    cmd = ['git', *args]

    try:
        result = subprocess.run(
            cmd,
            cwd=cwd,
            check=check,
            capture_output=True,
            text=True,
            timeout=timeout,
            # NEVER use shell=True - prevents command injection
        )
        return result

    except subprocess.TimeoutExpired:
        raise GitError(f"Git command timed out after {timeout}s: {' '.join(cmd)}")

    except subprocess.CalledProcessError as e:
        raise GitError(
            f"Git command failed: {' '.join(cmd)}\n"
            f"Exit code: {e.returncode}\n"
            f"Stderr: {e.stderr}"
        )
```

### Savepoint Context Manager

```python
from contextlib import contextmanager

@contextmanager
def git_savepoint(repo_path: Path):
    """
    Create git savepoint and rollback on error.

    Usage:
        with git_savepoint(repo):
            # Operations here
            commit_changes()
            push_changes()
            # Automatic rollback on exception
    """
    # Get current commit
    result = run_git(['rev-parse', 'HEAD'], cwd=repo_path)
    original_commit = result.stdout.strip()

    try:
        yield original_commit

    except Exception as e:
        log.warning(f"Operation failed, rolling back to {original_commit}")
        run_git(['reset', '--hard', original_commit], cwd=repo_path)
        run_git(['clean', '-fd'], cwd=repo_path)  # Remove untracked files from partial operations
        raise
```

### Branch Status Enum

```python
from enum import StrEnum

class BranchStatus(StrEnum):
    """Git branch status relative to remote."""
    UP_TO_DATE = "up-to-date"
    AHEAD = "ahead"
    BEHIND = "behind"
    DIVERGED = "diverged"

def get_branch_status(repo_path: Path) -> BranchStatus:
    """Determine branch status vs remote."""
    local = run_git(['rev-parse', 'HEAD'], cwd=repo_path).stdout.strip()
    remote = run_git(['rev-parse', '@{u}'], cwd=repo_path).stdout.strip()
    base = run_git(['merge-base', 'HEAD', '@{u}'], cwd=repo_path).stdout.strip()

    if local == remote:
        return BranchStatus.UP_TO_DATE
    elif local == base:
        return BranchStatus.BEHIND  # Can fast-forward
    elif remote == base:
        return BranchStatus.AHEAD  # Need to push
    else:
        return BranchStatus.DIVERGED  # Need manual merge
```

---

## Testing Strategy

### Unit Tests
- Test `run_git()` with valid/invalid commands
- Test timeout handling
- Test error message parsing
- Mock subprocess calls for isolation

### Integration Tests
- Create temporary git repos
- Test actual git operations (commit, push, pull)
- Test rollback scenarios
- Test conflict detection with real merges

### Property-Based Tests
- Generate random git operation sequences
- Verify savepoints always restore state
- Verify no data loss under any failure scenario

---

## Dependencies

- Python subprocess module (stdlib)
- Python pathlib (stdlib)
- Git installed on system (checked at runtime)

---

## Security Considerations

- **Never use `shell=True`**: Prevents command injection
- **Validate all paths**: Ensure paths are within repo
- **Timeout all operations**: Prevents infinite hangs
- **Never log sensitive data**: No credentials in logs

---

## Performance Considerations

- Git operations are I/O bound (disk, network)
- Subprocess overhead is minimal (<10ms per call)
- Most time spent in git itself (out of our control)
- Rollback is fast (reset --hard is O(1) for git)

---

## Error Recovery

### Partial Push Failure
**Problem**: Pushed some commits, then network fails
**Solution**: Next sync will retry push (git handles this)

### Partial Pull Failure
**Problem**: Fetched but not merged due to error
**Solution**: Rollback discards fetch, next sync retries

### Corrupt Repository
**Problem**: Git commands fail with corruption errors
**Solution**: Detect corruption, log error, suggest `git fsck`

---

## Migration from Bash

**Bash Issues**:
- No rollback on partial failure
- Timeout handling is complex
- Error messages are unclear
- Race conditions in status checks

**Python Benefits**:
- Context managers provide automatic rollback
- subprocess.timeout is built-in
- Exceptions provide clear error context
- subprocess.run returns structured result
