#!/usr/bin/env bash
# Agent session: identity injection, authenticated token minting, and per-run
# evidence recording for the coding-agent CLI wrappers.
#
# Harness-agnostic by design: identity and GitHub App settings come from one
# global config file (home/.config/dotfiles/agent.conf), never from this file.

set -euo pipefail
IFS=$'\n\t'

readonly AGENT_CONFIG="${DOTFILES_AGENT_CONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/agent.conf}"
readonly AGENT_EVIDENCE_ROOT="${DOTFILES_AGENT_EVIDENCE_ROOT:-.agents/evidence}"

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

# Override git and jj commit authorship from the configured identity.
# No-op when no identity is configured, so the environment is left untouched.
apply_agent_identity() {
    [[ -n "${AGENT_NAME:-}" ]] || return 0

    export GIT_AUTHOR_NAME="$AGENT_NAME"
    export GIT_AUTHOR_EMAIL="${AGENT_EMAIL:-}"
    export GIT_COMMITTER_NAME="$AGENT_NAME"
    export GIT_COMMITTER_EMAIL="${AGENT_EMAIL:-}"
    export JJ_USER="$AGENT_NAME"
    export JJ_EMAIL="${AGENT_EMAIL:-}"
}

# Mint a GitHub App installation token for the agent. The App private key is
# read from the credentials backend (credfile) and passed to the Python helper
# over stdin; the resulting token is exported for the harness process. Missing
# App credentials are a no-op so the wrapper never blocks on an unprovisioned
# App.
mint_agent_github_token() {
    local script_base credfile_bin helper_bin key token

    if [[ -n "${DOTFILES_AGENT_GH_TOKEN:-}" ]]; then
        export GH_TOKEN="$DOTFILES_AGENT_GH_TOKEN"
        export GITHUB_TOKEN="$DOTFILES_AGENT_GH_TOKEN"
        return 0
    fi

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

# Escape a string for safe embedding in a JSON string value. Handles the short
# escapes plus every remaining control character via \u00XX.
agent_json_escape() {
    local s="$1" c code out=""
    local i

    for ((i = 0; i < ${#s}; i++)); do
        c="${s:i:1}"
        case "$c" in
        '"') out+='\"' ;;
        '\') out+='\\' ;;
        $'\n') out+='\n' ;;
        $'\r') out+='\r' ;;
        $'\t') out+='\t' ;;
        $'\b') out+='\b' ;;
        $'\f') out+='\f' ;;
        *)
            printf -v code '%d' "'$c"
            if ((code < 0x20)); then
                printf -v out '%s\\u%04x' "$out" "$code"
            else
                out+="$c"
            fi
            ;;
        esac
    done
    printf '%s' "$out"
}

# List paths changed in the working tree relative to HEAD (git and colocated
# jj share the git backend), sorted and unique. Uses NUL-delimited porcelain
# output so names containing spaces, " -> ", or rename records parse intact.
agent_changed_files() {
    local field path

    while IFS= read -r -d '' field; do
        [[ -n "$field" ]] || continue
        path="${field:3}"
        printf '%s\n' "$path"
        if [[ "$field" == R* || "$field" == C* ]]; then
            # Rename/copy records emit the old path as the next NUL field.
            IFS= read -r -d '' _ || true
        fi
    done < <(git status --porcelain=v1 -z 2>/dev/null) | sort -u
}

# Write the per-run evidence record as JSON under AGENT_EVIDENCE_ROOT. The
# record attests what ran and what changed; correctness is CI's to decide.
# Returns non-zero when the record cannot be written.
emit_agent_run_record() {
    local agent="$1" status="$2" started_at="$3" ended_at="$4"
    local outdir="$AGENT_EVIDENCE_ROOT" outfile files_json file run_id
    local first=1

    files_json="["
    while IFS= read -r file; do
        [[ -n "$file" ]] || continue
        if ((first)); then
            first=0
        else
            files_json+=","
        fi
        files_json+="\"$(agent_json_escape "$file")\""
    done < <(agent_changed_files)
    files_json+="]"

    if ! mkdir -p "$outdir" 2>/dev/null; then
        printf 'agent: unable to create evidence directory %s\n' "$outdir" >&2
        return 1
    fi
    run_id="$(date -u +%Y%m%dT%H%M%S)-$$"
    outfile="$outdir/run-$run_id.json"

    if ! {
        printf '{\n'
        printf '  "agent": "%s",\n' "$(agent_json_escape "$agent")"
        printf '  "run_id": "%s",\n' "$(agent_json_escape "$run_id")"
        printf '  "identity": {"name": "%s", "email": "%s"},\n' \
            "$(agent_json_escape "${GIT_AUTHOR_NAME:-}")" \
            "$(agent_json_escape "${GIT_AUTHOR_EMAIL:-}")"
        printf '  "started_at": "%s",\n' "$(agent_json_escape "$started_at")"
        printf '  "ended_at": "%s",\n' "$(agent_json_escape "$ended_at")"
        printf '  "exit_code": %s,\n' "$status"
        printf '  "files_changed": %s\n' "$files_json"
        printf '}\n'
    } >"$outfile" 2>/dev/null; then
        printf 'agent: unable to write evidence record %s\n' "$outfile" >&2
        return 1
    fi
}

# Run the harness binary, then record evidence and exit with its status.
run_agent() {
    local agent="$1" binary="$2"
    shift 2
    local status=0 started_at ended_at

    load_agent_config
    apply_agent_identity
    mint_agent_github_token

    started_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

    set +e
    "$binary" "$@"
    status=$?
    set -e

    ended_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    if ! emit_agent_run_record "$agent" "$status" "$started_at" "$ended_at"; then
        # Preserve a nonzero harness status; only fail when the harness
        # succeeded but could not produce its required evidence record.
        if ((status == 0)); then
            status=1
        fi
    fi
    exit "$status"
}
