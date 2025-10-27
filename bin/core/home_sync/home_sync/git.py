"""Git operations for dotfiles synchronization.

This module provides safe, reliable git operations with proper error handling,
rollback capabilities, and conflict detection. All git commands are executed
without shell injection vulnerabilities and with proper timeout handling.
"""

import subprocess
from contextlib import contextmanager
from enum import StrEnum
from pathlib import Path
from typing import Iterator, List, Optional

from home_sync.logger import setup_logger

logger = setup_logger(__name__)


class GitError(Exception):
    """Base exception for git operations."""

    pass


class GitTimeoutError(GitError):
    """Git operation timed out."""

    pass


class GitConflictError(GitError):
    """Git operation resulted in a conflict."""

    pass


class BranchStatus(StrEnum):
    """Git branch status relative to remote."""

    UP_TO_DATE = "up-to-date"
    AHEAD = "ahead"
    BEHIND = "behind"
    DIVERGED = "diverged"


def run_git(
    args: List[str],
    cwd: Path,
    check: bool = True,
    timeout: int = 30,
) -> subprocess.CompletedProcess:
    """Execute git command safely.

    Args:
        args: Git arguments (without 'git' prefix)
        cwd: Working directory
        check: Raise exception on non-zero exit
        timeout: Command timeout in seconds

    Returns:
        CompletedProcess with stdout, stderr, returncode

    Raises:
        GitTimeoutError: If command times out
        GitError: If command fails and check=True
    """
    if not isinstance(args, list):
        raise TypeError("args must be a list, not a string (prevents shell injection)")

    if not cwd.exists():
        raise GitError(f"Working directory does not exist: {cwd}")

    cmd = ["git", *args]
    logger.debug(f"Running git command: {' '.join(cmd)} in {cwd}")

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

        if result.stdout:
            logger.debug(f"Git stdout: {result.stdout.strip()}")
        if result.stderr:
            logger.debug(f"Git stderr: {result.stderr.strip()}")

        return result

    except subprocess.TimeoutExpired as e:
        error_msg = f"Git command timed out after {timeout}s: {' '.join(cmd)}"
        logger.error(error_msg)
        raise GitTimeoutError(error_msg) from e

    except subprocess.CalledProcessError as e:
        error_msg = (
            f"Git command failed: {' '.join(cmd)}\n"
            f"Exit code: {e.returncode}\n"
            f"Stderr: {e.stderr}"
        )
        logger.error(error_msg)
        raise GitError(error_msg) from e


def is_git_repo(path: Path) -> bool:
    """Check if path is a valid git repository.

    Args:
        path: Directory to check

    Returns:
        True if path is a git repository, False otherwise
    """
    if not path.exists():
        logger.debug(f"Path does not exist: {path}")
        return False

    if not path.is_dir():
        logger.debug(f"Path is not a directory: {path}")
        return False

    try:
        result = run_git(["rev-parse", "--git-dir"], cwd=path, check=False)
        is_repo = result.returncode == 0

        if is_repo:
            logger.debug(f"Valid git repository: {path}")
        else:
            logger.debug(f"Not a git repository: {path}")

        return is_repo

    except (GitError, GitTimeoutError):
        logger.debug(f"Error checking if {path} is a git repository")
        return False


def get_current_commit(repo_path: Path) -> str:
    """Get the current HEAD commit SHA.

    Args:
        repo_path: Path to git repository

    Returns:
        40-character commit SHA

    Raises:
        GitError: If not a git repository or HEAD is invalid
    """
    if not is_git_repo(repo_path):
        raise GitError(f"Not a git repository: {repo_path}")

    result = run_git(["rev-parse", "HEAD"], cwd=repo_path)
    commit_sha = result.stdout.strip()

    if len(commit_sha) != 40:
        raise GitError(f"Invalid commit SHA: {commit_sha}")

    logger.debug(f"Current commit: {commit_sha}")
    return commit_sha


def check_dirty(repo_path: Path) -> bool:
    """Check if repository has uncommitted changes.

    Args:
        repo_path: Path to git repository

    Returns:
        True if repository has uncommitted changes, False if clean

    Raises:
        GitError: If not a git repository
    """
    if not is_git_repo(repo_path):
        raise GitError(f"Not a git repository: {repo_path}")

    # Check both staged and unstaged changes
    result = run_git(["status", "--short"], cwd=repo_path)
    is_dirty = bool(result.stdout.strip())

    if is_dirty:
        logger.debug(f"Repository has uncommitted changes:\n{result.stdout}")
    else:
        logger.debug("Repository is clean")

    return is_dirty


def get_modified_files(repo_path: Path) -> List[str]:
    """Get list of modified files in the repository.

    Args:
        repo_path: Path to git repository

    Returns:
        List of relative file paths with modifications

    Raises:
        GitError: If not a git repository
    """
    if not is_git_repo(repo_path):
        raise GitError(f"Not a git repository: {repo_path}")

    result = run_git(["status", "--short"], cwd=repo_path)
    lines = result.stdout.strip().split("\n")

    # Parse git status output: "?? file.txt" or "M  file.txt"
    modified_files = []
    for line in lines:
        if line.strip():
            # Extract filename from "XY filename" format
            parts = line.strip().split(maxsplit=1)
            if len(parts) == 2:
                modified_files.append(parts[1])

    logger.debug(f"Modified files: {modified_files}")
    return modified_files


@contextmanager
def git_savepoint(repo_path: Path) -> Iterator[str]:
    """Create git savepoint and rollback on error.

    This context manager creates a savepoint (records current commit) and
    automatically rolls back to that commit if an exception occurs within
    the context.

    Usage:
        with git_savepoint(repo):
            # Operations here
            commit_changes()
            push_changes()
            # Automatic rollback on exception

    Args:
        repo_path: Path to git repository

    Yields:
        Current commit SHA (savepoint)

    Raises:
        GitError: If not a git repository
    """
    if not is_git_repo(repo_path):
        raise GitError(f"Not a git repository: {repo_path}")

    # Get current commit as savepoint
    original_commit = get_current_commit(repo_path)
    logger.info(f"Created savepoint at commit {original_commit[:8]}")

    try:
        yield original_commit

    except Exception as e:
        logger.warning(
            f"Operation failed, rolling back to {original_commit[:8]}: {e}"
        )

        try:
            # Reset to savepoint (hard reset)
            run_git(["reset", "--hard", original_commit], cwd=repo_path)

            # Clean up any untracked files from partial operations
            # Note: This only removes untracked files in tracked directories
            run_git(["clean", "-fd"], cwd=repo_path)

            logger.info(f"Successfully rolled back to {original_commit[:8]}")

        except GitError as rollback_error:
            logger.error(f"Rollback failed: {rollback_error}")
            raise GitError(
                f"Original error: {e}\nRollback also failed: {rollback_error}"
            ) from rollback_error

        raise


def get_branch_status(repo_path: Path) -> BranchStatus:
    """Determine branch status relative to remote.

    Compares the local branch with its upstream tracking branch to determine
    if the branches are in sync, ahead, behind, or diverged.

    Args:
        repo_path: Path to git repository

    Returns:
        BranchStatus enum indicating relationship to remote

    Raises:
        GitError: If not a git repository or no upstream branch
    """
    if not is_git_repo(repo_path):
        raise GitError(f"Not a git repository: {repo_path}")

    try:
        # Get local HEAD commit
        local_result = run_git(["rev-parse", "HEAD"], cwd=repo_path)
        local_sha = local_result.stdout.strip()

        # Get remote tracking branch commit
        remote_result = run_git(["rev-parse", "@{u}"], cwd=repo_path)
        remote_sha = remote_result.stdout.strip()

        # Get merge base (common ancestor)
        base_result = run_git(["merge-base", "HEAD", "@{u}"], cwd=repo_path)
        base_sha = base_result.stdout.strip()

        # Determine relationship
        if local_sha == remote_sha:
            logger.debug("Branch is up-to-date with remote")
            return BranchStatus.UP_TO_DATE
        elif local_sha == base_sha:
            logger.debug("Branch is behind remote (can fast-forward)")
            return BranchStatus.BEHIND
        elif remote_sha == base_sha:
            logger.debug("Branch is ahead of remote (need to push)")
            return BranchStatus.AHEAD
        else:
            logger.warning("Branch has diverged from remote (requires manual merge)")
            return BranchStatus.DIVERGED

    except GitError as e:
        # Check if the error is due to no upstream branch
        if "no upstream" in str(e).lower() or "@{u}" in str(e):
            raise GitError(
                f"No upstream branch configured for current branch in {repo_path}"
            ) from e
        raise


def check_conflicts(repo_path: Path) -> bool:
    """Check if repository has merge conflicts.

    Detects unresolved merge conflicts by looking for conflict markers
    in the git status output.

    Args:
        repo_path: Path to git repository

    Returns:
        True if conflicts exist, False otherwise

    Raises:
        GitError: If not a git repository
    """
    if not is_git_repo(repo_path):
        raise GitError(f"Not a git repository: {repo_path}")

    # Check for unmerged paths (conflict markers)
    result = run_git(["status", "--short"], cwd=repo_path)
    status_lines = result.stdout.strip().split("\n")

    # Conflict markers: UU, AA, DD, AU, UA, DU, UD
    conflict_markers = ["UU", "AA", "DD", "AU", "UA", "DU", "UD"]

    for line in status_lines:
        if line.strip():
            status_code = line[:2]
            if status_code in conflict_markers:
                logger.warning(f"Conflict detected: {line.strip()}")
                return True

    logger.debug("No conflicts detected")
    return False


def is_fast_forward_possible(repo_path: Path) -> bool:
    """Check if fast-forward merge is possible.

    A fast-forward is possible when the local branch is behind the remote
    and has no divergent commits (i.e., local is an ancestor of remote).

    Args:
        repo_path: Path to git repository

    Returns:
        True if fast-forward is possible, False otherwise

    Raises:
        GitError: If not a git repository
    """
    if not is_git_repo(repo_path):
        raise GitError(f"Not a git repository: {repo_path}")

    try:
        status = get_branch_status(repo_path)

        # Fast-forward is only possible when behind or up-to-date
        if status == BranchStatus.BEHIND:
            logger.debug("Fast-forward is possible (branch is behind)")
            return True
        elif status == BranchStatus.UP_TO_DATE:
            logger.debug("Fast-forward not needed (already up-to-date)")
            return True
        else:
            logger.debug(f"Fast-forward not possible (status: {status})")
            return False

    except GitError as e:
        logger.warning(f"Cannot determine fast-forward status: {e}")
        return False


def get_ahead_behind_count(repo_path: Path) -> tuple[int, int]:
    """Get commit count ahead and behind remote.

    Args:
        repo_path: Path to git repository

    Returns:
        Tuple of (ahead_count, behind_count)

    Raises:
        GitError: If not a git repository or no upstream branch
    """
    if not is_git_repo(repo_path):
        raise GitError(f"Not a git repository: {repo_path}")

    try:
        # Use git rev-list to count commits
        result = run_git(["rev-list", "--left-right", "--count", "HEAD...@{u}"], cwd=repo_path)
        parts = result.stdout.strip().split()

        if len(parts) == 2:
            ahead = int(parts[0])
            behind = int(parts[1])
            logger.debug(f"Branch is {ahead} ahead, {behind} behind remote")
            return (ahead, behind)
        else:
            raise GitError(f"Unexpected output from rev-list: {result.stdout}")

    except GitError as e:
        if "no upstream" in str(e).lower():
            raise GitError(f"No upstream branch configured in {repo_path}") from e
        raise


def stage_changes(repo_path: Path, files: Optional[List[str]] = None, all_tracked: bool = False) -> None:
    """Stage changes for commit.

    Args:
        repo_path: Path to git repository
        files: List of specific files to stage (relative paths), or None
        all_tracked: If True, stage all tracked files (git add -u)

    Raises:
        GitError: If not a git repository or staging fails
    """
    if not is_git_repo(repo_path):
        raise GitError(f"Not a git repository: {repo_path}")

    if all_tracked:
        # Stage only tracked files (no new files)
        logger.info("Staging all tracked files")
        run_git(["add", "-u"], cwd=repo_path)
    elif files:
        # Stage specific files
        logger.info(f"Staging {len(files)} files")
        run_git(["add", *files], cwd=repo_path)
    else:
        # Stage everything (including new files)
        logger.info("Staging all changes")
        run_git(["add", "."], cwd=repo_path)


def create_commit(repo_path: Path, message: str, allow_empty: bool = False) -> str:
    """Create a git commit with the specified message.

    Args:
        repo_path: Path to git repository
        message: Commit message
        allow_empty: Allow commit with no changes

    Returns:
        Commit SHA of the new commit

    Raises:
        GitError: If not a git repository or commit fails
    """
    if not is_git_repo(repo_path):
        raise GitError(f"Not a git repository: {repo_path}")

    if not message or not message.strip():
        raise ValueError("Commit message cannot be empty")

    # Check if there are staged changes (unless allow_empty is set)
    if not allow_empty:
        result = run_git(["diff", "--cached", "--name-only"], cwd=repo_path)
        if not result.stdout.strip():
            raise GitError("No changes to commit")

    # Build commit command
    cmd = ["commit", "-m", message]
    if allow_empty:
        cmd.append("--allow-empty")

    logger.info(f"Creating commit: {message[:50]}...")
    run_git(cmd, cwd=repo_path)

    new_commit = get_current_commit(repo_path)
    logger.info(f"Created commit {new_commit[:8]}")
    return new_commit


def create_backup_branch(repo_path: Path, prefix: str = "backup") -> str:
    """Create a backup branch at current HEAD.

    Creates a backup branch with a timestamp to preserve the current state
    before potentially destructive operations.

    Args:
        repo_path: Path to git repository
        prefix: Branch name prefix (default: "backup")

    Returns:
        Name of the created backup branch

    Raises:
        GitError: If not a git repository or branch creation fails
    """
    if not is_git_repo(repo_path):
        raise GitError(f"Not a git repository: {repo_path}")

    import datetime

    # Generate timestamp-based branch name
    timestamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    branch_name = f"{prefix}-{timestamp}"

    logger.info(f"Creating backup branch: {branch_name}")

    try:
        # Create branch at current HEAD
        run_git(["branch", branch_name], cwd=repo_path)
        logger.info(f"Backup branch created: {branch_name}")
        return branch_name

    except GitError as e:
        raise GitError(f"Failed to create backup branch: {e}") from e


def get_current_branch(repo_path: Path) -> str:
    """Get the name of the current branch.

    Args:
        repo_path: Path to git repository

    Returns:
        Name of the current branch

    Raises:
        GitError: If not a git repository or detached HEAD
    """
    if not is_git_repo(repo_path):
        raise GitError(f"Not a git repository: {repo_path}")

    try:
        result = run_git(["branch", "--show-current"], cwd=repo_path)
        branch_name = result.stdout.strip()

        if not branch_name:
            raise GitError("HEAD is detached (not on any branch)")

        logger.debug(f"Current branch: {branch_name}")
        return branch_name

    except GitError as e:
        raise GitError(f"Failed to get current branch: {e}") from e


def unstage_all(repo_path: Path) -> None:
    """Unstage all staged changes.

    Args:
        repo_path: Path to git repository

    Raises:
        GitError: If not a git repository
    """
    if not is_git_repo(repo_path):
        raise GitError(f"Not a git repository: {repo_path}")

    logger.info("Unstaging all changes")
    run_git(["reset", "HEAD"], cwd=repo_path)


def is_remote_reachable(repo_path: Path, remote: str = "origin", timeout: int = 10) -> bool:
    """Check if remote repository is reachable.

    Args:
        repo_path: Path to git repository
        remote: Remote name (default: "origin")
        timeout: Network timeout in seconds

    Returns:
        True if remote is reachable, False otherwise
    """
    if not is_git_repo(repo_path):
        raise GitError(f"Not a git repository: {repo_path}")

    try:
        logger.debug(f"Checking connectivity to remote '{remote}'")
        run_git(["ls-remote", "--exit-code", remote], cwd=repo_path, timeout=timeout)
        logger.debug(f"Remote '{remote}' is reachable")
        return True

    except (GitError, GitTimeoutError) as e:
        logger.warning(f"Remote '{remote}' is not reachable: {e}")
        return False


def pull_changes(repo_path: Path, remote: str = "origin", fast_forward_only: bool = True) -> None:
    """Pull changes from remote repository.

    Args:
        repo_path: Path to git repository
        remote: Remote name (default: "origin")
        fast_forward_only: Only allow fast-forward merges (default: True)

    Raises:
        GitError: If not a git repository or pull fails
        GitConflictError: If fast-forward is not possible
    """
    if not is_git_repo(repo_path):
        raise GitError(f"Not a git repository: {repo_path}")

    # Check remote connectivity first
    if not is_remote_reachable(repo_path, remote):
        raise GitError(f"Remote '{remote}' is not reachable")

    # Get current branch
    branch = get_current_branch(repo_path)

    # Build pull command
    cmd = ["pull", remote, branch]
    if fast_forward_only:
        cmd.append("--ff-only")

    logger.info(f"Pulling changes from {remote}/{branch}")

    try:
        run_git(cmd, cwd=repo_path)
        logger.info("Pull completed successfully")

    except GitError as e:
        error_str = str(e).lower()

        # Check for fast-forward conflicts
        if "fast-forward" in error_str or "diverged" in error_str:
            raise GitConflictError(
                f"Cannot fast-forward: local and remote have diverged. "
                f"Manual merge or rebase required."
            ) from e

        # Check for merge conflicts
        if "conflict" in error_str:
            raise GitConflictError(
                f"Merge conflicts detected. Resolve conflicts manually."
            ) from e

        raise


def push_changes(
    repo_path: Path,
    remote: str = "origin",
    force: bool = False,
    set_upstream: bool = False,
) -> None:
    """Push changes to remote repository.

    Args:
        repo_path: Path to git repository
        remote: Remote name (default: "origin")
        force: Force push (default: False, use with caution)
        set_upstream: Set upstream tracking branch (default: False)

    Raises:
        GitError: If not a git repository or push fails
    """
    if not is_git_repo(repo_path):
        raise GitError(f"Not a git repository: {repo_path}")

    # Check remote connectivity first
    if not is_remote_reachable(repo_path, remote):
        raise GitError(f"Remote '{remote}' is not reachable")

    # Get current branch
    branch = get_current_branch(repo_path)

    # Build push command
    cmd = ["push", remote, branch]
    if force:
        logger.warning("Force push enabled - this may overwrite remote changes")
        cmd.append("--force")
    if set_upstream:
        cmd.extend(["--set-upstream", remote, branch])

    logger.info(f"Pushing changes to {remote}/{branch}")

    try:
        run_git(cmd, cwd=repo_path)
        logger.info("Push completed successfully")

    except GitError as e:
        error_str = str(e).lower()

        # Check for rejected push (non-fast-forward)
        if "rejected" in error_str or "non-fast-forward" in error_str:
            raise GitError(
                f"Push rejected: remote has changes not in local branch. "
                f"Pull changes first or use force push."
            ) from e

        raise


def fetch_changes(repo_path: Path, remote: str = "origin") -> None:
    """Fetch changes from remote repository without merging.

    Args:
        repo_path: Path to git repository
        remote: Remote name (default: "origin")

    Raises:
        GitError: If not a git repository or fetch fails
    """
    if not is_git_repo(repo_path):
        raise GitError(f"Not a git repository: {repo_path}")

    # Check remote connectivity first
    if not is_remote_reachable(repo_path, remote):
        raise GitError(f"Remote '{remote}' is not reachable")

    logger.info(f"Fetching changes from {remote}")

    try:
        run_git(["fetch", remote], cwd=repo_path)
        logger.info("Fetch completed successfully")

    except GitError as e:
        raise GitError(f"Failed to fetch from {remote}: {e}") from e
