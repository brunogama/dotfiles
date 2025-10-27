"""Integration tests for git status checking.

Tests cover:
- Branch status detection (ahead, behind, diverged, up-to-date)
- Conflict detection
- Fast-forward checking
- Ahead/behind commit counting
"""

import subprocess
from pathlib import Path

import pytest

from home_sync.git import (
    BranchStatus,
    GitError,
    check_conflicts,
    get_ahead_behind_count,
    get_branch_status,
    is_fast_forward_possible,
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


class TestGetBranchStatus:
    """Test get_branch_status() branch relationship detection."""

    def test_branch_status_up_to_date(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test up-to-date branch status."""
        local, _ = git_repo_with_remote

        status = get_branch_status(local)
        assert status == BranchStatus.UP_TO_DATE

    def test_branch_status_ahead(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test branch ahead of remote."""
        local, _ = git_repo_with_remote

        # Create local commit
        (local / "file.txt").write_text("content\n")
        subprocess.run(["git", "add", "."], cwd=local, check=True, capture_output=True)
        subprocess.run(
            ["git", "commit", "-m", "Local commit"],
            cwd=local,
            check=True,
            capture_output=True,
        )

        status = get_branch_status(local)
        assert status == BranchStatus.AHEAD

    def test_branch_status_behind(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test branch behind remote."""
        local, remote = git_repo_with_remote

        # Clone a second local repo to make changes
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

        # Make commit in local2 and push
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

        # Fetch in original local repo
        subprocess.run(["git", "fetch"], cwd=local, check=True, capture_output=True)

        status = get_branch_status(local)
        assert status == BranchStatus.BEHIND

    def test_branch_status_diverged(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test diverged branches."""
        local, remote = git_repo_with_remote

        # Create commit in local
        (local / "local_file.txt").write_text("local content\n")
        subprocess.run(["git", "add", "."], cwd=local, check=True, capture_output=True)
        subprocess.run(
            ["git", "commit", "-m", "Local commit"],
            cwd=local,
            check=True,
            capture_output=True,
        )

        # Clone a second local repo and make different commit
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

        # Fetch in original local repo
        subprocess.run(["git", "fetch"], cwd=local, check=True, capture_output=True)

        status = get_branch_status(local)
        assert status == BranchStatus.DIVERGED

    def test_branch_status_no_upstream(self, tmp_path: Path) -> None:
        """Test branch with no upstream configured."""
        # Create repo without remote
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

        (local / "README.md").write_text("# Test\n")
        subprocess.run(["git", "add", "."], cwd=local, check=True, capture_output=True)
        subprocess.run(
            ["git", "commit", "-m", "Initial"],
            cwd=local,
            check=True,
            capture_output=True,
        )

        with pytest.raises(GitError) as exc_info:
            get_branch_status(local)

        assert "No upstream branch" in str(exc_info.value)


class TestCheckConflicts:
    """Test check_conflicts() conflict detection."""

    def test_no_conflicts_clean_repo(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test conflict detection on clean repository."""
        local, _ = git_repo_with_remote
        assert check_conflicts(local) is False

    def test_no_conflicts_with_changes(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test conflict detection with uncommitted changes (not conflicts)."""
        local, _ = git_repo_with_remote

        (local / "file.txt").write_text("content\n")
        assert check_conflicts(local) is False

    def test_conflicts_detected(self, git_repo_with_remote: tuple[Path, Path]) -> None:
        """Test conflict detection during merge."""
        local, remote = git_repo_with_remote

        # Create conflicting changes in two branches
        # Branch 1: modify README
        (local / "README.md").write_text("# Version 1\n")
        subprocess.run(["git", "add", "."], cwd=local, check=True, capture_output=True)
        subprocess.run(
            ["git", "commit", "-m", "Version 1"],
            cwd=local,
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "branch", "branch1"], cwd=local, check=True, capture_output=True
        )

        # Branch 2: modify README differently
        subprocess.run(
            ["git", "checkout", "-b", "branch2"],
            cwd=local,
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "reset", "--hard", "HEAD~1"],
            cwd=local,
            check=True,
            capture_output=True,
        )
        (local / "README.md").write_text("# Version 2\n")
        subprocess.run(["git", "add", "."], cwd=local, check=True, capture_output=True)
        subprocess.run(
            ["git", "commit", "-m", "Version 2"],
            cwd=local,
            check=True,
            capture_output=True,
        )

        # Try to merge - should create conflict
        result = subprocess.run(
            ["git", "merge", "branch1"],
            cwd=local,
            check=False,
            capture_output=True,
        )

        # Merge should fail with conflict
        if result.returncode != 0:
            assert check_conflicts(local) is True


class TestIsFastForwardPossible:
    """Test is_fast_forward_possible() detection."""

    def test_fast_forward_up_to_date(
        self, git_repo_with_remote: tuple[Path, Path]
    ) -> None:
        """Test fast-forward on up-to-date branch."""
        local, _ = git_repo_with_remote
        assert is_fast_forward_possible(local) is True

    def test_fast_forward_behind(
        self, git_repo_with_remote: tuple[Path, Path]
    ) -> None:
        """Test fast-forward when behind remote."""
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

        # Fetch in original local
        subprocess.run(["git", "fetch"], cwd=local, check=True, capture_output=True)

        assert is_fast_forward_possible(local) is True

    def test_fast_forward_not_possible_ahead(
        self, git_repo_with_remote: tuple[Path, Path]
    ) -> None:
        """Test fast-forward not possible when ahead."""
        local, _ = git_repo_with_remote

        # Create local commit
        (local / "file.txt").write_text("content\n")
        subprocess.run(["git", "add", "."], cwd=local, check=True, capture_output=True)
        subprocess.run(
            ["git", "commit", "-m", "Local commit"],
            cwd=local,
            check=True,
            capture_output=True,
        )

        assert is_fast_forward_possible(local) is False

    def test_fast_forward_not_possible_diverged(
        self, git_repo_with_remote: tuple[Path, Path]
    ) -> None:
        """Test fast-forward not possible when diverged."""
        local, remote = git_repo_with_remote

        # Create local commit
        (local / "local.txt").write_text("local\n")
        subprocess.run(["git", "add", "."], cwd=local, check=True, capture_output=True)
        subprocess.run(
            ["git", "commit", "-m", "Local"],
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
            ["git", "commit", "-m", "Remote"],
            cwd=local2,
            check=True,
            capture_output=True,
        )
        subprocess.run(
            ["git", "push"], cwd=local2, check=True, capture_output=True
        )

        # Fetch in original local
        subprocess.run(["git", "fetch"], cwd=local, check=True, capture_output=True)

        assert is_fast_forward_possible(local) is False


class TestGetAheadBehindCount:
    """Test get_ahead_behind_count() commit counting."""

    def test_ahead_behind_up_to_date(
        self, git_repo_with_remote: tuple[Path, Path]
    ) -> None:
        """Test commit count on up-to-date branch."""
        local, _ = git_repo_with_remote

        ahead, behind = get_ahead_behind_count(local)
        assert ahead == 0
        assert behind == 0

    def test_ahead_behind_ahead_only(
        self, git_repo_with_remote: tuple[Path, Path]
    ) -> None:
        """Test commit count when ahead."""
        local, _ = git_repo_with_remote

        # Create 2 local commits
        for i in range(2):
            (local / f"file{i}.txt").write_text(f"content {i}\n")
            subprocess.run(["git", "add", "."], cwd=local, check=True, capture_output=True)
            subprocess.run(
                ["git", "commit", "-m", f"Commit {i}"],
                cwd=local,
                check=True,
                capture_output=True,
            )

        ahead, behind = get_ahead_behind_count(local)
        assert ahead == 2
        assert behind == 0

    def test_ahead_behind_behind_only(
        self, git_repo_with_remote: tuple[Path, Path]
    ) -> None:
        """Test commit count when behind."""
        local, remote = git_repo_with_remote

        # Create remote commits
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

        for i in range(3):
            (local2 / f"file{i}.txt").write_text(f"content {i}\n")
            subprocess.run(["git", "add", "."], cwd=local2, check=True, capture_output=True)
            subprocess.run(
                ["git", "commit", "-m", f"Commit {i}"],
                cwd=local2,
                check=True,
                capture_output=True,
            )

        subprocess.run(
            ["git", "push"], cwd=local2, check=True, capture_output=True
        )

        # Fetch in original local
        subprocess.run(["git", "fetch"], cwd=local, check=True, capture_output=True)

        ahead, behind = get_ahead_behind_count(local)
        assert ahead == 0
        assert behind == 3

    def test_ahead_behind_diverged(
        self, git_repo_with_remote: tuple[Path, Path]
    ) -> None:
        """Test commit count when diverged."""
        local, remote = git_repo_with_remote

        # Create local commit
        (local / "local.txt").write_text("local\n")
        subprocess.run(["git", "add", "."], cwd=local, check=True, capture_output=True)
        subprocess.run(
            ["git", "commit", "-m", "Local"],
            cwd=local,
            check=True,
            capture_output=True,
        )

        # Create remote commits
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

        for i in range(2):
            (local2 / f"remote{i}.txt").write_text(f"remote {i}\n")
            subprocess.run(["git", "add", "."], cwd=local2, check=True, capture_output=True)
            subprocess.run(
                ["git", "commit", "-m", f"Remote {i}"],
                cwd=local2,
                check=True,
                capture_output=True,
            )

        subprocess.run(
            ["git", "push"], cwd=local2, check=True, capture_output=True
        )

        # Fetch in original local
        subprocess.run(["git", "fetch"], cwd=local, check=True, capture_output=True)

        ahead, behind = get_ahead_behind_count(local)
        assert ahead == 1
        assert behind == 2
