#!/usr/bin/env bats
# Regression coverage for agent identity injection and token handling in the
# coding-agent CLI wrappers (codexm, claudem, pim).

load '../../helpers/test-helpers'
load '../../helpers/setup-teardown'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'

setup() {
    standard_setup
    CORE_DIR="$(get_dotfiles_root)/bin/core"
    export CORE_DIR
    export TEST_BIN="$TEST_TEMP_DIR/bin"
    export PATH="$TEST_BIN:$PATH"
    export WRAPPER_ARGS_OUTPUT="$TEST_TEMP_DIR/wrapper-args"
    export WRAPPER_ENV_OUTPUT="$TEST_TEMP_DIR/wrapper-env"
    mkdir -p "$TEST_BIN"
    create_fake_credentials
    cd "$TEST_TEMP_DIR"
}

create_fake_credentials() {
    local bin="$TEST_BIN/credentials"
    cat > "$bin" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
# All credentials are treated as "unavailable" (exit 4) so the wrapper loads no
# provider key and prints no warning during these tests.
[[ "$1" == "get" && $# -eq 2 ]] || exit 64
exit 4
EOF
    chmod +x "$bin"
    export DOTFILES_CREDENTIALS_BIN="$bin"
}

create_fake_upstream() {
    local name="$1"
    local upstream="$TEST_BIN/upstream-$name"
    cat > "$upstream" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$@" > "$WRAPPER_ARGS_OUTPUT"
: > "$WRAPPER_ENV_OUTPUT"
for var in GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME \
    GIT_COMMITTER_EMAIL GH_TOKEN GITHUB_TOKEN GH_ENTERPRISE_TOKEN \
    GITHUB_ENTERPRISE_TOKEN; do
    if value="$(printenv "$var" 2>/dev/null)"; then
        printf '%s=%s\n' "$var" "$value" >> "$WRAPPER_ENV_OUTPUT"
    fi
done
EOF
    chmod +x "$upstream"
    printf '%s\n' "$upstream"
}

create_failing_upstream() {
    local upstream="$TEST_BIN/upstream-fail"
    cat > "$upstream" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
: > "$WRAPPER_ENV_OUTPUT"
for var in GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME \
    GIT_COMMITTER_EMAIL GH_TOKEN GITHUB_TOKEN GH_ENTERPRISE_TOKEN \
    GITHUB_ENTERPRISE_TOKEN; do
    if value="$(printenv "$var" 2>/dev/null)"; then
        printf '%s=%s\n' "$var" "$value" >> "$WRAPPER_ENV_OUTPUT"
    fi
done
exit 3
EOF
    chmod +x "$upstream"
    printf '%s\n' "$upstream"
}

write_agent_config() {
    local name="$1" email="$2" app_id="${3:-}"
    {
        printf 'AGENT_NAME=%s\n' "$name"
        printf 'AGENT_EMAIL=%s\n' "$email"
        if [[ -n "$app_id" ]]; then
            printf 'GITHUB_APP_ID=%s\n' "$app_id"
        fi
    } > "$TEST_TEMP_DIR/agent.conf"
    printf '%s\n' "$TEST_TEMP_DIR/agent.conf"
}

link_agent_wrapper() {
    local agent="$1"
    local wrapper="${agent}m"
    ln -s "$CORE_DIR/$wrapper" "$TEST_BIN/$wrapper"
}

# Inherited git identity would leak into the child env and make the "untouched"
# assertions depend on the shell the suite was started from.
run_wrapper() {
    local agent="$1" upstream="$2" config="$3" agent_upper
    link_agent_wrapper "$agent"
    agent_upper="$(printf '%s' "$agent" | tr '[:lower:]' '[:upper:]')"
    run env \
        -u GIT_AUTHOR_NAME \
        -u GIT_AUTHOR_EMAIL \
        -u GIT_COMMITTER_NAME \
        -u GIT_COMMITTER_EMAIL \
        "DOTFILES_AGENT_CONFIG=$config" \
        "DOTFILES_${agent_upper}_BIN=$upstream" \
        "$TEST_BIN/${agent}m" --model test-model 'test prompt'
}

create_fake_credfile() {
    local bin="$TEST_BIN/credfile"
    if [[ "${1:-}" == "unavailable" ]]; then
        cat > "$bin" <<'EOF'
#!/usr/bin/env bash
exit 4
EOF
    else
        cat > "$bin" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
[[ "$1" == "get" && $# -eq 2 ]] || exit 64
printf '%s\n' '-----BEGIN PRIVATE KEY-----fake-key-----END PRIVATE KEY-----'
EOF
    fi
    chmod +x "$bin"
    export DOTFILES_CREDFILE_BIN="$bin"
}

create_fake_token_helper() {
    local bin="$TEST_BIN/agent-github-mint"
    cat > "$bin" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
cat >/dev/null
printf '%s\n' 'ghs_fake-token-value'
EOF
    chmod +x "$bin"
    export DOTFILES_AGENT_GH_MINT_BIN="$bin"
}

@test "wrapper injects configured identity into git env" {
    local upstream config
    upstream="$(create_fake_upstream codex)"
    config="$(write_agent_config 'agent-account' 'agent@example.com')"
    run_wrapper codex "$upstream" "$config"

    assert_success
    assert_equal "$(cat "$WRAPPER_ARGS_OUTPUT")" $'--model\ntest-model\ntest prompt'

    run grep -Fx 'GIT_AUTHOR_NAME=agent-account' "$WRAPPER_ENV_OUTPUT"
    assert_success
    run grep -Fx 'GIT_AUTHOR_EMAIL=agent@example.com' "$WRAPPER_ENV_OUTPUT"
    assert_success
    run grep -Fx 'GIT_COMMITTER_NAME=agent-account' "$WRAPPER_ENV_OUTPUT"
    assert_success
    run grep -Fx 'GIT_COMMITTER_EMAIL=agent@example.com' "$WRAPPER_ENV_OUTPUT"
    assert_success
}

@test "pim wrapper injects configured identity into git env" {
    local upstream config
    upstream="$(create_fake_upstream pi)"
    config="$(write_agent_config 'agent-account' 'agent@example.com')"
    run_wrapper pi "$upstream" "$config"

    assert_success
    run grep -Fx 'GIT_AUTHOR_NAME=agent-account' "$WRAPPER_ENV_OUTPUT"
    assert_success
    run grep -Fx 'GIT_AUTHOR_EMAIL=agent@example.com' "$WRAPPER_ENV_OUTPUT"
    assert_success
    run grep -Fx 'GIT_COMMITTER_NAME=agent-account' "$WRAPPER_ENV_OUTPUT"
    assert_success
    run grep -Fx 'GIT_COMMITTER_EMAIL=agent@example.com' "$WRAPPER_ENV_OUTPUT"
    assert_success
}

@test "wrapper leaves identity untouched when no config is present" {
    local upstream
    upstream="$(create_fake_upstream codex)"
    link_agent_wrapper codex
    mkdir -p "$TEST_TEMP_DIR/empty-home"
    run env \
        -u DOTFILES_AGENT_CONFIG \
        -u XDG_CONFIG_HOME \
        -u GIT_AUTHOR_NAME \
        -u GIT_AUTHOR_EMAIL \
        -u GIT_COMMITTER_NAME \
        -u GIT_COMMITTER_EMAIL \
        "HOME=$TEST_TEMP_DIR/empty-home" \
        "DOTFILES_CODEX_BIN=$upstream" \
        "$TEST_BIN/codexm" --model test-model 'test prompt'

    assert_success
    run grep -E '^GIT_(AUTHOR|COMMITTER)_(NAME|EMAIL)=' "$WRAPPER_ENV_OUTPUT"
    assert_failure
}

@test "wrapper leaves identity untouched when configured email is missing" {
    local upstream config
    upstream="$(create_fake_upstream codex)"
    config="$(write_agent_config 'agent-account' '')"
    run_wrapper codex "$upstream" "$config"

    assert_success
    run grep -E '^GIT_(AUTHOR|COMMITTER)_(NAME|EMAIL)=' "$WRAPPER_ENV_OUTPUT"
    assert_failure
}

@test "wrapper propagates a failing upstream exit code" {
    local upstream config
    upstream="$(create_failing_upstream)"
    config="$(write_agent_config 'agent-account' 'agent@example.com')"
    run_wrapper codex "$upstream" "$config"

    assert_failure 3
}

@test "pim wrapper propagates a failing upstream exit code" {
    local upstream config
    upstream="$(create_failing_upstream)"
    config="$(write_agent_config 'agent-account' 'agent@example.com')"
    run_wrapper pi "$upstream" "$config"

    assert_failure 3
}

@test "wrapper exports the provided GitHub token" {
    local upstream
    upstream="$(create_fake_upstream claude)"
    link_agent_wrapper claude
    run env \
        "DOTFILES_AGENT_GH_TOKEN=tok-123" \
        GH_ENTERPRISE_TOKEN=inherited-enterprise-gh-token \
        GITHUB_ENTERPRISE_TOKEN=inherited-enterprise-github-token \
        "DOTFILES_CLAUDE_BIN=$upstream" \
        "$TEST_BIN/claudem" --model test-model 'test prompt'

    assert_success
    run grep -Fx 'GH_TOKEN=tok-123' "$WRAPPER_ENV_OUTPUT"
    assert_success
    run grep -Fx 'GITHUB_TOKEN=tok-123' "$WRAPPER_ENV_OUTPUT"
    assert_success
    run grep -E '^(GH_ENTERPRISE_TOKEN|GITHUB_ENTERPRISE_TOKEN)=' "$WRAPPER_ENV_OUTPUT"
    assert_failure
}

@test "wrapper does not pass inherited GitHub tokens without an explicit choice" {
    local upstream config
    upstream="$(create_fake_upstream codex)"
    config="$(write_agent_config 'agent-account' 'agent@example.com')"
    link_agent_wrapper codex
    run env \
        GH_TOKEN=inherited-gh-token \
        GITHUB_TOKEN=inherited-github-token \
        GH_ENTERPRISE_TOKEN=inherited-enterprise-gh-token \
        GITHUB_ENTERPRISE_TOKEN=inherited-enterprise-github-token \
        "DOTFILES_AGENT_CONFIG=$config" \
        "DOTFILES_CODEX_BIN=$upstream" \
        "$TEST_BIN/codexm" --model test-model 'test prompt'

    assert_success
    run grep -E '^(GH_TOKEN|GITHUB_TOKEN|GH_ENTERPRISE_TOKEN|GITHUB_ENTERPRISE_TOKEN)=' "$WRAPPER_ENV_OUTPUT"
    assert_failure
}

@test "wrapper mints and exports a GitHub App token when the App is configured" {
    local upstream config
    upstream="$(create_fake_upstream codex)"
    config="$(write_agent_config 'agent-account' 'agent@example.com' '12345')"
    create_fake_credfile
    create_fake_token_helper
    run_wrapper codex "$upstream" "$config"

    assert_success
    run grep -Fx 'GH_TOKEN=ghs_fake-token-value' "$WRAPPER_ENV_OUTPUT"
    assert_success
    run grep -Fx 'GITHUB_TOKEN=ghs_fake-token-value' "$WRAPPER_ENV_OUTPUT"
    assert_success
}

@test "wrapper skips token minting when the private key is unavailable" {
    local upstream config
    upstream="$(create_fake_upstream codex)"
    config="$(write_agent_config 'agent-account' 'agent@example.com' '12345')"
    create_fake_credfile unavailable
    export GH_TOKEN=inherited-gh-token
    export GITHUB_TOKEN=inherited-github-token
    run_wrapper codex "$upstream" "$config"

    assert_success
    run grep -E '^GH_TOKEN=' "$WRAPPER_ENV_OUTPUT"
    assert_failure
    run grep -E '^GITHUB_TOKEN=' "$WRAPPER_ENV_OUTPUT"
    assert_failure
}

# Guards against the per-run evidence recording being reintroduced.
@test "wrapper writes no evidence records" {
    local upstream config
    upstream="$(create_fake_upstream codex)"
    config="$(write_agent_config 'agent-account' 'agent@example.com')"
    run_wrapper codex "$upstream" "$config"

    assert_success
    [ ! -e "$TEST_TEMP_DIR/.agents" ] || fail "wrapper created .agents/evidence"
}
