# shellcheck shell=bash
# ~/.config/zsh/personal-config.zsh
# Personal machine configuration and aliases
# Optimized for fast startup - no blocking operations

# ============================================================================
# AUTO-UPDATE (Background, cached daily)
# ============================================================================
# Check once per day - runs in background to not block startup
if [[ -d "$HOME/.dotfiles" ]]; then
    # Create cache directory
    mkdir -p ~/.cache/zsh 2>/dev/null

    # Check if we've already updated today
    TODAY_MARKER=~/.cache/zsh/scripts-checked-$(date +%Y%m%d)

    if [[ ! -f "$TODAY_MARKER" ]]; then
        # Update in background (non-blocking)
        {
            if command -v update-dotfiles-scripts &>/dev/null; then
                update-dotfiles-scripts &>/dev/null
                # Clean old markers (use setopt NULL_GLOB to avoid error if no matches)
                setopt LOCAL_OPTIONS NULL_GLOB
                rm -f ~/.cache/zsh/scripts-checked-* 2>/dev/null
                touch "$TODAY_MARKER"
            fi
        } &!
    fi
fi

# ============================================================================
# WELCOME MESSAGE - Removed to comply with Powerlevel10k instant prompt
# ============================================================================
# Console output during zsh initialization interferes with instant prompt.
# The prompt indicator already shows HOME:PERSONAL, so this message is redundant.

# ============================================================================
# MODERN SYNCENV ALIASES (Recommended)
# ============================================================================
alias sync="syncenv"
alias sync-personal="syncenv personal"
alias sync-work="syncenv work"
alias sync-status="syncenv --status"
alias sync-dry="syncenv --dry-run"

# ============================================================================
# LEGACY SYNC ALIASES (Deprecated)
# ============================================================================
alias home-sync-up="home-sync sync"
alias home-push="home-sync push"
alias home-pull="home-sync pull"
alias home-status="home-sync status"
alias sync-start="home-sync-service start"
alias sync-stop="home-sync-service stop"

# ============================================================================
# HOMEBREW MANAGEMENT
# ============================================================================
alias brew-install="brew-sync install"
alias brew-update="brew-sync update"
alias brew-full-sync="brew-sync sync"

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================
export MACHINE_TYPE="personal"
export HOME_ENV="personal"

# ============================================================================
# PERSONAL-SPECIFIC ALIASES
# ============================================================================
alias personal-backup="home-sync push && echo 'Personal environment backed up'"
alias personal-restore="home-sync pull && echo 'Personal environment restored'"

# Development shortcuts
alias dev="cd ~/Developer"
alias projects="cd ~/Projects"
alias personal="cd ~/Personal"

# ============================================================================
# QUICK CONFIGURATION EDITING
# ============================================================================
alias edit-personal="open-dotfiles-config personal"
alias edit-zsh="open-dotfiles-config zsh"
alias edit-git="open-dotfiles-config git"
alias edit-dotfiles="open-dotfiles-config repo"

# ============================================================================
# PRODUCTIVITY ALIASES
# ============================================================================
alias cleanup="brew cleanup && brew autoremove"
alias update-all="brew update && brew upgrade && home-sync-up"
