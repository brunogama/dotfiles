![There's no place like home](img/home.png)

# Bruno's Dotfiles

Modern, organized dotfiles with a clean Unix-native structure. No complex abstractions—just straightforward configuration management.

## Features

- **Simple Structure** - Configs in `config/`, scripts in `scripts/`, docs in `docs/`
- **Standard Unix Tools** - Makefile interface, direct symlinks
- **Fast Navigation** - Find anything instantly with flat, logical hierarchy
- **Selective Installation** - Install everything or just what you need
- **Automated Sync** - Background synchronization across machines
- **Secure Credentials** - Keychain integration + encrypted storage
- **Complete Documentation** - Man pages, guides, and examples

## Quick Start

### One-Line Installation

```bash
curl -fsSL https://raw.githubusercontent.com/brunogama/dotfiles/main/install | bash
```

This automatically:
- Installs prerequisites (Homebrew, Git, Xcode tools)
- Clones this repository to `~/.config/dotfiles`
- Creates symlinks for all configurations
- Installs scripts to `~/.local/bin`
- Configures your shell

### Manual Installation

```bash
# Clone repository
git clone --recurse-submodules https://github.com/brunogama/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles

# Install everything
make install

# Or install specific components
make install-zsh
make install-git
make install-scripts
```

## Directory Structure

```
~/.config/dotfiles/
├── config/              # Application configurations
│   ├── zsh/            # ZSH: .zshrc, aliases, functions
│   ├── git/            # Git: config, aliases, hooks, scripts
│   ├── homebrew/       # Homebrew: Brewfile, management
│   ├── mise/           # Mise version manager
│   ├── fish/           # Fish shell config
│   ├── ios-cli/        # iOS development CLI tools
│   └── sync-service/   # Background sync configuration
│
├── scripts/            # Executable scripts (installed to ~/.local/bin)
│   ├── core/          # Essential utilities
│   ├── git/           # Git workflow helpers
│   ├── macos/         # macOS-specific tools
│   └── credentials/   # Secure credential management
│
├── docs/              # Documentation
│   ├── guides/        # User guides and how-tos
│   ├── api/           # API documentation
│   └── man/           # Man pages
│
├── hooks/             # Claude Code hooks
│   ├── pre_tool_use.py
│   ├── post_tool_use.py
│   └── utils/
│
├── .claude/           # Claude Code configuration
│   ├── agents/        # Custom AI agents
│   ├── commands/      # Slash commands
│   └── settings.json
│
├── Makefile           # Standard installation interface
├── install            # One-line installer script
└── README.md          # This file
```

## Usage

### Makefile Commands

```bash
make help              # Show all available commands
make install           # Install all dotfiles
make install-zsh       # Install ZSH only
make install-git       # Install Git only
make install-scripts   # Install scripts only
make uninstall         # Remove all symlinks
make backup            # Backup existing configs
make test              # Dry-run installation
make clean             # Clean old backups
```

### Quick Navigation

```bash
# Edit ZSH config
vim ~/.config/dotfiles/config/zsh/.zshrc

# Browse scripts
ls ~/.config/dotfiles/scripts/

# View documentation
cat ~/.config/dotfiles/docs/guides/HOMEBREW_MANAGEMENT_GUIDE.md

# Check installed scripts
ls ~/.local/bin
```

## Configuration Packages

### ZSH (`config/zsh/`)

Modern ZSH setup with Prezto framework integration.

**Features:**
- Powerlevel10k prompt
- Machine-specific configs (work vs personal)
- Custom aliases and functions
- Intelligent command completion

**Files:**
- `.zshrc` - Main configuration
- `work-config.zsh` - Work machine settings
- `personal-config.zsh` - Personal settings
- `.zpreztorc` - Prezto configuration

### Git (`config/git/`)

Streamlined GitHub Flow workflow with conventional commits.

**Key Aliases:**
```bash
git up              # Pull, rebase, update submodules
git cob <branch>    # Create and switch to branch
git cm "message"    # Add all and commit
git save            # Create savepoint
git undo            # Undo last commit (keep changes)
```

**Features:**
- Conventional commit helpers
- GitHub Flow aliases
- Custom hooks (Swift lint, format, etc.)
- Interactive tools

### Scripts (`scripts/`)

Organized by category for easy discovery:

**Core Utilities:**
- `dotfiles-help` - Interactive documentation
- `work-mode` - Toggle work/personal configuration
- `reload-shell` - Restart shell with new config
- `update-dotfiles` - Pull latest changes

**Git Tools:**
- `git-browse.sh` - Open repo in browser
- `git-wip.sh` - Quick work-in-progress commits
- `conventional-commit` - Guided commit messages

**Credentials:**
- `credmatch` - Encrypted credential storage
- `credfile` - Secure file storage
- `store-api-key` / `get-api-key` - Keychain management

**macOS Tools:**
- `macos-prefs` - System preferences management
- `brew-sync` - Homebrew synchronization
- `dump-macos-settings` - Export macOS defaults

## Machine-Specific Setup

### Personal Machine

```bash
make install
work-mode off
```

### Work Machine

```bash
make install
work-mode on
```

### Server (Minimal)

```bash
make install-zsh install-git install-scripts
```

## Credential Management

### Keychain Storage

```bash
# Store secret in macOS Keychain
store-api-key "COMPANY_API_KEY" "your-secret-value"

# Retrieve from Keychain
get-api-key "COMPANY_API_KEY"
```

### Encrypted Git Storage

```bash
# Store in encrypted git repository
credmatch store "$(get-api-key CREDMATCH_MASTER_PASSWORD)" "KEY" "value"

# Fetch from encrypted storage
credmatch fetch "$(get-api-key CREDMATCH_MASTER_PASSWORD)" "KEY"
```

### Secure File Storage

```bash
# Store any file type
credfile put "ssh_config" ~/.ssh/config
credfile put "certificate" ~/certs/work.pem

# Retrieve files
credfile get "ssh_config" ~/.ssh/config.restored
credfile list
```

## Sync Service

Automated background synchronization across machines.

```bash
# Set up service
cd ~/.config/dotfiles
make install-sync

# Manual sync
home-sync-up       # Pull + push
home-push          # Push changes
home-pull          # Pull changes
home-status        # Check status

# Service management
sync-start         # Start background service
sync-stop          # Stop service
sync-status        # Service status
```

## Adding New Configurations

### 1. Add Config Files

```bash
# Add new app configuration
mkdir -p config/myapp
cp ~/.myapp/config.yml config/myapp/
```

### 2. Update Makefile

Add linking target:

```makefile
link-myapp:
	@ln -sfn $(CONFIG_DIR)/myapp $(HOME_DIR)/.config/myapp
```

### 3. Install

```bash
make link-myapp
```

## Documentation

### Man Pages

```bash
man credmatch      # Credential management
man credfile       # File storage
man home-sync      # Sync service
man work-mode      # Machine configuration
```

### Interactive Help

```bash
dotfiles-help      # Browse all documentation
```

### Guides

All guides are in `docs/guides/`:
- `HOMEBREW_MANAGEMENT_GUIDE.md`
- `HOME_SYNC_SERVICE_GUIDE.md`
- `WORK_SECRETS_GUIDE.md`

## Troubleshooting

### Broken Symlinks

```bash
# Remove and recreate
make unlink
make link
```

### Conflicts

```bash
# Backup first, then force
make backup
make uninstall
make install
```

### Scripts Not Found

```bash
# Ensure ~/.local/bin is in PATH
echo $PATH | grep -o "$HOME/.local/bin"

# Add to PATH if missing (already in .zshrc)
export PATH="$HOME/.local/bin:$PATH"
```

## Why This Structure?

**Previous (Stow-based):**
```
stow-packages/zsh/.config/zsh/.zshrc  # Confusing nested structure
```

**Current (Unix-native):**
```
config/zsh/.zshrc                      # Clear, direct path
```

### Advantages

✅ **Instant Understanding** - Structure is self-documenting  
✅ **Fast Navigation** - No mental mapping required  
✅ **Standard Tools** - Makefile, not custom abstractions  
✅ **Easy Debugging** - Direct paths, no indirection  
✅ **Git-Friendly** - Clear diffs, obvious locations  
✅ **Beginner-Friendly** - Unix conventions, not Stow quirks

## Migration from Stow

If you're upgrading from the old Stow-based structure:

```bash
# Backup first
make backup

# Uninstall old structure
cd old-location
./stow-install.sh --uninstall

# Install new structure
cd ~/.config/dotfiles
make install
```

All your configurations are preserved—just organized better!

## Contributing

### Making Changes

1. Edit files in `config/` or `scripts/`
2. Test: `make test`
3. Commit: `git commit -m "type: description"`
4. Push: `git push`

### Adding Scripts

1. Add to appropriate `scripts/` subdirectory
2. Make executable: `chmod +x scripts/category/myscript`
3. Reinstall: `make install-scripts`

## Resources

- [GNU Make Manual](https://www.gnu.org/software/make/manual/)
- [Dotfiles Best Practices](https://dotfiles.github.io/)
- [GitHub Flow](https://guides.github.com/introduction/flow/)

## License

MIT License - see [LICENSE.md](LICENSE.md)

---

**Simple. Organized. Unix-native.**

For questions or issues, check the troubleshooting section or open an issue.
