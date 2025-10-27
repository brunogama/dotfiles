# Modern Dotfiles

> A declarative, high-performance dotfiles system with environment management, secure credential storage, and automated synchronization

**Blazing fast shell startup (< 500ms) with lazy loading, secure credential management, and work/personal environment switching.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Shell: Bash](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![Platform: macOS](https://img.shields.io/badge/Platform-macOS-blue.svg)](https://www.apple.com/macos/)
[![Platform: Linux](https://img.shields.io/badge/Platform-Linux-orange.svg)](https://www.linux.org/)

## Features

- **One-Command Installation** - `./install` sets up everything
- **Blazing Fast Startup** - Optimized zsh with lazy loading (< 500ms cold start)
- **Automated Sync** - Keep dotfiles synchronized across machines
- **Secure Credentials** - macOS Keychain integration for secrets
- **Environment Switching** - Seamlessly toggle between work and personal configs
- **Spec-Driven Development** - OpenSpec framework for structured changes
- **50+ Utility Scripts** - Productivity-focused command-line tools
- **Declarative Symlinks** - JSON manifest for link management
- **Modern CLI Tools** - eza, bat, fd, rg, delta, and more

## Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Install everything (interactive, takes ~5 minutes)
./install

# Restart your shell
exec zsh
```

That's it! Your development environment is ready. See [QUICKSTART.md](QUICKSTART.md) for more details.

## What's Included

### Utilities (50+ Scripts)

This repository includes 50+ productivity scripts. See **[docs/scripts/](docs/scripts/)** for complete documentation.

```bash
dotfiles-help              # Interactive menu
dotfiles-help zsh-benchmark    # Help for specific script
dotfiles-help --search sync    # Search by keyword
```

**Most Used:**
- `work-mode` - Switch work/personal environments
- `syncenv` / `home-sync` - Sync dotfiles across machines
- `store-api-key` / `get-api-key` - Secure credentials (interactive, no history exposure)
- `zsh-benchmark` - Measure performance
- `conventional-commit` - Guided git commits
- `link-dotfiles` - Apply symlinks from manifest

**Categories:**
- [Core Utilities](docs/scripts/core.md) - 27 general-purpose tools
- [Credential Management](docs/guides/CREDENTIAL_MANAGEMENT.md) - Complete security guide
- [Git Utilities](docs/scripts/git.md) - 23 git enhancements
- [macOS Tools](docs/scripts/macos.md) - 3 macOS-specific utilities
- [Quick Reference](docs/scripts/quick-reference.md) - One-page cheat sheet

**Credential Management:**
- Full guide: [CREDENTIAL_MANAGEMENT.md](docs/guides/CREDENTIAL_MANAGEMENT.md)
- Tools: `store-api-key`, `credmatch`, `credfile`
- 30+ examples, workflows, troubleshooting

### Configurations

- **Git** - Aliases, hooks, ignore patterns, conventional commits
- **Zsh** - Prezto framework, Powerlevel10k theme, optimized startup
- **Homebrew** - Package declarations via Brewfile
- **macOS** - System preferences and settings
- **Mise** - Development tool version management

### Performance Features

- **Lazy Loading** - mise, rbenv, nvm, SDKMAN load on first use
- **Compiled Configs** - Pre-compiled .zwc bytecode for speed
- **Smart Caching** - 24-hour completion cache
- **Optimized History** - 10k entries (vs. 100k default)
- **Background Operations** - Non-blocking updates

**Expected Performance:**
- Cold start: **< 500ms** (was 1.5-2.5s)
- Warm start: **< 200ms** (was 0.8-1.5s)
- **70-80% faster** than typical zsh setups

## Installation

### Prerequisites

**Required:**
- macOS 10.15+ or Linux (Ubuntu 20.04+, CentOS 8+)
- Git 2.30+
- Bash 4.0+

**macOS:**
- Xcode Command Line Tools: `xcode-select --install`

**Linux:**
- Package manager (apt, yum, dnf, or pacman)

### Install

```bash
# Clone repository
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Interactive installation (recommended)
./install

# Non-interactive (CI/automation)
./install --yes

# Preview only (dry-run)
./install --dry-run

# Skip specific phases
./install --skip-packages  # Skip Homebrew bundle
./install --skip-links     # Skip symlink creation
```

### First-Time Setup

```bash
# 1. Configure git identity
vim ~/.dotfiles/git/.gitconfig
# Update: user.name and user.email

# 2. Choose environment
work-mode personal  # or: work-mode work

# 3. Setup credentials (secure, no shell history exposure!)
store-api-key CREDMATCH_MASTER_PASSWORD
store-api-key OPENAI_API_KEY

# 4. Restart shell
exec zsh

# 5. Benchmark performance (optional)
zsh-benchmark
```

See [ONBOARDING.md](ONBOARDING.md) for comprehensive setup guide.

## Usage

### Environment Management

Switch between work and personal configurations seamlessly:

```bash
# Switch to work environment
work-mode work
# Changes prompt to "WORK", loads work-config.zsh

# Switch to personal
work-mode personal
# Changes prompt to "HOME:PERSONAL", loads personal-config.zsh

# Check current environment
work-mode status
```

### Credential Management

Store and retrieve secrets securely without exposing them in shell history:

```bash
# SECURE: Interactive mode (no history exposure)
store-api-key OPENAI_API_KEY
# Prompts: Enter value: [hidden input]

# Retrieve securely
get-api-key OPENAI_API_KEY

# Store files
credfile put my-secret ~/path/to/secret.txt

# Retrieve files
credfile get my-secret ~/restored.txt

# List all credentials
credmatch list

# Clean up exposed secrets from history
clear-secret-history --dry-run
clear-secret-history
```

### Git Workflow

Enhanced git workflow with conventional commits:

```bash
# Interactive conventional commit
conventional-commit
# Guides you through: type, scope, description

# Quick WIP commit
git-wip

# Create savepoint
git-save-all

# Restore last savepoint
git-restore-last-savepoint
```

### Synchronization

Keep dotfiles in sync across machines:

```bash
# Modern sync (recommended)
syncenv          # Smart sync with git detection
syncenv --status # Check sync status

# Legacy sync
home-sync        # Auto-commits and pushes/pulls

# Background service (macOS)
home-sync-service start
```

### Performance Optimization

Measure and optimize shell startup:

```bash
# Benchmark startup time
zsh-benchmark              # Quick 10-run average
zsh-benchmark --detailed   # Function-by-function profiling

# After config changes
zsh-compile               # Recompile to bytecode
exec zsh                  # Restart shell

# Optimize history
zsh-trim-history          # Reduce to 10k entries
```

## Project Structure

```
~/.dotfiles/
├── install                  # Main installation script (START HERE)
├── LinkingManifest.json     # Declarative symlink definitions
│
├── bin/                     # Executable scripts (lowercase required)
│   ├── core/               # Core utilities (25+ scripts)
│   ├── credentials/        # Secure credential management
│   ├── git/               # Git hooks and utilities
│   ├── ide/               # IDE integration
│   ├── ios/               # iOS development tools (macOS)
│   └── macos/             # macOS-specific utilities
│
├── git/                    # Git configuration (NOT scripts)
│   ├── .gitconfig         # Global config
│   ├── .gitignore        # Patterns (symlinked to root)
│   └── aliases           # Git aliases
│
├── packages/              # Package manager configs
│   ├── homebrew/         # Brewfile for macOS
│   ├── mise/             # Version manager
│   └── syncservice/      # Background sync
│
├── zsh/                   # Zsh configuration (OPTIMIZED!)
│   ├── .zshrc            # Main config (< 500ms startup)
│   ├── personal-config.zsh # Personal environment
│   ├── work-config.zsh     # Work environment
│   └── lib/
│       └── lazy-load.zsh   # Lazy loading framework
│
├── openspec/             # Spec-driven development
│   ├── changes/         # Proposed changes
│   └── specs/          # Implemented specs
│
└── ai_docs/             # AI assistant documentation
```

**Constitutional Rule:** All directories MUST be lowercase (see [MINDSET.MD](MINDSET.MD))

See [ONBOARDING.md](ONBOARDING.md) for detailed structure explanation.

## Documentation

**Getting Started:**
- [QUICKSTART.md](QUICKSTART.md) - 5-minute setup guide
- [ONBOARDING.md](ONBOARDING.md) - Comprehensive 30-minute guide
- [AGENTS.md](AGENTS.md) - Project overview and AI assistant guide

**Performance:**
- [ZSH_OPTIMIZATION_SUMMARY.md](ZSH_OPTIMIZATION_SUMMARY.md) - Performance improvements

**Development:**
- [MINDSET.MD](MINDSET.MD) - Coding standards and constitutional rules
- [openspec/AGENTS.md](openspec/AGENTS.md) - Spec-driven development workflow
- [CHANGELOG.md](CHANGELOG.md) - User-facing changes

**Security:**
- [openspec/changes/fix-credential-shell-history-exposure/](openspec/changes/fix-credential-shell-history-exposure/) - Credential security

**Reference:**
- [LinkingManifest.json](LinkingManifest.json) - Symlink definitions
- [packages/homebrew/Brewfile](packages/homebrew/Brewfile) - Package list

## Contributing

Contributions welcome! Please follow these guidelines:

### Development Workflow

1. **Create a branch:**
   ```bash
   git checkout -b feature/my-feature
   ```

2. **Make changes following standards:**
   - Lowercase directories ONLY (constitutional rule)
   - Pass `shellcheck` validation
   - Use conventional commit messages
   - Test your changes
   - No emojis in documentation or code

3. **Test:**
   ```bash
   shellcheck bin/core/my-script
   ./bin/core/my-script --dry-run
   ```

4. **Commit:**
   ```bash
   git commit -m "feat: add my feature"
   ```

5. **Create PR:**
   ```bash
   gh pr create --title "feat: add feature" --body "Description"
   ```

### Coding Standards

- **Shell:** Follow [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- **Commits:** Use [Conventional Commits](https://www.conventionalcommits.org/)
- **Directories:** MUST be lowercase (see [MINDSET.MD](MINDSET.MD))
- **Documentation:** NO emojis allowed (see [MINDSET.MD](MINDSET.MD))
- **Security:** Never expose secrets in command arguments

### For Major Changes

Use OpenSpec for proposals:
1. Create proposal in `openspec/changes/`
2. Write spec.md with requirements
3. Validate with `openspec validate --strict`
4. Implement following tasks.md

See [openspec/AGENTS.md](openspec/AGENTS.md) for details.

## FAQ

**Q: Does this work on Linux?**
A: Yes! Tested on Ubuntu 20.04+, CentOS 8+. Some features are macOS-only (Homebrew, Keychain).

**Q: Can I customize the configuration?**
A: Absolutely! Edit files in `git/`, `zsh/`, `packages/` directories. Add your own scripts to `bin/core/`.

**Q: How do I add my own packages?**
A: Add them to `packages/homebrew/Brewfile` and run `brew bundle install --file=packages/homebrew/Brewfile`.

**Q: Is it safe to run `./install` multiple times?**
A: Yes! All operations are idempotent. Safe to re-run anytime.

**Q: What if I don't use Zsh?**
A: Scripts work with any shell. You'll need to manually source configurations for bash/fish.

**Q: Can I use this with my existing dotfiles?**
A: Yes, but conflicts may occur. The installer creates backups of existing files with timestamps.

**Q: How do I keep dotfiles in sync across machines?**
A: Use `syncenv` or `home-sync` commands. See [Usage](#synchronization) section.

**Q: Why is shell startup so fast?**
A: We use lazy loading, compiled configs, smart caching, and optimized history. See [Performance](#performance-features).

**Q: How do I debug slow startup?**
A: Run `zsh-benchmark --detailed` to see function-by-function timing.

## Why These Dotfiles?

### Comparison with Typical Dotfiles

| Feature | This Project | Typical Dotfiles |
|---------|--------------|------------------|
| **Installation** | One command (`./install`) | Manual symlinking, trial and error |
| **Symlink Management** | Declarative JSON manifest | Hardcoded scripts, brittle paths |
| **Environments** | Work/personal switching | Single environment only |
| **Credentials** | Secure Keychain, no history exposure | Plaintext files or git-crypt |
| **Sync** | Automated (`syncenv`, `home-sync`) | Manual git operations |
| **Change Management** | OpenSpec proposals with specs | Ad-hoc changes, no structure |
| **Scripts** | 50+ organized, tested utilities | Scattered scripts, no organization |
| **Performance** | < 500ms startup (lazy loading) | 1-3s startup (everything loads) |
| **Security** | Interactive credential input | Secrets in shell history |

### What Makes This Special

- **Declarative Configuration** - LinkingManifest.json is source of truth for all symlinks

- **Performance First** - Lazy loading, compiled configs, < 500ms cold start

- **Security by Design** - Interactive credential input prevents shell history exposure

- **Environment Aware** - Seamless work/personal mode switching with prompt indicators

- **Spec-Driven** - OpenSpec framework ensures changes are documented and validated

- **Battle-Tested** - 50+ utility scripts for real-world workflows

## License

MIT License - see [LICENSE](LICENSE) for details.

Copyright (c) 2025 Bruno Gama

## Acknowledgments

**Built with:**
- [Prezto](https://github.com/sorin-ionescu/prezto) - Zsh configuration framework
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Zsh theme
- [OpenSpec](https://github.com/cloudy-os/openspec) - Spec-driven development
- [Homebrew](https://brew.sh/) - Package management

**Modern CLI tools:**
- [eza](https://github.com/eza-community/eza) - Modern ls replacement
- [bat](https://github.com/sharkdp/bat) - Cat with syntax highlighting
- [fd](https://github.com/sharkdp/fd) - Fast find alternative
- [ripgrep](https://github.com/BurntSushi/ripgrep) - Fast grep alternative
- [delta](https://github.com/dandavison/delta) - Beautiful git diffs
- [zoxide](https://github.com/ajeetdsouza/zoxide) - Smart cd command

**Inspired by:**
- [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles)
- [Holman's dotfiles](https://github.com/holman/dotfiles)
- [thoughtbot's dotfiles](https://github.com/thoughtbot/dotfiles)

---

<div align="center">

**Star this repo if you find it useful!**

[Report Bug](https://github.com/yourusername/dotfiles/issues) · [Request Feature](https://github.com/yourusername/dotfiles/issues) · [Documentation](ONBOARDING.md)

</div>
