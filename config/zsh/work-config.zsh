# shellcheck shell=bash
# Work Configuration
# This file contains work-specific shell configuration

# Auto-install/update scripts if dotfiles repo is available
if [[ -d "$HOME/.config-fixing-dot-files-bugs" ]]; then
    DOTFILES_REPO="$HOME/.config-fixing-dot-files-bugs"
    LOCAL_BIN="$HOME/.local/bin"
    SCRIPTS_UPDATED_MARKER="$LOCAL_BIN/.scripts-updated"

    # Check if scripts need update (comparing timestamps)
    if [[ -d "$DOTFILES_REPO/scripts" ]] && [[ -d "$LOCAL_BIN" ]]; then
        # Find newest file in scripts directory
        NEWEST_SCRIPT=$(find "$DOTFILES_REPO/scripts" -type f -not -name "*.md" -print0 2>/dev/null | xargs -0 stat -f "%m %N" 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)

        if [[ -n "$NEWEST_SCRIPT" ]]; then
            SCRIPTS_MTIME=$(stat -f "%m" "$NEWEST_SCRIPT" 2>/dev/null || echo "0")
            MARKER_MTIME=$(stat -f "%m" "$SCRIPTS_UPDATED_MARKER" 2>/dev/null || echo "0")

            if [[ "$SCRIPTS_MTIME" -gt "$MARKER_MTIME" ]]; then
                (cd "$DOTFILES_REPO" && make install-scripts >/dev/null 2>&1)
                touch "$SCRIPTS_UPDATED_MARKER"
            fi
        elif [[ ! -f "$SCRIPTS_UPDATED_MARKER" ]]; then
            # First time setup
            (cd "$DOTFILES_REPO" && make install-scripts >/dev/null 2>&1)
            touch "$SCRIPTS_UPDATED_MARKER"
        fi
    fi
fi

# Ensure ~/bin is in PATH for credential management scripts
if [[ -d "$HOME/bin" && ":$PATH:" != *":$HOME/bin:"* ]]; then
    export PATH="$HOME/bin:$PATH"
fi

# Ensure ~/.config/bin is in PATH for credential management scripts
if [[ -d "$HOME/.config/bin" && ":$PATH:" != *":$HOME/.config/bin:"* ]]; then
    export PATH="$HOME/.config/bin:$PATH"
fi

# Source work secrets functions
if [[ -f "$HOME/.config/zsh/.zsh_functions/work-secrets" ]]; then
    source "$HOME/.config/zsh/.zsh_functions/work-secrets"
fi

# Auto-load work secrets on shell startup (optional - uncomment to enable)
# Uncomment the next line to automatically load work secrets when starting a new shell
# load-work-secrets "" "true" &>/dev/null

# Work-specific aliases
alias work-secrets="list-work-secrets"
alias ws="load-work-secrets"
alias ws-list="list-work-secrets"
alias ws-store="store-work-secret"
alias ws-get="get-work-secret"
alias ws-backup="backup-work-secrets"
alias ws-sync="sync-work-secrets"

# Quick configuration editing (uses dynamic path resolution)
alias edit-work="open-dotfiles-config work"
alias edit-zsh="open-dotfiles-config zsh"
alias edit-git="open-dotfiles-config git"
alias edit-dotfiles="open-dotfiles-config repo"

# Homebrew management aliases
alias brew-install="brew-sync install"
alias brew-update="brew-sync update"
alias brew-full-sync="brew-sync sync"

# Modern syncenv aliases (recommended)
alias sync="syncenv"
alias sync-personal="syncenv personal"
alias sync-work="syncenv work"
alias sync-status="syncenv --status"
alias sync-dry="syncenv --dry-run"

# Legacy home sync aliases (deprecated, use syncenv instead)
alias home-sync-up="home-sync sync"
alias home-push="home-sync push"
alias home-pull="home-sync pull"
alias home-status="home-sync status"
alias sync-start="home-sync-service start"
alias sync-stop="home-sync-service stop"

# Work environment variables (customize as needed)
export WORK_ENV="work"  # This enables the "WORK" indicator in the prompt
# export COMPANY_NAME="YourCompany"

# Function to quickly switch between work profiles
work-profile() {
    local profile="${1:-default}"

    case "$profile" in
        "dev"|"development")
            echo "🔧 Loading development work profile..."
            load-work-secrets ".*DEV.*|.*DEVELOPMENT.*"
            export WORK_ENV="development"
            ;;
        "prod"|"production")
            echo "🚀 Loading production work profile..."
            load-work-secrets ".*PROD.*|.*PRODUCTION.*"
            export WORK_ENV="production"
            ;;
        "staging")
            echo "🎭 Loading staging work profile..."
            load-work-secrets ".*STAGING.*|.*STAGE.*"
            export WORK_ENV="staging"
            ;;
        "default"|*)
            echo "💼 Loading default work profile..."
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
compdef _work_profile_completion work-profile

echo "💼 Work environment loaded (prompt shows: WORK). Available commands:"
echo "  syncenv / sync            - Sync dotfiles (smart git strategy)"
echo "  syncenv --status          - Check sync status"
echo "  ws / load-work-secrets    - Load work secrets into environment"
echo "  ws-list                   - List available work secrets"
echo "  work-profile <env>        - Switch work environment (dev/prod/staging)"
echo ""
