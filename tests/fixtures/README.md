# Test Fixtures

Test fixtures for bats integration tests. Fixtures provide pre-configured test data that can be copied and used in isolated test environments.

## Directory Structure

```
fixtures/
├── repos/              # Git repository fixtures
│   ├── simple-repo/           # Basic git repository with one commit
│   ├── repo-with-remote/      # Repository with remote tracking
│   ├── remote-repo.git/       # Bare remote repository
│   └── repo-with-conflicts/   # Repository with diverged branches
├── config/             # Configuration file fixtures
│   ├── test-gitconfig         # Sample git configuration
│   └── test-zshrc             # Sample zsh configuration
└── manifests/          # LinkingManifest fixtures
    └── test-linking-manifest.json
```

## Using Fixtures in Tests

### Copy Fixture to Test Directory

```bash
# Using helper function
copy_fixture "repos/simple-repo" "$TEST_TEMP_DIR"

# Using setup_with_fixtures
setup() {
    setup_with_fixtures "repos/simple-repo" "config/test-gitconfig"
}
```

### Access Copied Fixture

```bash
@test "use simple repo fixture" {
    cd "$TEST_TEMP_DIR/simple-repo"

    # Fixture is now in isolated test environment
    assert_on_branch "main"
    assert_file_exists "README.md"
}
```

## Repository Fixtures

### simple-repo

**Description**: Basic git repository with one commit on main branch.

**Contents**:
- One commit: "Initial commit"
- One file: `README.md`
- One branch: `master`

**Use Cases**:
- Testing basic git operations
- Testing file tracking
- Testing commit operations

**Example**:
```bash
@test "simple repo has one commit" {
    setup_with_fixtures "repos/simple-repo"
    cd "$TEST_TEMP_DIR/simple-repo"

    assert_commit_count 1
    assert_tracked_file "README.md"
}
```

### repo-with-remote

**Description**: Repository with remote tracking setup.

**Contents**:
- One commit: "Initial commit"
- One file: `README.md`
- Remote: `origin` pointing to `../remote-repo.git`
- Tracking branch: `main` tracks `origin/main`

**Use Cases**:
- Testing push/pull operations
- Testing remote tracking
- Testing fetch operations

**Example**:
```bash
@test "repo has remote configured" {
    setup_with_fixtures "repos/repo-with-remote" "repos/remote-repo.git"
    cd "$TEST_TEMP_DIR/repo-with-remote"

    assert_remote_exists "origin"
    run git remote get-url origin
    assert_success
}
```

### repo-with-conflicts

**Description**: Repository with two diverged branches that will conflict on merge.

**Contents**:
- Branch `master`: Contains "main" in `file.txt`
- Branch `feature`: Contains "feature" in `file.txt`
- Both branches modified the same file differently

**Use Cases**:
- Testing merge conflict handling
- Testing conflict resolution
- Testing rebase scenarios

**Example**:
```bash
@test "merging causes conflict" {
    setup_with_fixtures "repos/repo-with-conflicts"
    cd "$TEST_TEMP_DIR/repo-with-conflicts"

    run git merge feature
    assert_failure
    assert_merge_conflict
}
```

## Configuration Fixtures

### test-gitconfig

**Description**: Sample git configuration file with common settings.

**Contents**:
- User name and email
- Core editor and autocrlf settings
- Common aliases (st, ci, co, br, lg)
- Color UI enabled
- Default branch: main

**Use Cases**:
- Testing git configuration parsing
- Testing config file validation
- Testing git setup scripts

**Example**:
```bash
@test "parse git config" {
    setup_with_fixtures "config/test-gitconfig"

    export GIT_CONFIG_GLOBAL="$TEST_TEMP_DIR/test-gitconfig"
    run git config --global user.name
    assert_output "Test User"
}
```

### test-zshrc

**Description**: Minimal zsh configuration for testing.

**Contents**:
- PATH configuration
- History settings
- Basic options (HIST_IGNORE_DUPS, AUTO_CD, etc.)
- Completion setup
- Common aliases
- Test-specific environment variables

**Use Cases**:
- Testing zsh script sourcing
- Testing configuration loading
- Testing environment setup

**Example**:
```bash
@test "zshrc sets test mode" {
    setup_with_fixtures "config/test-zshrc"

    run zsh -c "source $TEST_TEMP_DIR/test-zshrc && echo \$TEST_MODE"
    assert_output "true"
}
```

## Manifest Fixtures

### test-linking-manifest.json

**Description**: Sample LinkingManifest with various link types.

**Contents**:
- Platform-agnostic links (zsh, git)
- Platform-specific links (darwin: Brewfile, linux: bash_profile)
- Optional and required links
- Metadata section

**Use Cases**:
- Testing manifest parsing
- Testing link creation
- Testing platform filtering
- Testing optional link handling

**Example**:
```bash
@test "manifest has darwin-specific links" {
    setup_with_fixtures "manifests/test-linking-manifest.json"

    run jq '.links[] | select(.platform == "darwin") | .source' \
        "$TEST_TEMP_DIR/test-linking-manifest.json"
    assert_output --partial "macos/Brewfile"
}
```

## Fixture Maintenance

### Adding New Fixtures

1. Create fixture in appropriate subdirectory
2. Document in this README
3. Include usage examples
4. Test fixture in isolation

### Fixture Guidelines

- **Minimal**: Include only essential data
- **Isolated**: Don't depend on external resources
- **Documented**: Explain purpose and contents
- **Realistic**: Mirror real-world scenarios
- **Deterministic**: Same fixture always produces same results

### Git Repository Fixtures

When creating git repository fixtures:

```bash
cd tests/fixtures/repos
mkdir my-new-repo
cd my-new-repo

git init
git config user.email "test@example.com"
git config user.name "Test User"

# Add content
echo "content" > file.txt
git add file.txt
git commit -m "Initial commit"
```

### Configuration File Fixtures

When creating config file fixtures:

- Use minimal, valid configuration
- Include comments explaining sections
- Use test-specific values (test@example.com, not real emails)
- Document any special features

### Manifest Fixtures

When creating manifest fixtures:

- Follow JSON schema validation
- Include platform diversity (darwin, linux, all)
- Include optional and required links
- Add meaningful metadata

## Troubleshooting

### Fixture Not Found

```bash
# Check fixture exists
ls -la tests/fixtures/repos/simple-repo

# Check copy_fixture path is correct
copy_fixture "repos/simple-repo" "$TEST_TEMP_DIR"  # Correct
copy_fixture "/repos/simple-repo" "$TEST_TEMP_DIR" # Incorrect (leading /)
```

### Git Fixture Issues

```bash
# Verify fixture is a git repository
cd tests/fixtures/repos/simple-repo
git status  # Should not error

# Check commits exist
git log  # Should show commits

# Verify branches
git branch -a  # Should list branches
```

### Permission Errors

```bash
# Ensure fixtures are readable
chmod -R +r tests/fixtures/

# Ensure git repositories are accessible
chmod -R +rx tests/fixtures/repos/
```

## Examples

### Complete Test Using Multiple Fixtures

```bash
#!/usr/bin/env bats

load '../helpers/test-helpers'
load '../helpers/git-helpers'
load '../helpers/setup-teardown'
load '../helpers/bats-support/load'
load '../helpers/bats-assert/load'

setup() {
    setup_with_fixtures \
        "repos/simple-repo" \
        "config/test-gitconfig" \
        "manifests/test-linking-manifest.json"
}

teardown() {
    standard_teardown
}

@test "use multiple fixtures" {
    # Use git repo
    cd "$TEST_TEMP_DIR/simple-repo"
    assert_commit_count 1

    # Use config
    assert_file_exists "$TEST_TEMP_DIR/test-gitconfig"
    assert_file_contains "$TEST_TEMP_DIR/test-gitconfig" "Test User"

    # Use manifest
    assert_file_exists "$TEST_TEMP_DIR/test-linking-manifest.json"
    run jq '.version' "$TEST_TEMP_DIR/test-linking-manifest.json"
    assert_output '"1.0"'
}
```
