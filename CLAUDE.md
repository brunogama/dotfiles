# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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

## Project Overview

Modern dotfiles system with:
- Declarative symlink management via `LinkingManifest.json`
- Environment switching (work/personal modes)
- Secure credential storage using macOS Keychain
- Spec-driven development using OpenSpec framework
- 50+ production-ready shell utilities
- Performance-optimized zsh (< 500ms startup)

## Constitutional Rules

### Rule 1: All Directories MUST Be Lowercase
All directories use lowercase names. No exceptions. See MINDSET.MD for rationale.

### Rule 2: No Emojis
No emojis in documentation, code, scripts, commit messages, or help text. See MINDSET.MD for rationale.

### Rule 3: OpenSpec for Major Changes
Use OpenSpec workflow for:
- New features or capabilities
- Breaking changes (API, schema, behavior)
- Architecture changes
- Performance optimizations that change behavior
- Security pattern updates

Skip OpenSpec for:
- Bug fixes restoring intended behavior
- Typos, formatting, comments
- Non-breaking dependency updates
- Simple configuration changes

See `openspec/AGENTS.md` for complete workflow.

## Core Commands

### Installation & Setup
```bash
./install                    # Interactive installation (10-20 minutes)
./install --dry-run          # Preview changes
./install --yes              # Non-interactive mode
link-dotfiles --dry-run      # Preview symlinks
link-dotfiles --apply        # Apply symlinks from manifest
```

### Language Runtime Management
The system uses official version managers for language runtimes:
```bash
# Python (pyenv)
pyenv install --list         # List available Python versions
pyenv install 3.11.5         # Install specific version
pyenv global 3.11.5          # Set global default
pyenv local 3.10.0           # Set project-specific version (.python-version)

# Ruby (rbenv)
rbenv install --list         # List available Ruby versions
rbenv install 3.2.2          # Install specific version
rbenv global 3.2.2           # Set global default
rbenv local 3.1.0            # Set project-specific version (.ruby-version)

# Node.js (nvm)
nvm install --lts            # Install latest LTS version
nvm install 18.16.0          # Install specific version
nvm use 18.16.0              # Use specific version
nvm alias default 18.16.0    # Set default version (.nvmrc supported)
```

### Testing
```bash
# Shell scripts
shellcheck bin/core/*        # Lint shell scripts
shellcheck bin/git/*         # Lint git utilities

# Python scripts (tests exist for some utilities)
python3 tests/test_git_smart_merge.py

# Validation
openspec validate --strict   # Validate all OpenSpec changes
bin/git/hooks/check-lowercase-dirs  # Constitutional rule check
bin/git/hooks/check-no-emojis       # Constitutional rule check
```

### Development Workflow
```bash
# Credential management (SECURE - no history exposure)
store-api-key OPENAI_API_KEY        # Interactive prompt
get-api-key OPENAI_API_KEY          # Retrieve from keychain

# Environment switching
work-mode work               # Switch to work environment
work-mode personal           # Switch to personal environment
work-mode status             # Check current environment

# Synchronization
syncenv                      # Smart sync with git detection
home-sync                    # Legacy sync (auto-commit)

# Git workflow
conventional-commit          # Interactive conventional commit
git-wip                      # Quick WIP commit
git-save-all                 # Create savepoint
git-restore-last-savepoint   # Restore savepoint
git-smart-merge <branch>     # Intelligent merge (rebase/merge detection)

# Performance
zsh-benchmark                # Measure shell startup (10 runs)
zsh-benchmark --detailed     # Function-by-function profiling
zsh-compile                  # Recompile zsh configs to bytecode
zsh-trim-history             # Reduce to 10k entries
```

## Architecture

### Directory Structure
```
~/.dotfiles/
├── install                  # Main installation script
├── LinkingManifest.json     # Source of truth for symlinks
├── bin/                     # Executable scripts (lowercase names)
│   ├── core/               # 25+ general utilities
│   ├── credentials/        # Secure credential management
│   ├── git/                # Git utilities and hooks
│   ├── ide/                # IDE integrations
│   ├── ios/                # iOS development (macOS only)
│   └── macos/              # macOS-specific utilities
├── git/                    # Git configuration (NOT scripts)
│   ├── .gitconfig          # Global config
│   ├── .gitignore_global   # 400+ ignore patterns
│   └── aliases             # Git aliases
├── packages/               # Package manager configs
│   ├── homebrew/           # Brewfile
│   ├── mise/               # Version manager
│   └── syncservice/        # Background sync daemon
├── zsh/                    # Zsh configuration
│   ├── .zshrc              # Main config (optimized)
│   ├── personal-config.zsh # Personal environment
│   ├── work-config.zsh     # Work environment
│   └── lib/lazy-load.zsh   # Lazy loading framework
├── openspec/               # Spec-driven development
│   ├── AGENTS.md           # AI assistant workflow
│   ├── project.md          # Project conventions
│   ├── changes/            # Proposed changes
│   └── specs/              # Implemented capabilities
└── ai_docs/                # AI assistant documentation
```

### Key Design Patterns

**Declarative Symlink Management**
- `LinkingManifest.json` is source of truth
- JSON schema validation
- Platform-specific and optional links
- `link-dotfiles` script applies manifest

**Environment Switching**
- `work-mode` script switches contexts
- Separate config files: `work-config.zsh`, `personal-config.zsh`
- Visual prompt indicators (WORK vs HOME:PERSONAL)
- Zero symlink changes required

**Secure Credential Management**
- Interactive input (no shell history exposure)
- macOS Keychain integration
- Scripts: `store-api-key`, `get-api-key`, `credmatch`, `credfile`
- See `openspec/changes/fix-credential-shell-history-exposure/` for security design

**Performance Optimization**
- Lazy loading for mise, rbenv, nvm, SDKMAN
- Compiled zsh configs (.zwc bytecode)
- 24-hour completion cache
- Optimized history (10k vs 100k default)
- < 500ms cold start (70-80% improvement)

**Spec-Driven Development**
- OpenSpec framework for major changes
- Three-stage workflow: create -> implement -> archive
- Strict validation before implementation
- See `openspec/AGENTS.md` for complete workflow

## Shell Script Standards

### Required Header
```bash
#!/usr/bin/env bash
set -euo pipefail
```

### Quality Requirements
- Zero `shellcheck` errors
- Functions ≤40 lines
- Files ≤400 lines
- Use `getopts` for arguments
- Trap cleanup on EXIT
- Idempotent operations
- Never `eval` untrusted input

### Structure
Large tasks should be broken into separate, composable scripts in dedicated directories.

## Git Workflow

### Commit Format
Use Conventional Commits format:
```
<type>(<scope>): <subject>

<body>

<footer>
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`

Use `conventional-commit` script for interactive guided commits.

### Pre-commit Hooks
Located in `bin/git/hooks/`:
- `check-lowercase-dirs` - Enforce constitutional rule
- `check-no-emojis` - Enforce constitutional rule
- `check-commit-msg` - Validate conventional commit format
- `validate-manifest` - Validate LinkingManifest.json schema
- `validate-openspec` - Validate OpenSpec changes

## Security

### Credential Handling
**NEVER** pass secrets as command-line arguments:
```bash
# WRONG - Exposes in history/process list
store-api-key OPENAI_API_KEY "sk-..."

# CORRECT - Interactive prompt
store-api-key OPENAI_API_KEY

# CORRECT - From stdin
cat secret.txt | store-api-key OPENAI_API_KEY --stdin

# CORRECT - From file
store-api-key OPENAI_API_KEY --from-file ~/.secrets/key
```

### Secret Scanning
All commits scanned for:
- API keys, tokens, passwords
- AWS credentials
- Private keys
- No secrets in code, comments, or history

## Testing Strategy

### Shell Scripts
- Use `shellcheck` for static analysis
- Test scripts in dry-run mode first
- Create test cases for complex utilities
- Example: `tests/test_git_smart_merge.py`

### Python Scripts
- PEP8 compliant
- UV header for external dependencies
- Scripts >500 lines become pip package

### Coverage Requirements
- Domain logic: ≥95% coverage
- Regression tests for every bug (minimum 5 tests)
- Tests must be deterministic and parallelizable

## Common Patterns

### Adding New Utility Script
1. Choose appropriate category under `bin/` (core, git, credentials, etc.)
2. Use lowercase filename (constitutional rule)
3. Add proper header with `set -euo pipefail`
4. Include usage documentation in comments
5. Run `shellcheck` before committing
6. Update `docs/scripts/` documentation if user-facing

### Adding New Symlink
1. Edit `LinkingManifest.json`
2. Validate: `link-dotfiles --dry-run`
3. Apply: `link-dotfiles --apply`
4. Commit both manifest and source file

### Adding New Feature (Major)
1. Create OpenSpec proposal in `openspec/changes/<change-id>/`
2. Write `proposal.md`, `tasks.md`, and spec deltas
3. Validate: `openspec validate <change-id> --strict`
4. Get approval before implementation
5. Implement following `tasks.md`
6. Archive after deployment: `openspec archive <change-id>`

## Documentation References

- `MINDSET.MD` - Constitutional rules and coding standards
- `openspec/AGENTS.md` - OpenSpec workflow for AI assistants
- `README.md` - User-facing documentation
- `docs/scripts/` - Script documentation by category
- `docs/guides/CREDENTIAL_MANAGEMENT.md` - Complete security guide

## Important Notes

- Repository is public - never commit secrets
- All tests must pass before commits
- Warnings are treated as errors
- Breaking changes require OpenSpec proposal
- Maintain backward compatibility when possible
