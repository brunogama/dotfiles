"""Consistent error handling patterns and exit codes.

This module provides standardized error handling for all Python scripts,
including base exception classes and common exit codes.
"""

from enum import IntEnum
from typing import NoReturn


class ExitCode(IntEnum):
    """Standard exit codes for script execution."""

    SUCCESS = 0
    ERROR = 1
    INVALID_USAGE = 2
    NOT_FOUND = 3
    PERMISSION_DENIED = 4
    TIMEOUT = 5
    CANCELLED = 130  # SIGINT


class BaseError(Exception):
    """Base exception class for script errors.

    Attributes:
        message: Error message
        exit_code: Associated exit code (default: ERROR)
    """

    def __init__(self, message: str, exit_code: ExitCode = ExitCode.ERROR):
        """Initialize error with message and exit code.

        Args:
            message: Description of the error
            exit_code: Exit code to use when this error terminates the program
        """
        super().__init__(message)
        self.message = message
        self.exit_code = exit_code

    def __str__(self) -> str:
        """Return error message as string."""
        return self.message


def exit_with_error(message: str, exit_code: ExitCode = ExitCode.ERROR) -> NoReturn:
    """Print error message and exit with specified code.

    Args:
        message: Error message to display
        exit_code: Exit code to use (default: ERROR)

    Raises:
        SystemExit: Always raised to terminate the program
    """
    import sys

    print(f"error: {message}", file=sys.stderr)
    sys.exit(exit_code)


def handle_keyboard_interrupt(func):
    """Decorator to handle Ctrl+C gracefully.

    Args:
        func: Function to wrap

    Returns:
        Wrapped function that catches KeyboardInterrupt
    """

    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except KeyboardInterrupt:
            import sys

            print("\nOperation cancelled by user", file=sys.stderr)
            sys.exit(ExitCode.CANCELLED)

    return wrapper
