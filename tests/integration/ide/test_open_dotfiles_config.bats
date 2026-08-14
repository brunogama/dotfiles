#!/usr/bin/env bats

load '../../helpers/test-helpers'
load '../../helpers/setup-teardown'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'

setup() {
    standard_setup
    export SCRIPT="$(get_dotfiles_root)/bin/ide/open-dotfiles-config"
    export CODE_CALL="$TEST_TEMP_DIR/code-call"
    mkdir -p "$HOME/.dotfiles/home" "$HOME/.dotfiles/bin/core" "$TEST_TEMP_DIR/bin"
    touch "$HOME/.dotfiles/bin/core/link-dotfiles.py"
    cat > "$TEST_TEMP_DIR/bin/code" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$1" > "$CODE_CALL"
EOF
    chmod +x "$TEST_TEMP_DIR/bin/code"
    export PATH="$TEST_TEMP_DIR/bin:$PATH"
}

@test "open-dotfiles-config: discovers a convention-based checkout" {
    run "$SCRIPT" repo
    assert_success
    assert_file_contains "$CODE_CALL" "$HOME/.dotfiles"
}
