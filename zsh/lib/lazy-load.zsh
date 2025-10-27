# lazy-load.zsh - Defer heavy tool initialization until first use
# Version: 1.0
#
# This framework lazy-loads expensive tools to dramatically improve
# shell startup time. Tools are initialized transparently on first use.

# ============================================================================
# Lazy Load: mise
# ============================================================================
if command -v mise &>/dev/null; then
    mise() {
        unfunction mise
        eval "$(command mise activate zsh)"
        mise "$@"
    }
fi

# ============================================================================
# Lazy Load: pyenv
# ============================================================================
if command -v pyenv &>/dev/null; then
    pyenv() {
        unfunction pyenv
        eval "$(command pyenv init -)"
        pyenv "$@"
    }

    # Also intercept python/pip commands
    python() {
        unfunction python pyenv 2>/dev/null
        eval "$(command pyenv init -)"
        python "$@"
    }

    pip() {
        unfunction pip pyenv 2>/dev/null
        eval "$(command pyenv init -)"
        pip "$@"
    }
fi

# ============================================================================
# Lazy Load: rbenv
# ============================================================================
if command -v rbenv &>/dev/null; then
    rbenv() {
        unfunction rbenv
        eval "$(command rbenv init - zsh)"
        rbenv "$@"
    }

    # Also intercept ruby/gem commands
    ruby() {
        unfunction ruby rbenv 2>/dev/null
        eval "$(command rbenv init - zsh)"
        ruby "$@"
    }

    gem() {
        unfunction gem rbenv 2>/dev/null
        eval "$(command rbenv init - zsh)"
        gem "$@"
    }
fi

# ============================================================================
# Lazy Load: NVM (Node Version Manager)
# ============================================================================
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    nvm() {
        unset -f nvm node npm npx 2>/dev/null
        source "$NVM_DIR/nvm.sh"
        nvm "$@"
    }

    node() {
        unset -f nvm node npm npx 2>/dev/null
        source "$NVM_DIR/nvm.sh"
        node "$@"
    }

    npm() {
        unset -f nvm node npm npx 2>/dev/null
        source "$NVM_DIR/nvm.sh"
        npm "$@"
    }

    npx() {
        unset -f nvm node npm npx 2>/dev/null
        source "$NVM_DIR/nvm.sh"
        npx "$@"
    }
fi

# ============================================================================
# Lazy Load: SDKMAN
# ============================================================================
if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    sdk() {
        unset -f sdk
        export SDKMAN_DIR="$HOME/.sdkman"
        setopt LOCAL_OPTIONS SH_WORD_SPLIT 2>/dev/null
        source "$SDKMAN_DIR/bin/sdkman-init.sh" 2>/dev/null
        sdk "$@"
    }
fi

# ============================================================================
# Lazy Load: FZF (if not loaded immediately)
# ============================================================================
# Note: FZF can be loaded in background in .zshrc for immediate availability
# This is a fallback if background loading fails
if command -v fzf &>/dev/null && [[ ! -f ~/.fzf-loaded ]]; then
    _load_fzf() {
        unfunction _load_fzf 2>/dev/null
        source <(fzf --zsh) 2>/dev/null
        touch ~/.fzf-loaded
    }

    # Intercept Ctrl+R if fzf not loaded
    bindkey '^R' _load_fzf
fi
