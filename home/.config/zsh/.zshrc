# ============================================================================
# Optimized .zshrc for Fast Startup
# Performance target: < 150ms warm startup on this machine
# ============================================================================

# ============================================================================
# 1. EARLY PATH, FPATH, AND ENVIRONMENT
# ============================================================================
# Keep these before Prezto so its completion module sees custom fpath entries and
# tools installed by Homebrew are available in login and non-login shells.
typeset -gU path fpath

export EDITOR="code"
export VISUAL="code"
export PYENV_ROOT="$HOME/.pyenv"
export RBENV_ROOT="$HOME/.rbenv"
export NVM_DIR="$HOME/.nvm"
export SDKMAN_DIR="$HOME/.sdkman"
export UV_NATIVE_TLS=1

# Keep inherited Nix profile paths ahead of Homebrew and /usr/local fallbacks.
path=(
    $HOME/local/bin(N)
    $HOME/.claude/local(N)
    $HOME/.cache/lm-studio/bin(N)
    $path
    /opt/{homebrew,local}/{,s}bin(N)
    /usr/local/{,s}bin(N)
)

# Legacy version managers remain available as an explicit migration fallback.
if [[ "${DOTFILES_ENABLE_LEGACY_VERSION_MANAGERS:-0}" == "1" ]]; then
    path=(
        $PYENV_ROOT/shims(N)
        $PYENV_ROOT/bin(N)
        $RBENV_ROOT/bin(N)
        $SDKMAN_DIR/bin(N)
        $path
    )
fi

fpath=(
    ~/.docker/completions(N)
    ${ZDOTDIR:-$HOME/.config/zsh}/completion(N)
    ~/.zsh_functions(N)
    $fpath
)

# ============================================================================
# 2. PREZTO INITIALIZATION
# ============================================================================
if [[ -n "${ZPREZTODIR:-}" && -s "$ZPREZTODIR/runcoms/zshrc" ]]; then
  source "$ZPREZTODIR/runcoms/zshrc"
elif [[ -s "$HOME/.zprezto/init.zsh" ]]; then
  source "$HOME/.zprezto/init.zsh"
fi

# ============================================================================
# 3. ENVIRONMENT CONFIGURATION (Interactive only)
# ============================================================================
if [[ -o interactive ]]; then
    if [[ "$DOTFILES_ENV" == "work" ]]; then
        [[ -f ~/.config/zsh/work-config.zsh ]] && source ~/.config/zsh/work-config.zsh
    else
        [[ -f ~/.config/zsh/personal-config.zsh ]] && source ~/.config/zsh/personal-config.zsh
    fi
fi

# ============================================================================
# 4. CORE SETTINGS (Fast operations only)
# ============================================================================

# Unalias conflicting commands
unalias g 2>/dev/null
unalias o 2>/dev/null
unalias e 2>/dev/null
unalias gsd 2>/dev/null

# ============================================================================
# 5. ALIASES (Instant - no performance impact)
# ============================================================================

# Shell & Config
alias zs='source ~/.config/zsh/.zshrc'
alias dotfiles='e ~/Developer/dotfiles'
config() {
    local repo
    repo="$(git rev-parse --show-toplevel 2>/dev/null || pwd -P)"
    e "$repo"
}
alias gitconfig='code ~/.gitconfig'

# Git shortcuts
alias mkdir="mkdir -p"
alias commit="git commit"
alias ppulls="git pull || true; git submodule foreach 'git pull || true'"
alias ppush="git push || true; git submodule foreach 'git push || true'"
alias reset-hard="git reset --hard || true"
alias reset-hard-all="reset-hard; git submodule foreach 'git reset --hard'"
alias gs-all="git status; git submodule foreach 'git status'"

# Advanced git
alias gdinit="rm -rf .git; git submodule deinit -f .; fd -e .git -t f; fd -e .gitignore -x cp {} .gitignore; git add .gitignore; git commit -m 'Initial commit'"

# Navigation
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Claude CLI
alias ccy='claude --dangerously-skip-permissions'

# ============================================================================
# 6. FUNCTIONS (Fast utility functions)
# ============================================================================

# Create and enter directory
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# ============================================================================
# 7. LAZY LOADING (Defer expensive tools until first use)
# ============================================================================
# Optional nvm path helper, if present, must run after NVM_DIR is set above.
if [[ -f ~/.config/zsh/lib/nvm-path.zsh ]]; then
    source ~/.config/zsh/lib/nvm-path.zsh
fi

# Lazy loading for nvm, pyenv, rbenv, mise, SDKMAN, and fzf key bindings.
if [[ -f ~/.config/zsh/lib/lazy-load.zsh ]]; then
    source ~/.config/zsh/lib/lazy-load.zsh
fi

# ============================================================================
# 9. ESSENTIAL FAST TOOLS (< 50ms each - keep immediate)
# ============================================================================
# Zoxide (fast, essential for navigation)
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# ============================================================================
# 10. KEY BINDINGS
# ============================================================================
# Word navigation (multiple bindings for compatibility)
bindkey "^[[1;3D" backward-word  # Option+Left
bindkey "^[[1;3C" forward-word   # Option+Right
bindkey "^[b" backward-word      # Option+Left (alt)
bindkey "^[f" forward-word       # Option+Right (alt)
bindkey "\e[1;3D" backward-word  # Escape sequence
bindkey "\e[1;3C" forward-word   # Escape sequence
bindkey "\eb" backward-word      # Option+b
bindkey "\ef" forward-word       # Option+f

# ============================================================================
# 11. COMPLETION
# ============================================================================
# Completion is initialized by Prezto's completion module. Custom fpath entries
# are added before Prezto above so compinit runs once, not twice.
# Register pi explicitly so stale .zcompdump caches still pick up the new file.
if [[ -o interactive ]] && (( $+functions[compdef] )) && [[ -r "${ZDOTDIR:-$HOME/.config/zsh}/completion/_pi" ]]; then
    autoload -Uz _pi
    compdef _pi pi
fi

# ============================================================================
# 12. FZF
# ============================================================================
# FZF key bindings are lazy-loaded by lib/lazy-load.zsh.

# ============================================================================
# END OF OPTIMIZED .zshrc
# Observed startup time: ~50ms warm in zsh -i/-l tests
# ============================================================================


set-default-shell() {
	brew install zsh
	echo "/opt/homebrew/bin/zsh" | sudo tee -a /etc/shells
	chsh -s $(which zsh)
	echo "Default shell set to $(which zsh)"
}

# rbenv initialization handled by lazy-load.zsh


# Primary Agent Launcher
primary() {
  echo "Waking up the Primary Agent..."
  # "$@" automatically passes ALL arguments (text) you type to the agent
  claude --agent primary-agent "$@"
}

export PATH="$HOME/.local/share/pi-node/node-v22.23.1-linux-x64/bin:$HOME/.local/bin:$PATH"

# Starship owns the prompt; Prezto still provides completion, history, editing,
# syntax highlighting, and autosuggestions without loading its prompt module.
if [[ -o interactive ]] && (( $+commands[starship] )); then
    export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
    ZLE_RPROMPT_INDENT=0
    eval "$(starship init zsh)"

    # Starship has no native transient-prompt support for Zsh. Wrap the line
    # editor so an accepted command is redrawn with the character-only profile.
    # add-zle-hook-widget preserves Prezto's autosuggestion/highlighting hooks.
    _dotfiles_starship_transient_prompt() {
        emulate -L zsh
        [[ "$CONTEXT" == "start" ]] || return 0

        local -i edit_status
        while true; do
            zle .recursive-edit
            edit_status=$?
            [[ "$edit_status" == 0 && "$KEYS" == $'\4' ]] || break
            [[ -o ignore_eof ]] || exit 0
        done

        local transient_prompt
        transient_prompt="$(
            "$commands[starship]" prompt \
                --profile transient \
                --terminal-width="${COLUMNS:-80}" \
                --keymap="${KEYMAP:-viins}" \
                --status="${STARSHIP_CMD_STATUS:-0}" \
                --pipestatus="${STARSHIP_PIPE_STATUS[*]:-0}"
        )" || return
        transient_prompt="${transient_prompt#$'\n'}"

        local saved_prompt="$PROMPT"
        local saved_rprompt="$RPROMPT"
        PROMPT="$transient_prompt"
        RPROMPT=''
        zle .reset-prompt
        PROMPT="$saved_prompt"
        RPROMPT="$saved_rprompt"

        if (( edit_status )); then
            zle .send-break
        else
            zle .accept-line
        fi
        return "$edit_status"
    }

    autoload -Uz add-zle-hook-widget
    add-zle-hook-widget line-init _dotfiles_starship_transient_prompt
fi
