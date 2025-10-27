#!/usr/bin/env bats
# Integration tests for additional utility scripts

load '../helpers/test_helper'

@test "createproject: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/createproject"
    run test -x "${PROJECT_ROOT}/bin/core/createproject"
    assert_success
}

@test "path-lookup: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/path-lookup"
    run test -x "${PROJECT_ROOT}/bin/core/path-lookup"
    assert_success
}

@test "prints: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/prints"
    run test -x "${PROJECT_ROOT}/bin/core/prints"
    assert_success
}

@test "dead-code: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/dead-code"
    run test -x "${PROJECT_ROOT}/bin/core/dead-code"
    assert_success
}

@test "markdown_clipper: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/markdown_clipper"
    run test -x "${PROJECT_ROOT}/bin/core/markdown_clipper"
    assert_success
}

@test "home-sync-service: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/home-sync-service"
    run test -x "${PROJECT_ROOT}/bin/core/home-sync-service"
    assert_success
}

@test "branches-current-branch: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/branches-current-branch"
    run test -x "${PROJECT_ROOT}/bin/core/branches-current-branch"
    assert_success
}

@test "open-xcode-with-flags: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/core/open-xcode-with-flags"
    run test -x "${PROJECT_ROOT}/bin/core/open-xcode-with-flags"
    assert_success
}
