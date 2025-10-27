#!/usr/bin/env bash
# Core test helper functions for bats integration tests

# Get the dotfiles root directory
get_dotfiles_root() {
    echo "${BATS_TEST_DIRNAME}/../.."
}

# Run a script from bin/core/
run_core_script() {
    local script="$1"
    shift
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"
    run "$dotfiles_root/bin/core/$script" "$@"
}

# Run a script from bin/git/
run_git_script() {
    local script="$1"
    shift
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"
    run "$dotfiles_root/bin/git/$script" "$@"
}

# Run a script from bin/credentials/
run_cred_script() {
    local script="$1"
    shift
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"
    run "$dotfiles_root/bin/credentials/$script" "$@"
}

# Assert script succeeded with expected output
assert_script_success() {
    local expected_output="$1"
    assert_success
    if [[ -n "$expected_output" ]]; then
        assert_output --partial "$expected_output"
    fi
}

# Assert script failed with expected error
assert_script_failure() {
    local expected_error="$1"
    assert_failure
    if [[ -n "$expected_error" ]]; then
        assert_output --partial "$expected_error"
    fi
}

# Create isolated test environment
create_test_env() {
    export TEST_TEMP_DIR="$(mktemp -d)"
    export HOME="$TEST_TEMP_DIR/home"
    export XDG_CONFIG_HOME="$HOME/.config"
    mkdir -p "$HOME" "$XDG_CONFIG_HOME"

    # Set up minimal git config
    git config --global user.email "test@example.com"
    git config --global user.name "Test User"
    git config --global init.defaultBranch "main"
}

# Clean up test environment
cleanup_test_env() {
    if [[ -n "$TEST_TEMP_DIR" ]] && [[ -d "$TEST_TEMP_DIR" ]]; then
        rm -rf "$TEST_TEMP_DIR"
    fi
}

# Copy fixture to test directory
copy_fixture() {
    local fixture_name="$1"
    local destination="${2:-$TEST_TEMP_DIR}"
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    cp -r "$dotfiles_root/tests/fixtures/$fixture_name" "$destination/"
}

# Create empty directory
create_empty_dir() {
    local dir_path="$1"
    mkdir -p "$dir_path"
}

# Assert directory exists
assert_dir_exists() {
    local dir_path="$1"
    [[ -d "$dir_path" ]] || {
        echo "Directory does not exist: $dir_path" >&2
        return 1
    }
}

# Assert file exists
assert_file_exists() {
    local file_path="$1"
    [[ -f "$file_path" ]] || {
        echo "File does not exist: $file_path" >&2
        return 1
    }
}

# Assert file contains text
assert_file_contains() {
    local file_path="$1"
    local expected_text="$2"
    grep -q "$expected_text" "$file_path" || {
        echo "File does not contain expected text: $expected_text" >&2
        echo "File contents:" >&2
        cat "$file_path" >&2
        return 1
    }
}

# Assert command exists in PATH
assert_command_exists() {
    local command="$1"
    command -v "$command" > /dev/null 2>&1 || {
        echo "Command not found in PATH: $command" >&2
        return 1
    }
}

# Skip test if command not available
skip_if_missing() {
    local command="$1"
    local message="${2:-$command not available}"
    if ! command -v "$command" > /dev/null 2>&1; then
        skip "$message"
    fi
}

# Skip test on specific platform
skip_on_platform() {
    local platform="$1"
    local message="${2:-Test not supported on $platform}"
    if [[ "$OSTYPE" == "$platform"* ]]; then
        skip "$message"
    fi
}

# Get current platform
get_platform() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "darwin"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
}

# Assert platform is darwin (macOS)
assert_macos() {
    [[ "$(get_platform)" == "darwin" ]] || {
        echo "Test requires macOS" >&2
        return 1
    }
}

# Assert platform is linux
assert_linux() {
    [[ "$(get_platform)" == "linux" ]] || {
        echo "Test requires Linux" >&2
        return 1
    }
}

# Wait for condition with timeout
wait_for() {
    local condition="$1"
    local timeout="${2:-10}"
    local interval="${3:-1}"
    local elapsed=0

    while ! eval "$condition" > /dev/null 2>&1; do
        sleep "$interval"
        elapsed=$((elapsed + interval))
        if [[ $elapsed -ge $timeout ]]; then
            echo "Timeout waiting for condition: $condition" >&2
            return 1
        fi
    done
}
