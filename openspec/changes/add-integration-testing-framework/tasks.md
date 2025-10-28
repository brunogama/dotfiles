# Implementation Tasks

## 1. Framework Setup
- [x] 1.1 Install bats-core via Homebrew
- [x] 1.2 Add bats-support and bats-assert libraries
- [x] 1.3 Create `tests/integration/` directory structure
- [x] 1.4 Create `tests/fixtures/` for test data
- [x] 1.5 Create `tests/helpers/test_helper.bash` with common utilities

## 2. Test Suites - Critical Flows
- [ ] 2.1 Symlink Management Tests (`test_symlink_management.bats`)
  - [ ] 2.1.1 Test link-dotfiles dry-run mode
  - [ ] 2.1.2 Test link-dotfiles apply mode
  - [ ] 2.1.3 Test symlink creation and removal
  - [ ] 2.1.4 Test conflict detection
- [ ] 2.2 Environment Switching Tests (`test_environment_switching.bats`)
  - [ ] 2.2.1 Test work-mode switch to work
  - [ ] 2.2.2 Test work-mode switch to personal
  - [ ] 2.2.3 Test work-mode status
  - [ ] 2.2.4 Test environment variable changes
- [x] 2.3 Credential Management Tests (`test_credentials.bats`)
  - [x] 2.3.1 Test store-api-key script exists
  - [x] 2.3.2 Test get-api-key script exists
  - [x] 2.3.3 Test credmatch script exists
  - [x] 2.3.4 Test all credential scripts
- [x] 2.4 Git Workflow Tests (`test_git_workflows.bats`)
  - [x] 2.4.1 Test conventional-commit
  - [x] 2.4.2 Test git-wip
  - [x] 2.4.3 Test git-smart-merge
  - [x] 2.4.4 Test git-save-all and git-restore-last-savepoint
- [ ] 2.5 Installation Tests (`test_installation.bats`)
  - [ ] 2.5.1 Test install --dry-run
  - [ ] 2.5.2 Test install --yes
  - [ ] 2.5.3 Test uninstallation cleanup

## 3. Test Infrastructure
- [x] 3.1 Create isolated test environment setup/teardown
- [x] 3.2 Implement fixture loading utilities
- [ ] 3.3 Add mock utilities for external dependencies
- [ ] 3.4 Create test data generators

## 4. Coverage and Quality
- [x] 4.1 Measure coverage of bin/core scripts
- [x] 4.2 Measure coverage of bin/git scripts
- [x] 4.3 Measure coverage of bin/credentials scripts
- [x] 4.4 Add tests until 50% coverage achieved
- [x] 4.5 Document coverage metrics

## 5. CI Integration
- [x] 5.1 Create `.github/workflows/integration-tests.yml`
- [x] 5.2 Configure test environment in CI
- [x] 5.3 Add test result reporting
- [x] 5.4 Configure test failure notifications
- [x] 5.5 Add coverage reporting to CI

## 6. Documentation
- [x] 6.1 Create `tests/README.md` with testing guide
- [x] 6.2 Document how to run tests locally
- [x] 6.3 Document how to write new tests
- [ ] 6.4 Update root README with testing section
- [x] 6.5 Add troubleshooting guide

## 7. Validation
- [x] 7.1 Run all tests locally and verify they pass
- [x] 7.2 Verify 50% coverage threshold met
- [ ] 7.3 Test CI workflow on pull request
- [x] 7.4 Validate tests run in clean environment
