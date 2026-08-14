#!/usr/bin/env bats
# Integration tests for the lowercase-directory repository hook.

load '../../helpers/test-helpers'
load '../../helpers/setup-teardown'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'

setup() {
    standard_setup
    export SCRIPT="$(get_dotfiles_root)/bin/git/hooks/check-lowercase-dirs"
    export TEST_REPOSITORY="$TEST_TEMP_DIR/repository"
    mkdir -p "$TEST_REPOSITORY"
}

run_hook() {
    run bash -c 'cd "$1" && "$2"' _ "$TEST_REPOSITORY" "$SCRIPT"
}

@test "check-lowercase-dirs: accepts lowercase directories" {
    mkdir -p "$TEST_REPOSITORY/home/.config/zsh"

    run_hook

    assert_success
}

@test "check-lowercase-dirs: rejects uppercase directories" {
    mkdir -p "$TEST_REPOSITORY/Uppercase/nested"

    run_hook

    assert_failure
    assert_output --partial "Uppercase"
}

@test "check-lowercase-dirs: permits the macOS Library target" {
    mkdir -p "$TEST_REPOSITORY/home-darwin/Library/LaunchAgents"

    run_hook

    assert_success
}

@test "check-lowercase-dirs: handles lowercase paths with spaces" {
    mkdir -p "$TEST_REPOSITORY/lowercase directory/nested path"

    run_hook

    assert_success
}

@test "check-lowercase-dirs: reports an uppercase path with spaces once" {
    mkdir -p "$TEST_REPOSITORY/Uppercase Directory/nested"

    run_hook

    assert_failure
    assert_output --partial "Uppercase Directory"
}
