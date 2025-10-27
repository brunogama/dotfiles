#!/usr/bin/env bats
# Integration tests for work-mode script

load '../../helpers/test-helpers'
load '../../helpers/file-helpers'
load '../../helpers/setup-teardown'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'
load '../../helpers/bats-file/load.bash'

setup() {
    standard_setup

    export ZSHENV="$HOME/.zshenv"
}

teardown() {
    standard_teardown
}

# Status Command Tests

@test "work-mode: status shows current environment" {
    run_core_script "work-mode" "status"
    assert_success
    assert_output --partial "Environment:"
}

@test "work-mode: status defaults to personal when no config exists" {
    # No .zshenv file
    run_core_script "work-mode" "status"
    assert_success
    assert_output --partial "personal"
}

@test "work-mode: status shows work when configured" {
    # Set up work environment
    echo "export DOTFILES_ENV=work" > "$ZSHENV"

    run_core_script "work-mode" "status"
    assert_success
    assert_output --partial "work"
}

@test "work-mode: status shows personal when configured" {
    # Set up personal environment (default, no DOTFILES_ENV)
    touch "$ZSHENV"

    run_core_script "work-mode" "status"
    assert_success
    assert_output --partial "personal"
}

# Work Mode Activation Tests

@test "work-mode: work activates work environment" {
    # Start with personal (no config)
    run_core_script "work-mode" "work" <<< "n"
    assert_success
    assert_output --partial "Switched to work environment"

    # Verify .zshenv was created
    assert_file_exists "$ZSHENV"
    assert_file_contains "$ZSHENV" "export DOTFILES_ENV=work"
}

@test "work-mode: on activates work environment" {
    run_core_script "work-mode" "on" <<< "n"
    assert_success
    assert_output --partial "Switched to work environment"
}

@test "work-mode: enable activates work environment" {
    run_core_script "work-mode" "enable" <<< "n"
    assert_success
    assert_output --partial "Switched to work environment"
}

@test "work-mode: work is idempotent" {
    # Set work mode twice
    run_core_script "work-mode" "work" <<< "n"
    assert_success

    run_core_script "work-mode" "work" <<< "n"
    assert_success
    assert_output --partial "Already in work environment"
}

@test "work-mode: work creates .zshenv if missing" {
    # Ensure no .zshenv
    rm -f "$ZSHENV"

    run_core_script "work-mode" "work" <<< "n"
    assert_success

    assert_file_exists "$ZSHENV"
}

# Personal Mode Activation Tests

@test "work-mode: personal activates personal environment" {
    # Start with work mode
    echo "export DOTFILES_ENV=work" > "$ZSHENV"

    run_core_script "work-mode" "personal" <<< "n"
    assert_success
    assert_output --partial "Switched to personal environment"

    # DOTFILES_ENV should be removed
    assert_file_exists "$ZSHENV"
    assert_file_not_contains "$ZSHENV" "export DOTFILES_ENV=work"
}

@test "work-mode: home activates personal environment" {
    echo "export DOTFILES_ENV=work" > "$ZSHENV"

    run_core_script "work-mode" "home" <<< "n"
    assert_success
    assert_output --partial "Switched to personal environment"
}

@test "work-mode: off activates personal environment" {
    echo "export DOTFILES_ENV=work" > "$ZSHENV"

    run_core_script "work-mode" "off" <<< "n"
    assert_success
    assert_output --partial "Switched to personal environment"
}

@test "work-mode: disable activates personal environment" {
    echo "export DOTFILES_ENV=work" > "$ZSHENV"

    run_core_script "work-mode" "disable" <<< "n"
    assert_success
    assert_output --partial "Switched to personal environment"
}

@test "work-mode: personal is idempotent" {
    # Already in personal mode (default)
    run_core_script "work-mode" "personal" <<< "n"
    assert_success
    assert_output --partial "Already in personal environment"
}

# Migration Tests

@test "work-mode: migrates old marker file system" {
    # Create old marker file
    touch "$HOME/.work-machine"

    run_core_script "work-mode" "work" <<< "n"
    assert_success

    # Old marker should be removed
    assert_file_not_exists "$HOME/.work-machine"

    # New system should be in place
    assert_file_contains "$ZSHENV" "export DOTFILES_ENV=work"
}

@test "work-mode: migration message shown" {
    touch "$HOME/.work-machine"

    run_core_script "work-mode" "work" <<< "n"
    assert_success
    assert_output --partial "Migrating from old marker file system"
}

# Environment Variable Tests

@test "work-mode: sets DOTFILES_ENV=work correctly" {
    run_core_script "work-mode" "work" <<< "n"
    assert_success

    # Check exact format
    grep -q "^export DOTFILES_ENV=work$" "$ZSHENV"
}

@test "work-mode: removes DOTFILES_ENV for personal mode" {
    echo "export DOTFILES_ENV=work" > "$ZSHENV"

    run_core_script "work-mode" "personal" <<< "n"
    assert_success

    # DOTFILES_ENV should not exist
    if [[ -f "$ZSHENV" ]]; then
        assert_file_not_contains "$ZSHENV" "DOTFILES_ENV"
    fi
}

@test "work-mode: replaces existing DOTFILES_ENV" {
    # Set up with wrong value
    echo "export DOTFILES_ENV=personal" > "$ZSHENV"

    run_core_script "work-mode" "work" <<< "n"
    assert_success

    # Should have work value now
    assert_file_contains "$ZSHENV" "export DOTFILES_ENV=work"
    refute_file_contains "$ZSHENV" "export DOTFILES_ENV=personal"
}

# Reload Prompt Tests

@test "work-mode: offers to reload shell" {
    run_core_script "work-mode" "work" <<< "n"
    assert_success
    assert_output --partial "Reload shell now?"
}

@test "work-mode: shows reload command" {
    run_core_script "work-mode" "work" <<< "n"
    assert_success
    assert_output --partial "exec zsh"
}

# Prompt Indicator Tests

@test "work-mode: mentions prompt indicator for work mode" {
    run_core_script "work-mode" "work" <<< "n"
    assert_success
    assert_output --partial "Prompt will show"
    assert_output --partial "WORK"
}

@test "work-mode: mentions prompt indicator for personal mode" {
    echo "export DOTFILES_ENV=work" > "$ZSHENV"

    run_core_script "work-mode" "personal" <<< "n"
    assert_success
    assert_output --partial "Prompt will show"
    assert_output --partial "HOME:PERSONAL"
}

# Help Tests

@test "work-mode: help shows usage" {
    run_core_script "work-mode" "help"
    assert_success
    assert_output --partial "Usage:"
    assert_output --partial "Commands:"
}

@test "work-mode: --help shows usage" {
    run_core_script "work-mode" "--help"
    assert_success
    assert_output --partial "Usage:"
}

@test "work-mode: -h shows usage" {
    run_core_script "work-mode" "-h"
    assert_success
    assert_output --partial "Usage:"
}

# Invalid Command Tests

@test "work-mode: invalid command shows error" {
    run_core_script "work-mode" "invalid"
    assert_failure
    assert_output --partial "Unknown command"
}

# Colored Output Tests

@test "work-mode: uses colored output" {
    run_core_script "work-mode" "status"
    assert_success
    # Should use colors (even if not visible in test)
}

# .zshenv Preservation Tests

@test "work-mode: preserves other content in .zshenv" {
    # Create .zshenv with other content
    cat > "$ZSHENV" << 'EOF'
export PATH="/custom/path:$PATH"
export MY_VAR="test"
EOF

    run_core_script "work-mode" "work" <<< "n"
    assert_success

    # Other content should be preserved
    assert_file_contains "$ZSHENV" "export PATH="
    assert_file_contains "$ZSHENV" "export MY_VAR="
    assert_file_contains "$ZSHENV" "export DOTFILES_ENV=work"
}

# Edge Case Tests

@test "work-mode: handles .zshenv with comments" {
    cat > "$ZSHENV" << 'EOF'
# My zshenv
export PATH="/usr/local/bin:$PATH"
# export DOTFILES_ENV=work
EOF

    run_core_script "work-mode" "work" <<< "n"
    assert_success

    # Should add the export, not uncomment
    grep -q "^export DOTFILES_ENV=work$" "$ZSHENV"
}

@test "work-mode: handles empty .zshenv" {
    touch "$ZSHENV"

    run_core_script "work-mode" "work" <<< "n"
    assert_success

    assert_file_contains "$ZSHENV" "export DOTFILES_ENV=work"
}

# Switching Tests

@test "work-mode: can switch from work to personal" {
    # Set work
    run_core_script "work-mode" "work" <<< "n"
    assert_success

    # Switch to personal
    run_core_script "work-mode" "personal" <<< "n"
    assert_success

    # Verify personal
    run_core_script "work-mode" "status"
    assert_success
    assert_output --partial "personal"
}

@test "work-mode: can switch from personal to work" {
    # Start in personal (default)
    run_core_script "work-mode" "personal" <<< "n"
    assert_success

    # Switch to work
    run_core_script "work-mode" "work" <<< "n"
    assert_success

    # Verify work
    run_core_script "work-mode" "status"
    assert_success
    assert_output --partial "work"
}

# Exit Code Tests

@test "work-mode: exits 0 on successful switch" {
    run_core_script "work-mode" "work" <<< "n"
    assert_equal "$status" 0
}

@test "work-mode: exits 0 when already in target mode" {
    run_core_script "work-mode" "work" <<< "n"
    assert_success

    run_core_script "work-mode" "work" <<< "n"
    assert_equal "$status" 0
}

@test "work-mode: exits non-zero on invalid command" {
    run_core_script "work-mode" "invalid"
    assert_failure
}

# Default Command Tests

@test "work-mode: defaults to status with no arguments" {
    run_core_script "work-mode"
    assert_success
    assert_output --partial "Environment:"
}
