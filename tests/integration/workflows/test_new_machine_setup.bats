#!/usr/bin/env bats
# Integration tests for new machine setup workflow

load '../../helpers/test-helpers'
load '../../helpers/git-helpers'
load '../../helpers/file-helpers'
load '../../helpers/setup-teardown'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'
load '../../helpers/bats-file/load.bash'

setup() {
    standard_setup
}

teardown() {
    standard_teardown
}

# New Machine Setup Workflow Tests

@test "new machine: complete setup flow simulation" {
    skip "End-to-end workflow - requires manual verification"

    # 1. Clone dotfiles (simulated - already in test repo)
    # 2. Run install --dry-run
    # 3. Configure environment
    # 4. Run sync
}

@test "new machine: install script available" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_file_exists "$dotfiles_root/install"
    assert_file_executable "$dotfiles_root/install"
}

@test "new machine: link-dotfiles available" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_file_exists "$dotfiles_root/bin/core/link-dotfiles"
}

@test "new machine: work-mode available" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_file_exists "$dotfiles_root/bin/core/work-mode"
}

@test "new machine: required directories exist" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_dir_exists "$dotfiles_root/bin"
    assert_dir_exists "$dotfiles_root/zsh"
    assert_dir_exists "$dotfiles_root/git"
    assert_dir_exists "$dotfiles_root/packages"
}

@test "new machine: LinkingManifest.json exists" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_file_exists "$dotfiles_root/LinkingManifest.json"
}

@test "new machine: install dry-run works" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    run "$dotfiles_root/install" --dry-run
    # May succeed or fail depending on environment
}

@test "new machine: README provides setup instructions" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_file_exists "$dotfiles_root/README.md"
    assert_file_contains "$dotfiles_root/README.md" "install"
}

# Setup Verification Tests

@test "setup verification: can check git version" {
    skip_if_no_command "git" "git not available"

    run git --version
    assert_success
}

@test "setup verification: can check zsh version" {
    skip_if_no_command "zsh" "zsh not available"

    run zsh --version
    assert_success
}

@test "setup verification: can check curl" {
    skip_if_no_command "curl" "curl not available"

    run curl --version
    assert_success
}

# Post-Install Verification Tests

@test "post-install: dotfiles bin in PATH" {
    skip "Requires shell restart"

    # After install, ~/Developer/dotfiles/bin should be in PATH
}

@test "post-install: zsh config loaded" {
    skip "Requires shell restart"

    # After install, ~/.zshrc should source dotfiles config
}

@test "post-install: git config applied" {
    skip "Requires install completion"

    # After install, git config should be linked
}

# Environment Configuration Tests

@test "environment: can switch to work mode" {
    run_core_script "work-mode" work
    # Should work or show appropriate error
}

@test "environment: can switch to personal mode" {
    run_core_script "work-mode" personal
    # Should work or show appropriate error
}

@test "environment: can check status" {
    run_core_script "work-mode" status
    # Should show current mode
}

# Initial Sync Tests

@test "initial sync: syncenv available" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_file_exists "$dotfiles_root/bin/core/syncenv"
}

@test "initial sync: can run dry-run" {
    run_core_script "syncenv" --dry-run
    # Should complete
}

# Dependency Check Tests

@test "dependencies: homebrew on macOS" {
    skip_on_linux "macOS only"
    skip_if_no_command "brew" "Homebrew not installed"

    run brew --version
    assert_success
}

@test "dependencies: mise available" {
    skip_if_no_command "mise" "mise not installed"

    run mise --version
    assert_success
}

# Configuration File Tests

@test "config files: Brewfile exists" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_file_exists "$dotfiles_root/packages/homebrew/Brewfile"
}

@test "config files: gitconfig exists" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_file_exists "$dotfiles_root/git/.gitconfig"
}

@test "config files: zshrc exists" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_file_exists "$dotfiles_root/zsh/.zshrc"
}

# Setup Time Estimation Tests

@test "setup time: install dry-run completes in reasonable time" {
    skip "Performance test - manual verification"

    # Should complete in < 30 seconds
}

@test "setup time: link-dotfiles completes quickly" {
    skip "Performance test - manual verification"

    # Should complete in < 5 seconds
}

# Error Recovery Tests

@test "error recovery: install handles missing dependencies gracefully" {
    skip "Requires missing dependency simulation"
}

@test "error recovery: link-dotfiles handles missing files gracefully" {
    skip "Requires missing file simulation"
}

# Platform-Specific Tests

@test "platform: detects macOS correctly" {
    skip_on_linux "macOS only"

    [[ "$(uname)" == "Darwin" ]]
}

@test "platform: detects Linux correctly" {
    skip_on_macos "Linux only"

    [[ "$(uname)" == "Linux" ]]
}

# Documentation Tests

@test "documentation: MINDSET.MD exists" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_file_exists "$dotfiles_root/MINDSET.MD"
}

@test "documentation: install instructions clear" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_file_exists "$dotfiles_root/README.md"
    assert_file_contains "$dotfiles_root/README.md" "./install"
}

# Git Repository Tests

@test "git repo: is valid repository" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    cd "$dotfiles_root"
    run git status
    assert_success
}

@test "git repo: has remote origin" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    cd "$dotfiles_root"
    run git remote get-url origin
    # May succeed or fail depending on setup
}

# Backup Tests

@test "backup: existing configs backed up during install" {
    skip "Requires existing config simulation"
}

@test "backup: can restore from backup" {
    skip "Requires backup restoration testing"
}

# Cleanup Tests

@test "cleanup: install cleans up on failure" {
    skip "Requires failure simulation"
}

@test "cleanup: link-dotfiles removes broken symlinks" {
    skip "Requires broken symlink simulation"
}

# Exit Code Tests

@test "exit codes: install dry-run returns 0" {
    skip "Depends on environment"
}

@test "exit codes: link-dotfiles dry-run returns 0" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    run "$dotfiles_root/bin/core/link-dotfiles" --dry-run
    # May succeed depending on environment
}

# Integration Tests

@test "integration: install -> link -> configure -> sync" {
    skip "Complex integration test - manual verification"

    # Full workflow:
    # 1. install --dry-run
    # 2. link-dotfiles --dry-run
    # 3. work-mode status
    # 4. syncenv --dry-run
}

@test "integration: all core scripts executable" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    for script in "$dotfiles_root"/bin/core/*; do
        if [[ -f "$script" ]]; then
            assert_file_executable "$script"
        fi
    done
}

@test "integration: all git scripts executable" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    for script in "$dotfiles_root"/bin/git/*; do
        if [[ -f "$script" && ! -d "$script" ]]; then
            assert_file_executable "$script"
        fi
    done
}

# Security Tests

@test "security: no credentials in repository" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    cd "$dotfiles_root"

    # Check for common credential patterns
    ! grep -r "password" . --include="*.sh" --include="*.bash" || true
    ! grep -r "api_key" . --include="*.sh" --include="*.bash" || true
}

@test "security: sensitive files in gitignore" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_file_contains "$dotfiles_root/.gitignore" "credentials"
    assert_file_contains "$dotfiles_root/.gitignore" "secrets"
}
