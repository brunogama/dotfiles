# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

path=(
    $PYENV_ROOT/shims(N)
    $PYENV_ROOT/bin(N)
    $RBENV_ROOT/bin(N)
    $SDKMAN_DIR/bin(N)
    $HOME/.claude/local(N)
    $HOME/.cache/lm-studio/bin(N)
    /opt/{homebrew,local}/{,s}bin(N)
    /usr/local/{,s}bin(N)
    $path
    $HOME/local/bin(N)
)

fpath=(
    ~/.docker/completions(N)
    ${ZDOTDIR:-$HOME/.config/zsh}/completion(N)
    ~/.zsh_functions(N)
    $fpath
)

# ============================================================================
# 2. PREZTO INITIALIZATION
# ============================================================================
if [[ -s "$HOME/.zprezto/init.zsh" ]]; then
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

# Load API keys before launching agent CLIs.
pi() {
    eval "$(dump-api-keys)"
    /opt/homebrew/bin/pi "$@"
}

claude() {
    eval "$(dump-api-keys)"
    /Users/bruno/.local/bin/claude "$@"
}

codex() {
    eval "$(dump-api-keys)"
    /Users/bruno/.local/bin/codex "$@"
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
# 12. POWERLEVEL10K CONFIGURATION
# ============================================================================
# Note: Prezto's prompt module automatically sources ~/.config/zsh/.p10k.zsh
# when the powerlevel10k theme is loaded. Do not manually source it here as
# it causes conflicts with Prezto's initialization sequence.
#
# Configuration file location is set in LinkingManifest.json:
# zsh/.p10k.zsh -> ~/.config/zsh/.p10k.zsh

# ============================================================================
# 13. FZF
# ============================================================================
# FZF key bindings are lazy-loaded by lib/lazy-load.zsh.

# ============================================================================
# END OF OPTIMIZED .zshrc
# Observed startup time: ~50ms warm in zsh -i/-l tests
# ============================================================================

# Prezto's powerlevel10k prompt module sources ~/.config/zsh/.p10k.zsh.
# Do not source it again here; that adds startup work and can duplicate prompt hooks.


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
