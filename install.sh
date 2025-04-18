#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print section header
print_header() {
    echo -e "\n${BLUE}==>${NC} ${GREEN}$1${NC}"
}

# Print info message
print_info() {
    echo -e "${BLUE}-->${NC} $1"
}

# Print success message
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Print error message
print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Print warning message
print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install dependencies based on OS
install_dependencies() {
    print_header "Installing dependencies"
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if ! command_exists brew; then
            print_info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            
            # Add Homebrew to PATH
            if [[ "$(uname -m)" == "arm64" ]]; then
                # Apple Silicon
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
                eval "$(/opt/homebrew/bin/brew shellenv)"
            else
                # Intel
                echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        else
            print_success "Homebrew already installed"
        fi
        
        print_info "Installing Stow with Homebrew..."
        brew install stow
    elif [[ -f /etc/debian_version ]]; then
        # Debian/Ubuntu
        print_info "Installing Stow with apt..."
        sudo apt update && sudo apt install -y stow
    elif [[ -f /etc/fedora-release ]]; then
        # Fedora
        print_info "Installing Stow with dnf..."
        sudo dnf install -y stow
    elif [[ -f /etc/arch-release ]]; then
        # Arch Linux
        print_info "Installing Stow with pacman..."
        sudo pacman -S --noconfirm stow
    else
        print_error "Unsupported operating system. Please install GNU Stow manually."
        exit 1
    fi
    
    print_success "Dependencies installed"
}

# Install Prezto
install_prezto() {
    print_header "Setting up Prezto"
    
    if [[ -d "${ZDOTDIR:-$HOME}/.zprezto" ]]; then
        print_info "Prezto already installed, updating..."
        cd "${ZDOTDIR:-$HOME}/.zprezto"
        git pull && git submodule update --init --recursive
        print_success "Prezto updated"
    else
        print_info "Installing Prezto..."
        git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
        print_success "Prezto installed"
    fi
}

# Backup existing dotfiles
backup_dotfiles() {
    print_header "Backing up existing dotfiles"
    
    # Create backup directory with timestamp
    BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Backup Prezto configuration files if they exist and are not symlinks
    for rcfile in "${ZDOTDIR:-$HOME}"/.z{shenv,shrc,login,logout,profile,preztorc}; do
        if [[ -f "$rcfile" && ! -L "$rcfile" ]]; then
            print_info "Backing up $rcfile to $BACKUP_DIR"
            cp "$rcfile" "$BACKUP_DIR/"
        fi
    done
    
    # Backup other dotfiles
    for config_dir in "$HOME/.config/nvim" "$HOME/.config/alacritty"; do
        if [[ -d "$config_dir" && ! -L "$config_dir" ]]; then
            print_info "Backing up $config_dir to $BACKUP_DIR"
            cp -r "$config_dir" "$BACKUP_DIR/"
        fi
    done
    
    print_success "Backup completed to $BACKUP_DIR"
}

# Install packages from Brewfile
install_brew_packages() {
    print_header "Installing packages from Brewfile"
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command_exists brew; then
            DOTFILES_DIR="$HOME/Developer/dotfiles"
            
            # Check if Brewfile exists
            if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
                print_info "Installing packages from Brewfile..."
                cd "$DOTFILES_DIR"
                brew bundle install --file="$DOTFILES_DIR/Brewfile"
                print_success "Packages installed successfully"
            else
                print_warning "Brewfile not found at $DOTFILES_DIR/Brewfile"
            fi
        else
            print_error "Homebrew is not installed. Cannot install packages from Brewfile."
        fi
    else
        print_warning "Not on macOS, skipping Brewfile installation."
    fi
}

# Remove default Prezto symlinks
remove_prezto_symlinks() {
    print_header "Removing default Prezto symlinks"
    
    for rcfile in "${ZDOTDIR:-$HOME}"/.z{shenv,shrc,login,logout,profile,preztorc}; do
        if [[ -L "$rcfile" ]]; then
            print_info "Removing symlink $rcfile"
            rm "$rcfile"
        elif [[ -f "$rcfile" ]]; then
            print_warning "File $rcfile exists but is not a symlink - backed up earlier"
            # We don't remove non-symlinks as they were backed up and might contain custom changes
        fi
    done
    
    print_success "Default Prezto symlinks removed"
}

# Apply dotfiles with Stow
apply_dotfiles() {
    print_header "Applying dotfiles with Stow"
    
    DOTFILES_DIR="$HOME/Developer/dotfiles"
    
    # Create necessary directories if they don't exist
    mkdir -p "$HOME/.config"
    
    # Apply Zsh/Prezto configurations
    if [[ -d "$DOTFILES_DIR/zsh" ]]; then
        print_info "Applying Zsh/Prezto configurations"
        cd "$DOTFILES_DIR"
        stow --dotfiles --target="$HOME" zsh
    fi
    
    # Apply other configurations
    if [[ -d "$DOTFILES_DIR/config" ]]; then
        print_info "Applying config files"
        cd "$DOTFILES_DIR"
        stow --dotfiles --target="$HOME/.config" config
    fi
    
    print_success "Dotfiles applied successfully"
}

# Main execution
main() {
    print_header "Dotfiles Installation Script"
    
    # Check if zsh is installed
    if ! command_exists zsh; then
        print_error "Zsh is not installed. Please install Zsh first."
        exit 1
    fi
    
    # Install dependencies
    install_dependencies
    
    # Backup existing dotfiles
    backup_dotfiles
    
    # Install Prezto
    install_prezto
    
    # Remove default Prezto symlinks
    remove_prezto_symlinks
    
    # Apply dotfiles with Stow
    apply_dotfiles
    
    # Install packages from Brewfile
    install_brew_packages
    
    print_header "Installation Complete!"
    print_info "Please restart your terminal or run 'source ~/.zshrc' to apply changes"
    print_info "If this is your first time using Prezto, you may want to set Zsh as your default shell:"
    print_info "chsh -s $(which zsh)"
}

# Run the script
main