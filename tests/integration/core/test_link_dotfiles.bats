#!/usr/bin/env bats
# Integration tests for convention-based link-dotfiles.py

load '../../helpers/test-helpers'
load '../../helpers/file-helpers'
load '../../helpers/setup-teardown'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'

setup() {
    standard_setup
    export LINK_SCRIPT="$(get_dotfiles_root)/bin/core/link-dotfiles.py"
    export TEST_DOTFILES="$TEST_TEMP_DIR/dotfiles"
    mkdir -p "$TEST_DOTFILES/home"
    export DOTFILES_ROOT="$TEST_DOTFILES"
    export DOTFILES_HOSTNAME="test-host"
}

create_home_file() {
    local path="$1"
    mkdir -p "$(dirname "$TEST_DOTFILES/home/$path")"
    printf '%s\n' "${2:-content}" > "$TEST_DOTFILES/home/$path"
}

create_overlay_file() {
    local tree="$1" path="$2"
    mkdir -p "$(dirname "$TEST_DOTFILES/$tree/$path")"
    printf '%s\n' "${3:-content}" > "$TEST_DOTFILES/$tree/$path"
}

create_command() {
    local domain="$1" name="$2"
    mkdir -p "$TEST_DOTFILES/bin/$domain"
    printf '#!/usr/bin/env bash\n' > "$TEST_DOTFILES/bin/$domain/$name"
    chmod +x "$TEST_DOTFILES/bin/$domain/$name"
}

assert_link_points_to() {
    local expected="$1" link="$2" actual
    expected="$(python3 -c 'from pathlib import Path; import sys; print(Path(sys.argv[1]).resolve())' "$expected")"
    actual="$(readlink "$link")"
    [[ "$actual" == "$expected" ]] || {
        printf 'expected %s, got %s\n' "$expected" "$actual" >&2
        return 1
    }
}

@test "link-dotfiles: help describes convention-based linking" {
    run python3 "$LINK_SCRIPT" --help
    assert_success
    assert_output --partial "Convention-based"
}

@test "link-dotfiles: ignores a malformed legacy manifest" {
    create_home_file ".example"
    printf 'not json' > "$TEST_DOTFILES/LinkingManifest.json"
    run python3 "$LINK_SCRIPT" --dry-run
    assert_success
    assert_output --partial ".example"
}

@test "link-dotfiles: maps common files recursively below HOME" {
    create_home_file ".linker-test/example/config"
    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success
    assert_link_points_to "$TEST_DOTFILES/home/.linker-test/example/config" "$HOME/.linker-test/example/config"
}

@test "link-dotfiles: dry-run creates neither links nor parent directories" {
    create_home_file ".linker-test/example/config"
    run python3 "$LINK_SCRIPT" --dry-run
    assert_success
    refute test -e "$HOME/.linker-test"
    refute test -L "$HOME/.linker-test/example/config"
}

@test "link-dotfiles: platform overlay wins over common source" {
    create_home_file ".linker-test/example/config" common
    create_overlay_file "home-$(uname | tr '[:upper:]' '[:lower:]')" ".linker-test/example/config" platform
    run python3 "$LINK_SCRIPT" --apply --yes --verbose
    assert_success
    assert_link_points_to "$TEST_DOTFILES/home-$(uname | tr '[:upper:]' '[:lower:]')/.linker-test/example/config" "$HOME/.linker-test/example/config"
    assert_output --partial "home-$(uname | tr '[:upper:]' '[:lower:]')"
}

@test "link-dotfiles: hostname overlay wins over platform source" {
    local platform
    platform="$(uname | tr '[:upper:]' '[:lower:]')"
    create_overlay_file "home-$platform" ".example" platform
    create_overlay_file "home-host-test-host" ".example" host
    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success
    assert_link_points_to "$TEST_DOTFILES/home-host-test-host/.example" "$HOME/.example"
}

@test "link-dotfiles: only current platform overlay is discovered" {
    create_overlay_file "home-linux" ".linux-only"
    create_overlay_file "home-darwin" ".darwin-only"
    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success
    if [[ "$(uname)" == Darwin ]]; then
        assert_symlink_exists "$HOME/.darwin-only"
        refute test -e "$HOME/.linux-only"
    else
        assert_symlink_exists "$HOME/.linux-only"
        refute test -e "$HOME/.darwin-only"
    fi
}

@test "link-dotfiles: discovers executable public commands" {
    create_command core example-command
    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success
    assert_link_points_to "$TEST_DOTFILES/bin/core/example-command" "$HOME/.local/bin/example-command"
    refute test -e "$HOME/local/bin/example-command"
}

@test "link-dotfiles: ignores nested and non-executable command files" {
    create_command core public-command
    mkdir -p "$TEST_DOTFILES/bin/core/nested"
    touch "$TEST_DOTFILES/bin/core/nested/hidden" "$TEST_DOTFILES/bin/core/not-public"
    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success
    assert_symlink_exists "$HOME/.local/bin/public-command"
    refute test -e "$HOME/.local/bin/hidden"
    refute test -e "$HOME/.local/bin/not-public"
}

@test "link-dotfiles: duplicate commands fail before filesystem mutation" {
    create_home_file ".valid"
    create_command core duplicate
    create_command git duplicate
    run python3 "$LINK_SCRIPT" --apply --yes
    assert_failure
    assert_output --partial "Duplicate command name"
    refute test -e "$HOME/.valid"
}

@test "link-dotfiles: collision fails before filesystem mutation" {
    create_home_file ".valid"
    create_home_file ".collision"
    printf 'existing\n' > "$HOME/.collision"
    run python3 "$LINK_SCRIPT" --apply --yes
    assert_failure
    assert_output --partial "Collision"
    refute test -e "$HOME/.valid"
}

@test "link-dotfiles: force and yes explicitly replace collisions" {
    create_home_file ".collision"
    printf 'existing\n' > "$HOME/.collision"
    run python3 "$LINK_SCRIPT" --apply --force --yes
    assert_success
    assert_link_points_to "$TEST_DOTFILES/home/.collision" "$HOME/.collision"
}

@test "link-dotfiles: correct existing links are idempotent" {
    create_home_file ".example"
    ln -s "$TEST_DOTFILES/home/.example" "$HOME/.example"
    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success
    assert_output --partial "already linked"
}

@test "link-dotfiles: records a versioned ownership ledger" {
    create_home_file ".example"
    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success
    local ledger="$HOME/.local/state/dotfiles/links.json"
    assert_file_exists "$ledger"
    run python3 -c 'import json, sys; state = json.load(open(sys.argv[1])); assert state["version"] == 1; assert state["repository_id"]; assert state["links"] == [{"source": "home/.example", "target": sys.argv[2]}]' "$ledger" "$HOME/.example"
    assert_success
}

@test "link-dotfiles: source symlinks are not managed" {
    create_home_file ".real"
    ln -s "$TEST_DOTFILES/home/.real" "$TEST_DOTFILES/home/.source-link"
    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success
    assert_symlink_exists "$HOME/.real"
    refute test -e "$HOME/.source-link"
}
