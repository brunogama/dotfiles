"""Unit tests for git commit operations.

Tests cover:
- Staging changes
- Creating commits
- Backup branch creation
- Branch name retrieval
- Unstaging changes
"""

import subprocess
from pathlib import Path

import pytest

from home_sync.git import (
    GitError,
    create_backup_branch,
    create_commit,
    get_current_branch,
    stage_changes,
    unstage_all,
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


class TestStageChanges:
    """Test stage_changes() functionality."""

    def test_stage_all_changes(self, temp_git_repo: Path) -> None:
        """Test staging all changes (default behavior)."""
        # Create new file and modify existing
        (temp_git_repo / "new_file.txt").write_text("new content\n")
        (temp_git_repo / "README.md").write_text("# Modified\n")

        stage_changes(temp_git_repo)

        # Check that both files are staged
        result = subprocess.run(
            ["git", "diff", "--cached", "--name-only"],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
            text=True,
        )
        staged_files = result.stdout.strip().split("\n")

        assert "new_file.txt" in staged_files
        assert "README.md" in staged_files

    def test_stage_all_tracked_only(self, temp_git_repo: Path) -> None:
        """Test staging only tracked files (no new files)."""
        # Create new file and modify existing
        (temp_git_repo / "new_file.txt").write_text("new content\n")
        (temp_git_repo / "README.md").write_text("# Modified\n")

        stage_changes(temp_git_repo, all_tracked=True)

        # Check that only modified tracked file is staged
        result = subprocess.run(
            ["git", "diff", "--cached", "--name-only"],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
            text=True,
        )
        staged_files = result.stdout.strip().split("\n")

        assert "README.md" in staged_files
        assert "new_file.txt" not in staged_files  # Untracked, not staged

    def test_stage_specific_files(self, temp_git_repo: Path) -> None:
        """Test staging specific files."""
        # Create multiple files
        (temp_git_repo / "file1.txt").write_text("content1\n")
        (temp_git_repo / "file2.txt").write_text("content2\n")
        (temp_git_repo / "file3.txt").write_text("content3\n")

        # Stage only file1 and file2
        stage_changes(temp_git_repo, files=["file1.txt", "file2.txt"])

        # Check that only specified files are staged
        result = subprocess.run(
            ["git", "diff", "--cached", "--name-only"],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
            text=True,
        )
        staged_files = result.stdout.strip().split("\n")

        assert "file1.txt" in staged_files
        assert "file2.txt" in staged_files
        assert "file3.txt" not in staged_files

    def test_stage_changes_not_git_repo(self, tmp_path: Path) -> None:
        """Test staging in non-git directory."""
        with pytest.raises(GitError) as exc_info:
            stage_changes(tmp_path)

        assert "Not a git repository" in str(exc_info.value)


class TestCreateCommit:
    """Test create_commit() functionality."""

    def test_create_commit_success(self, temp_git_repo: Path) -> None:
        """Test successful commit creation."""
        # Make a change and stage it
        (temp_git_repo / "file.txt").write_text("content\n")
        stage_changes(temp_git_repo)

        commit_sha = create_commit(temp_git_repo, "Test commit message")

        assert len(commit_sha) == 40
        assert all(c in "0123456789abcdef" for c in commit_sha)

        # Verify commit message
        result = subprocess.run(
            ["git", "log", "-1", "--pretty=%B"],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
            text=True,
        )
        assert result.stdout.strip() == "Test commit message"

    def test_create_commit_empty_message(self, temp_git_repo: Path) -> None:
        """Test commit with empty message fails."""
        with pytest.raises(ValueError) as exc_info:
            create_commit(temp_git_repo, "")

        assert "cannot be empty" in str(exc_info.value)

    def test_create_commit_whitespace_message(self, temp_git_repo: Path) -> None:
        """Test commit with whitespace-only message fails."""
        with pytest.raises(ValueError) as exc_info:
            create_commit(temp_git_repo, "   \n  ")

        assert "cannot be empty" in str(exc_info.value)

    def test_create_commit_no_changes(self, temp_git_repo: Path) -> None:
        """Test commit with no staged changes fails."""
        with pytest.raises(GitError) as exc_info:
            create_commit(temp_git_repo, "Test commit")

        assert "No changes to commit" in str(exc_info.value)

    def test_create_commit_allow_empty(self, temp_git_repo: Path) -> None:
        """Test commit with allow_empty flag."""
        commit_sha = create_commit(temp_git_repo, "Empty commit", allow_empty=True)

        assert len(commit_sha) == 40

        # Verify no files changed
        result = subprocess.run(
            ["git", "diff-tree", "--no-commit-id", "--name-only", "-r", commit_sha],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
            text=True,
        )
        assert result.stdout.strip() == ""

    def test_create_commit_multiline_message(self, temp_git_repo: Path) -> None:
        """Test commit with multiline message."""
        message = "Short summary\n\nDetailed explanation\nwith multiple lines"

        (temp_git_repo / "file.txt").write_text("content\n")
        stage_changes(temp_git_repo)

        commit_sha = create_commit(temp_git_repo, message)

        # Verify full commit message
        result = subprocess.run(
            ["git", "log", "-1", "--pretty=%B"],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
            text=True,
        )
        assert result.stdout.strip() == message

    def test_create_commit_not_git_repo(self, tmp_path: Path) -> None:
        """Test commit in non-git directory."""
        with pytest.raises(GitError) as exc_info:
            create_commit(tmp_path, "Test commit")

        assert "Not a git repository" in str(exc_info.value)


class TestCreateBackupBranch:
    """Test create_backup_branch() functionality."""

    def test_create_backup_branch_default_prefix(self, temp_git_repo: Path) -> None:
        """Test backup branch creation with default prefix."""
        branch_name = create_backup_branch(temp_git_repo)

        assert branch_name.startswith("backup-")
        assert len(branch_name) > 7  # backup-YYYYMMDD-HHMMSS

        # Verify branch exists
        result = subprocess.run(
            ["git", "branch", "--list", branch_name],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
            text=True,
        )
        assert branch_name in result.stdout

    def test_create_backup_branch_custom_prefix(self, temp_git_repo: Path) -> None:
        """Test backup branch creation with custom prefix."""
        branch_name = create_backup_branch(temp_git_repo, prefix="savepoint")

        assert branch_name.startswith("savepoint-")

        # Verify branch exists
        result = subprocess.run(
            ["git", "branch", "--list", branch_name],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
            text=True,
        )
        assert branch_name in result.stdout

    def test_create_backup_branch_points_to_head(self, temp_git_repo: Path) -> None:
        """Test backup branch points to current HEAD."""
        # Get current HEAD
        result = subprocess.run(
            ["git", "rev-parse", "HEAD"],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
            text=True,
        )
        head_sha = result.stdout.strip()

        # Create backup branch
        branch_name = create_backup_branch(temp_git_repo)

        # Get backup branch SHA
        result = subprocess.run(
            ["git", "rev-parse", branch_name],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
            text=True,
        )
        branch_sha = result.stdout.strip()

        assert branch_sha == head_sha

    def test_create_backup_branch_multiple(self, temp_git_repo: Path) -> None:
        """Test creating multiple backup branches."""
        import time

        branch1 = create_backup_branch(temp_git_repo)
        time.sleep(1)  # Ensure different timestamps
        branch2 = create_backup_branch(temp_git_repo)

        assert branch1 != branch2

        # Verify both exist
        result = subprocess.run(
            ["git", "branch", "--list"],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
            text=True,
        )
        assert branch1 in result.stdout
        assert branch2 in result.stdout

    def test_create_backup_branch_not_git_repo(self, tmp_path: Path) -> None:
        """Test backup branch creation in non-git directory."""
        with pytest.raises(GitError) as exc_info:
            create_backup_branch(tmp_path)

        assert "Not a git repository" in str(exc_info.value)


class TestGetCurrentBranch:
    """Test get_current_branch() functionality."""

    def test_get_current_branch_success(self, temp_git_repo: Path) -> None:
        """Test getting current branch name."""
        branch_name = get_current_branch(temp_git_repo)

        # Branch name should be either "main" or "master" depending on git config
        assert branch_name in ["main", "master"]

    def test_get_current_branch_custom_branch(self, temp_git_repo: Path) -> None:
        """Test getting current branch on custom branch."""
        # Create and checkout new branch
        subprocess.run(
            ["git", "checkout", "-b", "feature-branch"],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
        )

        branch_name = get_current_branch(temp_git_repo)
        assert branch_name == "feature-branch"

    def test_get_current_branch_detached_head(self, temp_git_repo: Path) -> None:
        """Test getting current branch with detached HEAD."""
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

        with pytest.raises(GitError) as exc_info:
            get_current_branch(temp_git_repo)

        assert "detached" in str(exc_info.value).lower()

    def test_get_current_branch_not_git_repo(self, tmp_path: Path) -> None:
        """Test getting branch in non-git directory."""
        with pytest.raises(GitError) as exc_info:
            get_current_branch(tmp_path)

        assert "Not a git repository" in str(exc_info.value)


class TestUnstageAll:
    """Test unstage_all() functionality."""

    def test_unstage_all_success(self, temp_git_repo: Path) -> None:
        """Test unstaging all changes."""
        # Make changes and stage them
        (temp_git_repo / "file1.txt").write_text("content1\n")
        (temp_git_repo / "file2.txt").write_text("content2\n")
        stage_changes(temp_git_repo)

        # Verify files are staged
        result = subprocess.run(
            ["git", "diff", "--cached", "--name-only"],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
            text=True,
        )
        assert len(result.stdout.strip()) > 0

        # Unstage
        unstage_all(temp_git_repo)

        # Verify nothing is staged
        result = subprocess.run(
            ["git", "diff", "--cached", "--name-only"],
            cwd=temp_git_repo,
            check=True,
            capture_output=True,
            text=True,
        )
        assert result.stdout.strip() == ""

    def test_unstage_all_no_staged_changes(self, temp_git_repo: Path) -> None:
        """Test unstaging when nothing is staged."""
        # Should not raise error
        unstage_all(temp_git_repo)

    def test_unstage_all_not_git_repo(self, tmp_path: Path) -> None:
        """Test unstaging in non-git directory."""
        with pytest.raises(GitError) as exc_info:
            unstage_all(tmp_path)

        assert "Not a git repository" in str(exc_info.value)
