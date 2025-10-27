# Dotfiles Project

Modern Unix dotfiles with environment management, automated sync, and secure credential storage.

## Core Functionality

**Environment Management**

- `work-mode [work|personal|status]` - Switch between work/home environments
- Prompt shows: **WORK** (orange) or **HOME:PERSONAL** (blue)
- Config: `~/.config-fixing-dot-files-bugs/zsh/{work,personal}-config.zsh`

**Sync & Backup**

- `home-sync [sync|push|pull|status]` - Sync dotfiles across machines
- `home-sync-service [start|stop|status]` - Background sync daemon

**Credentials**

- `credfile <file>` - Manage secure credential files (keychain + encrypted)
- `credmatch <pattern>` - Search/decrypt credentials by pattern

**Dotfiles Management**

- `./install` - One-command installation (idempotent)
- `./install --dry-run` - Preview installation without changes
- `./install --yes` - Non-interactive installation for CI
- `link-dotfiles` - Create symlinks from LinkingManifest.json
- `link-dotfiles --apply` - Actually create the symlinks

## Project Structure

```
.gitignore           # Symlink → git/.gitignore
.gitmodules          # Symlink → git/.gitmodules
LinkingManifest.json # Declarative symlink mappings
bin/                 # Executable scripts
├── core/            # Core utilities
├── credentials/     # Credential management
├── git/            # Git scripts and hooks
├── ide/            # IDE tooling
├── ios/            # iOS development (macOS only)
└── macos/          # macOS-specific scripts
git/                  # Git configuration (scripts in bin/git/)
├── .gitconfig
├── .gitignore      # Actual file, symlinked to root
├── .gitmodules     # Actual file, symlinked to root
├── ignore
└── aliases
packages/            # Package manager configs
├── homebrew/
│   └── Brewfile    # Symlinked to ~/Brewfile
├── macos/
├── mise/
├── ios/
└── syncservice/
zsh/                 # Shell configuration
fish/                # Fish shell config (optional)
ai_docs/            # AI assistant documentation
openspec/            # Change proposals and specs
```

## Code Quality Rules

### Shell Scripts

- **MUST** pass `shellcheck` with no errors
- Use `set -euo pipefail` for safety
- Quote variables: `"$var"` not `$var`
- Prefer `[[` over `[` for conditionals

### Python Scripts

- **MUST** adhere to PEP 8 style guide
- **MUST** use `uv` for dependency management
- Single-file scripts: Use `uv run` with inline metadata
- Example header:

  ```python
  #!/usr/bin/env -S uv run
  # /// script
  # requires-python = ">=3.11"
  # dependencies = ["requests"]
  # ///
  ```

### Git Commits

- Use conventional commits: `feat:`, `fix:`, `chore:`, etc.
- Include co-author: `factory-droid[bot]`

## OpenSpec Integration

<!-- OPENSPEC:START -->
# OpenSpec Instructions

These instructions are for AI assistants working in this project.

Always open `@/openspec/AGENTS.md` when the request:
- Mentions planning or proposals (words like proposal, spec, change, plan)
- Introduces new capabilities, breaking changes, architecture shifts, or big performance/security work
- Sounds ambiguous and you need the authoritative spec before coding

Use `@/openspec/AGENTS.md` to learn:
- How to create and apply change proposals
- Spec format and conventions
- Project structure and guidelines

Keep this managed block so 'openspec update' can refresh the instructions.

<!-- OPENSPEC:END -->