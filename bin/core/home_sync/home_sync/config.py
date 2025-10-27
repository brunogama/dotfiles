"""Configuration management for home-sync.

Provides typed configuration loading from YAML with validation and defaults.
"""

from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Dict, Optional

import yaml

from home_sync.logger import LogLevel

__all__ = ["Config", "load_config", "create_default_config"]


@dataclass
class Config:
    """Home-sync configuration with typed fields and validation.

    All fields have sensible defaults and are validated on load.
    """

    # Sync settings
    sync_interval: int = 3600  # 1 hour in seconds
    backup_retention: int = 30  # days
    auto_push_enabled: bool = True

    # Sync filters
    sync_dotfiles: bool = True
    sync_credentials: bool = True
    sync_homebrew: bool = True

    # Notification and logging
    notifications_enabled: bool = True
    log_level: LogLevel = LogLevel.INFO

    # Machine profile
    machine_profile: str = "default"

    # Remote backup
    remote_backup_enabled: bool = True

    # Paths (computed)
    config_dir: Path = field(default_factory=lambda: Path.home() / ".config" / "home-sync")
    log_dir: Path = field(default_factory=lambda: Path.home() / ".config" / "home-sync" / "logs")

    def __post_init__(self) -> None:
        """Validate configuration after initialization."""
        self.validate()

    def validate(self) -> None:
        """Validate configuration values.

        Raises:
            ValueError: If any configuration value is invalid
        """
        if self.sync_interval < 60:
            raise ValueError("sync_interval must be at least 60 seconds")

        if self.sync_interval > 86400:
            raise ValueError("sync_interval cannot exceed 86400 seconds (24 hours)")

        if self.backup_retention < 1:
            raise ValueError("backup_retention must be at least 1 day")

        if self.backup_retention > 365:
            raise ValueError("backup_retention cannot exceed 365 days")

        valid_profiles = ["default", "work", "personal", "server"]
        if self.machine_profile not in valid_profiles:
            raise ValueError(
                f"machine_profile must be one of: {', '.join(valid_profiles)}"
            )

        # Ensure paths are Path objects
        if not isinstance(self.config_dir, Path):
            self.config_dir = Path(self.config_dir)
        if not isinstance(self.log_dir, Path):
            self.log_dir = Path(self.log_dir)

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "Config":
        """Create Config from dictionary, handling type conversions.

        Args:
            data: Configuration dictionary from YAML

        Returns:
            Config instance with validated values
        """
        # Handle log_level string to enum conversion
        if "log_level" in data and isinstance(data["log_level"], str):
            data["log_level"] = LogLevel(data["log_level"].upper())

        # Handle Path conversions
        if "config_dir" in data and not isinstance(data["config_dir"], Path):
            data["config_dir"] = Path(data["config_dir"]).expanduser()

        if "log_dir" in data and not isinstance(data["log_dir"], Path):
            data["log_dir"] = Path(data["log_dir"]).expanduser()

        return cls(**data)


def load_config(config_path: Optional[Path] = None) -> Config:
    """Load configuration from YAML file.

    Args:
        config_path: Path to config file (defaults to ~/.config/home-sync/config.yml)

    Returns:
        Loaded and validated Config instance

    Raises:
        FileNotFoundError: If config file doesn't exist
        yaml.YAMLError: If config file is invalid YAML
        ValueError: If configuration values are invalid

    Example:
        >>> config = load_config()
        >>> print(config.sync_interval)
        3600
    """
    if config_path is None:
        config_path = Path.home() / ".config" / "home-sync" / "config.yml"

    config_path = Path(config_path).expanduser().resolve()

    if not config_path.exists():
        raise FileNotFoundError(
            f"Configuration file not found: {config_path}\n"
            f"Run 'home-sync init' to create a default configuration."
        )

    with open(config_path, "r") as f:
        data = yaml.safe_load(f) or {}

    # Merge with defaults
    config = Config()

    # Update only fields that exist in the YAML
    for key, value in data.items():
        if hasattr(config, key):
            setattr(config, key, value)

    # Re-validate after updates
    config.validate()

    return config


def create_default_config(config_path: Optional[Path] = None, force: bool = False) -> Path:
    """Create a default configuration file.

    Args:
        config_path: Path to config file (defaults to ~/.config/home-sync/config.yml)
        force: Overwrite existing file if True

    Returns:
        Path to created config file

    Raises:
        FileExistsError: If config file exists and force=False

    Example:
        >>> config_path = create_default_config()
        >>> print(f"Created: {config_path}")
    """
    if config_path is None:
        config_path = Path.home() / ".config" / "home-sync" / "config.yml"

    config_path = Path(config_path).expanduser().resolve()

    if config_path.exists() and not force:
        raise FileExistsError(
            f"Configuration file already exists: {config_path}\n"
            f"Use force=True to overwrite."
        )

    # Ensure directory exists
    config_path.parent.mkdir(parents=True, exist_ok=True)

    # Create default config
    default_config = Config()

    config_content = f"""# Home Environment Sync Configuration
# YAML format

# Sync interval in seconds (default: 3600 = 1 hour)
sync_interval: {default_config.sync_interval}

# Backup retention in days (default: 30)
backup_retention: {default_config.backup_retention}

# Auto-push changes after sync
auto_push_enabled: {str(default_config.auto_push_enabled).lower()}

# Enable remote backup of credentials
remote_backup_enabled: {str(default_config.remote_backup_enabled).lower()}

# Notification settings
notifications_enabled: {str(default_config.notifications_enabled).lower()}

# Log level (DEBUG, INFO, WARN, ERROR)
log_level: {default_config.log_level.value}

# Sync filters (what to sync)
sync_dotfiles: {str(default_config.sync_dotfiles).lower()}
sync_credentials: {str(default_config.sync_credentials).lower()}
sync_homebrew: {str(default_config.sync_homebrew).lower()}

# Machine-specific settings
machine_profile: "{default_config.machine_profile}"  # default, work, personal, server
"""

    with open(config_path, "w") as f:
        f.write(config_content)

    return config_path
