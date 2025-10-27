# Spec: Integration Testing

**Capability**: Integration Testing with Bats-Core
**Status**: Proposed
**Version**: 1.0.0

## Overview

Comprehensive integration test suite for shell scripts using bats-core framework, providing automated testing of critical workflows, git operations, credential management, and symlink operations.

## ADDED Requirements

### Requirement: Bats-Core Test Framework

The system MUST provide a bats-core-based test framework with supporting libraries.

**Context**: Enable reliable, maintainable integration tests for shell scripts with modern testing utilities.

**Acceptance Criteria**:
- Bats-core installed and configured
- bats-support, bats-assert, bats-file libraries available
- Test runner accessible via `bats` command
- CI/CD integration configured

#### Scenario: Run Integration Tests

**Given** the bats-core framework is installed
**And** test files exist in `tests/integration/`
**When** developer runs `bats tests/integration/`
**Then** all tests execute with pass/fail results
**And** execution completes in <5 minutes
**And** detailed failure messages are provided

#### Scenario: Test Isolation

**Given** a test file with setup/teardown functions
**When** tests run
**Then** each test has isolated temporary directory
**And** no test pollutes global state
**And** all temp directories are cleaned up after tests

### Requirement: Core Utility Integration Tests

The system MUST provide integration tests for core utility scripts achieving >60% coverage.

**Context**: Core utilities (installation, symlink management, environment switching) are critical and need comprehensive testing.

**Acceptance Criteria**:
- Tests for installation workflow
- Tests for link-dotfiles operations
- Tests for environment switching
- Coverage >60% of core scripts
- All critical paths covered

#### Scenario: Installation Dry-Run Test

**Given** a clean test environment
**When** user runs `./install --dry-run`
**Then** no filesystem modifications occur
**And** planned actions are displayed
**And** exit code is 0

#### Scenario: Link Dotfiles Test

**Given** a test HOME directory
**And** a valid LinkingManifest.json
**When** user runs `link-dotfiles --apply`
**Then** symlinks are created per manifest
**And** symlinks point to correct targets
**And** no broken symlinks exist

#### Scenario: Environment Switch Test

**Given** work-mode and personal-mode configs exist
**When** user runs `work-mode work`
**Then** work config is activated
**And** prompt reflects work environment
**And** running `work-mode personal` switches back

### Requirement: Git Utilities Integration Tests

The system MUST provide integration tests for git utilities achieving >70% coverage.

**Context**: Git utilities manage worktrees, commits, and synchronization - critical operations needing thorough testing.

**Acceptance Criteria**:
- Tests for git-worktree operations
- Tests for git-smart-merge
- Tests for conventional-commit
- Tests for savepoint operations
- Coverage >70% of git scripts

#### Scenario: Git Worktree Creation

**Given** a git repository with main branch
**When** user runs `git-worktree feature/new-feature`
**Then** new worktree is created in workspace directory
**And** worktree has correct branch checked out
**And** worktree is tracked by git

#### Scenario: Git Smart Merge

**Given** a feature branch ahead of main
**And** feature branch has clean history
**When** user runs `git-smart-merge main`
**Then** appropriate merge strategy is selected
**And** merge completes without conflicts
**And** commit history is clean

#### Scenario: Conventional Commit

**Given** staged changes in repository
**When** user runs `conventional-commit`
**Then** interactive prompts guide commit creation
**And** commit message follows conventional format
**And** commit includes co-author attribution

### Requirement: Credential Management Integration Tests

The system MUST provide integration tests for credential management achieving >50% coverage.

**Context**: Credential management must be secure and reliable, with tests using mock keychain storage.

**Acceptance Criteria**:
- Tests for store-api-key operations
- Tests for get-api-key retrieval
- Tests for credmatch functionality
- Mock keychain implementation
- Coverage >50% of credential scripts

#### Scenario: Store API Key

**Given** a test keychain
**When** user runs `echo "test-key" | store-api-key TEST_API_KEY --stdin`
**Then** key is stored in mock keychain
**And** key can be retrieved
**And** key is not exposed in process list or history

#### Scenario: Get API Key

**Given** a stored API key "TEST_KEY"
**When** user runs `get-api-key TEST_KEY`
**Then** key value is printed to stdout
**And** no error occurs
**And** exit code is 0

#### Scenario: Credential Match

**Given** multiple stored credentials
**When** user runs `credmatch "API"`
**Then** all matching credential names are listed
**And** no credential values are exposed

### Requirement: End-to-End Workflow Tests

The system MUST provide end-to-end workflow tests covering common user scenarios.

**Context**: Users perform multi-step workflows that cross script boundaries - these need integration testing.

**Acceptance Criteria**:
- Test for new machine setup workflow
- Test for daily sync workflow
- Test for work/personal mode switching
- All workflows complete successfully
- Workflows match user documentation

#### Scenario: New Machine Setup

**Given** a fresh test environment
**When** user performs setup workflow:
  1. Clones dotfiles repository
  2. Runs `./install --yes`
  3. Configures work mode with `work-mode work`
  4. Runs initial sync with `home-sync sync`
**Then** all steps complete successfully
**And** environment is fully configured
**And** all tools are accessible

#### Scenario: Daily Sync Workflow

**Given** an established dotfiles setup
**And** local changes exist
**When** user runs `home-sync sync --force`
**Then** changes are auto-committed
**And** changes are pushed to remote
**And** no uncommitted changes remain

### Requirement: Coverage Tracking and Reporting

The system MUST track and report shell script coverage using kcov.

**Context**: Coverage metrics ensure test suite adequacy and track testing progress over time.

**Acceptance Criteria**:
- kcov configured for shell scripts
- Coverage reports generated in HTML and XML
- Coverage threshold enforcement (>50%)
- CI uploads coverage to Codecov
- Coverage trends tracked

#### Scenario: Generate Coverage Report

**Given** integration tests are run with kcov
**When** tests complete
**Then** HTML coverage report is generated
**And** XML report is generated for CI
**And** coverage percentage is calculated
**And** uncovered lines are identified

#### Scenario: Enforce Coverage Threshold

**Given** coverage report shows 45% coverage
**When** CI checks coverage threshold
**Then** build fails
**And** error message indicates coverage below 50%
**And** uncovered areas are highlighted

### Requirement: CI/CD Integration

The system MUST integrate integration tests into CI/CD pipeline.

**Context**: Automated testing in CI catches regressions and ensures quality before merge.

**Acceptance Criteria**:
- Tests run on macOS and Linux
- Tests run on PRs and main branch
- Test failures block merge
- Coverage reports uploaded to Codecov
- Test execution <5 minutes

#### Scenario: Pull Request Testing

**Given** a pull request with code changes
**When** CI pipeline runs
**Then** integration tests execute on macOS and Linux
**And** coverage is measured
**And** test results are reported to PR
**And** merge is blocked if tests fail

#### Scenario: Main Branch Testing

**Given** code is merged to main branch
**When** CI pipeline runs
**Then** full integration test suite executes
**And** coverage report is generated
**And** coverage trends are tracked
**And** team is notified of failures

### Requirement: Test Fixtures and Helpers

The system MUST provide reusable test fixtures and helper functions.

**Context**: DRY test code requires shared utilities and pre-configured test data.

**Acceptance Criteria**:
- Git repository fixtures available
- File system fixtures available
- Configuration fixtures available
- Helper functions for common operations
- Setup/teardown utilities

#### Scenario: Use Git Repository Fixture

**Given** test needs a git repository
**When** test calls `create_test_repo "my-repo"`
**Then** clean git repo is created in temp directory
**And** repo has git config set
**And** repo path is returned
**And** repo is cleaned up after test

#### Scenario: Use Helper Functions

**Given** test needs to make a git commit
**When** test calls `make_commit "Test commit"`
**Then** file is created and staged
**And** commit is created with message
**And** commit is on current branch

### Requirement: Test Documentation

The system MUST provide comprehensive documentation for writing and running tests.

**Context**: Developers need clear guidance to write effective integration tests and debug failures.

**Acceptance Criteria**:
- README in tests/ directory
- Examples of each test pattern
- Fixture usage documentation
- Helper function reference
- Debugging guide

#### Scenario: Developer Writes New Test

**Given** developer needs to test new script
**When** developer reads test documentation
**Then** clear example tests are provided
**And** helper functions are documented
**And** fixture usage is explained
**And** developer can write test successfully

#### Scenario: Developer Debugs Failing Test

**Given** integration test fails
**When** developer follows debugging guide
**Then** guide explains how to run single test
**And** guide explains how to inspect test environment
**And** guide explains common failure patterns
**And** developer identifies root cause

### Requirement: Performance and Reliability

The system MUST ensure tests are fast, reliable, and maintainable.

**Context**: Slow or flaky tests reduce developer productivity and trust in the test suite.

**Acceptance Criteria**:
- Test suite completes in <5 minutes
- Test flakiness rate <2%
- Tests can run in parallel
- Tests have timeouts
- Tests are deterministic

#### Scenario: Parallel Test Execution

**Given** test suite has 100+ tests
**When** tests run with `bats --jobs 4`
**Then** tests execute in parallel
**And** total time is reduced
**And** no race conditions occur
**And** all tests pass reliably

#### Scenario: Test Timeout

**Given** test has infinite loop bug
**When** test runs
**Then** test times out after 30 seconds
**And** test is marked as failed
**And** timeout error is reported
**And** subsequent tests continue

## Dependencies

**External**:
- bats-core (test runner)
- bats-support (test helpers)
- bats-assert (assertions)
- bats-file (file assertions)
- kcov (coverage tool)

**Internal**:
- Shell scripts in bin/
- CI/CD workflows
- Documentation

## Backward Compatibility

No breaking changes - new capability only.

## Security Considerations

1. **Credential Isolation**: Tests use mock keychain, never real credentials
2. **Temp Directory Cleanup**: Prevent information leakage
3. **Git Config Isolation**: Test git config doesn't affect user's
4. **File Permission Tests**: Verify scripts don't modify protected files

## Performance Impact

- CI/CD pipeline adds ~5 minutes
- Local test runs optional
- Coverage tracking adds ~10% overhead
- No runtime impact on production scripts

## Monitoring and Observability

- Coverage trends tracked in Codecov
- Test execution time monitored in CI
- Flakiness rate tracked
- Test count tracked

## Success Metrics

1. Shell script coverage >50%
2. Test execution time <5 minutes
3. Test flakiness <2%
4. Zero critical bugs escape to production
5. 100% of new scripts have tests
