# home-sync

Home environment and credentials synchronization daemon (Python implementation)

## Overview

This is a Python rewrite of the bash home-sync script, providing better maintainability, testability, and reliability.

## Requirements

- Python 3.11+
- Git
- macOS (for keychain integration)
- PyYAML

## Installation

### Development Installation

```bash
# Install in editable mode with dev dependencies
cd bin/core/home_sync
pip install -e ".[dev]"

# Or using uv (recommended)
uv pip install -e ".[dev]"
```

### User Installation

```bash
# Install via uv tool (isolated environment)
uv tool install --from ./bin/core/home_sync home-sync

# Verify installation
home-sync --version
```

## Development

### Running Tests

```bash
# Run all tests with coverage
pytest

# Run specific test file
pytest tests/test_config.py -v

# Run with coverage report
pytest --cov=home_sync --cov-report=html
```

### Type Checking

```bash
# Run mypy strict type checking
mypy home_sync --strict
```

### Code Quality

All code must pass:
- pytest with ≥95% coverage
- mypy --strict with zero errors
- No shellcheck-equivalent warnings

## Architecture

### Module Structure

```
home_sync/
├── __init__.py         # Package metadata
├── __main__.py         # CLI entry point
├── cli.py              # Argument parsing
├── config.py           # Configuration management
├── daemon.py           # Daemon mode
├── dotfiles.py         # Dotfiles sync
├── credentials.py      # Credential sync
├── lock.py             # File locking (fcntl)
├── git.py              # Git operations
├── logger.py           # Logging setup
├── metrics.py          # Metrics collection
└── utils.py            # Utilities
```

### Key Design Patterns

- **Context Managers**: For lock acquisition and git savepoints
- **Dataclasses**: For typed configuration
- **Exception Hierarchy**: Clear error types (LockError, GitError, etc.)
- **Type Hints**: Full mypy --strict compliance

## Configuration

Configuration file: `~/.config/home-sync/config.yml`

```yaml
sync_interval: 3600      # Sync every hour
backup_retention: 30     # Keep backups for 30 days
auto_push: true          # Automatically push changes
log_level: INFO          # DEBUG, INFO, WARN, ERROR
```

## Usage

### Command Line

```bash
# One-time sync
home-sync sync

# Dry-run (no changes)
home-sync sync --dry-run

# Force auto-commit of changes
home-sync sync --force

# Run as daemon
home-sync daemon

# Show status
home-sync status

# Show version
home-sync version
```

### As LaunchAgent

Managed by `home-sync-service`:

```bash
home-sync-service install
home-sync-service start
home-sync-service status
home-sync-service logs
```

## Testing Strategy

- **Unit Tests**: Each module has comprehensive tests
- **Integration Tests**: Full sync workflows with temp repos
- **Coverage Target**: ≥95% (per MINDSET.MD)
- **Type Safety**: mypy --strict must pass

## Migration from Bash

This replaces `bin/core/home-sync` (bash version). Key improvements:

1. **Race-Free Locking**: Uses fcntl.flock() instead of TOCTOU-prone bash checks
2. **Transaction Rollback**: Git savepoints with automatic rollback on failure
3. **Better Testing**: Unit tests possible with Python (not practical in bash)
4. **Type Safety**: mypy catches errors at development time
5. **Clearer Errors**: Exception hierarchy provides context

## Contributing

See `openspec/changes/migrate-home-sync-to-python/` for:
- proposal.md - Overall design
- design.md - Technical decisions
- tasks.md - Implementation checklist
- specs/ - Requirements and scenarios

## License

Part of dotfiles system - see repository root for license.
