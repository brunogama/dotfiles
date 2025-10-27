# Integration Testing Specification

## ADDED Requirements

### Requirement: Test Framework
The system SHALL provide a bats-core testing framework for shell script integration tests.

#### Scenario: Framework installation
- **WHEN** bats-core is installed via Homebrew
- **THEN** bats, bats-support, and bats-assert libraries are available

#### Scenario: Test execution
- **WHEN** user runs `bats tests/integration/*.bats`
- **THEN** all integration tests execute and report results

### Requirement: Test Coverage
The system SHALL provide integration tests covering at least 50% of shell scripts in bin/ directories.

#### Scenario: Coverage measurement
- **WHEN** coverage is measured after test suite completion
- **THEN** coverage percentage is at least 50% for bin/core, bin/git, and bin/credentials

#### Scenario: Coverage reporting
- **WHEN** tests complete
- **THEN** coverage report is generated showing tested vs untested scripts

### Requirement: Critical Flow Tests
The system SHALL provide integration tests for all critical user workflows.

#### Scenario: Symlink management flow
- **WHEN** link-dotfiles is executed in dry-run and apply modes
- **THEN** symlink creation, removal, and conflict detection are verified

#### Scenario: Environment switching flow
- **WHEN** work-mode switches between work and personal environments
- **THEN** environment variables, prompts, and configurations are verified

#### Scenario: Credential management flow
- **WHEN** store-api-key and get-api-key are used
- **THEN** secure storage and retrieval from keychain are verified

#### Scenario: Git workflow operations
- **WHEN** git utilities like conventional-commit, git-wip, git-smart-merge are used
- **THEN** expected git operations and outcomes are verified

#### Scenario: Installation flow
- **WHEN** install script runs in dry-run and yes modes
- **THEN** installation steps and cleanup are verified

### Requirement: Test Isolation
The system SHALL provide isolated test environments that do not affect user data or system state.

#### Scenario: Isolated environment setup
- **WHEN** test suite begins
- **THEN** temporary test environment is created with fixtures and mocks

#### Scenario: Environment cleanup
- **WHEN** test suite completes or fails
- **THEN** temporary test environment is fully cleaned up

#### Scenario: No side effects
- **WHEN** tests execute
- **THEN** user dotfiles, git config, and keychain remain unmodified

### Requirement: CI Integration
The system SHALL execute integration tests automatically in CI on pull requests and merges.

#### Scenario: CI test execution
- **WHEN** pull request is created or updated
- **THEN** integration tests run in GitHub Actions workflow

#### Scenario: Test failure blocking
- **WHEN** integration tests fail in CI
- **THEN** pull request is blocked from merging

#### Scenario: Test results reporting
- **WHEN** CI tests complete
- **THEN** results and coverage are reported in pull request checks

### Requirement: Test Documentation
The system SHALL provide comprehensive documentation for writing and running integration tests.

#### Scenario: Testing guide
- **WHEN** developer reads tests/README.md
- **THEN** documentation explains how to run tests locally and write new tests

#### Scenario: Troubleshooting guide
- **WHEN** developer encounters test failures
- **THEN** documentation provides troubleshooting steps and common issues
