"""Utility functions for home-sync.

Provides path expansion, validation helpers, and safe subprocess execution.
"""

import os
import subprocess
from pathlib import Path
from typing import Any, Dict, List, Optional, Union

__all__ = [
    "expand_path",
    "ensure_directory",
    "run_command",
    "CommandResult",
    "CommandError",
]


class CommandError(Exception):
    """Raised when a command execution fails."""

    def __init__(
        self, command: List[str], exit_code: int, stdout: str, stderr: str
    ) -> None:
        """Initialize CommandError.

        Args:
            command: The command that failed
            exit_code: The exit code from the command
            stdout: Standard output from the command
            stderr: Standard error from the command
        """
        self.command = command
        self.exit_code = exit_code
        self.stdout = stdout
        self.stderr = stderr
        super().__init__(
            f"Command failed with exit code {exit_code}: {' '.join(command)}\n"
            f"stderr: {stderr}"
        )


class CommandResult:
    """Result from command execution."""

    def __init__(self, exit_code: int, stdout: str, stderr: str) -> None:
        """Initialize CommandResult.

        Args:
            exit_code: The exit code from the command
            stdout: Standard output from the command
            stderr: Standard error from the command
        """
        self.exit_code = exit_code
        self.stdout = stdout
        self.stderr = stderr

    @property
    def success(self) -> bool:
        """Check if command was successful.

        Returns:
            True if exit_code is 0, False otherwise
        """
        return self.exit_code == 0


def expand_path(path: Union[str, Path]) -> Path:
    """Expand a path with user home directory and environment variables.

    Args:
        path: Path to expand (can contain ~ and environment variables)

    Returns:
        Expanded absolute Path object

    Example:
        >>> expanded = expand_path("~/dotfiles")
        >>> expanded = expand_path("$HOME/.config")
    """
    if isinstance(path, Path):
        path = str(path)

    # Expand environment variables
    path = os.path.expandvars(path)

    # Expand user home directory
    path_obj = Path(path).expanduser()

    # Resolve to absolute path
    return path_obj.resolve()


def ensure_directory(path: Union[str, Path], mode: int = 0o755) -> Path:
    """Ensure a directory exists, creating it if necessary.

    Args:
        path: Directory path to ensure exists
        mode: Permission mode for created directories (default: 0o755)

    Returns:
        Path object for the directory

    Raises:
        OSError: If directory cannot be created
        NotADirectoryError: If path exists but is not a directory

    Example:
        >>> log_dir = ensure_directory("~/.config/home-sync/logs")
        >>> data_dir = ensure_directory(Path.home() / "data")
    """
    path_obj = expand_path(path)

    if path_obj.exists():
        if not path_obj.is_dir():
            raise NotADirectoryError(f"Path exists but is not a directory: {path_obj}")
        return path_obj

    # Create directory with parents
    path_obj.mkdir(parents=True, mode=mode, exist_ok=True)

    return path_obj


def run_command(
    command: List[str],
    cwd: Optional[Path] = None,
    timeout: int = 30,
    check: bool = True,
    capture_output: bool = True,
    env: Optional[Dict[str, str]] = None,
) -> CommandResult:
    """Execute a command safely with timeout and error handling.

    Args:
        command: Command and arguments as a list (shell=False for security)
        cwd: Working directory for command execution
        timeout: Timeout in seconds (default: 30)
        check: Raise CommandError on non-zero exit (default: True)
        capture_output: Capture stdout and stderr (default: True)
        env: Environment variables (None uses parent environment)

    Returns:
        CommandResult with exit_code, stdout, stderr

    Raises:
        CommandError: If command fails and check=True
        subprocess.TimeoutExpired: If command exceeds timeout
        FileNotFoundError: If command executable not found

    Example:
        >>> result = run_command(["git", "status"], cwd=Path.home() / "dotfiles")
        >>> if result.success:
        ...     print(result.stdout)
    """
    # Validate command
    if not command:
        raise ValueError("Command list cannot be empty")

    if not isinstance(command, list):
        raise TypeError("Command must be a list, not a string (prevents shell injection)")

    # Prepare arguments
    kwargs = {
        "cwd": str(cwd) if cwd else None,
        "timeout": timeout,
        "capture_output": capture_output,
        "text": True,
        "env": env,
    }

    try:
        result = subprocess.run(command, **kwargs)  # type: ignore

        cmd_result = CommandResult(
            exit_code=result.returncode,
            stdout=result.stdout if capture_output else "",
            stderr=result.stderr if capture_output else "",
        )

        if check and not cmd_result.success:
            raise CommandError(
                command=command,
                exit_code=cmd_result.exit_code,
                stdout=cmd_result.stdout,
                stderr=cmd_result.stderr,
            )

        return cmd_result

    except subprocess.TimeoutExpired as e:
        # Re-raise with more context
        raise subprocess.TimeoutExpired(
            cmd=command, timeout=timeout, output=e.output, stderr=e.stderr
        ) from e

    except FileNotFoundError as e:
        # Provide better error message
        raise FileNotFoundError(
            f"Command not found: {command[0]}\n"
            f"Make sure the command is installed and in PATH"
        ) from e
