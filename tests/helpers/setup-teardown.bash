#!/usr/bin/env bash
# Common setup and teardown functions for bats integration tests

# Standard setup for most tests
# Creates isolated test environment with temporary directories
standard_setup() {
    export TEST_TEMP_DIR="$(mktemp -d)"
    export HOME="$TEST_TEMP_DIR/home"
    export XDG_CONFIG_HOME="$HOME/.config"
    export XDG_DATA_HOME="$HOME/.local/share"
    export XDG_CACHE_HOME="$HOME/.cache"

    mkdir -p "$HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_CACHE_HOME"

    # Set up minimal git config
    git config --global user.email "test@example.com"
    git config --global user.name "Test User"
    git config --global init.defaultBranch "main"

    # Disable git hooks during tests
    git config --global core.hooksPath /dev/null
}

# Standard teardown for most tests
# Cleans up temporary directories and restores environment
standard_teardown() {
    if [[ -n "$TEST_TEMP_DIR" ]] && [[ -d "$TEST_TEMP_DIR" ]]; then
        rm -rf "$TEST_TEMP_DIR"
    fi

    # Restore git config
    git config --global --unset user.email 2>/dev/null || true
    git config --global --unset user.name 2>/dev/null || true
    git config --global --unset init.defaultBranch 2>/dev/null || true
    git config --global --unset core.hooksPath 2>/dev/null || true
}

# Setup for git tests
# Creates isolated test environment plus git repository
git_test_setup() {
    standard_setup

    export TEST_REPO_DIR="$TEST_TEMP_DIR/test-repo"
    mkdir -p "$TEST_REPO_DIR"
    cd "$TEST_REPO_DIR" || return 1

    git init
    git config user.email "test@example.com"
    git config user.name "Test User"
    git config init.defaultBranch "main"
}

# Teardown for git tests
git_test_teardown() {
    cd "$TEST_TEMP_DIR" || true
    standard_teardown
}

# Setup for credential tests
# Creates isolated environment with mock keychain
credential_test_setup() {
    standard_setup

    export KEYCHAIN_MOCK="$TEST_TEMP_DIR/mock-keychain"
    mkdir -p "$KEYCHAIN_MOCK"

    # Mock security command for non-macOS or testing without keychain access
    if [[ "$(uname)" != "Darwin" ]]; then
        export PATH="$TEST_TEMP_DIR/bin:$PATH"
        mkdir -p "$TEST_TEMP_DIR/bin"

        cat > "$TEST_TEMP_DIR/bin/security" << 'EOF'
#!/usr/bin/env bash
# Mock security command for testing
case "$1" in
    add-generic-password)
        echo "password has been set"
        ;;
    find-generic-password)
        echo "password"
        ;;
    delete-generic-password)
        echo "password has been deleted"
        ;;
    *)
        echo "mock security: unknown command $1" >&2
        exit 1
        ;;
esac
EOF
        chmod +x "$TEST_TEMP_DIR/bin/security"
    fi
}

# Teardown for credential tests
credential_test_teardown() {
    unset KEYCHAIN_MOCK
    standard_teardown
}

# Setup for workflow tests
# Creates full dotfiles environment with git repo and configs
workflow_test_setup() {
    standard_setup

    export DOTFILES_ROOT="$TEST_TEMP_DIR/dotfiles"
    export TEST_REPO_DIR="$DOTFILES_ROOT"

    mkdir -p "$DOTFILES_ROOT"
    cd "$DOTFILES_ROOT" || return 1

    git init
    git config user.email "test@example.com"
    git config user.name "Test User"
    git config init.defaultBranch "main"

    # Create minimal dotfiles structure
    mkdir -p "$DOTFILES_ROOT/bin/core"
    mkdir -p "$DOTFILES_ROOT/bin/git"
    mkdir -p "$DOTFILES_ROOT/bin/credentials"
    mkdir -p "$DOTFILES_ROOT/zsh"
    mkdir -p "$DOTFILES_ROOT/git"
}

# Teardown for workflow tests
workflow_test_teardown() {
    cd "$TEST_TEMP_DIR" || true
    unset DOTFILES_ROOT
    standard_teardown
}

# Setup for symlink tests
# Creates isolated environment with source and target directories
symlink_test_setup() {
    standard_setup

    export SOURCE_DIR="$TEST_TEMP_DIR/source"
    export TARGET_DIR="$TEST_TEMP_DIR/target"

    mkdir -p "$SOURCE_DIR" "$TARGET_DIR"
}

# Teardown for symlink tests
symlink_test_teardown() {
    unset SOURCE_DIR
    unset TARGET_DIR
    standard_teardown
}

# Setup with fixture copying
# Args: fixture_name [additional_fixtures...]
setup_with_fixtures() {
    standard_setup

    local dotfiles_root
    dotfiles_root="$(cd "${BATS_TEST_DIRNAME}/../.." && pwd)"

    for fixture in "$@"; do
        if [[ -d "$dotfiles_root/tests/fixtures/$fixture" ]]; then
            cp -r "$dotfiles_root/tests/fixtures/$fixture" "$TEST_TEMP_DIR/"
        elif [[ -f "$dotfiles_root/tests/fixtures/$fixture" ]]; then
            cp "$dotfiles_root/tests/fixtures/$fixture" "$TEST_TEMP_DIR/"
        else
            echo "Warning: Fixture not found: $fixture" >&2
        fi
    done
}

# Setup for performance tests
# Records start time and resource usage
performance_test_setup() {
    standard_setup

    export TEST_START_TIME="$(date +%s%N)"

    if command -v /usr/bin/time > /dev/null 2>&1; then
        export TIME_CMD="/usr/bin/time"
    else
        export TIME_CMD="time"
    fi
}

# Teardown for performance tests
# Reports elapsed time
performance_test_teardown() {
    if [[ -n "$TEST_START_TIME" ]]; then
        local end_time
        end_time="$(date +%s%N)"
        local elapsed=$((end_time - TEST_START_TIME))
        local elapsed_ms=$((elapsed / 1000000))
        echo "Test elapsed time: ${elapsed_ms}ms" >&3
    fi

    unset TEST_START_TIME
    unset TIME_CMD
    standard_teardown
}

# Skip test if running in CI
skip_in_ci() {
    local message="${1:-Test not supported in CI environment}"
    if [[ -n "$CI" ]] || [[ -n "$GITHUB_ACTIONS" ]]; then
        skip "$message"
    fi
}

# Skip test if not running in CI
skip_if_not_ci() {
    local message="${1:-Test only runs in CI environment}"
    if [[ -z "$CI" ]] && [[ -z "$GITHUB_ACTIONS" ]]; then
        skip "$message"
    fi
}

# Skip test if running on macOS
skip_on_macos() {
    local message="${1:-Test not supported on macOS}"
    if [[ "$(uname)" == "Darwin" ]]; then
        skip "$message"
    fi
}

# Skip test if running on Linux
skip_on_linux() {
    local message="${1:-Test not supported on Linux}"
    if [[ "$(uname)" == "Linux" ]]; then
        skip "$message"
    fi
}

# Skip test if command not available
skip_if_no_command() {
    local cmd="$1"
    local message="${2:-$cmd not available}"
    if ! command -v "$cmd" > /dev/null 2>&1; then
        skip "$message"
    fi
}

# Assert test completed within time limit
assert_time_limit() {
    local limit_ms="$1"

    if [[ -z "$TEST_START_TIME" ]]; then
        echo "ERROR: TEST_START_TIME not set. Use performance_test_setup()" >&2
        return 1
    fi

    local end_time
    end_time="$(date +%s%N)"
    local elapsed=$((end_time - TEST_START_TIME))
    local elapsed_ms=$((elapsed / 1000000))

    if [[ $elapsed_ms -gt $limit_ms ]]; then
        echo "Test exceeded time limit" >&2
        echo "  Limit: ${limit_ms}ms" >&2
        echo "  Actual: ${elapsed_ms}ms" >&2
        return 1
    fi
}
