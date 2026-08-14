#!/usr/bin/env bash
# Loads a Keychain credential only for the agent process being launched.

set -euo pipefail
IFS=$'\n\t'

readonly AGENT_CREDENTIALS_BIN="${DOTFILES_CREDENTIALS_BIN:-$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/credentials}"

load_agent_api_key() {
    local key_name="$1"
    local key_value
    local credential_status

    if key_value="$("$AGENT_CREDENTIALS_BIN" get "$key_name")"; then
        [[ -n "$key_value" ]] || return 0
        export "$key_name=$key_value"
        return 0
    else
        credential_status=$?
    fi

    # API keys are optional for OAuth-backed CLIs, but surface backend failures.
    if (( credential_status != 4 )); then
        printf 'Unable to load credential %s (exit %d)\n' "$key_name" "$credential_status" >&2
    fi
}

# Loads only the explicit credentials required by one agent wrapper.
load_agent_api_keys() {
    local key_name

    for key_name in "$@"; do
        load_agent_api_key "$key_name"
    done
}
