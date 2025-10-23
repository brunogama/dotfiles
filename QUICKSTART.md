# Quick Start Guide
## Bruno's Dotfiles - Get Running in 5 Minutes

**For:** Developers who want to get up and running fast  
**Time:** ~5 minutes  
**Prerequisites:** macOS 10.15+

---

## One-Line Installation (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/brunogama/dotfiles/main/install | bash
```

**This automatically:**
✓ Installs Xcode Command Line Tools  
✓ Installs Homebrew  
✓ Clones dotfiles to `~/.config/dotfiles`  
✓ Installs Prezto framework  
✓ Creates symlinks for configs and scripts  
✓ Configures your shell

**After installation:** Restart terminal or run `exec zsh`

---

## Manual Installation (5 Steps)

### Step 1: Install Prerequisites

```bash
# Install Xcode Command Line Tools
xcode-select --install

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Git (if not already installed)
brew install git
```

### Step 2: Clone Repository

```bash
git clone https://github.com/brunogama/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles
```

### Step 3: Install Prezto

```bash
make setup-prezto
```

### Step 4: Install Dotfiles

```bash
make install
```

### Step 5: Reload Shell

```bash
exec zsh
```

✓ **Done!** You should now see the Powerlevel10k prompt.

---

## Quick Configuration

### Set Your Environment

**For Personal Machine:**
```bash
work-mode personal  # Default, HOME:PERSONAL in prompt
```

**For Work Machine:**
```bash
work-mode work      # Shows WORK in prompt
exec zsh            # Reload to see changes
```

### Add Your Git Identity

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Add Work Secrets (Optional)

```bash
ws-store "API_KEY" "your-secret-key"
ws-store "DATABASE_URL" "postgresql://..."
ws-list  # Verify secrets are stored
```

---

## Verify Installation

```bash
# Check environment
work-mode status

# Check scripts are accessible
which work-mode     # Should output: ~/.local/bin/work-mode
work-mode --help    # Should show help text

# Check prompt (visual)
# You should see:
# - WORK (orange) or HOME:PERSONAL (blue) on right side
# - Current directory and git status on left
```

---

## Common Commands

```bash
# Environment
work-mode [work|personal|status]   # Switch environments

# Sync (multi-machine setup)
home-sync sync                     # Full sync
home-sync push                     # Push changes
home-sync pull                     # Pull changes

# Credentials
ws                                 # Load all work secrets
ws-store KEY "value"               # Store secret
ws-list                            # List secrets

# Help
dotfiles-help                      # Interactive help
man work-mode                      # Manual page
work-mode --help                   # Command help
```

---

## Troubleshooting

### "command not found: work-mode"

```bash
# Add to PATH
export PATH="$HOME/.local/bin:$PATH"

# Or reinstall scripts
cd ~/.config/dotfiles && make install-scripts
```

### "Prezto not found"

```bash
cd ~/.config/dotfiles && make setup-prezto
```

### Prompt Not Showing Environment

```bash
work-mode work        # Or: work-mode personal
exec zsh              # Reload shell
```

### Symlink Conflicts

```bash
cd ~/.config/dotfiles
make backup           # Backup existing configs
make unlink           # Remove old symlinks
make install          # Reinstall
```

---

## Next Steps

**Essential:**
1. ✓ Installation complete
2. ✓ Environment set
3. ✓ Git configured

**Optional:**
1. **Multi-Machine Sync:**
   ```bash
   home-sync setup
   sync-start
   ```

2. **Install Development Tools:**
   ```bash
   brew bundle install --file=Brewfile
   ```

3. **Customize Configuration:**
   - Edit `~/.config/zsh/work-config.zsh` or `personal-config.zsh`
   - Add aliases, functions, environment variables
   - Reload: `source ~/.zshrc`

4. **Read Full Documentation:**
   - `ONBOARDING.md` - Comprehensive guide
   - `README.md` - User manual
   - `AGENTS.md` - AI assistant guidelines
   - `docs/guides/` - Detailed guides

---

## Quick Commands Cheat Sheet

| Task | Command |
|------|---------|
| **Switch to work** | `work-mode work` |
| **Switch to personal** | `work-mode personal` |
| **Check status** | `work-mode status` |
| **Store secret** | `ws-store KEY "value"` |
| **Load secrets** | `ws` or `load-work-secrets` |
| **Sync dotfiles** | `home-sync sync` |
| **Update dotfiles** | `cd ~/.config/dotfiles && git pull && make install` |
| **Reload shell** | `exec zsh` or `source ~/.zshrc` |
| **Get help** | `dotfiles-help` or `[command] --help` |

---

## Getting Help

**Built-in Help:**
```bash
dotfiles-help           # Interactive help system
man [command]           # Manual pages
[command] --help        # Command-specific help
```

**Documentation:**
- `ONBOARDING.md` - Full onboarding guide
- `README.md` - User documentation
- `docs/guides/` - Detailed guides
- GitHub: https://github.com/brunogama/dotfiles

**Issues:**
- Create issue: https://github.com/brunogama/dotfiles/issues

---

**You're all set! Enjoy your new dotfiles setup! 🎉**

**Time to complete:** ~5 minutes  
**Last updated:** 2025-10-23
