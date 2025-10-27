# Quick Start Guide

Get up and running with these dotfiles in under 5 minutes.

## Prerequisites

- macOS 10.15+ or Linux (Ubuntu 20.04+)
- Git installed
- Terminal access

## Installation

```bash
# 1. Clone the repository
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles

# 2. Run the installer
./install

# 3. Restart your terminal
exec zsh
```

That's it! The installer will:
- Install Homebrew (macOS only)
- Install required dependencies (jq, etc.)
- Install packages from Brewfile
- Create all necessary symlinks
- Configure your shell

## Essential Commands

```bash
# Switch to work environment
work-mode work

# Switch to personal environment
work-mode personal

# Check current environment
work-mode status

# Update dotfiles
update-dotfiles

# Sync across machines
home-sync
```

## Configuration

### Set Your Git Identity

Edit `~/.dotfiles/git/.gitconfig`:

```ini
[user]
    name = Your Name
    email = your.email@example.com
```

### Choose Your Environment

```bash
# For work setup
work-mode work

# For personal setup
work-mode personal
```

## Common Issues

**Problem:** `jq: command not found`
**Solution:**
```bash
# macOS
brew install jq

# Linux
sudo apt install jq  # Ubuntu/Debian
sudo yum install jq  # CentOS/RHEL
```

**Problem:** `link-dotfiles not found`
**Solution:** Add to your PATH:
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
exec zsh
```

**Problem:** Symlinks not working
**Solution:** Re-run the linker:
```bash
~/.dotfiles/bin/core/link-dotfiles --apply
```

## What Just Happened?

The installation:

1. **Created symlinks** from `~/.dotfiles/` to your home directory
2. **Installed packages** defined in `packages/homebrew/Brewfile` (macOS)
3. **Configured git** with aliases and hooks
4. **Set up your shell** with zsh configuration
5. **Added utilities** to `~/.local/bin/` (available in PATH)

## Installed Scripts

You now have 50+ utility scripts available:

**Core utilities:**
- `link-dotfiles` - Manage symlinks
- `work-mode` - Switch environments
- `home-sync` - Sync dotfiles
- `update-dotfiles` - Pull updates

**Credential management:**
- `credfile` - Encrypt/store files
- `credmatch` - Search credentials
- `store-api-key` / `get-api-key` - API key management

**Git utilities:**
- `conventional-commit` - Guided commit messages
- `git-wip` - Quick WIP commits
- `git-save-all` - Create savepoints

Run `dotfiles-help` for complete list.

## Directory Structure

```
~/.dotfiles/
├── install              # Main installer (you just ran this)
├── LinkingManifest.json # Symlink definitions
├── bin/                 # Executable scripts
│   ├── core/           # Core utilities
│   ├── credentials/    # Credential management
│   ├── git/           # Git hooks and tools
│   └── macos/         # macOS-specific tools
├── git/                # Git configuration
├── packages/           # Package manager configs
│   └── homebrew/      # Brewfile for macOS
└── zsh/               # Zsh configuration
```

## Next Steps

1. **Customize your setup:**
   - Edit `git/.gitconfig` with your details
   - Choose environment mode (`work-mode`)
   - Add packages to `packages/homebrew/Brewfile`

2. **Learn more:**
   - Read `ONBOARDING.md` for comprehensive guide
   - Check `AGENTS.md` for project overview
   - Explore `bin/` directories for available scripts

3. **Start using:**
   - Store credentials with `credfile`
   - Use `conventional-commit` for better git messages
   - Try `home-sync` if you have multiple machines

## Need Help?

- **Full documentation:** Read `ONBOARDING.md`
- **Script usage:** Run `<script-name> --help`
- **Issues:** Check GitHub issues or create new one

---

**You're all set! Happy hacking!**
