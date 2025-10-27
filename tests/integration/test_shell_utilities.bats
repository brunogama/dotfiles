#!/usr/bin/env bats
# Integration tests for shell and environment utilities

load '../helpers/test_helper'

@test "syncenv: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/syncenv"
    run test -x "${PROJECT_ROOT}/bin/core/syncenv"
    assert_success
}

@test "reload-shell: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/reload-shell"
    run test -x "${PROJECT_ROOT}/bin/core/reload-shell"
    assert_success
}

@test "update-dotfiles: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/update-dotfiles"
    run test -x "${PROJECT_ROOT}/bin/core/update-dotfiles"
    assert_success
}

@test "update-dotfiles-scripts: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/update-dotfiles-scripts"
    run test -x "${PROJECT_ROOT}/bin/core/update-dotfiles-scripts"
    assert_success
}

@test "setup-git-hooks: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/setup-git-hooks"
    run test -x "${PROJECT_ROOT}/bin/core/setup-git-hooks"
    assert_success
}

@test "remove-all-emojis: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/remove-all-emojis"
    run test -x "${PROJECT_ROOT}/bin/core/remove-all-emojis"
    assert_success
}

@test "cm (alias): script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/cm"
    run test -x "${PROJECT_ROOT}/bin/core/cm"
    assert_success
}

@test "co (alias): script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/co"
    run test -x "${PROJECT_ROOT}/bin/core/co"
    assert_success
}

@test "e (alias): script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/e"
    run test -x "${PROJECT_ROOT}/bin/core/e"
    assert_success
}

@test "g (alias): script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/g"
    run test -x "${PROJECT_ROOT}/bin/core/g"
    assert_success
}

@test "n (alias): script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/n"
    run test -x "${PROJECT_ROOT}/bin/core/n"
    assert_success
}

@test "o (alias): script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/o"
    run test -x "${PROJECT_ROOT}/bin/core/o"
    assert_success
}

@test "p (alias): script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/p"
    run test -x "${PROJECT_ROOT}/bin/core/p"
    assert_success
}

@test "r (alias): script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/r"
    run test -x "${PROJECT_ROOT}/bin/core/r"
    assert_success
}
