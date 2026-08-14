#!/usr/bin/env bats
# Regression tests for CredFile's CredMatch password transport.

load '../../helpers/test-helpers'
load '../../helpers/file-helpers'
load '../../helpers/setup-teardown'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'

setup() {
    standard_setup
    export SCRIPT="$(get_dotfiles_root)/bin/credentials/credfile"
    export CREDMATCH_ARGS="$TEST_TEMP_DIR/credmatch-args"
    export CREDMATCH_STDIN="$TEST_TEMP_DIR/credmatch-stdin"
    mkdir -p "$TEST_TEMP_DIR/bin"

    cat > "$TEST_TEMP_DIR/bin/get-api-key" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' 'test-master-password'
EOF
    cat > "$TEST_TEMP_DIR/bin/credmatch" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" > "$CREDMATCH_ARGS"
IFS= read -r password
printf '%s\n' "$password" > "$CREDMATCH_STDIN"
EOF
    chmod +x "$TEST_TEMP_DIR/bin/get-api-key" "$TEST_TEMP_DIR/bin/credmatch"
    export PATH="$TEST_TEMP_DIR/bin:$PATH"
}

@test "credfile: sends the master password to CredMatch over standard input" {
    local source_file="$TEST_TEMP_DIR/source-file"
    printf 'test content\n' > "$source_file"

    run "$SCRIPT" put test-file "$source_file"

    assert_success
    assert_file_contains "$CREDMATCH_ARGS" "store --master-stdin FILE_test-file"
    run grep -F "test-master-password" "$CREDMATCH_ARGS"
    assert_failure
    assert_file_contains "$CREDMATCH_STDIN" "test-master-password"
}

@test "credfile: has no positional CredMatch master-password calls" {
    run grep -E 'credmatch (store|fetch|list) "\$master_password"' "$SCRIPT"

    assert_failure
}

@test "credential quick reference: excludes the legacy dump-api-keys command" {
    local quick_reference="$(get_dotfiles_root)/docs/scripts/quick-reference.md"

    run grep -F "dump-api-keys" "$quick_reference"

    assert_failure
}
