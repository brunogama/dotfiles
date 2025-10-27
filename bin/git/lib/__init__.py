"""Git-specific utility library for git Python scripts.

This package provides git-specific utilities for managing worktrees, branches,
and repository operations, including:

- git_common: Common git utilities (ExitCode, GitError, error_exit)
- git_operations: Git command wrapper and smart-merge integration
- git_validation: Repository validation functions
- git_metadata: Metadata serialization for git features

These modules build on top of bin.lib for general utilities and provide
domain-specific functionality for git scripts.
"""

__version__ = "1.0.0"
__all__ = ["git_common", "git_operations", "git_validation", "git_metadata"]
