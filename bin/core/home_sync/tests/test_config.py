"""Tests for config module."""

from pathlib import Path
from typing import Any

import pytest
import yaml

from home_sync.config import Config, create_default_config, load_config
from home_sync.logger import LogLevel


class TestConfig:
    """Test cases for Config dataclass."""

    def test_config_defaults(self) -> None:
        """Test that Config has correct default values."""
        config = Config()

        assert config.sync_interval == 3600
        assert config.backup_retention == 30
        assert config.auto_push_enabled is True
        assert config.sync_dotfiles is True
        assert config.sync_credentials is True
        assert config.sync_homebrew is True
        assert config.notifications_enabled is True
        assert config.log_level == LogLevel.INFO
        assert config.machine_profile == "default"
        assert config.remote_backup_enabled is True

    def test_config_validation_sync_interval_min(self) -> None:
        """Test sync_interval minimum validation."""
        with pytest.raises(ValueError, match="at least 60 seconds"):
            Config(sync_interval=30)

    def test_config_validation_sync_interval_max(self) -> None:
        """Test sync_interval maximum validation."""
        with pytest.raises(ValueError, match="cannot exceed 86400"):
            Config(sync_interval=100000)

    def test_config_validation_backup_retention_min(self) -> None:
        """Test backup_retention minimum validation."""
        with pytest.raises(ValueError, match="at least 1 day"):
            Config(backup_retention=0)

    def test_config_validation_backup_retention_max(self) -> None:
        """Test backup_retention maximum validation."""
        with pytest.raises(ValueError, match="cannot exceed 365"):
            Config(backup_retention=400)

    def test_config_validation_invalid_profile(self) -> None:
        """Test machine_profile validation."""
        with pytest.raises(ValueError, match="must be one of"):
            Config(machine_profile="invalid")

    def test_config_validation_valid_profiles(self) -> None:
        """Test all valid machine profiles."""
        for profile in ["default", "work", "personal", "server"]:
            config = Config(machine_profile=profile)
            assert config.machine_profile == profile

    def test_config_path_objects(self) -> None:
        """Test that paths are Path objects."""
        config = Config()
        assert isinstance(config.config_dir, Path)
        assert isinstance(config.log_dir, Path)

    def test_config_from_dict(self) -> None:
        """Test creating Config from dictionary."""
        data = {
            "sync_interval": 7200,
            "backup_retention": 60,
            "auto_push_enabled": False,
            "log_level": "DEBUG",
        }

        config = Config.from_dict(data)

        assert config.sync_interval == 7200
        assert config.backup_retention == 60
        assert config.auto_push_enabled is False
        assert config.log_level == LogLevel.DEBUG

    def test_config_from_dict_log_level_enum(self) -> None:
        """Test log_level string to enum conversion."""
        data = {"log_level": "warn"}
        config = Config.from_dict(data)
        assert config.log_level == LogLevel.WARN

    def test_config_from_dict_path_conversion(self) -> None:
        """Test Path string to Path object conversion."""
        data = {
            "config_dir": "~/.custom/config",
            "log_dir": "/var/log/home-sync",
        }

        config = Config.from_dict(data)

        assert isinstance(config.config_dir, Path)
        assert isinstance(config.log_dir, Path)
        assert config.config_dir == Path.home() / ".custom" / "config"
        assert config.log_dir == Path("/var/log/home-sync")


class TestLoadConfig:
    """Test cases for load_config function."""

    def test_load_config_file_not_found(self, tmp_path: Path) -> None:
        """Test error when config file doesn't exist."""
        nonexistent = tmp_path / "nonexistent.yml"

        with pytest.raises(FileNotFoundError, match="Configuration file not found"):
            load_config(nonexistent)

    def test_load_config_basic(self, tmp_path: Path) -> None:
        """Test loading a basic config file."""
        config_file = tmp_path / "config.yml"
        config_data = {
            "sync_interval": 7200,
            "backup_retention": 45,
            "log_level": "DEBUG",
        }

        with open(config_file, "w") as f:
            yaml.dump(config_data, f)

        config = load_config(config_file)

        assert config.sync_interval == 7200
        assert config.backup_retention == 45
        assert config.log_level == LogLevel.DEBUG

    def test_load_config_partial(self, tmp_path: Path) -> None:
        """Test loading config with only some fields."""
        config_file = tmp_path / "config.yml"
        config_data = {"sync_interval": 1800}

        with open(config_file, "w") as f:
            yaml.dump(config_data, f)

        config = load_config(config_file)

        # Changed field
        assert config.sync_interval == 1800
        # Default fields
        assert config.backup_retention == 30
        assert config.auto_push_enabled is True

    def test_load_config_empty_file(self, tmp_path: Path) -> None:
        """Test loading empty config file."""
        config_file = tmp_path / "config.yml"
        config_file.write_text("")

        config = load_config(config_file)

        # Should have all defaults
        assert config.sync_interval == 3600
        assert config.backup_retention == 30

    def test_load_config_invalid_yaml(self, tmp_path: Path) -> None:
        """Test error on invalid YAML."""
        config_file = tmp_path / "config.yml"
        config_file.write_text("invalid: yaml: content: [[[")

        with pytest.raises(yaml.YAMLError):
            load_config(config_file)

    def test_load_config_invalid_values(self, tmp_path: Path) -> None:
        """Test validation error on invalid values."""
        config_file = tmp_path / "config.yml"
        config_data = {"sync_interval": 30}  # Too low

        with open(config_file, "w") as f:
            yaml.dump(config_data, f)

        with pytest.raises(ValueError, match="at least 60 seconds"):
            load_config(config_file)


class TestCreateDefaultConfig:
    """Test cases for create_default_config function."""

    def test_create_default_config(self, tmp_path: Path) -> None:
        """Test creating default config file."""
        config_path = tmp_path / "config.yml"

        result = create_default_config(config_path)

        assert result == config_path
        assert config_path.exists()

        # Load and verify
        with open(config_path) as f:
            content = f.read()
            assert "sync_interval: 3600" in content
            assert "backup_retention: 30" in content
            assert "log_level: INFO" in content

    def test_create_default_config_creates_directory(self, tmp_path: Path) -> None:
        """Test that parent directory is created if needed."""
        config_path = tmp_path / "nested" / "dir" / "config.yml"

        create_default_config(config_path)

        assert config_path.exists()
        assert config_path.parent.exists()

    def test_create_default_config_file_exists(self, tmp_path: Path) -> None:
        """Test error when file exists without force."""
        config_path = tmp_path / "config.yml"
        config_path.write_text("existing content")

        with pytest.raises(FileExistsError, match="already exists"):
            create_default_config(config_path, force=False)

    def test_create_default_config_force_overwrite(self, tmp_path: Path) -> None:
        """Test overwriting existing file with force=True."""
        config_path = tmp_path / "config.yml"
        config_path.write_text("existing content")

        result = create_default_config(config_path, force=True)

        assert result == config_path
        content = config_path.read_text()
        assert "existing content" not in content
        assert "sync_interval: 3600" in content

    def test_create_default_config_is_valid(self, tmp_path: Path) -> None:
        """Test that created config can be loaded."""
        config_path = tmp_path / "config.yml"

        create_default_config(config_path)
        config = load_config(config_path)

        # Should have all defaults
        assert config.sync_interval == 3600
        assert config.backup_retention == 30
        assert config.log_level == LogLevel.INFO


class TestConfigIntegration:
    """Integration tests for config functionality."""

    def test_round_trip(self, tmp_path: Path) -> None:
        """Test creating, loading, and modifying config."""
        config_path = tmp_path / "config.yml"

        # Create default
        create_default_config(config_path)

        # Load it
        config = load_config(config_path)
        assert config.sync_interval == 3600

        # Modify and save
        with open(config_path, "w") as f:
            yaml.dump({"sync_interval": 7200, "log_level": "DEBUG"}, f)

        # Load again
        config2 = load_config(config_path)
        assert config2.sync_interval == 7200
        assert config2.log_level == LogLevel.DEBUG
