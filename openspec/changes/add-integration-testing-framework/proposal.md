# Integration Testing Framework

## Why

The dotfiles system lacks automated integration tests to verify critical workflows end-to-end. Manual testing is error-prone and time-consuming, leading to regressions in symlink management, environment switching, and credential handling.

## What Changes

- Add bats-core testing framework for shell script integration tests
- Implement test suites for critical user flows
- Achieve minimum 50% coverage of shell scripts in bin/
- Add CI integration for automated test execution
- Create test fixtures and helper utilities

## Impact

- Affected specs: New capability `integration-testing`
- Affected code:
  - New: `tests/integration/` directory with bats test files
  - New: `tests/fixtures/` for test data
  - New: `tests/helpers/` for test utilities
  - Modified: `.github/workflows/` for CI integration
  - Modified: Root Makefile or test runner scripts
