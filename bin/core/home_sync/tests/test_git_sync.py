"""Integration tests for git sync operations.

Tests cover:
- Remote connectivity checking
- Pulling changes (fast-forward only)
- Pushing changes
- Fetching changes
- Error handling for network failures and conflicts
"""

import subprocess
from pathlib import Path
from unittest.mock import patch

import pytest

from home_sync.git import (
    GitConflictError,
    GitError,
    fetch_changes,
    is_remote_reachable,
    pull_changes,
    push_changes,
    stage_changes,
    create_commit,
)


@pytest.fixture
def git_repo_with_remote(tmp_path: Path) -> tuple[Path, Path]:
    """Create two git repositories (local and remote) for testing.

    Args:
        tmp_path: pytest temporary directory fixture

    Returns:
        Tuple of (local_repo, remote_repo) paths
    """
    # Create remote (bare) repository
    remote = tmp_path / "remote.git"
    remote.mkdir()
    subprocess.run(["git", "init", "--bare"], cwd=remote, check=True, capture_output=True)

    # Create local repository
    local = tmp_path / "local"
    local.mkdir()
    subprocess.run(["git", "init"], cwd=local, check=True, capture_output=True)
    subprocess.run(
        ["git", "config", "user.email", "test@example.com"],
        cwd=local,
        check=True,
        capture_output=True,
    )
    subprocess.run(
        ["git", "config", "user.name", "Test User"],
        cwd=local,
        check=True,
        capture_output=True,
    )

    # Create initial commit
    (local / "README.md").write_text("# Test Repository\n")
    subprocess.run(["git", "add", "."], cwd=local, check=True, capture_output=True)
    subprocess.run(
        ["git", "commit", "-m", "Initial commit"],
        cwd=local,
        check=True,
        capture_output=True,
    )

    # Set up remote tracking
    subprocess.run(
        ["git", "remote", "add", "origin", str(remote)],
        cwd=local,
        check=True,
        capture_output=True,
    )

    # Get current branch name (could be main or master)
    result = subprocess.run(
        ["git", "branch", "--show-current"],
        cwd=local,
        check=True,
        capture_output=True,
        text=True,
    )
    branch_name = result.stdout.strip()

    subprocess.run(
        ["git", "push", "-u", "origin", branch_name],
        cwd=local,
        check=True,
        capture_output=True,
    )

    return local, remote


class TestIsRemoteReachable:
    """Test is_remote_reachable() connectivity checking."""

    def test_remote_reachable_success(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test checking reachable remote."""
        local, _ = git_repo_with_remote
        assert is_remote_reachable(local) is True

    def test_remote_unreachable(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test checking unreachable remote."""
        local, _ = git_repo_with_remote

        # Add a fake remote that doesn't exist
        subprocess.run(
            ["git", "remote", "add", "fake", "https://doesnotexist.invalid/repo.git"],
            cwd=local,
            check=True,
            capture_output=True,
        )

        assert is_remote_reachable(local, remote="fake", timeout=2) is False

    def test_remote_reachable_timeout(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test remote connectivity with timeout."""
        local, _ = git_repo_with_remote

        # Mock to simulate timeout only for ls-remote command
        original_run_git = __import__('home_sync.git', fromlist=['run_git']).run_git

        def mock_run_git_timeout(args, cwd, **kwargs):
            # Only timeout on ls-remote, allow other commands
            if args[0] == "ls-remote":
                from home_sync.git import GitTimeoutError
                raise GitTimeoutError("Timeout")
            return original_run_git(args, cwd, **kwargs)

        with patch("home_sync.git.run_git", side_effect=mock_run_git_timeout):
            assert is_remote_reachable(local, timeout=1) is False


class TestFetchChanges:
    """Test fetch_changes() functionality."""

    def test_fetch_changes_success(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test successful fetch."""
        local, remote = git_repo_with_remote

        # Create commit in a second local repo and push
        local2 = local.parent / "local2"
        subprocess.run(
            ["git", "clone", str(remote), str(local2)],
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "config", "user.email", "test@example.com"],
            cwd=local2,
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "config", "user.name", "Test User"],
            cwd=local2,
            check=True,
            capture_output=True,
        )

        (local2 / "file.txt").write_text("content\n")
        subprocess.run(["git", "add", "."], cwd=local2, check=True, capture_output=True)
        subprocess.run(
            ["git", "commit", "-m", "New commit"],
            cwd=local2,
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "push"], cwd=local2, check=True, capture_output=True
        )

        # Fetch in original local
        fetch_changes(local)

        # Verify fetch succeeded (check remote tracking branch)
        result = subprocess.run(
            ["git", "rev-parse", "origin/HEAD"],
            cwd=local,
            check=True,
            capture_output=True,
            text=True,
        )
        assert len(result.stdout.strip()) == 40  # SHA

    def test_fetch_changes_unreachable_remote(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test fetch with unreachable remote."""
        local, _ = git_repo_with_remote

        # Add fake remote
        subprocess.run(
            ["git", "remote", "add", "fake", "https://doesnotexist.invalid/repo.git"],
            cwd=local,
            check=True,
            capture_output=True,
        )

        with pytest.raises(GitError) as exc_info:
            fetch_changes(local, remote="fake")

        assert "not reachable" in str(exc_info.value)


class TestPullChanges:
    """Test pull_changes() functionality."""

    def test_pull_changes_fast_forward(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test pull with fast-forward."""
        local, remote = git_repo_with_remote

        # Create commit in remote
        local2 = local.parent / "local2"
        subprocess.run(
            ["git", "clone", str(remote), str(local2)],
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "config", "user.email", "test@example.com"],
            cwd=local2,
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "config", "user.name", "Test User"],
            cwd=local2,
            check=True,
            capture_output=True,
        )

        (local2 / "file.txt").write_text("content\n")
        subprocess.run(["git", "add", "."], cwd=local2, check=True, capture_output=True)
        subprocess.run(
            ["git", "commit", "-m", "Remote commit"],
            cwd=local2,
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "push"], cwd=local2, check=True, capture_output=True
        )

        # Pull in original local
        pull_changes(local)

        # Verify file exists after pull
        assert (local / "file.txt").exists()

    def test_pull_changes_up_to_date(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test pull when already up-to-date."""
        local, _ = git_repo_with_remote

        # Pull should succeed (already up-to-date)
        pull_changes(local)

    def test_pull_changes_diverged(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test pull with diverged branches."""
        local, remote = git_repo_with_remote

        # Create local commit
        (local / "local.txt").write_text("local\n")
        stage_changes(local)
        create_commit(local, "Local commit")

        # Create remote commit
        local2 = local.parent / "local2"
        subprocess.run(
            ["git", "clone", str(remote), str(local2)],
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "config", "user.email", "test@example.com"],
            cwd=local2,
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "config", "user.name", "Test User"],
            cwd=local2,
            check=True,
            capture_output=True,
        )

        (local2 / "remote.txt").write_text("remote\n")
        subprocess.run(["git", "add", "."], cwd=local2, check=True, capture_output=True)
        subprocess.run(
            ["git", "commit", "-m", "Remote commit"],
            cwd=local2,
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "push"], cwd=local2, check=True, capture_output=True
        )

        # Pull should fail due to divergence
        with pytest.raises(GitConflictError) as exc_info:
            pull_changes(local)

        assert "diverged" in str(exc_info.value).lower()

    def test_pull_changes_unreachable_remote(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test pull with unreachable remote."""
        local, _ = git_repo_with_remote

        # Add fake remote
        subprocess.run(
            ["git", "remote", "add", "fake", "https://doesnotexist.invalid/repo.git"],
            cwd=local,
            check=True,
            capture_output=True,
        )

        with pytest.raises(GitError) as exc_info:
            pull_changes(local, remote="fake")

        assert "not reachable" in str(exc_info.value)


class TestPushChanges:
    """Test push_changes() functionality."""

    def test_push_changes_success(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test successful push."""
        local, _ = git_repo_with_remote

        # Create local commit
        (local / "file.txt").write_text("content\n")
        stage_changes(local)
        create_commit(local, "New commit")

        # Push changes
        push_changes(local)

        # Verify push succeeded by cloning and checking file exists
        local2 = local.parent / "local2"
        subprocess.run(
            ["git", "clone", str(local.parent / "remote.git"), str(local2)],
            check=True,
            capture_output=True,
        )
        assert (local2 / "file.txt").exists()

    def test_push_changes_up_to_date(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test push when already up-to-date."""
        local, _ = git_repo_with_remote

        # Push should succeed (already up-to-date)
        push_changes(local)

    def test_push_changes_rejected(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test push rejected (non-fast-forward)."""
        local, remote = git_repo_with_remote

        # Create remote commit first
        local2 = local.parent / "local2"
        subprocess.run(
            ["git", "clone", str(remote), str(local2)],
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "config", "user.email", "test@example.com"],
            cwd=local2,
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "config", "user.name", "Test User"],
            cwd=local2,
            check=True,
            capture_output=True,
        )

        (local2 / "remote.txt").write_text("remote\n")
        subprocess.run(["git", "add", "."], cwd=local2, check=True, capture_output=True)
        subprocess.run(
            ["git", "commit", "-m", "Remote commit"],
            cwd=local2,
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "push"], cwd=local2, check=True, capture_output=True
        )

        # Create local commit (without pulling remote changes)
        (local / "local.txt").write_text("local\n")
        stage_changes(local)
        create_commit(local, "Local commit")

        # Push should be rejected
        with pytest.raises(GitError) as exc_info:
            push_changes(local)

        assert "rejected" in str(exc_info.value).lower()

    def test_push_changes_force(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test force push."""
        local, remote = git_repo_with_remote

        # Create remote commit first
        local2 = local.parent / "local2"
        subprocess.run(
            ["git", "clone", str(remote), str(local2)],
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "config", "user.email", "test@example.com"],
            cwd=local2,
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "config", "user.name", "Test User"],
            cwd=local2,
            check=True,
            capture_output=True,
        )

        (local2 / "remote.txt").write_text("remote\n")
        subprocess.run(["git", "add", "."], cwd=local2, check=True, capture_output=True)
        subprocess.run(
            ["git", "commit", "-m", "Remote commit"],
            cwd=local2,
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "push"], cwd=local2, check=True, capture_output=True
        )

        # Create local commit (without pulling remote changes)
        (local / "local.txt").write_text("local\n")
        stage_changes(local)
        create_commit(local, "Local commit")

        # Force push should succeed
        push_changes(local, force=True)

    def test_push_changes_unreachable_remote(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test push with unreachable remote."""
        local, _ = git_repo_with_remote

        # Add fake remote
        subprocess.run(
            ["git", "remote", "add", "fake", "https://doesnotexist.invalid/repo.git"],
            cwd=local,
            check=True,
            capture_output=True,
        )

        with pytest.raises(GitError) as exc_info:
            push_changes(local, remote="fake")

        assert "not reachable" in str(exc_info.value)
