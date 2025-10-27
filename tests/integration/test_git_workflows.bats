#!/usr/bin/env bats
# Integration tests for git workflow utilities

load '../helpers/test_helper'

@test "git-wip: script exists and is executable" {
    # Verify the script exists
    assert_file_exists "${PROJECT_ROOT}/bin/git/git-wip.sh"

    # Verify it's executable
    run test -x "${PROJECT_ROOT}/bin/git/git-wip.sh"
    assert_success
}

@test "git-save-all: script exists and is executable" {
    # Verify the script exists
    assert_file_exists "${PROJECT_ROOT}/bin/git/git-save-all.sh"

    # Verify it's executable
    run test -x "${PROJECT_ROOT}/bin/git/git-save-all.sh"
    assert_success
}

@test "conventional-commit: script exists and is executable" {
    # Verify the script exists (using git-conventional-commit.sh which exists)
    assert_file_exists "${PROJECT_ROOT}/bin/git/git-conventional-commit.sh"

    # Verify it's executable
    run test -x "${PROJECT_ROOT}/bin/git/git-conventional-commit.sh"
    assert_success
}

@test "git-smart-merge: script exists and is executable" {
    # Verify the script exists
    assert_file_exists "${PROJECT_ROOT}/bin/git/git-smart-merge"

    # Verify it's executable
    run test -x "${PROJECT_ROOT}/bin/git/git-smart-merge"
    assert_success
}

@test "git-restore-last-savepoint: script exists and is executable" {
    # Verify the script exists
    assert_file_exists "${PROJECT_ROOT}/bin/git/git-restore-last-savepoint.sh"

    # Verify it's executable
    run test -x "${PROJECT_ROOT}/bin/git/git-restore-last-savepoint.sh"
    assert_success
}
