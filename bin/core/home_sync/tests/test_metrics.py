"""Tests for metrics module."""

import json
import time
from pathlib import Path

import pytest

from home_sync.metrics import Metrics, MetricsCollector, read_metrics, write_metrics


class TestMetrics:
    """Test cases for Metrics dataclass."""

    def test_metrics_defaults(self) -> None:
        """Test that Metrics has correct default values."""
        metrics = Metrics()

        assert metrics.operation == "sync"
        assert metrics.success is False
        assert metrics.error_message is None
        assert metrics.files_checked == 0
        assert metrics.files_changed == 0
        assert metrics.files_added == 0
        assert metrics.files_removed == 0
        assert metrics.commits_created == 0
        assert metrics.pushes_attempted == 0
        assert metrics.pushes_succeeded == 0
        assert metrics.credentials_synced == 0
        assert metrics.machine_profile == "default"
        assert metrics.end_time is None
        assert metrics.duration_seconds is None

    def test_metrics_finish_success(self) -> None:
        """Test finishing metrics with success."""
        metrics = Metrics()
        start = metrics.start_time

        time.sleep(0.1)  # Small delay

        metrics.finish(success=True)

        assert metrics.success is True
        assert metrics.error_message is None
        assert metrics.end_time is not None
        assert metrics.end_time > start
        assert metrics.duration_seconds is not None
        assert metrics.duration_seconds > 0

    def test_metrics_finish_failure(self) -> None:
        """Test finishing metrics with failure."""
        metrics = Metrics()

        metrics.finish(success=False, error_message="Test error")

        assert metrics.success is False
        assert metrics.error_message == "Test error"
        assert metrics.end_time is not None
        assert metrics.duration_seconds is not None

    def test_metrics_to_dict(self) -> None:
        """Test converting metrics to dictionary."""
        metrics = Metrics(
            operation="daemon",
            files_changed=5,
            commits_created=1,
        )
        metrics.finish(success=True)

        data = metrics.to_dict()

        assert data["operation"] == "daemon"
        assert data["files_changed"] == 5
        assert data["commits_created"] == 1
        assert data["success"] is True
        assert "timestamp" in data
        assert "start_time" in data
        assert "end_time" in data
        assert "duration_seconds" in data

    def test_metrics_from_dict(self) -> None:
        """Test creating metrics from dictionary."""
        data = {
            "operation": "sync",
            "success": True,
            "files_changed": 10,
            "start_time": time.time(),
            "end_time": time.time() + 5,
            "duration_seconds": 5.0,
        }

        metrics = Metrics.from_dict(data)

        assert metrics.operation == "sync"
        assert metrics.success is True
        assert metrics.files_changed == 10
        assert metrics.duration_seconds == 5.0

    def test_metrics_round_trip(self) -> None:
        """Test converting to dict and back."""
        original = Metrics(
            operation="status",
            files_checked=100,
            success=True,
        )
        original.finish(success=True)

        data = original.to_dict()
        restored = Metrics.from_dict(data)

        assert restored.operation == original.operation
        assert restored.files_checked == original.files_checked
        assert restored.success == original.success


class TestMetricsCollector:
    """Test cases for MetricsCollector class."""

    def test_collector_initialization(self, tmp_path: Path) -> None:
        """Test collector initialization."""
        metrics_file = tmp_path / "metrics.json"
        collector = MetricsCollector(metrics_file=metrics_file)

        assert collector.metrics_file == metrics_file
        assert collector.current_metrics is None

    def test_collector_start(self, tmp_path: Path) -> None:
        """Test starting metrics collection."""
        collector = MetricsCollector(metrics_file=tmp_path / "metrics.json")

        metrics = collector.start("sync")

        assert metrics is not None
        assert metrics.operation == "sync"
        assert collector.current_metrics is metrics
        assert metrics.hostname is not None  # Should set hostname

    def test_collector_finish(self, tmp_path: Path) -> None:
        """Test finishing metrics collection."""
        collector = MetricsCollector(metrics_file=tmp_path / "metrics.json")

        collector.start("sync")
        result = collector.finish(success=True)

        assert result is not None
        assert result.success is True
        assert result.end_time is not None
        assert result.duration_seconds is not None

    def test_collector_finish_without_start(self, tmp_path: Path) -> None:
        """Test finishing without starting."""
        collector = MetricsCollector(metrics_file=tmp_path / "metrics.json")

        result = collector.finish(success=True)

        assert result is None

    def test_collector_writes_to_file(self, tmp_path: Path) -> None:
        """Test that metrics are written to file."""
        metrics_file = tmp_path / "metrics.json"
        collector = MetricsCollector(metrics_file=metrics_file)

        collector.start("sync")
        collector.finish(success=True)

        assert metrics_file.exists()

        with open(metrics_file) as f:
            data = json.load(f)

        assert len(data) == 1
        assert data[0]["operation"] == "sync"
        assert data[0]["success"] is True

    def test_collector_appends_metrics(self, tmp_path: Path) -> None:
        """Test that metrics are appended to existing file."""
        metrics_file = tmp_path / "metrics.json"
        collector = MetricsCollector(metrics_file=metrics_file)

        # First operation
        collector.start("sync")
        collector.finish(success=True)

        # Second operation
        collector.start("daemon")
        collector.finish(success=False)

        with open(metrics_file) as f:
            data = json.load(f)

        assert len(data) == 2
        assert data[0]["operation"] == "sync"
        assert data[1]["operation"] == "daemon"

    def test_collector_limits_entries(self, tmp_path: Path) -> None:
        """Test that old entries are removed after 1000."""
        metrics_file = tmp_path / "metrics.json"
        collector = MetricsCollector(metrics_file=metrics_file)

        # Create 1005 entries
        for i in range(1005):
            collector.start("sync")
            collector.finish(success=True)

        with open(metrics_file) as f:
            data = json.load(f)

        # Should keep only last 1000
        assert len(data) == 1000

    def test_collector_handles_corrupt_file(self, tmp_path: Path) -> None:
        """Test that collector handles corrupt JSON file."""
        metrics_file = tmp_path / "metrics.json"
        metrics_file.write_text("invalid json{{{")

        collector = MetricsCollector(metrics_file=metrics_file)
        collector.start("sync")
        collector.finish(success=True)

        # Should have created new file
        with open(metrics_file) as f:
            data = json.load(f)

        assert len(data) == 1


class TestWriteMetrics:
    """Test cases for write_metrics function."""

    def test_write_metrics_basic(self, tmp_path: Path) -> None:
        """Test writing metrics to file."""
        metrics_file = tmp_path / "metrics.json"
        metrics = Metrics(operation="sync", files_changed=5)
        metrics.finish(success=True)

        write_metrics(metrics, metrics_file=metrics_file)

        assert metrics_file.exists()

        with open(metrics_file) as f:
            data = json.load(f)

        assert len(data) == 1
        assert data[0]["files_changed"] == 5

    def test_write_metrics_creates_directory(self, tmp_path: Path) -> None:
        """Test that directory is created if needed."""
        metrics_file = tmp_path / "nested" / "dir" / "metrics.json"
        metrics = Metrics()
        metrics.finish(success=True)

        write_metrics(metrics, metrics_file=metrics_file)

        assert metrics_file.exists()
        assert metrics_file.parent.exists()


class TestReadMetrics:
    """Test cases for read_metrics function."""

    def test_read_metrics_empty_file(self, tmp_path: Path) -> None:
        """Test reading from nonexistent file."""
        metrics_file = tmp_path / "metrics.json"

        result = read_metrics(metrics_file=metrics_file)

        assert result == []

    def test_read_metrics_basic(self, tmp_path: Path) -> None:
        """Test reading metrics from file."""
        metrics_file = tmp_path / "metrics.json"

        # Write some metrics
        for i in range(5):
            m = Metrics(operation=f"sync-{i}", files_changed=i)
            m.finish(success=True)
            write_metrics(m, metrics_file=metrics_file)

        # Read them back
        result = read_metrics(metrics_file=metrics_file)

        assert len(result) == 5
        # Should be in reverse order (most recent first)
        assert result[0].operation == "sync-4"
        assert result[4].operation == "sync-0"

    def test_read_metrics_with_limit(self, tmp_path: Path) -> None:
        """Test reading metrics with limit."""
        metrics_file = tmp_path / "metrics.json"

        # Write 10 metrics
        for i in range(10):
            m = Metrics(operation=f"sync-{i}")
            m.finish(success=True)
            write_metrics(m, metrics_file=metrics_file)

        # Read only 3 most recent
        result = read_metrics(metrics_file=metrics_file, limit=3)

        assert len(result) == 3
        assert result[0].operation == "sync-9"
        assert result[1].operation == "sync-8"
        assert result[2].operation == "sync-7"

    def test_read_metrics_corrupt_file(self, tmp_path: Path) -> None:
        """Test reading corrupt metrics file."""
        metrics_file = tmp_path / "metrics.json"
        metrics_file.write_text("invalid json")

        result = read_metrics(metrics_file=metrics_file)

        assert result == []


class TestMetricsIntegration:
    """Integration tests for metrics functionality."""

    def test_full_workflow(self, tmp_path: Path) -> None:
        """Test complete metrics workflow."""
        metrics_file = tmp_path / "metrics.json"
        collector = MetricsCollector(metrics_file=metrics_file)

        # Start operation
        metrics = collector.start("sync")
        assert metrics is not None

        # Update metrics during operation
        metrics.files_checked = 100
        metrics.files_changed = 5
        metrics.files_added = 3
        metrics.files_removed = 2
        metrics.commits_created = 1

        time.sleep(0.1)  # Simulate work

        # Finish operation
        result = collector.finish(success=True)
        assert result is not None
        assert result.duration_seconds > 0

        # Read back and verify
        read_back = read_metrics(metrics_file=metrics_file, limit=1)
        assert len(read_back) == 1
        assert read_back[0].files_checked == 100
        assert read_back[0].files_changed == 5
        assert read_back[0].commits_created == 1
        assert read_back[0].success is True

    def test_multiple_operations(self, tmp_path: Path) -> None:
        """Test tracking multiple operations."""
        metrics_file = tmp_path / "metrics.json"
        collector = MetricsCollector(metrics_file=metrics_file)

        # Operation 1: Success
        collector.start("sync")
        collector.current_metrics.files_changed = 5
        collector.finish(success=True)

        # Operation 2: Failure
        collector.start("sync")
        collector.current_metrics.files_changed = 0
        collector.finish(success=False, error_message="Network error")

        # Operation 3: Success
        collector.start("daemon")
        collector.finish(success=True)

        # Read all metrics
        all_metrics = read_metrics(metrics_file=metrics_file)

        assert len(all_metrics) == 3
        assert all_metrics[0].operation == "daemon"  # Most recent
        assert all_metrics[1].success is False
        assert all_metrics[1].error_message == "Network error"
        assert all_metrics[2].files_changed == 5
