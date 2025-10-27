#!/usr/bin/env bats
# Integration tests for additional git utilities

load '../helpers/test_helper'

@test "git-reword: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/git/git-reword"
    run test -x "${PROJECT_ROOT}/bin/git/git-reword"
    assert_success
}

@test "git-virtual-worktree: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/git/git-virtual-worktree"
    run test -x "${PROJECT_ROOT}/bin/git/git-virtual-worktree"
    assert_success
}

@test "git-worktree: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/git/git-worktree"
    run test -x "${PROJECT_ROOT}/bin/git/git-worktree"
    assert_success
}

@test "git-vw-interactive: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/git/git-vw-interactive"
    run test -x "${PROJECT_ROOT}/bin/git/git-vw-interactive"
    assert_success
}

@test "git-wt-interactive: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/git/git-wt-interactive"
    run test -x "${PROJECT_ROOT}/bin/git/git-wt-interactive"
    assert_success
}

@test "git-restore-wip.sh: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/git/git-restore-wip.sh"
    run test -x "${PROJECT_ROOT}/bin/git/git-restore-wip.sh"
    assert_success
}

@test "git-restore-wip-all.sh: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/git/git-restore-wip-all.sh"
    run test -x "${PROJECT_ROOT}/bin/git/git-restore-wip-all.sh"
    assert_success
}

@test "install-all-git-hooks.sh: script exists and is executable" {
    assert_file_exists "${PROJECT_ROOT}/bin/git/install-all-git-hooks.sh"
    run test -x "${PROJECT_ROOT}/bin/git/install-all-git-hooks.sh"
    assert_success
}
