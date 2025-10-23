# ~/.config/zsh/personal-config.zsh
# Personal machine configuration and aliases

# Display available commands
echo "🏠 Personal environment loaded (prompt shows: HOME:PERSONAL). Available commands:"
echo "  home-sync / home-sync-up  - Sync home environment"
echo "  home-push / home-pull     - Push/pull changes"
echo "  sync-start / sync-stop    - Control sync service"

# Personal environment sync aliases
alias home-sync-up="home-sync sync"
alias home-push="home-sync push"
alias home-pull="home-sync pull"
alias home-status="home-sync status"
alias sync-start="home-sync-service start"
alias sync-stop="home-sync-service stop"
alias sync-status="home-sync-service status"

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
