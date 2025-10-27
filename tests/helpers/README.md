# Test Helper Functions

Comprehensive helper functions for bats integration tests.

## Loading Helpers

```bash
#!/usr/bin/env bats

load '../helpers/test-helpers'
load '../helpers/git-helpers'
load '../helpers/file-helpers'
load '../helpers/setup-teardown'
load '../helpers/bats-support/load'
load '../helpers/bats-assert/load'
load '../helpers/bats-file/load'
```

## Setup and Teardown

### standard_setup()

Creates isolated test environment with temporary directories and git config.

```bash
setup() {
    standard_setup
}
```

**Environment Variables Set:**
- `TEST_TEMP_DIR` - Temporary directory for test
- `HOME` - Isolated home directory
- `XDG_CONFIG_HOME` - XDG config directory
- `XDG_DATA_HOME` - XDG data directory
- `XDG_CACHE_HOME` - XDG cache directory

### standard_teardown()

Cleans up temporary directories and restores environment.

```bash
teardown() {
    standard_teardown
}
```

### git_test_setup()

Sets up isolated environment plus git repository.

```bash
setup() {
    git_test_setup
}
```

**Additional Variables:**
- `TEST_REPO_DIR` - Test git repository directory

### credential_test_setup()

Sets up environment with mock keychain for credential tests.

```bash
setup() {
    credential_test_setup
}
```

**Additional Variables:**
- `KEYCHAIN_MOCK` - Mock keychain directory

### workflow_test_setup()

Creates full dotfiles environment with git repo and directory structure.

```bash
setup() {
    workflow_test_setup
}
```

**Additional Variables:**
- `DOTFILES_ROOT` - Dotfiles root directory
- `TEST_REPO_DIR` - Same as DOTFILES_ROOT

### symlink_test_setup()

Creates environment with source and target directories for symlink tests.

```bash
setup() {
    symlink_test_setup
}
```

**Additional Variables:**
- `SOURCE_DIR` - Source directory for symlinks
- `TARGET_DIR` - Target directory for symlinks

### setup_with_fixtures(fixture_name...)

Sets up environment and copies fixtures.

```bash
setup() {
    setup_with_fixtures "repos/simple-repo" "config/test-gitconfig"
}
```

### performance_test_setup()

Records start time for performance testing.

```bash
setup() {
    performance_test_setup
}
```

**Additional Variables:**
- `TEST_START_TIME` - Start time in nanoseconds
- `TIME_CMD` - Path to time command

## Core Test Helpers

### get_dotfiles_root()

Returns absolute path to dotfiles root directory.

```bash
dotfiles_root="$(get_dotfiles_root)"
```

### run_core_script(script, args...)

Runs script from bin/core/ directory.

```bash
run_core_script "syncenv" "--dry-run"
assert_success
```

### run_git_script(script, args...)

Runs script from bin/git/ directory.

```bash
run_git_script "git-wip" "test message"
assert_success
```

### run_cred_script(script, args...)

Runs script from bin/credentials/ directory.

```bash
run_cred_script "store-api-key" "TEST_KEY"
assert_success
```

### create_test_env()

Creates isolated test environment (called by standard_setup).

```bash
create_test_env
```

### cleanup_test_env()

Cleans up test environment (called by standard_teardown).

```bash
cleanup_test_env
```

### copy_fixture(fixture_name, [destination])

Copies fixture to test directory.

```bash
copy_fixture "repos/simple-repo" "$TEST_TEMP_DIR"
```

### create_empty_dir(dir_path)

Creates empty directory.

```bash
create_empty_dir "$TEST_TEMP_DIR/test-dir"
```

## Assertion Helpers

### assert_dir_exists(dir_path)

Asserts directory exists.

```bash
assert_dir_exists "$HOME/.config"
```

### assert_file_exists(file_path)

Asserts file exists.

```bash
assert_file_exists "$HOME/.zshrc"
```

### assert_file_contains(file_path, expected_text)

Asserts file contains text (regex supported).

```bash
assert_file_contains "$HOME/.zshrc" "export PATH"
```

### assert_command_exists(command)

Asserts command exists in PATH.

```bash
assert_command_exists "git"
```

### assert_script_success([expected_output])

Asserts script succeeded with optional output check.

```bash
run_core_script "syncenv" "--status"
assert_script_success "Environment: personal"
```

### assert_script_failure([expected_error])

Asserts script failed with optional error check.

```bash
run_core_script "syncenv" "--invalid"
assert_script_failure "Unknown option"
```

## Platform Helpers

### get_platform()

Returns current platform (darwin, linux, or unknown).

```bash
platform="$(get_platform)"
if [[ "$platform" == "darwin" ]]; then
    echo "Running on macOS"
fi
```

### assert_macos()

Asserts platform is macOS.

```bash
@test "macos specific test" {
    assert_macos
    # Test macOS-specific functionality
}
```

### assert_linux()

Asserts platform is Linux.

```bash
@test "linux specific test" {
    assert_linux
    # Test Linux-specific functionality
}
```

### skip_if_missing(command, [message])

Skips test if command not available.

```bash
@test "requires docker" {
    skip_if_missing "docker"
    run docker ps
    assert_success
}
```

### skip_on_platform(platform, [message])

Skips test on specific platform.

```bash
@test "not supported on darwin" {
    skip_on_platform "darwin" "Test requires Linux"
    # Linux-only test
}
```

### skip_in_ci([message])

Skips test when running in CI.

```bash
@test "local only test" {
    skip_in_ci "Requires local keychain"
    # Test that needs local resources
}
```

### skip_on_macos([message])

Skips test on macOS.

```bash
@test "linux only test" {
    skip_on_macos
    # Linux-specific test
}
```

### skip_on_linux([message])

Skips test on Linux.

```bash
@test "macos only test" {
    skip_on_linux
    # macOS-specific test
}
```

### skip_if_no_command(command, [message])

Skips test if command not available.

```bash
@test "requires kcov" {
    skip_if_no_command "kcov" "Coverage tool not available"
    # Test using kcov
}
```

## Wait and Timing

### wait_for(condition, [timeout], [interval])

Waits for condition with timeout.

```bash
wait_for "[[ -f $TEST_TEMP_DIR/output.txt ]]" 10 1
```

**Parameters:**
- `condition` - Bash expression to evaluate
- `timeout` - Timeout in seconds (default: 10)
- `interval` - Check interval in seconds (default: 1)

### assert_time_limit(limit_ms)

Asserts test completed within time limit (requires performance_test_setup).

```bash
setup() {
    performance_test_setup
}

@test "performance test" {
    run some_command
    assert_time_limit 1000  # Must complete in <1000ms
}
```

## Git Helpers

### create_test_repo([repo_name], [repo_path])

Creates isolated test git repository.

```bash
repo_path="$(create_test_repo "my-repo")"
cd "$repo_path"
```

### make_commit(message, [file])

Makes commit in current repository.

```bash
make_commit "Initial commit" "README.md"
```

### create_and_commit_file(file, [content], [message])

Creates file and commits it.

```bash
create_and_commit_file "test.txt" "Hello World" "Add test file"
```

### create_branch(branch_name, [base_branch])

Creates new branch.

```bash
create_branch "feature-branch" "main"
```

### switch_branch(branch_name)

Switches to branch.

```bash
switch_branch "feature-branch"
```

### assert_on_branch(expected_branch)

Asserts current branch.

```bash
assert_on_branch "main"
```

### assert_clean_repo()

Asserts repository has no uncommitted changes.

```bash
assert_clean_repo
```

### assert_dirty_repo()

Asserts repository has uncommitted changes.

```bash
assert_dirty_repo
```

### assert_tracked_file(file)

Asserts file is tracked by git.

```bash
assert_tracked_file "README.md"
```

### assert_untracked_file(file)

Asserts file is not tracked by git.

```bash
assert_untracked_file "temp.txt"
```

### assert_commit_exists(commit_ref)

Asserts commit exists.

```bash
assert_commit_exists "HEAD~1"
```

### assert_branch_exists(branch_name)

Asserts branch exists.

```bash
assert_branch_exists "main"
```

### assert_branch_not_exists(branch_name)

Asserts branch does not exist.

```bash
assert_branch_not_exists "deleted-branch"
```

### get_current_commit()

Returns current commit hash.

```bash
commit="$(get_current_commit)"
```

### get_commit_count()

Returns number of commits.

```bash
count="$(get_commit_count)"
```

### assert_commit_count(expected_count)

Asserts commit count.

```bash
assert_commit_count 3
```

### create_remote_repo([remote_name])

Creates bare remote repository.

```bash
remote_path="$(create_remote_repo "origin")"
```

### add_remote(remote_name, remote_path)

Adds remote to current repository.

```bash
add_remote "origin" "$remote_path"
```

### assert_remote_exists([remote_name])

Asserts remote exists.

```bash
assert_remote_exists "origin"
```

### push_to_remote([remote_name], [branch])

Pushes to remote.

```bash
push_to_remote "origin" "main"
```

### pull_from_remote([remote_name], [branch])

Pulls from remote.

```bash
pull_from_remote "origin" "main"
```

### assert_behind_remote([branch], [remote])

Asserts repository is behind remote.

```bash
assert_behind_remote "main" "origin"
```

### assert_ahead_of_remote([branch], [remote])

Asserts repository is ahead of remote.

```bash
assert_ahead_of_remote "main" "origin"
```

### create_merge_conflict([file])

Creates merge conflict scenario.

```bash
create_merge_conflict "test-file.txt"
```

### assert_merge_conflict()

Asserts merge conflict exists.

```bash
assert_merge_conflict
```

### clone_repo(source_repo, dest_path)

Clones repository.

```bash
clone_repo "$remote_path" "$TEST_TEMP_DIR/clone"
```

## File Helpers

### assert_symlink_exists(link_path)

Asserts symlink exists.

```bash
assert_symlink_exists "$HOME/.zshrc"
```

### assert_symlink_to(link_path, expected_target)

Asserts symlink points to target.

```bash
assert_symlink_to "$HOME/.zshrc" "$DOTFILES_ROOT/zsh/.zshrc"
```

### assert_broken_symlink(link_path)

Asserts symlink is broken.

```bash
assert_broken_symlink "$HOME/.old-config"
```

### create_symlink(target, link_path)

Creates symlink.

```bash
create_symlink "/path/to/target" "$HOME/.config"
```

### remove_symlink(link_path)

Removes symlink if it exists.

```bash
remove_symlink "$HOME/.old-config"
```

### assert_executable(file_path)

Asserts file is executable.

```bash
assert_executable "$DOTFILES_ROOT/bin/core/syncenv"
```

### assert_not_executable(file_path)

Asserts file is not executable.

```bash
assert_not_executable "$HOME/.zshrc"
```

### make_executable(file_path)

Makes file executable.

```bash
make_executable "test-script.sh"
```

### assert_permissions(file_path, expected_perms)

Asserts file permissions (octal).

```bash
assert_permissions "test.sh" "755"
```

### assert_file_size(file_path, expected_size)

Asserts file size in bytes.

```bash
assert_file_size "test.txt" 42
```

### assert_file_empty(file_path)

Asserts file is empty.

```bash
assert_file_empty "$TEST_TEMP_DIR/output.log"
```

### assert_file_not_empty(file_path)

Asserts file is not empty.

```bash
assert_file_not_empty "$TEST_TEMP_DIR/output.log"
```

### assert_file_contains_line(file_path, expected_line)

Asserts file contains exact line.

```bash
assert_file_contains_line "$HOME/.zshrc" "export PATH=/usr/local/bin:$PATH"
```

### assert_file_not_contains(file_path, text)

Asserts file does not contain text.

```bash
assert_file_not_contains "$HOME/.zshrc" "SECRET_KEY"
```

### count_lines(file_path)

Returns number of lines in file.

```bash
lines="$(count_lines "$HOME/.zshrc")"
```

### assert_line_count(file_path, expected_count)

Asserts file line count.

```bash
assert_line_count "$HOME/.zshrc" 100
```

### create_file_with_content(file_path, content)

Creates file with content.

```bash
create_file_with_content "$TEST_TEMP_DIR/test.txt" "Hello World"
```

### append_to_file(file_path, content)

Appends content to file.

```bash
append_to_file "$TEST_TEMP_DIR/test.txt" "New line"
```

### assert_directory_empty(dir_path)

Asserts directory is empty.

```bash
assert_directory_empty "$TEST_TEMP_DIR/empty-dir"
```

### assert_directory_item_count(dir_path, expected_count)

Asserts directory contains n items.

```bash
assert_directory_item_count "$HOME/.config" 5
```

### assert_directory_contains(dir_path, item_name)

Asserts directory contains item.

```bash
assert_directory_contains "$HOME/.config" "zsh"
```

### copy_directory(source, dest)

Copies directory contents.

```bash
copy_directory "$DOTFILES_ROOT/zsh" "$HOME/.config/zsh"
```

### create_directory_tree(base_dir, paths...)

Creates nested directory structure.

```bash
create_directory_tree "$TEST_TEMP_DIR" "a/b/c" "d/e/f"
```

### assert_absolute_path(path)

Asserts path is absolute.

```bash
assert_absolute_path "/home/user/file.txt"
```

### assert_relative_path(path)

Asserts path is relative.

```bash
assert_relative_path "relative/path/file.txt"
```

### get_mtime(file_path)

Returns file modification time (Unix timestamp).

```bash
mtime="$(get_mtime "test.txt")"
```

### assert_recently_modified(file_path, [within_seconds])

Asserts file was modified recently.

```bash
assert_recently_modified "output.txt" 5
```

## Example Test Patterns

### Basic Test

```bash
#!/usr/bin/env bats

load '../helpers/test-helpers'
load '../helpers/bats-support/load'
load '../helpers/bats-assert/load'

setup() {
    standard_setup
}

teardown() {
    standard_teardown
}

@test "example test" {
    run echo "hello"
    assert_success
    assert_output "hello"
}
```

### Git Test

```bash
#!/usr/bin/env bats

load '../helpers/git-helpers'
load '../helpers/setup-teardown'
load '../helpers/bats-support/load'
load '../helpers/bats-assert/load'

setup() {
    git_test_setup
}

teardown() {
    git_test_teardown
}

@test "create and commit file" {
    create_and_commit_file "test.txt" "content"
    assert_tracked_file "test.txt"
    assert_commit_count 1
}
```

### With Fixtures

```bash
#!/usr/bin/env bats

load '../helpers/test-helpers'
load '../helpers/setup-teardown'
load '../helpers/bats-support/load'
load '../helpers/bats-assert/load'

setup() {
    setup_with_fixtures "repos/simple-repo"
}

teardown() {
    standard_teardown
}

@test "use fixture" {
    cd "$TEST_TEMP_DIR/simple-repo"
    assert_on_branch "main"
}
```

### Platform-Specific Test

```bash
@test "macos specific" {
    skip_on_linux "Requires macOS keychain"

    run security find-generic-password -s "test"
    assert_success
}
```

### Performance Test

```bash
setup() {
    performance_test_setup
}

teardown() {
    performance_test_teardown
}

@test "completes quickly" {
    run some_command
    assert_success
    assert_time_limit 1000  # <1 second
}
```
