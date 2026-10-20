#!/usr/bin/env bats

setup() {
    SCRIPT="$BATS_TEST_DIRNAME/../../../bin/credentials/dump-api-keys-on-production"
    export HOME="$BATS_TEST_TMPDIR/local-home"
    export LOCAL_HOME="$HOME"
    export REMOTE_HOME="$BATS_TEST_TMPDIR/remote-home"
    export XDG_CONFIG_HOME="$HOME/.config"
    export XDG_CACHE_HOME="$HOME/.cache"
    export XDG_STATE_HOME="$HOME/.local/state"
    mkdir -p "$HOME" "$REMOTE_HOME" "$BATS_TEST_TMPDIR/bin"
    export PATH="$BATS_TEST_TMPDIR/bin:$PATH"

    cat > "$BATS_TEST_TMPDIR/bin/ssh" <<'SH'
#!/bin/bash
set -euo pipefail
[[ "$1" == production ]] || exit 64
shift
HOME="$REMOTE_HOME" exec /bin/sh -c "$*"
SH
    cat > "$BATS_TEST_TMPDIR/bin/dump-api-keys" <<'SH'
#!/bin/bash
[[ "$HOME" == "$LOCAL_HOME" ]] || exit 64
printf '%s\n' 'export TEST_API_KEY=dummy-key'
SH
    chmod +x "$BATS_TEST_TMPDIR/bin/ssh" "$BATS_TEST_TMPDIR/bin/dump-api-keys"
}

@test "writes laptop keys remotely to a private home envrc without printing them" {
    run bash "$SCRIPT"
    [[ "$status" -eq 0 ]]
    [[ -z "$output" ]]
    [[ "$(cat "$REMOTE_HOME/.envrc")" == 'export TEST_API_KEY=dummy-key' ]]
    [[ "$(find "$REMOTE_HOME/.envrc" -perm 0600)" == "$REMOTE_HOME/.envrc" ]]
}

@test "overwrites an existing envrc and restricts its permissions" {
    printf '%s\n' 'export OLD_KEY=old-value' > "$REMOTE_HOME/.envrc"
    chmod 644 "$REMOTE_HOME/.envrc"

    run bash "$SCRIPT"
    [[ "$status" -eq 0 ]]
    [[ -z "$output" ]]
    [[ "$(cat "$REMOTE_HOME/.envrc")" == 'export TEST_API_KEY=dummy-key' ]]
    [[ "$(find "$REMOTE_HOME/.envrc" -perm 0600)" == "$REMOTE_HOME/.envrc" ]]
}

@test "returns SSH failure without creating a local envrc" {
    cat > "$BATS_TEST_TMPDIR/bin/ssh" <<'SH'
#!/bin/bash
exit 255
SH

    run bash "$SCRIPT"
    [[ "$status" -eq 255 ]]
    [[ ! -e "$HOME/.envrc" ]]
}

@test "a failed local export leaves the remote envrc unchanged" {
    printf '%s\n' 'export OLD_KEY=keep-me' > "$REMOTE_HOME/.envrc"
    cat > "$BATS_TEST_TMPDIR/bin/dump-api-keys" <<'SH'
#!/bin/bash
printf '%s\n' 'export PARTIAL_KEY=do-not-transfer'
exit 7
SH

    run bash "$SCRIPT"
    [[ "$status" -eq 7 ]]
    [[ -z "$output" ]]
    [[ ! -e "$HOME/.envrc" ]]
    [[ "$(cat "$REMOTE_HOME/.envrc")" == 'export OLD_KEY=keep-me' ]]
}

@test "an empty local export never connects or overwrites the remote envrc" {
    printf '%s\n' 'export OLD_KEY=keep-me' > "$REMOTE_HOME/.envrc"
    cat > "$BATS_TEST_TMPDIR/bin/dump-api-keys" <<'SH'
#!/bin/bash
exit 0
SH
    export SSH_CALLED="$BATS_TEST_TMPDIR/ssh-called"
    cat > "$BATS_TEST_TMPDIR/bin/ssh" <<'SH'
#!/bin/bash
touch "$SSH_CALLED"
SH

    run bash "$SCRIPT"
    [[ "$status" -ne 0 ]]
    [[ "$output" == *"No API keys exported"* ]]
    [[ ! -e "$SSH_CALLED" ]]
    [[ ! -e "$HOME/.envrc" ]]
    [[ "$(cat "$REMOTE_HOME/.envrc")" == 'export OLD_KEY=keep-me' ]]
}

@test "a failed remote write preserves the envrc and removes staging files" {
    printf '%s\n' 'export OLD_KEY=keep-me' > "$REMOTE_HOME/.envrc"
    cat > "$BATS_TEST_TMPDIR/bin/cat" <<'SH'
#!/bin/bash
IFS= read -r line || true
printf '%s\n' "$line"
exit 74
SH
    chmod +x "$BATS_TEST_TMPDIR/bin/cat"

    run bash "$SCRIPT"
    [[ "$status" -eq 74 ]]
    [[ -z "$output" ]]
    [[ "$(/bin/cat "$REMOTE_HOME/.envrc")" == 'export OLD_KEY=keep-me' ]]
    [[ -z "$(find "$REMOTE_HOME" -name '.envrc.*')" ]]
}

@test "install scripts-only links the production key command and is idempotent" {
    local root link
    root="$(cd "$BATS_TEST_DIRNAME/../../.." && pwd -P)"
    link="$HOME/.local/bin/dump-api-keys-on-production"

    run "$root/install" --scripts-only --dry-run --yes
    [[ "$status" -eq 0 ]]
    [[ ! -e "$link" ]]

    run "$root/install" --scripts-only --yes
    [[ "$status" -eq 0 ]]
    [[ -L "$link" && -x "$link" ]]
    [[ "$(readlink "$link")" == "$root/bin/credentials/dump-api-keys-on-production" ]]

    run env PATH="$HOME/.local/bin:$PATH" bash -c 'command -v dump-api-keys-on-production'
    [[ "$status" -eq 0 ]]
    [[ "$output" == "$link" ]]

    run "$root/install" --scripts-only --yes
    [[ "$status" -eq 0 ]]
    [[ "$(readlink "$link")" == "$root/bin/credentials/dump-api-keys-on-production" ]]
}
