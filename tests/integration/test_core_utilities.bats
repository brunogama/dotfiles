#!/usr/bin/env bats
# Integration tests for core utility scripts

load '../helpers/test_helper'

@test "link-dotfiles.py: script exists and is executable" {
    # Verify the script exists
    assert_file_exists "${PROJECT_ROOT}/bin/core/link-dotfiles.py"

    # Verify it's executable
    run test -x "${PROJECT_ROOT}/bin/core/link-dotfiles.py"
    assert_success
}

@test "link-dotfiles.py: shows help with --help flag" {
    skip_if_not_installed python3

    # Run with --help flag
    run python3 "${PROJECT_ROOT}/bin/core/link-dotfiles.py" --help

    # Verify it shows help
    assert_success
    assert_output --partial "usage"
}

@test "home-sync: script exists and is executable" {
    # Verify the script exists
    assert_file_exists "${PROJECT_ROOT}/bin/core/home-sync"

    # Verify it's executable
    run test -x "${PROJECT_ROOT}/bin/core/home-sync"
    assert_success
}

@test "dotfiles-help: script exists and is executable" {
    # Verify the script exists
    assert_file_exists "${PROJECT_ROOT}/bin/core/dotfiles-help"

    # Verify it's executable
    run test -x "${PROJECT_ROOT}/bin/core/dotfiles-help"
    assert_success
}

@test "check-dependency: script exists and is executable" {
    # Verify the script exists
    assert_file_exists "${PROJECT_ROOT}/bin/core/check-dependency"

    # Verify it's executable
    run test -x "${PROJECT_ROOT}/bin/core/check-dependency"
    assert_success
}
