"""Daemon mode for home-sync.

Runs continuously in the background, syncing at specified intervals
with proper signal handling for graceful shutdown.
"""

import signal
import time
from pathlib import Path
from typing import Any, Optional

from home_sync.dotfiles import DotfilesSync, DotfilesSyncError, SyncConfig
from home_sync.logger import setup_logger
from home_sync.metrics import Metrics, write_metrics

logger = setup_logger(__name__)

# Global flag for shutdown
_shutdown_requested = False
_reload_config_requested = False


def _handle_sigterm(signum: int, frame: Any) -> None:
    """Handle SIGTERM signal for graceful shutdown.

    Args:
        signum: Signal number
        frame: Current stack frame
    """
    global _shutdown_requested
    logger.info("Received SIGTERM, shutting down gracefully")
    _shutdown_requested = True


def _handle_sigint(signum: int, frame: Any) -> None:
    """Handle SIGINT (Ctrl+C) signal for graceful shutdown.

    Args:
        signum: Signal number
        frame: Current stack frame
    """
    global _shutdown_requested
    logger.info("Received SIGINT, shutting down gracefully")
    _shutdown_requested = True


def _handle_sighup(signum: int, frame: Any) -> None:
    """Handle SIGHUP signal for configuration reload.

    Args:
        signum: Signal number
        frame: Current stack frame
    """
    global _reload_config_requested
    logger.info("Received SIGHUP, will reload configuration on next cycle")
    _reload_config_requested = True


def setup_signal_handlers() -> None:
    """Set up signal handlers for daemon mode."""
    signal.signal(signal.SIGTERM, _handle_sigterm)
    signal.signal(signal.SIGINT, _handle_sigint)
    signal.signal(signal.SIGHUP, _handle_sighup)

    logger.debug("Signal handlers installed")


def interruptible_sleep(duration: int) -> bool:
    """Sleep for specified duration, but check for shutdown every second.

    Args:
        duration: Sleep duration in seconds

    Returns:
        True if completed full sleep, False if interrupted
    """
    for _ in range(duration):
        if _shutdown_requested:
            return False
        time.sleep(1)
    return True


def run_daemon(
    repo_path: Path,
    interval: int = 3600,
    force_commit: bool = False,
    metrics_file: Optional[Path] = None,
) -> None:
    """Run home-sync daemon.

    Runs continuously, syncing at the specified interval until
    a shutdown signal is received.

    Args:
        repo_path: Path to dotfiles repository
        interval: Sync interval in seconds (default: 3600 = 1 hour)
        force_commit: Auto-commit uncommitted changes
        metrics_file: Optional path to metrics file

    Raises:
        DotfilesSyncError: If sync fails critically
    """
    global _shutdown_requested, _reload_config_requested

    # Set up signal handlers
    setup_signal_handlers()

    # Initialize metrics file path
    if metrics_file is None:
        metrics_file = Path.home() / ".local" / "state" / "home-sync" / "metrics.json"
        metrics_file.parent.mkdir(parents=True, exist_ok=True)

    logger.info(f"Daemon starting (interval: {interval}s)")
    logger.info(f"Repository: {repo_path}")
    logger.info(f"Force commit: {force_commit}")
    logger.info(f"Metrics file: {metrics_file}")

    # Create sync config
    config = SyncConfig(
        repo_path=repo_path,
        force_commit=force_commit,
    )

    sync_count = 0
    success_count = 0
    failure_count = 0

    try:
        while not _shutdown_requested:
            # Check if config reload requested
            if _reload_config_requested:
                logger.info("Reloading configuration")
                _reload_config_requested = False
                # In future, reload config from file here
                # For now, config is static

            # Perform sync
            sync_count += 1
            logger.info(f"Starting sync #{sync_count}")

            try:
                sync_obj = DotfilesSync(config)
                metrics = sync_obj.sync()

                if metrics.success:
                    success_count += 1
                    logger.info(
                        f"Sync #{sync_count} completed successfully "
                        f"(duration: {metrics.duration_seconds:.2f}s)"
                    )

                    if metrics.commits_created > 0:
                        logger.info(f"  Created {metrics.commits_created} commit(s)")

                    # Save metrics
                    write_metrics(metrics, metrics_file)
                else:
                    failure_count += 1
                    logger.error(f"Sync #{sync_count} failed: {metrics.error_message}")

            except DotfilesSyncError as e:
                failure_count += 1
                logger.error(f"Sync #{sync_count} failed: {e}")
                # Continue running despite failure

            except Exception as e:
                failure_count += 1
                logger.error(f"Unexpected error during sync #{sync_count}: {e}")
                # Continue running despite failure

            # Show stats
            logger.info(
                f"Daemon stats: {sync_count} syncs "
                f"({success_count} success, {failure_count} failed)"
            )

            # Sleep until next sync (interruptible)
            if not _shutdown_requested:
                logger.debug(f"Sleeping for {interval}s until next sync")
                interruptible_sleep(interval)

    except KeyboardInterrupt:
        logger.info("Keyboard interrupt received")

    finally:
        logger.info(
            f"Daemon shutting down after {sync_count} syncs "
            f"({success_count} success, {failure_count} failed)"
        )
