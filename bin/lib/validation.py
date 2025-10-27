"""Common input validation functions.

This module provides validation functions for common input types,
helping ensure data integrity across all Python scripts.
"""

import re
from pathlib import Path
from typing import Any, Optional


class ValidationError(ValueError):
    """Exception raised when validation fails."""

    pass


def validate_non_empty(value: str, name: str = "value") -> str:
    """Validate that a string is not empty.

    Args:
        value: String to validate
        name: Name of the value for error messages

    Returns:
        The validated string

    Raises:
        ValidationError: If string is empty or whitespace-only
    """
    if not value or not value.strip():
        raise ValidationError(f"{name} cannot be empty")
    return value


def validate_path(
    path: Path | str, name: str = "path", must_exist: bool = False
) -> Path:
    """Validate a file system path.

    Args:
        path: Path to validate
        name: Name of the path for error messages
        must_exist: Whether the path must exist (default: False)

    Returns:
        The validated Path object

    Raises:
        ValidationError: If path is invalid or doesn't exist when required
    """
    if isinstance(path, str):
        path = Path(path)

    if must_exist and not path.exists():
        raise ValidationError(f"{name} does not exist: {path}")

    return path


def validate_range(
    value: int | float,
    name: str = "value",
    min_val: Optional[int | float] = None,
    max_val: Optional[int | float] = None,
) -> int | float:
    """Validate that a number is within a specified range.

    Args:
        value: Number to validate
        name: Name of the value for error messages
        min_val: Minimum allowed value (inclusive, optional)
        max_val: Maximum allowed value (inclusive, optional)

    Returns:
        The validated number

    Raises:
        ValidationError: If value is out of range
    """
    if min_val is not None and value < min_val:
        raise ValidationError(f"{name} must be >= {min_val}, got {value}")

    if max_val is not None and value > max_val:
        raise ValidationError(f"{name} must be <= {max_val}, got {value}")

    return value


def validate_choice(value: Any, choices: list, name: str = "value") -> Any:
    """Validate that a value is one of the allowed choices.

    Args:
        value: Value to validate
        choices: List of allowed choices
        name: Name of the value for error messages

    Returns:
        The validated value

    Raises:
        ValidationError: If value is not in choices
    """
    if value not in choices:
        raise ValidationError(
            f"{name} must be one of {choices}, got {value!r}"
        )
    return value
