# Script Quick Reference

One-page guide to all available scripts.

## Credential Management

**See full guide:** [docs/guides/CREDENTIAL_MANAGEMENT.md](../guides/CREDENTIAL_MANAGEMENT.md)

### Decision Guide

| Use Case | Tool | Example |
|----------|------|---------|
| Simple API key (1 machine) | `store-api-key` | `store-api-key GITHUB_TOKEN` |
| Multiple keys (need search) | `credmatch` | `credmatch store ... aws.prod.key ...` |
| Full file (SSH key, cert) | `credfile` | `credfile put ssh_key ~/.ssh/id_rsa` |

### Quick Workflows

**Store and retrieve simple key:**
```bash
store-api-key OPENAI_API_KEY
export OPENAI_API_KEY="$(get-api-key OPENAI_API_KEY)"
```

**Store and search multiple keys:**
```bash
MASTER="$(get-api-key CREDMATCH_MASTER_PASSWORD)"
credmatch store "$MASTER" "github.token" "ghp_xxx"
credmatch search "$MASTER" "github"
```

**Store and retrieve file:**
```bash
credfile put ssh_key ~/.ssh/id_rsa
credfile get ssh_key /tmp/key
```

## Core Utilities

| Script | Purpose | Example |
|--------|---------|---------|
| `work-mode` | Switch environment (work/personal) | `work-mode work` |
| `syncenv` | Sync dotfiles with smart git strategy | `syncenv` |
| `home-sync` | Full environment synchronization | `home-sync` |
| `link-dotfiles` | Apply symlinks from manifest | `link-dotfiles --apply` |
| `zsh-benchmark` | Measure shell startup time | `zsh-benchmark` |
| `zsh-compile` | Compile configs to bytecode | `zsh-compile` |
| `zsh-trim-history` | Reduce history size | `zsh-trim-history` |
| `update-dotfiles` | Pull latest dotfiles | `update-dotfiles` |
| `update-dotfiles-scripts` | Background script updates | `update-dotfiles-scripts` |
| `reload-shell` | Restart shell session | `reload-shell` |
| `check-dependency` | Check if command exists | `check-dependency jq` |
| `setup-git-hooks` | Install pre-commit hooks | `setup-git-hooks` |

## Credential Management

| Script | Purpose | Example |
|--------|---------|---------|
| `store-api-key` | Store key securely (interactive) | `store-api-key OPENAI_API_KEY` |
| `get-api-key` | Retrieve stored key | `get-api-key OPENAI_API_KEY` |
| `credfile` | Encrypt/decrypt files | `credfile put secret file.txt` |
| `credmatch` | Search/store credentials | `credmatch list` |
| `clear-secret-history` | Remove exposed secrets from history | `clear-secret-history` |
| `dump-api-keys` | Export all credentials | `dump-api-keys` |

## Git Utilities

| Script | Purpose | Example |
|--------|---------|---------|
| `conventional-commit` | Guided conventional commits | `conventional-commit` |
| `git-wip` | Quick WIP commit | `git-wip` |
| `git-save-all` | Create savepoint | `git-save-all "checkpoint"` |
| `git-restore-last-savepoint` | Restore last savepoint | `git-restore-last-savepoint` |
| `git-restore-wip` | Restore last WIP | `git-restore-wip` |
| `git-restore-wip-all` | Restore all WIP commits | `git-restore-wip-all` |
| `git-browse` | Open repo in browser | `git-browse` |
| `interactive-cherry-pick` | Interactive cherry-pick | `interactive-cherry-pick` |
| `git-add-only-changed-today` | Stage today's changes | `git-add-only-changed-today` |

## macOS Tools

| Script | Purpose | Example |
|--------|---------|---------|
| `brew-sync` | Sync Homebrew packages | `brew-sync update` |
| `dump-macos-settings` | Export macOS preferences | `dump-macos-settings` |
| `macos-prefs` | Apply macOS preferences | `macos-prefs` |

## Performance Tools

| Script | Purpose | Example |
|--------|---------|---------|
| `zsh-benchmark` | Measure startup time | `zsh-benchmark --detailed` |
| `zsh-compile` | Compile to bytecode | `zsh-compile` |
| `zsh-trim-history` | Reduce history size | `zsh-trim-history` |
| `update-dotfiles-scripts` | Background updates | `update-dotfiles-scripts` |

---

## By Task

### "I want to..."

**...sync dotfiles across machines**
```bash
syncenv              # Smart git-based sync (recommended)
# OR
home-sync            # Full sync with service
```

**...store a secret securely**
```bash
store-api-key KEY_NAME          # Interactive prompt (no history exposure)
# OR
echo "secret" | store-api-key KEY_NAME --stdin
```

**...retrieve a secret**
```bash
get-api-key KEY_NAME            # Retrieve from keychain
# OR
credmatch list                  # List all credentials
```

**...speed up shell startup**
```bash
zsh-benchmark                   # Identify bottlenecks
zsh-compile                     # Compile to bytecode
zsh-trim-history                # Reduce history
```

**...make a proper git commit**
```bash
conventional-commit             # Interactive guided commit
# Follows: type(scope): description
```

**...switch between work and personal**
```bash
work-mode work                  # Enable work configuration
work-mode personal              # Enable personal configuration
reload-shell                    # Apply changes
```

**...manage Homebrew packages**
```bash
brew-sync update                # Update from Brewfile
brew-sync generate              # Generate from installed
```

**...find a credential**
```bash
credmatch list                  # See all stored
get-api-key NAME                # Retrieve specific
```

**...set up new machine**
```bash
./install                       # One-command setup
# OR step-by-step:
./install --phase 1             # Homebrew
./install --phase 2             # Dependencies
./install --phase 3             # Symlinks
```

---

## By Frequency

### Daily Use
- `work-mode` - Switch environments
- `syncenv` - Sync dotfiles
- `conventional-commit` - Git commits
- `get-api-key` - Retrieve credentials
- `reload-shell` - Apply config changes

### Weekly Use
- `brew-sync update` - Update packages
- `zsh-benchmark` - Check performance
- `update-dotfiles` - Pull latest changes
- `clear-secret-history` - Security hygiene

### One-time Setup
- `./install` - Initial installation
- `link-dotfiles --apply` - Create symlinks
- `store-api-key` - Store credentials
- `setup-git-hooks` - Configure pre-commit
- `zsh-compile` - Compile configs

---

## Common Workflows

### New Machine Setup
```bash
# 1. Clone and install
git clone <repo> ~/.config
cd ~/.config
./install

# 2. Configure environment
work-mode personal          # or 'work'
reload-shell

# 3. Store credentials
store-api-key GITHUB_TOKEN
store-api-key OPENAI_API_KEY

# 4. Verify
zsh-benchmark               # Check performance
dotfiles-help               # Explore scripts
```

### Daily Development
```bash
# Morning
work-mode work
syncenv                     # Pull latest
get-api-key AWS_KEY         # Retrieve needed creds

# Development
conventional-commit         # Proper commits
git-wip                     # Quick saves

# Evening
syncenv                     # Push changes
work-mode personal
```

### Performance Optimization
```bash
# Measure
zsh-benchmark --detailed    # Identify bottlenecks

# Optimize
zsh-compile                 # Compile configs
zsh-trim-history            # Reduce history

# Verify
zsh-benchmark               # Should be <500ms
```

### Credential Management
```bash
# Store securely
store-api-key OPENAI_API_KEY        # Interactive

# Alternative methods
echo "secret" | store-api-key KEY --stdin
store-api-key KEY --from-file ~/.secrets/key

# Retrieve
get-api-key OPENAI_API_KEY

# Audit
credmatch list
clear-secret-history        # Clean exposed secrets
```

---

## Quick Tips

**Performance:**
- Target: <500ms cold start, <200ms warm
- Run `zsh-benchmark` monthly
- Compile configs after changes: `zsh-compile`

**Security:**
- Never use positional args with secrets: `store-api-key KEY value` (BAD)
- Always use interactive: `store-api-key KEY` (GOOD)
- Run `clear-secret-history` if you exposed secrets
- Rotate credentials regularly

**Git:**
- Use `conventional-commit` for proper format
- Use `git-wip` for quick saves
- Use `git-save-all` before risky changes

**Documentation:**
- Full docs: `docs/scripts/`
- Interactive help: `dotfiles-help`
- Specific script: `script-name --help`
- Onboarding: `ONBOARDING.md`

---

## Getting Help

```bash
dotfiles-help               # Interactive menu
dotfiles-help script-name   # Specific script help
dotfiles-help --search sync # Search by keyword

# OR read docs
cat docs/scripts/core.md
cat docs/scripts/credentials.md
cat ONBOARDING.md
```

---

## Platform Notes

**macOS (darwin):**
- All scripts fully supported
- Homebrew integration
- Keychain for secrets

**Linux:**
- Core scripts supported
- Homebrew optional (use native package manager)
- gnome-keyring/kwallet for secrets

**Script Categories:**
- `bin/core/` - Cross-platform
- `bin/macos/` - macOS only (marked in docs)
- `bin/git/` - Cross-platform
- `bin/credentials/` - Cross-platform
