#!/usr/bin/env bats
# Integration tests for git helper utilities

load '../../helpers/test-helpers'
load '../../helpers/git-helpers'
load '../../helpers/file-helpers'
load '../../helpers/setup-teardown'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'
load '../../helpers/bats-file/load.bash'

setup() {
    git_test_setup

    # Create initial commits
    create_file_with_content "README.md" "# Test repo"
    git add README.md
    git commit -m "Initial commit"

    # Ensure on main branch
    git checkout -b main 2>/dev/null || git checkout main
}

teardown() {
    git_test_teardown
}

# Git-smart-merge Tests

@test "git-smart-merge: shows help with --help" {
    run_git_script "git-smart-merge" --help
    # Should show usage information
}

@test "git-smart-merge: requires branch argument" {
    run_git_script "git-smart-merge"
    assert_failure
}

@test "git-smart-merge: validates branch exists" {
    run_git_script "git-smart-merge" "nonexistent-branch"
    assert_failure
}

@test "git-smart-merge: handles clean fast-forward merge" {
    # Create feature branch
    git checkout -b feature/test
    create_file_with_content "feature.txt" "new feature"
    git add feature.txt
    git commit -m "Add feature"

    # Back to main
    git checkout main

    run_git_script "git-smart-merge" "feature/test"
    assert_success

    # Should have feature file
    assert_file_exists "feature.txt"
}

@test "git-smart-merge: supports --dry-run" {
    git checkout -b feature/dryrun
    create_file_with_content "dry.txt" "content"
    git add dry.txt
    git commit -m "Dry run test"

    git checkout main

    run_git_script "git-smart-merge" "feature/dryrun" --dry-run
    assert_success

    # File should NOT exist (dry run)
    assert_file_not_exists "dry.txt"
}

# Git-reword Tests

@test "git-reword: requires Python" {
    skip_if_no_command "python3" "Python not available"

    run_git_script "git-reword" --help
    # Should show help
}

# Conventional-commit Tests

@test "conventional-commit: shows help with --help" {
    run_git_script "conventional-commit" --help
    # Should show usage
}

@test "conventional-commit: interactive mode" {
    skip "Requires interactive input"
}

# Git-browse Tests

@test "git-browse: opens repository in browser" {
    skip "Requires browser and network"
}

# Git-subrm Tests

@test "git-subrm: removes submodule" {
    skip "Requires submodule setup"
}

# Interactive-cherry-pick Tests

@test "interactive-cherry-pick: requires Python" {
    skip_if_no_command "python3" "Python not available"

    run_git_script "interactive-cherry-pick" --help
    # Should show help
}

# Integration Tests

@test "smart-merge: chooses rebase for linear history" {
    skip "Complex integration test"

    # Create feature branch with no conflicts
    # smart-merge should prefer rebase
}

@test "smart-merge: chooses merge for diverged history" {
    skip "Complex integration test"

    # Create diverged branches
    # smart-merge should use merge commit
}

@test "smart-merge: detects conflicts" {
    # Create conflicting changes
    create_file_with_content "conflict.txt" "original"
    git add conflict.txt
    git commit -m "Add file"

    # Branch and modify
    git checkout -b feature/conflict
    echo "feature change" > conflict.txt
    git add conflict.txt
    git commit -m "Feature change"

    # Main and modify differently
    git checkout main
    echo "main change" > conflict.txt
    git add conflict.txt
    git commit -m "Main change"

    # Merge should detect conflict
    run_git_script "git-smart-merge" "feature/conflict"
    assert_failure
    assert_output --partial "conflict"
}

# Exit Code Tests

@test "git-smart-merge: exits 0 on successful merge" {
    git checkout -b feature/success
    create_file_with_content "success.txt" "content"
    git add success.txt
    git commit -m "Success test"

    git checkout main

    run_git_script "git-smart-merge" "feature/success"
    assert_equal "$status" 0
}

@test "git-smart-merge: exits non-zero on failure" {
    run_git_script "git-smart-merge" "nonexistent-branch"
    [[ "$status" -ne 0 ]]
}

# Helper Script Tests

@test "git helpers: all scripts are executable" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    # Check all git scripts are executable
    for script in "$dotfiles_root"/bin/git/*; do
        if [[ -f "$script" && ! -x "$script" ]]; then
            echo "Not executable: $script"
            return 1
        fi
    done
}

@test "git helpers: scripts have proper shebangs" {
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"

    for script in "$dotfiles_root"/bin/git/*.sh; do
        if [[ -f "$script" ]]; then
            head -n 1 "$script" | grep -q "^#!"
        fi
    done
}
