"""General-purpose utility library for Python scripts.

This package provides shared utilities used across all Python scripts in the
dotfiles repository, including:

- common: General utility functions
- colors: ANSI color codes and formatting
- logging: Structured logging framework
- validation: Common input validation
- error_handling: Consistent error patterns

These modules promote code reuse and consistency across bin/core/,
bin/credentials/, bin/git/, and other script categories.
"""

__version__ = "1.0.0"
__all__ = ["common", "colors", "logging", "validation", "error_handling"]
