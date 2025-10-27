"""Repository validation functions for git scripts.

This module provides validation functions that check the state of the git
repository and exit with appropriate error messages if validation fails.
"""

import sys
from pathlib import Path

# Add paths for module imports
sys.path.insert(0, str(Path(__file__).parent))  # For git/lib/
sys.path.insert(0, str(Path(__file__).parent.parent.parent))  # For bin/lib/

from git_common import ExitCode, error_exit
from git_operations import Git


def check_git_repo() -> None:
    """Verify we're in a git repository.

    Raises:
        SystemExit: With NOT_GIT_REPO code if not in a git repository
    """
    if not Git.is_repo():
        error_exit("Not a git repository", ExitCode.NOT_GIT_REPO)


def check_not_detached_head() -> None:
    """Verify we're not in detached HEAD state.

    Raises:
        SystemExit: With DETACHED_HEAD code if in detached HEAD state
    """
    if Git.is_detached_head():
        error_exit(
            "You are in detached HEAD state. "
            "Please checkout a branch first:\n  git checkout main",
            ExitCode.DETACHED_HEAD,
        )


def check_clean_working_tree() -> None:
    """Verify working tree is clean (no uncommitted changes).

    Raises:
        SystemExit: With DIRTY_WORKING_TREE code if there are uncommitted changes
    """
    if Git.has_uncommitted_changes():
        error_exit(
            "Working directory has uncommitted changes.\n"
            "Please commit or stash your changes first:\n"
            "  git stash push -m 'WIP before feature merge'",
            ExitCode.DIRTY_WORKING_TREE,
        )
