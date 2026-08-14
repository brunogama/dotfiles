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
    export XDG_STATE_HOME="$TEST_TEMP_DIR/state"
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

@test "link-dotfiles: ignores a malformed historical manifest" {
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

@test "link-dotfiles: commands-only skips home-tree sources" {
    create_home_file ".not-linked"
    create_command core public-command
    run python3 "$LINK_SCRIPT" --commands-only --apply --yes
    assert_success
    refute test -e "$HOME/.not-linked"
    assert_link_points_to "$TEST_DOTFILES/bin/core/public-command" "$HOME/.local/bin/public-command"
}

@test "link-dotfiles: commands-only preserves prior ownership state" {
    create_home_file ".tracked"
    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success
    create_command core public-command
    run python3 "$LINK_SCRIPT" --commands-only --apply --yes
    assert_success
    rm "$TEST_DOTFILES/home/.tracked"
    run python3 "$LINK_SCRIPT" --prune --apply
    assert_success
    refute test -e "$HOME/.tracked"
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

@test "link-dotfiles: preserves Nix-managed targets even with force" {
    create_home_file ".gitconfig"
    create_home_file ".linker-test/unmanaged"
    local nix_source="$TEST_TEMP_DIR/nix-managed-gitconfig"
    printf 'nix-managed\n' > "$nix_source"
    nix_source="$(python3 -c 'from pathlib import Path; import sys; print(Path(sys.argv[1]).resolve())' "$nix_source")"
    rm -f "$HOME/.gitconfig"
    ln -s "$nix_source" "$HOME/.gitconfig"

    run python3 "$LINK_SCRIPT" --apply --force --yes

    assert_success
    assert_output --partial "Skipped (Nix-managed): $HOME/.gitconfig"
    assert_link_points_to "$nix_source" "$HOME/.gitconfig"
    assert_link_points_to "$TEST_DOTFILES/home/.linker-test/unmanaged" "$HOME/.linker-test/unmanaged"
    local state_file="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/links.json"
    refute grep -Fq '"target": "'"$HOME/.gitconfig"'"' "$state_file"
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
    local ledger="$XDG_STATE_HOME/dotfiles/links.json"
    assert_file_exists "$ledger"
    run python3 -c 'import json, pathlib, sys; state = json.load(open(sys.argv[1])); assert state["version"] == 1; assert state["repository_id"]; assert state["links"] == [{"source": str(pathlib.Path(sys.argv[2]).resolve()), "target": sys.argv[3]}]' "$ledger" "$TEST_DOTFILES/home/.example" "$HOME/.example"
    assert_success
}

@test "link-dotfiles: records completed links after an apply failure and converges on rerun" {
    create_home_file ".first"
    create_home_file ".second"

    run python3 "$LINK_SCRIPT" --apply --yes --self-test-fail-after 1
    assert_failure
    assert_output --partial "injected filesystem failure"

    local ledger="$XDG_STATE_HOME/dotfiles/links.json"
    run python3 -c 'import json, pathlib, sys; state = json.load(open(sys.argv[1])); assert state["links"] == [{"source": str(pathlib.Path(sys.argv[2]).resolve()), "target": sys.argv[3]}]' "$ledger" "$TEST_DOTFILES/home/.first" "$HOME/.first"
    assert_success
    assert_link_points_to "$TEST_DOTFILES/home/.first" "$HOME/.first"
    refute test -e "$HOME/.second"

    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success
    assert_link_points_to "$TEST_DOTFILES/home/.second" "$HOME/.second"
    run python3 -c 'import json, pathlib, sys; state = json.load(open(sys.argv[1])); assert state["links"] == [{"source": str(pathlib.Path(sys.argv[2]).resolve()), "target": sys.argv[3]}, {"source": str(pathlib.Path(sys.argv[4]).resolve()), "target": sys.argv[5]}]' "$ledger" "$TEST_DOTFILES/home/.first" "$HOME/.first" "$TEST_DOTFILES/home/.second" "$HOME/.second"
    assert_success
}

@test "link-dotfiles: prune removes a stale tracked symlink" {
    create_home_file ".stale"
    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success
    rm "$TEST_DOTFILES/home/.stale"
    run python3 "$LINK_SCRIPT" --prune --apply
    assert_success
    refute test -L "$HOME/.stale"
}

@test "link-dotfiles: prune preserves desired command links" {
    create_command core retained-command
    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success
    run python3 "$LINK_SCRIPT" --prune --apply
    assert_success
    assert_link_points_to "$TEST_DOTFILES/bin/core/retained-command" "$HOME/.local/bin/retained-command"
}

@test "link-dotfiles: prune rejects a foreign ownership ledger" {
    mkdir -p "$XDG_STATE_HOME/dotfiles"
    printf '{"version": 1, "repository_id": "foreign", "links": []}\n' > "$XDG_STATE_HOME/dotfiles/links.json"
    run python3 "$LINK_SCRIPT" --prune --apply
    assert_failure
    assert_output --partial "Invalid or missing ownership ledger"
}

@test "link-dotfiles: prune removes a tracked link from a prior checkout" {
    local prior_root="$TEST_TEMP_DIR/prior-checkout"
    mkdir -p "$prior_root/home" "$XDG_STATE_HOME/dotfiles"
    printf 'old\n' > "$prior_root/home/.moved"
    ln -s "$prior_root/home/.moved" "$HOME/.moved"
    create_home_file ".moved" new
    local repository_id
    repository_id="$(python3 -c 'import hashlib, pathlib, sys; print(hashlib.sha256(str(pathlib.Path(sys.argv[1]).resolve()).encode()).hexdigest())' "$TEST_DOTFILES")"
    printf '{"version": 1, "repository_id": "%s", "links": [{"source": "%s", "target": "%s"}]}\n' "$repository_id" "$prior_root/home/.moved" "$HOME/.moved" > "$XDG_STATE_HOME/dotfiles/links.json"
    run python3 "$LINK_SCRIPT" --prune --apply
    assert_success
    refute test -L "$HOME/.moved"
}

@test "link-dotfiles: prune preserves untracked targets" {
    local repository_id
    repository_id="$(python3 -c 'import hashlib, pathlib, sys; print(hashlib.sha256(str(pathlib.Path(sys.argv[1]).resolve()).encode()).hexdigest())' "$TEST_DOTFILES")"
    mkdir -p "$XDG_STATE_HOME/dotfiles"
    printf '{"version": 1, "repository_id": "%s", "links": []}\n' "$repository_id" > "$XDG_STATE_HOME/dotfiles/links.json"
    ln -s /tmp/untracked "$HOME/.untracked"
    printf 'regular\n' > "$HOME/.regular"
    mkdir "$HOME/.directory"
    run python3 "$LINK_SCRIPT" --prune --apply
    assert_success
    assert_symlink_exists "$HOME/.untracked"
    assert_file_exists "$HOME/.regular"
    assert_dir_exists "$HOME/.directory"
}

@test "link-dotfiles: prune dry-run leaves a stale tracked symlink" {
    create_home_file ".stale"
    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success
    rm "$TEST_DOTFILES/home/.stale"
    run python3 "$LINK_SCRIPT" --prune --dry-run
    assert_success
    assert_symlink_exists "$HOME/.stale"
    assert_output --partial "Would prune"
}

@test "link-dotfiles: migrates a proven legacy command link" {
    create_command core legacy-command
    mkdir -p "$HOME/local/bin"
    ln -s "$TEST_DOTFILES/bin/core/legacy-command" "$HOME/local/bin/legacy-command"
    run python3 "$LINK_SCRIPT" --migrate-legacy-bin --apply
    assert_success
    refute test -L "$HOME/local/bin/legacy-command"
    assert_link_points_to "$TEST_DOTFILES/bin/core/legacy-command" "$HOME/.local/bin/legacy-command"
}

@test "link-dotfiles: migration preserves unmanaged legacy entries" {
    create_command core managed-command
    mkdir -p "$HOME/local/bin"
    printf 'custom\n' > "$HOME/local/bin/custom-command"
    ln -s /tmp/unmanaged "$HOME/local/bin/managed-command"
    run python3 "$LINK_SCRIPT" --migrate-legacy-bin --apply
    assert_success
    assert_file_exists "$HOME/local/bin/custom-command"
    assert_symlink_exists "$HOME/local/bin/managed-command"
    refute test -e "$HOME/.local/bin/managed-command"
    assert_output --partial "Preserving"
}

@test "link-dotfiles: migration leaves unproven files directories and symlinks untouched without force and yes" {
    create_command core managed-command
    mkdir -p "$HOME/local/bin/unproven-directory"
    printf 'custom\n' > "$HOME/local/bin/unproven-file"
    ln -s /tmp/unproven "$HOME/local/bin/managed-command"
    run python3 "$LINK_SCRIPT" --migrate-legacy-bin --apply --force
    assert_success
    assert_file_exists "$HOME/local/bin/unproven-file"
    assert_dir_exists "$HOME/local/bin/unproven-directory"
    assert_symlink_exists "$HOME/local/bin/managed-command"
    refute test -e "$XDG_STATE_HOME/dotfiles/legacy-bin-backups"
    assert_output --partial "Preserving unproven"
}

@test "link-dotfiles: force and yes move unproven legacy entries into XDG state backups" {
    create_command core managed-command
    mkdir -p "$HOME/local/bin/unproven-directory"
    printf 'custom\n' > "$HOME/local/bin/unproven-file"
    printf 'nested\n' > "$HOME/local/bin/unproven-directory/file"
    ln -s /tmp/unproven "$HOME/local/bin/managed-command"
    run python3 "$LINK_SCRIPT" --migrate-legacy-bin --apply --force --yes
    assert_success
    refute test -e "$HOME/local/bin/unproven-file"
    refute test -e "$HOME/local/bin/unproven-directory"
    refute test -L "$HOME/local/bin/managed-command"
    local backup_root
    backup_root="$(find "$XDG_STATE_HOME/dotfiles/legacy-bin-backups" -mindepth 1 -maxdepth 1 -type d)"
    assert_file_exists "$backup_root/unproven-file"
    assert_file_exists "$backup_root/unproven-directory/file"
    assert_symlink_exists "$backup_root/managed-command"
    assert_output --partial "Backed up unproven legacy entry"
    run python3 "$LINK_SCRIPT" --migrate-legacy-bin --apply --force --yes
    assert_success
    assert_equal "$(find "$XDG_STATE_HOME/dotfiles/legacy-bin-backups" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')" "1"
}

@test "link-dotfiles: migration dry-run changes neither legacy nor command links" {
    create_command core legacy-command
    mkdir -p "$HOME/local/bin"
    ln -s "$TEST_DOTFILES/bin/core/legacy-command" "$HOME/local/bin/legacy-command"
    run python3 "$LINK_SCRIPT" --migrate-legacy-bin --dry-run
    assert_success
    assert_symlink_exists "$HOME/local/bin/legacy-command"
    refute test -e "$HOME/.local/bin/legacy-command"
    assert_output --partial "Would migrate"
}

@test "link-dotfiles: migration refuses a conflicting command target" {
    create_command core legacy-command
    mkdir -p "$HOME/local/bin" "$HOME/.local/bin"
    ln -s "$TEST_DOTFILES/bin/core/legacy-command" "$HOME/local/bin/legacy-command"
    printf 'conflict\n' > "$HOME/.local/bin/legacy-command"
    run python3 "$LINK_SCRIPT" --migrate-legacy-bin --apply
    assert_failure
    assert_symlink_exists "$HOME/local/bin/legacy-command"
    assert_file_exists "$HOME/.local/bin/legacy-command"
    assert_output --partial "Collision"
}

@test "link-dotfiles: Folder Actions link uses the canonical script extension" {
    if [[ "$(uname)" != Darwin ]]; then
        skip "Folder Actions are Darwin-only"
    fi
    mkdir -p "$TEST_DOTFILES/bin/folder-action-scripts"
    printf 'compiled script\n' > "$TEST_DOTFILES/bin/folder-action-scripts/compress-video-automation.scpt"
    run python3 "$LINK_SCRIPT" --folder-actions --apply --yes
    assert_success
    assert_link_points_to "$TEST_DOTFILES/bin/folder-action-scripts/compress-video-automation.scpt" "$HOME/Library/Scripts/Folder Action Scripts/compress-video-automation.scpt"
    refute test -e "$HOME/Library/Scripts/Folder Action Scripts/compress-video-automation.scptn"
}

@test "link-dotfiles: Folder Actions dry-run does not create target directories" {
    if [[ "$(uname)" != Darwin ]]; then
        skip "Folder Actions are Darwin-only"
    fi
    mkdir -p "$TEST_DOTFILES/bin/folder-action-scripts"
    printf 'compiled script\n' > "$TEST_DOTFILES/bin/folder-action-scripts/compress-video-automation.scpt"
    run python3 "$LINK_SCRIPT" --folder-actions --dry-run
    assert_success
    refute test -e "$HOME/Library"
    assert_output --partial "Would create"
}

@test "link-dotfiles: Folder Actions collision preserves existing target" {
    if [[ "$(uname)" != Darwin ]]; then
        skip "Folder Actions are Darwin-only"
    fi
    mkdir -p "$TEST_DOTFILES/bin/folder-action-scripts" "$HOME/Library/Scripts/Folder Action Scripts"
    printf 'compiled script\n' > "$TEST_DOTFILES/bin/folder-action-scripts/compress-video-automation.scpt"
    printf 'existing\n' > "$HOME/Library/Scripts/Folder Action Scripts/compress-video-automation.scpt"
    run python3 "$LINK_SCRIPT" --folder-actions --apply --yes
    assert_failure
    assert_file_exists "$HOME/Library/Scripts/Folder Action Scripts/compress-video-automation.scpt"
    assert_output --partial "Collision"
}

@test "install-folder-actions: delegates to the shared linker" {
    local installer="$(get_dotfiles_root)/bin/macos/install-folder-actions"
    mkdir -p "$TEST_DOTFILES/bin/folder-action-scripts"
    printf 'compiled script\n' > "$TEST_DOTFILES/bin/folder-action-scripts/compress-video-automation.scpt"
    run "$installer" --dry-run
    if [[ "$(uname)" == Darwin ]]; then
        assert_success
        assert_output --partial "Folder Action Scripts"
    else
        assert_success
        assert_output --partial "Skipping Folder Actions"
    fi
}

@test "link-dotfiles: source symlinks are not managed" {
    create_home_file ".real"
    ln -s "$TEST_DOTFILES/home/.real" "$TEST_DOTFILES/home/.source-link"
    run python3 "$LINK_SCRIPT" --apply --yes
    assert_success
    assert_symlink_exists "$HOME/.real"
    refute test -e "$HOME/.source-link"
}
