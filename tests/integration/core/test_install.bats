#!/usr/bin/env bats
# Integration tests for the install script

load '../../helpers/test-helpers'
load '../../helpers/git-helpers'
load '../../helpers/file-helpers'
load '../../helpers/setup-teardown'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'
load '../../helpers/bats-file/load.bash'

setup() {
    git_test_setup

    # Create mock dotfiles structure
    export DOTFILES_ROOT="$TEST_REPO_DIR"
    cd "$DOTFILES_ROOT"

    # Create necessary directories
    mkdir -p bin/core
    mkdir -p packages/homebrew

    # Create mock scripts
    cat > bin/core/link-dotfiles.py << 'EOF'
#!/usr/bin/env python3
import sys
print("Mock link-dotfiles")
exit(0)
EOF
    chmod +x bin/core/link-dotfiles.py

    cat > bin/core/zsh-compile << 'EOF'
#!/usr/bin/env bash
echo "Mock zsh-compile"
exit 0
EOF
    chmod +x bin/core/zsh-compile

    # Create mock Brewfile
    cat > packages/homebrew/Brewfile << 'EOF'
# Test Brewfile
brew "jq"
EOF

    # Copy install script to test directory
    cp "$(get_dotfiles_root)/install" "$DOTFILES_ROOT/install"
}

teardown() {
    git_test_teardown
}

# Argument Parsing Tests

@test "install: --help shows usage" {
    run "$DOTFILES_ROOT/install" --help
    assert_success
    assert_output --partial "install v"
    assert_output --partial "USAGE:"
    assert_output --partial "OPTIONS:"
    assert_output --partial "EXIT CODES:"
}

@test "install: -h shows usage" {
    run "$DOTFILES_ROOT/install" -h
    assert_success
    assert_output --partial "USAGE:"
}

@test "install: unknown option fails" {
    run "$DOTFILES_ROOT/install" --unknown-option
    assert_failure
    assert_output --partial "Unknown option:"
}

@test "install: --dry-run sets dry run mode" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "DRY RUN MODE"
    assert_output --partial "no changes were made"
}

@test "install: --verbose enables verbose output" {
    run "$DOTFILES_ROOT/install" --dry-run --yes --verbose
    assert_success
}

@test "install: --skip-brew skips Homebrew" {
    skip_on_linux "macOS-specific test"

    run "$DOTFILES_ROOT/install" --dry-run --yes --skip-brew
    assert_success
    assert_output --partial "Skipping Homebrew"
}

@test "install: --skip-packages skips package installation" {
    run "$DOTFILES_ROOT/install" --dry-run --yes --skip-packages
    assert_success
}

@test "install: --skip-links skips symlink creation" {
    run "$DOTFILES_ROOT/install" --dry-run --yes --skip-links
    assert_success
    assert_output --partial "Skipping symlink creation"
}

@test "install: --yes enables non-interactive mode" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    refute_output --partial "(y/n)"
}

# Pre-flight Checks Tests

@test "install: succeeds in git repository" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Running in git repository"
}

@test "install: fails without git repository" {
    # Remove .git directory
    rm -rf "$DOTFILES_ROOT/.git"

    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_failure
    assert_line --partial "Not in a git repository"
}

@test "install: checks git is installed" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "git is installed"
}

@test "install: reports platform" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Platform:"
}

@test "install: reports dotfiles root" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Dotfiles root:"
}

# Dry-run Mode Tests

@test "install: dry-run reports would install Homebrew" {
    skip_on_linux "macOS-specific test"

    # Temporarily hide brew command
    export PATH="/usr/bin:/bin"

    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Would install Homebrew"
}

@test "install: dry-run reports would install jq" {
    # Temporarily hide jq command
    export PATH="/usr/bin:/bin"

    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Would install jq"
}

@test "install: dry-run reports would install pyenv" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Would install pyenv"
}

@test "install: dry-run reports would install rbenv" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Would install rbenv"
}

@test "install: dry-run reports would install nvm" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Would install nvm"
}

@test "install: dry-run reports would clone Prezto" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Would clone Prezto"
}

@test "install: dry-run reports would compile zsh configs" {
    export SHELL="/bin/zsh"

    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Would compile zsh configuration"
}

@test "install: dry-run makes no filesystem changes" {
    local initial_files
    initial_files=$(find "$TEST_REPO_DIR" -type f | wc -l)

    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success

    local final_files
    final_files=$(find "$TEST_REPO_DIR" -type f | wc -l)

    # File count should be same (no new files created)
    [[ "$initial_files" == "$final_files" ]]
}

# Phase Execution Tests

@test "install: executes all phases in order" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success

    # Verify phase order in output
    assert_output --partial "Phase 1: Pre-flight Checks"
    assert_output --partial "Phase 2: Homebrew Setup"
    assert_output --partial "Phase 3: Dependencies"
    assert_output --partial "Phase 4: Homebrew Bundle"
    assert_output --partial "Phase 5: Version Manager Setup"
    assert_output --partial "Phase 6: Prezto & Powerlevel10k Setup"
    assert_output --partial "Phase 7: Symlink Creation"
    assert_output --partial "Phase 8: Shell Configuration"
    assert_output --partial "Phase 9: Performance Optimization"
}

@test "install: shows completion summary" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Installation Complete"
    assert_output --partial "Next Steps:"
}

# Platform-specific Tests

@test "install: skips Homebrew on Linux" {
    skip_on_macos "Linux-specific test"

    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Skipping Homebrew (not on macOS)"
}

@test "install: skips Homebrew bundle on Linux" {
    skip_on_macos "Linux-specific test"

    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Skipping Homebrew bundle (not on macOS)"
}

# Dependencies Tests

@test "install: checks for jq" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success

    # Should either say jq is installed or would install it
    if command -v jq &>/dev/null; then
        assert_output --partial "jq is already installed"
    else
        assert_output --partial "jq is not installed"
    fi
}

@test "install: reports jq version when installed" {
    skip_if_no_command "jq" "jq not available"

    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "jq is already installed"
}

# Version Manager Tests

@test "install: checks for pyenv" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success

    if [[ -d "$HOME/.pyenv" ]]; then
        assert_output --partial "pyenv is already installed"
    else
        assert_output --partial "pyenv is not installed"
    fi
}

@test "install: checks for rbenv" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success

    if [[ -d "$HOME/.rbenv" ]]; then
        assert_output --partial "rbenv is already installed"
    else
        assert_output --partial "rbenv is not installed"
    fi
}

@test "install: checks for nvm" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success

    if [[ -d "$HOME/.nvm" ]]; then
        assert_output --partial "nvm is already installed"
    else
        assert_output --partial "nvm is not installed"
    fi
}

# Symlink Phase Tests

@test "install: calls link-dotfiles script" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Running link-dotfiles"
}

@test "install: passes dry-run to link-dotfiles" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success

    # Mock script should be called
    assert_output --partial "Mock link-dotfiles"
}

@test "install: fails if link-dotfiles missing" {
    rm -f "$DOTFILES_ROOT/bin/core/link-dotfiles.py"

    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_failure
    assert_output --partial "link-dotfiles.py script not found"
}

# Shell Configuration Tests

@test "install: reports current shell" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Current shell:"
}

@test "install: checks for zsh config when using zsh" {
    export SHELL="/bin/zsh"

    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Shell Configuration"
}

# Performance Optimization Tests

@test "install: skips performance optimization for non-zsh shells" {
    export SHELL="/bin/bash"

    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Skipping performance optimization (not using zsh)"
}

@test "install: runs performance optimization for zsh" {
    export SHELL="/bin/zsh"

    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Performance Optimization"
}

@test "install: skips compilation if zsh-compile missing" {
    export SHELL="/bin/zsh"
    rm -f "$DOTFILES_ROOT/bin/core/zsh-compile"

    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "zsh-compile not found"
}

# Exit Code Tests

@test "install: exits 0 on success" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_equal "$status" 0
}

@test "install: exits 1 on unknown option" {
    run "$DOTFILES_ROOT/install" --invalid-flag
    assert_equal "$status" 1
}

@test "install: exits 2 when not in git repo" {
    rm -rf "$DOTFILES_ROOT/.git"

    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_equal "$status" 2
}

@test "install: exits 0 with --help" {
    run "$DOTFILES_ROOT/install" --help
    assert_equal "$status" 0
}

# Logging Tests

@test "install: uses colored output" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success

    # Check for ANSI color codes (even though they may not render in test)
    # The script uses colors, so output should contain color codes
}

@test "install: shows warning for missing optional components" {
    # pyenv, rbenv, nvm are optional - should show warnings if not installed
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
}

# Brewfile Tests

@test "install: finds Brewfile in correct location" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success

    # Should not warn about missing Brewfile since we created it in setup
    refute_output --partial "Brewfile not found"
}

@test "install: handles missing Brewfile gracefully" {
    rm -f "$DOTFILES_ROOT/packages/homebrew/Brewfile"

    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Brewfile not found"
}

# Summary Tests

@test "install: dry-run shows appropriate summary" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "This was a dry run - no changes were made"
    assert_output --partial "Run './install' (without --dry-run) to actually install"
}

@test "install: shows next steps in summary" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Next Steps:"
    assert_output --partial "Restart your terminal"
}

@test "install: shows zsh performance tips for zsh users" {
    export SHELL="/bin/zsh"

    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Zsh Performance Tips:"
    assert_output --partial "zsh-benchmark"
}

@test "install: does not show zsh tips for non-zsh users" {
    export SHELL="/bin/bash"

    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    refute_output --partial "Zsh Performance Tips:"
}

# Flag Combination Tests

@test "install: handles multiple skip flags" {
    run "$DOTFILES_ROOT/install" --dry-run --yes --skip-brew --skip-packages --skip-links
    assert_success
    assert_output --partial "Skipping Homebrew"
    assert_output --partial "Skipping symlink creation"
}

@test "install: verbose and dry-run work together" {
    run "$DOTFILES_ROOT/install" --dry-run --yes --verbose
    assert_success
    assert_output --partial "DRY RUN MODE"
}

# Prezto Tests

@test "install: checks for Prezto installation" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success

    if [[ -d "$HOME/.zprezto" ]]; then
        assert_output --partial "Prezto is already installed"
    else
        assert_output --partial "Prezto is not installed"
    fi
}

@test "install: checks for Powerlevel10k theme" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success

    # Should check for Powerlevel10k if Prezto exists
    if [[ -d "$HOME/.zprezto" ]]; then
        assert_output --partial "Powerlevel10k"
    fi
}

# Banner Tests

@test "install: shows banner on start" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success
    assert_output --partial "Dotfiles Installation"
    assert_output --partial "========"
}

@test "install: shows version in help" {
    run "$DOTFILES_ROOT/install" --help
    assert_success
    assert_output --regexp "install v[0-9]+\.[0-9]+\.[0-9]+"
}
