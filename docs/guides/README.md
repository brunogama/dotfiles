![There's no place like home](img/home.png)

# Bruno's Dotfiles

Modern, organized dotfiles using GNU Stow for clean symlink management.

## Features

- **Selective Installation** - Install only what you need per machine
- **Organized Packages** - Configs grouped by purpose
- **Clean Symlinks** - Easy to see what's managed
- **Automated Sync Service** - Background synchronization across machines
- **Secure Credential Management** - Keychain + encrypted git storage
- **Secure File Storage** - Store any file type with base64 encoding
- **Machine-Specific Configs** - Work vs personal environment separation
- **Complete Documentation** - Man pages and interactive help system
- **Multi-Machine Sync** - Seamless environment replication

## Available Packages

| Package        | Description             | Contents                                                  |
| -------------- | ----------------------- | --------------------------------------------------------- |
| `zsh`          | ZSH shell configuration | `.zshrc`, aliases, functions, work/personal configs       |
| `git`          | Git configuration       | `.gitconfig`, aliases, hooks, scripts                     |
| `bin`          | Custom scripts & tools  | `credmatch`, `credfile`, credential management, man pages |
| `sync-service` | Home sync service       | Background sync, LaunchAgent, automation                  |
| `shell-tools`  | Shell utilities         | mise, fish configurations                                 |
| `development`  | Dev tools               | cursor, github-copilot, ios-cli                           |
| `macos`        | macOS apps              | raycast, Rectangle configs                                |

## Quick Start

### One-Line Installation (Recommended)

```bash
# Complete setup with one command (includes all dependencies)
curl -fsSL https://raw.githubusercontent.com/brunogama/dotfiles/main/install.sh | bash
```

This will automatically:
- Install Xcode Command Line Tools (if needed)
- Install Homebrew (if needed)  
- Install GNU Stow
- Clone this repository with submodules (includes Prezto)
- Install all dotfiles packages
- Configure your shell
- Set up credential management

### Manual Installation

If you prefer manual control:

```bash
# Install prerequisites
brew install stow

# Clone this repository with submodules (includes Prezto)
git clone --recurse-submodules https://github.com/brunogama/dotfiles.git ~/.config
cd ~/.config

# Or if you already cloned without submodules:
git submodule update --init --recursive

# Install all packages
./stow-install.sh

# Or install specific packages
./stow-install.sh zsh git bin
```

### First Time Setup

```bash
# After installation, restart your terminal or:
source ~/.zshrc

# Set up the home sync service (recommended)
./install.sh sync-service
home-sync setup

# Set up work secrets (optional)
store-api-key "COMPANY_API_KEY" "your-api-key"
backup-work-secrets  # Backup to encrypted storage

# Enable work mode (if on work machine)
work-mode on
```

## Management Commands

### Stow Package Management (`./stow-install.sh`)

```bash
# Install all packages
./stow-install.sh

# Install specific packages
./stow-install.sh zsh git bin sync-service

# List available packages
./stow-install.sh --list

# Dry run (see what would be installed)
./stow-install.sh --dry-run

# Backup existing configs before installing
./stow-install.sh --backup

# Force installation (resolve conflicts)
./stow-install.sh --force
```

### Home Sync Service (`home-sync`)

```bash
# Set up sync service
home-sync setup

# Manual sync operations
home-sync-up        # Full sync (pull + push)
home-push           # Push local changes
home-pull           # Pull remote changes
home-status         # Show sync status

# Service management
sync-start          # Start background service
sync-stop           # Stop background service
sync-status         # Check service status
```

### Documentation System

```bash
# Interactive help system
dotfiles-help

# Access man pages
man credmatch       # Credential management
man credfile        # File storage
man home-sync       # Sync service
man work-mode       # Machine configuration
```

## Package Details

### ZSH Package

**Location:** `stow-packages/zsh/.config/zsh/`

**Features:**

- Prezto framework integration
- Machine-specific configuration loading (work vs personal)
- Custom aliases and functions
- Work secrets management integration
- Home sync service shortcuts

**Key Files:**

- `.zshrc` - Main configuration with conditional loading
- `work-config.zsh` - Work-specific settings and aliases
- `personal-config.zsh` - Personal machine configuration
- `.zsh_functions/work-secrets` - Secret management functions

### Git Package

**Location:** `stow-packages/git/.config/git/`

**Features:**

- Streamlined GitHub Flow aliases
- Conventional commit helpers
- Custom hooks and scripts

**Key Aliases:**

- `git up` - Pull, rebase, update submodules
- `git cob <branch>` - Create and switch to branch
- `git cm "<message>"` - Add all and commit
- `git save` - Create savepoint
- `git undo` - Undo last commit (keep changes)

### Bin Package

**Location:** `stow-packages/bin/.local/bin/`

**Features:**

- Secure credential management (macOS Keychain + encrypted git)
- File storage with base64 encoding
- Interactive documentation system
- Machine configuration management

**Key Scripts:**

- `credmatch` - Encrypted git-based credential storage
- `credfile` - Secure file storage with base64 encoding
- `store-api-key` / `get-api-key` - Keychain integration
- `work-mode` - Toggle work/personal machine configuration
- `dotfiles-help` - Interactive documentation system

### Sync Service Package

**Location:** `stow-packages/sync-service/`

**Features:**

- Automated background synchronization
- macOS LaunchAgent integration
- Comprehensive logging and status monitoring
- Multi-machine environment replication

**Key Components:**

- `home-sync` - Main sync orchestration script
- `home-sync-service` - LaunchAgent management
- Background service with configurable intervals
- Sync status monitoring and conflict resolution

## Credential & File Management

### Credential Management

```bash
# Store secrets in Keychain
store-api-key "COMPANY_API_KEY" "your-secret-key"
get-api-key "COMPANY_API_KEY"

# Encrypted git-based storage
credmatch store "$(get-api-key CREDMATCH_MASTER_PASSWORD)" "KEY" "value"
credmatch fetch "$(get-api-key CREDMATCH_MASTER_PASSWORD)" "KEY"

# Work secrets functions (auto-loads master password)
backup-work-secrets     # Backup Keychain to CredMatch
sync-work-secrets       # Sync CredMatch to Keychain
```

### Secure File Storage

```bash
# Store any file type securely
credfile put "ssh_config" ~/.ssh/config
credfile put "work_cert" ~/certificates/work.pem

# Retrieve files
credfile get "ssh_config" ~/.ssh/config.backup
credfile get "work_cert"  # Output to stdout

# Manage stored files
credfile list            # List all stored files
credfile info "ssh_config"  # File details
credfile rm "old_file"   # Remove file
```

### Multi-Machine Sync

```bash
# On machine A - store and sync
credfile put "shared_config" ~/important.conf
home-push

# On machine B - pull and retrieve
home-pull
credfile get "shared_config" ~/important.conf
```

## Machine-Specific Installation

### Personal Machine

```bash
./install.sh zsh git bin sync-service shell-tools macos
work-mode off  # Ensure personal configuration
```

### Work Machine

```bash
./install.sh zsh git bin sync-service development
work-mode on   # Enable work-specific configuration
```

### Server (Minimal)

```bash
./install.sh zsh git bin shell-tools
# Skip sync-service for servers without GUI
```

### Machine Configuration

```bash
# Check current mode
work-mode status

# Toggle work mode
work-mode on     # Enable work configuration
work-mode off    # Use personal configuration

# Reload shell after mode change
reload-shell
```

## Adding New Configurations

### 1. Create Package Structure

```bash
mkdir -p stow-packages/new-app/.config/new-app
```

### 2. Add Configuration Files

```bash
cp ~/.config/new-app/config.yml stow-packages/new-app/.config/new-app/
```

### 3. Install Package

```bash
stow -d stow-packages -t ~ new-app
```

### 4. Update Install Script

Add the new package to the `AVAILABLE_PACKAGES` array in `install.sh`.

## Troubleshooting

### Conflicts During Installation

```bash
# Check for conflicts
./sync.sh --check

# Force installation (overwrites conflicts)
./install.sh --force

# Or backup first
./install.sh --backup --force
```

### Broken Symlinks

```bash
# Re-stow all packages
./sync.sh --restow

# Or re-stow specific package
stow -R -d stow-packages -t ~ zsh
```

### Secrets Not Loading

```bash
# Check if secrets exist
ws-list

# Check PATH includes ~/.local/bin
echo $PATH | grep -o "$HOME/.local/bin"

# Reload configuration
source ~/.zshrc
```

## Directory Structure

```
~/.config/
├── stow-packages/           # Stow packages
│   ├── zsh/                # ZSH configuration package
│   │   └── .config/zsh/    # → ~/.config/zsh/
│   ├── git/                # Git configuration package
│   │   └── .config/git/    # → ~/.config/git/
│   ├── bin/                # Scripts & tools package
│   │   ├── .local/bin/     # → ~/.local/bin/ (scripts)
│   │   └── .local/share/man/ # → ~/.local/share/man/ (man pages)
│   ├── sync-service/       # Home sync service
│   │   ├── .local/bin/     # → ~/.local/bin/ (sync scripts)
│   │   └── .config/sync-service/ # → ~/.config/sync-service/
│   └── ...
├── install.sh              # Installation script
├── README.md               # This file
├── .cursor/                # Cursor IDE configuration
│   ├── rules/              # Development rules and patterns
│   └── mcp-wrappers/       # MCP tool configurations
└── credentials.enc         # Encrypted credential storage (credmatch)
```

## Migration from Old Setup

Your old configurations have been migrated to Stow packages. The original directories are still present for reference but are no longer used.

**To complete the migration:**

1. Test that everything works with the new Stow setup
2. Remove old directories when you're confident: `rm -rf zsh git bin` (etc.)
3. Update any external references to the old paths

## Contributing

### Making Changes

1. Edit files in `stow-packages/*/`
2. Test changes: `./sync.sh --check`
3. Commit changes: `./sync.sh --push`

### Adding New Packages

1. Create package structure in `stow-packages/`
2. Add to `AVAILABLE_PACKAGES` in `install.sh`
3. Update this README
4. Test installation

## Advanced Features

### Background Sync Service

The home sync service runs in the background and automatically synchronizes your environment:

- **Automated sync** every 30 minutes (configurable)
- **Conflict detection** and resolution
- **Comprehensive logging** for troubleshooting
- **Status monitoring** with `sync-status`

### Secure File Storage System

Store any file type securely across machines:

- **Base64 encoding** for binary file support
- **Filename preservation** with metadata
- **AES-256-CBC encryption** via CredMatch
- **Git-based versioning** and distribution
- **Legacy format** compatibility

### Machine-Specific Configuration

Intelligent environment detection:

- **Automatic work mode** detection via hostname/username patterns
- **Manual override** with `.work-machine` file
- **Conditional loading** of work vs personal configs
- **Environment isolation** for security

### Interactive Documentation

Complete help system with man pages:

- **Interactive help** via `dotfiles-help`
- **Comprehensive man pages** for all tools
- **Command examples** and use cases
- **Quick reference** commands

## Resources

- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/stow.html)
- [Dotfiles Best Practices](https://dotfiles.github.io/)
- [GitHub Flow](https://guides.github.com/introduction/flow/)
- [Home Sync Service Guide](HOME_SYNC_SERVICE_GUIDE.md)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

---

**Enjoy your organized, modern dotfiles!**

For questions or issues, check the troubleshooting section above or create an issue.
