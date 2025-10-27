"""Tests for lock module."""

import os
import time
from multiprocessing import Process, Queue
from pathlib import Path
from typing import Any

import pytest

from home_sync.lock import (
    LOCK_TIMEOUT,
    LockError,
    _check_stale_lock,
    _is_process_running,
    _read_lock_info,
    acquire_lock,
)


# Module-level worker functions for multiprocessing tests
def _lock_worker_timeout(lock_file: Path, queue: Queue) -> None:
    """Worker process that tries to acquire lock with timeout."""
    try:
        with acquire_lock(lock_file=lock_file, timeout=2):
            queue.put("acquired")
    except LockError:
        queue.put("timeout")


def _lock_worker_hold(lock_file: Path, duration: float) -> None:
    """Worker that holds lock for specified duration."""
    with acquire_lock(lock_file=lock_file, timeout=10):
        time.sleep(duration)


def _lock_worker_counter(lock_file: Path, counter_file: Path, worker_id: int) -> None:
    """Worker that increments counter while holding lock."""
    with acquire_lock(lock_file=lock_file, timeout=10):
        # Read counter
        count = int(counter_file.read_text())
        # Simulate some work
        time.sleep(0.1)
        # Increment and write back
        counter_file.write_text(str(count + 1))


def _lock_worker_wait(lock_file: Path, queue: Queue) -> None:
    """Wait for lock and signal success."""
    try:
        with acquire_lock(lock_file=lock_file, timeout=10):
            queue.put("success")
    except LockError:
        queue.put("failed")


class TestIsProcessRunning:
    """Test cases for _is_process_running helper."""

    def test_current_process_running(self) -> None:
        """Test that current process is detected as running."""
        assert _is_process_running(os.getpid()) is True

    def test_nonexistent_process(self) -> None:
        """Test that nonexistent process is detected as not running."""
        # Use a very high PID that's unlikely to exist
        assert _is_process_running(999999) is False

    def test_parent_process(self) -> None:
        """Test that parent process is detected as running."""
        # Parent process should be running
        assert _is_process_running(os.getppid()) is True


class TestReadLockInfo:
    """Test cases for _read_lock_info helper."""

    def test_read_valid_lock_info(self, tmp_path: Path) -> None:
        """Test reading valid lock file."""
        lock_file = tmp_path / "test.lock"
        lock_file.write_text(f"{os.getpid()}:{int(time.time())}\n")

        result = _read_lock_info(lock_file)

        assert result is not None
        pid, timestamp = result
        assert pid == os.getpid()
        assert isinstance(timestamp, float)

    def test_read_invalid_format(self, tmp_path: Path) -> None:
        """Test reading lock file with invalid format."""
        lock_file = tmp_path / "test.lock"
        lock_file.write_text("invalid content")

        result = _read_lock_info(lock_file)

        assert result is None

    def test_read_empty_file(self, tmp_path: Path) -> None:
        """Test reading empty lock file."""
        lock_file = tmp_path / "test.lock"
        lock_file.write_text("")

        result = _read_lock_info(lock_file)

        assert result is None

    def test_read_nonexistent_file(self, tmp_path: Path) -> None:
        """Test reading nonexistent lock file."""
        lock_file = tmp_path / "nonexistent.lock"

        result = _read_lock_info(lock_file)

        assert result is None


class TestCheckStaleLock:
    """Test cases for _check_stale_lock helper."""

    def test_nonexistent_lock_not_stale(self, tmp_path: Path) -> None:
        """Test that nonexistent lock is not considered stale."""
        lock_file = tmp_path / "test.lock"

        assert _check_stale_lock(lock_file) is False

    def test_current_process_not_stale(self, tmp_path: Path) -> None:
        """Test that lock from current process is not stale."""
        lock_file = tmp_path / "test.lock"
        lock_file.write_text(f"{os.getpid()}:{int(time.time())}\n")

        assert _check_stale_lock(lock_file) is False

    def test_dead_process_is_stale(self, tmp_path: Path) -> None:
        """Test that lock from dead process is stale."""
        lock_file = tmp_path / "test.lock"
        # Use a very high PID that's unlikely to exist
        lock_file.write_text(f"999999:{int(time.time())}\n")

        assert _check_stale_lock(lock_file) is True

    def test_invalid_lock_is_stale(self, tmp_path: Path) -> None:
        """Test that invalid lock file is considered stale."""
        lock_file = tmp_path / "test.lock"
        lock_file.write_text("invalid")

        assert _check_stale_lock(lock_file) is True


class TestAcquireLock:
    """Test cases for acquire_lock context manager."""

    def test_acquire_and_release(self, tmp_path: Path) -> None:
        """Test basic lock acquisition and release."""
        lock_file = tmp_path / "test.lock"

        with acquire_lock(lock_file=lock_file):
            # Lock should be held
            assert lock_file.exists()

        # Lock should be released and file removed
        assert not lock_file.exists()

    def test_lock_file_contains_pid(self, tmp_path: Path) -> None:
        """Test that lock file contains PID and timestamp."""
        lock_file = tmp_path / "test.lock"

        with acquire_lock(lock_file=lock_file):
            lock_info = _read_lock_info(lock_file)
            assert lock_info is not None
            pid, timestamp = lock_info
            assert pid == os.getpid()
            assert timestamp <= time.time()

    def test_lock_prevents_concurrent_access(self, tmp_path: Path) -> None:
        """Test that lock prevents concurrent access."""
        lock_file = tmp_path / "test.lock"

        with acquire_lock(lock_file=lock_file):
            # Start another process that tries to acquire lock
            queue: Queue = Queue()
            proc = Process(target=_lock_worker_timeout, args=(lock_file, queue))
            proc.start()

            # Wait for worker to timeout
            proc.join(timeout=5)

            # Worker should have timed out
            result = queue.get(timeout=1) if not queue.empty() else None
            assert result == "timeout"

    def test_lock_released_after_exception(self, tmp_path: Path) -> None:
        """Test that lock is released even if exception occurs."""
        lock_file = tmp_path / "test.lock"

        with pytest.raises(ValueError):
            with acquire_lock(lock_file=lock_file):
                raise ValueError("test error")

        # Lock should be released
        assert not lock_file.exists()

    def test_timeout_error(self, tmp_path: Path) -> None:
        """Test that timeout raises LockError."""
        lock_file = tmp_path / "test.lock"

        # Start worker that holds lock
        proc = Process(target=_lock_worker_hold, args=(lock_file, 3))
        proc.start()

        # Give worker time to acquire lock
        time.sleep(0.5)

        try:
            # Try to acquire lock with short timeout
            with pytest.raises(LockError, match="Could not acquire lock"):
                with acquire_lock(lock_file=lock_file, timeout=1):
                    pass
        finally:
            proc.join(timeout=5)
            if proc.is_alive():
                proc.terminate()

    def test_stale_lock_removed(self, tmp_path: Path) -> None:
        """Test that stale lock is detected and removed."""
        lock_file = tmp_path / "test.lock"

        # Create stale lock from dead process
        lock_file.write_text(f"999999:{int(time.time())}\n")

        # Should be able to acquire lock after removing stale one
        with acquire_lock(lock_file=lock_file, timeout=5):
            assert lock_file.exists()

        assert not lock_file.exists()

    def test_no_stale_check(self, tmp_path: Path) -> None:
        """Test disabling stale lock check."""
        lock_file = tmp_path / "test.lock"

        # Create stale lock from dead process
        lock_file.write_text(f"999999:{int(time.time())}\n")

        # Lock file physically exists, but process is dead
        # With check_stale=False, this should still eventually succeed
        # because the lock isn't actually held (process is dead)
        with acquire_lock(lock_file=lock_file, timeout=5, check_stale=False):
            pass

    def test_creates_parent_directory(self, tmp_path: Path) -> None:
        """Test that parent directory is created if needed."""
        lock_file = tmp_path / "nested" / "dir" / "test.lock"

        with acquire_lock(lock_file=lock_file):
            assert lock_file.parent.exists()

        assert not lock_file.exists()

    def test_sequential_acquisitions(self, tmp_path: Path) -> None:
        """Test multiple sequential lock acquisitions."""
        lock_file = tmp_path / "test.lock"

        # First acquisition
        with acquire_lock(lock_file=lock_file):
            pass

        # Second acquisition should work immediately
        with acquire_lock(lock_file=lock_file):
            pass

        # Third acquisition
        with acquire_lock(lock_file=lock_file):
            pass

        assert not lock_file.exists()


class TestLockIntegration:
    """Integration tests for lock functionality."""

    def test_multiple_processes_sequential(self, tmp_path: Path) -> None:
        """Test that multiple processes can acquire lock sequentially."""
        lock_file = tmp_path / "test.lock"
        counter_file = tmp_path / "counter.txt"
        counter_file.write_text("0")

        # Start multiple workers
        processes = []
        for i in range(5):
            proc = Process(target=_lock_worker_counter, args=(lock_file, counter_file, i))
            proc.start()
            processes.append(proc)

        # Wait for all to complete
        for proc in processes:
            proc.join(timeout=30)

        # Counter should be exactly 5 (no race conditions)
        final_count = int(counter_file.read_text())
        assert final_count == 5

    def test_lock_survives_keyboard_interrupt(self, tmp_path: Path) -> None:
        """Test that lock is released on KeyboardInterrupt."""
        lock_file = tmp_path / "test.lock"

        with pytest.raises(KeyboardInterrupt):
            with acquire_lock(lock_file=lock_file):
                raise KeyboardInterrupt()

        # Lock should still be released
        assert not lock_file.exists()

    def test_concurrent_with_retry(self, tmp_path: Path) -> None:
        """Test that waiting process eventually gets lock."""
        lock_file = tmp_path / "test.lock"

        # Start holder that keeps lock for 2 seconds
        holder_proc = Process(target=_lock_worker_hold, args=(lock_file, 2))
        holder_proc.start()

        # Give holder time to acquire lock
        time.sleep(0.5)

        # Start waiter that should get lock after holder releases
        queue: Queue = Queue()
        waiter_proc = Process(target=_lock_worker_wait, args=(lock_file, queue))
        waiter_proc.start()

        # Wait for both to complete
        holder_proc.join(timeout=5)
        waiter_proc.join(timeout=15)

        # Waiter should have succeeded
        result = queue.get(timeout=1) if not queue.empty() else None
        assert result == "success"
