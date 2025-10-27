#!/usr/bin/env bats
# Sample integration test demonstrating test patterns and helper functions

load '../helpers/test-helpers'
load '../helpers/git-helpers'
load '../helpers/file-helpers'
load '../helpers/setup-teardown'
load '../helpers/bats-support/load.bash'
load '../helpers/bats-assert/load.bash'
load '../helpers/bats-file/load.bash'

# Example 1: Basic test with standard setup/teardown
setup() {
    standard_setup
}

teardown() {
    standard_teardown
}

@test "sample: test environment is isolated" {
    # Verify test environment variables are set
    [[ -n "$TEST_TEMP_DIR" ]]
    [[ -n "$HOME" ]]
    [[ -d "$HOME" ]]

    # Verify HOME is in temp directory
    [[ "$HOME" == "$TEST_TEMP_DIR"* ]]
}

@test "sample: file operations work" {
    # Create file with content
    create_file_with_content "$HOME/test.txt" "Hello World"

    # Assert file exists and contains expected content
    assert_file_exists "$HOME/test.txt"
    assert_file_contains "$HOME/test.txt" "Hello World"

    # Assert line count
    assert_line_count "$HOME/test.txt" 1
}

@test "sample: directory operations work" {
    # Create directory structure
    create_directory_tree "$HOME" "level1/level2" "other/path"

    # Assert directories exist
    assert_dir_exists "$HOME/level1"
    assert_dir_exists "$HOME/level1/level2"
    assert_dir_exists "$HOME/other/path"

    # Create files in directories
    touch "$HOME/level1/file1.txt"
    touch "$HOME/level1/file2.txt"

    # Assert directory contains items
    assert_directory_item_count "$HOME/level1" 3  # 2 files + level2 dir
    assert_directory_contains "$HOME/level1" "file1.txt"
}

@test "sample: symlink operations work" {
    # Create source file
    create_file_with_content "$HOME/source.txt" "source content"

    # Create symlink
    create_symlink "$HOME/source.txt" "$HOME/link.txt"

    # Assert symlink exists and points to correct target
    assert_symlink_exists "$HOME/link.txt"
    assert_symlink_to "$HOME/link.txt" "$HOME/source.txt"

    # Assert symlink content is accessible
    assert_file_contains "$HOME/link.txt" "source content"
}

@test "sample: command execution with assertions" {
    # Run command and assert success
    run echo "test output"
    assert_success
    assert_output "test output"

    # Run command with multiple lines
    run bash -c "echo line1; echo line2"
    assert_success
    assert_line --index 0 "line1"
    assert_line --index 1 "line2"
}

@test "sample: git operations work" {
    # Create git repository
    repo_path="$(create_test_repo "sample-repo")"
    cd "$repo_path" || exit 1

    # Assert we're in a git repository
    run git rev-parse --git-dir
    assert_success

    # Create and commit file
    create_and_commit_file "README.md" "# Sample Repo" "Initial commit"

    # Assert file is tracked
    assert_tracked_file "README.md"

    # Assert commit exists
    assert_commit_count 1
    assert_on_branch "main"

    # Create branch
    create_branch "feature-branch"
    assert_on_branch "feature-branch"
    assert_branch_exists "feature-branch"

    # Make another commit on feature branch
    create_and_commit_file "feature.txt" "feature content" "Add feature"
    assert_commit_count 2
}

@test "sample: platform detection works" {
    # Get platform
    platform="$(get_platform)"

    # Assert platform is one of expected values
    [[ "$platform" == "darwin" || "$platform" == "linux" ]]

    # Platform-specific assertions
    if [[ "$platform" == "darwin" ]]; then
        assert_command_exists "sw_vers"
    elif [[ "$platform" == "linux" ]]; then
        assert_command_exists "uname"
    fi
}

@test "sample: skip patterns work" {
    # Example of conditional skip (won't actually skip in this test)
    if false; then
        skip "This test is skipped conditionally"
    fi

    # Test continues if not skipped
    assert_success
}

@test "sample: file permissions work" {
    # Create executable file
    create_file_with_content "$HOME/script.sh" "#!/bin/bash\necho test"
    make_executable "$HOME/script.sh"

    # Assert file is executable
    assert_executable "$HOME/script.sh"

    # Check permissions (755 on most systems)
    run stat -f "%OLp" "$HOME/script.sh" 2>/dev/null || stat -c "%a" "$HOME/script.sh"
    assert_success
}

@test "sample: file modification time checks work" {
    # Create file
    create_file_with_content "$HOME/recent.txt" "content"

    # Assert file was modified recently (within 10 seconds)
    assert_recently_modified "$HOME/recent.txt" 10
}

@test "sample: wait_for timeout works" {
    # Create file after delay
    (sleep 1 && touch "$HOME/delayed.txt") &

    # Wait for file to exist
    wait_for "[[ -f $HOME/delayed.txt ]]" 5 1

    # Assert file now exists
    assert_file_exists "$HOME/delayed.txt"
}

@test "sample: run script from dotfiles" {
    # Get dotfiles root
    dotfiles_root="$(get_dotfiles_root)"

    # Assert dotfiles root exists
    assert_dir_exists "$dotfiles_root"

    # Assert key directories exist
    assert_dir_exists "$dotfiles_root/bin"
    assert_dir_exists "$dotfiles_root/bin/core"
    assert_dir_exists "$dotfiles_root/bin/git"
}

@test "sample: empty and non-empty file checks work" {
    # Create empty file
    touch "$HOME/empty.txt"
    assert_file_empty "$HOME/empty.txt"

    # Create non-empty file
    echo "content" > "$HOME/non-empty.txt"
    assert_file_not_empty "$HOME/non-empty.txt"
}

@test "sample: broken symlink detection works" {
    # Create symlink to non-existent target
    ln -s "$HOME/does-not-exist" "$HOME/broken-link"

    # Assert symlink exists but is broken
    assert_symlink_exists "$HOME/broken-link"
    assert_broken_symlink "$HOME/broken-link"
}

@test "sample: git repository states work" {
    # Create repo
    repo_path="$(create_test_repo "state-repo")"
    cd "$repo_path" || exit 1

    # Initially should be empty (no commits)
    run git log
    assert_failure  # No commits yet

    # Make initial commit
    create_and_commit_file "file1.txt" "content1"
    assert_clean_repo

    # Make uncommitted change
    echo "new content" > "file2.txt"
    assert_dirty_repo

    # File should be untracked
    assert_untracked_file "file2.txt"

    # Add and commit
    git add file2.txt
    git commit -m "Add file2"
    assert_clean_repo
    assert_tracked_file "file2.txt"
}

@test "sample: absolute and relative path checks work" {
    # Absolute path
    assert_absolute_path "/usr/bin"
    assert_absolute_path "$HOME"

    # Relative path
    assert_relative_path "relative/path"
    assert_relative_path "../parent"
}

@test "sample: directory content checks work" {
    # Create directory with known contents
    mkdir -p "$HOME/test-dir"
    touch "$HOME/test-dir/file1.txt"
    touch "$HOME/test-dir/file2.txt"
    mkdir "$HOME/test-dir/subdir"

    # Assert item count
    assert_directory_item_count "$HOME/test-dir" 3

    # Assert specific items exist
    assert_directory_contains "$HOME/test-dir" "file1.txt"
    assert_directory_contains "$HOME/test-dir" "subdir"

    # Test empty directory
    mkdir "$HOME/empty-dir"
    assert_directory_empty "$HOME/empty-dir"
}
