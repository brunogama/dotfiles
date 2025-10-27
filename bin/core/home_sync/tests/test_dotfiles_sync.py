"""Integration tests for dotfiles full sync.

Tests cover:
- Full sync workflow with clean repository
- Sync with uncommitted changes (auto-commit)
- Sync with diverged branches
- Dry-run mode
- Savepoint/rollback on failure
"""

import subprocess
from pathlib import Path

import pytest

from home_sync.dotfiles import (
    DotfilesSync,
    DotfilesSyncError,
    SyncConfig,
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

    # Get current branch name
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


class TestFullSync:
    """Test full sync workflow."""

    def test_sync_clean_repo(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test sync with clean repository."""
        local, _ = git_repo_with_remote

        config = SyncConfig(repo_path=local)
        sync = DotfilesSync(config)

        metrics = sync.sync()

        assert metrics.success is True
        assert metrics.error_message is None
        assert metrics.commits_created == 0

    def test_sync_with_auto_commit(
        self, git_repo_with_remote: tuple[Path, Path]
    ) -> None:
        """Test sync with uncommitted changes (auto-commit)."""
        local, _ = git_repo_with_remote

        # Make a change
        (local / "file.txt").write_text("content\n")

        config = SyncConfig(repo_path=local, force_commit=True)
        sync = DotfilesSync(config)

        metrics = sync.sync()

        assert metrics.success is True
        assert metrics.commits_created == 1

        # Verify file was committed
        result = subprocess.run(
            ["git", "log", "-1", "--pretty=%B"],
            cwd=local,
            check=True,
            capture_output=True,
            text=True,
        )
        assert "Auto-commit" in result.stdout

    def test_sync_dirty_without_force(
        self, git_repo_with_remote: tuple[Path, Path]
    ) -> None:
        """Test sync with uncommitted changes without force fails."""
        local, _ = git_repo_with_remote

        # Make a change
        (local / "file.txt").write_text("content\n")

        config = SyncConfig(repo_path=local, force_commit=False)
        sync = DotfilesSync(config)

        with pytest.raises(DotfilesSyncError) as exc_info:
            sync.sync()

        assert "uncommitted changes" in str(exc_info.value).lower()

    def test_sync_dry_run(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test sync in dry-run mode."""
        local, _ = git_repo_with_remote

        # Make a change
        (local / "file.txt").write_text("content\n")

        config = SyncConfig(repo_path=local, dry_run=True, force_commit=True)
        sync = DotfilesSync(config)

        metrics = sync.sync()

        assert metrics.success is True

        # Verify no actual changes were made
        result = subprocess.run(
            ["git", "status", "--short"],
            cwd=local,
            check=True,
            capture_output=True,
            text=True,
        )
        assert "file.txt" in result.stdout  # File still untracked

    def test_sync_creates_backup_branch(
        self, git_repo_with_remote: tuple[Path, Path]
    ) -> None:
        """Test sync creates backup branch before force operations."""
        local, _ = git_repo_with_remote

        # Make a change
        (local / "file.txt").write_text("content\n")

        config = SyncConfig(repo_path=local, force_commit=True)
        sync = DotfilesSync(config)

        sync.sync()

        # Verify backup branch was created
        result = subprocess.run(
            ["git", "branch", "--list", "backup-*"],
            cwd=local,
            check=True,
            capture_output=True,
            text=True,
        )
        assert "backup-" in result.stdout

    def test_sync_with_pull(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test sync pulls changes from remote."""
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

        (local2 / "remote_file.txt").write_text("remote content\n")
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

        # Sync in original local repo
        config = SyncConfig(repo_path=local)
        sync = DotfilesSync(config)

        metrics = sync.sync()

        assert metrics.success is True

        # Verify remote file was pulled
        assert (local / "remote_file.txt").exists()

    def test_sync_with_push(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test sync pushes local changes to remote."""
        local, remote = git_repo_with_remote

        # Make local change
        (local / "local_file.txt").write_text("local content\n")

        config = SyncConfig(repo_path=local, force_commit=True)
        sync = DotfilesSync(config)

        metrics = sync.sync()

        assert metrics.success is True

        # Verify changes were pushed by cloning and checking
        local2 = local.parent / "local2"
        subprocess.run(
            ["git", "clone", str(remote), str(local2)],
            check=True,
            capture_output=True,
        )
        assert (local2 / "local_file.txt").exists()

    def test_sync_skip_pull(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test sync with skip_pull flag (no remote changes)."""
        local, _ = git_repo_with_remote

        # Sync with skip_pull (no remote changes, should work)
        config = SyncConfig(repo_path=local, skip_pull=True)
        sync = DotfilesSync(config)

        metrics = sync.sync()

        assert metrics.success is True

    def test_sync_skip_push(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test sync with skip_push flag."""
        local, remote = git_repo_with_remote

        # Make local change
        (local / "local_file.txt").write_text("local content\n")

        config = SyncConfig(
            repo_path=local, force_commit=True, skip_push=True, skip_pull=True
        )
        sync = DotfilesSync(config)

        metrics = sync.sync()

        assert metrics.success is True

        # Verify changes were NOT pushed
        local2 = local.parent / "local2"
        subprocess.run(
            ["git", "clone", str(remote), str(local2)],
            check=True,
            capture_output=True,
        )
        assert not (local2 / "local_file.txt").exists()

    def test_sync_diverged_branches_fails(
        self, git_repo_with_remote: tuple[Path, Path]
    ) -> None:
        """Test sync fails when branches have diverged."""
        local, remote = git_repo_with_remote

        # Create local commit
        (local / "local.txt").write_text("local\n")
        subprocess.run(["git", "add", "."], cwd=local, check=True, capture_output=True)
        subprocess.run(
            ["git", "commit", "-m", "Local commit"],
            cwd=local,
            check=True,
            capture_output=True,
        )

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

        # Sync should fail due to divergence
        config = SyncConfig(repo_path=local)
        sync = DotfilesSync(config)

        with pytest.raises(DotfilesSyncError) as exc_info:
            sync.sync()

        assert "diverged" in str(exc_info.value).lower()

    def test_sync_rollback_on_failure(
        self, git_repo_with_remote: tuple[Path, Path]
    ) -> None:
        """Test sync rolls back changes on failure."""
        local, _ = git_repo_with_remote

        # Get initial commit
        result = subprocess.run(
            ["git", "rev-parse", "HEAD"],
            cwd=local,
            check=True,
            capture_output=True,
            text=True,
        )
        initial_commit = result.stdout.strip()

        # Make a change
        (local / "file.txt").write_text("content\n")

        # Configure sync to fail during push (fake remote)
        subprocess.run(
            ["git", "remote", "set-url", "origin", "https://doesnotexist.invalid/repo.git"],
            cwd=local,
            check=True,
            capture_output=True,
        )

        config = SyncConfig(repo_path=local, force_commit=True, skip_pull=True)
        sync = DotfilesSync(config)

        with pytest.raises(DotfilesSyncError):
            sync.sync()

        # Verify rollback happened (back to initial commit)
        result = subprocess.run(
            ["git", "rev-parse", "HEAD"],
            cwd=local,
            check=True,
            capture_output=True,
            text=True,
        )
        current_commit = result.stdout.strip()

        assert current_commit == initial_commit

    def test_sync_metrics(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test sync updates metrics correctly."""
        local, _ = git_repo_with_remote

        # Make a change
        (local / "file.txt").write_text("content\n")

        config = SyncConfig(repo_path=local, force_commit=True)
        sync = DotfilesSync(config)

        metrics = sync.sync()

        assert metrics.success is True
        assert metrics.operation == "dotfiles_sync"
        assert metrics.duration_seconds is not None
        assert metrics.duration_seconds > 0
        assert metrics.commits_created == 1
