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

This repository turns a home directory into a reproducible, high-performance development environment. Nix flakes and standalone Home Manager own the user CLI toolchain, shell files, and Git configuration without sudo. Optional nix-darwin activation owns supported system defaults, with Homebrew retained only for declared macOS exceptions.

The main goals are:

- **Fast shell startup** with optimized zsh, Nix-managed Prezto and Starship, and opt-in legacy version managers.
- **Safe installation** through idempotent bootstrap scripts, evaluated Nix configuration, and rollback-capable generations.
- **Work/personal environments** with separate zsh configuration files.
- **Credential hygiene** using Keychain-backed and encrypted secret storage tools.
- **Portable automation** with shell, Python, Git, macOS, iOS, and video utilities under `bin/`.
- **Quality gates** for shell syntax, manifest validation, OpenSpec proposals, Python tests, and integration tests.

> [!IMPORTANT]
> Home Manager takes ownership of declared shell and Git files. The first activation backs conflicting files up with a `.pre-nix` suffix. Start with `./install --nix --dry-run`.

## Features

| Area | What is included |
| --- | --- |
| Installation | One-command setup, dry runs, non-interactive mode, scripts-only updates |
| Shell | Organized zsh config, Prezto, Starship, lazy loading, custom completions |
| Environments | `work-mode` switches between `work` and `personal` profiles |
| Sync | `syncenv`, `home-sync`, and an optional macOS background sync service |
| Credentials | `store-api-key`, `get-api-key`, `credmatch`, `credfile`, and history cleanup |
| Git | Conventional commits, WIP/savepoint helpers, worktree helpers, smart merge tools |
| Packages | Nixpkgs CLI tools, pinned npm agent tools, and a minimal Homebrew exception set |
| Testing | Bats integration tests, Python unit tests, CI validation, mypy and coverage for `home-sync` |

## Get started

### Prerequisites

- macOS with Xcode Command Line Tools: `xcode-select --install`
- Git for cloning the repository
- Administrator access only when installing multi-user Nix or explicitly activating nix-darwin system settings
- Review `nix/host.nix`; it is the single place for the user, architecture, and Git identity

`./install --nix` defaults to standalone Home Manager and does not use sudo when Nix is already installed. Use `./install --nix --system` only when you want nix-darwin, macOS defaults, shell registration, and retained Homebrew items. If Nix is managed by Determinate Systems, set `manageNix = false` in `nix/host.nix` before system activation.

### Install

```bash
git clone https://github.com/brunogama/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Edit username, architecture, and Git identity first
$EDITOR nix/host.nix

# Preview prerequisite and activation commands
./install --nix --dry-run

# Activate Home Manager and npm tools without sudo
./install --nix

exec zsh
```

Useful installer modes:

```bash
./install --nix --system    # Optional privileged nix-darwin activation
./install --nix --yes       # Non-interactive prerequisite installation
./install --nix --skip-npm  # Activate without the external npm tool set
./install --scripts-only    # Refresh scripts in ~/local/bin only
./install                   # Legacy Homebrew/version-manager installer
```

> [!TIP]
> User and system activation are idempotent. Existing Home Manager conflicts are backed up as `*.pre-nix`. On first system activation, recognized Apple shell files modified only by the upstream Nix installer are preserved as `*.before-nix-darwin`; unknown or customized `/etc` files are never overwritten. Homebrew is touched only by explicit `--system` activation, and automatic cleanup remains disabled.

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

Work mode loads `~/.config/zsh/work-config.zsh` and personal mode loads `~/.config/zsh/personal-config.zsh` after reloading the shell.

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

Nix-provided runtimes are used by default. To temporarily restore the previous nvm, pyenv, rbenv, mise, and SDKMAN hooks, set `DOTFILES_ENABLE_LEGACY_VERSION_MANAGERS=1`; fzf remains lazy-loaded either way.

### Manage packages

```bash
nix-activate                 # Activate the user environment without sudo
nix-rebuild                  # Activate privileged nix-darwin system settings
nix-update                   # Update and validate flake.lock only
nix-update --switch          # Update and activate the user environment
nix-update --switch --system # Update and activate nix-darwin with sudo
nix-validate                 # Static checks plus all Nix evaluations
nix-npm-sync                 # Reinstall the package-lock.json npm tool set
```

Add CLI packages to `nix/packages.nix`. Homebrew exceptions live in both `nix/darwin.nix` and the legacy `packages/homebrew/Brewfile`; keep those small lists aligned. Pinned agent-facing npm packages live in `packages/npm/` and install under `~/.local/share/dotfiles/npm/`.

### Migration and rollback

The first user activation moves shell and Git ownership from `LinkingManifest.json` to standalone Home Manager. The manifest remains for the legacy installer and script linking. Optional system activation reuses the same Home Manager module through nix-darwin, so the two modes do not maintain separate user configurations. `work-mode` stores mutable state in `~/.config/zsh/environment.zsh`, outside the Nix store. Keychain and encrypted credential files are never copied into Nix derivations.

Homebrew is retained only for:

- `sourcekitten`, because it depends on the Apple/Xcode toolchain and is not packaged in the selected Nixpkgs release.
- Fork, because it is a macOS GUI cask.
- `anysphere.remote-ssh`, because it is installed through the editor marketplace.

```bash
nix-rollback --list              # Inspect available generations
nix-rollback                     # Activate the previous generation
nix-rollback --generation 42     # Activate one specific generation
```

A nix-darwin rollback does not remove Nix. For a full return to the legacy flow, run the nix-darwin uninstaller, restore the relevant `*.pre-nix` files, then run `./install`. Review commands before removing `/nix` or Homebrew.

## Project map

```text
.
├── flake.nix                  # Pinned nix-darwin/Home Manager entry point
├── flake.lock                 # Reproducible input revisions
├── install                    # Nix dispatcher and legacy installer
├── LinkingManifest.json       # Legacy and script symlink manifest
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
├── nix/                       # Host, package, macOS, and Home Manager modules
├── packages/
│   ├── homebrew/              # Retained Homebrew exceptions
│   ├── npm/                   # Locked external npm tools
│   ├── ios/                   # iOS tooling settings
│   ├── macos/                 # macOS preference exports
│   ├── mise/                  # Tool version config
│   └── syncservice/           # Launch agent and sync config
├── tests/                     # Bats, Python, fixtures, and helpers
└── zsh/                       # zsh, Prezto, Starship, completions
```

## Validation

Run the smallest useful check for the area you changed:

```bash
# Nix migration scripts and evaluation
nix-validate --static        # Works before Nix is installed
nix-validate --target user   # Standalone Home Manager evaluation
nix-validate --target system # nix-darwin evaluation
nix-validate                 # Validate both modes

# Shell syntax
bash -n install
zsh -n zsh/.zshrc

# Installer, manifest, and linking
./install --nix --dry-run
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
| A command is not found | Run `nix-activate`, then `exec zsh`; for repository scripts also run `./install --scripts-only` |
| Nix activation reports an existing file | Inspect the file and its `.pre-nix` backup before retrying; do not delete either blindly |
| `pi` is missing | Run `nix-npm-sync`, then verify `~/.local/share/dotfiles/npm/current/node_modules/.bin/pi` |
| Nix conflicts with Determinate Nix | Set `manageNix = false` in `nix/host.nix` and rebuild |
| Shell startup feels slow | Run `zsh-benchmark --detailed`, then `zsh-compile` |
| Work profile did not apply | Run `work-mode status`, then `exec zsh` |
| Homebrew exceptions drifted | Run `nix-rebuild`; automatic cleanup is intentionally disabled |
| Credentials are missing | Use `credmatch list`, `credfile list`, or re-store simple keys with `store-api-key` |

If you are using this repository as a starting point for your own dotfiles, review every link target and script before applying it to your machine.
