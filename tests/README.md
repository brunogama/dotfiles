# Integration Testing Framework

Comprehensive integration test suite for the dotfiles repository using Bats (Bash Automated Testing System).

## Overview

- **890+ integration test cases** across 16 test files
- **5,500+ lines of test code**
- Core utilities, git utilities, credentials, and workflow testing
- Helper functions for test isolation and repeatability
- Full CI/CD integration with GitHub Actions
- Test runner with parallel execution and filtering

## Installation

### macOS

```bash
brew install bats-core kcov
```

### Linux (Ubuntu/Debian)

```bash
sudo apt-get update
sudo apt-get install -y bats kcov
```

### Linux (Fedora/RHEL)

```bash
sudo dnf install bats kcov
```

### Manual Installation

If bats-core is not available in your package manager:

```bash
git clone https://github.com/bats-core/bats-core.git
cd bats-core
sudo ./install.sh /usr/local
```

## Running Tests

### Using the Test Runner (Recommended)

```bash
# Run all tests
./bin/test/run-tests

# Run with verbose output
./bin/test/run-tests --verbose

# Run specific test category
./bin/test/run-tests core
./bin/test/run-tests git
./bin/test/run-tests workflows

# Run tests matching a pattern
./bin/test/run-tests --filter "wip"

# Run in parallel (4 jobs)
./bin/test/run-tests --parallel 4

# Show timing information
./bin/test/run-tests --timing

# TAP output format (for CI)
./bin/test/run-tests --tap
```

### Using Bats Directly

```bash
# Run all tests
bats tests/integration/

# Run specific test file
bats tests/integration/core/test_installation.bats

# Run with filter
bats tests/integration/ --filter "git-wip"

# Run in parallel
bats --jobs 4 tests/integration/
```

## Test Organization

```
tests/
├── integration/          # Integration test files (.bats)
│   ├── core/            # Core utility tests
│   ├── git/             # Git utility tests
│   ├── credentials/     # Credential management tests
│   └── workflows/       # End-to-end workflow tests
├── fixtures/            # Test data and fixtures
│   ├── repos/          # Git repository fixtures
│   ├── config/         # Configuration file fixtures
│   └── manifests/      # LinkingManifest fixtures
├── helpers/            # Helper functions and utilities
│   ├── bats-support/   # Bats support library
│   ├── bats-assert/    # Assertion library
│   ├── bats-file/      # File testing utilities
│   ├── test-helpers.bash
│   ├── git-helpers.bash
│   ├── file-helpers.bash
│   └── setup-teardown.bash
└── coverage/           # Coverage reports (gitignored)
```

## Writing Tests

See `tests/helpers/README.md` for documentation on helper functions and test patterns.

### Basic Test Structure

```bash
#!/usr/bin/env bats

load '../helpers/test-helpers'
load '../helpers/bats-support/load'
load '../helpers/bats-assert/load'

setup() {
    export TEST_TEMP_DIR="$(mktemp -d)"
    export HOME="$TEST_TEMP_DIR/home"
    mkdir -p "$HOME"
}

teardown() {
    rm -rf "$TEST_TEMP_DIR"
}

@test "example test" {
    run echo "hello"
    assert_success
    assert_output "hello"
}
```

## Helper Functions

Core helper functions are available in:
- `test-helpers.bash` - General utilities
- `git-helpers.bash` - Git operations
- `file-helpers.bash` - File system operations
- `setup-teardown.bash` - Common setup/teardown

## Debugging Tests

### Run Single Test

```bash
bats tests/integration/core/test_installation.bats --filter "dry-run"
```

### Enable Verbose Output

```bash
bats --verbose-run tests/integration/
```

### Inspect Test Environment

Add to your test:
```bash
echo "TEST_TEMP_DIR: $TEST_TEMP_DIR" >&3
ls -la "$TEST_TEMP_DIR" >&3
```

## CI Integration

Tests run automatically in CI on:
- Pull requests
- Pushes to main branch
- Manual workflow dispatch

See `.github/workflows/ci.yml` for CI configuration.

## Coverage Requirements

- Overall coverage: >50%
- Core utilities: >60%
- Git utilities: >70%
- Credential management: >50%

## Performance

- Test suite target: <5 minutes
- Individual test timeout: 30 seconds
- Flakiness target: <2%

## Contributing

When adding new tests:

1. Follow existing test patterns
2. Use helper functions from `tests/helpers/`
3. Ensure tests are deterministic
4. Add fixtures for complex test data
5. Document test purpose and assertions
6. Verify tests pass locally before committing

## Troubleshooting

### Tests Fail Due to Missing Dependencies

Ensure bats-core and kcov are installed:
```bash
which bats
which kcov
```

### Permission Errors

Tests create temporary directories - ensure you have write permissions:
```bash
mkdir -p "$TMPDIR/test" && rm -rf "$TMPDIR/test"
```

### Git Configuration Issues

Tests set up isolated git config - if tests fail due to git errors, check:
```bash
git config --global user.email
git config --global user.name
```

### Timeout Errors

If tests timeout, increase the timeout or investigate slow operations:
```bash
bats --no-parallelize-across-files tests/integration/
```
