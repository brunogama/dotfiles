"""Unit tests for dotfiles sync setup.

Tests cover:
- SyncConfig validation
- DotfilesSync initialization
- Prerequisite validation
- Status checking
- Sync readiness checks
"""

import subprocess
from pathlib import Path
from unittest.mock import MagicMock, patch

import pytest

from home_sync.dotfiles import (
    DotfilesSync,
    DotfilesSyncError,
    SyncConfig,
)
from home_sync.git import BranchStatus


@pytest.fixture
def temp_git_repo(tmp_path: Path) -> Path:
    """Create a temporary git repository for testing.

    Args:
        tmp_path: pytest temporary directory fixture

    Returns:
        Path to temporary git repository
    """
    repo = tmp_path / "test_repo"
    repo.mkdir()

    # Initialize git repo
    subprocess.run(["git", "init"], cwd=repo, check=True, capture_output=True)
    subprocess.run(
        ["git", "config", "user.email", "test@example.com"],
        cwd=repo,
        check=True,
        capture_output=True,
    )
    subprocess.run(
        ["git", "config", "user.name", "Test User"],
        cwd=repo,
        check=True,
        capture_output=True,
    )

    # Create initial commit
    (repo / "README.md").write_text("# Test Repository\n")
    subprocess.run(["git", "add", "."], cwd=repo, check=True, capture_output=True)
    subprocess.run(
        ["git", "commit", "-m", "Initial commit"],
        cwd=repo,
        check=True,
        capture_output=True,
    )

    return repo


class TestSyncConfig:
    """Test SyncConfig dataclass."""

    def test_sync_config_defaults(self, temp_git_repo: Path) -> None:
        """Test sync config with default values."""
        config = SyncConfig(repo_path=temp_git_repo)

        assert config.repo_path == temp_git_repo
        assert config.dry_run is False
        assert config.force_commit is False
        assert config.remote == "origin"
        assert config.skip_push is False
        assert config.skip_pull is False

    def test_sync_config_custom_values(self, temp_git_repo: Path) -> None:
        """Test sync config with custom values."""
        config = SyncConfig(
            repo_path=temp_git_repo,
            dry_run=True,
            force_commit=True,
            remote="upstream",
            skip_push=True,
            skip_pull=True,
        )

        assert config.dry_run is True
        assert config.force_commit is True
        assert config.remote == "upstream"
        assert config.skip_push is True
        assert config.skip_pull is True

    def test_sync_config_path_expansion(self, tmp_path: Path) -> None:
        """Test that paths are expanded and resolved."""
        # Use ~ in path (will be expanded)
        config = SyncConfig(repo_path=Path("~"))

        # Path should be expanded
        assert "~" not in str(config.repo_path)
        assert config.repo_path.is_absolute()

    def test_sync_config_string_path(self, temp_git_repo: Path) -> None:
        """Test that string paths are converted to Path objects."""
        config = SyncConfig(repo_path=str(temp_git_repo))

        assert isinstance(config.repo_path, Path)
        assert config.repo_path == temp_git_repo


class TestDotfilesSyncInit:
    """Test DotfilesSync initialization."""

    def test_init_success(self, temp_git_repo: Path) -> None:
        """Test successful initialization."""
        config = SyncConfig(repo_path=temp_git_repo)
        sync = DotfilesSync(config)

        assert sync.config == config
        assert sync.metrics is not None
        assert sync.metrics.operation == "dotfiles_sync"

    def test_init_dry_run_mode(self, temp_git_repo: Path) -> None:
        """Test initialization in dry-run mode."""
        config = SyncConfig(repo_path=temp_git_repo, dry_run=True)
        sync = DotfilesSync(config)

        assert sync.config.dry_run is True


class TestValidatePrerequisites:
    """Test validate_prerequisites() method."""

    def test_validate_prerequisites_success(self, temp_git_repo: Path) -> None:
        """Test successful prerequisite validation."""
        config = SyncConfig(repo_path=temp_git_repo, skip_pull=True, skip_push=True)
        sync = DotfilesSync(config)

        # Should not raise exception
        sync.validate_prerequisites()

    def test_validate_prerequisites_path_not_exist(self, tmp_path: Path) -> None:
        """Test validation with nonexistent path."""
        nonexistent = tmp_path / "does_not_exist"
        config = SyncConfig(repo_path=nonexistent)
        sync = DotfilesSync(config)

        with pytest.raises(DotfilesSyncError) as exc_info:
            sync.validate_prerequisites()

        assert "does not exist" in str(exc_info.value)

    def test_validate_prerequisites_not_git_repo(self, tmp_path: Path) -> None:
        """Test validation with non-git directory."""
        config = SyncConfig(repo_path=tmp_path)
        sync = DotfilesSync(config)

        with pytest.raises(DotfilesSyncError) as exc_info:
            sync.validate_prerequisites()

        assert "Not a git repository" in str(exc_info.value)

    def test_validate_prerequisites_detached_head(self, temp_git_repo: Path) -> None:
        """Test validation with detached HEAD."""
        # Get current commit SHA
        result = subprocess.run(
            ["git", "rev-parse", "HEAD"],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
            text=True,
        )
        commit_sha = result.stdout.strip()

        # Checkout specific commit (detached HEAD)
        subprocess.run(
            ["git", "checkout", commit_sha],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
        )

        config = SyncConfig(repo_path=temp_git_repo, skip_pull=True, skip_push=True)
        sync = DotfilesSync(config)

        with pytest.raises(DotfilesSyncError) as exc_info:
            sync.validate_prerequisites()

        assert "current branch" in str(exc_info.value).lower()

    def test_validate_prerequisites_remote_unreachable(
        self, temp_git_repo: Path
    ) -> None:
        """Test validation with unreachable remote."""
        # Add fake remote
        subprocess.run(
            ["git", "remote", "add", "origin", "https://doesnotexist.invalid/repo.git"],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
        )

        config = SyncConfig(repo_path=temp_git_repo)
        sync = DotfilesSync(config)

        with pytest.raises(DotfilesSyncError) as exc_info:
            sync.validate_prerequisites()

        assert "not reachable" in str(exc_info.value)

    def test_validate_prerequisites_remote_unreachable_dry_run(
        self, temp_git_repo: Path
    ) -> None:
        """Test validation with unreachable remote in dry-run mode."""
        # Add fake remote
        subprocess.run(
            ["git", "remote", "add", "origin", "https://doesnotexist.invalid/repo.git"],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
        )

        config = SyncConfig(repo_path=temp_git_repo, dry_run=True)
        sync = DotfilesSync(config)

        # Should not raise exception in dry-run mode
        sync.validate_prerequisites()


class TestCheckStatus:
    """Test check_status() method."""

    def test_check_status_clean_repo(self, temp_git_repo: Path) -> None:
        """Test status check on clean repository."""
        config = SyncConfig(repo_path=temp_git_repo, skip_pull=True, skip_push=True)
        sync = DotfilesSync(config)

        status = sync.check_status()

        assert status["is_dirty"] is False
        assert status["current_branch"] in ["main", "master"]
        assert status["branch_status"] is None  # skipped

    def test_check_status_dirty_repo(self, temp_git_repo: Path) -> None:
        """Test status check on dirty repository."""
        # Make a change
        (temp_git_repo / "file.txt").write_text("content\n")

        config = SyncConfig(repo_path=temp_git_repo, skip_pull=True, skip_push=True)
        sync = DotfilesSync(config)

        status = sync.check_status()

        assert status["is_dirty"] is True

    def test_check_status_with_branch_status(self, temp_git_repo: Path) -> None:
        """Test status check with branch status."""
        # Add a fake remote for branch status
        subprocess.run(
            ["git", "remote", "add", "origin", str(temp_git_repo / ".git")],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
        )

        config = SyncConfig(repo_path=temp_git_repo)
        sync = DotfilesSync(config)

        # Mock is_remote_reachable to return True
        with patch("home_sync.dotfiles.is_remote_reachable", return_value=True):
            # Mock get_branch_status to return UP_TO_DATE
            with patch(
                "home_sync.dotfiles.get_branch_status",
                return_value=BranchStatus.UP_TO_DATE,
            ):
                status = sync.check_status()

        assert status["branch_status"] == BranchStatus.UP_TO_DATE


class TestCanSync:
    """Test can_sync() method."""

    def test_can_sync_clean_repo(self, temp_git_repo: Path) -> None:
        """Test can_sync on clean repository."""
        config = SyncConfig(repo_path=temp_git_repo, skip_pull=True, skip_push=True)
        sync = DotfilesSync(config)

        can_sync, reason = sync.can_sync()

        assert can_sync is True
        assert reason is None

    def test_can_sync_dirty_without_force(self, temp_git_repo: Path) -> None:
        """Test can_sync on dirty repository without force."""
        # Make a change
        (temp_git_repo / "file.txt").write_text("content\n")

        config = SyncConfig(
            repo_path=temp_git_repo, force_commit=False, skip_pull=True, skip_push=True
        )
        sync = DotfilesSync(config)

        can_sync, reason = sync.can_sync()

        assert can_sync is False
        assert "uncommitted changes" in reason.lower()

    def test_can_sync_dirty_with_force(self, temp_git_repo: Path) -> None:
        """Test can_sync on dirty repository with force."""
        # Make a change
        (temp_git_repo / "file.txt").write_text("content\n")

        config = SyncConfig(
            repo_path=temp_git_repo, force_commit=True, skip_pull=True, skip_push=True
        )
        sync = DotfilesSync(config)

        can_sync, reason = sync.can_sync()

        assert can_sync is True
        assert reason is None

    def test_can_sync_diverged_branches(self, temp_git_repo: Path) -> None:
        """Test can_sync with diverged branches."""
        config = SyncConfig(repo_path=temp_git_repo)
        sync = DotfilesSync(config)

        # Mock check_status to return diverged
        with patch.object(
            sync,
            "check_status",
            return_value={
                "is_dirty": False,
                "branch_status": BranchStatus.DIVERGED,
                "current_branch": "main",
            },
        ):
            can_sync, reason = sync.can_sync()

        assert can_sync is False
        assert "diverged" in reason.lower()

    def test_can_sync_ahead_of_remote(self, temp_git_repo: Path) -> None:
        """Test can_sync when ahead of remote."""
        config = SyncConfig(repo_path=temp_git_repo, skip_pull=True, skip_push=True)
        sync = DotfilesSync(config)

        # Mock check_status to return ahead
        with patch.object(
            sync,
            "check_status",
            return_value={
                "is_dirty": False,
                "branch_status": BranchStatus.AHEAD,
                "current_branch": "main",
            },
        ):
            can_sync, reason = sync.can_sync()

        # Should be able to sync even when ahead
        assert can_sync is True
        assert reason is None

    def test_can_sync_behind_remote(self, temp_git_repo: Path) -> None:
        """Test can_sync when behind remote."""
        config = SyncConfig(repo_path=temp_git_repo, skip_pull=True, skip_push=True)
        sync = DotfilesSync(config)

        # Mock check_status to return behind
        with patch.object(
            sync,
            "check_status",
            return_value={
                "is_dirty": False,
                "branch_status": BranchStatus.BEHIND,
                "current_branch": "main",
            },
        ):
            can_sync, reason = sync.can_sync()

        # Should be able to sync when behind
        assert can_sync is True
        assert reason is None
