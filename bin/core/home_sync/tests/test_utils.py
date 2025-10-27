"""Tests for utils module."""

import os
import subprocess
from pathlib import Path

import pytest

from home_sync.utils import (
    CommandError,
    CommandResult,
    ensure_directory,
    expand_path,
    run_command,
)


class TestExpandPath:
    """Test cases for expand_path function."""

    def test_expand_path_absolute(self) -> None:
        """Test expanding absolute path."""
        result = expand_path("/usr/local/bin")
        assert result == Path("/usr/local/bin")
        assert result.is_absolute()

    def test_expand_path_user_home(self) -> None:
        """Test expanding path with ~."""
        result = expand_path("~/dotfiles")
        assert result == Path.home() / "dotfiles"
        assert result.is_absolute()

    def test_expand_path_env_var(self, monkeypatch: pytest.MonkeyPatch) -> None:
        """Test expanding path with environment variables."""
        monkeypatch.setenv("TEST_DIR", "/custom/path")
        result = expand_path("$TEST_DIR/subdir")
        assert result == Path("/custom/path/subdir")

    def test_expand_path_combined(self, monkeypatch: pytest.MonkeyPatch) -> None:
        """Test expanding path with both ~ and env vars."""
        monkeypatch.setenv("CONFIG_DIR", ".config")
        result = expand_path("~/$CONFIG_DIR/app")
        assert result == Path.home() / ".config" / "app"

    def test_expand_path_relative(self, tmp_path: Path) -> None:
        """Test expanding relative path."""
        os.chdir(tmp_path)
        result = expand_path("./subdir")
        assert result == tmp_path / "subdir"
        assert result.is_absolute()

    def test_expand_path_from_path_object(self) -> None:
        """Test expanding Path object."""
        result = expand_path(Path("~/dotfiles"))
        assert result == Path.home() / "dotfiles"


class TestEnsureDirectory:
    """Test cases for ensure_directory function."""

    def test_ensure_directory_creates(self, tmp_path: Path) -> None:
        """Test creating new directory."""
        new_dir = tmp_path / "test" / "nested"
        result = ensure_directory(new_dir)

        assert result == new_dir
        assert result.exists()
        assert result.is_dir()

    def test_ensure_directory_exists(self, tmp_path: Path) -> None:
        """Test with existing directory."""
        existing_dir = tmp_path / "existing"
        existing_dir.mkdir()

        result = ensure_directory(existing_dir)

        assert result == existing_dir
        assert result.exists()

    def test_ensure_directory_not_a_directory(self, tmp_path: Path) -> None:
        """Test error when path is a file."""
        file_path = tmp_path / "file.txt"
        file_path.write_text("content")

        with pytest.raises(NotADirectoryError, match="not a directory"):
            ensure_directory(file_path)

    def test_ensure_directory_with_tilde(self, tmp_path: Path) -> None:
        """Test creating directory with ~ expansion."""
        # Use actual home directory since monkeypatching Path.home() doesn't affect expanduser()
        test_dir = ensure_directory("~/test_dir_home_sync_test")

        assert test_dir == Path.home() / "test_dir_home_sync_test"
        assert test_dir.exists()

        # Clean up
        test_dir.rmdir()

    def test_ensure_directory_permissions(self, tmp_path: Path) -> None:
        """Test directory is created with correct permissions."""
        new_dir = tmp_path / "perms_test"
        result = ensure_directory(new_dir, mode=0o700)

        assert result.exists()
        # Check permissions (may vary by OS)
        stat = result.stat()
        assert stat.st_mode & 0o777 == 0o700


class TestCommandResult:
    """Test cases for CommandResult class."""

    def test_command_result_success_true(self) -> None:
        """Test success property when exit_code is 0."""
        result = CommandResult(exit_code=0, stdout="output", stderr="")
        assert result.success is True

    def test_command_result_success_false(self) -> None:
        """Test success property when exit_code is non-zero."""
        result = CommandResult(exit_code=1, stdout="", stderr="error")
        assert result.success is False

    def test_command_result_attributes(self) -> None:
        """Test CommandResult attributes."""
        result = CommandResult(exit_code=2, stdout="out", stderr="err")
        assert result.exit_code == 2
        assert result.stdout == "out"
        assert result.stderr == "err"


class TestCommandError:
    """Test cases for CommandError exception."""

    def test_command_error_attributes(self) -> None:
        """Test CommandError has correct attributes."""
        error = CommandError(
            command=["git", "status"],
            exit_code=128,
            stdout="",
            stderr="fatal error",
        )

        assert error.command == ["git", "status"]
        assert error.exit_code == 128
        assert error.stdout == ""
        assert error.stderr == "fatal error"

    def test_command_error_message(self) -> None:
        """Test CommandError message format."""
        error = CommandError(
            command=["test", "cmd"],
            exit_code=1,
            stdout="",
            stderr="error message",
        )

        message = str(error)
        assert "exit code 1" in message
        assert "test cmd" in message
        assert "error message" in message


class TestRunCommand:
    """Test cases for run_command function."""

    def test_run_command_success(self) -> None:
        """Test successful command execution."""
        result = run_command(["echo", "test"])

        assert result.success is True
        assert result.exit_code == 0
        assert "test" in result.stdout

    def test_run_command_failure(self) -> None:
        """Test failed command with check=True."""
        with pytest.raises(CommandError) as exc_info:
            run_command(["false"])

        error = exc_info.value
        assert error.exit_code != 0

    def test_run_command_failure_no_check(self) -> None:
        """Test failed command with check=False."""
        result = run_command(["false"], check=False)

        assert result.success is False
        assert result.exit_code != 0

    def test_run_command_with_cwd(self, tmp_path: Path) -> None:
        """Test command execution with working directory."""
        result = run_command(["pwd"], cwd=tmp_path)

        assert result.success is True
        assert str(tmp_path) in result.stdout

    def test_run_command_timeout(self) -> None:
        """Test command timeout."""
        with pytest.raises(subprocess.TimeoutExpired):
            run_command(["sleep", "10"], timeout=1)

    def test_run_command_not_found(self) -> None:
        """Test error when command not found."""
        with pytest.raises(FileNotFoundError, match="Command not found"):
            run_command(["nonexistent_command_xyz"])

    def test_run_command_empty_list(self) -> None:
        """Test error with empty command list."""
        with pytest.raises(ValueError, match="cannot be empty"):
            run_command([])

    def test_run_command_not_list(self) -> None:
        """Test error when command is string instead of list."""
        with pytest.raises(TypeError, match="must be a list"):
            run_command("echo test")  # type: ignore

    def test_run_command_capture_output_false(self) -> None:
        """Test command with capture_output=False."""
        result = run_command(["echo", "test"], capture_output=False)

        assert result.success is True
        assert result.stdout == ""
        assert result.stderr == ""

    def test_run_command_with_env(self, monkeypatch: pytest.MonkeyPatch) -> None:
        """Test command with custom environment."""
        custom_env = os.environ.copy()
        custom_env["TEST_VAR"] = "custom_value"

        result = run_command(["sh", "-c", "echo $TEST_VAR"], env=custom_env)

        assert result.success is True
        assert "custom_value" in result.stdout

    def test_run_command_stderr_capture(self) -> None:
        """Test stderr is captured."""
        result = run_command(
            ["sh", "-c", "echo error >&2"],
            check=False,
        )

        assert "error" in result.stderr


class TestUtilsIntegration:
    """Integration tests for utils module."""

    def test_path_and_directory_workflow(self, tmp_path: Path) -> None:
        """Test complete workflow with path expansion and directory creation."""
        # Expand path
        base_path = expand_path(tmp_path / "config")

        # Ensure directory
        log_dir = ensure_directory(base_path / "logs")
        data_dir = ensure_directory(base_path / "data")

        assert log_dir.exists()
        assert data_dir.exists()
        assert log_dir.parent == base_path

    def test_command_workflow(self, tmp_path: Path) -> None:
        """Test complete command execution workflow."""
        # Create a test file
        test_file = tmp_path / "test.txt"
        test_file.write_text("test content")

        # List directory
        result = run_command(["ls", "-1"], cwd=tmp_path)

        assert result.success
        assert "test.txt" in result.stdout

        # Count lines in file
        result = run_command(["wc", "-l", str(test_file)])

        assert result.success
        assert "1" in result.stdout
