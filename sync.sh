#!/usr/bin/env bash

# Dotfiles Sync Script (GNU Stow)
# Usage: ./sync.sh [options]
# Syncs dotfiles across machines and manages Stow packages

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_DIR="$DOTFILES_DIR/stow-packages"

# Function to log messages
log() {
    local level="$1"
    shift
    case "$level" in
        "INFO")  echo -e "${BLUE}[INFO]${NC} $*" ;;
        "SUCCESS") echo -e "${GREEN}[SUCCESS]${NC} $*" ;;
        "WARN")  echo -e "${YELLOW}[WARN]${NC} $*" ;;
        "ERROR") echo -e "${RED}[ERROR]${NC} $*" ;;
    esac
}

# Function to display usage
usage() {
    cat << EOF
Dotfiles Sync Script (GNU Stow)

Usage: $0 [OPTIONS]

OPTIONS:
    -h, --help          Show this help message
    -p, --pull          Pull latest changes from remote
    -u, --push          Push local changes to remote
    -s, --status        Show git status
    -r, --restow        Re-stow all currently installed packages
    -c, --check         Check for conflicts
    --list-installed    List currently installed packages

EXAMPLES:
    $0 --pull           # Pull latest changes and re-stow
    $0 --push           # Push local changes
    $0 --status         # Show git status
    $0 --restow         # Re-stow all packages
    $0 --check          # Check for conflicts

EOF
}

# Function to check if git repo exists
check_git_repo() {
    if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
        log "ERROR" "Not a git repository: $DOTFILES_DIR"
        exit 1
    fi
}

# Function to get installed packages
get_installed_packages() {
    local installed=()
    
    # Check each potential package
    for package_dir in "$STOW_DIR"/*; do
        if [[ -d "$package_dir" ]]; then
            local package=$(basename "$package_dir")
            
            # Check if any files from this package are currently linked
            if find "$package_dir" -type f | head -1 | read -r sample_file; then
                local relative_path="${sample_file#$package_dir/}"
                local target_path="$HOME/$relative_path"
                
                if [[ -L "$target_path" ]]; then
                    local link_target=$(readlink "$target_path")
                    if [[ "$link_target" == *"$package"* ]]; then
                        installed+=("$package")
                    fi
                fi
            fi
        fi
    done
    
    printf '%s\n' "${installed[@]}"
}

# Function to pull changes
pull_changes() {
    log "INFO" "Pulling latest changes from remote..."
    
    cd "$DOTFILES_DIR"
    
    if git pull; then
        log "SUCCESS" "Successfully pulled changes"
        
        # Re-stow installed packages
        log "INFO" "Re-stowing installed packages..."
        restow_packages
    else
        log "ERROR" "Failed to pull changes"
        exit 1
    fi
}

# Function to push changes
push_changes() {
    log "INFO" "Pushing local changes to remote..."
    
    cd "$DOTFILES_DIR"
    
    # Check if there are changes to commit
    if git diff --quiet && git diff --cached --quiet; then
        log "INFO" "No changes to commit"
    else
        log "INFO" "Found uncommitted changes:"
        git status --short
        
        read -p "Do you want to commit and push these changes? (y/N): " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            read -p "Enter commit message: " commit_msg
            if [[ -n "$commit_msg" ]]; then
                git add .
                git commit -m "$commit_msg"
            else
                log "ERROR" "Commit message cannot be empty"
                exit 1
            fi
        else
            log "INFO" "Skipping commit"
            return 0
        fi
    fi
    
    if git push; then
        log "SUCCESS" "Successfully pushed changes"
    else
        log "ERROR" "Failed to push changes"
        exit 1
    fi
}

# Function to show git status
show_status() {
    log "INFO" "Git repository status:"
    cd "$DOTFILES_DIR"
    git status
    
    echo
    log "INFO" "Installed packages:"
    get_installed_packages | while read -r package; do
        echo "  ✅ $package"
    done
}

# Function to restow packages
restow_packages() {
    local installed_packages
    while IFS= read -r package; do
        installed_packages+=("$package")
    done < <(get_installed_packages)
    
    if [[ ${#installed_packages[@]} -eq 0 ]]; then
        log "INFO" "No packages currently installed"
        return 0
    fi
    
    log "INFO" "Re-stowing packages: ${installed_packages[*]}"
    
    for package in "${installed_packages[@]}"; do
        log "INFO" "Re-stowing package: $package"
        if stow -R -d "$STOW_DIR" -t "$HOME" "$package"; then
            log "SUCCESS" "Re-stowed package: $package"
        else
            log "ERROR" "Failed to re-stow package: $package"
        fi
    done
}

# Function to check for conflicts
check_conflicts() {
    log "INFO" "Checking for conflicts..."
    
    local conflicts_found=false
    
    for package_dir in "$STOW_DIR"/*; do
        if [[ -d "$package_dir" ]]; then
            local package=$(basename "$package_dir")
            
            log "INFO" "Checking package: $package"
            
            # Use stow's dry-run to check for conflicts
            if ! stow -n -d "$STOW_DIR" -t "$HOME" "$package" 2>/dev/null; then
                log "WARN" "Conflicts found for package: $package"
                stow -n -d "$STOW_DIR" -t "$HOME" "$package" 2>&1 | sed 's/^/  /'
                conflicts_found=true
            fi
        fi
    done
    
    if [[ "$conflicts_found" == "false" ]]; then
        log "SUCCESS" "No conflicts found"
    else
        log "WARN" "Conflicts found. Use --force with install.sh to resolve"
    fi
}

# Function to list installed packages
list_installed() {
    log "INFO" "Currently installed packages:"
    
    local installed_packages
    while IFS= read -r package; do
        installed_packages+=("$package")
    done < <(get_installed_packages)
    
    if [[ ${#installed_packages[@]} -eq 0 ]]; then
        log "INFO" "No packages currently installed"
    else
        for package in "${installed_packages[@]}"; do
            echo "  ✅ $package"
        done
    fi
}

# Main function
main() {
    local action=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -p|--pull)
                action="pull"
                shift
                ;;
            -u|--push)
                action="push"
                shift
                ;;
            -s|--status)
                action="status"
                shift
                ;;
            -r|--restow)
                action="restow"
                shift
                ;;
            -c|--check)
                action="check"
                shift
                ;;
            --list-installed)
                action="list-installed"
                shift
                ;;
            -*)
                log "ERROR" "Unknown option: $1"
                usage
                exit 1
                ;;
            *)
                log "ERROR" "Unknown argument: $1"
                usage
                exit 1
                ;;
        esac
    done
    
    # Check prerequisites
    check_git_repo
    
    if ! command -v stow &> /dev/null; then
        log "ERROR" "GNU Stow is not installed"
        log "INFO" "Install it with: brew install stow"
        exit 1
    fi
    
    # Execute action
    case "$action" in
        "pull")
            pull_changes
            ;;
        "push")
            push_changes
            ;;
        "status")
            show_status
            ;;
        "restow")
            restow_packages
            ;;
        "check")
            check_conflicts
            ;;
        "list-installed")
            list_installed
            ;;
        "")
            log "ERROR" "No action specified"
            usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
