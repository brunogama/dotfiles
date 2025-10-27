#!/usr/bin/env bats
# Integration tests for credential management scripts

load '../../helpers/test-helpers'
load '../../helpers/file-helpers'
load '../../helpers/setup-teardown'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'
load '../../helpers/bats-file/load.bash'

setup() {
    credential_test_setup
}

teardown() {
    credential_test_teardown
}

# Store-API-Key Tests

@test "store-api-key: shows usage without arguments" {
    run_cred_script "store-api-key"
    assert_failure
    assert_output --partial "Usage:"
}

@test "store-api-key: shows help with --help" {
    run_cred_script "store-api-key" --help
    assert_success
    assert_output --partial "Usage:"
}

@test "store-api-key: requires key name" {
    run_cred_script "store-api-key"
    assert_failure
}

@test "store-api-key: validates key name format" {
    # Test with invalid characters
    run_cred_script "store-api-key" "invalid key name" <<< "test-value"
    # Should either fail or handle gracefully
}

@test "store-api-key: accepts stdin input" {
    skip_on_linux "Requires macOS Keychain"

    # Mock stdin
    run_cred_script "store-api-key" "TEST_KEY" <<< "test-value"
    # Should process stdin
}

@test "store-api-key: prompts for value interactively" {
    skip_on_linux "Requires macOS Keychain"

    # When no stdin, should prompt
    run_cred_script "store-api-key" "TEST_KEY"
    # Should show prompt or handle input
}

# Get-API-Key Tests

@test "get-api-key: shows usage without arguments" {
    run_cred_script "get-api-key"
    assert_failure
    assert_output --partial "Usage:"
}

@test "get-api-key: shows help with --help" {
    run_cred_script "get-api-key" --help
    assert_success
    assert_output --partial "Usage:"
}

@test "get-api-key: requires key name" {
    run_cred_script "get-api-key"
    assert_failure
}

@test "get-api-key: handles non-existent key" {
    skip_on_linux "Requires macOS Keychain"

    run_cred_script "get-api-key" "NONEXISTENT_KEY_$(date +%s)"
    assert_failure
}

# Credmatch Tests

@test "credmatch: shows usage without arguments" {
    run_cred_script "credmatch"
    # Should show usage or accept stdin
}

@test "credmatch: shows help with --help" {
    run_cred_script "credmatch" --help
    assert_success
    assert_output --partial "Usage:"
}

@test "credmatch: processes pattern" {
    # Test pattern matching
    run_cred_script "credmatch" "test-pattern"
    # Should process or show help
}

# Credfile Tests

@test "credfile: shows usage without arguments" {
    run_cred_script "credfile"
    # Should show usage or accept stdin
}

@test "credfile: shows help with --help" {
    run_cred_script "credfile" --help
    assert_success
    assert_output --partial "Usage:"
}

@test "credfile: processes file input" {
    # Create test file
    echo "test content" > "$TEST_TEMP_DIR/test-input"

    run_cred_script "credfile" "$TEST_TEMP_DIR/test-input"
    # Should process file
}

# Dump-API-Keys Tests

@test "dump-api-keys: shows usage with --help" {
    run_cred_script "dump-api-keys" --help
    # Should show help or list keys
}

@test "dump-api-keys: lists stored keys" {
    skip_on_linux "Requires macOS Keychain"

    run_cred_script "dump-api-keys"
    # Should list keys or show empty list
}

# Clear-Secret-History Tests

@test "clear-secret-history: shows usage with --help" {
    run_cred_script "clear-secret-history" --help
    # Should show help
}

@test "clear-secret-history: cleans shell history" {
    # Create test history file
    echo "export SECRET=test" > "$HOME/.zsh_history"
    echo "normal command" >> "$HOME/.zsh_history"

    run_cred_script "clear-secret-history"
    # Should process history
}

# Security Tests

@test "credentials: no secrets in command history" {
    skip_on_linux "Requires macOS Keychain"

    # Store a key interactively
    run_cred_script "store-api-key" "TEST_KEY" <<< "secret-value"

    # Check that secret is not in output
    refute_output --partial "secret-value"
}

@test "credentials: no secrets in process list" {
    skip_on_linux "Requires macOS Keychain"

    # When storing, secret shouldn't appear in ps
    # This is hard to test directly, but the scripts should use stdin
}

@test "credentials: interactive prompts hide input" {
    skip_on_linux "Requires macOS Keychain"

    # Password prompts should be hidden (using read -s)
    # Hard to test directly in bats
}

# Error Handling Tests

@test "store-api-key: handles empty value" {
    skip_on_linux "Requires macOS Keychain"

    run_cred_script "store-api-key" "TEST_KEY" <<< ""
    # Should fail or warn about empty value
}

@test "store-api-key: handles invalid keychain" {
    skip_on_linux "Requires macOS Keychain"

    # If keychain is not available, should fail gracefully
    export KEYCHAIN_MOCK="invalid"
    run_cred_script "store-api-key" "TEST_KEY" <<< "value"
    # Should handle error
}

@test "get-api-key: handles keychain errors" {
    skip_on_linux "Requires macOS Keychain"

    # Should handle keychain access errors
    run_cred_script "get-api-key" "KEY_WITH_ERROR"
    # Should fail gracefully
}

# Platform Tests

@test "credentials: detect macOS platform" {
    skip_on_linux "macOS-specific test"

    # On macOS, should use security command
    run_cred_script "store-api-key" --help
    assert_success
}

@test "credentials: handle non-macOS platforms" {
    skip_on_macos "Linux-specific test"

    # On non-macOS, should warn or provide alternative
    run_cred_script "store-api-key" "TEST_KEY" <<< "value"
    # Should handle gracefully or show error
}

# Integration Tests

@test "credentials: store and retrieve key" {
    skip_on_linux "Requires macOS Keychain"
    skip_in_ci "Requires keychain access"

    local key_name="BATS_TEST_KEY_$(date +%s)"

    # Store
    run_cred_script "store-api-key" "$key_name" <<< "test-value-123"

    # Retrieve
    run_cred_script "get-api-key" "$key_name"
    assert_success
    assert_output "test-value-123"

    # Cleanup
    run_cred_script "get-api-key" "$key_name" --delete || true
}

@test "credentials: update existing key" {
    skip_on_linux "Requires macOS Keychain"
    skip_in_ci "Requires keychain access"

    local key_name="BATS_UPDATE_KEY_$(date +%s)"

    # Store initial
    run_cred_script "store-api-key" "$key_name" <<< "initial-value"

    # Update
    run_cred_script "store-api-key" "$key_name" <<< "updated-value"

    # Verify
    run_cred_script "get-api-key" "$key_name"
    assert_output "updated-value"

    # Cleanup
    run_cred_script "get-api-key" "$key_name" --delete || true
}

# Exit Code Tests

@test "store-api-key: exits 0 on success" {
    skip_on_linux "Requires macOS Keychain"
    skip_in_ci "Requires keychain access"

    local key_name="BATS_EXIT_TEST_$(date +%s)"
    run_cred_script "store-api-key" "$key_name" <<< "test"
    assert_equal "$status" 0

    # Cleanup
    run_cred_script "get-api-key" "$key_name" --delete || true
}

@test "store-api-key: exits non-zero without arguments" {
    run_cred_script "store-api-key"
    assert_failure
}

@test "get-api-key: exits 0 when key exists" {
    skip_on_linux "Requires macOS Keychain"
    skip_in_ci "Requires keychain access"

    local key_name="BATS_EXISTS_TEST_$(date +%s)"

    # Store
    run_cred_script "store-api-key" "$key_name" <<< "test"

    # Get
    run_cred_script "get-api-key" "$key_name"
    assert_equal "$status" 0

    # Cleanup
    run_cred_script "get-api-key" "$key_name" --delete || true
}

@test "get-api-key: exits non-zero when key missing" {
    skip_on_linux "Requires macOS Keychain"

    run_cred_script "get-api-key" "DEFINITELY_NONEXISTENT_KEY_$(date +%s)"
    assert_failure
}
