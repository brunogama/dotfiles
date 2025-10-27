"""Tests for logger module."""

import logging
from io import StringIO

import pytest

from home_sync.logger import ColoredFormatter, LogLevel, get_logger, setup_logger


class TestColoredFormatter:
    """Test cases for ColoredFormatter."""

    def test_format_with_colors(self) -> None:
        """Test that formatter adds colors when enabled."""
        formatter = ColoredFormatter(use_colors=True)
        record = logging.LogRecord(
            name="test",
            level=logging.INFO,
            pathname="",
            lineno=0,
            msg="Test message",
            args=(),
            exc_info=None,
        )

        formatted = formatter.format(record)
        assert "\033[0;34m" in formatted  # Blue color for INFO
        assert "\033[0m" in formatted  # Reset code
        assert "Test message" in formatted

    def test_format_without_colors(self) -> None:
        """Test that formatter works without colors."""
        formatter = ColoredFormatter(use_colors=False)
        record = logging.LogRecord(
            name="test",
            level=logging.INFO,
            pathname="",
            lineno=0,
            msg="Test message",
            args=(),
            exc_info=None,
        )

        formatted = formatter.format(record)
        assert "\033[" not in formatted  # No ANSI codes
        assert "Test message" in formatted
        assert "[INFO]" in formatted


class TestSetupLogger:
    """Test cases for setup_logger."""

    def test_setup_logger_default(self) -> None:
        """Test logger setup with default parameters."""
        logger = setup_logger("test_default")
        assert logger.name == "test_default"
        assert logger.level == logging.INFO
        assert len(logger.handlers) == 1

    def test_setup_logger_debug_level(self) -> None:
        """Test logger setup with DEBUG level."""
        logger = setup_logger("test_debug", level=LogLevel.DEBUG)
        assert logger.level == logging.DEBUG

    def test_setup_logger_warn_level(self) -> None:
        """Test logger setup with WARN level."""
        logger = setup_logger("test_warn", level=LogLevel.WARN)
        assert logger.level == logging.WARNING

    def test_setup_logger_error_level(self) -> None:
        """Test logger setup with ERROR level."""
        logger = setup_logger("test_error", level=LogLevel.ERROR)
        assert logger.level == logging.ERROR

    def test_setup_logger_force_colors_true(self) -> None:
        """Test logger with forced colors."""
        logger = setup_logger("test_colors", force_colors=True)
        handler = logger.handlers[0]
        assert isinstance(handler.formatter, ColoredFormatter)
        assert handler.formatter.use_colors is True

    def test_setup_logger_force_colors_false(self) -> None:
        """Test logger with colors disabled."""
        logger = setup_logger("test_no_colors", force_colors=False)
        handler = logger.handlers[0]
        assert isinstance(handler.formatter, ColoredFormatter)
        assert handler.formatter.use_colors is False

    def test_setup_logger_removes_old_handlers(self) -> None:
        """Test that setup_logger removes existing handlers."""
        logger = setup_logger("test_handlers")
        assert len(logger.handlers) == 1

        # Setup again
        setup_logger("test_handlers")
        assert len(logger.handlers) == 1  # Should still be 1, not 2


class TestGetLogger:
    """Test cases for get_logger."""

    def test_get_logger_returns_existing(self) -> None:
        """Test that get_logger returns an existing logger."""
        logger1 = setup_logger("test_existing")
        logger2 = get_logger("test_existing")
        assert logger1 is logger2

    def test_get_logger_default_name(self) -> None:
        """Test get_logger with default name."""
        setup_logger("home_sync")
        logger = get_logger()
        assert logger.name == "home_sync"


class TestLoggerIntegration:
    """Integration tests for logger functionality."""

    def test_log_messages_at_different_levels(self, caplog: pytest.LogCaptureFixture) -> None:
        """Test logging messages at different levels."""
        logger = setup_logger("test_integration", level=LogLevel.DEBUG)

        with caplog.at_level(logging.DEBUG):
            logger.debug("Debug message")
            logger.info("Info message")
            logger.warning("Warning message")
            logger.error("Error message")

        assert "Debug message" in caplog.text
        assert "Info message" in caplog.text
        assert "Warning message" in caplog.text
        assert "Error message" in caplog.text

    def test_level_filtering(self, caplog: pytest.LogCaptureFixture) -> None:
        """Test that level filtering works correctly."""
        logger = setup_logger("test_filtering", level=LogLevel.WARN)

        with caplog.at_level(logging.WARNING):
            logger.debug("Debug message")  # Should not appear
            logger.info("Info message")  # Should not appear
            logger.warning("Warning message")  # Should appear
            logger.error("Error message")  # Should appear

        assert "Debug message" not in caplog.text
        assert "Info message" not in caplog.text
        assert "Warning message" in caplog.text
        assert "Error message" in caplog.text
