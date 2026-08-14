#!/usr/bin/env bash
# Loads a Keychain credential only for the agent process being launched.

load_agent_api_key() {
	local key_name="$1"
	local key_value

	key_value="$(get-api-key "$key_name" 2>/dev/null)" || return 0
	[[ -n "$key_value" ]] || return 0
	export "$key_name=$key_value"
}

# Loads only the explicit credentials required by one agent wrapper.
load_agent_api_keys() {
	local key_name

	for key_name in "$@"; do
		load_agent_api_key "$key_name"
	done
}
