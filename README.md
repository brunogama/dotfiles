# Bruno's Dotfiles

This repository contains my personal dotfiles and configuration files, managed with GNU Stow and Homebrew for easy deployment across multiple machines.

## Overview

These dotfiles provide configuration for:

- **Zsh** with Prezto framework
- **Homebrew** packages and applications
- **Vim/Neovim** configuration
- **Git** configuration
- **Terminal** configurations (iTerm2/Alacritty/etc.)
- Other various development tools

## Prerequisites

- **macOS** or **Linux**
- **Git**
- **Zsh**

## Installation

### Quick Install

```bash
git clone https://github.com/brunogama/dotfiles.git ~/Developer/dotfiles
cd ~/Developer/dotfiles
./install.sh
```

### Manual Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/brunogama/dotfiles.git ~/Developer/dotfiles
   ```

2. **Install GNU Stow** (if not already installed):
   ```bash
   # macOS
   brew install stow
   
   # Debian/Ubuntu
   sudo apt install stow
   
   # Fedora
   sudo dnf install stow
   
   # Arch Linux
   sudo pacman -S stow
   ```

3. **Install Prezto** (if not already installed):
   ```bash
   git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
   ```

4. **Use Stow to create symlinks**:
   ```bash
   cd ~/Developer/dotfiles
   stow --dotfiles --target="$HOME" zsh
   stow --dotfiles --target="$HOME/.config" config
   ```

5. **Install Homebrew packages** (macOS only):
   ```bash
   brew bundle install --file="~/Developer/dotfiles/Brewfile"
   ```

## Structure

```
dotfiles/
├── config/           # Configuration files for .config directory
│   ├── nvim/         # Neovim configuration
│   └── ...           # Other config directories
├── zsh/              # Zsh configuration files
│   ├── dot-zshrc     # Main Zsh config file
│   ├── dot-zpreztorc # Prezto config file
│   └── ...           # Other Zsh files
├── Brewfile          # Homebrew packages and applications
├── install.sh        # Installation script
└── README.md         # This file
```

## Prezto Integration

This dotfiles setup uses [Prezto](https://github.com/sorin-ionescu/prezto) for Zsh configuration. The installation script handles:

1. Installing or updating Prezto
2. Removing default Prezto symlinks
3. Creating symlinks to the custom configuration in this repository

## Homebrew & Brewfile

The Brewfile contains all packages, applications, and fonts that I use. To manually install everything from the Brewfile:

```bash
brew bundle install --file="~/Developer/dotfiles/Brewfile"
```

To update the Brewfile after installing new packages:

```bash
cd ~/Developer/dotfiles
brew bundle dump --force
```

## Customization

Feel free to fork this repository and customize it to fit your needs:

1. Modify the configuration files
2. Update the Brewfile to include your preferred packages
3. Add new directories for additional tools

## Updating

To update your dotfiles:

```bash
cd ~/Developer/dotfiles
git pull
./install.sh
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [GNU Stow](https://www.gnu.org/software/stow/)
- [Prezto](https://github.com/sorin-ionescu/prezto)
- [Homebrew](https://brew.sh/)
- The dotfiles community for inspiration and best practices