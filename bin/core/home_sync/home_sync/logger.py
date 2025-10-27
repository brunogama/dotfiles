"""Logging configuration for home-sync.

Provides TTY-aware colored logging with level filtering and structured output.
"""

import logging
import sys
from enum import Enum
from typing import Optional

__all__ = ["setup_logger", "LogLevel", "get_logger"]


class LogLevel(str, Enum):
    """Log level enumeration."""

    DEBUG = "DEBUG"
    INFO = "INFO"
    WARN = "WARN"
    ERROR = "ERROR"


class ColoredFormatter(logging.Formatter):
    """Formatter that adds ANSI colors to log messages when outputting to TTY."""

    # ANSI color codes
    COLORS = {
        "DEBUG": "\033[0;36m",  # Cyan
        "INFO": "\033[0;34m",  # Blue
        "WARNING": "\033[1;33m",  # Yellow
        "ERROR": "\033[0;31m",  # Red
        "CRITICAL": "\033[1;31m",  # Bold Red
    }
    RESET = "\033[0m"

    def __init__(self, use_colors: bool = True) -> None:
        """Initialize the colored formatter.

        Args:
            use_colors: Whether to use ANSI color codes
        """
        super().__init__(fmt="[%(levelname)s] %(message)s", datefmt="%Y-%m-%d %H:%M:%S")
        self.use_colors = use_colors

    def format(self, record: logging.LogRecord) -> str:
        """Format the log record with optional colors.

        Args:
            record: The log record to format

        Returns:
            Formatted log message
        """
        if self.use_colors and record.levelname in self.COLORS:
            levelname = record.levelname
            record.levelname = f"{self.COLORS[levelname]}{levelname}{self.RESET}"
            result = super().format(record)
            # Restore original levelname for other formatters
            record.levelname = levelname
            return result
        return super().format(record)


def setup_logger(
    name: str = "home_sync",
    level: LogLevel = LogLevel.INFO,
    force_colors: Optional[bool] = None,
) -> logging.Logger:
    """Set up and configure the logger.

    Args:
        name: Logger name
        level: Logging level (DEBUG, INFO, WARN, ERROR)
        force_colors: Force color output (None=auto-detect TTY, True=always, False=never)

    Returns:
        Configured logger instance

    Example:
        >>> logger = setup_logger("home_sync", LogLevel.DEBUG)
        >>> logger.info("Starting sync")
    """
    logger = logging.getLogger(name)
    logger.setLevel(getattr(logging, level.value))

    # Remove existing handlers to avoid duplicates
    logger.handlers.clear()

    # Create console handler
    handler = logging.StreamHandler(sys.stderr)
    handler.setLevel(getattr(logging, level.value))

    # Determine if we should use colors
    use_colors = force_colors if force_colors is not None else sys.stderr.isatty()

    # Set formatter
    formatter = ColoredFormatter(use_colors=use_colors)
    handler.setFormatter(formatter)

    logger.addHandler(handler)
    return logger


def get_logger(name: str = "home_sync") -> logging.Logger:
    """Get an existing logger instance.

    Args:
        name: Logger name

    Returns:
        Logger instance

    Example:
        >>> log = get_logger()
        >>> log.info("Status message")
    """
    return logging.getLogger(name)
