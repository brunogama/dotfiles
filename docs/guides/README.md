# Dotfiles Guides

Complete documentation for Bruno's dotfiles project.

## 📚 Getting Started

**New to this project?**

- **[Main README](../../README.md)** - Start here for installation and overview
- **[Quick Start Guide](../../QUICKSTART.md)** - 5-minute setup guide
- **[Comprehensive Onboarding](../../ONBOARDING.md)** - Complete developer guide

## 🔧 Feature Guides

### Core Functionality

- **[Homebrew Management](HOMEBREW_MANAGEMENT_GUIDE.md)** - Manage packages across machines
- **[Home Sync Service](HOME_SYNC_SERVICE_GUIDE.md)** - Automated dotfiles synchronization
- **[Work Secrets Management](WORK_SECRETS_GUIDE.md)** - Secure credential storage

### Quick Commands

```bash
# Installation
make install              # Install all dotfiles
make install-zsh          # ZSH configuration only
make install-git          # Git configuration only
make install-scripts      # Install scripts to ~/.local/bin

# Environment Management
work-mode [work|personal|status]  # Switch environments

# Sync & Backup
home-sync [sync|push|pull]        # Manual sync
sync-start                         # Start background service

# Credentials
credfile <file>           # Manage secure files
credmatch <pattern>       # Search/decrypt credentials
```

## 📖 Man Pages

All scripts have comprehensive man pages:

```bash
man credmatch             # Credential management
man credfile              # File storage
man home-sync             # Sync service
man work-mode             # Environment switching
```

## 🏗️ Architecture

**Directory Structure:**
```
~/.config/dotfiles/
├── config/          # Application configurations
├── scripts/         # Executable utilities
├── docs/            # Documentation (you are here)
├── openspec/        # Change proposals
└── Makefile         # Installation interface
```

**Installation System:**
- Uses **Makefile** for installation (standard Unix tool)
- Creates **symlinks** from `~/.config/dotfiles/config/` to appropriate locations
- Installs **scripts** to `~/.local/bin` (added to PATH)

## 🔍 Finding Help

### Interactive Help

```bash
dotfiles-help         # Browse all documentation
```

### Browse Guides

All guides in this directory:
```bash
ls ~/.config/dotfiles/docs/guides/
cat ~/.config/dotfiles/docs/guides/HOMEBREW_MANAGEMENT_GUIDE.md
```

### Search Documentation

```bash
# Search all markdown files
rg "search term" ~/.config/dotfiles --type md

# Search scripts
rg "search term" ~/.config/dotfiles/scripts
```

## 🛠️ Troubleshooting

**Scripts not found?**
```bash
# Ensure ~/.local/bin is in PATH
echo $PATH | grep "$HOME/.local/bin"

# Reinstall scripts
make install-scripts
```

**Broken symlinks?**
```bash
# Remove and recreate
make unlink
make link
```

**Configuration conflicts?**
```bash
# Backup existing configs
make backup

# Force clean install
make uninstall
make install
```

## 📝 Contributing

See the main [README.md](../../README.md) for contribution guidelines.

**Making changes:**
1. Edit files in `config/` or `scripts/`
2. Test: `make test`
3. Commit: `git commit -m "type: description"`
4. Push: `git push`

## 📚 Additional Resources

- [Main README](../../README.md) - Project overview
- [Quick Start](../../QUICKSTART.md) - Fast setup
- [Onboarding](../../ONBOARDING.md) - Complete guide
- [Makefile](../../Makefile) - Installation commands
- [OpenSpec](../../openspec/) - Change proposals

---

**For detailed installation instructions, see the [main README](../../README.md).**
