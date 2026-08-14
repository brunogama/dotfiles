<!-- prettier-ignore -->
<div align="center">

# Modern Dotfiles

A declarative, reproducible development environment for macOS and Linux.

[![CI](https://img.shields.io/github/actions/workflow/status/brunogama/dotfiles/ci.yml?branch=main&style=flat-square&label=CI)](https://github.com/brunogama/dotfiles/actions)
![Shell](https://img.shields.io/badge/shell-bash%20%2B%20zsh-4eaa25?style=flat-square)
![Python](https://img.shields.io/badge/python-3.11%2B-3776ab?style=flat-square&logo=python&logoColor=white)
![Platform](https://img.shields.io/badge/platform-macOS%20%2B%20Linux-555?style=flat-square)

[Get started](#get-started) • [Everyday operations](#everyday-operations) • [Validation](#validation) • [Documentation](#documentation)

<img src="./img/home.png" alt="Modern Dotfiles terminal home banner" width="720" />

</div>

## Overview

---

Modern Dotfiles manages a fast, portable home environment: shell configuration, Git settings, package declarations, secure credentials, and automation commands. Nix and Home Manager are the primary installation path; nix-darwin is opt-in for macOS system settings. Legacy scripts remain available for machines that have not migrated.

> [!IMPORTANT]
> Start with `./install --nix --dry-run`. Home Manager manages declared shell and Git files and preserves conflicts as `*.pre-nix` backups rather than overwriting them blindly.

## Highlights

---

| Area | What it provides |
| --- | --- |
| Shell | Zsh, Prezto, Starship, lazy loading, completion, and startup profiling. |
| Environments | `work-mode` switches between personal and work profiles. |
| Packages | Reproducible Nix packages, pinned npm tools, and a small Homebrew exception list. |
| Credentials | Keychain-backed API keys plus encrypted searchable credentials and files. |
| Automation | Core, Git, IDE, macOS, iOS, and media tools exposed from `bin/`. |
| Quality | Shell checks, Bats integration tests, Python tests, Nix evaluation, and CI. |

## Get started

---

### Prerequisites

- macOS with Xcode Command Line Tools, or a supported Linux distribution
- Git and a terminal
- Nix for the recommended installation path
- Administrator access only for multi-user Nix or `--system` nix-darwin activation

Review `nix/host.nix` before activation. It defines the machine name, user identity, and Nix ownership settings.

### Install the user environment

```bash
git clone https://github.com/brunogama/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

$EDITOR nix/host.nix
./install --nix --dry-run
./install --nix
exec zsh
```

The default Nix flow activates standalone Home Manager without `sudo`, configures the managed home files, installs pinned CLI packages, and links repository commands into `~/.local/bin`.

Use these variants only when needed:

```bash
./install --nix --system    # Also activate nix-darwin system settings
./install --nix --yes       # Non-interactive identity detection
./install --nix --skip-npm  # Skip the pinned npm tool set
./install --scripts-only    # Refresh public command links only
./install                   # Legacy installer path
```

> [!TIP]
> `--system` is the only mode that changes macOS system defaults or touches retained Homebrew exceptions.

### First commands

```bash
work-mode personal
store-api-key GITHUB_TOKEN
zsh-benchmark
dotfiles-help
```

## Everyday operations

---

### Switch environment profiles

```bash
work-mode work
work-mode personal
work-mode status
```

Restart the shell with `exec zsh` after switching. The active profile is stored outside the Nix store in `~/.config/zsh/environment.zsh`.

### Link repository files and commands

The repository layout is the source of truth for links the linker owns: files beneath `home/`, platform overlays such as `home-darwin/`, and immediate executable files in `bin/<domain>/`. Targets declared in [`nix/home.nix`](nix/home.nix) are owned by Home Manager and are intentionally skipped.

```bash
uv run bin/core/link-dotfiles.py --dry-run
uv run bin/core/link-dotfiles.py --apply --yes
```

Existing targets are protected. Use `--force --yes` only after reviewing a dry run.

### Store credentials safely

```bash
# Keychain-backed API key
store-api-key OPENAI_API_KEY
get-api-key OPENAI_API_KEY

# Encrypted searchable credentials
credmatch list
credmatch search github

# Encrypted file
credfile put github_ssh ~/.ssh/id_rsa
credfile get github_ssh /tmp/id_rsa
```

> [!WARNING]
> Never pass a secret as a command argument. Use the interactive prompt, standard input, or a file so secrets do not enter shell history or process listings.

### Update packages and dotfiles

```bash
nix-activate                 # Activate the user environment
nix-update                   # Update and validate flake.lock
nix-update --switch          # Update and activate the user environment
nix-validate                 # Run static checks and Nix evaluations
nix-npm-sync                 # Refresh the pinned npm tool set
update-dotfiles              # Update the repository checkout
```

Add general CLI packages to `nix/packages.nix`. Keep Homebrew exceptions aligned between `nix/darwin.nix` and `packages/homebrew/Brewfile.generated`.

### Sync and maintain the shell

```bash
syncenv --status
home-sync status
home-sync-service start

zsh-benchmark --detailed
zsh-compile
zsh-trim-history
```

`syncenv` resolves inline Python dependencies with `uv`. The optional `home-sync` service is a package-backed Python application under `bin/core/home_sync`.

## Project map

---

```text
.
├── flake.nix        # Nix, Home Manager, and nix-darwin entry point
├── install          # Nix dispatcher and legacy installer
├── home/            # Common files mapped below $HOME
├── home-darwin/     # macOS-specific home overrides
├── bin/             # Public tools grouped by domain
├── nix/             # Host, package, Home Manager, and macOS modules
├── packages/        # Npm, Homebrew, mise, macOS, and service configuration
├── git/             # Git config, aliases, and hooks
├── zsh/             # Shell framework, themes, and completion
├── tests/           # Bats, Python, fixtures, and helpers
└── docs/            # Guides, command reference, and technical reports
```

## Validation

---

Run the narrowest useful check for the files you changed:

```bash
# Installation and Nix evaluation
./install --nix --dry-run
./install --dry-run
nix-validate --static
nix-validate --target user
nix-validate --target system

# Shell and command linking
bash -n install
zsh -n home/.config/zsh/.zshrc
uv run bin/core/link-dotfiles.py --dry-run
uv run bin/core/link-dotfiles.py --prune --dry-run

# Repository test suites
./bin/test/run-tests

# home-sync Python package
cd bin/core/home_sync
uv pip install -e '.[dev]'
uv run pytest tests/ -v
uv run mypy home_sync --strict
```

GitHub Actions verifies a clean Home Manager installation on macOS as well as the static, integration, and documentation checks.

## Documentation

---

- [QUICKSTART.md](QUICKSTART.md) - Short setup path.
- [ONBOARDING.md](ONBOARDING.md) - Architecture and development workflow.
- [docs/scripts/quick-reference.md](docs/scripts/quick-reference.md) - Command reference.
- [docs/guides/CREDENTIAL_MANAGEMENT.md](docs/guides/CREDENTIAL_MANAGEMENT.md) - Credential storage and recovery.
- [docs/reports/ZSH_OPTIMIZATION_SUMMARY.md](docs/reports/ZSH_OPTIMIZATION_SUMMARY.md) - Shell performance notes.
- `AGENTS.md` - Repository conventions for coding agents.

## Troubleshooting

---

| Symptom | Try this |
| --- | --- |
| A command is unavailable | Run `nix-activate`, then `exec zsh`. For repository commands, run `./install --scripts-only` and ensure `~/.local/bin` is on `PATH`. |
| Activation reports a file conflict | Inspect the file and its `*.pre-nix` backup before retrying. Do not delete either blindly. |
| `pi` is unavailable | Run `nix-npm-sync`, then check `~/.local/share/dotfiles/npm/current/node_modules/.bin/pi`. |
| Nix conflicts with Determinate Nix | Set `manageNix = false` in `nix/host.nix`, then rebuild. |
| Shell startup is slow | Run `zsh-benchmark --detailed`, then `zsh-compile`. |
| Credentials are missing | Use `credmatch list`, `credfile list`, or re-store a simple key with `store-api-key`. |

If you adapt this repository for another machine, review every host value, link target, and installation command before applying it.
