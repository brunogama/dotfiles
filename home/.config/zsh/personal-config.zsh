# shellcheck shell=bash
# ~/.config/zsh/personal-config.zsh
# Personal machine configuration and aliases
# Optimized for fast startup - no blocking operations

# ============================================================================
# AUTO-UPDATE (Background, cached daily)
# ============================================================================
# Avoid external date/mkdir calls on every startup. Only do work when ~/.dotfiles
# exists and today's marker is missing.
_dotfiles_auto_update_once_daily() {
    local dotfiles_dir="$HOME/.dotfiles"
    [[ -d "$dotfiles_dir" ]] || return

    zmodload -F zsh/datetime b:strftime 2>/dev/null || return

    local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
    local today_marker="$cache_dir/scripts-checked-$(strftime '%Y%m%d')"
    [[ -f "$today_marker" ]] && return

    {
        mkdir -p "$cache_dir" 2>/dev/null
        if command -v update-dotfiles-scripts &>/dev/null; then
            update-dotfiles-scripts &>/dev/null
            setopt LOCAL_OPTIONS NULL_GLOB
            rm -f "$cache_dir"/scripts-checked-* 2>/dev/null
            touch "$today_marker"
        fi
    } >/dev/null 2>&1 &
}
_dotfiles_auto_update_once_daily
unfunction _dotfiles_auto_update_once_daily

# ============================================================================
# WELCOME MESSAGE - Omitted to keep interactive startup and prompt output clean
# ============================================================================
# Keep initialization silent so prompt rendering remains clean.
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
