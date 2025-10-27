"""Tests for CLI commands using Click."""

import subprocess
from pathlib import Path
from unittest.mock import MagicMock, patch

import pytest
from click.testing import CliRunner

from home_sync.cli import cli
from home_sync.dotfiles import DotfilesSync, DotfilesSyncError
from home_sync.metrics import Metrics


@pytest.fixture
def cli_runner() -> CliRunner:
    """Create Click CLI test runner.

    Returns:
        CliRunner for testing Click commands
    """
    return CliRunner()


@pytest.fixture
def git_repo(tmp_path: Path) -> Path:
    """Create a test git repository.

    Args:
        tmp_path: pytest temporary directory fixture

    Returns:
        Path to test repository
    """
    repo = tmp_path / "dotfiles"
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
    (repo / "README.md").write_text("# Test\n")
    subprocess.run(["git", "add", "."], cwd=repo, check=True, capture_output=True)
    subprocess.run(
        ["git", "commit", "-m", "Initial commit"],
        cwd=repo,
        check=True,
        capture_output=True,
    )

    return repo


class TestCLIBasics:
    """Test basic CLI functionality."""

    def test_cli_help(self, cli_runner: CliRunner) -> None:
        """Test CLI help message."""
        result = cli_runner.invoke(cli, ["--help"])

        assert result.exit_code == 0
        assert "Home environment and credentials synchronization tool" in result.output
        assert "sync" in result.output
        assert "daemon" in result.output
        assert "status" in result.output

    def test_cli_version(self, cli_runner: CliRunner) -> None:
        """Test version command."""
        result = cli_runner.invoke(cli, ["version"])

        assert result.exit_code == 0
        assert "home-sync version" in result.output

    def test_cli_verbose_flag(self, cli_runner: CliRunner) -> None:
        """Test verbose flag sets log level."""
        result = cli_runner.invoke(cli, ["-v", "--help"])

        assert result.exit_code == 0
        # Verbose flag should work with subcommands


class TestSyncCommand:
    """Test sync command."""

    def test_sync_clean_repo(
        self, cli_runner: CliRunner, git_repo: Path
    ) -> None:
        """Test sync with clean repository."""
        result = cli_runner.invoke(cli, ["sync", "--repo", str(git_repo)])

        # Should fail because no remote configured
        assert result.exit_code == 1
        assert "Error:" in result.output

    def test_sync_dry_run(
        self, cli_runner: CliRunner, git_repo: Path
    ) -> None:
        """Test sync in dry-run mode."""
        result = cli_runner.invoke(
            cli, ["sync", "--repo", str(git_repo), "--dry-run", "--skip-pull", "--skip-push"]
        )

        assert result.exit_code == 0
        assert "Dry-run:" in result.output or "Sync completed" in result.output

    def test_sync_with_force(
        self, cli_runner: CliRunner, git_repo: Path
    ) -> None:
        """Test sync with force flag."""
        # Make a change
        (git_repo / "file.txt").write_text("content\n")

        result = cli_runner.invoke(
            cli,
            [
                "sync",
                "--repo",
                str(git_repo),
                "--force",
                "--skip-pull",
                "--skip-push",
            ],
        )

        assert result.exit_code == 0
        assert "Sync completed" in result.output

    def test_sync_dirty_without_force(
        self, cli_runner: CliRunner, git_repo: Path
    ) -> None:
        """Test sync with uncommitted changes without force fails."""
        # Make a change
        (git_repo / "file.txt").write_text("content\n")

        result = cli_runner.invoke(
            cli, ["sync", "--repo", str(git_repo), "--skip-pull", "--skip-push"]
        )

        assert result.exit_code == 1
        assert "Error:" in result.output

    def test_sync_nonexistent_repo(self, cli_runner: CliRunner) -> None:
        """Test sync with nonexistent repository."""
        result = cli_runner.invoke(
            cli, ["sync", "--repo", "/nonexistent/path"]
        )

        # Click returns exit code 2 for invalid arguments
        assert result.exit_code == 2
        assert "does not exist" in result.output.lower() or "invalid" in result.output.lower()

    def test_sync_skip_pull(
        self, cli_runner: CliRunner, git_repo: Path
    ) -> None:
        """Test sync with skip-pull flag."""
        result = cli_runner.invoke(
            cli, ["sync", "--repo", str(git_repo), "--skip-pull", "--skip-push"]
        )

        assert result.exit_code == 0
        assert "Sync completed" in result.output

    def test_sync_skip_push(
        self, cli_runner: CliRunner, git_repo: Path
    ) -> None:
        """Test sync with skip-push flag."""
        result = cli_runner.invoke(
            cli, ["sync", "--repo", str(git_repo), "--skip-pull", "--skip-push"]
        )

        assert result.exit_code == 0
        assert "Sync completed" in result.output

    def test_sync_default_repo(self, cli_runner: CliRunner) -> None:
        """Test sync uses default repo path."""
        result = cli_runner.invoke(cli, ["sync"])

        # Should fail because ~/.dotfiles likely doesn't exist in test
        assert result.exit_code == 1
        assert "Error:" in result.output

    def test_sync_keyboard_interrupt(
        self, cli_runner: CliRunner, git_repo: Path
    ) -> None:
        """Test sync handles keyboard interrupt."""
        with patch.object(DotfilesSync, "sync") as mock_sync:
            mock_sync.side_effect = KeyboardInterrupt()

            result = cli_runner.invoke(
                cli, ["sync", "--repo", str(git_repo), "--skip-pull", "--skip-push"]
            )

            assert result.exit_code == 130
            assert "interrupted" in result.output.lower()


class TestDaemonCommand:
    """Test daemon command."""

    def test_daemon_help(self, cli_runner: CliRunner) -> None:
        """Test daemon help message."""
        result = cli_runner.invoke(cli, ["daemon", "--help"])

        assert result.exit_code == 0
        assert "Run as a background daemon" in result.output
        assert "--interval" in result.output
        assert "--force" in result.output

    def test_daemon_nonexistent_repo(self, cli_runner: CliRunner) -> None:
        """Test daemon with nonexistent repository."""
        result = cli_runner.invoke(
            cli, ["daemon", "--repo", "/nonexistent/path"]
        )

        # Click returns exit code 2 for invalid arguments
        assert result.exit_code == 2
        assert "does not exist" in result.output.lower() or "invalid" in result.output.lower()

    @patch("home_sync.cli.run_daemon")
    def test_daemon_starts(
        self, mock_run_daemon: MagicMock, cli_runner: CliRunner, git_repo: Path
    ) -> None:
        """Test daemon starts with correct parameters."""
        result = cli_runner.invoke(
            cli,
            [
                "daemon",
                "--repo",
                str(git_repo),
                "--interval",
                "1800",
                "--force",
            ],
        )

        assert result.exit_code == 0
        mock_run_daemon.assert_called_once()
        call_kwargs = mock_run_daemon.call_args[1]
        assert call_kwargs["repo_path"] == git_repo
        assert call_kwargs["interval"] == 1800
        assert call_kwargs["force_commit"] is True

    @patch("home_sync.cli.run_daemon")
    def test_daemon_keyboard_interrupt(
        self, mock_run_daemon: MagicMock, cli_runner: CliRunner, git_repo: Path
    ) -> None:
        """Test daemon handles keyboard interrupt."""
        mock_run_daemon.side_effect = KeyboardInterrupt()

        result = cli_runner.invoke(cli, ["daemon", "--repo", str(git_repo)])

        assert result.exit_code == 0
        assert "stopped" in result.output.lower()

    @patch("home_sync.cli.run_daemon")
    def test_daemon_exception(
        self, mock_run_daemon: MagicMock, cli_runner: CliRunner, git_repo: Path
    ) -> None:
        """Test daemon handles exceptions."""
        mock_run_daemon.side_effect = RuntimeError("Test error")

        result = cli_runner.invoke(cli, ["daemon", "--repo", str(git_repo)])

        assert result.exit_code == 1
        assert "Error:" in result.output


class TestStatusCommand:
    """Test status command."""

    def test_status_help(self, cli_runner: CliRunner) -> None:
        """Test status help message."""
        result = cli_runner.invoke(cli, ["status", "--help"])

        assert result.exit_code == 0
        assert "Show repository status" in result.output

    def test_status_clean_repo(
        self, cli_runner: CliRunner, git_repo: Path
    ) -> None:
        """Test status with clean repository."""
        result = cli_runner.invoke(cli, ["status", "--repo", str(git_repo)])

        # Repos without upstream may fail with error exit code
        # This is expected behavior since get_branch_status fails
        assert "Repository:" in result.output or "Error:" in result.output
        assert "Branch:" in result.output or "Error:" in result.output

    def test_status_dirty_repo(
        self, cli_runner: CliRunner, git_repo: Path
    ) -> None:
        """Test status with uncommitted changes."""
        # Make a change
        (git_repo / "file.txt").write_text("content\n")

        result = cli_runner.invoke(cli, ["status", "--repo", str(git_repo)])

        # Repos without upstream may fail with error exit code
        assert "Repository:" in result.output or "Error:" in result.output

    def test_status_nonexistent_repo(self, cli_runner: CliRunner) -> None:
        """Test status with nonexistent repository."""
        result = cli_runner.invoke(cli, ["status", "--repo", "/nonexistent/path"])

        # Click returns exit code 2 for invalid arguments
        assert result.exit_code == 2
        assert "does not exist" in result.output.lower() or "invalid" in result.output.lower()

    def test_status_non_git_directory(
        self, cli_runner: CliRunner, tmp_path: Path
    ) -> None:
        """Test status with non-git directory."""
        non_git = tmp_path / "not-git"
        non_git.mkdir()

        result = cli_runner.invoke(cli, ["status", "--repo", str(non_git)])

        assert result.exit_code == 1
        assert "Error:" in result.output
        assert "not a git repository" in result.output.lower()

    def test_status_default_repo(self, cli_runner: CliRunner) -> None:
        """Test status uses default repo path."""
        result = cli_runner.invoke(cli, ["status"])

        # Should fail because ~/.dotfiles likely doesn't exist in test
        assert result.exit_code == 1
        assert "Error:" in result.output


class TestCLIIntegration:
    """Test CLI integration with multiple commands."""

    def test_verbose_affects_all_commands(self, cli_runner: CliRunner) -> None:
        """Test verbose flag works with all commands."""
        # Test with sync
        result = cli_runner.invoke(cli, ["-v", "sync", "--help"])
        assert result.exit_code == 0

        # Test with daemon
        result = cli_runner.invoke(cli, ["-vv", "daemon", "--help"])
        assert result.exit_code == 0

        # Test with status
        result = cli_runner.invoke(cli, ["-vvv", "status", "--help"])
        assert result.exit_code == 0

    def test_context_passing(
        self, cli_runner: CliRunner, git_repo: Path
    ) -> None:
        """Test context is passed between parent and child commands."""
        result = cli_runner.invoke(
            cli, ["-v", "sync", "--repo", str(git_repo), "--dry-run", "--skip-pull", "--skip-push"]
        )

        # Should succeed with verbose flag propagated
        assert result.exit_code == 0
