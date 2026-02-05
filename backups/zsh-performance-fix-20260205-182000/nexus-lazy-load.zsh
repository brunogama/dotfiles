
# ============================================================================
# NEXUS CREDENTIALS (Lazy-loaded)
# ============================================================================
# Load credentials only when needed, not on every shell startup.
# Saves ~1.1 seconds by avoiding synchronous keychain calls.

_nexus_credentials_loaded=false

_load_nexus_credentials() {
    if [[ "$_nexus_credentials_loaded" == "false" ]]; then
        export NEXUS_USER="$(get-api-key NEXUS_USER)"
        export NEXUS_PASS="$(get-api-key NEXUS_PASS)"
        _nexus_credentials_loaded=true
    fi
}

# Wrapper functions that auto-load credentials
uv() {
    _load_nexus_credentials
    command uv "$@"
}

pip() {
    _load_nexus_credentials
    if command -v pyenv &>/dev/null; then
        unfunction pip pyenv 2>/dev/null
        eval "$(command pyenv init -)"
    fi
    command pip "$@"
}

pip3() {
    _load_nexus_credentials
    if command -v pyenv &>/dev/null; then
        unfunction pip3 pyenv 2>/dev/null
        eval "$(command pyenv init -)"
    fi
    command pip3 "$@"
}
