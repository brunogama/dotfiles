#!/usr/bin/env bats
# Integration tests for git-worktree and git-virtual-worktree utilities

load '../../helpers/test-helpers'
load '../../helpers/git-helpers'
load '../../helpers/file-helpers'
load '../../helpers/setup-teardown'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'
load '../../helpers/bats-file/load.bash'

setup() {
    git_test_setup

    # Create initial commit on main branch
    create_file_with_content "README.md" "# Test repo"
    git add README.md
    git commit -m "Initial commit"

    # Ensure we're on main branch
    git checkout -b main 2>/dev/null || git checkout main
}

teardown() {
    git_test_teardown
}

# Git-worktree Tests

@test "git-worktree: shows help with --help" {
    skip_if_no_command "python3" "Python not available"

    run_git_script "git-worktree" --help
    # Should show help or typer output
}

@test "git-worktree: requires slug for create" {
    skip_if_no_command "python3" "Python not available"

    run_git_script "git-worktree" create
    assert_failure
}

@test "git-worktree: validates slug format" {
    skip_if_no_command "python3" "Python not available"

    # Invalid: contains slash
    run_git_script "git-worktree" create "invalid/slug"
    assert_failure

    # Invalid: contains spaces
    run_git_script "git-worktree" create "invalid slug"
    assert_failure

    # Invalid: path traversal
    run_git_script "git-worktree" create "../escape"
    assert_failure
}

@test "git-worktree: accepts valid slug" {
    skip_if_no_command "python3" "Python not available"
    skip "Requires interactive confirmation or --yes flag"

    run_git_script "git-worktree" create "valid-slug"
    # Would create worktree
}

@test "git-worktree: normalizes slug to lowercase" {
    skip_if_no_command "python3" "Python not available"
    skip "Requires mocking or dry-run mode"

    # MixedCase should become lowercase
}

@test "git-worktree: requires git repository" {
    skip_if_no_command "python3" "Python not available"

    cd "$TEST_TEMP_DIR"
    mkdir -p not-a-repo
    cd not-a-repo

    run_git_script "git-worktree" create "test"
    assert_failure
}

@test "git-worktree: requires non-detached HEAD" {
    skip_if_no_command "python3" "Python not available"

    # Detach HEAD
    git checkout HEAD~0 2>/dev/null || git checkout --detach HEAD

    run_git_script "git-worktree" create "test"
    assert_failure
}

@test "git-worktree: list shows worktrees" {
    skip_if_no_command "python3" "Python not available"

    run_git_script "git-worktree" list-worktrees
    assert_success
}

# Git-virtual-worktree Tests

@test "git-virtual-worktree: shows help with --help" {
    skip_if_no_command "python3" "Python not available"

    run_git_script "git-virtual-worktree" --help
    # Should show help
}

@test "git-virtual-worktree: requires slug for create" {
    skip_if_no_command "python3" "Python not available"

    run_git_script "git-virtual-worktree" create
    assert_failure
}

@test "git-virtual-worktree: validates slug format" {
    skip_if_no_command "python3" "Python not available"

    run_git_script "git-virtual-worktree" create "invalid/slug"
    assert_failure
}

@test "git-virtual-worktree: accepts depth option" {
    skip_if_no_command "python3" "Python not available"
    skip "Requires interactive confirmation"

    run_git_script "git-virtual-worktree" create "test" --depth 5
    # Would create shallow clone with depth 5
}

@test "git-virtual-worktree: list shows virtual worktrees" {
    skip_if_no_command "python3" "Python not available"

    run_git_script "git-virtual-worktree" list-virtual-worktrees
    assert_success
}

# Slug Validation Tests

@test "worktree slugs: reject empty" {
    skip_if_no_command "python3" "Python not available"

    run_git_script "git-worktree" create ""
    assert_failure
}

@test "worktree slugs: reject special characters" {
    skip_if_no_command "python3" "Python not available"

    # Test various invalid characters
    for char in '@' '#' '$' '%' '^' '&' '*'; do
        run_git_script "git-worktree" create "test${char}slug"
        assert_failure
    done
}

@test "worktree slugs: accept valid characters" {
    skip_if_no_command "python3" "Python not available"
    skip "Would create actual worktrees"

    # Hyphens, underscores, alphanumeric
    # run_git_script "git-worktree" create "test-slug_123"
    # assert_success
}

@test "worktree slugs: reject too long" {
    skip_if_no_command "python3" "Python not available"

    # Create 101-character slug
    local long_slug
    long_slug=$(printf 'a%.0s' {1..101})

    run_git_script "git-worktree" create "$long_slug"
    assert_failure
}

# Parent Directory Tests

@test "worktree: rejects parent with spaces" {
    skip_if_no_command "python3" "Python not available"
    skip "Requires setup with spaced directory name"
}

@test "worktree: validates path traversal protection" {
    skip_if_no_command "python3" "Python not available"

    run_git_script "git-worktree" create "../../escape"
    assert_failure
}

# Branch Tests

@test "worktree: creates feature branch" {
    skip_if_no_command "python3" "Python not available"
    skip "Would create actual worktree"

    # Should create feature/<slug> branch
}

@test "worktree: fails if branch exists" {
    skip_if_no_command "python3" "Python not available"

    # Create branch first
    git branch feature/test-exists

    run_git_script "git-worktree" create "test-exists"
    assert_failure
}

# Metadata Tests

@test "worktree: saves metadata on create" {
    skip_if_no_command "python3" "Python not available"
    skip "Would create actual worktree"

    # Should create .git/worktree-feature-<slug>.json
}

@test "worktree: loads metadata for status" {
    skip_if_no_command "python3" "Python not available"
    skip "Requires existing worktree"

    # run_git_script "git-worktree" status "test-slug"
}

# Submodule Tests

@test "worktree: initializes submodules if present" {
    skip_if_no_command "python3" "Python not available"
    skip "Requires repo with submodules"
}

# Integration Flow Tests

@test "worktree workflow: create-merge-cleanup" {
    skip_if_no_command "python3" "Python not available"
    skip "Complex integration test"

    # 1. Create worktree
    # 2. Make changes in worktree
    # 3. Merge back
    # 4. Cleanup
}

@test "virtual-worktree workflow: create-merge-cleanup" {
    skip_if_no_command "python3" "Python not available"
    skip "Complex integration test requiring remote"

    # 1. Create virtual worktree
    # 2. Make changes
    # 3. Push to remote
    # 4. Merge
    # 5. Cleanup
}

# Error Handling Tests

@test "worktree: handles worktree path exists" {
    skip_if_no_command "python3" "Python not available"
    skip "Would create directories"

    # Pre-create the worktree path
    # run_git_script "git-worktree" create should fail
}

@test "worktree: handles branch in use" {
    skip_if_no_command "python3" "Python not available"
    skip "Requires existing worktree"

    # Create worktree with branch
    # Try to create another with same branch
    # Should fail
}

# Virtual Worktree Specific Tests

@test "virtual-worktree: uses shallow clone" {
    skip_if_no_command "python3" "Python not available"
    skip "Would clone repository"

    # Should use --depth 1 by default
}

@test "virtual-worktree: requires remote URL" {
    skip_if_no_command "python3" "Python not available"

    # Repository without remote
    git remote remove origin 2>/dev/null || true

    run_git_script "git-virtual-worktree" create "test"
    assert_failure
}

@test "virtual-worktree: stores remote metadata" {
    skip_if_no_command "python3" "Python not available"
    skip "Would create virtual worktree"

    # Metadata should include remote_url and depth
}

# Exit Code Tests

@test "worktree: exits non-zero on invalid slug" {
    skip_if_no_command "python3" "Python not available"

    run_git_script "git-worktree" create "invalid/slug"
    [[ "$status" -ne 0 ]]
}

@test "worktree: exits non-zero outside git repo" {
    skip_if_no_command "python3" "Python not available"

    cd "$TEST_TEMP_DIR"
    mkdir -p not-git
    cd not-git

    run_git_script "git-worktree" create "test"
    [[ "$status" -ne 0 ]]
}

# Command Tests

@test "worktree commands: all subcommands exist" {
    skip_if_no_command "python3" "Python not available"

    # Test that main commands are recognized
    run_git_script "git-worktree" --help
    assert_output --partial "create"
    assert_output --partial "merge"
    assert_output --partial "cleanup"
    assert_output --partial "list"
    assert_output --partial "status"
}

@test "virtual-worktree commands: all subcommands exist" {
    skip_if_no_command "python3" "Python not available"

    run_git_script "git-virtual-worktree" --help
    assert_output --partial "create"
    assert_output --partial "merge"
    assert_output --partial "cleanup"
    assert_output --partial "list"
    assert_output --partial "status"
}

# Merge Strategy Tests

@test "worktree: merge uses git-smart-merge" {
    skip_if_no_command "python3" "Python not available"
    skip "Requires git-smart-merge and existing worktree"

    # Merge command should invoke git-smart-merge
}

@test "worktree: merge supports --dry-run" {
    skip_if_no_command "python3" "Python not available"
    skip "Requires existing worktree"

    # run_git_script "git-worktree" merge "test" --dry-run
}

@test "worktree: merge supports --force-rebase" {
    skip_if_no_command "python3" "Python not available"
    skip "Requires existing worktree"

    # run_git_script "git-worktree" merge "test" --force-rebase
}

@test "worktree: merge supports --force-merge" {
    skip_if_no_command "python3" "Python not available"
    skip "Requires existing worktree"

    # run_git_script "git-worktree" merge "test" --force-merge
}

# Cleanup Tests

@test "worktree: cleanup prompts for confirmation" {
    skip_if_no_command "python3" "Python not available"
    skip "Interactive test"

    # Should prompt unless --yes flag
}

@test "worktree: cleanup removes worktree directory" {
    skip_if_no_command "python3" "Python not available"
    skip "Requires existing worktree"

    # After cleanup, worktree directory should not exist
}

@test "worktree: cleanup deletes feature branch" {
    skip_if_no_command "python3" "Python not available"
    skip "Requires existing worktree"

    # After cleanup, feature/<slug> branch should be deleted
}

@test "worktree: cleanup removes metadata" {
    skip_if_no_command "python3" "Python not available"
    skip "Requires existing worktree"

    # After cleanup, metadata file should be removed
}

# Status Display Tests

@test "worktree: status shows all metadata" {
    skip_if_no_command "python3" "Python not available"
    skip "Requires existing worktree"

    # Should show: base branch, feature branch, path, created time, created by
}

@test "worktree: status indicates missing worktree" {
    skip_if_no_command "python3" "Python not available"
    skip "Requires metadata without actual worktree"

    # Should show warning if worktree directory doesn't exist
}

# List Display Tests

@test "worktree: list shows empty when no worktrees" {
    skip_if_no_command "python3" "Python not available"

    run_git_script "git-worktree" list-worktrees
    assert_success
    # May show "No worktrees found" or similar
}

@test "virtual-worktree: list shows empty when none exist" {
    skip_if_no_command "python3" "Python not available"

    run_git_script "git-virtual-worktree" list-virtual-worktrees
    assert_success
}
