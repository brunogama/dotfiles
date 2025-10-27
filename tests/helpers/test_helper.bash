#!/usr/bin/env bash
# Common test utilities and setup for bats integration tests

# Load bats libraries
load '../libs/bats-support/load'
load '../libs/bats-assert/load'

# Test environment variables
export TEST_TEMP_DIR="${BATS_TEST_TMPDIR}/dotfiles-test"
export TEST_HOME="${TEST_TEMP_DIR}/home"
export TEST_DOTFILES="${TEST_TEMP_DIR}/dotfiles"

# Project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
export PROJECT_ROOT

# Add bin directories to PATH for testing
export PATH="${PROJECT_ROOT}/bin/core:${PROJECT_ROOT}/bin/git:${PROJECT_ROOT}/bin/credentials:${PATH}"

# Setup function called before each test
setup() {
    # Create isolated test environment
    mkdir -p "${TEST_HOME}"
    mkdir -p "${TEST_DOTFILES}"

    # Set HOME to test directory
    export HOME="${TEST_HOME}"
    export DOTFILES="${TEST_DOTFILES}"
}

# Teardown function called after each test
teardown() {
    # Clean up test environment
    if [[ -d "${TEST_TEMP_DIR}" ]]; then
        rm -rf "${TEST_TEMP_DIR}"
    fi
}

# Helper: Create a test file with content
create_test_file() {
    local file_path="$1"
    local content="$2"

    mkdir -p "$(dirname "${file_path}")"
    echo "${content}" > "${file_path}"
}

# Helper: Assert file exists
assert_file_exists() {
    local file_path="$1"
    [[ -f "${file_path}" ]] || [[ -L "${file_path}" ]]
}

# Helper: Assert file does not exist
assert_file_not_exists() {
    local file_path="$1"
    [[ ! -f "${file_path}" ]] && [[ ! -L "${file_path}" ]]
}

# Helper: Assert symlink points to target
assert_symlink_to() {
    local link_path="$1"
    local target_path="$2"

    [[ -L "${link_path}" ]] || return 1
    local actual_target
    actual_target="$(readlink "${link_path}")"
    [[ "${actual_target}" == "${target_path}" ]]
}

# Helper: Mock git user config for tests
setup_git_user() {
    git config --global user.name "Test User"
    git config --global user.email "test@example.com"
}

# Helper: Create a test git repository
create_test_repo() {
    local repo_path="$1"

    mkdir -p "${repo_path}"
    cd "${repo_path}" || return 1
    git init
    git config user.name "Test User"
    git config user.email "test@example.com"
    cd - > /dev/null || return 1
}

# Helper: Skip test if command not available
skip_if_not_installed() {
    local command="$1"
    if ! command -v "${command}" &> /dev/null; then
        skip "${command} is not installed"
    fi
}

# Helper: Run command and capture output
run_with_timeout() {
    local timeout_seconds="$1"
    shift
    timeout "${timeout_seconds}s" "$@"
}
