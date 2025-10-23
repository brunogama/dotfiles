# shellcheck shell=bash
# ~/.config/zsh/personal-config.zsh
# Personal machine configuration and aliases

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

# Display available commands
echo "🏠 Personal environment loaded (prompt shows: HOME:PERSONAL). Available commands:"
echo "  syncenv / sync            - Sync dotfiles (smart git strategy)"
echo "  syncenv --status          - Check sync status"
echo "  home-sync / home-sync-up  - Legacy sync (use syncenv instead)"

# Modern syncenv aliases (recommended)
alias sync="syncenv"
alias sync-personal="syncenv personal"
alias sync-work="syncenv work"
alias sync-status="syncenv --status"
alias sync-dry="syncenv --dry-run"

# Legacy aliases (deprecated, use syncenv instead)
alias home-sync-up="home-sync sync"
alias home-push="home-sync push"
alias home-pull="home-sync pull"
alias home-status="home-sync status"
alias sync-start="home-sync-service start"
alias sync-stop="home-sync-service stop"

# Homebrew management aliases
alias brew-install="brew-sync install"
alias brew-update="brew-sync update"
alias brew-full-sync="brew-sync sync"

# Personal environment variables
export MACHINE_TYPE="personal"
export HOME_ENV="personal"
export EDITOR="code"
export VISUAL="code"

# Personal-specific aliases and functions
alias personal-backup="home-sync push && echo '✅ Personal environment backed up'"
alias personal-restore="home-sync pull && echo '✅ Personal environment restored'"

# Development shortcuts for personal projects
alias dev="cd ~/Developer"
alias projects="cd ~/Projects"
alias personal="cd ~/Personal"

# Quick configuration editing (uses dynamic path resolution)
alias edit-personal="open-dotfiles-config personal"
alias edit-zsh="open-dotfiles-config zsh"
alias edit-git="open-dotfiles-config git"
alias edit-dotfiles="open-dotfiles-config repo"

# Personal productivity aliases
alias cleanup="brew cleanup && brew autoremove"
alias update-all="brew update && brew upgrade && home-sync-up"
