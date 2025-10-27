# Tasks: Implement Integration Tests with Bats-Core

## Phase 1: Foundation Setup (Week 1, Days 1-2)

### Task 1.1: Install and Configure Bats-Core
**Estimated Time**: 2 hours
**Dependencies**: None
**Priority**: CRITICAL

- [ ] Add bats-core to Brewfile for macOS
- [ ] Document Linux installation (apt-get install bats)
- [ ] Create `tests/` directory structure
- [ ] Install bats-support library: `git clone https://github.com/bats-core/bats-support.git tests/helpers/bats-support`
- [ ] Install bats-assert library: `git clone https://github.com/bats-core/bats-assert.git tests/helpers/bats-assert`
- [ ] Install bats-file library: `git clone https://github.com/bats-core/bats-file.git tests/helpers/bats-file`
- [ ] Create `.gitignore` entries for test artifacts

**Validation**: Run `bats --version` successfully

### Task 1.2: Set Up Test Infrastructure
**Estimated Time**: 3 hours
**Dependencies**: Task 1.1
**Priority**: CRITICAL

- [ ] Create `tests/helpers/test-helpers.bash` with core utilities
- [ ] Create `tests/helpers/git-helpers.bash` with git utilities
- [ ] Create `tests/helpers/file-helpers.bash` with file utilities
- [ ] Create `tests/helpers/setup-teardown.bash` with common setup/teardown
- [ ] Document helper function API in `tests/helpers/README.md`
- [ ] Create sample test `tests/integration/test_sample.bats` demonstrating patterns

**Validation**: Sample test runs and passes

### Task 1.3: Create Test Fixtures
**Estimated Time**: 4 hours
**Dependencies**: Task 1.2
**Priority**: HIGH

- [ ] Create `tests/fixtures/repos/simple-repo/` with basic git repo
- [ ] Create `tests/fixtures/repos/repo-with-remote/` with remote tracking
- [ ] Create `tests/fixtures/repos/repo-with-conflicts/` with merge conflicts
- [ ] Create `tests/fixtures/config/test-gitconfig` with test git config
- [ ] Create `tests/fixtures/config/test-zshrc` with test zsh config
- [ ] Create `tests/fixtures/manifests/test-linking-manifest.json` with test manifest
- [ ] Document fixture usage in `tests/fixtures/README.md`

**Validation**: Fixtures can be copied and used in tests

## Phase 2: Core Utility Tests (Week 1, Days 3-5)

### Task 2.1: Installation Workflow Tests
**Estimated Time**: 6 hours
**Dependencies**: Task 1.3
**Priority**: HIGH

- [ ] Create `tests/integration/core/test_installation.bats`
- [ ] Test `./install --dry-run` (no modifications, shows plan)
- [ ] Test `./install --yes` (non-interactive mode)
- [ ] Test `./install --skip-packages` (skips Homebrew)
- [ ] Test installation with missing dependencies (graceful failure)
- [ ] Test installation with existing symlinks (handles conflicts)
- [ ] Verify installer creates expected directory structure
- [ ] Add 5+ test cases covering happy path and error cases

**Validation**: `bats tests/integration/core/test_installation.bats` passes all tests

### Task 2.2: Symlink Management Tests
**Estimated Time**: 6 hours
**Dependencies**: Task 1.3
**Priority**: HIGH

- [ ] Create `tests/integration/core/test_link_dotfiles.bats`
- [ ] Test `link-dotfiles --dry-run` (preview only)
- [ ] Test `link-dotfiles --apply` (creates symlinks)
- [ ] Test symlink creation for each category (shell, git, packages, binaries)
- [ ] Test directory-contents linking
- [ ] Test optional links (not created when conditions not met)
- [ ] Test platform-specific links (darwin vs linux)
- [ ] Test broken symlink detection and cleanup
- [ ] Test symlink target validation

**Validation**: `bats tests/integration/core/test_link_dotfiles.bats` passes all tests

### Task 2.3: Environment Switching Tests
**Estimated Time**: 4 hours
**Dependencies**: Task 1.3
**Priority**: MEDIUM

- [ ] Create `tests/integration/core/test_environment_switch.bats`
- [ ] Test `work-mode work` (switches to work environment)
- [ ] Test `work-mode personal` (switches to personal environment)
- [ ] Test `work-mode status` (shows current mode)
- [ ] Test prompt indicator changes
- [ ] Test config file sourcing
- [ ] Test invalid mode handling

**Validation**: `bats tests/integration/core/test_environment_switch.bats` passes all tests

## Phase 3: Git Utilities Tests (Week 2, Days 1-3)

### Task 3.1: Git Worktree Tests
**Estimated Time**: 8 hours
**Dependencies**: Task 1.3
**Priority**: HIGH

- [ ] Create `tests/integration/git/test_git_worktree.bats`
- [ ] Test `git-worktree feature/new-feature` (creates worktree)
- [ ] Test worktree in correct location
- [ ] Test branch creation and checkout
- [ ] Test worktree cleanup on delete
- [ ] Test multiple worktrees
- [ ] Test worktree with existing branch
- [ ] Test virtual worktree creation with `git-virtual-worktree`
- [ ] Test worktree naming conventions
- [ ] Test error handling (invalid branch names, conflicts)

**Validation**: `bats tests/integration/git/test_git_worktree.bats` passes all tests

### Task 3.2: Smart Merge Tests
**Estimated Time**: 6 hours
**Dependencies**: Task 1.3
**Priority**: HIGH

- [ ] Create `tests/integration/git/test_git_smart_merge.bats`
- [ ] Test fast-forward merge
- [ ] Test rebase when appropriate
- [ ] Test merge commit when necessary
- [ ] Test conflict detection and handling
- [ ] Test merge with uncommitted changes
- [ ] Test merge strategy selection logic
- [ ] Test dry-run mode

**Validation**: `bats tests/integration/git/test_git_smart_merge.bats` passes all tests

### Task 3.3: Conventional Commit Tests
**Estimated Time**: 5 hours
**Dependencies**: Task 1.3
**Priority**: MEDIUM

- [ ] Create `tests/integration/git/test_conventional_commit.bats`
- [ ] Test interactive commit type selection
- [ ] Test scope input
- [ ] Test subject validation (≤50 chars)
- [ ] Test body wrapping (72 chars)
- [ ] Test commit format validation
- [ ] Test co-author attribution
- [ ] Test with pre-commit hooks

**Validation**: `bats tests/integration/git/test_conventional_commit.bats` passes all tests

### Task 3.4: Savepoint Tests
**Estimated Time**: 4 hours
**Dependencies**: Task 1.3
**Priority**: MEDIUM

- [ ] Create `tests/integration/git/test_git_savepoints.bats`
- [ ] Test `git-save-all` (creates WIP commit)
- [ ] Test `git-restore-last-savepoint` (restores state)
- [ ] Test savepoint with uncommitted changes
- [ ] Test savepoint with untracked files
- [ ] Test multiple savepoints
- [ ] Test savepoint cleanup

**Validation**: `bats tests/integration/git/test_git_savepoints.bats` passes all tests

## Phase 4: Credential Management Tests (Week 2, Days 4-5)

### Task 4.1: Store API Key Tests
**Estimated Time**: 4 hours
**Dependencies**: Task 1.3
**Priority**: HIGH

- [ ] Create `tests/integration/credentials/test_store_api_key.bats`
- [ ] Set up mock keychain for testing
- [ ] Test `store-api-key KEY --stdin` (stores from stdin)
- [ ] Test `store-api-key KEY --from-file FILE` (stores from file)
- [ ] Test key format validation
- [ ] Test overwrite existing key
- [ ] Test error handling (invalid input, permission denied)
- [ ] Verify no exposure in process list or history

**Validation**: `bats tests/integration/credentials/test_store_api_key.bats` passes all tests

### Task 4.2: Get API Key Tests
**Estimated Time**: 3 hours
**Dependencies**: Task 4.1
**Priority**: HIGH

- [ ] Create `tests/integration/credentials/test_get_api_key.bats`
- [ ] Test `get-api-key KEY` (retrieves value)
- [ ] Test non-existent key (error handling)
- [ ] Test output format (stdout only)
- [ ] Test with multiple stored keys
- [ ] Test permission handling

**Validation**: `bats tests/integration/credentials/test_get_api_key.bats` passes all tests

### Task 4.3: Credential Match Tests
**Estimated Time**: 2 hours
**Dependencies**: Task 4.1
**Priority**: MEDIUM

- [ ] Create `tests/integration/credentials/test_credmatch.bats`
- [ ] Test `credmatch "pattern"` (finds matching credentials)
- [ ] Test case-insensitive matching
- [ ] Test regex patterns
- [ ] Test empty results
- [ ] Verify no value exposure (only names)

**Validation**: `bats tests/integration/credentials/test_credmatch.bats` passes all tests

## Phase 5: Workflow Tests (Week 3, Days 1-2)

### Task 5.1: New Machine Setup Workflow
**Estimated Time**: 6 hours
**Dependencies**: Tasks 2.1, 2.2, 2.3
**Priority**: HIGH

- [ ] Create `tests/integration/workflows/test_new_machine_setup.bats`
- [ ] Test complete setup flow:
  1. Clone dotfiles
  2. Run install
  3. Configure work mode
  4. Run initial sync
- [ ] Verify all tools available after setup
- [ ] Verify config files properly linked
- [ ] Test setup on fresh macOS environment
- [ ] Test setup on fresh Linux environment
- [ ] Document setup time and steps

**Validation**: `bats tests/integration/workflows/test_new_machine_setup.bats` passes all tests

### Task 5.2: Daily Workflow Tests
**Estimated Time**: 4 hours
**Dependencies**: Tasks 2.1, 2.2, 3.x, 4.x
**Priority**: MEDIUM

- [ ] Create `tests/integration/workflows/test_daily_workflow.bats`
- [ ] Test sync workflow with local changes
- [ ] Test credential rotation workflow
- [ ] Test environment switch workflow
- [ ] Test git workflow (commit, push, pull)
- [ ] Test worktree workflow (create, switch, delete)

**Validation**: `bats tests/integration/workflows/test_daily_workflow.bats` passes all tests

## Phase 6: Coverage and CI Integration (Week 3, Days 3-5)

### Task 6.1: Set Up Coverage Tracking
**Estimated Time**: 6 hours
**Dependencies**: All test tasks
**Priority**: HIGH

- [ ] Install kcov on macOS: `brew install kcov`
- [ ] Document kcov installation for Linux
- [ ] Create wrapper script `bin/test/run-with-coverage.sh`
- [ ] Configure kcov to include `bin/` directory
- [ ] Configure kcov to exclude system paths
- [ ] Generate HTML coverage reports
- [ ] Generate XML coverage reports for CI
- [ ] Set coverage threshold to 50%

**Validation**: Coverage report generated successfully

### Task 6.2: CI/CD Integration
**Estimated Time**: 8 hours
**Dependencies**: Task 6.1
**Priority**: CRITICAL

- [ ] Update `.github/workflows/ci.yml`
- [ ] Add `test-integration` job for macOS
- [ ] Add `test-integration` job for Linux
- [ ] Install bats and libraries in CI
- [ ] Install kcov in CI
- [ ] Run tests with coverage in CI
- [ ] Upload coverage to Codecov
- [ ] Add coverage badge to README
- [ ] Configure coverage threshold check
- [ ] Add test results to PR comments

**Validation**: CI runs tests successfully on PR

### Task 6.3: Coverage Analysis and Gap Filling
**Estimated Time**: 6 hours
**Dependencies**: Task 6.2
**Priority**: HIGH

- [ ] Generate coverage report
- [ ] Identify scripts with <30% coverage
- [ ] Prioritize high-risk, low-coverage scripts
- [ ] Write additional tests for gaps
- [ ] Achieve overall >50% coverage
- [ ] Document remaining gaps and rationale
- [ ] Create issues for future test additions

**Validation**: Coverage >50% achieved and verified in CI

## Phase 7: Documentation and Polish (Week 4)

### Task 7.1: Test Documentation
**Estimated Time**: 6 hours
**Dependencies**: All test tasks
**Priority**: HIGH

- [ ] Create comprehensive `tests/README.md`
- [ ] Document how to run tests locally
- [ ] Document how to run single test file
- [ ] Document how to debug failing tests
- [ ] Document helper function API
- [ ] Document fixture usage patterns
- [ ] Create test writing guide with examples
- [ ] Add troubleshooting section

**Validation**: New developer can write test following documentation

### Task 7.2: Performance Optimization
**Estimated Time**: 4 hours
**Dependencies**: All test tasks
**Priority**: MEDIUM

- [ ] Profile test suite execution time
- [ ] Identify slow tests (>30s)
- [ ] Optimize fixture loading
- [ ] Enable parallel execution where safe
- [ ] Add test timeouts
- [ ] Measure improvement
- [ ] Target <5 minute total execution

**Validation**: Test suite completes in <5 minutes

### Task 7.3: Flakiness Detection and Fixes
**Estimated Time**: 4 hours
**Dependencies**: Task 6.2
**Priority**: MEDIUM

- [ ] Run tests 100 times to detect flakes
- [ ] Identify tests with >1% failure rate
- [ ] Analyze flake causes (timing, race conditions)
- [ ] Fix flaky tests
- [ ] Add retry logic where appropriate
- [ ] Document known limitations
- [ ] Target <2% flakiness rate

**Validation**: 100 consecutive runs with <2% flake rate

### Task 7.4: Final Review and Launch
**Estimated Time**: 3 hours
**Dependencies**: All tasks
**Priority**: CRITICAL

- [ ] Review all test code for quality
- [ ] Ensure all tests pass on macOS and Linux
- [ ] Verify coverage meets 50% threshold
- [ ] Update main README with testing section
- [ ] Create announcement/demo
- [ ] Train team on writing integration tests
- [ ] Merge to main branch
- [ ] Monitor CI stability for 1 week

**Validation**: Tests running reliably in CI for 1 week

## Summary

**Total Estimated Time**: 2-3 weeks (100-120 hours)

**Critical Path**:
1. Foundation Setup (Tasks 1.x)
2. Core Tests (Tasks 2.x)
3. Git Tests (Tasks 3.x)
4. CI Integration (Task 6.2)
5. Coverage Achievement (Task 6.3)

**Parallelizable Work**:
- Credential tests (Task 4.x) can be done alongside git tests
- Workflow tests (Task 5.x) can be done while fixing coverage gaps
- Documentation (Task 7.1) can be started early and updated throughout

**Success Criteria**:
- [ ] 50%+ shell script coverage
- [ ] <5 minute test execution
- [ ] <2% flakiness rate
- [ ] Tests run on every PR
- [ ] All critical workflows tested
- [ ] Documentation complete
