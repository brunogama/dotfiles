#!/usr/bin/env bash
# Agent session: identity injection and authenticated token minting for the
# coding-agent CLI wrappers.
#
# Harness-agnostic by design: identity and GitHub settings come from one
# global config file (home/.config/dotfiles/agent.conf), never from this file.

set -euo pipefail
IFS=$'\n\t'

readonly AGENT_CONFIG="${DOTFILES_AGENT_CONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/agent.conf}"

AGENT_NAME=""
AGENT_EMAIL=""
GITHUB_APP_ID=""

# Load the global agent config into AGENT_NAME / AGENT_EMAIL / GITHUB_APP_ID.
# Only whitelisted keys are read; the file is optional.
load_agent_config() {
	local line key value

	[[ -r "$AGENT_CONFIG" ]] || return 0

	while IFS= read -r line || [[ -n "$line" ]]; do
		line="${line%%#*}"
		[[ "$line" == *'='* ]] || continue
		key="${line%%=*}"
		value="${line#*=}"
		key="${key//[[:space:]]/}"
		# Trim surrounding whitespace and optional double quotes.
		value="${value#"${value%%[![:space:]]*}"}"
		value="${value%"${value##*[![:space:]]}"}"
		value="${value#\"}"
		value="${value%\"}"

		case "$key" in
		AGENT_NAME) AGENT_NAME="$value" ;;
		AGENT_EMAIL) AGENT_EMAIL="$value" ;;
		GITHUB_APP_ID) GITHUB_APP_ID="$value" ;;
		*) ;;
		esac
	done <"$AGENT_CONFIG"
}

# Set Git author and committer identity only with a complete configuration.
apply_agent_identity() {
	[[ -n "${AGENT_NAME:-}" && -n "${AGENT_EMAIL:-}" ]] || return 0

	export GIT_AUTHOR_NAME="$AGENT_NAME"
	export GIT_AUTHOR_EMAIL="${AGENT_EMAIL:-}"
	export GIT_COMMITTER_NAME="$AGENT_NAME"
	export GIT_COMMITTER_EMAIL="${AGENT_EMAIL:-}"
}

# Mint a GitHub App installation token for the agent. The App private key is
# read from the credentials backend (credfile) and passed to the Python helper
# over stdin; the resulting token is exported for the harness process. Missing
# App credentials are a no-op so the wrapper never blocks on an unprovisioned
# App.
mint_agent_github_token() {
	local script_base credfile_bin helper_bin key token
	unset GH_ENTERPRISE_TOKEN GITHUB_ENTERPRISE_TOKEN

	if [[ -n "${DOTFILES_AGENT_GH_TOKEN:-}" ]]; then
		export GH_TOKEN="$DOTFILES_AGENT_GH_TOKEN"
		export GITHUB_TOKEN="$DOTFILES_AGENT_GH_TOKEN"
		return 0
	fi

	# Prefer repository-scoped App tokens by default. Export the user's gh CLI
	# credential only when explicitly opted in, because that token may have
	# broader account scopes than an agent wrapper should inherit implicitly.
	if [[ "${DOTFILES_AGENT_USE_GH_TOKEN:-0}" == "1" ]] &&
		command -v gh >/dev/null 2>&1; then
		if token="$(gh auth token 2>/dev/null)" && [[ -n "$token" ]]; then
			export GH_TOKEN="$token"
			export GITHUB_TOKEN="$token"
			return 0
		fi
	fi

	# Use an App token unless an explicit token or an opted-in gh token worked.
	unset GH_TOKEN GITHUB_TOKEN
	[[ -n "${GITHUB_APP_ID:-}" ]] || return 0

	script_base="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
	credfile_bin="${DOTFILES_CREDFILE_BIN:-$script_base/../credentials/credfile}"
	helper_bin="${DOTFILES_AGENT_GH_MINT_BIN:-$script_base/agent-github-mint}"

	if [[ -n "${DOTFILES_AGENT_GH_KEY_FILE:-}" ]]; then
		key="$(cat "$DOTFILES_AGENT_GH_KEY_FILE" 2>/dev/null || true)"
	else
		key="$("$credfile_bin" get GITHUB_APP_PRIVATE_KEY 2>/dev/null || true)"
	fi
	if [[ -z "$key" ]]; then
		printf 'agent: GitHub App private key not found; token minting skipped\n' >&2
		return 0
	fi

	if token="$(printf '%s\n' "$key" | "$helper_bin" --app-id "$GITHUB_APP_ID")" && [[ -n "$token" ]]; then
		export GH_TOKEN="$token"
		export GITHUB_TOKEN="$token"
	else
		printf 'agent: GitHub App token minting failed\n' >&2
	fi
}

# Run the harness binary and exit with its status.
run_agent() {
	local binary="$1"
	shift
	local status=0

	load_agent_config
	apply_agent_identity
	mint_agent_github_token

	set +e
	"$binary" "$@"
	status=$?
	set -e

	exit "$status"
}
