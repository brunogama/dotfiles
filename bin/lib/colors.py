"""ANSI color codes and formatting for terminal output.

This module provides color constants and formatting functions for
consistent terminal output across all Python scripts.
"""

# ANSI Color Codes
RESET = "\033[0m"
BOLD = "\033[1m"
DIM = "\033[2m"
UNDERLINE = "\033[4m"

# Foreground Colors
BLACK = "\033[0;30m"
RED = "\033[0;31m"
GREEN = "\033[0;32m"
YELLOW = "\033[0;33m"
BLUE = "\033[0;34m"
MAGENTA = "\033[0;35m"
CYAN = "\033[0;36m"
WHITE = "\033[0;37m"

# Bright Foreground Colors
BRIGHT_BLACK = "\033[0;90m"
BRIGHT_RED = "\033[0;91m"
BRIGHT_GREEN = "\033[0;92m"
BRIGHT_YELLOW = "\033[0;93m"
BRIGHT_BLUE = "\033[0;94m"
BRIGHT_MAGENTA = "\033[0;95m"
BRIGHT_CYAN = "\033[0;96m"
BRIGHT_WHITE = "\033[0;97m"


def format_error(message: str) -> str:
    """Format an error message with red color.

    Args:
        message: The message to format

    Returns:
        Formatted message with color codes
    """
    return f"{RED}{message}{RESET}"


def format_success(message: str) -> str:
    """Format a success message with green color.

    Args:
        message: The message to format

    Returns:
        Formatted message with color codes
    """
    return f"{GREEN}{message}{RESET}"


def format_warning(message: str) -> str:
    """Format a warning message with yellow color.

    Args:
        message: The message to format

    Returns:
        Formatted message with color codes
    """
    return f"{YELLOW}{message}{RESET}"


def format_info(message: str) -> str:
    """Format an informational message with blue color.

    Args:
        message: The message to format

    Returns:
        Formatted message with color codes
    """
    return f"{BLUE}{message}{RESET}"


def strip_ansi(text: str) -> str:
    """Remove ANSI color codes from text.

    Args:
        text: Text potentially containing ANSI codes

    Returns:
        Text with all ANSI codes removed
    """
    import re

    ansi_escape = re.compile(r"\033\[[0-9;]*m")
    return ansi_escape.sub("", text)
