# lazy-load.zsh - Defer heavy tool initialization until first use
# Version: 2.1
#
# This framework lazy-loads expensive tools to dramatically improve
# shell startup time. Tools are initialized transparently on first use.

# ============================================================================
# Lazy Load: NVM (Node Version Manager)
# ============================================================================
# True lazy loading - nvm.sh is only sourced on first use of nvm/node/npm/npx.
# Saves ~100-200ms on shell startup compared to sourcing nvm.sh eagerly.
# After first use, .nvmrc auto-switching is enabled via chpwd hook.

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    # Internal function to initialize nvm and set up .nvmrc auto-switching
    _lazy_load_nvm() {
        unfunction nvm node npm npx 2>/dev/null
        source "$NVM_DIR/nvm.sh"

        # Set up automatic version switching for .nvmrc files
        autoload -U add-zsh-hook

        load-nvmrc() {
            local nvmrc_path
            nvmrc_path="$(nvm_find_nvmrc)"

            if [[ -n "$nvmrc_path" ]]; then
                local nvmrc_node_version
                nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

                if [[ "$nvmrc_node_version" = "N/A" ]]; then
                    nvm install
                elif [[ "$nvmrc_node_version" != "$(nvm version)" ]]; then
                    nvm use --silent
                fi
            elif [[ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ]] && [[ "$(nvm version)" != "$(nvm version default)" ]]; then
                nvm use default --silent
            fi
        }

        add-zsh-hook chpwd load-nvmrc
        load-nvmrc  # Check current directory for .nvmrc
    }

    nvm() {
        _lazy_load_nvm
        nvm "$@"
    }

    node() {
        _lazy_load_nvm
        node "$@"
    }

    npm() {
        _lazy_load_nvm
        npm "$@"
    }

    npx() {
        _lazy_load_nvm
        npx "$@"
    }
fi

# ============================================================================
# Lazy Load: mise (polyglot version manager)
# ============================================================================
if command -v mise &>/dev/null; then
    mise() {
        unfunction mise
        eval "$(command mise activate zsh)"
        mise "$@"
    }
fi

# ============================================================================
# Lazy Load: pyenv (Python version manager)
# ============================================================================
# Note: Prezto's python module is configured with skip-init in .zpreztorc
# We handle lazy loading here for better startup performance (~100-200ms saved)
if [[ -d "$PYENV_ROOT" ]] || command -v pyenv &>/dev/null; then
    pyenv() {
        unfunction pyenv
        eval "$(command pyenv init -)"
        pyenv "$@"
    }

    # Also intercept python/pip/python3/pip3 commands
    python() {
        unfunction python pyenv 2>/dev/null
        eval "$(command pyenv init -)"
        python "$@"
    }

    python3() {
        unfunction python3 pyenv 2>/dev/null
        eval "$(command pyenv init -)"
        python3 "$@"
    }

    pip() {
        unfunction pip pyenv 2>/dev/null
        eval "$(command pyenv init -)"
        pip "$@"
    }

    pip3() {
        unfunction pip3 pyenv 2>/dev/null
        eval "$(command pyenv init -)"
        pip3 "$@"
    }
fi

# ============================================================================
# Lazy Load: rbenv (Ruby version manager)
# ============================================================================
# Note: Prezto's ruby module is configured with skip-init in .zpreztorc
# We handle lazy loading here for better startup performance (~50-100ms saved)
if [[ -d "$RBENV_ROOT" ]] || command -v rbenv &>/dev/null; then
    rbenv() {
        unfunction rbenv
        eval "$(command rbenv init - zsh)"
        rbenv "$@"
    }

    # Also intercept ruby/gem/bundle commands
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

    bundle() {
        unfunction bundle rbenv 2>/dev/null
        eval "$(command rbenv init - zsh)"
        bundle "$@"
    }
fi

# ============================================================================
# Lazy Load: SDKMAN (JVM version manager)
# ============================================================================
if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    sdk() {
        unset -f sdk java gradle maven kotlin groovy scala
        export SDKMAN_DIR="$HOME/.sdkman"
        setopt LOCAL_OPTIONS SH_WORD_SPLIT 2>/dev/null
        source "$SDKMAN_DIR/bin/sdkman-init.sh" 2>/dev/null
        sdk "$@"
    }

    # Intercept common JVM commands
    java() {
        unset -f sdk java gradle maven kotlin groovy scala
        export SDKMAN_DIR="$HOME/.sdkman"
        setopt LOCAL_OPTIONS SH_WORD_SPLIT 2>/dev/null
        source "$SDKMAN_DIR/bin/sdkman-init.sh" 2>/dev/null
        java "$@"
    }

    gradle() {
        unset -f sdk java gradle maven kotlin groovy scala
        export SDKMAN_DIR="$HOME/.sdkman"
        setopt LOCAL_OPTIONS SH_WORD_SPLIT 2>/dev/null
        source "$SDKMAN_DIR/bin/sdkman-init.sh" 2>/dev/null
        gradle "$@"
    }
fi

# ============================================================================
# Lazy Load: FZF (fuzzy finder)
# ============================================================================
# Note: FZF can be loaded in background in .zshrc for immediate availability.
# This is a fallback if background loading fails.
if command -v fzf &>/dev/null && [[ ! -f ~/.fzf-loaded ]]; then
    _load_fzf() {
        unfunction _load_fzf 2>/dev/null
        source <(fzf --zsh) 2>/dev/null
        touch ~/.fzf-loaded
    }

    # Intercept Ctrl+R if fzf not loaded
    bindkey '^R' _load_fzf
fi
