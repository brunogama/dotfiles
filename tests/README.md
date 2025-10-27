# Integration Tests

This directory contains integration tests for the dotfiles system using the bats-core testing framework.

## Overview

The test suite provides automated verification of critical dotfiles workflows:

- Core utilities (link-dotfiles, home-sync, etc.)
- Git workflow scripts (git-wip, git-smart-merge, etc.)
- Credential management (store-api-key, get-api-key, etc.)

## Requirements

- bats-core (installed via Homebrew)
- bats-support library (included in tests/libs)
- bats-assert library (included in tests/libs)
- shellcheck (for script validation)

## Installation

Install required dependencies:

```bash
brew install bats-core shellcheck
```

The bats libraries are automatically installed in the `tests/libs` directory.

## Running Tests

### Run all tests

```bash
bats tests/integration/*.bats
```

### Run specific test file

```bash
bats tests/integration/test_core_utilities.bats
bats tests/integration/test_git_workflows.bats
bats tests/integration/test_credentials.bats
```

### Run tests with verbose output

```bash
bats -t tests/integration/*.bats
```

### Run tests with TAP output

```bash
bats --formatter tap tests/integration/*.bats
```

## Test Structure

```
tests/
├── integration/          # Integration test files
│   ├── test_core_utilities.bats
│   ├── test_git_workflows.bats
│   └── test_credentials.bats
├── helpers/             # Test helper utilities
│   └── test_helper.bash
├── libs/                # Bats libraries
│   ├── bats-support/
│   └── bats-assert/
└── fixtures/            # Test data and fixtures
```

## Writing Tests

### Test File Template

```bash
#!/usr/bin/env bats
# Description of test suite

load '../helpers/test_helper'

@test "descriptive test name" {
    # Test implementation
    run command_to_test

    assert_success
    assert_output "expected output"
}
```

### Available Helpers

From `test_helper.bash`:

- `setup()` - Runs before each test
- `teardown()` - Runs after each test
- `create_test_file(path, content)` - Create test files
- `assert_file_exists(path)` - Verify file exists
- `assert_file_not_exists(path)` - Verify file doesn't exist
- `assert_symlink_to(link, target)` - Verify symlink target
- `setup_git_user()` - Configure git for tests
- `create_test_repo(path)` - Create test git repository
- `skip_if_not_installed(command)` - Skip test if dependency missing

From bats-assert:

- `assert_success` - Verify command succeeded
- `assert_failure` - Verify command failed
- `assert_output` - Verify output matches
- `assert_line` - Verify specific output line
- `refute_output` - Verify output doesn't match

## Test Environment

Tests run in isolated environments:

- `TEST_TEMP_DIR` - Temporary directory for test data
- `TEST_HOME` - Isolated HOME directory
- `TEST_DOTFILES` - Isolated dotfiles directory
- `PROJECT_ROOT` - Path to project root

All test data is automatically cleaned up after each test.

## CI Integration

Tests run automatically in GitHub Actions on:

- Push to main branch
- Push to feature/* branches
- Pull requests to main

See `.github/workflows/integration-tests.yml` for CI configuration.

## Coverage

Current test coverage:

- Core utilities: 22/32 scripts (69%)
- Git workflows: 17/24 scripts (71%)
- Credentials: 6/9 scripts (67%)

**Overall: 45/89 scripts (51%)**

Target achieved: 50% coverage

## Adding New Tests

1. Create test file in `tests/integration/test_<category>.bats`
2. Add test cases using `@test` blocks
3. Use helper functions from `test_helper.bash`
4. Run tests locally to verify
5. Update coverage metrics in this README

## Troubleshooting

### Tests fail with "command not found"

Ensure the script exists and is executable:

```bash
ls -la bin/core/script-name
chmod +x bin/core/script-name
```

### Bats libraries not found

Reinstall bats libraries:

```bash
rm -rf tests/libs
mkdir -p tests/libs
cd tests/libs
git clone --depth 1 https://github.com/bats-core/bats-support.git
git clone --depth 1 https://github.com/bats-core/bats-assert.git
```

### Tests fail in CI but pass locally

Check that:
- All dependencies are installed in CI
- Tests don't rely on local environment
- Paths are absolute or relative to PROJECT_ROOT
- Tests clean up after themselves

## Best Practices

1. **Isolation** - Each test should be independent
2. **Cleanup** - Use teardown() to clean up test data
3. **Descriptive names** - Test names should explain what they verify
4. **Fast execution** - Keep tests quick (< 1 second each)
5. **Deterministic** - Tests should always produce same result
6. **No side effects** - Don't modify system state

## Resources

- [bats-core documentation](https://bats-core.readthedocs.io/)
- [bats-assert reference](https://github.com/bats-core/bats-assert)
- [bats-support reference](https://github.com/bats-core/bats-support)
