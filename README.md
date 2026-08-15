# Modern Dotfiles

[![CI](https://github.com/brunogama/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/brunogama/dotfiles/actions/workflows/ci.yml)

A Nix-first, macOS-oriented home-environment configuration for a reproducible developer setup. It combines Home Manager and optional nix-darwin activation with shell configuration, safe convention-based linking, credential utilities, Git helpers, and local synchronization tools.

> [!IMPORTANT]
> This repository is configured for macOS hosts. Before activating it on another machine, review and personalize [`nix/host.nix`](nix/host.nix), which defines the account, host, architecture, and Git identity used by the Nix configuration.

---

## Highlights

- **Declarative setup** - Nix flakes and Home Manager manage the primary user environment, with optional nix-darwin system settings.
- **Explicit ownership** - Home Manager owns its declared paths; the convention linker manages eligible files and public commands outside that boundary.
- **Safe activation** - Dry-run modes, collision protection, confirmations, and `pre-nix` backups avoid silently overwriting configuration.
- **Productive shell** - Zsh, Starship, version-manager support, work and personal profiles, and shell-maintenance commands are included.
- **Credential tooling** - Keychain-backed API-key helpers and encrypted credential-file workflows keep secrets out of the repository and shell history.
- **Built-in quality checks** - Shell, Python, Nix, integration, and repository validation tooling support safe changes.

---

## Get started

### Recommended: smart installation

Clone the repository, then preview the installation plan before applying it:

```bash
git clone https://github.com/brunogama/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install --dry-run
./install
```

`./install` never fetches or synchronizes the checkout. It uses the current worktree contents, warns when they are dirty, and is safe to rerun.

- On macOS, it selects the user-only Nix and Home Manager flow, bootstrapping upstream Nix with consent when required.
- On Linux, it selects the retained legacy installer and provisions minimal prerequisites through `apt-get`, `dnf`, or `pacman`.
- Unsupported platforms fail with an actionable error.

For the optional privileged macOS configuration, preview first and then apply it:

```bash
./install --system --dry-run
./install --system
```

> [!TIP]
> Use `--backend auto|nix|legacy` to choose a backend explicitly. `--nix` remains a compatibility alias, and `--legacy` is a shorter legacy alias. Pass `--username NAME` or `--machine-name NAME` only when changing host identity. Use `--nix-distribution determinate` for an existing Determinate Nix installation.

### Focused maintenance and recovery

Use `./install --scripts-only` to update only public commands in `~/.local/bin`; it never selects or activates a backend. Legacy mode on a Home Manager-managed macOS user is blocked unless `--allow-mixed-backends` explicitly acknowledges the recovery risk.

Legacy-only options are `--skip-brew`, `--skip-packages`, and `--skip-links`. Nix-only options are `--configuration`, `--skip-npm`, and `--nix-distribution`. Incompatible option combinations fail instead of being ignored. Run `./install --help` for the complete interface.

---

## Configuration ownership and linking

The repository uses two complementary activation mechanisms:

| Mechanism | Owns | Use it for |
| --- | --- | --- |
| Home Manager and nix-darwin | Paths explicitly declared in [`nix/home.nix`](nix/home.nix) and [`nix/darwin.nix`](nix/darwin.nix) | Reproducible user and system configuration |
| Convention linker | Eligible files under [`home/`](home/), [`home-darwin/`](home-darwin/), and public executables directly under `bin/<domain>/` | Home files and commands not declared in Nix |

The linker maps home-tree files to their equivalent paths below `$HOME` and links public commands to `~/.local/bin`. It previews by default and refuses unmanaged collisions unless explicitly forced.

```bash
# Inspect planned links
uv run bin/core/link-dotfiles.py --dry-run

# Apply only after reviewing the plan
uv run bin/core/link-dotfiles.py --apply --yes

# Link only public commands
uv run bin/core/link-dotfiles.py --commands-only --apply --yes
```

> [!WARNING]
> Use `--force` only when you have confirmed that replacing an existing target is correct. Pruning removes only links recorded in the linker's ownership state.

---

## Everyday operations

### Environment and packages

```bash
# Check or change the active shell profile
work-mode status
work-mode work
work-mode personal

# Start a new shell after switching profiles
exec zsh

# Preview Nix operations
nix-activate --dry-run
nix-rebuild --dry-run
nix-update --dry-run

# Validate the Nix configuration
nix-validate
```

### Credentials

```bash
# Prompt for an API key and store it in the macOS Keychain
store-api-key OPENAI_API_KEY

# Retrieve a stored API key
get-api-key OPENAI_API_KEY

# Manage encrypted credential files
credfile ~/.secrets/example
credmatch example
```

> [!WARNING]
> Never pass a secret as a command argument. Use the interactive prompt, standard input, or a file so it does not enter shell history or process listings.

### Synchronization and shell maintenance

```bash
# Synchronize this dotfiles repository
home-sync status
home-sync sync

# Maintain shell performance
zsh-benchmark
zsh-compile
zsh-trim-history
```

---

## Project map

```text
.
├── install          # Nix dispatcher and legacy installer
├── flake.nix        # Nix flake entry point
├── nix/             # Host, Home Manager, package, and nix-darwin modules
├── home/            # Common home-directory source files
├── home-darwin/     # macOS-specific home-directory source files
├── bin/             # Public tools grouped by domain
│   ├── core/        # Nix, linker, shell, sync, and utility commands
│   ├── credentials/ # Keychain and encrypted-credential tools
│   ├── git/         # Git workflow helpers and hooks
│   ├── ide/         # IDE integrations
│   ├── macos/       # macOS-specific utilities
│   └── test/        # Repository test runner
├── packages/        # Package-manager configuration
├── git/             # Git configuration and shared helpers
├── zsh/             # Zsh configuration and support files
├── tests/           # Bats, Python, and integration coverage
└── docs/            # Architecture, guides, and operational documentation
```

---

## Validate changes

Run the checks appropriate to the surface you changed:

```bash
# Shell syntax
bash -n install

# Static and evaluated Nix checks
nix-validate --static
nix-validate

# Confirm linking is safe before applying it
uv run bin/core/link-dotfiles.py --dry-run

# Integration tests
bin/test/run-tests

# Focused Python tests
python3 tests/test_git_smart_merge.py
python3 tests/test_uv_resolver.py

# Full local macOS CI gate before opening or updating a pull request
scripts/local-ci.sh
```

> [!NOTE]
> `scripts/local-ci.sh` runs each macOS stage in an isolated temporary workspace. Use `--include-destructive` only when you explicitly want to test Nix installation in a disposable VM.

See [`tests/README.md`](tests/README.md) for Bats test prerequisites, filtering, timing, TAP output, and parallel execution.

---

## Documentation

- [Architecture overview](docs/architecture.md)
- [Convention linker source inventory](docs/linking-source-inventory.md)
- [Credential management guide](docs/guides/CREDENTIAL_MANAGEMENT.md)
- [Git virtual worktree guide](docs/git-virtual-worktree.md)
- [Script quick reference](docs/scripts/quick-reference.md)
