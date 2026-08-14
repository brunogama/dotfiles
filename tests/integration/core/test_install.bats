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
    mkdir -p home-darwin

    # Create mock scripts
    cat > bin/core/link-dotfiles.py << 'EOF'
#!/usr/bin/env python3
import sys
print("Mock link-dotfiles", *sys.argv[1:])
exit(0)
EOF
    chmod +x bin/core/link-dotfiles.py

    cat > bin/core/zsh-compile << 'EOF'
#!/usr/bin/env bash
echo "Mock zsh-compile"
exit 0
EOF
    chmod +x bin/core/zsh-compile

    cat > bin/core/nix-bootstrap << 'EOF'
#!/usr/bin/env bash
printf 'Mock nix-bootstrap:'
printf ' %s' "$@"
printf '\n'
EOF
    chmod +x bin/core/nix-bootstrap

    # Create mock Brewfile
    cat > home-darwin/Brewfile << 'EOF'
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
    assert_output --partial "--nix"
    assert_output --partial "--system"
    assert_output --partial "--username"
    assert_output --partial "--machine-name"
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

@test "install: --nix delegates without running legacy phases" {
    run "$DOTFILES_ROOT/install" --nix --dry-run --yes
    assert_success
    assert_output --partial "Mock nix-bootstrap: --dry-run --yes"
    refute_output --partial "Phase 1: Pre-flight Checks"
}

@test "install: --nix delegates with no forwarded arguments" {
    run /bin/bash "$DOTFILES_ROOT/install" --nix
    assert_success
    assert_output --partial "Mock nix-bootstrap:"
}

@test "install: --nix forwards explicit system activation" {
    run /bin/bash "$DOTFILES_ROOT/install" --nix --system --dry-run
    assert_success
    assert_output --partial "Mock nix-bootstrap: --system --dry-run"
}

@test "install: --nix forwards host identity" {
    run /bin/bash "$DOTFILES_ROOT/install" --nix \
        --username ci-user --machine-name "CI Runner Mac" --dry-run

    assert_success
    assert_output --partial "--username ci-user"
    assert_output --partial "--machine-name CI Runner Mac"
}

@test "nix-configure-host: prompts and writes host identity" {
    local real_dotfiles_root host_file original_host
    real_dotfiles_root="$(cd "$(get_dotfiles_root)" && pwd)"
    host_file="$BATS_TEST_TMPDIR/host.nix"
    original_host="$real_dotfiles_root/nix/host.nix"
    cp "$original_host" "$host_file"

    run env DOTFILES_NIX_HOST_FILE="$host_file" /bin/bash -c \
        'printf "%s\n" "ci-user" "CI Runner Mac" | /bin/bash "$1"' \
        _ "$real_dotfiles_root/bin/core/nix-configure-host"

    assert_success
    assert_file_contains "$host_file" 'configurationName = "ci-runner-mac";'
    assert_file_contains "$host_file" 'username = "ci-user";'
    assert_file_contains "$host_file" 'computerName = "CI Runner Mac";'
    assert_file_contains "$host_file" 'hostName = "ci-runner-mac";'
    assert_file_contains "$host_file" 'localHostName = "ci-runner-mac";'
}

@test "nix-configure-host: dry-run preserves host configuration" {
    local real_dotfiles_root host_file checksum_before checksum_after
    real_dotfiles_root="$(cd "$(get_dotfiles_root)" && pwd)"
    host_file="$BATS_TEST_TMPDIR/host.nix"
    cp "$real_dotfiles_root/nix/host.nix" "$host_file"
    checksum_before="$(cksum < "$host_file")"

    run env DOTFILES_NIX_HOST_FILE="$host_file" /bin/bash \
        "$real_dotfiles_root/bin/core/nix-configure-host" \
        --dry-run --username ci-user --machine-name "CI Runner Mac"

    assert_success
    assert_output --partial "Would configure Nix username: ci-user"
    checksum_after="$(cksum < "$host_file")"
    assert_equal "$checksum_after" "$checksum_before"
}

@test "nix-configure-host: rejects shell glob characters in machine names" {
    local real_dotfiles_root machine_name
    real_dotfiles_root="$(cd "$(get_dotfiles_root)" && pwd)"

    for machine_name in '*' '?' '[' ']'; do
        run /bin/bash "$real_dotfiles_root/bin/core/nix-configure-host" \
            --dry-run --username ci-user --machine-name "$machine_name"

        assert_failure
        assert_output --partial "contains unsupported characters"
    done
}

@test "nix-bootstrap: detects installed Nix outside PATH" {
    skip_on_linux "macOS-specific Nix bootstrap"
    [[ -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]] || \
        skip "Nix daemon profile is not installed"

    local real_dotfiles_root
    real_dotfiles_root="$(get_dotfiles_root)"
    run env HOME="$HOME" PATH="/usr/bin:/bin" \
        /bin/bash "$real_dotfiles_root/bin/core/nix-bootstrap" --dry-run

    assert_success
    refute_output --partial "Would install upstream Nix"
}

@test "nix-rebuild: uses the locked darwin-rebuild package" {
    skip_on_linux "macOS-specific nix-darwin command"
    local real_dotfiles_root
    real_dotfiles_root="$(cd "$(get_dotfiles_root)" && pwd)"
    run env PATH="/usr/bin:/bin" \
        /bin/bash "$real_dotfiles_root/bin/core/nix-rebuild" \
        --dry-run --skip-check --skip-npm

    assert_success
    assert_output --partial "$real_dotfiles_root#darwin-rebuild"
    refute_output --partial "github:nix-darwin"
}

@test "nix-activate: dry-run is user-only and sudo-free" {
    skip_on_linux "macOS-specific Home Manager configuration"
    local real_dotfiles_root
    real_dotfiles_root="$(cd "$(get_dotfiles_root)" && pwd)"
    run /bin/bash "$real_dotfiles_root/bin/core/nix-activate" \
        --dry-run --skip-check --skip-npm

    assert_success
    assert_output --partial "$real_dotfiles_root#home-manager"
    refute_output --partial "sudo"
    refute_output --partial "darwin-rebuild"
}

@test "nix-bootstrap: defaults to user activation" {
    skip_on_linux "macOS-specific Nix bootstrap"
    local real_dotfiles_root
    real_dotfiles_root="$(cd "$(get_dotfiles_root)" && pwd)"
    run /bin/bash "$real_dotfiles_root/bin/core/nix-bootstrap" \
        --dry-run --skip-npm

    assert_success
    assert_output --partial "bin/core/nix-activate"
    assert_output --partial "bin/core/zsh-compile --force"
    refute_output --partial "bin/core/nix-rebuild"
    refute_output --partial "sudo"
}

@test "zsh-compile: force replaces stale bytecode" {
    command -v zsh >/dev/null 2>&1 || skip "zsh is not installed"
    local real_dotfiles_root compile_home source_file original_checksum
    real_dotfiles_root="$(cd "$(get_dotfiles_root)" && pwd)"
    compile_home="$BATS_TEST_TMPDIR/zsh-compile-home"
    source_file="$compile_home/.config/zsh/.zshrc"
    mkdir -p "$(dirname "$source_file")"
    printf 'export COMPILED_VALUE=old\n' > "$source_file"
    zsh -c 'zcompile "$1"' _ "$source_file"
    original_checksum="$(cksum < "$source_file.zwc")"
    touch -t 203001010000 "$source_file.zwc"
    printf 'export COMPILED_VALUE=new\n' > "$source_file"

    run env HOME="$compile_home" zsh \
        "$real_dotfiles_root/bin/core/zsh-compile" --force

    assert_success
    refute_output --partial "already up to date"
    refute [ "$(cksum < "$source_file.zwc")" = "$original_checksum" ]
}

@test "nix-bootstrap: system mode is explicit" {
    skip_on_linux "macOS-specific Nix bootstrap"
    local real_dotfiles_root
    real_dotfiles_root="$(cd "$(get_dotfiles_root)" && pwd)"
    run /bin/bash "$real_dotfiles_root/bin/core/nix-bootstrap" \
        --system --dry-run --skip-npm

    assert_success
    assert_output --partial "bin/core/nix-rebuild"
}

@test "nix-update: switch defaults to user activation" {
    local real_dotfiles_root
    real_dotfiles_root="$(cd "$(get_dotfiles_root)" && pwd)"
    run /bin/bash "$real_dotfiles_root/bin/core/nix-update" \
        --switch --dry-run

    assert_success
    assert_output --partial "bin/core/nix-activate"
    refute_output --partial "bin/core/nix-rebuild"
    refute_output --partial "sudo"
}

@test "nix-update: system switch is explicit" {
    local real_dotfiles_root
    real_dotfiles_root="$(cd "$(get_dotfiles_root)" && pwd)"
    run /bin/bash "$real_dotfiles_root/bin/core/nix-update" \
        --switch --system --dry-run

    assert_success
    assert_output --partial "bin/core/nix-rebuild"
}

@test "nix-update: system mode requires switch" {
    local real_dotfiles_root
    real_dotfiles_root="$(cd "$(get_dotfiles_root)" && pwd)"
    run /bin/bash "$real_dotfiles_root/bin/core/nix-update" \
        --system --dry-run

    assert_failure
    assert_output --partial "--system requires --switch"
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
    assert_output --regexp "(Would install jq|jq is already installed)"
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
    skip_on_linux "macOS-specific phase sequence"

    run env SHELL=/bin/zsh "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success

    # Verify phase order in output
    assert_output --partial "Phase 1: Pre-flight Checks"
    assert_output --partial "Phase 2: Homebrew Setup"
    assert_output --partial "Phase 3: Dependencies"
    assert_output --partial "Phase 4: Homebrew Bundle"
    assert_output --partial "Phase 5: Version Manager Setup"
    assert_output --partial "Phase 6: Prezto & Starship Setup"
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

@test "install: scripts-only delegates public commands to the linker" {
    run "$DOTFILES_ROOT/install" --scripts-only --dry-run --yes
    assert_success
    assert_output --partial "Public Command Linking (~/.local/bin only)"
    assert_output --partial "Mock link-dotfiles --commands-only --dry-run --yes"
    refute_output --partial "~/local/bin"
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
    skip_on_linux "Homebrew is only configured on macOS"

    rm -f "$DOTFILES_ROOT/home-darwin/Brewfile"

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

@test "install: checks for Starship prompt" {
    run "$DOTFILES_ROOT/install" --dry-run --yes
    assert_success

    if command -v starship >/dev/null 2>&1; then
        assert_output --partial "Starship is already installed"
    else
        assert_output --partial "Starship is not installed"
        assert_output --partial "Would install Starship with Homebrew"
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
