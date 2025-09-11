#!/usr/bin/env bash

# Dotfiles Installation Script (GNU Stow)
# Usage: ./install.sh [packages...]
# Examples:
#   ./install.sh              # Install all packages
#   ./install.sh zsh git      # Install specific packages
#   ./install.sh --help       # Show help

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
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

# Available packages
AVAILABLE_PACKAGES=(
    "zsh"           # ZSH shell configuration
    "git"           # Git configuration and aliases
    "bin"           # Custom scripts and binaries
    "homebrew"      # Homebrew package management
    "sync-service"  # Home environment sync service
    "shell-tools"   # Shell tools (mise, fish, etc.)
    "development"   # Development tools (cursor, copilot, etc.)
    "macos"         # macOS-specific apps (raycast, Rectangle)
)

# Function to display usage
usage() {
    cat << EOF
Dotfiles Installation Script (GNU Stow)

Usage: $0 [OPTIONS] [PACKAGES...]

OPTIONS:
    -h, --help      Show this help message
    -l, --list      List available packages
    -b, --backup    Create backup before installation
    -f, --force     Force installation (overwrite conflicts)
    -d, --dry-run   Show what would be installed without doing it

PACKAGES:
$(printf "    %-15s %s\n" \
    "zsh" "ZSH shell configuration" \
    "git" "Git configuration and aliases" \
    "bin" "Custom scripts and binaries" \
    "homebrew" "Homebrew package management" \
    "sync-service" "Home environment sync service" \
    "shell-tools" "Shell tools (mise, fish, etc.)" \
    "development" "Development tools (cursor, copilot, etc.)" \
    "macos" "macOS-specific apps (raycast, Rectangle)")

EXAMPLES:
    $0                      # Install all packages
    $0 zsh git             # Install only zsh and git
    $0 --list              # List available packages
    $0 --backup zsh        # Backup existing configs before installing zsh
    $0 --dry-run           # Preview what would be installed

EOF
}

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

# Function to check if a package exists
package_exists() {
    local package="$1"
    [[ -d "$STOW_DIR/$package" ]]
}

# Function to check if stow is installed
check_stow() {
    if ! command -v stow &> /dev/null; then
        log "ERROR" "GNU Stow is not installed"
        log "INFO" "Install it with: brew install stow"
        exit 1
    fi
}

# Function to backup existing configs
backup_config() {
    local package="$1"
    local package_dir="$STOW_DIR/$package"
    
    if [[ ! -d "$package_dir" ]]; then
        return 0
    fi
    
    log "INFO" "Creating backup for package: $package"
    mkdir -p "$BACKUP_DIR"
    
    # Find all files that would be linked and backup if they exist
    find "$package_dir" -type f | while read -r file; do
        local relative_path="${file#$package_dir/}"
        local target_path="$HOME/$relative_path"
        
        if [[ -e "$target_path" && ! -L "$target_path" ]]; then
            local backup_path="$BACKUP_DIR/$relative_path"
            mkdir -p "$(dirname "$backup_path")"
            cp "$target_path" "$backup_path"
            log "INFO" "Backed up: $relative_path"
        fi
    done
}

# Function to install a package
install_package() {
    local package="$1"
    local force="$2"
    local dry_run="$3"
    
    if ! package_exists "$package"; then
        log "ERROR" "Package '$package' does not exist"
        return 1
    fi
    
    log "INFO" "Installing package: $package"
    
    if [[ "$dry_run" == "true" ]]; then
        log "INFO" "[DRY RUN] Would install package: $package"
        stow -n -d "$STOW_DIR" -t "$HOME" "$package" 2>&1 | sed 's/^/  /'
        return 0
    fi
    
    local stow_args=(-d "$STOW_DIR" -t "$HOME")
    if [[ "$force" == "true" ]]; then
        stow_args+=(--adopt)
    fi
    
    if stow "${stow_args[@]}" "$package"; then
        log "SUCCESS" "Installed package: $package"
        return 0
    else
        log "ERROR" "Failed to install package: $package"
        return 1
    fi
}

# Function to list available packages
list_packages() {
    log "INFO" "Available packages:"
    for package in "${AVAILABLE_PACKAGES[@]}"; do
        local status="❌"
        if package_exists "$package"; then
            status="✅"
        fi
        echo "  $status $package"
    done
}

# Main function
main() {
    local packages=()
    local create_backup=false
    local force=false
    local dry_run=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -l|--list)
                list_packages
                exit 0
                ;;
            -b|--backup)
                create_backup=true
                shift
                ;;
            -f|--force)
                force=true
                shift
                ;;
            -d|--dry-run)
                dry_run=true
                shift
                ;;
            -*)
                log "ERROR" "Unknown option: $1"
                usage
                exit 1
                ;;
            *)
                packages+=("$1")
                shift
                ;;
        esac
    done
    
    # Check prerequisites
    check_stow
    
    # If no packages specified, install all available packages
    if [[ ${#packages[@]} -eq 0 ]]; then
        packages=("${AVAILABLE_PACKAGES[@]}")
        log "INFO" "No packages specified, installing all available packages"
    fi
    
    # Validate packages
    for package in "${packages[@]}"; do
        if ! package_exists "$package"; then
            log "ERROR" "Package '$package' does not exist"
            log "INFO" "Available packages: ${AVAILABLE_PACKAGES[*]}"
            exit 1
        fi
    done
    
    log "INFO" "Starting dotfiles installation..."
    log "INFO" "Dotfiles directory: $DOTFILES_DIR"
    log "INFO" "Target directory: $HOME"
    log "INFO" "Packages to install: ${packages[*]}"
    
    # Create backups if requested
    if [[ "$create_backup" == "true" ]]; then
        for package in "${packages[@]}"; do
            backup_config "$package"
        done
        if [[ -d "$BACKUP_DIR" ]]; then
            log "SUCCESS" "Backups created in: $BACKUP_DIR"
        fi
    fi
    
    # Install packages
    local success_count=0
    local total_count=${#packages[@]}
    
    for package in "${packages[@]}"; do
        if install_package "$package" "$force" "$dry_run"; then
            ((success_count++))
        fi
    done
    
    # Summary
    echo
    log "INFO" "Installation summary: $success_count/$total_count packages"
    
    if [[ "$dry_run" == "false" && $success_count -eq $total_count ]]; then
        log "SUCCESS" "All packages installed successfully!"
        echo
        log "INFO" "Next steps:"
        echo "  1. Restart your terminal or run: source ~/.zshrc"
        echo "  2. Check that everything works as expected"
        echo "  3. Remove old config directories if everything looks good"
    elif [[ "$dry_run" == "true" ]]; then
        log "INFO" "Dry run completed. Run without --dry-run to install."
    else
        log "WARN" "Some packages failed to install. Check the errors above."
        exit 1
    fi
}

# Run main function
main "$@"
