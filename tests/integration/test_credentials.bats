#!/usr/bin/env bats
# Integration tests for credential management utilities

load '../helpers/test_helper'

@test "store-api-key: script exists and is executable" {
    # Verify the script exists
    assert_file_exists "${PROJECT_ROOT}/bin/credentials/store-api-key"

    # Verify it's executable
    run test -x "${PROJECT_ROOT}/bin/credentials/store-api-key"
    assert_success
}

@test "get-api-key: script exists and is executable" {
    # Verify the script exists
    assert_file_exists "${PROJECT_ROOT}/bin/credentials/get-api-key"

    # Verify it's executable
    run test -x "${PROJECT_ROOT}/bin/credentials/get-api-key"
    assert_success
}

@test "credmatch: script exists and is executable" {
    # Verify the script exists
    assert_file_exists "${PROJECT_ROOT}/bin/credentials/credmatch"

    # Verify it's executable
    run test -x "${PROJECT_ROOT}/bin/credentials/credmatch"
    assert_success
}

@test "credfile: script exists and is executable" {
    # Verify the script exists
    assert_file_exists "${PROJECT_ROOT}/bin/credentials/credfile"

    # Verify it's executable
    run test -x "${PROJECT_ROOT}/bin/credentials/credfile"
    assert_success
}

@test "dump-api-keys: script exists and is executable" {
    # Verify the script exists
    assert_file_exists "${PROJECT_ROOT}/bin/credentials/dump-api-keys"

    # Verify it's executable
    run test -x "${PROJECT_ROOT}/bin/credentials/dump-api-keys"
    assert_success
}

@test "clear-secret-history: script exists and is executable" {
    # Verify the script exists
    assert_file_exists "${PROJECT_ROOT}/bin/credentials/clear-secret-history"

    # Verify it's executable
    run test -x "${PROJECT_ROOT}/bin/credentials/clear-secret-history"
    assert_success
}
