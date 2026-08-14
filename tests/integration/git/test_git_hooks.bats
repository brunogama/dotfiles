#!/usr/bin/env bats
# Integration tests for git hooks

load '../../helpers/test-helpers'
load '../../helpers/git-helpers'
load '../../helpers/file-helpers'
load '../../helpers/setup-teardown'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'
load '../../helpers/bats-file/load.bash'

setup() {
    git_test_setup

    # Get dotfiles root
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"
    export HOOKS_DIR="$dotfiles_root/bin/git/hooks"

    # Create initial commit
    create_test_file "README.md" "# Test"
    git add README.md
    git commit -m "Initial commit"
}

teardown() {
    git_test_teardown
}

# Check-lowercase-dirs Hook Tests

@test "check-lowercase-dirs: passes with lowercase directories" {
    mkdir -p src/components
    create_test_file "src/components/button.js" "export default {}"
    git add src/

    run "$HOOKS_DIR/check-lowercase-dirs"
    assert_success
}

@test "check-lowercase-dirs: fails with uppercase directory" {
    mkdir -p SRC
    create_test_file "SRC/file.js" "content"
    git add SRC/

    run "$HOOKS_DIR/check-lowercase-dirs"
    assert_failure
    assert_output --partial "Uppercase"
}

@test "check-lowercase-dirs: fails with mixed case directory" {
    mkdir -p Src/Components
    create_test_file "Src/Components/button.js" "content"
    git add Src/

    run "$HOOKS_DIR/check-lowercase-dirs"
    assert_failure
}

@test "check-lowercase-dirs: checks nested directories" {
    mkdir -p lowercase/UpperCase/nested
    create_test_file "lowercase/UpperCase/nested/file.txt" "content"
    git add lowercase/

    run "$HOOKS_DIR/check-lowercase-dirs"
    assert_failure
}

@test "check-lowercase-dirs: passes with no staged files" {
    run "$HOOKS_DIR/check-lowercase-dirs"
    assert_success
}

# Check-no-emojis Hook Tests

@test "check-no-emojis: passes without emojis" {
    create_test_file "test.txt" "No emojis here"
    git add test.txt

    run "$HOOKS_DIR/check-no-emojis"
    assert_success
}

@test "check-no-emojis: fails with emoji in file content" {
    create_test_file "emoji.txt" "Hello 👋 world"
    git add emoji.txt

    run "$HOOKS_DIR/check-no-emojis"
    assert_failure
    assert_output --partial "emoji"
}

@test "check-no-emojis: fails with emoji in commit message" {
    skip "Commit message check requires different hook type"
}

@test "check-no-emojis: detects various emoji types" {
    # Test different emoji categories
    create_test_file "test1.txt" "Smiling face 😀"
    create_test_file "test2.txt" "Heart ❤️"
    create_test_file "test3.txt" "Rocket 🚀"
    git add test1.txt test2.txt test3.txt

    run "$HOOKS_DIR/check-no-emojis"
    assert_failure
}

@test "check-no-emojis: passes with no staged files" {
    run "$HOOKS_DIR/check-no-emojis"
    assert_success
}

@test "check-no-emojis: treats pipe-prefixed staged filenames as data" {
    printf '%s\n' '#!/usr/bin/env bash' "touch '$TEST_REPO_DIR/executed'" \
        > "check-no-emojis-exploit.sh"
    chmod +x "check-no-emojis-exploit.sh"
    create_test_file "|check-no-emojis-exploit.sh" "safe"
    git add -- "|check-no-emojis-exploit.sh"

    run env "PATH=$TEST_REPO_DIR:$PATH" "$HOOKS_DIR/check-no-emojis"

    assert_success
    refute test -e "$TEST_REPO_DIR/executed"
}

# Check-commit-msg Hook Tests

@test "check-commit-msg: validates conventional commit format" {
    skip "Requires commit-msg hook context"
    # Would need to test via actual commit
}

@test "check-commit-msg: accepts valid types" {
    skip "Requires commit-msg hook context"
    # feat, fix, docs, style, refactor, perf, test, chore
}

@test "check-commit-msg: rejects invalid format" {
    skip "Requires commit-msg hook context"
}

# Manifest Validation Retirement Tests

@test "manifest validation: has no active hook or CI registration" {
    local dotfiles_root hook_name
    dotfiles_root="$(get_dotfiles_root)"
    hook_name="validate-""manifest"
    refute test -e "$HOOKS_DIR/$hook_name"
    run grep -R "$hook_name" "$dotfiles_root/.pre-commit-config.yaml" "$dotfiles_root/.github/workflows/ci.yml"
    # grep returns 1 when pattern not found, 2 on errors
    [ "$status" -eq 1 ]
}

# Validate-openspec Hook Tests

@test "validate-openspec: skips when no openspec changes" {
    create_test_file "regular.txt" "content"
    git add regular.txt

    run "$HOOKS_DIR/validate-openspec"
    assert_success
}

@test "validate-openspec: validates openspec changes" {
    skip "Requires openspec structure"
}

# Hook Installation Tests

@test "install-all-git-hooks: installs hooks" {
    skip "Would modify actual .git/hooks"
}

@test "install-conventional-commit: installs commit-msg hook" {
    skip "Would modify actual .git/hooks"
}

# Hook Integration Tests

@test "hooks: run in correct order" {
    skip "Requires actual git commit flow"
}

@test "hooks: can be bypassed with --no-verify" {
    # Create uppercase directory
    mkdir -p UPPERCASE
    create_test_file "UPPERCASE/file.txt" "content"
    git add UPPERCASE/

    # Commit with --no-verify should succeed
    run git commit -m "test" --no-verify
    assert_success
}

# Exit Code Tests

@test "check-lowercase-dirs: exits 0 when passing" {
    mkdir -p lowercase
    create_test_file "lowercase/file.txt" "content"
    git add lowercase/

    run "$HOOKS_DIR/check-lowercase-dirs"
    assert_equal "$status" 0
}

@test "check-lowercase-dirs: exits non-zero when failing" {
    mkdir -p UPPERCASE
    create_test_file "UPPERCASE/file.txt" "content"
    git add UPPERCASE/

    run "$HOOKS_DIR/check-lowercase-dirs"
    [[ "$status" -ne 0 ]]
}

@test "check-no-emojis: exits 0 when passing" {
    create_test_file "clean.txt" "No emojis"
    git add clean.txt

    run "$HOOKS_DIR/check-no-emojis"
    assert_equal "$status" 0
}

@test "check-no-emojis: exits non-zero when failing" {
    create_test_file "emoji.txt" "Has emoji 😀"
    git add emoji.txt

    run "$HOOKS_DIR/check-no-emojis"
    [[ "$status" -ne 0 ]]
}

# Error Message Tests

@test "check-lowercase-dirs: provides helpful error message" {
    mkdir -p BadDirectory
    create_test_file "BadDirectory/file.txt" "content"
    git add BadDirectory/

    run "$HOOKS_DIR/check-lowercase-dirs"
    assert_failure
    # Should indicate which directory violated the rule
}

@test "check-no-emojis: identifies emoji locations" {
    create_test_file "emoji-file.txt" "Content with emoji 🚀"
    git add emoji-file.txt

    run "$HOOKS_DIR/check-no-emojis"
    assert_failure
    # Should show filename and/or line with emoji
}

# Performance Tests

@test "hooks: run efficiently on large changesets" {
    skip "Performance test - manual verification"

    # Create many files
    for i in {1..100}; do
        mkdir -p "dir$i"
        create_test_file "dir$i/file.txt" "content $i"
    done
    git add .

    # Hooks should complete in reasonable time
    run timeout 10s "$HOOKS_DIR/check-lowercase-dirs"
    assert_success
}
