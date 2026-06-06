<!-- prettier-ignore -->
<div align="center">

# Modern Dotfiles

A fast, declarative Unix home environment for shell configuration, secure credentials, Git workflows, package management, and machine-to-machine sync.

[![CI](https://img.shields.io/github/actions/workflow/status/brunogama/dotfiles/ci.yml?branch=main&style=flat-square&label=CI)](https://github.com/brunogama/dotfiles/actions)
![Shell](https://img.shields.io/badge/shell-bash%20%2B%20zsh-4eaa25?style=flat-square)
![Python](https://img.shields.io/badge/python-3.11%2B-3776ab?style=flat-square&logo=python&logoColor=white)
![Platform](https://img.shields.io/badge/platform-macOS%20%2B%20Linux-555?style=flat-square)

[Overview](#overview) • [Get started](#get-started) • [Daily workflows](#daily-workflows) • [Project map](#project-map) • [Validation](#validation)

<img src="./img/home.png" alt="Modern Dotfiles terminal home banner" width="720" />

</div>

## Overview

This repository turns a home directory into a reproducible, high-performance development environment. It combines declarative symlink management with focused command-line utilities so the same setup can be installed, updated, audited, and synchronized across machines.

The main goals are:

- **Fast shell startup** with optimized zsh, Prezto, Powerlevel10k, and lazy-loaded version managers.
- **Safe installation** through an idempotent `./install` script and a JSON symlink manifest.
- **Work/personal environments** with prompt indicators and separate zsh configuration files.
- **Credential hygiene** using Keychain-backed and encrypted secret storage tools.
- **Portable automation** with shell, Python, Git, macOS, iOS, and video utilities under `bin/`.
- **Quality gates** for shell syntax, manifest validation, OpenSpec proposals, Python tests, and integration tests.

> [!IMPORTANT]
> Dotfiles intentionally create symlinks and can replace existing configuration files. Start with `./install --dry-run` before applying changes on a new machine.

## Features

| Area | What is included |
| --- | --- |
| Installation | One-command setup, dry runs, non-interactive mode, scripts-only updates |
| Shell | Organized zsh config, Prezto, Powerlevel10k, lazy loading, custom completions |
| Environments | `work-mode` switches between `work` and `personal` profiles |
| Sync | `syncenv`, `home-sync`, and an optional macOS background sync service |
| Credentials | `store-api-key`, `get-api-key`, `credmatch`, `credfile`, and history cleanup |
| Git | Conventional commits, WIP/savepoint helpers, worktree helpers, smart merge tools |
| Packages | Homebrew bundle, mise config, macOS preferences, sync service config |
| Testing | Bats integration tests, Python unit tests, CI validation, mypy and coverage for `home-sync` |

## Get started

### Prerequisites

- macOS 10.15+ or a modern Linux distribution
- Git 2.30+
- Bash 4+
- Zsh 5.8+
- Python 3.11+ for Python-based tools
- `uv` for inline Python scripts such as `syncenv`
- `jq` for manifest processing (installed automatically when possible)
- Xcode Command Line Tools on macOS: `xcode-select --install`

### Install

```bash
git clone https://github.com/brunogama/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Preview all changes first
./install --dry-run

# Interactive setup
./install

# Restart the shell after installation
exec zsh
```

Useful installer modes:

```bash
./install --yes             # Non-interactive setup
./install --skip-packages   # Skip package installation
./install --skip-links      # Skip symlink creation
./install --scripts-only    # Refresh scripts in ~/local/bin only
```

> [!TIP]
> The installer is designed to be idempotent. Re-run it after pulling updates or after changing `LinkingManifest.json`.

### First steps after install

```bash
# Choose an environment profile
work-mode personal
# or
work-mode work

# Store credentials without exposing secrets in shell history
store-api-key GITHUB_TOKEN
store-api-key OPENAI_API_KEY

# Check shell startup performance
zsh-benchmark

# Explore available tools
dotfiles-help
```

## Daily workflows

### Switch environments

```bash
work-mode work       # Sets DOTFILES_ENV=work and loads work config
work-mode personal   # Uses the personal profile by default
work-mode status     # Shows the active profile
```

Work mode loads `~/.config/zsh/work-config.zsh` and personal mode loads `~/.config/zsh/personal-config.zsh`. The prompt shows `WORK` or `HOME:PERSONAL` after reloading the shell.

### Manage symlinks

`LinkingManifest.json` is the source of truth for files linked into your home directory.

```bash
python3 bin/core/link-dotfiles.py --dry-run
python3 bin/core/link-dotfiles.py --apply
```

It links zsh files, Git configuration, package manager config, sync service files, and executable scripts into their target locations.

### Manage credentials

```bash
# Simple secrets in macOS Keychain
store-api-key API_KEY_NAME
get-api-key API_KEY_NAME

# Searchable encrypted credentials
credmatch list
credmatch search github

# Encrypted files such as SSH keys or certificates
credfile put github_ssh ~/.ssh/id_rsa
credfile get github_ssh /tmp/id_rsa

# Audit shell history for exposed secrets
clear-secret-history --dry-run
```

> [!WARNING]
> Do not pass secrets as command arguments. Use interactive prompts, stdin, or files so values do not land in shell history.

### Sync across machines

```bash
syncenv                  # Smart Git-based sync for the active profile
syncenv --status         # Check repository sync state
home-sync status         # Check package-backed sync state
home-sync-service start  # Optional macOS LaunchAgent
```

> [!NOTE]
> `syncenv` uses `uv` to resolve inline Python dependencies. `home-sync` uses the package in `bin/core/home_sync`; set up its `.venv` before starting the background service.

The Python `home-sync` package includes daemon, locking, Git, metrics, and config modules.

### Tune zsh performance

```bash
zsh-benchmark            # Quick startup benchmark
zsh-benchmark --detailed # zprof-based details
zsh-compile              # Compile zsh files to .zwc bytecode
zsh-trim-history         # Keep history size manageable
```

Heavy tools such as `nvm`, `pyenv`, `rbenv`, `mise`, SDKMAN, and fzf are loaded lazily so interactive shells stay responsive.

### Manage packages

```bash
brew bundle --file packages/homebrew/Brewfile
brew-sync update
brew-sync generate
```

The Homebrew bundle captures CLI tools, GUI apps, VS Code extensions, and globally installed npm packages used by this environment.

## Project map

```text
.
├── install                    # Main idempotent installer
├── LinkingManifest.json       # Declarative symlink manifest
├── bin/
│   ├── core/                  # Core utilities and home-sync Python package
│   ├── credentials/           # Secret and encrypted-file management
│   ├── git/                   # Git workflow helpers
│   ├── ide/                   # Editor integration
│   ├── macos/                 # macOS-specific tools
│   └── test/                  # Test runner
├── docs/
│   ├── guides/                # Deep-dive user guides
│   ├── scripts/               # Script reference and quick reference
│   └── reports/               # Architecture and implementation reports
├── git/                       # Global Git config and templates
├── packages/
│   ├── homebrew/              # Brewfile declarations
│   ├── ios/                   # iOS tooling settings
│   ├── macos/                 # macOS preference exports
│   ├── mise/                  # Tool version config
│   └── syncservice/           # Launch agent and sync config
├── tests/                     # Bats, Python, fixtures, and helpers
└── zsh/                       # zsh, Prezto, Powerlevel10k, completions
```

## Validation

Run the smallest useful check for the area you changed:

```bash
# Shell syntax
bash -n install
zsh -n zsh/.zshrc

# Installer, manifest, and linking
./install --dry-run
python3 -m json.tool LinkingManifest.json >/dev/null
python3 bin/core/link-dotfiles.py --dry-run

# Integration tests
./bin/test/run-tests

# Python package tests
cd bin/core/home_sync
uv pip install -e ".[dev]"
uv run pytest tests/ -v
uv run mypy home_sync --strict
```

GitHub Actions also validates pre-commit hooks, lowercase directory rules, emoji-free text files, shell scripts, the linking manifest, OpenSpec proposals, installation dry runs, and Linux/macOS test paths.

## Documentation

- [QUICKSTART.md](QUICKSTART.md) - Short setup guide.
- [ONBOARDING.md](ONBOARDING.md) - Full architecture and workflow tour.
- [docs/scripts/quick-reference.md](docs/scripts/quick-reference.md) - One-page command reference.
- [docs/guides/CREDENTIAL_MANAGEMENT.md](docs/guides/CREDENTIAL_MANAGEMENT.md) - Credential storage guide.
- [docs/reports/ZSH_OPTIMIZATION_SUMMARY.md](docs/reports/ZSH_OPTIMIZATION_SUMMARY.md) - Shell performance notes.
- [AGENTS.md](AGENTS.md) - Project instructions for AI coding agents.

Dedicated files cover legal, contribution, and release-history details.

## Troubleshooting

| Symptom | Try this |
| --- | --- |
| A command is not found | Confirm `~/local/bin` is in `PATH`, then run `./install --scripts-only` |
| Symlinks point to the wrong place | Run `python3 bin/core/link-dotfiles.py --dry-run`, then `python3 bin/core/link-dotfiles.py --apply --force` if needed |
| Shell startup feels slow | Run `zsh-benchmark --detailed`, then `zsh-compile` |
| Work profile did not apply | Run `work-mode status`, then `exec zsh` |
| Homebrew packages drifted | Run `brew-sync generate` or `brew bundle --file packages/homebrew/Brewfile` |
| Credentials are missing | Use `credmatch list`, `credfile list`, or re-store simple keys with `store-api-key` |

If you are using this repository as a starting point for your own dotfiles, review every link target and script before applying it to your machine.
