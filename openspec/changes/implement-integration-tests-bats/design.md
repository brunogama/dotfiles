# Design: Integration Tests with Bats-Core

## Architecture Overview

The integration test system will use bats-core as the test runner with a modular architecture supporting:

1. **Test isolation**: Each test runs in a clean environment
2. **Fixture management**: Reusable test repositories and file structures
3. **Helper functions**: Shared utilities for common operations
4. **Coverage tracking**: Shell script coverage measurement
5. **CI integration**: Automated testing on multiple platforms

## Test Framework Stack

```
┌─────────────────────────────────────┐
│      Bats-Core Test Runner          │
├─────────────────────────────────────┤
│  bats-support (enhanced assertions) │
│  bats-assert  (rich assertions)     │
│  bats-file    (file system utils)   │
├─────────────────────────────────────┤
│     Custom Test Helpers             │
│  - Git repo fixtures                │
│  - Temporary directory mgmt         │
│  - Mock credential storage          │
├─────────────────────────────────────┤
│       Scripts Under Test            │
│  bin/core/* bin/git/* bin/creds/*  │
└─────────────────────────────────────┘
```

## Directory Structure

```
tests/
├── integration/
│   ├── core/
│   │   ├── test_installation.bats
│   │   ├── test_link_dotfiles.bats
│   │   └── test_environment_switch.bats
│   ├── git/
│   │   ├── test_git_worktree.bats
│   │   ├── test_git_smart_merge.bats
│   │   ├── test_conventional_commit.bats
│   │   └── test_git_savepoints.bats
│   ├── credentials/
│   │   ├── test_store_api_key.bats
│   │   ├── test_get_api_key.bats
│   │   └── test_credmatch.bats
│   └── workflows/
│       ├── test_new_machine_setup.bats
│       └── test_daily_workflow.bats
├── fixtures/
│   ├── repos/
│   │   ├── simple-repo/
│   │   ├── repo-with-remote/
│   │   └── repo-with-conflicts/
│   ├── config/
│   │   ├── test-gitconfig
│   │   └── test-zshrc
│   └── manifests/
│       └── test-linking-manifest.json
├── helpers/
│   ├── test-helpers.bash
│   ├── git-helpers.bash
│   ├── file-helpers.bash
│   └── setup-teardown.bash
└── coverage/
    └── kcov-output/
```

## Test Isolation Strategy

### Setup/Teardown Pattern

Each test file uses:

```bash
setup() {
    # Create isolated temp directory
    export TEST_TEMP_DIR="$(mktemp -d)"
    export HOME="$TEST_TEMP_DIR/home"
    mkdir -p "$HOME"

    # Set up git config
    git config --global user.email "test@example.com"
    git config --global user.name "Test User"

    # Copy fixtures
    cp -r "$BATS_TEST_DIRNAME/../fixtures" "$TEST_TEMP_DIR/"
}

teardown() {
    # Clean up temp directory
    rm -rf "$TEST_TEMP_DIR"
}
```

### Fixture Management

**Git Repository Fixtures**:
- Pre-configured test repos with known state
- Committed to `tests/fixtures/repos/`
- Copied to temp dir for each test
- Various states: clean, dirty, with-conflicts, behind-remote

**Configuration Fixtures**:
- Sample config files
- Test-specific gitconfig, zshrc
- LinkingManifest.json variants

## Helper Functions

### Core Helpers (`test-helpers.bash`)

```bash
# Run script and capture output
run_script() {
    local script="$1"
    shift
    run "$DOTFILES_ROOT/bin/core/$script" "$@"
}

# Assert script succeeded
assert_script_success() {
    assert_success
    assert_output --partial "$1"
}

# Create test git repo
create_test_repo() {
    local repo_name="$1"
    local repo_path="$TEST_TEMP_DIR/$repo_name"

    mkdir -p "$repo_path"
    cd "$repo_path"
    git init
    git config user.email "test@example.com"
    git config user.name "Test User"

    echo "$repo_path"
}
```

### Git Helpers (`git-helpers.bash`)

```bash
# Create commit
make_commit() {
    local message="$1"
    local file="${2:-test-file.txt}"

    echo "content-$(date +%s)" > "$file"
    git add "$file"
    git commit -m "$message"
}

# Check branch status
assert_branch() {
    local expected="$1"
    local actual="$(git rev-parse --abbrev-ref HEAD)"

    assert_equal "$expected" "$actual"
}

# Assert repo is clean
assert_clean_repo() {
    run git status --porcelain
    assert_output ""
}
```

### File Helpers (`file-helpers.bash`)

```bash
# Assert symlink points to target
assert_symlink_to() {
    local link="$1"
    local target="$2"

    assert [ -L "$link" ]
    assert_equal "$(readlink "$link")" "$target"
}

# Assert file contains text
assert_file_contains() {
    local file="$1"
    local text="$2"

    assert grep -q "$text" "$file"
}
```

## Coverage Tracking

Using `kcov` (Kernel Code Coverage) for shell script coverage:

1. **Installation**: `brew install kcov` (macOS), `apt-get install kcov` (Linux)
2. **Integration**: Wrap test runs with kcov
3. **Reporting**: Generate HTML and JSON coverage reports
4. **CI Integration**: Upload to Codecov

```bash
# Run tests with coverage
kcov \
    --exclude-pattern=/usr/,/opt/ \
    --include-path=bin/ \
    coverage/ \
    bats tests/integration/
```

## Test Categories

### 1. Installation Tests (`test_installation.bats`)

**Coverage**: Installation workflow, dependency checks, dry-run mode

```bash
@test "install --dry-run shows planned actions" {
    run ./install --dry-run

    assert_success
    assert_output --partial "Would create symlink"
    assert_output --partial "Would install packages"
}

@test "install --yes non-interactive mode" {
    run ./install --yes --skip-packages

    assert_success
    assert [ -L "$HOME/.zshrc" ]
}
```

### 2. Git Workflow Tests (`test_git_worktree.bats`)

**Coverage**: git-worktree, git-virtual-worktree, branch operations

```bash
@test "git-worktree creates new worktree" {
    cd "$(create_test_repo main-repo)"
    make_commit "Initial"

    run git-worktree feature/test

    assert_success
    assert [ -d "$HOME/work/main-repo-feature-test" ]
}

@test "git-worktree cleans up on delete" {
    # ... test cleanup logic
}
```

### 3. Credential Management Tests (`test_store_api_key.bats`)

**Coverage**: store-api-key, get-api-key, credmatch

```bash
@test "store-api-key saves to keychain" {
    echo "test-key-value" | run store-api-key TEST_KEY --stdin

    assert_success

    run get-api-key TEST_KEY
    assert_output "test-key-value"
}

@test "store-api-key validates key format" {
    echo "invalid" | run store-api-key INVALID --stdin

    assert_failure
    assert_output --partial "Invalid key format"
}
```

### 4. Symlink Management Tests (`test_link_dotfiles.bats`)

**Coverage**: link-dotfiles, LinkingManifest.json parsing

```bash
@test "link-dotfiles creates symlinks from manifest" {
    run link-dotfiles --apply

    assert_success
    assert_symlink_to "$HOME/.gitconfig" "$DOTFILES_ROOT/git/.gitconfig"
    assert_symlink_to "$HOME/.zshrc" "$DOTFILES_ROOT/zsh/.zshrc"
}

@test "link-dotfiles dry-run doesn't modify filesystem" {
    run link-dotfiles --dry-run

    assert_success
    assert [ ! -L "$HOME/.gitconfig" ]
}
```

### 5. End-to-End Workflow Tests (`test_daily_workflow.bats`)

**Coverage**: Common multi-script workflows

```bash
@test "new machine setup workflow" {
    # 1. Clone dotfiles
    # 2. Run install
    # 3. Configure work mode
    # 4. Verify all tools available

    run ./install --yes
    run work-mode work
    run home-sync sync --skip-push

    assert_success
}

@test "sync workflow with credentials" {
    # 1. Store API keys
    # 2. Sync dotfiles
    # 3. Verify credentials available

    echo "key1" | run store-api-key KEY1 --stdin
    run home-sync sync --force
    run get-api-key KEY1

    assert_output "key1"
}
```

## CI/CD Integration

### GitHub Actions Workflow

Add to `.github/workflows/ci.yml`:

```yaml
test-integration:
  name: Integration Tests
  runs-on: ${{ matrix.os }}
  strategy:
    matrix:
      os: [macos-latest, ubuntu-latest]

  steps:
    - uses: actions/checkout@v4

    - name: Install bats
      run: |
        if [[ "$RUNNER_OS" == "macOS" ]]; then
          brew install bats-core kcov
        else
          sudo apt-get update
          sudo apt-get install -y bats kcov
        fi

    - name: Install bats libraries
      run: |
        git clone https://github.com/bats-core/bats-support.git tests/helpers/bats-support
        git clone https://github.com/bats-core/bats-assert.git tests/helpers/bats-assert
        git clone https://github.com/bats-core/bats-file.git tests/helpers/bats-file

    - name: Run integration tests
      run: |
        kcov \
          --exclude-pattern=/usr/,/opt/ \
          --include-path=bin/ \
          tests/coverage/ \
          bats tests/integration/

    - name: Check coverage threshold
      run: |
        coverage=$(kcov --print-summary tests/coverage/ | grep "percent_covered" | awk '{print $2}')
        if (( $(echo "$coverage < 50" | bc -l) )); then
          echo "ERROR: Coverage $coverage% below 50% threshold"
          exit 1
        fi

    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        files: tests/coverage/kcov-merged/cobertura.xml
        flags: integration-tests
```

## Performance Considerations

1. **Parallel Execution**: Use `bats --jobs 4` for parallel test runs
2. **Fixture Caching**: Pre-build fixtures, don't regenerate per-test
3. **Selective Testing**: Tag tests by priority/category
4. **Resource Limits**: Set timeouts for long-running tests

## Maintenance Strategy

1. **Test-Driven Development**: Write tests before script changes
2. **Coverage Monitoring**: Track coverage trends over time
3. **Flake Detection**: Mark and isolate flaky tests
4. **Documentation**: Keep test README updated
5. **Regular Review**: Quarterly test suite health checks

## Success Metrics

1. **Coverage**: Shell script line coverage >50%
2. **Reliability**: <2% test flakiness rate
3. **Performance**: Test suite <5 minutes
4. **Adoption**: Tests written for all new scripts
5. **Bug Detection**: Catch bugs before production

## Trade-offs

| Decision | Pros | Cons |
|----------|------|------|
| Bats-core vs ShellSpec | Simpler, more popular | Fewer features |
| kcov vs custom coverage | Standard tool, accurate | Platform-specific setup |
| Test in CI only | No local setup needed | Slower feedback |
| Extensive fixtures | Realistic tests | More maintenance |

## Security Considerations

1. **Credential Tests**: Use mock keychain, never real credentials
2. **Temp Directories**: Ensure cleanup prevents information leakage
3. **Git Config**: Isolate test git config from user's global config
4. **File Permissions**: Test scripts don't modify protected files

## Future Enhancements

1. **Property-Based Testing**: Generate random test cases
2. **Mutation Testing**: Verify test suite effectiveness
3. **Performance Benchmarks**: Track script performance over time
4. **Visual Diffs**: Show before/after filesystem states
5. **Interactive Mode**: Debug tests with breakpoints
