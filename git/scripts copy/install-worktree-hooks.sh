#!/usr/bin/env bash
# Install Git Worktree Hooks
# This script installs hooks for enhanced worktree experience

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}❌${NC} $1"; }
log_header() { echo -e "${PURPLE}🔧${NC} $1"; }

# Ensure we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    log_error "Not in a git repository"
    exit 1
fi

# Get git hooks directory
HOOKS_DIR="$(git rev-parse --git-dir)/hooks"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log_header "Installing Git Worktree Hooks"

# Create hooks directory if it doesn't exist
mkdir -p "$HOOKS_DIR"

# Install hooks
install_hook() {
    local hook_name="$1"
    local source_file="$SCRIPT_DIR/git-hooks/$hook_name"
    local target_file="$HOOKS_DIR/$hook_name"
    
    if [[ ! -f "$source_file" ]]; then
        log_error "Source hook not found: $source_file"
        return 1
    fi
    
    # Backup existing hook if it exists
    if [[ -f "$target_file" ]]; then
        log_warning "Backing up existing $hook_name hook"
        cp "$target_file" "$target_file.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Copy and make executable
    cp "$source_file" "$target_file"
    chmod +x "$target_file"
    
    log_success "Installed $hook_name hook"
}

# Install each hook
install_hook "post-checkout"
install_hook "pre-commit"

# Create configuration file
CONFIG_FILE="$HOME/.gitconfig-worktree"
if [[ ! -f "$CONFIG_FILE" ]]; then
    cat > "$CONFIG_FILE" << 'EOF'
# Git Worktree Configuration
# Source this file or add to your shell configuration

# Environment variables for hook behavior
export WORKTREE_HOOKS_ENABLED=true
export WORKTREE_LINT_ENABLED=true
export WORKTREE_TEST_ENABLED=false

# Worktree base directory (customize as needed)
export WORKTREE_BASE_DIR="$(git rev-parse --show-toplevel 2>/dev/null)/../worktrees"

# Default branch name
export DEFAULT_BRANCH="main"
EOF
    log_success "Created configuration file: $CONFIG_FILE"
    log_info "Add 'source $CONFIG_FILE' to your shell configuration"
else
    log_info "Configuration file already exists: $CONFIG_FILE"
fi

# Add git aliases to global config
log_info "Adding git aliases..."

git config --global alias.wt-list 'worktree list'
git config --global alias.wt-add 'worktree add'
git config --global alias.wt-remove 'worktree remove'
git config --global alias.wt-prune 'worktree prune'

log_success "Git aliases added"

# Create shell integration file
SHELL_INTEGRATION="$HOME/.git-worktree-integration"
cat > "$SHELL_INTEGRATION" << 'EOF'
# Git Worktree Shell Integration
# Add this to your .bashrc, .zshrc, or equivalent

# Load worktree configuration
if [[ -f "$HOME/.gitconfig-worktree" ]]; then
    source "$HOME/.gitconfig-worktree"
fi

# Enhanced cd function for worktrees
wtcd() {
    local branch="$1"
    if [[ -z "$branch" ]]; then
        echo "Usage: wtcd <branch>"
        return 1
    fi
    
    # Find worktree path
    local worktree_path
    worktree_path=$(git worktree list | grep "$branch" | awk '{print $1}' | head -n 1)
    
    if [[ -n "$worktree_path" && -d "$worktree_path" ]]; then
        cd "$worktree_path"
        echo "Switched to worktree: $worktree_path"
    else
        echo "Worktree for branch '$branch' not found"
        return 1
    fi
}

# Auto-completion for wtcd (bash)
if [[ -n "$BASH_VERSION" ]]; then
    _wtcd_completion() {
        local cur="${COMP_WORDS[COMP_CWORD]}"
        local branches
        branches=$(git worktree list --porcelain | grep "^branch" | sed 's/^branch refs\/heads\///' | tr '\n' ' ')
        COMPREPLY=($(compgen -W "$branches" -- "$cur"))
    }
    complete -F _wtcd_completion wtcd
fi

# Auto-completion for wtcd (zsh)
if [[ -n "$ZSH_VERSION" ]]; then
    _wtcd() {
        local branches
        branches=($(git worktree list --porcelain | grep "^branch" | sed 's/^branch refs\/heads\///'))
        compadd -a branches
    }
    compdef _wtcd wtcd
fi

# Prompt enhancement to show worktree info
worktree_prompt_info() {
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        local worktree_root
        worktree_root="$(git rev-parse --show-toplevel)"
        local main_repo
        main_repo="$(git rev-parse --git-common-dir)"
        
        # Check if we're in a worktree
        if [[ "$worktree_root/.git" != "$main_repo" ]]; then
            local branch
            branch="$(git branch --show-current)"
            echo " [wt:$branch]"
        fi
    fi
}

# Example PS1 integration (customize as needed)
# PS1='${PS1}$(worktree_prompt_info)'
EOF

log_success "Created shell integration file: $SHELL_INTEGRATION"

# Make scripts executable
chmod +x "$SCRIPT_DIR/git-worktree-manager.sh" 2>/dev/null || true
chmod +x "$SCRIPT_DIR/git-aliases.sh" 2>/dev/null || true

log_header "Installation Summary"
echo
echo "✅ Installed hooks:"
echo "   - post-checkout: Enhanced worktree switching experience"
echo "   - pre-commit: Quality checks before commits"
echo
echo "✅ Created configuration:"
echo "   - $CONFIG_FILE"
echo "   - $SHELL_INTEGRATION"
echo
echo "✅ Added git aliases:"
echo "   - git wt-list"
echo "   - git wt-add"
echo "   - git wt-remove"
echo "   - git wt-prune"
echo
echo "🔧 Next steps:"
echo "   1. Source the configuration: source $CONFIG_FILE"
echo "   2. Add shell integration: source $SHELL_INTEGRATION"
echo "   3. Initialize worktree structure: ./scripts/git-worktree-manager.sh init"
echo "   4. Create your first worktree: ./scripts/git-worktree-manager.sh create feature/my-feature"
echo
echo "💡 Tips:"
echo "   - Use 'wtcd <branch>' to quickly switch between worktrees"
echo "   - Customize hook behavior with environment variables in $CONFIG_FILE"
echo "   - Run './scripts/git-worktree-manager.sh help' for full usage"

log_success "Git Worktree hooks installation completed!"
