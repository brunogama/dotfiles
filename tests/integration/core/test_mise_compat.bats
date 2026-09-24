#!/usr/bin/env bats

setup() {
    export DOTFILES_TEST_ROOT
    DOTFILES_TEST_ROOT="$(cd "$BATS_TEST_DIRNAME/../../.." && pwd)"
    export MISE_CALLS="$BATS_TEST_TMPDIR/mise-calls"
    mkdir -p "$BATS_TEST_TMPDIR/bin"
    cat > "$BATS_TEST_TMPDIR/bin/mise" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$MISE_CALLS"
case "$*" in
    'where node')
        [[ -z "${MISE_TEST_NODE_ROOT:-}" ]] || printf '%s\n' "$MISE_TEST_NODE_ROOT"
        ;;
    'exec -- npm prefix --global')
        [[ -z "${MISE_TEST_NPM_ROOT:-${MISE_TEST_NODE_ROOT:-}}" ]] || \
            printf '%s\n' "${MISE_TEST_NPM_ROOT:-$MISE_TEST_NODE_ROOT}"
        ;;
    'exec -- npm ls --global --depth=0 --json')
        [[ -z "${MISE_TEST_NPM_VERSION:-}" ]] || printf '{"dependencies":{"@playwright/cli":{"version":"%s"}}}\n' "$MISE_TEST_NPM_VERSION"
        ;;
esac
if [[ "${MISE_FAIL_WHERE:-}" == "true" && "${1:-}" == where ]]; then
    exit 1
fi
EOF
    chmod +x "$BATS_TEST_TMPDIR/bin/mise"
    export PATH="$BATS_TEST_TMPDIR/bin:$PATH"
}

@test "deprecated nvm installs through mise and warns" {
    ln -s "$DOTFILES_TEST_ROOT/bin/core/nvm" "$BATS_TEST_TMPDIR/bin/nvm"
    run "$BATS_TEST_TMPDIR/bin/nvm" install 26.10.0
    [ "$status" -eq 0 ]
    [[ "$output" == *"deprecated"* ]]
    [ "$(cat "$MISE_CALLS")" = "install node@26.10.0" ]
}

@test "nvm install without a version uses the configured mise Node" {
    run "$DOTFILES_TEST_ROOT/bin/core/nvm" install
    [ "$status" -eq 0 ]
    [ "$(cat "$MISE_CALLS")" = "install node" ]
}

@test "deprecated pyenv and rbenv global commands write mise globals" {
    run "$DOTFILES_TEST_ROOT/bin/core/pyenv" global 3.14.7
    [ "$status" -eq 0 ]
    run "$DOTFILES_TEST_ROOT/bin/core/rbenv" global 4.0.7
    [ "$status" -eq 0 ]
    [ "$(sed -n '1p' "$MISE_CALLS")" = "use --global python@3.14.7" ]
    [ "$(sed -n '2p' "$MISE_CALLS")" = "use --global ruby@4.0.7" ]
}

@test "deprecated sdk command delegates the chosen candidate" {
    run "$DOTFILES_TEST_ROOT/bin/core/sdk" install java 27
    [ "$status" -eq 0 ]
    [ "$(cat "$MISE_CALLS")" = "install java@27" ]
}

@test "session commands refuse to claim a change from a subprocess" {
    run "$DOTFILES_TEST_ROOT/bin/core/nvm" use 26.10.0
    [ "$status" -eq 2 ]
    [[ "$output" == *"current shell"* ]]
}

@test "interactive nvm use changes the active mise shell" {
    run /bin/zsh -c 'source "$1"; mise() { print -r -- "$*"; }; nvm use 26.10.0' \
        _ "$DOTFILES_TEST_ROOT/home/.config/zsh/lib/mise-compat.zsh"
    [ "$status" -eq 0 ]
    [[ "$output" == *"shell node@26.10.0"* ]]
    [[ "$output" == *"deprecated"* ]]
}

@test "login shell prefers mise over stale nvm links from an older install" {
    local old_home="$BATS_TEST_TMPDIR/old-home"
    mkdir -p "$old_home/.local/bin" "$old_home/.local/share/mise/shims" \
        "$old_home/.nvm/current/bin" "$BATS_TEST_TMPDIR/compat-bin"
    printf '#!/bin/sh\n' > "$old_home/.nvm/current/bin/node"
    printf '#!/bin/sh\n' > "$old_home/.local/share/mise/shims/node"
    chmod +x "$old_home/.nvm/current/bin/node" "$old_home/.local/share/mise/shims/node"
    ln -s "$old_home/.nvm/current/bin/node" "$old_home/.local/bin/node"
    ln -s "$DOTFILES_TEST_ROOT/bin/core/nvm" "$BATS_TEST_TMPDIR/compat-bin/nvm"

    run env HOME="$old_home" DOTFILES_MISE_COMPAT_BIN="$BATS_TEST_TMPDIR/compat-bin" \
        /bin/zsh -fc 'source "$1"; whence -p node; whence -p nvm' \
        _ "$DOTFILES_TEST_ROOT/home/.config/zsh/.zprofile"
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "$old_home/.local/share/mise/shims/node" ]
    [ "${lines[1]}" = "$BATS_TEST_TMPDIR/compat-bin/nvm" ]
    [ -L "$old_home/.local/bin/node" ]
}

@test "toolchain check fails when a configured runtime is absent" {
    run env MISE_FAIL_WHERE=true "$DOTFILES_TEST_ROOT/bin/core/mise-toolchain-sync" \
        --check --skip-npm
    [ "$status" -eq 1 ]
    [[ "$output" == *"node is not installed"* ]]
}

@test "toolchain dry run does not install a runtime" {
    run "$DOTFILES_TEST_ROOT/bin/core/mise-toolchain-sync" --dry-run
    [ "$status" -eq 0 ]
    [[ "$output" == *"Would install Node, Python, and Ruby"* ]]
    [ ! -e "$MISE_CALLS" ]
}

@test "toolchain sync keeps an exact global npm version" {
    export MISE_TEST_NODE_ROOT="$BATS_TEST_TMPDIR/node"
    export MISE_TEST_NPM_VERSION=0.1.13
    mkdir -p "$MISE_TEST_NODE_ROOT"
    run "$DOTFILES_TEST_ROOT/bin/core/mise-toolchain-sync"
    [ "$status" -eq 0 ]
    [[ "$output" == *"already installed in mise Node"* ]]
    ! rg -q '^exec -- npm install ' "$MISE_CALLS"
}

@test "toolchain sync upgrades an outdated global npm version" {
    export MISE_TEST_NODE_ROOT="$BATS_TEST_TMPDIR/node"
    export MISE_TEST_NPM_VERSION=0.1.12
    mkdir -p "$MISE_TEST_NODE_ROOT"
    run "$DOTFILES_TEST_ROOT/bin/core/mise-toolchain-sync"
    [ "$status" -eq 0 ]
    rg -q '^exec -- npm install --global --no-audit --no-fund @playwright/cli@0.1.13$' "$MISE_CALLS"
}

@test "toolchain sync accepts equivalent Node prefix paths" {
    export MISE_TEST_NPM_ROOT="$BATS_TEST_TMPDIR/node"
    export MISE_TEST_NODE_ROOT="$BATS_TEST_TMPDIR/node-alias"
    export MISE_TEST_NPM_VERSION=0.1.13
    mkdir -p "$MISE_TEST_NPM_ROOT"
    ln -s "$MISE_TEST_NPM_ROOT" "$MISE_TEST_NODE_ROOT"

    run "$DOTFILES_TEST_ROOT/bin/core/mise-toolchain-sync" --check
    [ "$status" -eq 0 ]
    [[ "$output" == *"already installed in mise Node"* ]]
}
