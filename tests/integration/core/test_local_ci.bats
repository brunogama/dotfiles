#!/usr/bin/env bats
# Regression tests for the local CI executor.

load '../../helpers/test-helpers'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'

setup() {
    DOTFILES_ROOT="$(get_dotfiles_root)"
    LOCAL_CI="$DOTFILES_ROOT/scripts/local-ci.sh"
}

@test "local-ci: documents its command-line interface" {
    run "$LOCAL_CI" --help

    assert_success
    assert_output --partial "Usage: scripts/local-ci.sh"
}

@test "local-ci: rejects an unknown option" {
    run "$LOCAL_CI" --not-an-option

    assert_failure 2
    assert_output --partial "Unknown option: --not-an-option"
}

@test "local-ci: isolates each stage and preserves the caller environment" {
    local probe_directory
    probe_directory="$BATS_TEST_TMPDIR/local-ci-probes"
    mkdir -p "$probe_directory"

    run bash -s -- "$LOCAL_CI" "$probe_directory" <<'EOF'
set -euo pipefail

local_ci="$1"
probe_directory="$2"
set --
source "$local_ci"
rm -rf "$run_root"
run_root="$(mktemp -d "$probe_directory/stages.XXXXXX")"
results="$probe_directory/results.tsv"
: >"$results"

probe() {
    local output="$1"
    printf '%s\n' "$HOME" "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" \
        "$XDG_STATE_HOME" "$TMPDIR" >"$output"
    touch "$HOME/stage-marker"
}
export -f probe

caller_home="$HOME"
caller_config="${XDG_CONFIG_HOME-}"
caller_cache="${XDG_CACHE_HOME-}"
caller_state="${XDG_STATE_HOME-}"
caller_tmp="${TMPDIR-}"
run_macos_stage test probe 'probe / one' probe "$probe_directory/first"
run_macos_stage test probe 'probe / two' probe "$probe_directory/second"
[[ "$HOME" == "$caller_home" ]]
[[ "${XDG_CONFIG_HOME-}" == "$caller_config" ]]
[[ "${XDG_CACHE_HOME-}" == "$caller_cache" ]]
[[ "${XDG_STATE_HOME-}" == "$caller_state" ]]
[[ "${TMPDIR-}" == "$caller_tmp" ]]
first_home="$(sed -n '1p' "$probe_directory/first")"
second_home="$(sed -n '1p' "$probe_directory/second")"
[[ -f "$first_home/stage-marker" ]]
[[ -f "$second_home/stage-marker" ]]
touch "$probe_directory/markers-verified"
EOF

    assert_success

    local first_home first_config first_cache first_state first_tmp
    local second_home
    first_home="$(sed -n '1p' "$probe_directory/first")"
    first_config="$(sed -n '2p' "$probe_directory/first")"
    first_cache="$(sed -n '3p' "$probe_directory/first")"
    first_state="$(sed -n '4p' "$probe_directory/first")"
    first_tmp="$(sed -n '5p' "$probe_directory/first")"
    second_home="$(sed -n '1p' "$probe_directory/second")"

    assert_equal "$first_config" "$first_home/.config"
    assert_equal "$first_cache" "$first_home/.cache"
    assert_equal "$first_state" "$first_home/.local/state"
    assert_equal "$first_tmp" "$first_home/tmp"
    [[ "$first_home" != "$second_home" ]]
    [[ -f "$probe_directory/markers-verified" ]]
}

@test "local-ci: runs maintained Bats suites in parallel" {
    local arguments_file
    arguments_file="$BATS_TEST_TMPDIR/bats-arguments"

    run bash -s -- "$LOCAL_CI" "$arguments_file" <<'EOF'
set -euo pipefail

local_ci="$1"
arguments_file="$2"
set --
source "$local_ci"
workspace="$(mktemp -d "$BATS_TEST_TMPDIR/workspace.XXXXXX")"

bats() {
    printf '%s\n' "$*" >"$arguments_file"
}

macos_integration

[[ "$(wc -l <"$arguments_file")" -eq 1 ]]
[[ "$(cat "$arguments_file")" == '--tap --jobs 2 tests/integration/core/test_install.bats tests/integration/core/test_work_mode.bats' ]]
EOF

    assert_success
}
