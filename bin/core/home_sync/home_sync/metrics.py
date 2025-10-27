"""Metrics tracking for home-sync operations.

Provides JSON-based metrics collection for monitoring sync operations.
"""

import json
import time
from dataclasses import asdict, dataclass, field
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, Optional

from home_sync.logger import get_logger

__all__ = ["Metrics", "MetricsCollector", "write_metrics", "read_metrics"]

logger = get_logger(__name__)


@dataclass
class Metrics:
    """Metrics for a sync operation.

    Tracks timing, file counts, and operation results.
    """

    # Timing
    start_time: float = field(default_factory=time.time)
    end_time: Optional[float] = None
    duration_seconds: Optional[float] = None

    # Operation info
    operation: str = "sync"  # sync, daemon, status
    success: bool = False
    error_message: Optional[str] = None

    # File counts
    files_checked: int = 0
    files_changed: int = 0
    files_added: int = 0
    files_removed: int = 0

    # Git stats
    commits_created: int = 0
    pushes_attempted: int = 0
    pushes_succeeded: int = 0

    # Credential stats
    credentials_synced: int = 0

    # Machine info
    hostname: Optional[str] = None
    machine_profile: str = "default"

    def finish(self, success: bool = True, error_message: Optional[str] = None) -> None:
        """Mark the operation as finished and calculate duration.

        Args:
            success: Whether the operation succeeded
            error_message: Error message if operation failed
        """
        self.end_time = time.time()
        self.duration_seconds = self.end_time - self.start_time
        self.success = success
        self.error_message = error_message

    def to_dict(self) -> Dict[str, Any]:
        """Convert metrics to dictionary.

        Returns:
            Dictionary representation of metrics
        """
        data = asdict(self)

        # Add formatted timestamp
        data["timestamp"] = datetime.fromtimestamp(self.start_time).isoformat()

        return data

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "Metrics":
        """Create Metrics from dictionary.

        Args:
            data: Dictionary with metrics data

        Returns:
            Metrics instance
        """
        # Remove timestamp if present (we use start_time)
        data_copy = data.copy()
        data_copy.pop("timestamp", None)

        return cls(**data_copy)


class MetricsCollector:
    """Collects and manages metrics for sync operations."""

    def __init__(self, metrics_file: Optional[Path] = None) -> None:
        """Initialize metrics collector.

        Args:
            metrics_file: Path to metrics JSON file (default: ~/.config/home-sync/metrics.json)
        """
        if metrics_file is None:
            metrics_file = Path.home() / ".config" / "home-sync" / "metrics.json"

        self.metrics_file = Path(metrics_file)
        self.current_metrics: Optional[Metrics] = None

    def start(self, operation: str = "sync") -> Metrics:
        """Start collecting metrics for an operation.

        Args:
            operation: Operation name (sync, daemon, status)

        Returns:
            New Metrics instance
        """
        self.current_metrics = Metrics(operation=operation)

        # Add hostname if available
        try:
            import socket

            self.current_metrics.hostname = socket.gethostname()
        except Exception:
            pass

        logger.debug(f"Started metrics collection for: {operation}")
        return self.current_metrics

    def finish(
        self, success: bool = True, error_message: Optional[str] = None
    ) -> Optional[Metrics]:
        """Finish current metrics collection and write to file.

        Args:
            success: Whether the operation succeeded
            error_message: Error message if operation failed

        Returns:
            Completed Metrics instance or None if no metrics were started
        """
        if self.current_metrics is None:
            logger.warning("No metrics to finish")
            return None

        self.current_metrics.finish(success=success, error_message=error_message)

        logger.debug(
            f"Finished metrics: {self.current_metrics.operation} "
            f"(duration: {self.current_metrics.duration_seconds:.2f}s, "
            f"success: {success})"
        )

        # Write metrics to file
        try:
            self._append_metrics(self.current_metrics)
        except Exception as e:
            logger.warning(f"Failed to write metrics: {e}")

        return self.current_metrics

    def _append_metrics(self, metrics: Metrics) -> None:
        """Append metrics to JSON file.

        Args:
            metrics: Metrics to append
        """
        # Ensure directory exists
        self.metrics_file.parent.mkdir(parents=True, exist_ok=True)

        # Read existing metrics
        existing = []
        if self.metrics_file.exists():
            try:
                with open(self.metrics_file, "r") as f:
                    existing = json.load(f)
            except json.JSONDecodeError:
                logger.warning(f"Invalid metrics file: {self.metrics_file}, starting fresh")
                existing = []

        # Append new metrics
        existing.append(metrics.to_dict())

        # Keep only last 1000 entries
        if len(existing) > 1000:
            existing = existing[-1000:]

        # Write back
        with open(self.metrics_file, "w") as f:
            json.dump(existing, f, indent=2)


def write_metrics(
    metrics: Metrics, metrics_file: Optional[Path] = None
) -> None:
    """Write metrics to JSON file.

    Args:
        metrics: Metrics to write
        metrics_file: Path to metrics file (default: ~/.config/home-sync/metrics.json)

    Example:
        >>> m = Metrics(operation="sync")
        >>> m.files_changed = 5
        >>> m.finish(success=True)
        >>> write_metrics(m)
    """
    collector = MetricsCollector(metrics_file=metrics_file)
    collector._append_metrics(metrics)


def read_metrics(
    metrics_file: Optional[Path] = None, limit: Optional[int] = None
) -> list[Metrics]:
    """Read metrics from JSON file.

    Args:
        metrics_file: Path to metrics file (default: ~/.config/home-sync/metrics.json)
        limit: Maximum number of recent metrics to return (None for all)

    Returns:
        List of Metrics instances, most recent first

    Example:
        >>> recent = read_metrics(limit=10)
        >>> for m in recent:
        ...     print(f"{m.operation}: {m.duration_seconds:.2f}s")
    """
    if metrics_file is None:
        metrics_file = Path.home() / ".config" / "home-sync" / "metrics.json"

    metrics_file = Path(metrics_file)

    if not metrics_file.exists():
        return []

    try:
        with open(metrics_file, "r") as f:
            data = json.load(f)

        metrics_list = [Metrics.from_dict(item) for item in data]

        # Reverse to get most recent first
        metrics_list.reverse()

        if limit is not None:
            metrics_list = metrics_list[:limit]

        return metrics_list

    except (json.JSONDecodeError, ValueError) as e:
        logger.warning(f"Failed to read metrics: {e}")
        return []
