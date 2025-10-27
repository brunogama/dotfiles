"""File locking for home-sync to prevent concurrent operations.

Provides atomic, race-free file locking using fcntl with stale lock detection.
"""

import fcntl
import os
import time
from contextlib import contextmanager
from pathlib import Path
from typing import Iterator, Optional

from home_sync.logger import get_logger

__all__ = ["acquire_lock", "LockError", "LOCK_FILE", "LOCK_TIMEOUT"]

# Default lock file location
LOCK_FILE = Path("/tmp/home-sync.lock")

# Default lock timeout in seconds (5 minutes)
LOCK_TIMEOUT = 300

logger = get_logger(__name__)


class LockError(Exception):
    """Raised when lock acquisition fails."""

    pass


def _is_process_running(pid: int) -> bool:
    """Check if a process with given PID is running.

    Args:
        pid: Process ID to check

    Returns:
        True if process is running, False otherwise
    """
    try:
        # Send signal 0 to check if process exists
        # This doesn't actually send a signal, just checks permissions
        os.kill(pid, 0)
        return True
    except OSError:
        # Process doesn't exist or we don't have permission
        return False


def _read_lock_info(lock_file: Path) -> Optional[tuple[int, float]]:
    """Read PID and timestamp from lock file.

    Args:
        lock_file: Path to lock file

    Returns:
        Tuple of (pid, timestamp) or None if file is invalid
    """
    try:
        content = lock_file.read_text().strip()
        if not content:
            return None

        parts = content.split(":")
        if len(parts) != 2:
            return None

        pid = int(parts[0])
        timestamp = float(parts[1])
        return (pid, timestamp)
    except (ValueError, OSError):
        return None


def _check_stale_lock(lock_file: Path) -> bool:
    """Check if lock file is stale (process no longer running).

    Args:
        lock_file: Path to lock file

    Returns:
        True if lock is stale and can be removed, False otherwise
    """
    if not lock_file.exists():
        return False

    lock_info = _read_lock_info(lock_file)
    if lock_info is None:
        # Invalid lock file format, consider it stale
        logger.warning(f"Found invalid lock file: {lock_file}")
        return True

    pid, timestamp = lock_info

    # Check if process is still running
    if not _is_process_running(pid):
        age = time.time() - timestamp
        logger.warning(
            f"Found stale lock from PID {pid} (age: {age:.1f}s), removing"
        )
        return True

    return False


@contextmanager
def acquire_lock(
    lock_file: Path = LOCK_FILE,
    timeout: int = LOCK_TIMEOUT,
    check_stale: bool = True,
) -> Iterator[None]:
    """Acquire an exclusive file lock with automatic cleanup.

    This context manager provides atomic, race-free file locking using fcntl.
    The lock is automatically released when the context exits.

    Args:
        lock_file: Path to lock file (default: /tmp/home-sync.lock)
        timeout: Maximum time to wait for lock in seconds (default: 300)
        check_stale: Check for and remove stale locks (default: True)

    Yields:
        None (lock is held during context)

    Raises:
        LockError: If lock cannot be acquired within timeout
        OSError: If lock file operations fail

    Example:
        >>> with acquire_lock():
        ...     # Perform synchronized operations
        ...     sync_dotfiles()
        ...     sync_credentials()

    Note:
        Uses fcntl.flock() which is advisory locking. All processes must
        cooperate by using the same lock file.
    """
    fd: Optional[int] = None
    start_time = time.time()

    try:
        # Check for stale lock before attempting acquisition
        if check_stale and _check_stale_lock(lock_file):
            try:
                lock_file.unlink(missing_ok=True)
            except OSError as e:
                logger.warning(f"Failed to remove stale lock: {e}")

        # Open lock file (create if doesn't exist)
        lock_file.parent.mkdir(parents=True, exist_ok=True)
        fd = os.open(str(lock_file), os.O_CREAT | os.O_WRONLY, 0o644)

        # Try to acquire lock with timeout
        while True:
            assert fd is not None, "File descriptor should not be None"

            try:
                # Try non-blocking lock acquisition
                fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)

                # Successfully acquired lock
                logger.debug(f"Acquired lock: {lock_file}")

                # Write PID and timestamp to lock file
                lock_info = f"{os.getpid()}:{int(time.time())}\n"
                os.write(fd, lock_info.encode())
                os.fsync(fd)

                # Lock acquired successfully
                yield

                # Exit normally after context completes
                return

            except BlockingIOError:
                # Lock is held by another process
                elapsed = time.time() - start_time

                if elapsed >= timeout:
                    # Check if holder is still running
                    lock_holder_info = _read_lock_info(lock_file)
                    if lock_holder_info:
                        pid, timestamp = lock_holder_info
                        if _is_process_running(pid):
                            raise LockError(
                                f"Could not acquire lock after {timeout}s. "
                                f"Lock held by PID {pid} since {timestamp}"
                            )
                        else:
                            # Process died but lock wasn't cleaned up
                            logger.warning(
                                f"Lock holder PID {pid} is dead, removing lock"
                            )
                            try:
                                fcntl.flock(fd, fcntl.LOCK_UN)
                                os.close(fd)
                                fd = None
                                lock_file.unlink(missing_ok=True)
                                # Retry acquisition
                                continue
                            except OSError:
                                raise LockError(
                                    f"Could not acquire lock after {timeout}s"
                                )
                    else:
                        raise LockError(
                            f"Could not acquire lock after {timeout}s"
                        )

                # Wait before retrying
                time.sleep(0.1)

    finally:
        # Clean up: release lock and remove file
        if fd is not None:
            try:
                fcntl.flock(fd, fcntl.LOCK_UN)
            except OSError as e:
                logger.warning(f"Failed to unlock file: {e}")

            try:
                os.close(fd)
            except OSError as e:
                logger.warning(f"Failed to close lock file: {e}")

        # Remove lock file
        try:
            lock_file.unlink(missing_ok=True)
            logger.debug(f"Released lock: {lock_file}")
        except OSError as e:
            logger.warning(f"Failed to remove lock file: {e}")
