#!/bin/bash
# Bruno's Dotfiles - One-Line Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/brunogama/dotfiles/main/install.sh | bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/brunogama/dotfiles.git"
DOTFILES_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install dependencies
install_dependencies() {
    log_info "Installing dependencies..."
    
    # Check for macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "This installer is designed for macOS only"
        exit 1
    fi
    
    # Install Xcode Command Line Tools if not present
    if ! xcode-select -p >/dev/null 2>&1; then
        log_info "Installing Xcode Command Line Tools..."
        xcode-select --install
        log_warning "Please complete the Xcode Command Line Tools installation and re-run this script"
        exit 1
    fi
    
    # Install Homebrew if not present
    if ! command_exists brew; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi
    
    # Install GNU Stow
    if ! command_exists stow; then
        log_info "Installing GNU Stow..."
        brew install stow
    fi
    
    # Install Git (should be available via Xcode tools, but ensure it's there)
    if ! command_exists git; then
        log_info "Installing Git..."
        brew install git
    fi
}

# Backup existing dotfiles
backup_existing() {
    log_info "Backing up existing dotfiles to $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"
    
    # List of common dotfiles to backup
    local files_to_backup=(
        ".zshrc" ".zprofile" ".zshenv" ".zpreztorc"
        ".gitconfig" ".gitignore_global"
        ".config/git" ".config/zsh"
    )
    
    for file in "${files_to_backup[@]}"; do
        if [[ -e "$HOME/$file" ]]; then
            cp -r "$HOME/$file" "$BACKUP_DIR/" 2>/dev/null || true
            log_info "Backed up: $file"
        fi
    done
}

# Clone dotfiles repository
clone_dotfiles() {
    log_info "Cloning dotfiles repository..."
    
    # Remove existing dotfiles directory if it exists
    if [[ -d "$DOTFILES_DIR" ]]; then
        log_warning "Existing dotfiles directory found. Moving to backup..."
        mv "$DOTFILES_DIR" "$BACKUP_DIR/config-backup"
    fi
    
    # Clone with submodules (includes Prezto)
    git clone --recurse-submodules "$REPO_URL" "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
}

# Install dotfiles packages
install_packages() {
    log_info "Installing dotfiles packages..."
    cd "$DOTFILES_DIR"
    
    # Install core packages first using stow directly
    log_info "Installing core packages (zsh, git, bin)..."
    stow -d stow-packages -t "$HOME" zsh git bin

    # Install sync service
    log_info "Installing sync service..."
    stow -d stow-packages -t "$HOME" sync-service

    # Install shell tools
    log_info "Installing shell tools..."
    stow -d stow-packages -t "$HOME" shell-tools

    # Install homebrew management
    log_info "Installing homebrew management..."
    stow -d stow-packages -t "$HOME" homebrew
    
    # Install macOS apps configuration (optional)
    if [[ -d "stow-packages/macos" ]]; then
        log_info "Installing macOS app configurations..."
        stow -d stow-packages -t "$HOME" macos
    fi
}

# Set up Prezto
setup_prezto() {
    log_info "Checking Prezto configuration..."

    # Check if Prezto is already installed
    if [[ -d "$HOME/.zprezto" ]]; then
        log_success "Prezto is already installed"
    else
        log_info "Prezto not found. Install manually if needed: https://github.com/sorin-ionescu/prezto"
        log_info "Note: Your zsh configuration will work without Prezto"
    fi

    # Create Prezto configuration symlinks if they don't exist
    log_info "Creating Prezto configuration symlinks..."

    if [[ ! -e "$HOME/.zpreztorc" ]]; then
        ln -sf "$HOME/.config/zsh/.zpreztorc" "$HOME/.zpreztorc"
        log_success "Created symlink: ~/.zpreztorc"
    else
        log_info "Symlink already exists: ~/.zpreztorc"
    fi

    if [[ ! -e "$HOME/.zprofile" ]]; then
        ln -sf "$HOME/.config/zsh/.zprofile" "$HOME/.zprofile"
        log_success "Created symlink: ~/.zprofile"
    else
        log_info "Symlink already exists: ~/.zprofile"
    fi

    if [[ ! -e "$HOME/.p10k.zsh" ]]; then
        ln -sf "$HOME/.config/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
        log_success "Created symlink: ~/.p10k.zsh"
    else
        log_info "Symlink already exists: ~/.p10k.zsh"
    fi

    # Create history file if it doesn't exist
    if [[ ! -f "$HOME/.config/zsh/.zsh_history" ]]; then
        touch "$HOME/.config/zsh/.zsh_history"
        log_success "Created history file: ~/.config/zsh/.zsh_history"
    fi
}

# Configure shell
configure_shell() {
    log_info "Configuring shell..."
    
    # Change default shell to zsh if not already
    if [[ "$SHELL" != */zsh ]]; then
        log_info "Changing default shell to zsh..."
        chsh -s $(which zsh)
        log_success "Default shell changed to zsh"
    fi
    
    # Source the new configuration
    if [[ -f "$HOME/.zshrc" ]]; then
        log_info "New shell configuration installed. Please restart your terminal or run: source ~/.zshrc"
    fi
}

# Set up credentials (optional)
setup_credentials() {
    log_info "Setting up credential management..."
    
    # Check if credmatch is available
    if command_exists credmatch; then
        log_success "CredMatch credential management is available"
        log_info "To set up credential sync, run: store-api-key 'CREDMATCH_MASTER_PASSWORD' 'your-master-password'"
    fi
    
    # Check if work secrets are available
    if command_exists backup-work-secrets; then
        log_success "Work secrets management is available"
        log_info "To backup work secrets, run: backup-work-secrets"
    fi
}

# Main installation function
main() {
    log_info "🏠 Bruno's Dotfiles Installer"
    log_info "=============================="
    echo
    
    # Check if running on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "This installer is designed for macOS only"
        exit 1
    fi
    
    # Install dependencies
    install_dependencies
    
    # Backup existing dotfiles
    backup_existing
    
    # Clone dotfiles repository
    clone_dotfiles
    
    # Install packages
    install_packages
    
    # Set up Prezto
    setup_prezto
    
    # Configure shell
    configure_shell
    
    # Set up credentials
    setup_credentials
    
    echo
    log_success "🎉 Dotfiles installation completed!"
    log_success "======================================"
    echo
    log_info "📋 Next Steps:"
    log_info "1. Restart your terminal or run: source ~/.zshrc"
    log_info "2. Set up credential sync (optional): store-api-key 'CREDMATCH_MASTER_PASSWORD' 'your-password'"
    log_info "3. Install background sync service: home-sync-service install"
    log_info "4. Check documentation: dotfiles-help"
    echo
    log_info "📁 Backup location: $BACKUP_DIR"
    log_info "📂 Dotfiles location: $DOTFILES_DIR"
    echo
    log_success "Welcome to your new development environment! 🚀"
}

# Handle script interruption
trap 'log_error "Installation interrupted"; exit 1' INT TERM

# Run main function
main "$@"