"""Common git script utilities and constants.

This module provides shared utilities for git Python scripts, including
exit codes, error handling, console initialization, and timeout constants.
"""

import sys
from enum import Enum
from pathlib import Path
from typing import NoReturn

# Add parent's parent to path for bin/lib/ access
sys.path.insert(0, str(Path(__file__).parent.parent.parent))

from lib.error_handling import BaseError
from rich.console import Console

# Initialize Rich console for formatted output
console = Console()

# Git command timeout constants (in seconds)
GIT_TIMEOUT = 300  # 5 minutes for regular operations
CLONE_TIMEOUT = 600  # 10 minutes for clone operations


class ExitCode(Enum):
    """Exit codes for git applications."""

    SUCCESS = 0
    ERROR = 1
    NOT_GIT_REPO = 2
    DETACHED_HEAD = 3
    DIRTY_WORKING_TREE = 4
    WORKTREE_EXISTS = 5
    BRANCH_EXISTS = 6
    BRANCH_IN_USE = 7
    INVALID_PATH = 8


class GitError(BaseError):
    """Base exception for git-related errors.

    Inherits from lib.error_handling.BaseError for consistent error handling
    across all Python scripts.
    """

    def __init__(self, message: str, exit_code: ExitCode = ExitCode.ERROR):
        """Initialize git error with message and exit code.

        Args:
            message: Description of the error
            exit_code: Git-specific exit code
        """
        # Convert ExitCode enum to int for BaseError
        super().__init__(message, exit_code.value)
        self.git_exit_code = exit_code


def error_exit(message: str, exit_code: ExitCode = ExitCode.ERROR) -> NoReturn:
    """Print error message to console and exit with specified code.

    Args:
        message: Error message to display
        exit_code: Exit code to use (default: ERROR)

    Raises:
        SystemExit: Always raised to terminate the program
    """
    console.print(f"[red]error:[/red] {message}", style="bold")
    sys.exit(exit_code.value)
