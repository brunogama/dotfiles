# Proposal: Migrate home-sync to Python

**Change ID**: `migrate-home-sync-to-python`
**Status**: Proposed
**Created**: 2025-10-27
**Author**: Claude Code

## Summary

Migrate the home-sync daemon from bash (603 lines) to Python for improved maintainability, testability, and reliability. The current bash implementation exceeds MINDSET.MD's 400-line limit and has multiple shellcheck violations that are difficult to address without significant refactoring.

## Motivation

### Current Problems

1. **File Size Violation** - `bin/core/home-sync` is 603 lines, exceeding the 400-line limit by 50%
2. **Shellcheck Violations** - Multiple SC2155 errors (declare and assign separately) that mask return values
3. **Race Conditions** - Lock file handling has TOCTOU bugs in bash that are error-prone to fix
4. **Limited Error Handling** - Bash's error handling is verbose and difficult to maintain
5. **No Test Coverage** - Bash scripts are hard to unit test; only integration tests are practical
6. **Complex String Parsing** - YAML config parsing, JSON output, and text manipulation are cumbersome in bash

### Benefits of Python

1. **Better Structure** - Cleaner module organization and function decomposition
2. **Type Safety** - Type hints and static analysis with mypy
3. **Easier Testing** - pytest with mocking, fixtures, and comprehensive coverage
4. **Better Libraries** - Native YAML, JSON, subprocess handling, pathlib
5. **Atomic Operations** - fcntl for proper file locking without races
6. **Standard Library** - argparse for CLI, logging module, configparser
7. **Maintainability** - Easier to onboard contributors familiar with Python

### Non-Goals

- This migration does NOT change functionality or user-facing behavior
- Config file format remains YAML
- CLI interface remains identical
- Daemon operation and LaunchAgent integration unchanged
- Performance characteristics should remain similar or better

## Scope

### In Scope

- Rewrite `bin/core/home-sync` in Python 3.11+
- Maintain 100% feature parity with bash version
- Add comprehensive test suite (≥95% coverage per MINDSET.MD)
- Fix all critical issues identified in code review:
  - Race-free lock file handling with fcntl
  - Proper error propagation without masking return values
  - Secure credential password handling
  - Atomic operations for git operations
- Update documentation and usage examples
- Ensure compatibility with home-sync-service (LaunchAgent wrapper)

### Out of Scope

- Migrating home-sync-service (stays as bash, it's simpler)
- Changing configuration file format (stays YAML)
- Adding new features beyond current functionality
- Changing CLI interface or command structure
- Modifying credential sync protocol (ws-sync, ws-backup remain external)

## Architecture

### Module Structure

```
bin/core/home_sync/
├── __init__.py
├── __main__.py         # Entry point (home-sync command)
├── cli.py              # Argument parsing and command routing
├── config.py           # Configuration loading and validation
├── daemon.py           # Daemon mode and signal handling
├── dotfiles.py         # Dotfiles sync logic
├── credentials.py      # Credential sync logic
├── lock.py             # Atomic lock file management (fcntl)
├── git.py              # Git operations (status, commit, push, pull)
├── logger.py           # Logging setup and utilities
├── metrics.py          # Metrics collection (JSON output)
└── utils.py            # Shared utilities

tests/
├── test_cli.py
├── test_config.py
├── test_daemon.py
├── test_dotfiles.py
├── test_credentials.py
├── test_lock.py
├── test_git.py
├── test_integration.py
└── fixtures/
    ├── test_config.yml
    └── test_repo/
```

### Key Design Decisions

1. **Package Structure**: Use a proper Python package (home_sync) installed via `uv tool install` or pip
2. **Entry Point**: Maintain `bin/core/home-sync` as a symlink to the installed package
3. **Dependencies**: Minimal external dependencies (PyYAML, possibly click for CLI)
4. **Python Version**: Require Python 3.11+ (for StrEnum, better type hints)
5. **Lock Management**: Use fcntl.flock() for atomic, race-free locking
6. **Testing**: pytest with ≥95% coverage, integration tests with temporary git repos
7. **Error Handling**: Custom exception hierarchy for clear error reporting
8. **Logging**: Python logging module with structured output

## Dependencies

### Python Packages
- **PyYAML** - YAML parsing (already commonly installed)
- **click** (optional) - CLI framework for better arg parsing and help text
- **pytest** - Testing framework
- **pytest-cov** - Coverage reporting
- **mypy** - Static type checking

### System Requirements
- Python 3.11+ (check with `python3 --version`)
- git (unchanged)
- macOS Keychain integration (security command, unchanged)

## Risks and Mitigation

### Risk 1: Python Not Available
**Mitigation**: Add prerequisite check in install script; document Python requirement clearly

### Risk 2: Breaking Changes During Migration
**Mitigation**:
- Maintain bash version until Python version is fully tested
- Keep both versions in parallel during transition
- Use feature flag in home-sync-service to switch between versions

### Risk 3: Performance Regression
**Mitigation**:
- Benchmark sync operations before/after migration
- Profile with cProfile if needed
- Python's subprocess module is well-optimized

### Risk 4: External Tool Integration
**Mitigation**:
- Carefully test ws-sync, ws-backup, ws-list integration
- Use same subprocess patterns as bash (shell=False for security)

## Success Criteria

1. All existing functionality works identically
2. Test coverage ≥95% (per MINDSET.MD)
3. No shellcheck-equivalent errors (mypy --strict passes)
4. All critical issues from code review are fixed
5. Performance within 10% of bash version (measure sync time)
6. Documentation updated
7. Successfully runs as LaunchAgent daemon for 1 week without issues

## Migration Path

### Phase 1: Setup and Infrastructure
- Create Python package structure
- Set up pytest and mypy configuration
- Add to LinkingManifest.json
- Update install script to check Python version

### Phase 2: Core Modules
- Implement config, logger, lock, utils modules
- Add comprehensive tests for each
- Validate with mypy --strict

### Phase 3: Sync Logic
- Implement dotfiles.py with git operations
- Implement credentials.py
- Add integration tests with temporary repos

### Phase 4: CLI and Daemon
- Implement CLI interface (cli.py, __main__.py)
- Implement daemon mode with signal handling
- Test LaunchAgent integration

### Phase 5: Validation and Transition
- Run both versions in parallel for testing
- Compare metrics and logs
- Switch home-sync-service to use Python version
- Deprecate bash version

## Alternatives Considered

### Keep Bash and Refactor
**Pros**: No migration risk, no new dependencies
**Cons**: Fundamental language limitations remain, shellcheck issues persist, testing still difficult

**Decision**: Rejected - The architectural issues run too deep for incremental fixes

### Use Go or Rust
**Pros**: Better performance, single binary
**Cons**: More complex for contributors, harder to maintain, overkill for this use case

**Decision**: Rejected - Python better matches skill set and maintenance profile

### Use Shell Script with Better Tools
**Pros**: Stay in bash ecosystem
**Cons**: Doesn't solve core maintainability issues

**Decision**: Rejected - Band-aid solution

## Related Changes

- Depends on: None (standalone migration)
- Blocks: None (parallel development possible)
- Related: `fix-home-sync-issues` (this supersedes those fixes)

## Timeline

- **Week 1**: Phase 1 (Setup) + Phase 2 (Core Modules)
- **Week 2**: Phase 3 (Sync Logic) + comprehensive testing
- **Week 3**: Phase 4 (CLI/Daemon) + LaunchAgent integration
- **Week 4**: Phase 5 (Validation) + documentation updates

**Estimated Total Effort**: 25-30 hours

## Questions for Review

1. Should we use click for CLI or stick with argparse?
2. Do we need to maintain bash version indefinitely or can we deprecate after migration?
3. Should we add new features while migrating (e.g., backup/restore) or keep strict parity?
4. What's the minimum Python version we can require (3.9, 3.10, 3.11+)?

## Approval Checklist

- [ ] Architecture reviewed and approved
- [ ] Dependencies acceptable
- [ ] Timeline realistic
- [ ] Risks understood and mitigated
- [ ] Test coverage requirements clear (≥95%)
- [ ] Documentation plan defined
- [ ] Backward compatibility strategy defined
