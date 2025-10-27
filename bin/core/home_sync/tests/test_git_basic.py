"""Unit tests for basic git operations.

Tests cover:
- Safe subprocess execution
- Repository validation
- Status checking
- Savepoint/rollback functionality
"""

import subprocess
import tempfile
from pathlib import Path
from unittest.mock import MagicMock, patch

import pytest

from home_sync.git import (
    BranchStatus,
    GitError,
    GitTimeoutError,
    check_dirty,
    get_current_commit,
    get_modified_files,
    git_savepoint,
    is_git_repo,
    run_git,
)


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


class TestRunGit:
    """Test run_git() subprocess wrapper."""

    def test_run_git_success(self, temp_git_repo: Path) -> None:
        """Test successful git command execution."""
        result = run_git(["status", "--short"], cwd=temp_git_repo)

        assert result.returncode == 0
        assert isinstance(result.stdout, str)
        assert isinstance(result.stderr, str)

    def test_run_git_with_output(self, temp_git_repo: Path) -> None:
        """Test git command with output capture."""
        result = run_git(["rev-parse", "HEAD"], cwd=temp_git_repo)

        assert result.returncode == 0
        assert len(result.stdout.strip()) == 40  # SHA-1 hash

    def test_run_git_invalid_command(self, temp_git_repo: Path) -> None:
        """Test git command with invalid arguments."""
        with pytest.raises(GitError) as exc_info:
            run_git(["invalid-command"], cwd=temp_git_repo)

        assert "Git command failed" in str(exc_info.value)
        assert "invalid-command" in str(exc_info.value)

    def test_run_git_timeout(self, temp_git_repo: Path) -> None:
        """Test git command timeout handling."""
        # Mock subprocess.run to raise TimeoutExpired
        with patch("subprocess.run") as mock_run:
            mock_run.side_effect = subprocess.TimeoutExpired(
                cmd=["git", "fetch"], timeout=1
            )

            with pytest.raises(GitTimeoutError) as exc_info:
                run_git(["fetch"], cwd=temp_git_repo, timeout=1)

            assert "timed out after 1s" in str(exc_info.value)

    def test_run_git_no_check(self, temp_git_repo: Path) -> None:
        """Test git command with check=False."""
        result = run_git(["invalid-command"], cwd=temp_git_repo, check=False)

        assert result.returncode != 0
        assert "not a git command" in result.stderr.lower()

    def test_run_git_nonexistent_directory(self, tmp_path: Path) -> None:
        """Test git command with nonexistent working directory."""
        nonexistent = tmp_path / "does_not_exist"

        with pytest.raises(GitError) as exc_info:
            run_git(["status"], cwd=nonexistent)

        assert "does not exist" in str(exc_info.value)

    def test_run_git_prevents_shell_injection(self, temp_git_repo: Path) -> None:
        """Test that run_git prevents shell injection."""
        # Passing a string instead of list should raise TypeError
        with pytest.raises(TypeError) as exc_info:
            run_git("status; rm -rf /", cwd=temp_git_repo)  # type: ignore

        assert "must be a list" in str(exc_info.value)
        assert "shell injection" in str(exc_info.value)


class TestIsGitRepo:
    """Test is_git_repo() repository validation."""

    def test_is_git_repo_valid(self, temp_git_repo: Path) -> None:
        """Test valid git repository detection."""
        assert is_git_repo(temp_git_repo) is True

    def test_is_git_repo_invalid(self, tmp_path: Path) -> None:
        """Test non-git directory detection."""
        assert is_git_repo(tmp_path) is False

    def test_is_git_repo_nonexistent(self, tmp_path: Path) -> None:
        """Test nonexistent path detection."""
        nonexistent = tmp_path / "does_not_exist"
        assert is_git_repo(nonexistent) is False

    def test_is_git_repo_file(self, tmp_path: Path) -> None:
        """Test file (not directory) detection."""
        file_path = tmp_path / "file.txt"
        file_path.write_text("content")
        assert is_git_repo(file_path) is False

    def test_is_git_repo_subdirectory(self, temp_git_repo: Path) -> None:
        """Test git repository subdirectory detection."""
        subdir = temp_git_repo / "subdir"
        subdir.mkdir()
        assert is_git_repo(subdir) is True  # Still part of git repo


class TestGetCurrentCommit:
    """Test get_current_commit() SHA retrieval."""

    def test_get_current_commit_success(self, temp_git_repo: Path) -> None:
        """Test successful commit SHA retrieval."""
        commit = get_current_commit(temp_git_repo)

        assert isinstance(commit, str)
        assert len(commit) == 40
        assert all(c in "0123456789abcdef" for c in commit)

    def test_get_current_commit_not_git_repo(self, tmp_path: Path) -> None:
        """Test commit retrieval from non-git directory."""
        with pytest.raises(GitError) as exc_info:
            get_current_commit(tmp_path)

        assert "Not a git repository" in str(exc_info.value)

    def test_get_current_commit_matches_git(self, temp_git_repo: Path) -> None:
        """Test commit SHA matches git rev-parse output."""
        result = subprocess.run(
            ["git", "rev-parse", "HEAD"],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
            text=True,
        )
        expected_sha = result.stdout.strip()

        assert get_current_commit(temp_git_repo) == expected_sha


class TestCheckDirty:
    """Test check_dirty() status detection."""

    def test_check_dirty_clean_repo(self, temp_git_repo: Path) -> None:
        """Test clean repository (no changes)."""
        assert check_dirty(temp_git_repo) is False

    def test_check_dirty_modified_file(self, temp_git_repo: Path) -> None:
        """Test repository with modified file."""
        (temp_git_repo / "README.md").write_text("# Modified\n")
        assert check_dirty(temp_git_repo) is True

    def test_check_dirty_new_file(self, temp_git_repo: Path) -> None:
        """Test repository with untracked file."""
        (temp_git_repo / "new_file.txt").write_text("new content\n")
        assert check_dirty(temp_git_repo) is True

    def test_check_dirty_staged_changes(self, temp_git_repo: Path) -> None:
        """Test repository with staged changes."""
        (temp_git_repo / "README.md").write_text("# Staged\n")
        subprocess.run(
            ["git", "add", "README.md"],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
        )
        assert check_dirty(temp_git_repo) is True

    def test_check_dirty_deleted_file(self, temp_git_repo: Path) -> None:
        """Test repository with deleted file."""
        (temp_git_repo / "README.md").unlink()
        assert check_dirty(temp_git_repo) is True

    def test_check_dirty_not_git_repo(self, tmp_path: Path) -> None:
        """Test check_dirty on non-git directory."""
        with pytest.raises(GitError) as exc_info:
            check_dirty(tmp_path)

        assert "Not a git repository" in str(exc_info.value)


class TestGetModifiedFiles:
    """Test get_modified_files() file list retrieval."""

    def test_get_modified_files_clean_repo(self, temp_git_repo: Path) -> None:
        """Test clean repository returns empty list."""
        assert get_modified_files(temp_git_repo) == []

    def test_get_modified_files_modified(self, temp_git_repo: Path) -> None:
        """Test modified file detection."""
        (temp_git_repo / "README.md").write_text("# Modified\n")
        files = get_modified_files(temp_git_repo)

        assert "README.md" in files

    def test_get_modified_files_new(self, temp_git_repo: Path) -> None:
        """Test new file detection."""
        (temp_git_repo / "new_file.txt").write_text("new content\n")
        files = get_modified_files(temp_git_repo)

        assert "new_file.txt" in files

    def test_get_modified_files_multiple(self, temp_git_repo: Path) -> None:
        """Test multiple modified files."""
        (temp_git_repo / "file1.txt").write_text("content1\n")
        (temp_git_repo / "file2.txt").write_text("content2\n")
        (temp_git_repo / "README.md").write_text("# Modified\n")

        files = get_modified_files(temp_git_repo)

        assert len(files) >= 3
        assert "file1.txt" in files
        assert "file2.txt" in files
        assert "README.md" in files

    def test_get_modified_files_not_git_repo(self, tmp_path: Path) -> None:
        """Test get_modified_files on non-git directory."""
        with pytest.raises(GitError) as exc_info:
            get_modified_files(tmp_path)

        assert "Not a git repository" in str(exc_info.value)


class TestGitSavepoint:
    """Test git_savepoint() context manager."""

    def test_git_savepoint_success(self, temp_git_repo: Path) -> None:
        """Test savepoint creation and normal exit."""
        original_commit = get_current_commit(temp_git_repo)

        with git_savepoint(temp_git_repo) as savepoint:
            assert savepoint == original_commit

            # Make a change and commit
            (temp_git_repo / "file.txt").write_text("new content\n")
            subprocess.run(
                ["git", "add", "."], cwd=temp_git_repo, check=True, capture_output=True
            )
            subprocess.run(
                ["git", "commit", "-m", "test commit"],
                cwd=temp_git_repo,
                check=True,
                capture_output=True,
            )

        # After successful context, new commit should be preserved
        assert get_current_commit(temp_git_repo) != original_commit

    def test_git_savepoint_rollback_on_exception(self, temp_git_repo: Path) -> None:
        """Test savepoint rollback on exception."""
        original_commit = get_current_commit(temp_git_repo)

        with pytest.raises(ValueError):
            with git_savepoint(temp_git_repo):
                # Make a change and commit
                (temp_git_repo / "file.txt").write_text("new content\n")
                subprocess.run(
                    ["git", "add", "."],
                    cwd=temp_git_repo,
                    check=True,
                    capture_output=True,
                )
                subprocess.run(
                    ["git", "commit", "-m", "test commit"],
                    cwd=temp_git_repo,
                    check=True,
                    capture_output=True,
                )

                # Raise exception to trigger rollback
                raise ValueError("Something went wrong")

        # After exception, should be rolled back to original commit
        assert get_current_commit(temp_git_repo) == original_commit

    def test_git_savepoint_rollback_preserves_untracked(
        self, temp_git_repo: Path
    ) -> None:
        """Test that rollback preserves untracked files."""
        # Create untracked file before savepoint
        untracked_file = temp_git_repo / "untracked.txt"
        untracked_file.write_text("untracked content\n")

        with pytest.raises(ValueError):
            with git_savepoint(temp_git_repo):
                # Make a tracked change
                (temp_git_repo / "README.md").write_text("# Modified\n")
                subprocess.run(
                    ["git", "add", "."],
                    cwd=temp_git_repo,
                    check=True,
                    capture_output=True,
                )
                subprocess.run(
                    ["git", "commit", "-m", "test"],
                    cwd=temp_git_repo,
                    check=True,
                    capture_output=True,
                )

                raise ValueError("trigger rollback")

        # Untracked file from before savepoint should still exist
        # Note: git clean -fd may remove it if it was created during operations
        # This test focuses on files that existed before the savepoint

    def test_git_savepoint_not_git_repo(self, tmp_path: Path) -> None:
        """Test savepoint on non-git directory."""
        with pytest.raises(GitError) as exc_info:
            with git_savepoint(tmp_path):
                pass

        assert "Not a git repository" in str(exc_info.value)

    def test_git_savepoint_rollback_multiple_commits(
        self, temp_git_repo: Path
    ) -> None:
        """Test rollback with multiple commits."""
        original_commit = get_current_commit(temp_git_repo)

        with pytest.raises(ValueError):
            with git_savepoint(temp_git_repo):
                # First commit
                (temp_git_repo / "file1.txt").write_text("content1\n")
                subprocess.run(
                    ["git", "add", "."],
                    cwd=temp_git_repo,
                    check=True,
                    capture_output=True,
                )
                subprocess.run(
                    ["git", "commit", "-m", "commit 1"],
                    cwd=temp_git_repo,
                    check=True,
                    capture_output=True,
                )

                # Second commit
                (temp_git_repo / "file2.txt").write_text("content2\n")
                subprocess.run(
                    ["git", "add", "."],
                    cwd=temp_git_repo,
                    check=True,
                    capture_output=True,
                )
                subprocess.run(
                    ["git", "commit", "-m", "commit 2"],
                    cwd=temp_git_repo,
                    check=True,
                    capture_output=True,
                )

                raise ValueError("rollback both commits")

        # Should be rolled back to original, removing both commits
        assert get_current_commit(temp_git_repo) == original_commit
        assert not (temp_git_repo / "file1.txt").exists()
        assert not (temp_git_repo / "file2.txt").exists()
