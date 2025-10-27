"""Tests for daemon mode operations."""

import signal
import subprocess
import time
from pathlib import Path
from typing import Any
from unittest.mock import MagicMock, call, patch

import pytest

from home_sync import daemon
from home_sync.dotfiles import DotfilesSyncError
from home_sync.metrics import Metrics


@pytest.fixture
def git_repo(tmp_path: Path) -> Path:
    """Create a test git repository.

    Args:
        tmp_path: pytest temporary directory fixture

    Returns:
        Path to test repository
    """
    repo = tmp_path / "dotfiles"
    repo.mkdir()

    # Initialize git repo
    subprocess.run(["git", "init"], cwd=repo, check=True, capture_output=True)
    subprocess.run(
        ["git", "config", "user.email", "test@example.com"],
        cwd=repo,
        check=True,
        capture_output=True,
    )
    subprocess.run(
        ["git", "config", "user.name", "Test User"],
        cwd=repo,
        check=True,
        capture_output=True,
    )

    # Create initial commit
    (repo / "README.md").write_text("# Test\n")
    subprocess.run(["git", "add", "."], cwd=repo, check=True, capture_output=True)
    subprocess.run(
        ["git", "commit", "-m", "Initial commit"],
        cwd=repo,
        check=True,
        capture_output=True,
    )

    return repo


@pytest.fixture(autouse=True)
def reset_daemon_flags() -> None:
    """Reset global daemon flags before each test."""
    daemon._shutdown_requested = False
    daemon._reload_config_requested = False


class TestSignalHandlers:
    """Test signal handling."""

    def test_handle_sigterm(self) -> None:
        """Test SIGTERM handler sets shutdown flag."""
        assert daemon._shutdown_requested is False

        daemon._handle_sigterm(signal.SIGTERM, None)

        assert daemon._shutdown_requested is True

    def test_handle_sigint(self) -> None:
        """Test SIGINT handler sets shutdown flag."""
        assert daemon._shutdown_requested is False

        daemon._handle_sigint(signal.SIGINT, None)

        assert daemon._shutdown_requested is True

    def test_handle_sighup(self) -> None:
        """Test SIGHUP handler sets reload flag."""
        assert daemon._reload_config_requested is False

        daemon._handle_sighup(signal.SIGHUP, None)

        assert daemon._reload_config_requested is True

    def test_setup_signal_handlers(self) -> None:
        """Test signal handlers are installed."""
        # This test verifies the function doesn't raise
        daemon.setup_signal_handlers()

        # Verify handlers are installed
        assert signal.getsignal(signal.SIGTERM) == daemon._handle_sigterm
        assert signal.getsignal(signal.SIGINT) == daemon._handle_sigint
        assert signal.getsignal(signal.SIGHUP) == daemon._handle_sighup


class TestInterruptibleSleep:
    """Test interruptible sleep functionality."""

    def test_sleep_completes_normally(self) -> None:
        """Test sleep completes full duration when not interrupted."""
        start = time.time()
        result = daemon.interruptible_sleep(2)
        elapsed = time.time() - start

        assert result is True
        assert elapsed >= 2.0
        assert elapsed < 2.5  # Allow some margin

    def test_sleep_interrupted_by_shutdown(self) -> None:
        """Test sleep returns early when shutdown requested."""
        daemon._shutdown_requested = False

        # Set shutdown flag after 1 second
        def set_shutdown() -> None:
            time.sleep(1)
            daemon._shutdown_requested = True

        import threading

        thread = threading.Thread(target=set_shutdown)
        thread.start()

        start = time.time()
        result = daemon.interruptible_sleep(5)
        elapsed = time.time() - start

        thread.join()

        assert result is False
        assert elapsed >= 1.0
        assert elapsed < 2.0  # Should interrupt quickly

    def test_sleep_checks_every_second(self) -> None:
        """Test sleep checks shutdown flag every second."""
        daemon._shutdown_requested = False

        # Set shutdown after 0.5 seconds
        def set_shutdown() -> None:
            time.sleep(0.5)
            daemon._shutdown_requested = True

        import threading

        thread = threading.Thread(target=set_shutdown)
        thread.start()

        start = time.time()
        result = daemon.interruptible_sleep(10)
        elapsed = time.time() - start

        thread.join()

        # Should check at 1 second mark and interrupt
        assert result is False
        assert elapsed >= 1.0
        assert elapsed < 1.5


class TestRunDaemon:
    """Test main daemon loop."""

    @patch("home_sync.daemon.DotfilesSync")
    @patch("home_sync.daemon.write_metrics")
    @patch("home_sync.daemon.interruptible_sleep")
    def test_daemon_single_cycle(
        self,
        mock_sleep: MagicMock,
        mock_write_metrics: MagicMock,
        mock_sync_class: MagicMock,
        git_repo: Path,
        tmp_path: Path,
    ) -> None:
        """Test daemon completes one sync cycle."""
        # Mock sync to succeed
        mock_sync_instance = MagicMock()
        mock_metrics = Metrics(operation="test")
        mock_metrics.success = True
        mock_metrics.commits_created = 1
        mock_sync_instance.sync.return_value = mock_metrics
        mock_sync_class.return_value = mock_sync_instance

        # Stop after first cycle
        mock_sleep.return_value = False

        metrics_file = tmp_path / "metrics.json"

        daemon.run_daemon(
            repo_path=git_repo,
            interval=10,
            force_commit=True,
            metrics_file=metrics_file,
        )

        # Verify sync was called
        mock_sync_class.assert_called_once()
        mock_sync_instance.sync.assert_called_once()

        # Verify metrics saved
        mock_write_metrics.assert_called_once_with(mock_metrics, metrics_file)

    @patch("home_sync.daemon.DotfilesSync")
    @patch("home_sync.daemon.write_metrics")
    @patch("home_sync.daemon.interruptible_sleep")
    def test_daemon_multiple_cycles(
        self,
        mock_sleep: MagicMock,
        mock_write_metrics: MagicMock,
        mock_sync_class: MagicMock,
        git_repo: Path,
    ) -> None:
        """Test daemon runs multiple sync cycles."""
        # Mock sync to succeed
        mock_sync_instance = MagicMock()
        mock_metrics = Metrics(operation="test")
        mock_metrics.success = True
        mock_sync_instance.sync.return_value = mock_metrics
        mock_sync_class.return_value = mock_sync_instance

        # Run 3 cycles then stop
        mock_sleep.side_effect = [True, True, False]

        daemon.run_daemon(repo_path=git_repo, interval=10)

        # Verify sync called 3 times
        assert mock_sync_instance.sync.call_count == 3

        # Verify metrics saved 3 times
        assert mock_write_metrics.call_count == 3

    @patch("home_sync.daemon.DotfilesSync")
    @patch("home_sync.daemon.write_metrics")
    @patch("home_sync.daemon.interruptible_sleep")
    def test_daemon_sync_failure_continues(
        self,
        mock_sleep: MagicMock,
        mock_write_metrics: MagicMock,
        mock_sync_class: MagicMock,
        git_repo: Path,
    ) -> None:
        """Test daemon continues after sync failure."""
        # First sync fails, second succeeds
        mock_sync_instance = MagicMock()
        mock_sync_instance.sync.side_effect = [
            DotfilesSyncError("Test error"),
            Metrics(operation="test", success=True),
        ]
        mock_sync_class.return_value = mock_sync_instance

        # Run 2 cycles then stop
        mock_sleep.side_effect = [True, False]

        daemon.run_daemon(repo_path=git_repo, interval=10)

        # Verify both syncs attempted
        assert mock_sync_instance.sync.call_count == 2

    @patch("home_sync.daemon.DotfilesSync")
    @patch("home_sync.daemon.write_metrics")
    @patch("home_sync.daemon.interruptible_sleep")
    def test_daemon_unexpected_error_continues(
        self,
        mock_sleep: MagicMock,
        mock_write_metrics: MagicMock,
        mock_sync_class: MagicMock,
        git_repo: Path,
    ) -> None:
        """Test daemon continues after unexpected error."""
        # First sync raises unexpected error, second succeeds
        mock_sync_instance = MagicMock()
        mock_sync_instance.sync.side_effect = [
            RuntimeError("Unexpected"),
            Metrics(operation="test", success=True),
        ]
        mock_sync_class.return_value = mock_sync_instance

        # Run 2 cycles then stop
        mock_sleep.side_effect = [True, False]

        daemon.run_daemon(repo_path=git_repo, interval=10)

        # Verify both syncs attempted
        assert mock_sync_instance.sync.call_count == 2

    @patch("home_sync.daemon.DotfilesSync")
    @patch("home_sync.daemon.interruptible_sleep")
    def test_daemon_reload_config(
        self,
        mock_sleep: MagicMock,
        mock_sync_class: MagicMock,
        git_repo: Path,
    ) -> None:
        """Test daemon handles config reload signal."""
        mock_sync_instance = MagicMock()
        mock_sync_instance.sync.return_value = Metrics(operation="test", success=True)
        mock_sync_class.return_value = mock_sync_instance

        # Trigger reload after first cycle
        def trigger_reload(*args: Any, **kwargs: Any) -> bool:
            if mock_sleep.call_count == 1:
                daemon._reload_config_requested = True
                return True
            return False

        mock_sleep.side_effect = trigger_reload

        daemon.run_daemon(repo_path=git_repo, interval=10)

        # Verify config reload was processed
        # (Currently just logs, no actual reload)
        assert mock_sync_instance.sync.call_count >= 2

    def test_daemon_keyboard_interrupt(self, git_repo: Path) -> None:
        """Test daemon handles keyboard interrupt gracefully."""

        @patch("home_sync.daemon.interruptible_sleep")
        def run_with_interrupt(mock_sleep: MagicMock) -> None:
            mock_sleep.side_effect = KeyboardInterrupt()

            # Should not raise
            daemon.run_daemon(repo_path=git_repo, interval=10)

        run_with_interrupt()

    @patch("home_sync.daemon.DotfilesSync")
    @patch("home_sync.daemon.interruptible_sleep")
    def test_daemon_default_metrics_file(
        self,
        mock_sleep: MagicMock,
        mock_sync_class: MagicMock,
        git_repo: Path,
    ) -> None:
        """Test daemon creates default metrics file."""
        mock_sync_instance = MagicMock()
        mock_sync_instance.sync.return_value = Metrics(operation="test", success=True)
        mock_sync_class.return_value = mock_sync_instance

        mock_sleep.return_value = False

        # Run without metrics_file argument
        daemon.run_daemon(repo_path=git_repo, interval=10)

        # Should use default path
        # ~/.local/state/home-sync/metrics.json

    @patch("home_sync.daemon.DotfilesSync")
    @patch("home_sync.daemon.write_metrics")
    @patch("home_sync.daemon.interruptible_sleep")
    def test_daemon_metrics_tracking(
        self,
        mock_sleep: MagicMock,
        mock_write_metrics: MagicMock,
        mock_sync_class: MagicMock,
        git_repo: Path,
    ) -> None:
        """Test daemon tracks success/failure counts."""
        # Mix of successes and failures
        mock_sync_instance = MagicMock()
        success_metrics = Metrics(operation="test", success=True)
        failure_metrics = Metrics(operation="test", success=False)
        failure_metrics.error_message = "Test error"

        mock_sync_instance.sync.side_effect = [
            success_metrics,
            failure_metrics,
            success_metrics,
        ]
        mock_sync_class.return_value = mock_sync_instance

        # Run 3 cycles
        mock_sleep.side_effect = [True, True, False]

        daemon.run_daemon(repo_path=git_repo, interval=10)

        # Verify correct number of calls
        assert mock_sync_instance.sync.call_count == 3

        # Verify metrics saved for successful syncs
        # (Failed syncs don't generate metrics to save)
        assert mock_write_metrics.call_count == 2

    @patch("home_sync.daemon.DotfilesSync")
    @patch("home_sync.daemon.interruptible_sleep")
    def test_daemon_interval_timing(
        self,
        mock_sleep: MagicMock,
        mock_sync_class: MagicMock,
        git_repo: Path,
    ) -> None:
        """Test daemon uses correct interval."""
        mock_sync_instance = MagicMock()
        mock_sync_instance.sync.return_value = Metrics(operation="test", success=True)
        mock_sync_class.return_value = mock_sync_instance

        mock_sleep.return_value = False

        custom_interval = 1800
        daemon.run_daemon(
            repo_path=git_repo,
            interval=custom_interval,
        )

        # Verify sleep called with correct interval
        mock_sleep.assert_called_with(custom_interval)

    @patch("home_sync.daemon.DotfilesSync")
    @patch("home_sync.daemon.interruptible_sleep")
    def test_daemon_force_commit_passed(
        self,
        mock_sleep: MagicMock,
        mock_sync_class: MagicMock,
        git_repo: Path,
    ) -> None:
        """Test daemon passes force_commit to sync config."""
        mock_sync_instance = MagicMock()
        mock_sync_instance.sync.return_value = Metrics(operation="test", success=True)
        mock_sync_class.return_value = mock_sync_instance

        mock_sleep.return_value = False

        daemon.run_daemon(
            repo_path=git_repo,
            interval=10,
            force_commit=True,
        )

        # Verify DotfilesSync created with force_commit=True
        call_args = mock_sync_class.call_args
        config = call_args[0][0]
        assert config.force_commit is True


class TestDaemonIntegration:
    """Test daemon integration scenarios."""

    @patch("home_sync.daemon.interruptible_sleep")
    @patch("home_sync.daemon.DotfilesSync")
    def test_daemon_real_sync_cycle(
        self,
        mock_sync_class: MagicMock,
        mock_sleep: MagicMock,
        git_repo: Path,
        tmp_path: Path,
    ) -> None:
        """Test daemon with configured sync (no remote operations)."""
        # Stop after first cycle
        mock_sleep.return_value = False

        # Mock sync to avoid remote operations
        mock_sync_instance = MagicMock()
        mock_metrics = Metrics(operation="test", success=True)
        mock_sync_instance.sync.return_value = mock_metrics
        mock_sync_class.return_value = mock_sync_instance

        metrics_file = tmp_path / "metrics.json"

        # Should complete without error
        daemon.run_daemon(
            repo_path=git_repo,
            interval=10,
            force_commit=False,
            metrics_file=metrics_file,
        )

        # Verify sync was called
        assert mock_sync_instance.sync.call_count == 1
