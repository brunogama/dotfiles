# Work Configuration
# This file contains work-specific shell configuration

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

# Work environment variables (customize as needed)
# export WORK_ENV="development"
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

echo "💼 Work configuration loaded. Available commands:"
echo "  ws / load-work-secrets    - Load work secrets into environment"
echo "  ws-list                   - List available work secrets"  
echo "  ws-store <key> <value>    - Store a new work secret"
echo "  ws-get <key>              - Get a specific work secret"
echo "  work-profile <env>        - Switch work environment (dev/prod/staging)"
echo ""
