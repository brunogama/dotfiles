"""Git command wrapper and smart-merge integration.

This module provides a Git command wrapper class and integration with
git-smart-merge for intelligent branch merging.
"""

import shutil
import subprocess
import sys
from pathlib import Path
from typing import Optional

# Add parent's parent to path for bin/lib/ access
sys.path.insert(0, str(Path(__file__).parent.parent.parent))

from git_common import GIT_TIMEOUT, GitError, console


class Git:
    """Git command wrapper with error handling."""

    @staticmethod
    def run(
        *args: str,
        check: bool = True,
        capture_output: bool = True,
        cwd: Optional[Path] = None,
        timeout: int = GIT_TIMEOUT,
    ) -> subprocess.CompletedProcess:
        """Run a git command with proper error handling.

        Args:
            *args: Git command arguments
            check: Raise GitError on non-zero exit code (default: True)
            capture_output: Capture stdout/stderr (default: True)
            cwd: Working directory for command (default: None)
            timeout: Timeout in seconds (default: GIT_TIMEOUT)

        Returns:
            CompletedProcess with result

        Raises:
            GitError: If command fails or times out
        """
        try:
            result = subprocess.run(
                ["git", *args],
                capture_output=capture_output,
                text=True,
                check=check,
                cwd=cwd,
                timeout=timeout,
            )
            return result
        except subprocess.TimeoutExpired as e:
            raise GitError(
                f"Git command timed out after {timeout}s: git {' '.join(args)}"
            ) from e
        except subprocess.CalledProcessError as e:
            if capture_output:
                error_msg = e.stderr.strip() if e.stderr else str(e)
                raise GitError(f"Git command failed: {error_msg}") from e
            raise GitError(f"Git command failed: {e}") from e

    @staticmethod
    def is_repo() -> bool:
        """Check if current directory is a git repository."""
        try:
            Git.run("rev-parse", "--git-dir")
            return True
        except (GitError, subprocess.TimeoutExpired):
            return False

    @staticmethod
    def get_git_dir() -> Path:
        """Get the git directory path."""
        result = Git.run("rev-parse", "--git-dir")
        return Path(result.stdout.strip()).resolve()

    @staticmethod
    def is_detached_head() -> bool:
        """Check if in detached HEAD state."""
        try:
            Git.run("symbolic-ref", "-q", "HEAD")
            return False
        except GitError:
            return True

    @staticmethod
    def get_current_branch() -> str:
        """Get the current branch name."""
        result = Git.run("rev-parse", "--abbrev-ref", "HEAD")
        return result.stdout.strip()

    @staticmethod
    def has_uncommitted_changes(cwd: Optional[Path] = None) -> bool:
        """Check if there are uncommitted changes.

        Args:
            cwd: Directory to check (defaults to current directory)

        Returns:
            True if there are uncommitted changes, False otherwise
        """
        try:
            Git.run("diff-index", "--quiet", "HEAD", "--", cwd=cwd)
            return False
        except GitError:
            return True

    @staticmethod
    def branch_exists(branch: str) -> bool:
        """Check if a branch exists."""
        try:
            Git.run("show-ref", "--verify", "--quiet", f"refs/heads/{branch}")
            return True
        except GitError:
            return False

    @staticmethod
    def remote_branch_exists(branch: str, remote: str = "origin") -> bool:
        """Check if a remote branch exists."""
        try:
            Git.run("rev-parse", "--verify", f"{remote}/{branch}")
            return True
        except GitError:
            return False

    @staticmethod
    def get_user_name() -> str:
        """Get git user name."""
        try:
            result = Git.run("config", "user.name")
            return result.stdout.strip()
        except GitError:
            return "unknown"

    @staticmethod
    def is_branch_in_worktree(branch: str) -> bool:
        """Check if a branch is checked out in any worktree."""
        result = Git.run("worktree", "list")
        return f"[{branch}]" in result.stdout

    @staticmethod
    def has_submodules() -> bool:
        """Check if repository has submodules."""
        return Path(".gitmodules").exists()


def find_git_smart_merge() -> Optional[Path]:
    """Find git-smart-merge script.

    Searches in:
    1. System PATH
    2. Same directory as this script (bin/git/)
    3. Parent bin/ directory

    Returns:
        Path to git-smart-merge if found, None otherwise
    """
    # Try PATH first
    path_result = shutil.which("git-smart-merge")
    if path_result:
        return Path(path_result)

    # Try same directory as this script
    script_dir = Path(__file__).parent.parent  # bin/git/
    same_dir = script_dir / "git-smart-merge"
    if same_dir.exists():
        return same_dir

    # Try parent bin/ directory
    parent_bin = script_dir.parent / "git-smart-merge"
    if parent_bin.exists():
        return parent_bin

    return None


def run_git_smart_merge(
    feature_branch: str,
    force_rebase: bool = False,
    force_merge: bool = False,
    dry_run: bool = False,
) -> int:
    """Run git-smart-merge to integrate feature branch.

    Args:
        feature_branch: Name of feature branch to merge
        force_rebase: Force rebase without conflict detection
        force_merge: Force merge without trying rebase
        dry_run: Preview strategy without executing

    Returns:
        Exit code from git-smart-merge (0=success, 1=error, 2=usage)
    """
    smart_merge_path = find_git_smart_merge()

    if not smart_merge_path:
        console.print(
            "[red]Error:[/red] git-smart-merge not found\n\n"
            "Install git-smart-merge or add bin/ directory to PATH:\n"
            "  export PATH=\"$HOME/.dotfiles/bin:$PATH\""
        )
        return 1

    console.print(f"[dim]Using git-smart-merge from:[/dim] {smart_merge_path}")

    # Build command
    cmd = [str(smart_merge_path), feature_branch]

    if dry_run:
        cmd.append("--dry-run")
    elif force_rebase:
        cmd.append("--force-rebase")
    elif force_merge:
        cmd.append("--force-merge")

    # Run git-smart-merge (capture_output=False for live output)
    try:
        result = subprocess.run(
            cmd,
            capture_output=False,
            text=True,
        )
        return result.returncode
    except FileNotFoundError:
        console.print("[red]Error:[/red] Failed to execute git-smart-merge")
        return 1
    except Exception as e:
        console.print(
            f"[red]Error:[/red] Unexpected error running git-smart-merge: {e}"
        )
        return 1
