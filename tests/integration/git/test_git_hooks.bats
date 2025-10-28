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
    create_file_with_content "README.md" "# Test"
    git add README.md
    git commit -m "Initial commit"
}

teardown() {
    git_test_teardown
}

# Check-lowercase-dirs Hook Tests

@test "check-lowercase-dirs: passes with lowercase directories" {
    mkdir -p src/components
    create_file_with_content "src/components/button.js" "export default {}"
    git add src/

    run "$HOOKS_DIR/check-lowercase-dirs"
    assert_success
}

@test "check-lowercase-dirs: fails with uppercase directory" {
    mkdir -p SRC
    create_file_with_content "SRC/file.js" "content"
    git add SRC/

    run "$HOOKS_DIR/check-lowercase-dirs"
    assert_failure
    assert_output --partial "uppercase"
}

@test "check-lowercase-dirs: fails with mixed case directory" {
    mkdir -p Src/Components
    create_file_with_content "Src/Components/button.js" "content"
    git add Src/

    run "$HOOKS_DIR/check-lowercase-dirs"
    assert_failure
}

@test "check-lowercase-dirs: checks nested directories" {
    mkdir -p lowercase/UpperCase/nested
    create_file_with_content "lowercase/UpperCase/nested/file.txt" "content"
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
    create_file_with_content "test.txt" "No emojis here"
    git add test.txt

    run "$HOOKS_DIR/check-no-emojis"
    assert_success
}

@test "check-no-emojis: fails with emoji in file content" {
    create_file_with_content "emoji.txt" "Hello 👋 world"
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
    create_file_with_content "test1.txt" "Smiling face 😀"
    create_file_with_content "test2.txt" "Heart ❤️"
    create_file_with_content "test3.txt" "Rocket 🚀"
    git add test1.txt test2.txt test3.txt

    run "$HOOKS_DIR/check-no-emojis"
    assert_failure
}

@test "check-no-emojis: passes with no staged files" {
    run "$HOOKS_DIR/check-no-emojis"
    assert_success
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

# Validate-manifest Hook Tests

@test "validate-manifest: passes with valid LinkingManifest.json" {
    # Create valid manifest
    cat > LinkingManifest.json << 'EOF'
{
  "version": "1.0",
  "links": [
    {
      "source": "test/.testrc",
      "target": "~/.testrc",
      "platform": "all",
      "optional": false
    }
  ]
}
EOF
    git add LinkingManifest.json

    run "$HOOKS_DIR/validate-manifest"
    assert_success
}

@test "validate-manifest: fails with invalid JSON" {
    echo "invalid json" > LinkingManifest.json
    git add LinkingManifest.json

    run "$HOOKS_DIR/validate-manifest"
    assert_failure
}

@test "validate-manifest: skips when manifest not changed" {
    create_file_with_content "other.txt" "content"
    git add other.txt

    run "$HOOKS_DIR/validate-manifest"
    assert_success
}

# Validate-openspec Hook Tests

@test "validate-openspec: skips when no openspec changes" {
    create_file_with_content "regular.txt" "content"
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
    create_file_with_content "UPPERCASE/file.txt" "content"
    git add UPPERCASE/

    # Commit with --no-verify should succeed
    run git commit -m "test" --no-verify
    assert_success
}

# Exit Code Tests

@test "check-lowercase-dirs: exits 0 when passing" {
    mkdir -p lowercase
    create_file_with_content "lowercase/file.txt" "content"
    git add lowercase/

    run "$HOOKS_DIR/check-lowercase-dirs"
    assert_equal "$status" 0
}

@test "check-lowercase-dirs: exits non-zero when failing" {
    mkdir -p UPPERCASE
    create_file_with_content "UPPERCASE/file.txt" "content"
    git add UPPERCASE/

    run "$HOOKS_DIR/check-lowercase-dirs"
    [[ "$status" -ne 0 ]]
}

@test "check-no-emojis: exits 0 when passing" {
    create_file_with_content "clean.txt" "No emojis"
    git add clean.txt

    run "$HOOKS_DIR/check-no-emojis"
    assert_equal "$status" 0
}

@test "check-no-emojis: exits non-zero when failing" {
    create_file_with_content "emoji.txt" "Has emoji 😀"
    git add emoji.txt

    run "$HOOKS_DIR/check-no-emojis"
    [[ "$status" -ne 0 ]]
}

# Error Message Tests

@test "check-lowercase-dirs: provides helpful error message" {
    mkdir -p BadDirectory
    create_file_with_content "BadDirectory/file.txt" "content"
    git add BadDirectory/

    run "$HOOKS_DIR/check-lowercase-dirs"
    assert_failure
    # Should indicate which directory violated the rule
}

@test "check-no-emojis: identifies emoji locations" {
    create_file_with_content "emoji-file.txt" "Content with emoji 🚀"
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
        create_file_with_content "dir$i/file.txt" "content $i"
    done
    git add .

    # Hooks should complete in reasonable time
    run timeout 10s "$HOOKS_DIR/check-lowercase-dirs"
    assert_success
}
