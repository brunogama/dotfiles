#!/usr/bin/env bats

load '../../helpers/setup-teardown'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'
load '../../helpers/bats-file/load.bash'

setup() {
    standard_setup

    export REAL_DOTFILES_ROOT
    REAL_DOTFILES_ROOT="$(cd "$BATS_TEST_DIRNAME/../../.." && pwd)"
    export SYNC_SCRIPT="$REAL_DOTFILES_ROOT/bin/core/nvm-npm-sync"
    export NVM_DIR="$HOME/.nvm"
    export NVM_TEST_VERSION="v24.9.0"
    export NVM_TEST_LOG="$TEST_TEMP_DIR/operations.log"
    export MANAGED_STATE_NAME=".dotfiles-managed-npm-packages"
    export NVM_TEST_REAL_NODE
    NVM_TEST_REAL_NODE="$(command -v node || true)"
    [[ -x "$NVM_TEST_REAL_NODE" ]] || skip "node is required for the nvm fixture"

    export TEST_MANIFEST_DIR="$TEST_TEMP_DIR/manifest"
    export MOCK_BIN="$TEST_TEMP_DIR/mock-bin"
    export COMPETING_BIN="$TEST_TEMP_DIR/competing-bin"
    export NVM_TEST_NPM_FIXTURE="$TEST_TEMP_DIR/npm-fixture"
    export NVM_TEST_NVM_SH_FIXTURE="$TEST_TEMP_DIR/nvm-fixture.sh"
    export NVM_TEST_INSTALLER_FIXTURE="$TEST_TEMP_DIR/nvm-installer.sh"
    mkdir -p "$TEST_MANIFEST_DIR" "$MOCK_BIN" "$COMPETING_BIN"

    create_npm_fixture
    create_nvm_fixture
    create_installer_fixture
    create_curl_fixture
    create_shasum_fixture
    create_competing_runtime_fixtures
    export PATH="$COMPETING_BIN:$PATH"
}

teardown() {
    standard_teardown
}

write_manifest() {
    local dependencies="$1"

    printf '{\n  "name": "test-global-tools",\n  "private": true,\n  "dependencies": %s\n}\n' \
        "$dependencies" > "$TEST_MANIFEST_DIR/package.json"
}

create_npm_fixture() {
    cat > "$NVM_TEST_NPM_FIXTURE" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

printf 'npm' >> "$NVM_TEST_LOG"
printf ' %s' "$@" >> "$NVM_TEST_LOG"
printf '\n' >> "$NVM_TEST_LOG"

prefix=""
command_name=""
packages=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        --prefix)
            prefix="$2"
            shift 2
            ;;
        --global|-g|--no-audit|--no-fund)
            shift
            ;;
        prefix|install|uninstall)
            command_name="$1"
            shift
            ;;
        *)
            packages+=("$1")
            shift
            ;;
    esac
done

runtime_node="$(command -v node)"
printf 'npm-runtime-node %s\n' "$runtime_node" >> "$NVM_TEST_LOG"
if [[ "$runtime_node" != "$prefix/bin/node" ]]; then
    printf 'npm ran with %s instead of %s/bin/node\n' "$runtime_node" "$prefix" >&2
    exit 96
fi

case "$command_name" in
    prefix)
        printf '%s\n' "$prefix"
        ;;
    install)
        for spec in "${packages[@]}"; do
            package_name="${spec%@*}"
            version="${spec##*@}"
            package_dir="$prefix/lib/node_modules/$package_name"
            mkdir -p "$package_dir" "$prefix/bin"
            printf '{"name":"%s","version":"%s"}\n' \
                "$package_name" "$version" > "$package_dir/package.json"
        done
        ;;
    uninstall)
        for package_name in "${packages[@]}"; do
            rm -rf -- "$prefix/lib/node_modules/$package_name"
        done
        ;;
    *)
        printf 'unexpected npm command\n' >&2
        exit 2
        ;;
esac
EOF
    chmod +x "$NVM_TEST_NPM_FIXTURE"
}

create_competing_runtime_fixtures() {
    cat > "$COMPETING_BIN/node" <<'EOF'
#!/usr/bin/env bash
printf 'competing node must not run\n' >&2
exit 97
EOF
    cat > "$COMPETING_BIN/npm" <<'EOF'
#!/usr/bin/env bash
printf 'competing npm must not run\n' >&2
exit 98
EOF
    chmod +x "$COMPETING_BIN/node" "$COMPETING_BIN/npm"
}

create_nvm_fixture() {
    cat > "$NVM_TEST_NVM_SH_FIXTURE" <<'EOF'
nvm() {
    printf 'nvm' >> "$NVM_TEST_LOG"
    printf ' %s' "$@" >> "$NVM_TEST_LOG"
    printf '\n' >> "$NVM_TEST_LOG"

    local command_name="${1-}"
    shift || true
    case "$command_name" in
        install)
            [[ "${1-}" == "node" ]] || return 2
            local prefix="$NVM_DIR/versions/node/$NVM_TEST_VERSION"
            mkdir -p "$prefix/bin" "$prefix/lib/node_modules"
            ln -sfn "$NVM_TEST_REAL_NODE" "$prefix/bin/node"
            cp "$NVM_TEST_NPM_FIXTURE" "$prefix/bin/npm"
            chmod +x "$prefix/bin/npm"
            ;;
        version)
            local requested="${1-}"
            if [[ "$requested" == "node" ]]; then
                printf '%s\n' "$NVM_TEST_VERSION"
            elif [[ "$requested" == "default" && -f "$NVM_DIR/alias/default" ]]; then
                cat "$NVM_DIR/alias/default"
            elif [[ -d "$NVM_DIR/versions/node/$requested" ]]; then
                printf '%s\n' "$requested"
            else
                printf 'N/A\n'
            fi
            ;;
        alias)
            [[ "${1-}" == "default" && -n "${2-}" ]] || return 2
            mkdir -p "$NVM_DIR/alias"
            printf '%s\n' "$2" > "$NVM_DIR/alias/default"
            ;;
        use)
            local requested=""
            local argument
            for argument in "$@"; do
                [[ "$argument" == --* ]] || requested="$argument"
            done
            [[ -n "$requested" ]] || return 2
            if [[ "${NVM_SYMLINK_CURRENT-}" == "true" ]]; then
                rm -f -- "$NVM_DIR/current"
                ln -s "$NVM_DIR/versions/node/$requested" "$NVM_DIR/current"
            fi
            ;;
        *)
            return 2
            ;;
    esac
}

if [[ "${1-}" != "--no-use" && -f "$NVM_DIR/alias/default" ]]; then
    nvm use --silent "$(cat "$NVM_DIR/alias/default")"
fi
EOF
}

create_installer_fixture() {
    cat > "$NVM_TEST_INSTALLER_FIXTURE" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

printf 'install-nvm\n' >> "$NVM_TEST_LOG"
cp "$NVM_TEST_NVM_SH_FIXTURE" "$NVM_DIR/nvm.sh"
EOF
    chmod +x "$NVM_TEST_INSTALLER_FIXTURE"
}

create_curl_fixture() {
    cat > "$MOCK_BIN/curl" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

output=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        -o)
            output="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

[[ -n "$output" ]]
cp "$NVM_TEST_INSTALLER_FIXTURE" "$output"
EOF
    chmod +x "$MOCK_BIN/curl"
}

create_shasum_fixture() {
    cat > "$MOCK_BIN/shasum" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

[[ "$*" == "-a 256 -c -" ]]
read -r expected path
[[ -n "$expected" && -f "$path" ]]
printf 'verify-installer %s\n' "$path" >> "$NVM_TEST_LOG"
[[ "${NVM_TEST_BAD_CHECKSUM:-0}" != "1" ]]
EOF
    chmod +x "$MOCK_BIN/shasum"
}

install_fake_nvm() {
    mkdir -p "$NVM_DIR"
    cp "$NVM_TEST_NVM_SH_FIXTURE" "$NVM_DIR/nvm.sh"
}

operation_line() {
    local pattern="$1"

    grep -n -m 1 -F "$pattern" "$NVM_TEST_LOG" | cut -d: -f1
}

@test "nvm-npm-sync installs nvm before Node and uses the exact nvm global prefix" {
    write_manifest '{"managed-tool":"1.2.3"}'

    run env PATH="$MOCK_BIN:$PATH" /bin/bash "$SYNC_SCRIPT" --manifest-dir "$TEST_MANIFEST_DIR"

    assert_success
    local prefix
    prefix="$(cd -P "$NVM_DIR/versions/node/$NVM_TEST_VERSION" && pwd)"
    assert_file_exists "$NVM_DIR/nvm.sh"
    assert_equal "$(cat "$NVM_DIR/alias/default")" "$NVM_TEST_VERSION"
    assert_equal "$(cd -P "$NVM_DIR/current" && pwd)" "$prefix"
    assert_file_exists "$prefix/lib/node_modules/managed-tool/package.json"
    assert_file_contains "$prefix/$MANAGED_STATE_NAME" "managed-tool"
    assert_file_not_exists "$XDG_DATA_HOME/dotfiles/npm"
    assert_file_contains "$NVM_TEST_LOG" "npm-runtime-node $prefix/bin/node"
    assert_file_contains "$NVM_TEST_LOG" "verify-installer"
    assert_file_contains "$NVM_TEST_LOG" "npm --prefix $prefix prefix --global"
    assert_file_contains "$NVM_TEST_LOG" "npm --prefix $prefix install --global --no-audit --no-fund managed-tool@1.2.3"

    local install_nvm_line install_node_line alias_line npm_install_line use_line
    install_nvm_line="$(operation_line "install-nvm")"
    install_node_line="$(operation_line "nvm install node")"
    alias_line="$(operation_line "nvm alias default $NVM_TEST_VERSION")"
    use_line="$(operation_line "nvm use --silent $NVM_TEST_VERSION")"
    npm_install_line="$(operation_line "npm --prefix $prefix install")"
    (( install_nvm_line < install_node_line ))
    (( install_node_line < alias_line ))
    (( alias_line < use_line ))
    (( use_line < npm_install_line ))
}

@test "nvm-npm-sync rejects an unverified nvm installer" {
    write_manifest '{"managed-tool":"1.2.3"}'

    run env PATH="$MOCK_BIN:$PATH" NVM_TEST_BAD_CHECKSUM=1 \
        /bin/bash "$SYNC_SCRIPT" --manifest-dir "$TEST_MANIFEST_DIR"

    assert_failure
    assert_output --partial "nvm installer checksum mismatch"
    assert_file_not_exists "$NVM_DIR"
    if [[ -f "$NVM_TEST_LOG" ]]; then
        refute grep -q 'install-nvm' "$NVM_TEST_LOG"
    fi
}

@test "nvm-npm-sync is idempotent and check verifies the installed state" {
    write_manifest '{"managed-tool":"1.2.3"}'
    install_fake_nvm

    run /bin/bash "$SYNC_SCRIPT" --manifest-dir "$TEST_MANIFEST_DIR"
    assert_success
    local install_count state_checksum
    install_count="$(grep -c 'npm .* install ' "$NVM_TEST_LOG")"
    state_checksum="$(cksum < "$NVM_DIR/versions/node/$NVM_TEST_VERSION/$MANAGED_STATE_NAME")"

    run /bin/bash "$SYNC_SCRIPT" --manifest-dir "$TEST_MANIFEST_DIR"
    assert_success
    assert_output --partial "managed-tool@1.2.3 is already installed"
    assert_equal "$(grep -c 'npm .* install ' "$NVM_TEST_LOG")" "$install_count"
    assert_equal "$(cksum < "$NVM_DIR/versions/node/$NVM_TEST_VERSION/$MANAGED_STATE_NAME")" "$state_checksum"

    run /bin/bash "$SYNC_SCRIPT" --check --manifest-dir "$TEST_MANIFEST_DIR"
    assert_success
    assert_output --partial "nvm global npm tools match"
}

@test "nvm-npm-sync removes retired managed packages and preserves unmanaged globals" {
    write_manifest '{"managed-tool":"1.2.3","retired-tool":"4.5.6"}'
    install_fake_nvm
    run /bin/bash "$SYNC_SCRIPT" --manifest-dir "$TEST_MANIFEST_DIR"
    assert_success

    local prefix="$NVM_DIR/versions/node/$NVM_TEST_VERSION"
    mkdir -p "$prefix/lib/node_modules/unmanaged-tool"
    printf '{"name":"unmanaged-tool","version":"9.9.9"}\n' \
        > "$prefix/lib/node_modules/unmanaged-tool/package.json"
    write_manifest '{"managed-tool":"1.2.3"}'

    run /bin/bash "$SYNC_SCRIPT" --manifest-dir "$TEST_MANIFEST_DIR"

    assert_success
    assert_output --partial "Removing formerly managed npm package: retired-tool"
    assert_file_not_exists "$prefix/lib/node_modules/retired-tool"
    assert_file_exists "$prefix/lib/node_modules/unmanaged-tool/package.json"
    assert_equal "$(cat "$prefix/$MANAGED_STATE_NAME")" "managed-tool"
    if grep -F 'uninstall' "$NVM_TEST_LOG" | grep -Fq 'unmanaged-tool'; then
        fail "the synchronizer attempted to uninstall an unmanaged package"
    fi
}

@test "nvm-npm-sync handles an empty manifest with the system Bash" {
    write_manifest '{}'
    install_fake_nvm

    run /bin/bash "$SYNC_SCRIPT" --manifest-dir "$TEST_MANIFEST_DIR"

    assert_success
    local prefix="$NVM_DIR/versions/node/$NVM_TEST_VERSION"
    assert_file_exists "$prefix/$MANAGED_STATE_NAME"
    assert_equal "$(wc -c < "$prefix/$MANAGED_STATE_NAME" | tr -d ' ')" "0"

    run /bin/bash "$SYNC_SCRIPT" --check --manifest-dir "$TEST_MANIFEST_DIR"
    assert_success
}

@test "nvm-npm-sync dry-run reports the plan without creating nvm or package state" {
    write_manifest '{"managed-tool":"1.2.3"}'

    run env PATH="$MOCK_BIN:$PATH" /bin/bash "$SYNC_SCRIPT" --dry-run \
        --manifest-dir "$TEST_MANIFEST_DIR"

    assert_success
    assert_output --partial "Would install nvm"
    assert_output --partial "Would run: nvm install node"
    assert_output --partial "Would set the installed Node release as the nvm default"
    assert_output --partial "Would reconcile only repository-managed packages"
    assert_file_not_exists "$NVM_DIR"
    assert_file_not_exists "$NVM_TEST_LOG"
}

@test "nvm-npm-sync preserves an incomplete nvm directory" {
    write_manifest '{"managed-tool":"1.2.3"}'
    mkdir -p "$NVM_DIR"
    printf 'keep me\n' > "$NVM_DIR/recovery-note"

    run env PATH="$MOCK_BIN:$PATH" /bin/bash "$SYNC_SCRIPT" --manifest-dir "$TEST_MANIFEST_DIR"

    assert_failure
    assert_output --partial "incomplete nvm directory preserved"
    assert_file_exists "$NVM_DIR/recovery-note"
    assert_file_not_exists "$NVM_TEST_LOG"
}

@test "nvm-npm-sync check fails when an exact managed version drifts" {
    write_manifest '{"managed-tool":"1.2.3"}'
    install_fake_nvm
    run /bin/bash "$SYNC_SCRIPT" --manifest-dir "$TEST_MANIFEST_DIR"
    assert_success
    local install_count
    install_count="$(grep -c 'npm .* install ' "$NVM_TEST_LOG")"

    write_manifest '{"managed-tool":"2.0.0"}'
    run /bin/bash "$SYNC_SCRIPT" --check --manifest-dir "$TEST_MANIFEST_DIR"

    assert_failure
    assert_output --partial "managed-tool is 1.2.3, expected 2.0.0"
    assert_equal "$(grep -c 'npm .* install ' "$NVM_TEST_LOG")" "$install_count"
}

@test "nvm-npm-sync check does not auto-select or rewrite nvm current" {
    write_manifest '{"managed-tool":"1.2.3"}'
    install_fake_nvm
    run /bin/bash "$SYNC_SCRIPT" --manifest-dir "$TEST_MANIFEST_DIR"
    assert_success

    local other_prefix="$NVM_DIR/versions/node/v23.0.0"
    mkdir -p "$other_prefix"
    rm -f -- "$NVM_DIR/current"
    ln -s "$other_prefix" "$NVM_DIR/current"
    local current_before
    current_before="$(readlink "$NVM_DIR/current")"

    run /bin/bash "$SYNC_SCRIPT" --check --manifest-dir "$TEST_MANIFEST_DIR"

    assert_failure
    assert_output --partial "nvm current points to"
    assert_equal "$(readlink "$NVM_DIR/current")" "$current_before"
}

@test "nvm-npm-sync rejects non-exact direct dependency versions" {
    write_manifest '{"managed-tool":"^1.2.3"}'
    install_fake_nvm

    run /bin/bash "$SYNC_SCRIPT" --manifest-dir "$TEST_MANIFEST_DIR"

    assert_failure
    assert_output --partial "must use an exact semantic version"
    if [[ -f "$NVM_TEST_LOG" ]]; then
        refute grep -q 'npm .* install ' "$NVM_TEST_LOG"
    fi
}

@test "zsh prefers the stable nvm bin and removes the retired XDG npm path" {
    command -v zsh >/dev/null 2>&1 || skip "zsh is required"
    local current_bin="$NVM_DIR/current/bin"
    local retired_bin="$HOME/.local/share/dotfiles/npm/current/node_modules/.bin"
    local fallback_bin="$XDG_DATA_HOME/dotfiles/npm/current/node_modules/.bin"
    local local_bin="$HOME/.local/bin"
    mkdir -p "$current_bin" "$retired_bin" "$fallback_bin" "$local_bin"

    printf '#!/usr/bin/env sh\nprintf "nvm-tool\\n"\n' > "$current_bin/managed-tool"
    printf '#!/usr/bin/env sh\nprintf "nvm-npm\\n"\n' > "$current_bin/npm"
    printf '#!/usr/bin/env sh\nprintf "retired-tool\\n"\n' > "$retired_bin/managed-tool"
    printf '#!/usr/bin/env sh\nprintf "stale-local-npm\\n"\n' > "$local_bin/npm"
    chmod +x "$current_bin/managed-tool" "$current_bin/npm" \
        "$retired_bin/managed-tool" "$local_bin/npm"

    run env HOME="$HOME" XDG_DATA_HOME="$XDG_DATA_HOME" \
        DOTFILES_NPM_BIN="$retired_bin" PATH="$retired_bin:$fallback_bin:$local_bin:/usr/bin:/bin" \
        zsh -dfc 'source "$1"; command -v managed-tool; managed-tool; command -v npm; npm; print -r -- "${DOTFILES_NPM_BIN-unset}"; print -r -- "$PATH"' \
        _ "$REAL_DOTFILES_ROOT/home/.config/zsh/.zshrc"

    assert_success
    assert_output --partial "$current_bin/managed-tool"
    assert_output --partial "nvm-tool"
    assert_output --partial "$current_bin/npm"
    assert_output --partial "nvm-npm"
    assert_output --partial "unset"
    refute_output --partial "$retired_bin"
    refute_output --partial "$fallback_bin"
}
