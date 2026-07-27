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

# 2. Review your host identity
$EDITOR nix/host.nix

# 3. Preview and activate the user environment without sudo
./install --nix --dry-run
./install --nix

# 4. Restart your terminal
exec zsh
```

The default Nix installer will:

- Activate the pinned CLI packages through standalone Home Manager
- Configure Git, zsh, Prezto, and Starship
- Install pinned npm tools under your XDG data directory
- Add repository utilities to `~/local/bin`

Nix itself must already be installed. To apply macOS system defaults and the retained Homebrew exceptions, explicitly run `./install --nix --system`; that mode requires administrator access. Linux and legacy installations can continue to use `./install`.

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

For the Nix workflow, edit `nix/host.nix`:

```nix
git = {
  name = "Your Name";
  email = "your.email@example.com";
};
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
echo 'export PATH="$HOME/local/bin:$PATH"' >> ~/.zshrc
exec zsh
```

**Problem:** Symlinks not working
**Solution:** Re-run the linker:

```bash
~/.dotfiles/bin/core/link-dotfiles --apply
```

## What Just Happened?

The default Nix installation:

1. **Built a standalone Home Manager generation** from `flake.lock`
2. **Installed CLI packages** declared in `nix/packages.nix`
3. **Configured Git and zsh** from the shared Home Manager module
4. **Installed pinned npm tools** outside the immutable Nix store
5. **Added repository utilities** to `~/local/bin`

It did not activate nix-darwin, modify system defaults, install Homebrew items, or invoke sudo.

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
├── flake.nix            # Home Manager and nix-darwin outputs
├── flake.lock           # Pinned Nix inputs
├── install              # Nix dispatcher and legacy installer
├── LinkingManifest.json # Legacy symlink definitions
├── bin/                 # Executable scripts
│   ├── core/           # Core utilities
│   ├── credentials/    # Credential management
│   ├── git/           # Git hooks and tools
│   └── macos/         # macOS-specific tools
├── git/                # Git configuration
├── nix/                # Host, package, user, and system modules
├── packages/           # External package manager configs
│   ├── homebrew/      # Optional system-mode exceptions
│   └── npm/           # Pinned external npm tools
└── zsh/               # Zsh and Starship configuration
```

## Next Steps

1. **Customize your setup:**
   - Edit `nix/host.nix` with your identity
   - Choose an environment mode with `work-mode`
   - Add user packages to `nix/packages.nix`
   - Keep Homebrew exceptions limited to explicit system activation

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
