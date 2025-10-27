"""General utility functions for Python scripts.

This module provides common utility functions used across all Python scripts,
including path helpers, file operations, and string utilities.
"""

import json
from pathlib import Path
from typing import Any, Dict, Optional


def ensure_directory(path: Path) -> Path:
    """Ensure a directory exists, creating it if necessary.

    Args:
        path: Path to directory

    Returns:
        The path object (for chaining)

    Raises:
        OSError: If directory cannot be created
    """
    path.mkdir(parents=True, exist_ok=True)
    return path


def read_json_file(path: Path) -> Dict[str, Any]:
    """Read and parse a JSON file.

    Args:
        path: Path to JSON file

    Returns:
        Parsed JSON data as dictionary

    Raises:
        FileNotFoundError: If file doesn't exist
        json.JSONDecodeError: If file contains invalid JSON
    """
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def write_json_file(path: Path, data: Dict[str, Any], indent: int = 2) -> None:
    """Write data to a JSON file.

    Args:
        path: Path to JSON file
        data: Data to write
        indent: Number of spaces for indentation (default: 2)

    Raises:
        OSError: If file cannot be written
    """
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=indent)
        f.write("\n")  # Add trailing newline


def get_script_dir() -> Path:
    """Get the directory containing the calling script.

    Returns:
        Path to the directory containing the script

    Note:
        This function inspects the call stack, so it should be
        called directly from the main script, not from imported modules.
    """
    import inspect

    frame = inspect.stack()[1]
    module = inspect.getmodule(frame[0])
    if module and module.__file__:
        return Path(module.__file__).parent.resolve()
    return Path.cwd()


def truncate_string(text: str, max_length: int, suffix: str = "...") -> str:
    """Truncate a string to maximum length with suffix.

    Args:
        text: String to truncate
        max_length: Maximum length including suffix
        suffix: Suffix to append when truncated (default: "...")

    Returns:
        Truncated string

    Raises:
        ValueError: If max_length is less than suffix length
    """
    if max_length < len(suffix):
        raise ValueError("max_length must be >= suffix length")

    if len(text) <= max_length:
        return text

    return text[: max_length - len(suffix)] + suffix
