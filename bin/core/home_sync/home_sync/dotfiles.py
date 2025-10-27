"""Dotfiles synchronization orchestration.

This module provides high-level sync operations for dotfiles repositories,
orchestrating git operations with proper error handling and rollback support.
"""

from dataclasses import dataclass
from pathlib import Path
from typing import Optional

from home_sync.git import (
    GitConflictError,
    GitError,
    check_dirty,
    create_backup_branch,
    create_commit,
    get_branch_status,
    get_current_branch,
    git_savepoint,
    is_git_repo,
    is_remote_reachable,
    pull_changes,
    push_changes,
    stage_changes,
    BranchStatus,
)
from home_sync.logger import setup_logger
from home_sync.metrics import Metrics

logger = setup_logger(__name__)


class DotfilesSyncError(Exception):
    """Base exception for dotfiles sync operations."""

    pass


@dataclass
class SyncConfig:
    """Configuration for dotfiles sync operations."""

    repo_path: Path
    dry_run: bool = False
    force_commit: bool = False
    remote: str = "origin"
    skip_push: bool = False
    skip_pull: bool = False

    def __post_init__(self) -> None:
        """Validate configuration after initialization."""
        if not isinstance(self.repo_path, Path):
            self.repo_path = Path(self.repo_path)

        self.repo_path = self.repo_path.expanduser().resolve()


class DotfilesSync:
    """Orchestrates dotfiles synchronization with git.

    This class provides high-level sync operations for dotfiles repositories,
    including prerequisite validation, dry-run support, and comprehensive
    error handling with automatic rollback on failure.

    Example:
        sync = DotfilesSync(repo_path=Path("~/.dotfiles"))
        result = sync.sync(dry_run=False, force_commit=True)
        print(f"Sync completed: {result.success}")
    """

    def __init__(self, config: SyncConfig) -> None:
        """Initialize dotfiles sync.

        Args:
            config: Sync configuration

        Raises:
            DotfilesSyncError: If configuration is invalid
        """
        self.config = config
        self.metrics = Metrics(operation="dotfiles_sync")

        logger.info(f"Initialized DotfilesSync for {self.config.repo_path}")
        if self.config.dry_run:
            logger.info("DRY-RUN MODE: No changes will be made")

    def validate_prerequisites(self) -> None:
        """Validate prerequisites for sync operation.

        Checks:
        - Repository path exists
        - Path is a valid git repository
        - Current branch is known (not detached HEAD)

        Raises:
            DotfilesSyncError: If prerequisites are not met
        """
        logger.info("Validating prerequisites")

        # Check path exists
        if not self.config.repo_path.exists():
            raise DotfilesSyncError(
                f"Repository path does not exist: {self.config.repo_path}"
            )

        # Check is git repository
        if not is_git_repo(self.config.repo_path):
            raise DotfilesSyncError(
                f"Not a git repository: {self.config.repo_path}"
            )

        # Check not detached HEAD
        try:
            branch = get_current_branch(self.config.repo_path)
            logger.debug(f"Current branch: {branch}")
        except GitError as e:
            raise DotfilesSyncError(f"Cannot determine current branch: {e}") from e

        # Check remote connectivity if sync operations will be performed
        if not self.config.skip_pull or not self.config.skip_push:
            if not is_remote_reachable(self.config.repo_path, self.config.remote):
                if self.config.dry_run:
                    logger.warning(
                        f"Remote '{self.config.remote}' is not reachable (dry-run, continuing)"
                    )
                else:
                    raise DotfilesSyncError(
                        f"Remote '{self.config.remote}' is not reachable. "
                        f"Check network connection."
                    )

        logger.info("Prerequisites validated successfully")

    def check_status(self) -> dict[str, any]:
        """Check current repository status.

        Returns:
            Dictionary with status information:
            - is_dirty: bool - Has uncommitted changes
            - branch_status: BranchStatus - Relationship to remote
            - current_branch: str - Current branch name

        Raises:
            DotfilesSyncError: If status check fails
        """
        logger.info("Checking repository status")

        try:
            is_dirty = check_dirty(self.config.repo_path)
            branch = get_current_branch(self.config.repo_path)

            # Get branch status if not skipping sync operations
            if not self.config.skip_pull and not self.config.skip_push:
                try:
                    branch_status = get_branch_status(self.config.repo_path)
                except GitError as e:
                    logger.warning(f"Could not determine branch status: {e}")
                    branch_status = None
            else:
                branch_status = None

            status = {
                "is_dirty": is_dirty,
                "branch_status": branch_status,
                "current_branch": branch,
            }

            logger.info(
                f"Status: dirty={is_dirty}, branch={branch}, "
                f"branch_status={branch_status}"
            )

            return status

        except GitError as e:
            raise DotfilesSyncError(f"Failed to check status: {e}") from e

    def can_sync(self) -> tuple[bool, Optional[str]]:
        """Check if sync can proceed.

        Returns:
            Tuple of (can_sync, reason_if_not)

        """
        try:
            status = self.check_status()

            # Check if dirty and force not enabled
            if status["is_dirty"] and not self.config.force_commit:
                return (
                    False,
                    "Repository has uncommitted changes. "
                    "Commit manually or use --force to auto-commit.",
                )

            # Check if branches have diverged
            if status["branch_status"] == BranchStatus.DIVERGED:
                return (
                    False,
                    "Local and remote branches have diverged. "
                    "Manual merge or rebase required.",
                )

            return (True, None)

        except DotfilesSyncError as e:
            return (False, str(e))

    def sync(self) -> Metrics:
        """Perform full dotfiles synchronization.

        This method orchestrates the complete sync workflow:
        1. Validate prerequisites
        2. Check if sync can proceed
        3. Auto-commit if dirty (with --force)
        4. Pull changes (fast-forward only)
        5. Push changes
        6. Update metrics

        Returns:
            Metrics object with sync results

        Raises:
            DotfilesSyncError: If sync fails
        """
        self.metrics.start_time = __import__("time").time()
        logger.info("Starting dotfiles sync")

        try:
            # Step 1: Validate prerequisites
            self.validate_prerequisites()

            # Step 2: Check if sync can proceed
            can_proceed, reason = self.can_sync()
            if not can_proceed:
                raise DotfilesSyncError(f"Cannot sync: {reason}")

            if self.config.dry_run:
                logger.info("DRY-RUN: Sync would proceed successfully")
                self.metrics.finish(success=True)
                return self.metrics

            # Step 3: Perform sync within savepoint
            with git_savepoint(self.config.repo_path) as savepoint:
                logger.info(f"Created savepoint at {savepoint[:8]}")

                # Auto-commit if dirty
                status = self.check_status()
                if status["is_dirty"]:
                    self._handle_dirty_repo()

                # Pull changes
                if not self.config.skip_pull:
                    self._pull_changes()

                # Push changes
                if not self.config.skip_push:
                    self._push_changes()

            logger.info("Dotfiles sync completed successfully")
            self.metrics.finish(success=True)
            return self.metrics

        except (DotfilesSyncError, GitError, GitConflictError) as e:
            logger.error(f"Sync failed: {e}")
            self.metrics.finish(success=False, error_message=str(e))
            raise DotfilesSyncError(f"Sync failed: {e}") from e

        except Exception as e:
            logger.error(f"Unexpected error during sync: {e}")
            self.metrics.finish(success=False, error_message=str(e))
            raise

    def _handle_dirty_repo(self) -> None:
        """Handle uncommitted changes by auto-committing.

        Raises:
            DotfilesSyncError: If auto-commit fails
        """
        if not self.config.force_commit:
            raise DotfilesSyncError(
                "Repository has uncommitted changes but force_commit is disabled"
            )

        logger.info("Auto-committing changes (--force enabled)")

        try:
            # Create backup branch before force operations
            backup_branch = create_backup_branch(self.config.repo_path)
            logger.info(f"Created backup branch: {backup_branch}")

            # Stage all changes (including untracked files for home-sync use case)
            stage_changes(self.config.repo_path)

            # Create commit with timestamp
            import datetime

            timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            commit_message = f"Auto-commit: {timestamp}"

            commit_sha = create_commit(self.config.repo_path, commit_message)
            logger.info(f"Created commit {commit_sha[:8]}: {commit_message}")

            self.metrics.commits_created += 1

        except GitError as e:
            raise DotfilesSyncError(f"Failed to auto-commit: {e}") from e

    def _pull_changes(self) -> None:
        """Pull changes from remote.

        Raises:
            DotfilesSyncError: If pull fails
        """
        logger.info(f"Pulling changes from {self.config.remote}")

        try:
            pull_changes(
                self.config.repo_path,
                remote=self.config.remote,
                fast_forward_only=True,
            )
            logger.info("Pull completed successfully")

        except GitConflictError as e:
            raise DotfilesSyncError(f"Pull failed due to conflicts: {e}") from e

        except GitError as e:
            raise DotfilesSyncError(f"Pull failed: {e}") from e

    def _push_changes(self) -> None:
        """Push changes to remote.

        Raises:
            DotfilesSyncError: If push fails
        """
        logger.info(f"Pushing changes to {self.config.remote}")

        try:
            push_changes(self.config.repo_path, remote=self.config.remote)
            logger.info("Push completed successfully")

        except GitError as e:
            raise DotfilesSyncError(f"Push failed: {e}") from e
