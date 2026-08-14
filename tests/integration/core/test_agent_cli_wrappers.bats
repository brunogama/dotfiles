#!/usr/bin/env bats
# Regression coverage for coding-agent credential wrappers.

load '../../helpers/test-helpers'
load '../../helpers/setup-teardown'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'

setup() {
    standard_setup
    export CORE_DIR="$(get_dotfiles_root)/bin/core"
    export ZSHRC="$(get_dotfiles_root)/home/.config/zsh/.zshrc"
    export TEST_BIN="$TEST_TEMP_DIR/bin"
    export API_KEY_LOOKUP_LOG="$TEST_TEMP_DIR/api-key-lookups"
    export WRAPPER_ARGS_OUTPUT="$TEST_TEMP_DIR/wrapper-args"
    export WRAPPER_ENV_OUTPUT="$TEST_TEMP_DIR/wrapper-env"
    mkdir -p "$TEST_BIN"
    export PATH="$TEST_BIN:$PATH"

    cat > "$TEST_BIN/get-api-key" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$1" >> "$API_KEY_LOOKUP_LOG"
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

run_agent_wrapper() {
    local agent="$1"
    local override_name="$2"
    local upstream
    upstream="$(create_fake_upstream "$agent")"
    ln -s "$CORE_DIR/$agent" "$TEST_BIN/$agent"

    run env "$override_name=$upstream" "$TEST_BIN/$agent" --model test-model 'test prompt'

    assert_success
    assert_equal "$(cat "$WRAPPER_ARGS_OUTPUT")" $'--model\ntest-model\ntest prompt'
}

assert_only_loaded_key() {
    local key_name="$1"

    assert_equal "$(cat "$API_KEY_LOOKUP_LOG")" "$key_name"
    run grep -Fx "$key_name=$key_name-test-value" "$WRAPPER_ENV_OUTPUT"
    assert_success
}

@test "agent CLI wrappers do not use dump-api-keys" {
    run grep -F "dump-api-keys" "$ZSHRC"
    assert_failure

    run grep -R -F "dump-api-keys" "$CORE_DIR"
    assert_failure
}

@test "codex wrapper loads only the OpenAI key and forwards arguments" {
    run_agent_wrapper codex DOTFILES_CODEX_BIN
    assert_only_loaded_key OPENAI_API_KEY
}

@test "claude wrapper loads only the Anthropic key and forwards arguments" {
    run_agent_wrapper claude DOTFILES_CLAUDE_BIN
    assert_only_loaded_key ANTHROPIC_API_KEY
}

@test "pi wrapper loads its curated provider keys and forwards arguments" {
    run_agent_wrapper pi DOTFILES_PI_BIN

    assert_equal "$(cat "$API_KEY_LOOKUP_LOG")" $'ANTHROPIC_API_KEY\nANT_LING_API_KEY\nOPENAI_API_KEY\nAZURE_OPENAI_API_KEY\nDEEPSEEK_API_KEY\nNVIDIA_API_KEY\nGEMINI_API_KEY\nGROQ_API_KEY\nCEREBRAS_API_KEY\nXAI_API_KEY\nFIREWORKS_API_KEY\nTOGETHER_API_KEY\nOPENROUTER_API_KEY\nAI_GATEWAY_API_KEY\nZAI_API_KEY\nZAI_CODING_CN_API_KEY\nMISTRAL_API_KEY\nMINIMAX_API_KEY\nMOONSHOT_API_KEY\nOPENCODE_API_KEY\nKIMI_API_KEY\nCLOUDFLARE_API_KEY\nQWEN_TOKEN_PLAN_API_KEY\nQWEN_TOKEN_PLAN_CN_API_KEY\nXIAOMI_API_KEY\nXIAOMI_TOKEN_PLAN_CN_API_KEY\nXIAOMI_TOKEN_PLAN_AMS_API_KEY\nXIAOMI_TOKEN_PLAN_SGP_API_KEY'
    run grep -Fx 'GITHUB_TOKEN=GITHUB_TOKEN-test-value' "$WRAPPER_ENV_OUTPUT"
    assert_failure
}
