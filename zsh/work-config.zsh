# shellcheck shell=bash
# ~/.config/zsh/work-config.zsh
# Work machine configuration
# Optimized for fast startup - no blocking operations

# ============================================================================
# AUTO-UPDATE (Background, cached daily)
# ============================================================================
# Check once per day - runs in background to not block startup
if [[ -d "$HOME/.config-fixing-dot-files-bugs" ]]; then
    # Create cache directory
    mkdir -p ~/.cache/zsh 2>/dev/null

    # Check if we've already updated today
    TODAY_MARKER=~/.cache/zsh/scripts-checked-$(date +%Y%m%d)

    if [[ ! -f "$TODAY_MARKER" ]]; then
        # Update in background (non-blocking)
        {
            if command -v update-dotfiles-scripts &>/dev/null; then
                update-dotfiles-scripts &>/dev/null
                # Clean old markers
                rm -f ~/.cache/zsh/scripts-checked-* 2>/dev/null
                touch "$TODAY_MARKER"
            fi
        } &!
    fi
fi

# ============================================================================
# PATH SETUP
# ============================================================================
# Ensure ~/bin and ~/.local/bin in PATH (at end for lower priority)
if [[ -d "$HOME/bin" && ":$PATH:" != *":$HOME/bin:"* ]]; then
    export PATH="$PATH:$HOME/bin"
fi

if [[ -d "$HOME/.local/bin" && ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$PATH:$HOME/.local/bin"
fi

# ============================================================================
# WORK SECRETS (Lazy load)
# ============================================================================
# Source work secrets functions (but don't auto-load)
if [[ -f "$HOME/.config-fixing-dot-files-bugs/zsh/.zsh_functions/work-secrets" ]]; then
    source "$HOME/.config-fixing-dot-files-bugs/zsh/.zsh_functions/work-secrets"
fi

# Note: Auto-load disabled for performance
# Uncomment to auto-load secrets on shell startup:
# load-work-secrets "" "true" &>/dev/null

# ============================================================================
# WELCOME MESSAGE (Interactive only)
# ============================================================================
if [[ -o interactive ]]; then
    echo "Work environment loaded (prompt shows: WORK)"
    echo "  Available commands: sync, ws/load-work-secrets, work-profile"
fi

# ============================================================================
# WORK-SPECIFIC ALIASES
# ============================================================================
alias work-secrets="list-work-secrets"
alias ws="load-work-secrets"
alias ws-list="list-work-secrets"
alias ws-store="store-work-secret"
alias ws-get="get-work-secret"
alias ws-backup="backup-work-secrets"
alias ws-sync="sync-work-secrets"

# ============================================================================
# QUICK CONFIGURATION EDITING
# ============================================================================
alias edit-work="open-dotfiles-config work"
alias edit-zsh="open-dotfiles-config zsh"
alias edit-git="open-dotfiles-config git"
alias edit-dotfiles="open-dotfiles-config repo"

# ============================================================================
# HOMEBREW MANAGEMENT
# ============================================================================
alias brew-install="brew-sync install"
alias brew-update="brew-sync update"
alias brew-full-sync="brew-sync sync"

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
# ENVIRONMENT VARIABLES
# ============================================================================
export WORK_ENV="work"  # Enables "WORK" indicator in prompt
# export COMPANY_NAME="YourCompany"

# ============================================================================
# WORK PROFILE SWITCHER
# ============================================================================
work-profile() {
    local profile="${1:-default}"

    case "$profile" in
        "dev"|"development")
            echo "Loading development work profile..."
            load-work-secrets ".*DEV.*|.*DEVELOPMENT.*"
            export WORK_ENV="development"
            ;;
        "prod"|"production")
            echo "Loading production work profile..."
            load-work-secrets ".*PROD.*|.*PRODUCTION.*"
            export WORK_ENV="production"
            ;;
        "staging")
            echo "Loading staging work profile..."
            load-work-secrets ".*STAGING.*|.*STAGE.*"
            export WORK_ENV="staging"
            ;;
        "default"|*)
            echo "Loading default work profile..."
            load-work-secrets
            export WORK_ENV="default"
            ;;
    esac
}

# Tab completion for work-profile
_work_profile_completion() {
    local profiles=("dev" "development" "prod" "production" "staging" "default")
    compadd -a profiles
}

if [[ -o interactive ]]; then
    compdef _work_profile_completion work-profile
fi
