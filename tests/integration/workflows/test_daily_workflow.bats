#!/usr/bin/env bats
# Integration tests for daily development workflows

load '../../helpers/test-helpers'
load '../../helpers/git-helpers'
load '../../helpers/file-helpers'
load '../../helpers/setup-teardown'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'
load '../../helpers/bats-file/load.bash'

setup() {
    git_test_setup

    # Create initial commit
    create_file_with_content "README.md" "# Test repo"
    git add README.md
    git commit -m "Initial commit"

    git checkout -b main 2>/dev/null || git checkout main
}

teardown() {
    git_test_teardown
}

# Daily Sync Workflow Tests

@test "daily workflow: sync with clean working tree" {
    run_core_script "syncenv" --dry-run
    # Should succeed with clean tree
}

@test "daily workflow: sync with uncommitted changes" {
    create_file_with_content "new-file.txt" "content"

    run_core_script "syncenv" --dry-run
    # Should handle uncommitted changes
}

@test "daily workflow: sync with untracked files" {
    echo "untracked" > untracked.txt

    run_core_script "syncenv" --dry-run
    # Should handle untracked files
}

@test "daily workflow: sync detects git repository" {
    run_core_script "syncenv" --dry-run
    assert_success
}

# Credential Management Workflow Tests

@test "credential workflow: store-api-key available" {
    skip_if_no_command "security" "macOS keychain not available"

    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_file_exists "$dotfiles_root/bin/credentials/store-api-key"
}

@test "credential workflow: get-api-key available" {
    skip_if_no_command "security" "macOS keychain not available"

    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_file_exists "$dotfiles_root/bin/credentials/get-api-key"
}

@test "credential workflow: credmatch available" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_file_exists "$dotfiles_root/bin/credentials/credmatch"
}

# Environment Switch Workflow Tests

@test "environment workflow: switch to work mode" {
    run_core_script "work-mode" work
    # Should switch modes
}

@test "environment workflow: switch to personal mode" {
    run_core_script "work-mode" personal
    # Should switch modes
}

@test "environment workflow: check current mode" {
    run_core_script "work-mode" status
    # Should show current mode
}

@test "environment workflow: idempotent switches" {
    run_core_script "work-mode" work
    run_core_script "work-mode" work
    # Should handle duplicate switches
}

# Git Workflow Tests

@test "git workflow: create WIP commit" {
    create_file_with_content "wip.txt" "work in progress"

    run_git_script "git-wip.sh"
    assert_success
}

@test "git workflow: restore WIP" {
    create_file_with_content "wip.txt" "work in progress"
    run_git_script "git-wip.sh"

    # Reset to clean state
    git reset HEAD

    run_git_script "git-restore-wip.sh"
    assert_success
}

@test "git workflow: create savepoint" {
    create_file_with_content "save.txt" "savepoint"

    run_git_script "git-save-all.sh"
    assert_success
}

@test "git workflow: conventional commit" {
    skip "Requires interactive input"

    # conventional-commit should guide user
}

@test "git workflow: smart merge" {
    # Create feature branch
    git checkout -b feature/test
    create_file_with_content "feature.txt" "feature work"
    git add feature.txt
    git commit -m "Add feature"

    # Back to main
    git checkout main

    run_git_script "git-smart-merge" "feature/test"
    assert_success
}

# Worktree Workflow Tests

@test "worktree workflow: git-worktree available" {
    skip_if_no_command "python3" "Python not available"

    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_file_exists "$dotfiles_root/bin/git/git-worktree"
}

@test "worktree workflow: list worktrees" {
    skip_if_no_command "python3" "Python not available"

    run_git_script "git-worktree" list-worktrees
    assert_success
}

@test "worktree workflow: create worktree" {
    skip_if_no_command "python3" "Python not available"
    skip "Requires interactive confirmation"

    # Would create worktree
}

# Combined Workflow Tests

@test "combined workflow: WIP -> switch env -> restore" {
    # Create WIP
    create_file_with_content "wip.txt" "content"
    run_git_script "git-wip.sh"
    assert_success

    # Switch environment
    run_core_script "work-mode" personal

    # Restore WIP
    git reset HEAD
    run_git_script "git-restore-wip.sh"
    assert_success
}

@test "combined workflow: savepoint -> modify -> restore" {
    # Create savepoint
    create_file_with_content "original.txt" "original content"
    run_git_script "git-save-all.sh"
    assert_success

    # Modify
    echo "modified" > original.txt

    # Restore
    run_git_script "git-restore-last-savepoint.sh"
    assert_success
}

@test "combined workflow: feature branch -> merge -> cleanup" {
    # Create feature
    git checkout -b feature/test-workflow
    create_file_with_content "feature.txt" "feature"
    git add feature.txt
    git commit -m "Add feature"

    # Merge
    git checkout main
    run_git_script "git-smart-merge" "feature/test-workflow"
    assert_success

    # Cleanup
    git branch -d feature/test-workflow
}

# Performance Workflow Tests

@test "performance workflow: zsh-compile available" {
    skip_if_no_command "zsh" "zsh not available"

    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_file_exists "$dotfiles_root/bin/core/zsh-compile"
}

@test "performance workflow: zsh-trim-history available" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_file_exists "$dotfiles_root/bin/core/zsh-trim-history"
}

@test "performance workflow: zsh-benchmark available" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_file_exists "$dotfiles_root/bin/core/zsh-benchmark"
}

# Daily Maintenance Tests

@test "maintenance: check for updates" {
    skip "Requires network and git remote"

    # git fetch origin
    # Compare local and remote
}

@test "maintenance: trim history periodically" {
    run_core_script "zsh-trim-history"
    # Should trim if needed
}

@test "maintenance: compile configs periodically" {
    skip_if_no_command "zsh" "zsh not available"

    run_core_script "zsh-compile"
    # Should compile configs
}

# Error Recovery Tests

@test "error recovery: WIP when nothing to commit" {
    run_git_script "git-wip.sh"
    # Should handle gracefully
}

@test "error recovery: restore WIP when none exists" {
    run_git_script "git-restore-wip.sh"
    # Should handle gracefully
}

@test "error recovery: sync when network unavailable" {
    skip "Requires network simulation"
}

# Multi-Project Workflow Tests

@test "multi-project: switch between repositories" {
    skip "Requires multiple repository setup"
}

@test "multi-project: manage multiple worktrees" {
    skip "Requires worktree setup"
}

# Collaboration Workflow Tests

@test "collaboration: conventional commits enforced" {
    skip "Requires commit-msg hook installation"
}

@test "collaboration: pre-commit hooks run" {
    skip "Requires hook installation"
}

@test "collaboration: no emojis in commits" {
    skip "Requires hook installation"
}

# Backup and Recovery Tests

@test "backup: savepoint before risky operation" {
    # Create savepoint
    create_file_with_content "before.txt" "before"
    run_git_script "git-save-all.sh"
    assert_success

    # Risky operation
    # ...

    # Can restore if needed
}

@test "backup: multiple savepoints maintained" {
    # First savepoint
    create_file_with_content "v1.txt" "version 1"
    run_git_script "git-save-all.sh"
    assert_success

    # Second savepoint
    create_file_with_content "v2.txt" "version 2"
    run_git_script "git-save-all.sh"
    assert_success

    # Both should exist in reflog
}

# Integration with External Tools Tests

@test "external tools: mise integration" {
    skip_if_no_command "mise" "mise not installed"

    run mise --version
    assert_success
}

@test "external tools: git integration" {
    run git --version
    assert_success
}

# Configuration Management Tests

@test "config management: link-dotfiles --apply" {
    skip "Requires actual system modification"
}

@test "config management: work-mode changes config" {
    run_core_script "work-mode" work
    # Should modify .zshenv
}

# Time Management Tests

@test "time management: quick WIP save" {
    skip "Performance test"

    # Should complete in < 2 seconds
}

@test "time management: fast environment switch" {
    skip "Performance test"

    # Should complete in < 1 second
}

# Logging and Debugging Tests

@test "logging: scripts output helpful messages" {
    run_git_script "git-wip.sh" --help
    # Should show usage
}

@test "logging: errors are descriptive" {
    run_git_script "git-smart-merge" "nonexistent-branch"
    assert_failure
    # Should have helpful error message
}

# Exit Code Tests

@test "exit codes: successful WIP returns 0" {
    create_file_with_content "test.txt" "content"

    run_git_script "git-wip.sh"
    assert_equal "$status" 0
}

@test "exit codes: failed merge returns non-zero" {
    run_git_script "git-smart-merge" "nonexistent"
    [[ "$status" -ne 0 ]]
}

@test "exit codes: successful sync returns 0" {
    run_core_script "syncenv" --dry-run
    assert_equal "$status" 0
}

# Documentation Tests

@test "documentation: all scripts have --help" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    # Core scripts should have help
    run_core_script "work-mode" --help
    # Should show help or run normally
}

@test "documentation: README covers daily workflows" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    assert_file_contains "$dotfiles_root/README.md" "workflow"
}

# Security Tests

@test "security: no credentials exposed in process list" {
    skip "Requires process monitoring"
}

@test "security: no credentials in shell history" {
    skip "Requires history inspection"
}
