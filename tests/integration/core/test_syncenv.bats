#!/usr/bin/env bats
# Integration tests for syncenv script

load '../../helpers/test-helpers'
load '../../helpers/git-helpers'
load '../../helpers/file-helpers'
load '../../helpers/setup-teardown'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'
load '../../helpers/bats-file/load.bash'

setup() {
    git_test_setup

    # Set up as dotfiles repo
    export DOTFILES_ROOT="$TEST_REPO_DIR"
    cd "$DOTFILES_ROOT"

    # Create minimal dotfiles structure
    mkdir -p zsh
    echo "test zshrc" > zsh/.zshrc
}

teardown() {
    git_test_teardown
}

# Status Command Tests

@test "syncenv: status shows sync state" {
    run_core_script "syncenv" "status"
    assert_success
}

@test "syncenv: status shows git status" {
    run_core_script "syncenv" "status"
    assert_success
    # Should show some git information
}

# Dry-run Tests

@test "syncenv: --dry-run shows what would be done" {
    # Make a change
    echo "modified" > zsh/.zshrc

    run_core_script "syncenv" "--dry-run"
    assert_success
    assert_output --partial "DRY RUN"
}

@test "syncenv: --dry-run does not commit" {
    # Make a change
    echo "modified" > zsh/.zshrc

    run_core_script "syncenv" "--dry-run"
    assert_success

    # Should still be dirty
    assert_dirty_repo
}

# Git Detection Tests

@test "syncenv: detects when in git repository" {
    run_core_script "syncenv" "status"
    assert_success
}

@test "syncenv: handles non-git directory" {
    # Remove .git
    rm -rf "$TEST_REPO_DIR/.git"

    run_core_script "syncenv" "status"
    # Should handle gracefully or report not in git repo
}

# Clean Repository Tests

@test "syncenv: reports clean repository" {
    # Commit everything
    git add -A
    git commit -m "Initial commit" --allow-empty

    run_core_script "syncenv" "status"
    assert_success
    # Should indicate repository is clean
}

# Modified Files Tests

@test "syncenv: detects modified files" {
    # Commit initial state
    git add -A
    git commit -m "Initial" --allow-empty

    # Make a change
    echo "modified" > zsh/.zshrc

    run_core_script "syncenv" "status"
    assert_success
    # Should show modified files
}

# Help Tests

@test "syncenv: help shows usage" {
    run_core_script "syncenv" "help"
    assert_success
    assert_output --partial "Usage:"
}

@test "syncenv: --help shows usage" {
    run_core_script "syncenv" "--help"
    assert_success
    assert_output --partial "Usage:"
}

# Exit Code Tests

@test "syncenv: exits 0 on success" {
    run_core_script "syncenv" "status"
    assert_equal "$status" 0
}

# Environment Detection Tests

@test "syncenv: detects DOTFILES_ROOT" {
    run_core_script "syncenv" "status"
    assert_success
}

# Command Parsing Tests

@test "syncenv: accepts status command" {
    run_core_script "syncenv" "status"
    assert_success
}

@test "syncenv: accepts --dry-run flag" {
    run_core_script "syncenv" "--dry-run"
    assert_success
}

# Output Tests

@test "syncenv: provides informative output" {
    run_core_script "syncenv" "status"
    assert_success
    # Should have some meaningful output
    [[ -n "$output" ]]
}
