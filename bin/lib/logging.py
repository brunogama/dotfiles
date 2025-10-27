"""Structured logging framework for Python scripts.

This module provides a consistent logging interface for all Python scripts,
with support for different log levels and formatted output.
"""

import logging
import sys
from enum import IntEnum
from typing import Optional


class LogLevel(IntEnum):
    """Log levels for structured logging."""

    DEBUG = logging.DEBUG
    INFO = logging.INFO
    WARNING = logging.WARNING
    ERROR = logging.ERROR
    CRITICAL = logging.CRITICAL


# Default log format
DEFAULT_FORMAT = "%(levelname)s: %(message)s"
DETAILED_FORMAT = "%(asctime)s [%(levelname)s] %(name)s: %(message)s"


def get_logger(name: str, level: LogLevel = LogLevel.INFO) -> logging.Logger:
    """Get or create a logger with the specified name and level.

    Args:
        name: Logger name (typically __name__)
        level: Log level (default: INFO)

    Returns:
        Configured logger instance
    """
    logger = logging.getLogger(name)

    # Only configure if not already configured
    if not logger.handlers:
        logger.setLevel(level)

        # Console handler
        handler = logging.StreamHandler(sys.stderr)
        handler.setLevel(level)

        # Formatter
        formatter = logging.Formatter(DEFAULT_FORMAT)
        handler.setFormatter(formatter)

        logger.addHandler(handler)

    return logger


def set_log_level(logger: logging.Logger, level: LogLevel) -> None:
    """Set the log level for a logger and its handlers.

    Args:
        logger: Logger to configure
        level: New log level
    """
    logger.setLevel(level)
    for handler in logger.handlers:
        handler.setLevel(level)


def configure_root_logger(
    level: LogLevel = LogLevel.INFO, detailed: bool = False
) -> logging.Logger:
    """Configure the root logger for the application.

    Args:
        level: Log level to use (default: INFO)
        detailed: Whether to use detailed format with timestamps (default: False)

    Returns:
        Configured root logger
    """
    logger = logging.getLogger()
    logger.setLevel(level)

    # Remove existing handlers
    for handler in logger.handlers[:]:
        logger.removeHandler(handler)

    # Add new handler
    handler = logging.StreamHandler(sys.stderr)
    handler.setLevel(level)

    # Set formatter
    fmt = DETAILED_FORMAT if detailed else DEFAULT_FORMAT
    formatter = logging.Formatter(fmt)
    handler.setFormatter(formatter)

    logger.addHandler(handler)

    return logger


def enable_debug_logging() -> None:
    """Enable debug logging for the root logger."""
    configure_root_logger(LogLevel.DEBUG, detailed=True)


def disable_logging() -> None:
    """Disable all logging output."""
    logging.disable(logging.CRITICAL)
