#!/usr/bin/env bats
# Integration tests for git-wip and savepoint utilities

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
    create_test_file "README.md" "# Test repo"
    git add README.md
    git commit -m "Initial commit"
}

teardown() {
    git_test_teardown
}

# Git-wip Tests

@test "git-wip: runs without errors" {
    run_git_script "git-wip.sh"
    assert_success
}

@test "git-wip: creates WIP commit when changes exist" {
    # Create changes
    create_test_file "test.txt" "new content"

    run_git_script "git-wip.sh"
    assert_success

    # WIP commit should be in reflog
    git reflog | grep "WIP"
}

@test "git-wip: stages all changes" {
    # Create multiple changes
    create_test_file "file1.txt" "content 1"
    create_test_file "file2.txt" "content 2"
    mkdir -p subdir
    create_test_file "subdir/file3.txt" "content 3"

    run_git_script "git-wip.sh"
    assert_success

    # All files should be staged
    run git status --porcelain
    assert_output --regexp "^A.*file1.txt"
    assert_output --regexp "^A.*file2.txt"
    assert_output --regexp "^A.*subdir/file3.txt"
}

@test "git-wip: resets HEAD after commit" {
    create_test_file "test.txt" "content"

    # Get initial commit count
    local initial_commits
    initial_commits=$(git rev-list --count HEAD)

    run_git_script "git-wip.sh"
    assert_success

    # Commit count should be same (WIP commit was reset)
    local final_commits
    final_commits=$(git rev-list --count HEAD)

    [[ "$initial_commits" == "$final_commits" ]]
}

@test "git-wip: keeps changes staged after reset" {
    create_test_file "test.txt" "content"

    run_git_script "git-wip.sh"
    assert_success

    # Changes should still be staged
    run git diff --cached --name-only
    assert_output "test.txt"
}

@test "git-wip: handles no changes gracefully" {
    run_git_script "git-wip.sh"
    assert_success
    assert_output --partial "No changes to WIP"
}

@test "git-wip: bypasses pre-commit hooks" {
    create_test_file "test.txt" "content"

    # Create pre-commit hook that would fail
    mkdir -p .git/hooks
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
echo "Hook should not run"
exit 1
EOF
    chmod +x .git/hooks/pre-commit

    # Should succeed despite hook
    run_git_script "git-wip.sh"
    assert_success
    refute_output --partial "Hook should not run"
}

@test "git-wip: includes untracked files" {
    # Create untracked file
    create_test_file "untracked.txt" "new file"

    run_git_script "git-wip.sh"
    assert_success

    # File should be staged
    run git diff --cached --name-only
    assert_output "untracked.txt"
}

@test "git-wip: handles modified files" {
    create_test_file "existing.txt" "original"
    git add existing.txt
    git commit -m "Add existing file"

    # Modify file
    echo "modified" > existing.txt

    run_git_script "git-wip.sh"
    assert_success

    # Modification should be staged
    run git diff --cached --name-only
    assert_output "existing.txt"
}

@test "git-wip: handles deleted files" {
    create_test_file "to-delete.txt" "content"
    git add to-delete.txt
    git commit -m "Add file to delete"

    # Delete file
    rm to-delete.txt

    run_git_script "git-wip.sh"
    assert_success

    # Deletion should be staged
    run git diff --cached --name-only
    assert_output "to-delete.txt"
}

# Git-restore-wip Tests

@test "git-restore-wip: requires WIP commit" {
    run_git_script "git-restore-wip.sh"
    assert_failure
    assert_output --partial "No WIP commit found"
}

@test "git-restore-wip: restores last WIP commit" {
    # Create and WIP changes
    create_test_file "test.txt" "content"
    run_git_script "git-wip.sh"
    assert_success

    # Unstage changes
    git reset HEAD

    # Restore WIP
    run_git_script "git-restore-wip.sh"
    assert_success
    assert_output --partial "Restoring WIP commit"
}

@test "git-restore-wip: applies WIP changes" {
    create_test_file "test.txt" "WIP content"
    run_git_script "git-wip.sh"

    # Clear working tree
    git reset HEAD
    rm -f test.txt

    # Restore
    run_git_script "git-restore-wip.sh"
    assert_success

    # File should be back with WIP content
    assert_file_exists "test.txt"
    assert_file_contains "test.txt" "WIP content"
}

@test "git-restore-wip: finds most recent WIP" {
    # Create first WIP
    create_test_file "first.txt" "first"
    run_git_script "git-wip.sh"

    # Create second WIP
    create_test_file "second.txt" "second"
    run_git_script "git-wip.sh"

    # Clear
    git reset HEAD
    rm -f first.txt second.txt

    # Restore should get most recent
    run_git_script "git-restore-wip.sh"
    assert_success

    # Should have second file
    assert_file_exists "second.txt"
}

@test "git-restore-wip: uses cherry-pick" {
    create_test_file "test.txt" "content"
    run_git_script "git-wip.sh"

    git reset HEAD
    rm test.txt

    # Get commit count before restore
    local before_commits
    before_commits=$(git rev-list --count HEAD)

    run_git_script "git-restore-wip.sh"
    assert_success

    # Should have new commit from cherry-pick
    local after_commits
    after_commits=$(git rev-list --count HEAD)

    [[ $after_commits -gt $before_commits ]]
}

# Git-save-all Tests

@test "git-save-all: creates savepoint" {
    create_test_file "test.txt" "content"

    run_git_script "git-save-all.sh"
    assert_success

    # Should have savepoint in reflog
    git reflog | grep "SAVE POINT"
}

@test "git-save-all: stages changes before savepoint" {
    create_test_file "test.txt" "content"

    run_git_script "git-save-all.sh"
    assert_success

    # File should be in last commit
    git show HEAD --name-only | grep "test.txt"
}

@test "git-save-all: uses specific commit message format" {
    create_test_file "test.txt" "content"

    run_git_script "git-save-all.sh"
    assert_success

    # Should have exact message
    git log -1 --pretty=%s | grep "^chore!: SAVE POINT$"
}

# Git-restore-last-savepoint Tests

@test "git-restore-last-savepoint: requires savepoint" {
    run_git_script "git-restore-last-savepoint.sh"
    assert_failure
    assert_output --partial "No SAVE POINT commit found"
}

@test "git-restore-last-savepoint: restores savepoint" {
    # Create savepoint
    create_test_file "saved.txt" "saved content"
    run_git_script "git-save-all.sh"
    assert_success

    # Remove file
    rm saved.txt
    git add -A
    git commit -m "Remove saved file"

    # Restore
    run_git_script "git-restore-last-savepoint.sh"
    assert_success
    assert_output --partial "Restoring SAVE POINT"
}

@test "git-restore-last-savepoint: removes savepoint after restore" {
    create_test_file "test.txt" "content"
    run_git_script "git-save-all.sh"

    run_git_script "git-restore-last-savepoint.sh"
    assert_success

    # Savepoint commit should be removed from HEAD
    # (cherry-picked then reset --hard HEAD~1)
    run git log -1 --pretty=%s
    refute_output "chore!: SAVE POINT"
}

@test "git-restore-last-savepoint: finds most recent savepoint" {
    # Create first savepoint
    create_test_file "first.txt" "first"
    run_git_script "git-save-all.sh"

    # Create second savepoint
    create_test_file "second.txt" "second"
    run_git_script "git-save-all.sh"

    # Remove both
    rm first.txt second.txt
    git add -A
    git commit -m "Clean up"

    # Restore should get most recent
    run_git_script "git-restore-last-savepoint.sh"
    assert_success

    # Should have second file
    assert_file_exists "second.txt"
}

# WIP vs Savepoint Comparison Tests

@test "WIP and savepoint: different reflog patterns" {
    # Create WIP
    create_test_file "wip.txt" "wip"
    run_git_script "git-wip.sh"

    # Create savepoint
    create_test_file "save.txt" "save"
    run_git_script "git-save-all.sh"

    # Verify different patterns in reflog
    git reflog --pretty="%s" | grep "^WIP$"
    git reflog --pretty="%s" | grep "^chore!: SAVE POINT$"
}

@test "WIP: preserves uncommitted state" {
    create_test_file "test.txt" "content"

    # Get status before WIP
    run git status --porcelain
    local before_status="$output"

    run_git_script "git-wip.sh"
    assert_success

    # Status should be same after WIP
    run git status --porcelain
    assert_output "$before_status"
}

@test "savepoint: creates persistent commit" {
    create_test_file "test.txt" "content"

    local before_commits
    before_commits=$(git rev-list --count HEAD)

    run_git_script "git-save-all.sh"
    assert_success

    # Should have one more commit
    local after_commits
    after_commits=$(git rev-list --count HEAD)

    [[ $after_commits -eq $((before_commits + 1)) ]]
}

# Reflog Search Tests

@test "git-restore-wip: searches reflog correctly" {
    # Create multiple commits
    create_test_file "regular.txt" "regular commit"
    git add regular.txt
    git commit -m "Regular commit"

    create_test_file "wip.txt" "wip commit"
    run_git_script "git-wip.sh"

    create_test_file "another.txt" "another commit"
    git add another.txt
    git commit -m "Another commit"

    # Clear
    git reset --hard HEAD
    rm -f wip.txt

    # Should find WIP despite other commits
    run_git_script "git-restore-wip.sh"
    assert_success
}

@test "git-restore-last-savepoint: searches reflog correctly" {
    # Create regular commits around savepoint
    create_test_file "before.txt" "before"
    git add before.txt
    git commit -m "Before savepoint"

    create_test_file "saved.txt" "saved"
    run_git_script "git-save-all.sh"

    create_test_file "after.txt" "after"
    git add after.txt
    git commit -m "After savepoint"

    # Should find savepoint despite surrounding commits
    run_git_script "git-restore-last-savepoint.sh"
    assert_success
}

# Error Handling Tests

@test "git-wip: handles git errors gracefully" {
    create_test_file "test.txt" "content"

    # Corrupt git directory
    echo "corrupt" > .git/HEAD

    run_git_script "git-wip.sh"
    assert_failure
}

@test "git-restore-wip: handles cherry-pick conflicts" {
    skip "Complex conflict scenario - manual testing"
    # Would require setting up conflicting changes
}

# Exit Code Tests

@test "git-wip: exits 0 with changes" {
    create_test_file "test.txt" "content"

    run_git_script "git-wip.sh"
    assert_equal "$status" 0
}

@test "git-wip: exits 0 without changes" {
    run_git_script "git-wip.sh"
    assert_equal "$status" 0
}

@test "git-restore-wip: exits 0 on success" {
    create_test_file "test.txt" "content"
    run_git_script "git-wip.sh"
    git reset HEAD
    rm test.txt

    run_git_script "git-restore-wip.sh"
    assert_equal "$status" 0
}

@test "git-restore-wip: exits 1 when no WIP found" {
    run_git_script "git-restore-wip.sh"
    assert_equal "$status" 1
}

@test "git-save-all: exits 0 on success" {
    create_test_file "test.txt" "content"

    run_git_script "git-save-all.sh"
    assert_equal "$status" 0
}

@test "git-restore-last-savepoint: exits 1 when no savepoint found" {
    run_git_script "git-restore-last-savepoint.sh"
    assert_equal "$status" 1
}

# Integration Tests

@test "WIP workflow: create and restore" {
    # Simulate developer workflow
    # 1. Make changes
    create_test_file "feature.txt" "work in progress"
    mkdir -p src
    create_test_file "src/code.txt" "new code"

    # 2. WIP to save state
    run_git_script "git-wip.sh"
    assert_success

    # 3. Switch context (simulate)
    git reset HEAD
    rm -rf feature.txt src

    # 4. Restore WIP later
    run_git_script "git-restore-wip.sh"
    assert_success

    # 5. Verify all changes restored
    assert_file_exists "feature.txt"
    assert_file_exists "src/code.txt"
    assert_file_contains "feature.txt" "work in progress"
}

@test "savepoint workflow: create and restore" {
    # 1. Reach a good state
    create_test_file "stable.txt" "stable version"

    # 2. Create savepoint
    run_git_script "git-save-all.sh"
    assert_success

    # 3. Make experimental changes
    create_test_file "experiment.txt" "experimental code"
    git add -A
    git commit -m "Experimental changes"

    create_test_file "more-experiments.txt" "more experiments"
    git add -A
    git commit -m "More experiments"

    # 4. Restore to savepoint
    run_git_script "git-restore-last-savepoint.sh"
    assert_success

    # 5. Should have stable file
    assert_file_exists "stable.txt"
}

@test "WIP and savepoint: can coexist" {
    # Create savepoint
    create_test_file "saved.txt" "saved"
    run_git_script "git-save-all.sh"

    # Create WIP
    create_test_file "wip.txt" "wip"
    run_git_script "git-wip.sh"

    # Both should be in reflog
    git reflog | grep "WIP"
    git reflog | grep "SAVE POINT"

    # Can restore each independently
    git reset HEAD
    rm wip.txt

    run_git_script "git-restore-wip.sh"
    assert_success
    assert_file_exists "wip.txt"
}

@test "multiple WIPs: can create many" {
    # Create multiple WIP sessions
    for i in {1..5}; do
        create_test_file "wip$i.txt" "wip $i"
        run_git_script "git-wip.sh"
        assert_success
        git reset HEAD
    done

    # All should be in reflog
    local wip_count
    wip_count=$(git reflog --pretty="%s" | grep -c "^WIP$")

    [[ $wip_count -ge 5 ]]
}

@test "multiple savepoints: can create many" {
    # Create multiple savepoints
    for i in {1..3}; do
        create_test_file "save$i.txt" "save $i"
        run_git_script "git-save-all.sh"
        assert_success
    done

    # All should be in reflog
    local save_count
    save_count=$(git reflog --pretty="%s" | grep -c "^chore!: SAVE POINT$")

    [[ $save_count -ge 3 ]]
}

# Cleanup Behavior Tests

@test "git-wip: preserves working directory state" {
    create_test_file "test.txt" "content"

    # Record file state
    local file_hash
    file_hash=$(sha256sum test.txt | cut -d' ' -f1)

    run_git_script "git-wip.sh"
    assert_success

    # File should be unchanged
    local after_hash
    after_hash=$(sha256sum test.txt | cut -d' ' -f1)

    [[ "$file_hash" == "$after_hash" ]]
}

@test "git-restore-wip: adds commit to history" {
    create_test_file "test.txt" "content"
    run_git_script "git-wip.sh"

    git reset HEAD
    rm test.txt

    local before_log
    before_log=$(git log --oneline | wc -l)

    run_git_script "git-restore-wip.sh"
    assert_success

    local after_log
    after_log=$(git log --oneline | wc -l)

    [[ $after_log -gt $before_log ]]
}

@test "git-restore-last-savepoint: removes savepoint from HEAD" {
    create_test_file "test.txt" "content"
    run_git_script "git-save-all.sh"

    # Verify savepoint is at HEAD
    git log -1 --pretty=%s | grep "SAVE POINT"

    run_git_script "git-restore-last-savepoint.sh"
    assert_success

    # Savepoint should not be at HEAD anymore
    run git log -1 --pretty=%s
    refute_output --partial "SAVE POINT"
}
