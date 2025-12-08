# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================================
# Optimized .zshrc for Fast Startup
# Performance target: < 500ms cold start, < 200ms warm start
# ============================================================================

# ============================================================================
# 1. PREZTO INITIALIZATION (Must be first for instant prompt)
# ============================================================================
# Note: Prezto's prompt module handles Powerlevel10k instant prompt internally.
# Do not manually source instant prompt - it conflicts with Prezto's mechanism.
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
export EDITOR="code"
export VISUAL="code"
export GIT_PAGER='delta'

# Unalias conflicting commands
unalias g 2>/dev/null
unalias o 2>/dev/null
unalias e 2>/dev/null

# ============================================================================
# 5. ALIASES (Instant - no performance impact)
# ============================================================================

# Shell & Config
alias zs='source ~/.config/zsh/.zshrc'
alias config='code $(realpath .)'
alias gitconfig='code ~/.gitconfig'

# Modern CLI tools
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --git --icons --group-directories-first'
alias tree='eza --tree --icons'
alias cat='bat --paging=never'
alias less='bat --paging=always'
alias find='fd'
alias grep='rg'
alias top='htop'
alias du='dust'

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
alias new-main-with-one-commit="git checkout -b main && git commit --allow-empty -m 'Initial commit' && git push -u origin main"
alias delete-main="git branch -D main && git push origin --delete main; git checkout -b main; new-main-with-one-commit"
alias delete-branch="git branch -D"
alias delete-remote-branch="git push origin --delete"
alias delete-tag="git tag -d"
alias delete-remote-tag="git push origin --delete"

# Help piped through bat
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# Navigation
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Escape hatches for aliased commands
alias old-find='/usr/bin/find'
alias old-grep='/usr/bin/grep'
alias old-cat='/bin/cat'

# Claude CLI
alias ccy='claude --dangerously-skip-permissions'
alias claude="/Users/bruno/.claude/local/claude"

# ============================================================================
# 6. FUNCTIONS (Fast utility functions)
# ============================================================================

# Create and enter directory
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Bat diff for git
batdiff() {
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
}

# Dead code detection (iOS specific)
deadcode() {
    local folder_name="$(basename "$(pwd)")"
    xcodebuild \
      -scheme "$folder_name" \
      -destination 'platform=iOS Simulator,OS=16.4,name=iPhone 14' \
      -derivedDataPath ~/Desktop/dd \
      clean build
    periphery scan \
      --skip-build \
      --index-store-path ~/Desktop/dd/Index.noindex/DataStore/ \
      --retain-public true \
      --targets "$folder_name"
    rm -rf ~/Desktop/dd
}

# ============================================================================
# 7. LAZY LOADING (Defer expensive tools until first use)
# ============================================================================
# Lazy loading for pyenv, rbenv, mise, and SDKMAN.
# Note: nvm lazy loading is handled by Prezto's node module (--no-use flag).
if [[ -f ~/.config/zsh/lib/lazy-load.zsh ]]; then
    source ~/.config/zsh/lib/lazy-load.zsh
fi

# ============================================================================
# 8. ESSENTIAL FAST TOOLS (< 50ms each - keep immediate)
# ============================================================================
# Zoxide (fast, essential for navigation)
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# ============================================================================
# 9. KEY BINDINGS
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
# 10. COMPLETION (Consolidated - called only once!)
# ============================================================================
# Add completion directories to fpath
fpath=(
    ~/.docker/completions(N)
    ~/.zsh_functions(N)
    $fpath
)

# Initialize completion (only once!)
autoload -Uz compinit

# Smart completion caching - only rebuild if older than 24 hours
setopt EXTENDEDGLOB
if [[ -n ${ZDOTDIR:-$HOME}/.config/zsh/.zcompdump(#qNmh+24) ]]; then
    compinit
else
    compinit -C  # Skip security check for speed
fi
unsetopt EXTENDEDGLOB

# ============================================================================
# 11. POWERLEVEL10K CONFIGURATION
# ============================================================================
# Note: Prezto's prompt module automatically sources ~/.config/zsh/.p10k.zsh
# when the powerlevel10k theme is loaded. Do not manually source it here as
# it causes conflicts with Prezto's initialization sequence.
#
# Configuration file location is set in LinkingManifest.json:
# zsh/.p10k.zsh -> ~/.config/zsh/.p10k.zsh

# ============================================================================
# 12. FZF (Load in background for responsiveness)
# ============================================================================
if [[ -o interactive ]] && command -v fzf &>/dev/null; then
    # Background load to not block startup
    {
        source <(fzf --zsh) 2>/dev/null
        touch ~/.fzf-loaded
    } &!
fi

# ============================================================================
# 13. PATHS (Consolidated)
# ============================================================================
# Add custom paths (avoid duplicates)
# Note: .local/bin is added LAST so system tools take precedence
path=(
    $HOME/.claude/local(N)
    $HOME/.cache/lm-studio/bin(N)
    $path
    $HOME/.local/bin(N)
)

# Deduplicate PATH
typeset -U path

# ============================================================================
# 14. ENVIRONMENT VARIABLES (Non-blocking)
# ============================================================================
export PYENV_ROOT="$HOME/.pyenv"
export RBENV_ROOT="$HOME/.rbenv"
export NVM_DIR="$HOME/.nvm"
export SDKMAN_DIR="$HOME/.sdkman"

# Add version manager bin paths to PATH (for lazy-loading detection)
# Note: PATH is deduplicated by typeset -U above
path=(
    $PYENV_ROOT/bin(N)
    $RBENV_ROOT/bin(N)
    $SDKMAN_DIR/bin(N)
    $path
)

# ============================================================================
# END OF OPTIMIZED .zshrc
# Expected startup time: < 500ms (cold), < 200ms (warm)
# ============================================================================

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# Context Window Manager Aliases
# =============================================================================
export CTX_MANAGER_PATH="/Users/bruno/Developer/deep-researchs/commands/context-window-management-command"
export CTX_STORAGE_BASE="/Users/bruno/ai_data"

# Context Window Management aliases
alias ctx-manager='python3 $CTX_MANAGER_PATH/context_storage_manager.py'
alias ctx-stats='python3 $CTX_MANAGER_PATH/context_storage_manager.py stats'
alias ctx-search='python3 $CTX_MANAGER_PATH/context_storage_manager.py search'
alias ctx-store='python3 $CTX_MANAGER_PATH/context_storage_manager.py store'
alias ctx-examples='python3 $CTX_MANAGER_PATH/examples.py'
alias ctx-setup='bash $CTX_MANAGER_PATH/setup.sh'

# PromptKit Aliases
# =============================================================================
export PROMPTKIT_PATH="/Users/bruno/Developer/Inbox/PromptKit"
export PROMPTKIT_STORAGE_BASE="/Users/bruno/ai_data"

# Context Window Management aliases
alias pk-manager='python3 $PROMPTKIT_PATH/promptkit.py'
alias pk-stats='python3 $PROMPTKIT_PATH/promptkit.py stats'
alias pk-search='python3 $PROMPTKIT_PATH/promptkit.py search'
alias pk-store='python3 $PROMPTKIT_PATH/promptkit.py store'
alias pk-examples='python3 $PROMPTKIT_PATH/promptkit_examples.py'
alias pk-setup='bash $PROMPTKIT_PATH/setup.sh'

kimi-cc() {
    export ANTHROPIC_AUTH_TOKEN=$(get-api-key KIMI_API_KEY)
	export ANTHROPIC_BASE_URL=https://api.moonshot.ai/anthropic
	export ANTHROPIC_MODEL=kimi-k2-thinking
	export ANTHROPIC_DEFAULT_OPUS_MODEL=kimi-k2-thinking-turbo
	export ANTHROPIC_DEFAULT_SONNET_MODEL=kimi-k2-thinking-turbo
	export ANTHROPIC_DEFAULT_HAIKU_MODEL=kimi-k2-thinking-turbo
	export CLAUDE_CODE_SUBAGENT_MODEL=kimi-k2-thinking-turbo
	claude $@
}

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
