# Proposal: Implement Integration Tests with Bats-Core

**Status**: Draft
**Priority**: HIGH
**Type**: New Capability
**Estimated Effort**: Large (2-3 weeks)

## Why

The dotfiles repository has comprehensive Python unit tests (91% coverage) but lacks integration tests for shell scripts. While shellcheck provides static analysis, we need runtime integration tests to verify:

1. End-to-end workflows across multiple scripts
2. Interaction with real git repositories
3. File system operations and symlink management
4. Script behavior with various input combinations
5. Error handling and edge cases

Currently:
- 50+ shell scripts in `bin/core/`, `bin/git/`, `bin/credentials/`
- CI only runs dry-run tests and basic smoke tests
- No systematic coverage measurement for shell scripts
- Manual testing is error-prone and time-consuming

## What

Implement a comprehensive integration test suite using bats-core (Bash Automated Testing System):

### Key Components

1. **Bats-Core Framework**
   - Install and configure bats-core as test runner
   - Add bats-support and bats-assert libraries for better assertions
   - Set up bats-file for file system testing utilities

2. **Test Coverage Targets**
   - Critical user flows: >80% coverage
   - Git utilities: >70% coverage
   - Core utilities: >60% coverage
   - Credential management: >50% coverage
   - Overall shell script coverage: >50%

3. **Test Organization**
   ```
   tests/
   ├── integration/
   │   ├── test_installation.bats      # Installation workflow
   │   ├── test_git_workflows.bats     # Git utilities
   │   ├── test_credential_mgmt.bats   # Credential operations
   │   ├── test_symlink_mgmt.bats      # Link management
   │   └── test_environment_switch.bats # Environment switching
   ├── fixtures/
   │   └── test-repos/                 # Test git repos
   └── helpers/
       └── test-helpers.bash            # Shared test utilities
   ```

4. **CI/CD Integration**
   - Add `test-integration` job to `.github/workflows/ci.yml`
   - Run tests on macOS and Linux
   - Generate coverage reports
   - Fail on coverage below threshold

## Success Criteria

1. **Coverage**: >50% shell script line coverage measured
2. **Critical Flows**: All critical user workflows have integration tests
3. **CI Integration**: Tests run automatically on PRs and main branch
4. **Documentation**: Clear guide for writing and running integration tests
5. **Performance**: Test suite completes in <5 minutes

## Benefits

1. **Quality**: Catch integration bugs before they reach production
2. **Confidence**: Safe refactoring with comprehensive test coverage
3. **Documentation**: Tests serve as executable documentation
4. **Consistency**: Automated verification of cross-platform behavior
5. **Velocity**: Faster development with quick feedback loops

## Risks and Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| Flaky tests | Medium | Use fixtures, isolate tests, avoid timing dependencies |
| Slow test suite | Medium | Parallelize tests, use test doubles where appropriate |
| Platform differences | Low | Test on both macOS and Linux in CI |
| Maintenance burden | Low | Keep tests focused and DRY with helpers |

## Dependencies

- bats-core (installable via Homebrew)
- bats-support, bats-assert, bats-file libraries
- CI/CD workflow modifications

## Alternatives Considered

1. **ShellSpec**: More features but steeper learning curve
2. **shUnit2**: Older, less actively maintained
3. **Manual testing**: Current state - not scalable
4. **Python-based tests**: Overhead of wrapping shell scripts

Bats-core chosen for:
- Simple, readable syntax
- Active maintenance and community
- Native bash integration
- Excellent library ecosystem

## Open Questions

1. Should we aim for 50% or higher initial coverage target?
2. Do we need performance benchmarking in integration tests?
3. Should tests run in parallel by default?
4. Do we need docker containers for Linux testing locally?

## Related Changes

- None (new capability)

## Impact Assessment

**Code Changes**: Medium
- New test files (~1000-1500 lines)
- CI workflow updates
- Documentation

**Breaking Changes**: None

**Migration Required**: No

## Approval Checklist

- [ ] Technical lead approval
- [ ] Coverage targets agreed upon
- [ ] CI/CD integration plan approved
- [ ] Timeline and resource allocation confirmed
