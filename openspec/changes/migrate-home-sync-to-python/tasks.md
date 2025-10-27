# Tasks: Migrate home-sync to Python

**Change ID**: `migrate-home-sync-to-python`

## Task Breakdown

Tasks are organized into phases for incremental delivery. Each task is small, verifiable, and includes validation steps.

---

## Phase 1: Setup and Infrastructure (Foundation)

### 1.1 Create Python Package Structure
- [ ] Create `bin/core/home_sync/` directory
- [ ] Add `__init__.py` with version = "2.0.0"
- [ ] Add `py.typed` marker file for type checking
- [ ] Create `pyproject.toml` with package metadata
- [ ] Add basic README.md for developers

**Validation**: `python -c "import home_sync; print(home_sync.__version__)"`

### 1.2 Configure Development Tools
- [ ] Create `.mypy.ini` for strict type checking
- [ ] Create `pytest.ini` with coverage settings
- [ ] Add `requirements-dev.txt` (pytest, mypy, pytest-cov)
- [ ] Create `.python-version` file (3.11)

**Validation**: Run `mypy --version` and `pytest --version`

### 1.3 Update LinkingManifest.json
- [ ] Add symlink for `bin/core/home-sync` → Python entry point
- [ ] Keep bash version as `bin/core/home-sync.bash` (backup)
- [ ] Document Python requirement in manifest

**Validation**: Run `link-dotfiles.py --dry-run`

### 1.4 Update Installation Script
- [ ] Add Python 3.11+ version check
- [ ] Add `uv` installation if not present
- [ ] Add `uv tool install` step for home_sync package
- [ ] Add fallback instructions if Python unavailable

**Validation**: Run `./install --dry-run`

---

## Phase 2: Core Modules (Building Blocks)

### 2.1 Implement logger.py
- [ ] Create `logger.py` with colored output
- [ ] Add TTY detection for color codes
- [ ] Support multiple log levels (DEBUG, INFO, WARN, ERROR)
- [ ] Add file logging capability
- [ ] Write unit tests (`test_logger.py`)

**Validation**: `pytest tests/test_logger.py -v --cov=home_sync.logger --cov-report=term-missing`

### 2.2 Implement config.py
- [ ] Create `SyncConfig` dataclass with defaults
- [ ] Add YAML loading with PyYAML
- [ ] Add config validation method
- [ ] Handle missing/invalid config gracefully
- [ ] Write unit tests (`test_config.py`)

**Validation**: `pytest tests/test_config.py -v --cov=home_sync.config`

### 2.3 Implement utils.py
- [ ] Add path expansion (tilde, env vars)
- [ ] Add file existence checks
- [ ] Add directory validation
- [ ] Add timestamp formatting
- [ ] Write unit tests (`test_utils.py`)

**Validation**: `pytest tests/test_utils.py -v --cov=home_sync.utils`

### 2.4 Implement lock.py
- [ ] Create `acquire_lock()` context manager with fcntl
- [ ] Add stale lock detection (check PID)
- [ ] Add timeout-based acquisition
- [ ] Add proper cleanup on exit
- [ ] Write comprehensive unit tests (`test_lock.py`)

**Validation**: `pytest tests/test_lock.py -v --cov=home_sync.lock` (must be 100% coverage)

### 2.5 Implement metrics.py
- [ ] Create metrics dataclass (success_count, failure_count, duration)
- [ ] Add JSON serialization/deserialization
- [ ] Add metrics file persistence
- [ ] Add metrics update methods
- [ ] Write unit tests (`test_metrics.py`)

**Validation**: `pytest tests/test_metrics.py -v --cov=home_sync.metrics`

---

## Phase 3: Git Operations (Critical Logic)

### 3.1 Implement git.py - Basic Operations
- [ ] Create `run_git()` helper (subprocess wrapper)
- [ ] Add `is_git_repo()` check
- [ ] Add `get_current_commit()` function
- [ ] Add `check_dirty()` status check
- [ ] Add timeout handling (30s default)
- [ ] Write unit tests with temp repos (`test_git_basic.py`)

**Validation**: `pytest tests/test_git_basic.py -v --cov=home_sync.git`

### 3.2 Implement git.py - Status Checking
- [ ] Add `get_branch_status()` (ahead, behind, diverged)
- [ ] Add `check_conflicts()` detection
- [ ] Add `is_fast_forward()` check
- [ ] Write integration tests with branching scenarios

**Validation**: `pytest tests/test_git_status.py -v`

### 3.3 Implement git.py - Commit Operations
- [ ] Add `stage_changes()` (git add)
- [ ] Add `create_commit()` with message
- [ ] Add `create_backup_branch()` before force operations
- [ ] Write unit tests

**Validation**: `pytest tests/test_git_commit.py -v`

### 3.4 Implement git.py - Sync Operations
- [ ] Add `pull_changes()` with ff-only
- [ ] Add `push_changes()` with error handling
- [ ] Add remote connectivity check
- [ ] Write integration tests

**Validation**: `pytest tests/test_git_sync.py -v`

### 3.5 Implement git.py - Savepoint/Rollback
- [ ] Create `git_savepoint()` context manager
- [ ] Add rollback on exception
- [ ] Test rollback scenarios
- [ ] Verify no data loss

**Validation**: `pytest tests/test_git_rollback.py -v` (must be 100% coverage)

---

## Phase 4: Sync Logic (Business Logic)

### 4.1 Implement dotfiles.py - Sync Setup
- [ ] Create `DotfilesSync` class
- [ ] Add prerequisite validation (git repo, clean status)
- [ ] Add dry-run support
- [ ] Write basic unit tests

**Validation**: `pytest tests/test_dotfiles_setup.py -v`

### 4.2 Implement dotfiles.py - Full Sync
- [ ] Add `sync()` method orchestrating:
  - Check git status
  - Auto-commit if dirty (with --force)
  - Pull changes (ff-only)
  - Push changes
- [ ] Add savepoint/rollback wrapper
- [ ] Write integration tests with temp repos

**Validation**: `pytest tests/test_dotfiles_sync.py -v --cov=home_sync.dotfiles`

### 4.3 Implement dotfiles.py - Error Recovery
- [ ] Handle git conflicts gracefully
- [ ] Handle network failures (retry logic)
- [ ] Handle permission errors
- [ ] Test all error paths

**Validation**: `pytest tests/test_dotfiles_errors.py -v`

### 4.4 Implement credentials.py - Setup
- [ ] Create `CredentialsSync` class
- [ ] Add external tool checks (ws-sync, ws-backup, ws-list)
- [ ] Add master password retrieval (keychain)
- [ ] Add interactive prompt fallback
- [ ] Write unit tests with mocking

**Validation**: `pytest tests/test_credentials_setup.py -v`

### 4.5 Implement credentials.py - Sync Operations
- [ ] Add `pull_credentials()` (ws-backup)
- [ ] Add `push_credentials()` (ws-sync)
- [ ] Add `list_credentials()` (ws-list)
- [ ] Handle tool failures gracefully
- [ ] Write integration tests with mocked tools

**Validation**: `pytest tests/test_credentials_sync.py -v --cov=home_sync.credentials`

---

## Phase 5: CLI and Daemon (User Interface)

### 5.1 Implement cli.py - Argument Parsing
- [ ] Create argument parser with argparse
- [ ] Add commands: sync, daemon, status, version
- [ ] Add global flags: --dry-run, --force, --verbose
- [ ] Add command-specific arguments
- [ ] Write unit tests for arg parsing

**Validation**: `pytest tests/test_cli.py -v`

### 5.2 Implement cli.py - Command Routing
- [ ] Route `sync` → full_sync()
- [ ] Route `daemon` → run_daemon()
- [ ] Route `status` → show_status()
- [ ] Route `version` → show_version()
- [ ] Add proper exit codes (0 = success, 1 = error)

**Validation**: Test each command manually

### 5.3 Implement daemon.py - Signal Handling
- [ ] Set up signal handlers (SIGTERM, SIGINT, SIGHUP)
- [ ] Add graceful shutdown on SIGTERM/SIGINT
- [ ] Add config reload on SIGHUP
- [ ] Add shutdown event flag
- [ ] Write unit tests with signal mocking

**Validation**: `pytest tests/test_daemon_signals.py -v`

### 5.4 Implement daemon.py - Main Loop
- [ ] Create main daemon loop
- [ ] Add interruptible sleep (check every 1s)
- [ ] Load metrics on startup
- [ ] Save metrics on exit
- [ ] Add error handling (continue on failure)

**Validation**: `pytest tests/test_daemon_loop.py -v`

### 5.5 Implement __main__.py - Entry Point
- [ ] Create main() function
- [ ] Set up logging based on --verbose
- [ ] Load configuration
- [ ] Call CLI router
- [ ] Handle exceptions at top level
- [ ] Write integration test

**Validation**: `python -m home_sync --help`

---

## Phase 6: Integration and Testing (Quality Assurance)

### 6.1 Write Integration Tests - Sync Workflow
- [ ] Create `test_integration_sync.py`
- [ ] Test: Full sync with clean repo
- [ ] Test: Sync with uncommitted changes (--force)
- [ ] Test: Sync with diverged branches (error)
- [ ] Test: Sync with network failure (retry)
- [ ] Test: Dry-run doesn't modify anything

**Validation**: `pytest tests/test_integration_sync.py -v --cov`

### 6.2 Write Integration Tests - Daemon Mode
- [ ] Create `test_integration_daemon.py`
- [ ] Test: Daemon starts and loops correctly
- [ ] Test: SIGTERM triggers graceful shutdown
- [ ] Test: SIGHUP reloads configuration
- [ ] Test: Daemon recovers from sync failures
- [ ] Test: Metrics are persisted correctly

**Validation**: `pytest tests/test_integration_daemon.py -v --cov`

### 6.3 Run Full Test Suite
- [ ] Run all tests: `pytest -v`
- [ ] Check coverage: `pytest --cov=home_sync --cov-report=html`
- [ ] Verify ≥95% coverage (MINDSET.MD requirement)
- [ ] Fix any failing tests
- [ ] Run mypy: `mypy home_sync --strict`

**Validation**: Coverage report shows ≥95%, mypy passes

### 6.3.1 Add CI Python Testing Job
- [ ] Add `test-python` job to `.github/workflows/ci.yml`
- [ ] Install uv and Python 3.11 in CI
- [ ] Run pytest with coverage report
- [ ] Verify minimum 91% coverage threshold
- [ ] Run mypy --strict type checking
- [ ] Upload coverage to Codecov

**Validation**: CI workflow includes Python testing, job passes on main branch

### 6.3.2 Add Mutation Testing
- [ ] Install mutmut in CI pipeline
- [ ] Configure mutmut to test home_sync modules
- [ ] Run mutation tests on all core modules
- [ ] Set minimum mutation score threshold (80%)
- [ ] Generate HTML mutation test report
- [ ] Upload mutation test results as artifacts

**Validation**: Mutation testing job passes with ≥80% mutation score

### 6.4 Manual Testing - CLI Commands
- [ ] Test: `home-sync --help`
- [ ] Test: `home-sync version`
- [ ] Test: `home-sync status`
- [ ] Test: `home-sync sync --dry-run`
- [ ] Test: `home-sync sync` (actual sync)
- [ ] Verify output format matches bash version

**Validation**: Manual verification of each command

### 6.5 Manual Testing - LaunchAgent Integration
- [ ] Update home-sync-service to use Python version
- [ ] Test: `home-sync-service restart`
- [ ] Verify daemon starts successfully
- [ ] Check logs: `home-sync-service logs`
- [ ] Let run for 1 hour, verify syncs occur
- [ ] Test signal handling: `home-sync-service stop`

**Validation**: Service runs correctly, logs show successful syncs

---

## Phase 7: Documentation and Transition (Finalization)

### 7.1 Update Core Documentation
- [ ] Update `README.md` - Add Python 3.11+ requirement
- [ ] Update `CLAUDE.md` - Update script standards section
- [ ] Update `docs/scripts/core.md` - home-sync usage examples
- [ ] Add migration notes to `CHANGELOG.md`

**Validation**: Documentation review

### 7.2 Create Developer Documentation
- [ ] Write `bin/core/home_sync/README.md` - Architecture overview
- [ ] Write `docs/architecture/home-sync.md` - Design decisions
- [ ] Add inline docstrings to all public functions
- [ ] Generate API documentation (sphinx or pdoc)

**Validation**: Documentation completeness check

### 7.3 Update Installation System
- [ ] Test `./install` with Python version
- [ ] Test `link-dotfiles.py --apply` creates correct symlinks
- [ ] Verify `uv tool install` works correctly
- [ ] Test on clean system (VM or container)

**Validation**: Fresh installation succeeds

### 7.4 Performance Benchmarking
- [ ] Benchmark: Startup time (target: <100ms)
- [ ] Benchmark: Full sync time (compare to bash)
- [ ] Benchmark: Memory usage (target: <50MB)
- [ ] Document performance metrics

**Validation**: Performance within 10% of bash version

### 7.5 Parallel Operation Testing
- [ ] Run Python version manually for 1 week
- [ ] Compare logs with bash version
- [ ] Check for any regressions
- [ ] Collect user feedback

**Validation**: 1 week of stable operation

---

## Phase 8: Deployment and Cleanup (Final Steps)

### 8.1 Enable as Default
- [ ] Update home-sync-service to use Python by default
- [ ] Update LinkingManifest.json (remove bash version)
- [ ] Restart LaunchAgent: `home-sync-service restart`
- [ ] Monitor logs for issues

**Validation**: Python version running as daemon

### 8.2 Monitor Production Usage
- [ ] Run for 1 week as daemon
- [ ] Check logs daily for errors
- [ ] Review metrics (success/failure rates)
- [ ] Address any issues found

**Validation**: Zero critical issues for 1 week

### 8.3 Deprecate Bash Version
- [ ] Archive bash version: `git mv home-sync.bash archive/`
- [ ] Remove from LinkingManifest.json
- [ ] Update documentation (bash version deprecated)
- [ ] Create git tag: `v2.0.0-python-migration`

**Validation**: Bash version archived, Python is default

### 8.4 Final Validation
- [ ] Run full test suite: `pytest -v --cov`
- [ ] Run mypy: `mypy home_sync --strict`
- [ ] Run shellcheck on remaining bash scripts
- [ ] Verify all MINDSET.MD rules satisfied

**Validation**: All checks pass

### 8.5 Close OpenSpec Proposal
- [ ] Mark proposal as "Implemented"
- [ ] Archive to `openspec/archive/migrate-home-sync-to-python/`
- [ ] Update project changelog
- [ ] Close related issues (fix-home-sync-issues)

**Validation**: OpenSpec status updated

---

## Task Summary

**Total Tasks**: 75 tasks across 8 phases

**Estimated Effort**:
- Phase 1 (Setup): 2-3 hours
- Phase 2 (Core): 4-5 hours
- Phase 3 (Git): 5-6 hours
- Phase 4 (Sync): 5-6 hours
- Phase 5 (CLI): 3-4 hours
- Phase 6 (Testing): 4-5 hours
- Phase 7 (Docs): 2-3 hours
- Phase 8 (Deploy): 1-2 hours

**Total**: 26-34 hours (roughly 1 month part-time)

---

## Dependencies

### Parallelizable Work
- Phase 2 tasks can be done in any order (independent modules)
- Phase 3 tasks have some dependencies (basic → status → sync)
- Documentation (Phase 7) can start early

### Blocking Dependencies
- Phase 5 (CLI) depends on Phase 2-4 (core modules and sync logic)
- Phase 6 (Integration tests) depends on Phase 5 (complete functionality)
- Phase 8 (Deployment) depends on Phase 6 (testing complete)

---

## Risk Mitigation

### Critical Path Tasks (Must Not Fail)
1. **Lock implementation (2.4)** - Must be race-free
2. **Git rollback (3.5)** - Must not lose data
3. **Integration testing (6.1-6.2)** - Must catch regressions
4. **LaunchAgent testing (6.5)** - Must work reliably

### High-Risk Tasks
- **Git sync operations (3.4)** - Network failures, conflicts
- **Credential sync (4.5)** - External tool integration
- **Daemon signal handling (5.3)** - Must shut down cleanly

**Mitigation**: Extra testing, code review, gradual rollout

---

## Success Criteria

All tasks complete when:
- [ ] All 75 tasks checked off
- [ ] Test coverage ≥95%
- [ ] Mypy --strict passes with zero errors
- [ ] Performance within 10% of bash version
- [ ] 1 week of stable production operation
- [ ] Zero critical bugs
- [ ] Documentation complete and reviewed
