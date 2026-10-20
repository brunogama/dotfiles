#!/usr/bin/env bats
# Regression coverage for coding-agent credential wrappers.

load '../../helpers/test-helpers'
load '../../helpers/setup-teardown'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'

setup() {
    standard_setup
    cd "$TEST_TEMP_DIR"
    CORE_DIR="$(get_dotfiles_root)/bin/core"
    export CORE_DIR
    ZSHRC="$(get_dotfiles_root)/home/.config/zsh/.zshrc"
    export ZSHRC
    export TEST_BIN="$TEST_TEMP_DIR/bin"
    export TEST_HOME="$TEST_TEMP_DIR/home"
    export API_KEY_LOOKUP_LOG="$TEST_TEMP_DIR/api-key-lookups"
    export CREDENTIALS_BACKEND_LOG="$TEST_TEMP_DIR/credentials-backend"
    export WRAPPER_ARGS_OUTPUT="$TEST_TEMP_DIR/wrapper-args"
    export WRAPPER_ENV_OUTPUT="$TEST_TEMP_DIR/wrapper-env"
    export CREDENTIALS_BIN="$TEST_BIN/credentials"
    mkdir -p "$TEST_BIN" "$TEST_HOME"
    export PATH="$TEST_BIN:$PATH"

    cat > "$CREDENTIALS_BIN" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

[[ "$1" == "get" && $# -eq 2 ]] || exit 64
key_name="$2"
printf '%s\n' "$key_name" >> "$API_KEY_LOOKUP_LOG"

if [[ "${UNAVAILABLE_API_KEY:-}" == "$key_name" ]]; then
    exit 4
fi
if [[ "${FAILED_API_KEY:-}" == "$key_name" ]]; then
    printf 'credential backend unavailable\n' >&2
    exit 2
fi
printf '%s-test-value\n' "$key_name"
EOF
    chmod +x "$CREDENTIALS_BIN"

    cat > "$TEST_BIN/get-api-key" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

printf '%s\n' "$1" >> "$CREDENTIALS_BACKEND_LOG"
printf '%s-test-value\n' "$1"
EOF
    chmod +x "$TEST_BIN/get-api-key"
}

create_fake_upstream() {
    local name="$1"
    local upstream="$TEST_BIN/upstream-$name"

    cat > "$upstream" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$@" > "$WRAPPER_ARGS_OUTPUT"
env | LC_ALL=C sort > "$WRAPPER_ENV_OUTPUT"
EOF
    chmod +x "$upstream"
    printf '%s\n' "$upstream"
}

link_agent_wrapper() {
    local agent="$1"
    local wrapper="${agent}m"

    ln -s "$CORE_DIR/$wrapper" "$TEST_BIN/$wrapper"
}

assert_forwarded_arguments() {
    assert_equal "$(cat "$WRAPPER_ARGS_OUTPUT")" $'--model\ntest-model\ntest prompt'
}

run_agent_wrapper() {
    local agent="$1"
    local override_name="$2"
    local upstream
    shift 2
    upstream="$(create_fake_upstream "$agent")"
    link_agent_wrapper "$agent"

    run env \
        -u OPENAI_API_KEY \
        -u ANTHROPIC_API_KEY \
        "DOTFILES_CREDENTIALS_BIN=$CREDENTIALS_BIN" \
        "$override_name=$upstream" \
        "$@" \
        "$TEST_BIN/${agent}m" --model test-model 'test prompt'

    assert_success
    assert_forwarded_arguments
}

run_agent_wrapper_default() {
    local agent="$1"
    local upstream default_bin
    upstream="$(create_fake_upstream "$agent")"
    link_agent_wrapper "$agent"

    case "$agent" in
        codex|claude)
            default_bin="$TEST_HOME/.local/bin/$agent"
            ;;
        pi)
            default_bin="$TEST_BIN/pi"
            ;;
    esac
    mkdir -p "$(dirname "$default_bin")"
    cp "$upstream" "$default_bin"

    run env \
        -u OPENAI_API_KEY \
        -u ANTHROPIC_API_KEY \
        -u DOTFILES_CLAUDE_BIN \
        -u DOTFILES_CODEX_BIN \
        -u DOTFILES_PI_BIN \
        "HOME=$TEST_HOME" \
        "XDG_DATA_HOME=$TEST_HOME/.local/share" \
        "DOTFILES_CREDENTIALS_BIN=$CREDENTIALS_BIN" \
        "$TEST_BIN/${agent}m" --model test-model 'test prompt'

    assert_success
    assert_forwarded_arguments
}

assert_only_loaded_key() {
    local key_name="$1"

    assert_equal "$(cat "$API_KEY_LOOKUP_LOG")" "$key_name"
    run grep -Fx "$key_name=$key_name-test-value" "$WRAPPER_ENV_OUTPUT"
    assert_success
}

assert_key_not_exported() {
    local key_name="$1"

    run grep -E "^${key_name}=" "$WRAPPER_ENV_OUTPUT"
    assert_failure
}

@test "credentials get delegates to the Keychain lookup backend" {
    run env \
        "DOTFILES_GET_API_KEY_BIN=$TEST_BIN/get-api-key" \
        "$CORE_DIR/credentials" get OPENAI_API_KEY

    assert_success
    assert_output 'OPENAI_API_KEY-test-value'
    assert_equal "$(cat "$CREDENTIALS_BACKEND_LOG")" 'OPENAI_API_KEY'
}

@test "agent CLI wrappers do not use dump-api-keys" {
    run grep -F "dump-api-keys" "$ZSHRC"
    assert_failure

    run grep -R -F "dump-api-keys" "$CORE_DIR"
    assert_failure
}

@test "ytwisdom rejects non-HTTP URLs before invoking external commands" {
    run env \
        "HOME=$TEST_HOME" \
        "ZDOTDIR=$TEST_HOME/.config/zsh" \
        "PATH=$TEST_BIN:$PATH" \
        zsh -fc 'source "$1"; ytwisdom "$2"' zsh "$ZSHRC" 'file:///tmp/video'

    assert_failure
    assert_output 'Usage: ytwisdom [http(s)-url]'
}

@test "ytwisdom terminates yt-dlp options before an HTTPS URL" {
    cat > "$TEST_BIN/yt-dlp" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$@" > "$WRAPPER_ARGS_OUTPUT"
printf '%s\n' 'Example video'
EOF
    cat > "$TEST_BIN/fabric" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' 'wisdom'
EOF
    cat > "$TEST_BIN/pbpaste" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' called > "$TEST_TEMP_DIR/pbpaste-called"
printf '%s\n' 'https://clipboard.example/video'
EOF
    chmod +x "$TEST_BIN/yt-dlp" "$TEST_BIN/fabric" "$TEST_BIN/pbpaste"

    run env \
        "HOME=$TEST_HOME" \
        "ZDOTDIR=$TEST_HOME/.config/zsh" \
        "PATH=$TEST_BIN:$PATH" \
        zsh -fc 'source "$1"; ytwisdom "$2"' zsh "$ZSHRC" 'https://example.test/video'

    assert_success
    assert_output --partial 'Saved to: '
    assert_equal "$(cat "$WRAPPER_ARGS_OUTPUT")" $'--no-playlist\n--skip-download\n--get-title\n--\nhttps://example.test/video'
    refute test -e "$TEST_TEMP_DIR/pbpaste-called"
    rm -f "${output#Saved to: }"
}

@test "ytwisdom reads the clipboard only without an argument and allocates unique outputs" {
    local first_output second_output
    cat > "$TEST_BIN/yt-dlp" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$@" > "$WRAPPER_ARGS_OUTPUT"
printf '%s\n' 'Example video'
EOF
    cat > "$TEST_BIN/fabric" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' 'wisdom'
EOF
    cat > "$TEST_BIN/pbpaste" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' 'https://clipboard.example/video'
EOF
    chmod +x "$TEST_BIN/yt-dlp" "$TEST_BIN/fabric" "$TEST_BIN/pbpaste"

    run env \
        "HOME=$TEST_HOME" \
        "ZDOTDIR=$TEST_HOME/.config/zsh" \
        "PATH=$TEST_BIN:$PATH" \
        zsh -fc 'source "$1"; ytwisdom' zsh "$ZSHRC"
    assert_success
    first_output="${output#Saved to: }"

    run env \
        "HOME=$TEST_HOME" \
        "ZDOTDIR=$TEST_HOME/.config/zsh" \
        "PATH=$TEST_BIN:$PATH" \
        zsh -fc 'source "$1"; ytwisdom' zsh "$ZSHRC"
    assert_success
    second_output="${output#Saved to: }"

    assert_equal "$(cat "$WRAPPER_ARGS_OUTPUT")" $'--no-playlist\n--skip-download\n--get-title\n--\nhttps://clipboard.example/video'
    [[ -f "$first_output" && -f "$second_output" && "$first_output" != "$second_output" ]]
    rm -f "$first_output" "$second_output"
}

@test "codexm wrapper loads only the OpenAI key and forwards arguments" {
    run_agent_wrapper codex DOTFILES_CODEX_BIN
    assert_only_loaded_key OPENAI_API_KEY
}

@test "claudem wrapper loads only the Anthropic key and forwards arguments" {
    run_agent_wrapper claude DOTFILES_CLAUDE_BIN
    assert_only_loaded_key ANTHROPIC_API_KEY
}

@test "pim wrapper forwards arguments without loading provider keys" {
    run_agent_wrapper pi DOTFILES_PI_BIN PI_PROVIDER_TOKEN=inherited-provider-token
    refute test -e "$API_KEY_LOOKUP_LOG"
    run grep -Fx 'PI_PROVIDER_TOKEN=inherited-provider-token' "$WRAPPER_ENV_OUTPUT"
    assert_success
}

@test "unavailable optional credentials do not prevent agent launches" {
    run_agent_wrapper codex DOTFILES_CODEX_BIN UNAVAILABLE_API_KEY=OPENAI_API_KEY
    assert_key_not_exported OPENAI_API_KEY

    run_agent_wrapper claude DOTFILES_CLAUDE_BIN UNAVAILABLE_API_KEY=ANTHROPIC_API_KEY
    assert_key_not_exported ANTHROPIC_API_KEY
}

@test "credential backend failures are reported without preventing an agent launch" {
    run_agent_wrapper codex DOTFILES_CODEX_BIN FAILED_API_KEY=OPENAI_API_KEY
    assert_output --partial 'Unable to load credential OPENAI_API_KEY (exit 2)'
    assert_key_not_exported OPENAI_API_KEY
}

@test "agent wrappers exercise their default executable paths" {
    run_agent_wrapper_default codex
    run_agent_wrapper_default claude
}

@test "pim wrapper resolves pi from PATH" {
    run_agent_wrapper_default pi
}

@test "pim wrapper reports a missing upstream executable" {
    bats_require_minimum_version 1.5.0
    link_agent_wrapper pi

    run -127 env \
        -u DOTFILES_PI_BIN \
        HOME="$TEST_HOME" \
        PATH="/usr/bin:/bin" \
        "$TEST_BIN/pim"

    assert_failure 127
    assert_output 'pim: executable not found; install Pi or set DOTFILES_PI_BIN'
}
