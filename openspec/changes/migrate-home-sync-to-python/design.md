# Design: Migrate home-sync to Python

**Change ID**: `migrate-home-sync-to-python`

## Architecture Overview

This document captures key architectural decisions, design patterns, and technical trade-offs for migrating home-sync from bash to Python.

---

## Module Organization

### Package Layout

```
bin/core/home_sync/
├── __init__.py              # Package metadata, version
├── __main__.py              # CLI entry point (python -m home_sync)
├── cli.py                   # Command-line interface
├── config.py                # Configuration management
├── daemon.py                # Background daemon logic
├── dotfiles.py              # Dotfiles synchronization
├── credentials.py           # Credential synchronization
├── lock.py                  # File locking (fcntl)
├── git.py                   # Git operations wrapper
├── logger.py                # Logging configuration
├── metrics.py               # Metrics collection
└── utils.py                 # Shared utilities
```

### Module Responsibilities

#### `cli.py` - Command-Line Interface
- Parse arguments using argparse (or click)
- Route commands to appropriate modules
- Handle --dry-run, --force, --verbose flags
- Exit with appropriate status codes

**Key Design**: Keep CLI logic separate from business logic for testability

#### `config.py` - Configuration Management
- Load YAML configuration from `~/.config/home-sync/config.yml`
- Validate configuration schema
- Provide typed config dataclass
- Handle missing/invalid config gracefully

**Key Design**: Use dataclasses with defaults for type safety

#### `daemon.py` - Background Service
- Run continuous sync loop
- Handle SIGTERM, SIGINT, SIGHUP signals
- Interruptible sleep (check signal every second)
- Load metrics on startup, save on exit

**Key Design**: Use signal handlers and threading.Event for clean shutdown

#### `lock.py` - Atomic File Locking
- Acquire exclusive lock using fcntl.flock()
- Detect stale locks (process not running)
- Timeout-based lock acquisition
- Context manager interface

**Key Design**: Use fcntl for race-free locking (solves TOCTOU bug)

#### `git.py` - Git Operations
- Wrap git commands with subprocess
- Check repository status (dirty, ahead, behind, diverged)
- Safe commit, push, pull operations
- Savepoint creation and rollback

**Key Design**: Never use shell=True (security), validate all paths

#### `dotfiles.py` - Dotfiles Sync
- Sync dotfiles repository
- Auto-commit with backup branch
- Detect conflicts (diverged branches)
- Transaction-style rollback on failure

**Key Design**: Create savepoint before operations, rollback on error

#### `credentials.py` - Credential Sync
- Integrate with ws-sync, ws-backup, ws-list
- Retrieve master password from keychain
- Interactive prompt if not in keychain
- Validate external tool availability

**Key Design**: Never store password in config or logs

#### `logger.py` - Logging Setup
- Configure Python logging module
- Support multiple outputs: console, file, syslog
- Structured logging (JSON for metrics)
- Color output only on TTY

**Key Design**: Detect TTY for color codes, plain text for pipes/files

#### `metrics.py` - Metrics Collection
- Track sync success/failure counts
- Measure sync duration
- Persist to JSON file
- Query for status display

**Key Design**: Simple JSON append for metrics, rotate on size limit

---

## Key Design Patterns

### 1. Context Managers for Resource Safety

**Lock Acquisition**:
```python
from contextlib import contextmanager
import fcntl

@contextmanager
def acquire_lock(lockfile: Path, timeout: int = 300):
    """Acquire exclusive lock with timeout."""
    fd = None
    try:
        fd = open(lockfile, 'w')
        fcntl.flock(fd.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        yield
    except BlockingIOError:
        # Lock held by another process
        raise LockError(f"Lock held, timeout after {timeout}s")
    finally:
        if fd:
            fcntl.flock(fd.fileno(), fcntl.LOCK_UN)
            fd.close()
            lockfile.unlink(missing_ok=True)
```

**Git Savepoint**:
```python
@contextmanager
def git_savepoint(repo_path: Path):
    """Create savepoint and rollback on error."""
    original_commit = get_current_commit(repo_path)
    try:
        yield
    except Exception:
        log.warning(f"Rolling back to {original_commit}")
        run_git(['reset', '--hard', original_commit], cwd=repo_path)
        raise
```

### 2. Dataclasses for Configuration

```python
from dataclasses import dataclass, field
from typing import Optional

@dataclass
class SyncConfig:
    """Home sync configuration."""
    sync_interval: int = 3600
    backup_retention: int = 30
    auto_push: bool = True
    log_level: str = "INFO"
    dotfiles_dir: Optional[Path] = None

    @classmethod
    def from_yaml(cls, config_path: Path) -> 'SyncConfig':
        """Load from YAML file with validation."""
        with open(config_path) as f:
            data = yaml.safe_load(f)
        return cls(**data)

    def validate(self):
        """Validate configuration values."""
        if self.sync_interval < 60:
            raise ValueError("sync_interval must be ≥ 60 seconds")
        if self.backup_retention < 1:
            raise ValueError("backup_retention must be ≥ 1 day")
```

### 3. Exception Hierarchy

```python
class HomeSyncError(Exception):
    """Base exception for home-sync errors."""
    pass

class LockError(HomeSyncError):
    """Lock acquisition failed."""
    pass

class GitError(HomeSyncError):
    """Git operation failed."""
    pass

class ConfigError(HomeSyncError):
    """Configuration invalid."""
    pass

class CredentialError(HomeSyncError):
    """Credential sync failed."""
    pass
```

**Benefit**: Catch specific errors, clear error messages

### 4. Subprocess Safety

```python
def run_git(args: list[str], cwd: Path, check: bool = True) -> subprocess.CompletedProcess:
    """Run git command safely."""
    cmd = ['git', *args]
    try:
        return subprocess.run(
            cmd,
            cwd=cwd,
            check=check,
            capture_output=True,
            text=True,
            timeout=30,  # Prevent hangs
            # NEVER use shell=True - security risk
        )
    except subprocess.TimeoutExpired:
        raise GitError(f"Git command timed out: {' '.join(cmd)}")
    except subprocess.CalledProcessError as e:
        raise GitError(f"Git command failed: {e.stderr}")
```

### 5. Signal Handling for Daemon

```python
import signal
import threading

class Daemon:
    def __init__(self, config: SyncConfig):
        self.config = config
        self.shutdown_event = threading.Event()

    def setup_signals(self):
        """Register signal handlers."""
        signal.signal(signal.SIGTERM, self._handle_shutdown)
        signal.signal(signal.SIGINT, self._handle_shutdown)
        signal.signal(signal.SIGHUP, self._handle_reload)

    def _handle_shutdown(self, signum, frame):
        log.info("Received shutdown signal")
        self.shutdown_event.set()

    def _handle_reload(self, signum, frame):
        log.info("Reloading configuration")
        self.config = SyncConfig.from_yaml(CONFIG_PATH)

    def run(self):
        """Main daemon loop."""
        self.setup_signals()
        while not self.shutdown_event.is_set():
            try:
                self.sync()
            except HomeSyncError as e:
                log.error(f"Sync failed: {e}")

            # Interruptible sleep (check every second)
            for _ in range(self.config.sync_interval):
                if self.shutdown_event.is_set():
                    break
                time.sleep(1)
```

---

## Technical Decisions

### Decision 1: argparse vs click

**Options**:
1. **argparse** (stdlib) - No dependencies, works well
2. **click** - Better UX, more features, but adds dependency

**Decision**: Use **argparse**
**Rationale**:
- No external dependencies
- Sufficient for our needs
- Matches MINDSET.MD preference for minimal dependencies

### Decision 2: YAML Library

**Options**:
1. **PyYAML** - Standard library, widely used
2. **ruamel.yaml** - Better round-trip, preserves comments
3. **pyyaml-include** - Adds include directives

**Decision**: Use **PyYAML** (safe_load)
**Rationale**:
- Most common, likely already installed
- We don't need round-trip editing
- safe_load prevents code execution

### Decision 3: Python Version Requirement

**Options**:
1. Python 3.9+ (oldest Ubuntu LTS has)
2. Python 3.10+ (match defaults)
3. Python 3.11+ (latest stable features)

**Decision**: Require **Python 3.11+**
**Rationale**:
- macOS Sequoia ships with Python 3.11
- Better type hints (StrEnum, Self type)
- tomllib in stdlib (if we move config to TOML)
- Better error messages

### Decision 4: Package Installation Method

**Options**:
1. Install with pip (global or user)
2. Use uv tool (isolated environments)
3. Keep as loose scripts

**Decision**: Use **uv tool install** + symlink
**Rationale**:
- Isolated environment (no conflicts)
- Easy to uninstall
- Matches modern Python tooling
- Symlink in ~/.local/bin for compatibility

### Decision 5: Logging Format

**Options**:
1. Plain text (like bash)
2. JSON structured logs
3. Both (console + JSON file)

**Decision**: Console colorized + JSON metrics file
**Rationale**:
- Console output for humans (with colors on TTY)
- JSON metrics for machine parsing
- Separate concerns: logs vs metrics

### Decision 6: Testing Strategy

**Pytest with fixtures**:
- Unit tests for each module (≥95% coverage)
- Integration tests with temporary git repos
- Mock external dependencies (ws-sync, keychain)
- Parametrize test cases for edge conditions

**Coverage requirement**: ≥95% (per MINDSET.MD)

---

## Error Handling Strategy

### Principle: Fail Fast with Clear Messages

**Good Error Message**:
```
ERROR: Git push failed: remote rejected (Permission denied)
  Repository: /Users/bruno/Developer/new-dotfiles
  Remote: origin (git@github.com:user/dotfiles.git)

  Possible causes:
  1. SSH key not authorized
  2. Repository permissions insufficient
  3. Branch protection enabled

  Run: git push origin main --verbose
```

**Bad Error Message**:
```
ERROR: Sync failed
```

### Exception Handling Pattern

```python
def sync_dotfiles(config: SyncConfig, dry_run: bool = False) -> bool:
    """Sync dotfiles with proper error handling."""
    try:
        with git_savepoint(config.dotfiles_dir):
            check_git_status(config.dotfiles_dir)
            commit_changes(config.dotfiles_dir, dry_run)
            pull_changes(config.dotfiles_dir, dry_run)
            push_changes(config.dotfiles_dir, dry_run)
        return True

    except GitError as e:
        log.error(f"Git operation failed: {e}")
        log.info("Changes rolled back to previous state")
        return False

    except LockError as e:
        log.error(f"Could not acquire lock: {e}")
        log.info("Another sync may be running")
        return False

    except Exception as e:
        log.exception("Unexpected error during sync")
        return False
```

---

## Performance Considerations

### Startup Time
**Target**: < 100ms (faster than bash due to no sourcing overhead)

**Optimizations**:
- Lazy imports (only load heavy modules when needed)
- Compiled bytecode (.pyc files)
- Minimal global initialization

### Sync Performance
**Target**: Within 10% of bash version

**Not a concern because**:
- Subprocess calls dominate (git, security commands)
- Python's subprocess module is well-optimized
- I/O and network are bottlenecks, not CPU

### Memory Usage
**Target**: < 50MB RSS

**Expected**: 15-20MB (typical for Python CLI tool)

---

## Security Considerations

### Credential Handling
- Never log passwords
- Never pass as command-line arguments
- Use macOS Keychain (security command)
- Prompt interactively if not in keychain

### Command Injection
- Never use shell=True in subprocess
- Validate all paths before operations
- Use pathlib for safe path manipulation

### Lock File Safety
- Use fcntl.flock (atomic, kernel-level)
- Stale lock detection (check if PID exists)
- Timeout to prevent infinite waits

---

## Migration Strategy

### Parallel Operation Phase

During migration, both versions coexist:

```
bin/core/
├── home-sync           # Symlink to Python version
├── home-sync.bash      # Renamed bash version (backup)
└── home_sync/          # Python package
```

home-sync-service can toggle:
```bash
# In home-sync-service
if [[ -x "$HOME/.local/bin/home-sync" ]]; then
    # Python version exists, use it
    HOME_SYNC_BIN="$HOME/.local/bin/home-sync"
else
    # Fall back to bash
    HOME_SYNC_BIN="$DOTFILES_ROOT/bin/core/home-sync.bash"
fi
```

### Testing Protocol
1. Run Python version manually for 1 week
2. Compare logs and metrics with bash version
3. Enable as daemon via LaunchAgent
4. Monitor for 1 week
5. If stable, deprecate bash version

---

## Backward Compatibility

### Config File
- YAML format unchanged
- All existing keys supported
- New keys optional with defaults

### CLI Interface
- All existing commands work identically
- Same flags: --dry-run, --force, --verbose
- Same exit codes: 0 = success, 1 = error
- Output format compatible (parseable by scripts)

### LaunchAgent Integration
- No changes to plist file
- Same ProgramArguments
- Same log file locations
- Same signal handling (SIGTERM, SIGHUP)

---

## Testing Plan

### Unit Tests (per module)
- `test_config.py` - YAML parsing, validation, defaults
- `test_lock.py` - Lock acquire, release, timeout, stale
- `test_git.py` - Status check, commit, push, pull, savepoint
- `test_logger.py` - Color detection, levels, format

### Integration Tests
- `test_dotfiles.py` - Full sync cycle with temp repo
- `test_credentials.py` - ws-sync integration (mocked)
- `test_daemon.py` - Signal handling, loop, shutdown

### Coverage Target
- Minimum: 95% (per MINDSET.MD)
- Critical modules (lock, git, credentials): 100%

### Test Infrastructure
- Temporary git repos for isolation
- Mock external commands (ws-sync, security)
- Parametrize edge cases
- CI integration (GitHub Actions)

---

## Documentation Updates

### Files to Update
1. `README.md` - Installation requires Python 3.11+
2. `CLAUDE.md` - Update script standards section
3. `docs/scripts/core.md` - home-sync usage examples
4. `install` script - Check Python version

### New Documentation
1. `bin/core/home_sync/README.md` - Developer guide
2. `docs/architecture/home-sync.md` - Architecture overview
3. `CHANGELOG.md` - Migration notes

---

## Rollback Plan

If critical issues arise:

1. Revert symlink: `ln -sf home-sync.bash home-sync`
2. Update home-sync-service to use bash version
3. Restart LaunchAgent: `home-sync-service restart`
4. Investigate issues in parallel
5. Fix and retry migration

**Decision Point**: After 1 week of stable operation, remove bash version
