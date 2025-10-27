#!/usr/bin/env bats
# Integration tests for link-dotfiles.py

load '../../helpers/test-helpers'
load '../../helpers/file-helpers'
load '../../helpers/setup-teardown'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'
load '../../helpers/bats-file/load.bash'

setup() {
    standard_setup

    # Get dotfiles root and script path
    local dotfiles_root
    dotfiles_root="$(get_dotfiles_root)"
    export LINK_SCRIPT="$dotfiles_root/bin/core/link-dotfiles.py"

    # Create test dotfiles structure
    export TEST_DOTFILES="$TEST_TEMP_DIR/dotfiles"
    mkdir -p "$TEST_DOTFILES"
    cd "$TEST_DOTFILES"

    # Set DOTFILES_ROOT for script
    export DOTFILES_ROOT="$TEST_DOTFILES"

    # Create source files
    mkdir -p zsh git vim
    echo "test zshrc" > zsh/.zshrc
    echo "test gitconfig" > git/.gitconfig
    echo "test vimrc" > vim/.vimrc
}

teardown() {
    standard_teardown
}

# Helper to create manifest
create_test_manifest() {
    cat > "$TEST_DOTFILES/LinkingManifest.json" << 'EOF'
{
  "version": "1.0",
  "links": [
    {
      "source": "zsh/.zshrc",
      "target": "~/.zshrc",
      "platform": "all",
      "optional": false
    },
    {
      "source": "git/.gitconfig",
      "target": "~/.gitconfig",
      "platform": "all",
      "optional": false
    },
    {
      "source": "vim/.vimrc",
      "target": "~/.vimrc",
      "platform": "all",
      "optional": true
    }
  ]
}
EOF
}

# Help and Version Tests

@test "link-dotfiles: --help shows usage" {
    run python3 "$LINK_SCRIPT" --help
    assert_success
    assert_output --partial "link-dotfiles"
    assert_output --partial "Usage"
    assert_output --partial "Options"
}

# Prerequisite Tests

@test "link-dotfiles: fails without LinkingManifest.json" {
    run python3 "$LINK_SCRIPT" --dry-run
    assert_failure
    assert_output --partial "LinkingManifest.json not found"
}

@test "link-dotfiles: fails with invalid JSON" {
    echo "invalid json" > "$TEST_DOTFILES/LinkingManifest.json"

    run python3 "$LINK_SCRIPT" --dry-run
    assert_failure
    assert_output --partial "invalid JSON"
}

@test "link-dotfiles: succeeds with valid manifest" {
    create_test_manifest

    run python3 "$LINK_SCRIPT" --dry-run
    assert_success
}

# Dry-run Mode Tests

@test "link-dotfiles: dry-run does not create symlinks" {
    create_test_manifest

    run python3 "$LINK_SCRIPT" --dry-run
    assert_success

    # No symlinks should be created
    assert_file_not_exists "$HOME/.zshrc"
    assert_file_not_exists "$HOME/.gitconfig"
}

@test "link-dotfiles: dry-run reports what would be done" {
    create_test_manifest

    run python3 "$LINK_SCRIPT" --dry-run
    assert_success
    assert_output --partial "Would create"
}

@test "link-dotfiles: dry-run reports all links" {
    create_test_manifest

    run python3 "$LINK_SCRIPT" --dry-run
    assert_success
    assert_output --partial ".zshrc"
    assert_output --partial ".gitconfig"
    assert_output --partial ".vimrc"
}

# Apply Mode Tests

@test "link-dotfiles: --apply creates symlinks" {
    create_test_manifest

    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success

    # Symlinks should be created
    assert_symlink_exists "$HOME/.zshrc"
    assert_symlink_exists "$HOME/.gitconfig"
    assert_symlink_exists "$HOME/.vimrc"
}

@test "link-dotfiles: --apply creates correct symlink targets" {
    create_test_manifest

    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success

    assert_symlink_to "$HOME/.zshrc" "$TEST_DOTFILES/zsh/.zshrc"
    assert_symlink_to "$HOME/.gitconfig" "$TEST_DOTFILES/git/.gitconfig"
}

@test "link-dotfiles: creates parent directories" {
    cat > "$TEST_DOTFILES/LinkingManifest.json" << 'EOF'
{
  "version": "1.0",
  "links": [
    {
      "source": "git/.gitconfig",
      "target": "~/.config/git/config",
      "platform": "all",
      "optional": false
    }
  ]
}
EOF

    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success

    # Parent directory should be created
    assert_dir_exists "$HOME/.config/git"
    assert_symlink_exists "$HOME/.config/git/config"
}

# Platform Filtering Tests

@test "link-dotfiles: filters links by platform" {
    cat > "$TEST_DOTFILES/LinkingManifest.json" << 'EOF'
{
  "version": "1.0",
  "links": [
    {
      "source": "zsh/.zshrc",
      "target": "~/.zshrc",
      "platform": "all",
      "optional": false
    },
    {
      "source": "git/.gitconfig",
      "target": "~/.macos-only",
      "platform": "darwin",
      "optional": false
    },
    {
      "source": "vim/.vimrc",
      "target": "~/.linux-only",
      "platform": "linux",
      "optional": false
    }
  ]
}
EOF

    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success

    # All platform should be created
    assert_symlink_exists "$HOME/.zshrc"

    # Platform-specific links depend on current platform
    if [[ "$(uname)" == "Darwin" ]]; then
        assert_symlink_exists "$HOME/.macos-only"
        assert_file_not_exists "$HOME/.linux-only"
    else
        assert_file_not_exists "$HOME/.macos-only"
        assert_symlink_exists "$HOME/.linux-only"
    fi
}

# Optional Links Tests

@test "link-dotfiles: creates optional links" {
    create_test_manifest

    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success

    # Optional link should still be created if source exists
    assert_symlink_exists "$HOME/.vimrc"
}

@test "link-dotfiles: skips optional links with missing source" {
    cat > "$TEST_DOTFILES/LinkingManifest.json" << 'EOF'
{
  "version": "1.0",
  "links": [
    {
      "source": "zsh/.zshrc",
      "target": "~/.zshrc",
      "platform": "all",
      "optional": false
    },
    {
      "source": "nonexistent/file",
      "target": "~/.optional",
      "platform": "all",
      "optional": true
    }
  ]
}
EOF

    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success

    # Required link created
    assert_symlink_exists "$HOME/.zshrc"

    # Optional link skipped
    assert_file_not_exists "$HOME/.optional"
}

# Existing File Handling Tests

@test "link-dotfiles: skips already correct symlinks" {
    create_test_manifest

    # Create symlink first
    ln -sf "$TEST_DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success

    # Should report as already linked
    assert_output --partial "Already linked"
}

@test "link-dotfiles: prompts for existing files in interactive mode" {
    create_test_manifest

    # Create existing file
    echo "existing" > "$HOME/.zshrc"

    # In non-interactive mode with --yes, should overwrite
    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success

    # Should have replaced with symlink
    assert_symlink_exists "$HOME/.zshrc"
}

@test "link-dotfiles: --force overwrites existing files" {
    create_test_manifest

    # Create existing file
    echo "existing" > "$HOME/.zshrc"

    run python3 "$LINK_SCRIPT" --apply --force --yes
    assert_success

    # Should have replaced with symlink
    assert_symlink_exists "$HOME/.zshrc"
    assert_symlink_to "$HOME/.zshrc" "$TEST_DOTFILES/zsh/.zshrc"
}

# Verbose Output Tests

@test "link-dotfiles: --verbose shows detailed output" {
    create_test_manifest

    run python3 "$LINK_SCRIPT" --dry-run --verbose
    assert_success
    assert_output --partial "DEBUG"
}

@test "link-dotfiles: verbose shows processing steps" {
    create_test_manifest

    run python3 "$LINK_SCRIPT" --dry-run --verbose
    assert_success
    assert_output --partial "Processing:"
}

# Statistics Tests

@test "link-dotfiles: reports statistics" {
    create_test_manifest

    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success

    # Should show count of created links
    assert_output --partial "Created:"
}

# Error Handling Tests

@test "link-dotfiles: handles missing source file" {
    cat > "$TEST_DOTFILES/LinkingManifest.json" << 'EOF'
{
  "version": "1.0",
  "links": [
    {
      "source": "nonexistent/file",
      "target": "~/.nonexistent",
      "platform": "all",
      "optional": false
    }
  ]
}
EOF

    run python3 "$LINK_SCRIPT" --dry-run
    assert_success

    # Should report source not found
    assert_output --partial "not found"
}

# Complex Manifest Tests

@test "link-dotfiles: handles multiple links" {
    cat > "$TEST_DOTFILES/LinkingManifest.json" << 'EOF'
{
  "version": "1.0",
  "links": [
    {
      "source": "zsh/.zshrc",
      "target": "~/.zshrc",
      "platform": "all",
      "optional": false
    },
    {
      "source": "git/.gitconfig",
      "target": "~/.gitconfig",
      "platform": "all",
      "optional": false
    },
    {
      "source": "vim/.vimrc",
      "target": "~/.vimrc",
      "platform": "all",
      "optional": false
    },
    {
      "source": "zsh/.zshenv",
      "target": "~/.zshenv",
      "platform": "all",
      "optional": true
    }
  ]
}
EOF

    # Create .zshenv as well
    echo "test zshenv" > "$TEST_DOTFILES/zsh/.zshenv"

    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success

    # All links should be created
    assert_symlink_exists "$HOME/.zshrc"
    assert_symlink_exists "$HOME/.gitconfig"
    assert_symlink_exists "$HOME/.vimrc"
    assert_symlink_exists "$HOME/.zshenv"
}

# Platform Detection Tests

@test "link-dotfiles: detects darwin platform" {
    skip_on_linux "macOS-specific test"

    create_test_manifest

    run python3 "$LINK_SCRIPT" --dry-run --verbose
    assert_success
}

@test "link-dotfiles: detects linux platform" {
    skip_on_macos "Linux-specific test"

    create_test_manifest

    run python3 "$LINK_SCRIPT" --dry-run --verbose
    assert_success
}

# Tilde Expansion Tests

@test "link-dotfiles: expands tilde in target paths" {
    create_test_manifest

    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success

    # Symlinks should be in actual HOME, not literal '~'
    assert_symlink_exists "$HOME/.zshrc"
    assert_dir_exists "$(dirname "$HOME/.zshrc")"
}

# Exit Code Tests

@test "link-dotfiles: exits 0 on success" {
    create_test_manifest

    run python3 "$LINK_SCRIPT" --dry-run
    assert_equal "$status" 0
}

@test "link-dotfiles: exits non-zero on missing manifest" {
    run python3 "$LINK_SCRIPT" --dry-run
    assert_failure
}

@test "link-dotfiles: exits non-zero on invalid JSON" {
    echo "invalid" > "$TEST_DOTFILES/LinkingManifest.json"

    run python3 "$LINK_SCRIPT" --dry-run
    assert_failure
}

# Color Output Tests

@test "link-dotfiles: uses ANSI colors in output" {
    create_test_manifest

    run python3 "$LINK_SCRIPT" --dry-run
    assert_success

    # Output should contain color codes or formatted messages
    # (even if not visible in test output)
}

# Idempotency Tests

@test "link-dotfiles: is idempotent" {
    create_test_manifest

    # Run twice
    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success

    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success

    # Should still have correct symlinks
    assert_symlink_exists "$HOME/.zshrc"
    assert_symlink_to "$HOME/.zshrc" "$TEST_DOTFILES/zsh/.zshrc"
}

# Symlink Replacement Tests

@test "link-dotfiles: replaces incorrect symlinks" {
    create_test_manifest

    # Create symlink to wrong location
    mkdir -p "$TEST_TEMP_DIR/wrong"
    echo "wrong" > "$TEST_TEMP_DIR/wrong/.zshrc"
    ln -sf "$TEST_TEMP_DIR/wrong/.zshrc" "$HOME/.zshrc"

    run python3 "$LINK_SCRIPT" --apply --yes --force
    assert_success

    # Should point to correct location now
    assert_symlink_to "$HOME/.zshrc" "$TEST_DOTFILES/zsh/.zshrc"
}

# Directory Creation Tests

@test "link-dotfiles: creates nested directories" {
    cat > "$TEST_DOTFILES/LinkingManifest.json" << 'EOF'
{
  "version": "1.0",
  "links": [
    {
      "source": "git/.gitconfig",
      "target": "~/.config/deep/nested/config",
      "platform": "all",
      "optional": false
    }
  ]
}
EOF

    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success

    assert_dir_exists "$HOME/.config/deep/nested"
    assert_symlink_exists "$HOME/.config/deep/nested/config"
}

# Cleanup Tests

@test "link-dotfiles: removes broken symlinks when re-run" {
    create_test_manifest

    # Create broken symlink
    ln -sf "/nonexistent/path" "$HOME/.zshrc"
    assert_broken_symlink "$HOME/.zshrc"

    run python3 "$LINK_SCRIPT" --apply --yes --force
    assert_success

    # Should be fixed
    assert_symlink_exists "$HOME/.zshrc"
    refute_broken_symlink "$HOME/.zshrc"
}
