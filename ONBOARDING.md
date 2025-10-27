# Dotfiles Project - Comprehensive Onboarding

Welcome to the Modern Dotfiles project. This guide will help you understand, set up, and contribute to this repository.

## 1. Project Overview

### Purpose

A production-ready dotfiles management system that provides:
- **Environment Management** - Switch between work/personal configurations seamlessly
- **Secure Credentials** - Encrypted storage with macOS Keychain integration
- **Automated Sync** - Keep dotfiles synchronized across multiple machines
- **Performance Optimization** - Shell startup < 500ms with lazy loading
- **Quality Enforcement** - Pre-commit hooks and CI validation

### Tech Stack

**Primary Languages:**
- **Bash/Shell** (67 scripts) - Core automation and utilities
- **Zsh** - Shell configuration and environment
- **Python 3.11+** - Advanced scripting with uv dependency management
- **JSON/YAML** - Configuration files

**Key Dependencies:**

**Runtime (Required):**
- `git` 2.30+ - Version control
- `jq` - JSON parsing in shell scripts
- `bash` 4.0+ - Script execution
- `zsh` - Interactive shell
- `perl` - Text processing (regex, emoji detection)

**Development (Optional):**
- `shellcheck` - Shell script linting
- `pre-commit` - Git hooks framework
- `openspec` - Spec-driven development tool

**macOS-specific:**
- `brew` - Package management
- macOS Keychain - Credential storage

**Linux-specific:**
- Native package manager (apt, yum, pacman)
- `gnome-keyring` or `kwallet` - Credential storage

### Architecture Pattern

**Declarative + Imperative Hybrid:**
- **Declarative**: `LinkingManifest.json` defines desired symlink state
- **Imperative**: Shell scripts apply and manage configurations
- **Modular**: Small, focused scripts compose larger workflows
- **Idempotent**: Scripts can run multiple times safely

**Key Design Patterns:**
- **Repository Pattern**: Configuration files stored in versioned repo
- **Symlink Management**: Declarative manifest drives symlink creation
- **Lazy Loading**: Heavy tools (mise, nvm, rbenv) load on first use
- **Environment Switching**: Context-aware configuration (work vs personal)

### Key Dependencies and Purposes

| Dependency | Purpose | Required | Platform |
|------------|---------|----------|----------|
| `git` | Version control, sync mechanism | Yes | All |
| `jq` | JSON parsing in scripts | Yes | All |
| `bash` | Script execution | Yes | All |
| `zsh` | Interactive shell | Yes | All |
| `homebrew` | macOS package management | No | macOS |
| `shellcheck` | Shell script validation | No | Dev |
| `pre-commit` | Git hooks framework | No | Dev |
| `perl` | Regex, emoji detection | Yes | All |
| `fzf` | Fuzzy finder (optional) | No | All |
| `ripgrep` | Fast search tool | No | All |

**Version Constraints:**
- Git 2.30+ (for improved security)
- Python 3.11+ (for uv script headers)
- Bash 4.0+ (for associative arrays)
- Zsh 5.8+ (for modern features)

---

## 2. Repository Structure

### Top-Level Directories

```
.
├── bin/                    # 67 executable scripts (organized by category)
├── zsh/                    # Zsh shell configuration
├── git/                    # Git configuration files
├── packages/               # Package manager configurations
├── ai_docs/                # AI assistant documentation
├── openspec/               # Change proposals and specifications
├── docs/                   # User-facing documentation
├── fish/                   # Fish shell config (optional)
├── logs/                   # Runtime logs
├── img/                    # Documentation images
├── .github/                # GitHub workflows and CI
├── .claude/                # Claude AI configuration
├── install                 # Root installation script
└── LinkingManifest.json    # Declarative symlink definitions
```

### bin/ - Executable Scripts (67 files)

**Organizational Pattern:** Scripts organized by function, not technology

```
bin/
├── core/                   # 30 general utilities
│   ├── work-mode          # Environment switching
│   ├── syncenv            # Git-based sync
│   ├── link-dotfiles      # Symlink management
│   ├── zsh-benchmark      # Performance measurement
│   ├── zsh-compile        # Bytecode compilation
│   ├── setup-git-hooks    # Pre-commit setup
│   └── dotfiles-help      # Interactive help system
├── credentials/           # 9 security tools
│   ├── store-api-key      # Secure key storage (interactive)
│   ├── get-api-key        # Key retrieval
│   ├── credfile           # File encryption
│   ├── credmatch          # Credential search
│   └── clear-secret-history  # History sanitization
├── git/                   # 23 git enhancements
│   ├── conventional-commit   # Guided commits
│   ├── git-wip            # Quick WIP saves
│   ├── git-save-all       # Savepoint creation
│   └── hooks/             # Pre-commit hook scripts
│       ├── check-no-emojis
│       ├── check-lowercase-dirs
│       ├── validate-manifest
│       └── validate-openspec
├── macos/                 # 3 macOS tools
│   ├── brew-sync          # Brewfile management
│   └── macos-prefs        # System preferences
└── ide/                   # IDE integration
    └── open-dotfiles-config
```

### zsh/ - Shell Configuration

```
zsh/
├── .zshrc                 # Main configuration (loads others)
├── .zprofile              # Login shell initialization
├── .zpreztorc             # Prezto framework config
├── .p10k.zsh              # Powerlevel10k theme
├── personal-config.zsh    # Personal environment settings
├── work-config.zsh        # Work environment settings
├── lib/
│   └── lazy-load.zsh      # Lazy loading framework
└── completion/            # Custom completions
```

**Performance Optimization:**
- Compiled `.zwc` bytecode files for faster loading
- Lazy loading for heavy tools (mise, nvm, rbenv, SDKMAN)
- 24-hour completion cache
- Reduced history (10k vs 100k entries)

### git/ - Git Configuration

**Unique Pattern:** Configuration stored centrally, scripts in bin/git/

```
git/
├── .gitconfig             # Global git config
├── .gitignore             # Global ignore patterns (symlinked to root)
├── .gitmodules            # Submodule config (symlinked to root)
├── ignore                 # Additional ignore patterns
├── conventional-commits-gitmessage  # Commit template
└── github-flow-aliases.gitconfig    # Git aliases
```

**Why .gitignore in git/ but symlinked to root?**
- Consolidates all git files in one directory (MINDSET Rule 1)
- Git requires .gitignore at repository root
- Solution: Store in git/, symlink to root via LinkingManifest.json

### packages/ - Package Configurations

```
packages/
├── homebrew/
│   └── Brewfile           # macOS package declarations
├── mise/
│   └── config.toml        # Version manager config
├── macos/
│   ├── domains.txt        # Preference domains
│   └── system-preferences.sh
└── syncservice/
    └── config.yml         # Background sync config
```

### openspec/ - Spec-Driven Development

**OpenSpec Framework:** Formal change proposals before implementation

```
openspec/
├── AGENTS.md              # AI assistant instructions
├── project.md             # Project conventions
├── changes/               # Active proposals
│   ├── add-pre-commit-hooks-and-ci/
│   │   ├── proposal.md    # What and why
│   │   ├── tasks.md       # Implementation checklist
│   │   └── specs/         # Requirement specifications
│   └── add-script-documentation/
└── archive/               # Completed changes
```

**Workflow:**
1. Create proposal (problem statement, solution)
2. Write specs (requirements with scenarios)
3. Validate with `openspec validate <id> --strict`
4. Implement tasks
5. Archive after deployment

### docs/ - Documentation

```
docs/
├── scripts/
│   ├── README.md          # Script documentation overview
│   └── quick-reference.md # One-page cheat sheet
└── reports/               # Generated analysis reports
```

### ai_docs/ - AI Assistant Knowledge Base

```
ai_docs/
├── knowledge_base/
│   └── ide/               # IDE-specific AI configs
└── reports/
    ├── code-reviews/      # Automated code reviews
    ├── session-summaries/ # AI session logs
    └── task-summaries/    # Task completion reports
```

### Non-Standard Patterns

1. **git/ Directory Consolidation:**
   - All git files stored in `git/`
   - `.gitignore` and `.gitmodules` symlinked to root
   - Scripts moved to `bin/git/` (executables separate from config)

2. **Lowercase Directory Enforcement (MINDSET Rule 1):**
   - ALL directories must be lowercase
   - No exceptions (enforced by pre-commit hooks)
   - Reason: Cross-platform compatibility, Unix convention

3. **Emoji-Free Codebase (MINDSET Rule 2):**
   - No emojis in any documentation or code
   - Enforced by pre-commit hooks
   - Reason: Accessibility, terminal compatibility, professionalism

4. **Declarative Symlinks:**
   - `LinkingManifest.json` defines all symlinks
   - `bin/core/link-dotfiles` parses and applies
   - Platform-aware, optional links, backup support

5. **Script Organization by Function:**
   - Traditional: scripts/bash/, scripts/python/
   - This project: bin/core/, bin/credentials/, bin/git/
   - Rationale: Find by task, not by implementation language

---

## 3. Getting Started

### Prerequisites

**Required Software:**

**All Platforms:**
- Git 2.30+: `git --version`
- Bash 4.0+: `bash --version`
- jq: `command -v jq`
- Perl: `command -v perl`

**macOS:**
- Xcode Command Line Tools: `xcode-select --version`
- Homebrew (optional): `brew --version`

**Linux:**
- Build essentials: `gcc --version`
- Package manager: apt, yum, or pacman

### Step-by-Step Setup

#### 1. Clone Repository

```bash
# Clone to ~/.dotfiles (or any location)
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Verify structure
ls -la
```

Expected output: `bin/`, `zsh/`, `git/`, `packages/`, `install`, etc.

#### 2. Run Installation (Interactive)

```bash
# Interactive installation (recommended for first time)
./install

# Follow prompts:
# - Confirm Homebrew installation (macOS)
# - Select packages to install
# - Confirm symlink creation
# - Set up environment (work or personal)
```

**Installation Phases:**
1. Prerequisites check
2. Homebrew setup (macOS only)
3. Dependency installation (jq, git, zsh, etc.)
4. Package installation (from Brewfile)
5. Symlink creation (from LinkingManifest.json)
6. Shell configuration
7. Performance optimization (compile configs)

**Expected Duration:** 5-10 minutes

#### 3. Non-Interactive Installation (CI/Automation)

```bash
# Preview without changes
./install --dry-run

# Non-interactive (assume yes to all)
./install --yes

# Skip specific phases
./install --skip-brew --skip-packages

# Verbose output for debugging
./install --verbose
```

#### 4. Apply Shell Configuration

```bash
# Restart shell to apply changes
exec zsh

# Or source directly
source ~/.zshrc

# Verify prompt shows environment
# Should see: HOME:PERSONAL or WORK
```

#### 5. Set Environment Mode

```bash
# For work machines
work-mode work

# For personal machines
work-mode personal

# Check current mode
work-mode status

# Restart shell
exec zsh
```

#### 6. Configure Credentials (Optional)

```bash
# Store API keys securely (interactive, no history exposure)
store-api-key GITHUB_TOKEN
# Enter token when prompted (hidden input)

store-api-key OPENAI_API_KEY
# Enter key when prompted

# Verify stored
get-api-key GITHUB_TOKEN
```

#### 7. Set Up Git Hooks (Optional but Recommended)

```bash
# Install pre-commit hooks
bin/core/setup-git-hooks

# Test hooks
pre-commit run --all-files

# Hooks enforce:
# - Shellcheck validation
# - No emojis (MINDSET Rule 2)
# - Lowercase directories (MINDSET Rule 1)
# - Conventional commit messages
# - LinkingManifest.json validation
# - OpenSpec proposal validation
```

#### 8. Test Installation

```bash
# Measure shell performance
zsh-benchmark
# Target: < 500ms cold start, < 200ms warm

# List available scripts
dotfiles-help

# Test credential retrieval (if configured)
get-api-key GITHUB_TOKEN

# Check sync status (if using sync)
syncenv --status

# Verify symlinks
link-dotfiles --dry-run
```

### Common Setup Issues

#### Issue 1: "jq: command not found"

**Cause:** jq not installed

**Fix:**
```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq

# CentOS/RHEL
sudo yum install jq
```

#### Issue 2: "Permission denied" on ./install

**Cause:** Install script not executable

**Fix:**
```bash
chmod +x install
./install
```

#### Issue 3: Shell startup is slow (> 1 second)

**Cause:** Configs not compiled or lazy loading not enabled

**Fix:**
```bash
# Compile all zsh configs to bytecode
zsh-compile

# Verify lazy loading enabled
grep "lazy-load" ~/.zshrc

# Measure performance
zsh-benchmark --detailed
```

#### Issue 4: Symlinks not created

**Cause:** LinkingManifest.json not parsed or permission issues

**Fix:**
```bash
# Test dry-run
bin/core/link-dotfiles --dry-run

# Check for errors
bin/core/link-dotfiles --apply --verbose

# Verify manifest syntax
jq empty LinkingManifest.json
```

#### Issue 5: "openspec: command not found"

**Cause:** OpenSpec CLI not installed (optional)

**Note:** OpenSpec is optional for normal usage, only needed for creating proposals

**Fix (if needed):**
```bash
# Install via pipx (recommended)
pipx install openspec

# Or via pip
pip install --user openspec

# Verify
openspec --version
```

---

## 4. Key Components

### Entry Points

#### 1. ./install - Root Installation Script

**Path:** `/install`
**Purpose:** One-command setup for new machines
**Language:** Bash
**Lines:** 469

**Key Functions:**
- `check_prerequisites()` - Validates required software
- `install_homebrew()` - Sets up Homebrew (macOS)
- `install_dependencies()` - Installs jq, git, zsh
- `install_packages()` - Processes Brewfile
- `create_symlinks()` - Calls link-dotfiles
- `configure_shell()` - Sets zsh as default
- `optimize_performance()` - Compiles configs

**Usage:**
```bash
./install               # Interactive
./install --dry-run     # Preview
./install --yes         # Non-interactive
./install --help        # Show options
```

**Exit Codes:**
- 0: Success
- 1: General error
- 2: Prerequisites not met
- 3: User cancelled

#### 2. bin/core/link-dotfiles - Symlink Manager

**Path:** `bin/core/link-dotfiles`
**Purpose:** Parse LinkingManifest.json and create symlinks
**Language:** Bash
**Lines:** 400+

**Key Functions:**
- `parse_manifest()` - Reads JSON with jq
- `create_link()` - Creates individual symlink
- `backup_existing()` - Backs up before overwriting
- `validate_source()` - Checks source files exist
- `filter_platform()` - Applies platform-specific links

**Symlink Types:**
- `file` - Single file symlink
- `directory` - Directory symlink
- `directory-contents` - Symlink each file in directory

**Usage:**
```bash
link-dotfiles --dry-run      # Preview
link-dotfiles --apply        # Create symlinks
link-dotfiles --backup       # Backup existing files first
link-dotfiles --force        # Overwrite without confirmation
```

#### 3. ~/.zshrc - Shell Entry Point

**Path:** `zsh/.zshrc`
**Purpose:** Main zsh configuration
**Language:** Zsh
**Lines:** ~200 (optimized)

**Loading Order:**
1. PATH initialization
2. Prezto framework
3. Powerlevel10k theme
4. Lazy-load library
5. Environment-specific config (work or personal)
6. FZF integration (background)
7. Aliases and functions

**Performance Optimizations:**
- Single compinit call (was 3x)
- 24-hour completion cache
- Lazy loading for mise, nvm, rbenv, SDKMAN
- Background operations for FZF
- Compiled to .zwc bytecode

### Core Business Logic

#### 1. Environment Switching (bin/core/work-mode)

**Purpose:** Toggle between work and personal configurations

**State Management:**
- State file: `~/.work_mode` (contains "work" or "personal")
- Config files:
  - `zsh/work-config.zsh` - Work-specific settings
  - `zsh/personal-config.zsh` - Personal settings
- Loaded conditionally in .zshrc

**Workflow:**
```bash
# User runs
work-mode work

# Script writes "work" to ~/.work_mode
# Prompt changes to WORK (orange)
# work-config.zsh loaded on next shell start

# User runs
work-mode personal

# Script writes "personal" to ~/.work_mode
# Prompt changes to HOME:PERSONAL (blue)
# personal-config.zsh loaded on next shell start
```

**Use Cases:**
- Work machine: `work-mode work` loads work credentials, paths, aliases
- Personal machine: `work-mode personal` loads personal settings
- Shared machine: Switch contexts as needed

#### 2. Credential Management (bin/credentials/)

**Architecture:**
- **Storage**: macOS Keychain (encrypted by OS)
- **CLI Tools**: `security` command (macOS) or `secret-tool` (Linux)
- **Scripts**: Wrappers for secure input/output

**Key Scripts:**

**store-api-key (v2.0 - Security Hardened):**
```bash
# SECURE: Interactive mode (no history)
store-api-key OPENAI_API_KEY
# Prompts for value (hidden input)

# SECURE: Stdin mode
echo "secret" | store-api-key KEY --stdin

# SECURE: File mode
store-api-key KEY --from-file ~/.secrets/key

# INSECURE (deprecated): Positional args
store-api-key KEY "value"  # Shows in history!
```

**get-api-key:**
```bash
# Retrieve from Keychain
get-api-key OPENAI_API_KEY
# Returns: sk-...

# Use in scripts
export OPENAI_API_KEY="$(get-api-key OPENAI_API_KEY)"
```

**credmatch:**
```bash
# List all credentials
credmatch list

# Search by pattern
credmatch search github

# Store encrypted
credmatch store "PASSWORD" "KEY" "value"

# Fetch decrypted
credmatch fetch "PASSWORD" "KEY"
```

**Security Model:**
- Master password stored in Keychain
- Credentials encrypted with AES-256-CBC
- No plaintext storage
- Shell history protection (interactive mode)
- Audit trail via `clear-secret-history`

#### 3. Sync Mechanism (bin/core/syncenv)

**Purpose:** Keep dotfiles synchronized across machines

**Strategy:** Git-based with smart conflict resolution

**Workflow:**
```bash
# Push local changes
syncenv

# Script:
1. Checks for uncommitted changes
2. Auto-commits with timestamp
3. Pulls remote changes
4. Handles conflicts intelligently
5. Pushes local commits
6. Reports status
```

**Conflict Resolution:**
- Favors local changes
- Backs up conflicting remote versions
- Never loses data
- Manual resolution if needed

**Alternative:** `home-sync` service for background sync

### Configuration Management

#### LinkingManifest.json

**Purpose:** Declarative symlink definitions

**Schema:**
```json
{
  "version": "1.0.0",
  "links": {
    "shell": {
      "zsh": [
        {
          "source": "zsh/.zshrc",
          "target": "~/.zshrc",
          "description": "Zsh main configuration",
          "type": "file",
          "platform": ["darwin", "linux"],
          "optional": false
        }
      ]
    },
    "git": [...],
    "packages": [...]
  }
}
```

**Fields:**
- `source` (required): Path relative to repo root
- `target` (required): Destination path (~ expands to $HOME)
- `description` (optional): Human-readable description
- `type` (optional): "file", "directory", "directory-contents" (default: "file")
- `platform` (optional): ["darwin", "linux"] filter
- `optional` (optional): Skip if source missing (default: false)

**Benefits:**
- Single source of truth for symlinks
- Self-documenting (descriptions)
- Platform-aware
- Version controlled
- Validated by pre-commit hooks

### Authentication and Authorization

**Not Applicable** - This is a local development environment tool.

**Security Considerations:**
- Credentials stored in OS-level Keychain (encrypted)
- Master passwords never in plaintext
- Shell history protection for secrets
- Pre-commit hooks scan for exposed secrets
- Private repository recommended

### External Services Integration

**GitHub:**
- Repository hosting
- CI/CD via GitHub Actions
- Issue tracking
- Pull requests

**Homebrew:**
- Package installation (macOS)
- Brewfile for declarative packages

**OpenSpec:**
- Optional CLI for spec-driven development
- Validates proposals before implementation

**No runtime external services** - Works offline after initial setup.

---

## 5. Development Workflow

### Git Branch Naming Conventions

**Format:** `<type>/<short-description>`

**Types:**
- `feat/` - New features
- `fix/` - Bug fixes
- `chore/` - Maintenance
- `docs/` - Documentation only
- `refactor/` - Code restructuring
- `perf/` - Performance improvements
- `test/` - Test additions/fixes

**Examples:**
```bash
git checkout -b feat/add-fish-shell-support
git checkout -b fix/symlink-creation-permissions
git checkout -b chore/update-homebrew-deps
git checkout -b docs/improve-onboarding-guide
```

### Commit Message Format

**Required:** Conventional Commits specification

**Format:**
```
<type>(<scope>): <description>

[optional body]

[optional footer]

Co-authored-by: factory-droid[bot] <138933559+factory-droid[bot]@users.noreply.github.com>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting, no code change
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance
- `perf`: Performance improvement
- `ci`: CI/CD changes
- `build`: Build system changes
- `revert`: Revert previous commit

**Scope (optional):** Component affected (install, symlinks, credentials, docs)

**Examples:**
```bash
feat: add fish shell configuration support

fix(install): handle missing jq dependency gracefully

docs: update ONBOARDING.md with troubleshooting section

chore(deps): update Homebrew formulas

Co-authored-by: factory-droid[bot] <138933559+factory-droid[bot]@users.noreply.github.com>
```

**Enforcement:**
- Pre-commit hook validates format
- CI blocks PRs with invalid messages
- Use `bin/git/conventional-commit` for guided commits

### Starting a New Feature

**Step-by-Step:**

#### 1. Create OpenSpec Proposal (for significant changes)

```bash
# Check existing proposals
openspec list

# Create new proposal directory
mkdir -p openspec/changes/add-fish-shell-support

# Create proposal files
cd openspec/changes/add-fish-shell-support
touch proposal.md tasks.md
mkdir -p specs/shell-configuration

# Write proposal (see AGENTS.md for format)
# Write tasks checklist
# Write specs with requirements and scenarios

# Validate before proceeding
openspec validate add-fish-shell-support --strict
```

#### 2. Create Feature Branch

```bash
# From main branch
git checkout main
git pull origin main

# Create and switch to feature branch
git checkout -b feat/add-fish-shell-support

# Verify
git branch --show-current
```

#### 3. Implement Changes

```bash
# Create fish configuration
mkdir -p fish/conf.d
touch fish/conf.d/config.fish

# Update LinkingManifest.json
jq '.links.shell.fish = [...]' LinkingManifest.json > tmp.json
mv tmp.json LinkingManifest.json

# Create installation logic in install script
# Add fish to package dependencies

# Test changes
./install --dry-run
```

#### 4. Write Tests

```bash
# For shell scripts: Add shellcheck validation
shellcheck fish/conf.d/config.fish

# For installation: Test on clean system or VM
# For symlinks: Test link-dotfiles --dry-run

# Manual testing checklist:
# [ ] Fresh installation works
# [ ] Symlinks created correctly
# [ ] Fish shell loads without errors
# [ ] Can switch between zsh and fish
```

#### 5. Commit Changes

```bash
# Stage changes
git add fish/ LinkingManifest.json install

# Commit with conventional format
git commit -m "feat: add fish shell configuration support

Adds basic fish shell support with:
- Configuration directory structure
- Symlink definitions in manifest
- Installation integration

Co-authored-by: factory-droid[bot] <138933559+factory-droid[bot]@users.noreply.github.com>"

# Or use guided commit
bin/git/conventional-commit
```

### Testing Requirements

#### Unit Tests

**Shell Scripts:**
```bash
# Use shellcheck for static analysis
shellcheck bin/core/link-dotfiles

# Test individual functions in isolation
# (Add BATS framework for formal unit tests if needed)
```

#### Integration Tests

```bash
# Test full installation flow
./install --dry-run

# Test symlink creation
bin/core/link-dotfiles --dry-run

# Test credential storage
store-api-key TEST_KEY
get-api-key TEST_KEY
```

#### Manual Testing Checklist

**For New Scripts:**
- [ ] --help flag works
- [ ] Passes shellcheck with no errors
- [ ] Handles missing dependencies gracefully
- [ ] Idempotent (can run multiple times)
- [ ] Error messages are clear
- [ ] Exit codes are correct

**For Configuration Changes:**
- [ ] Shell starts without errors
- [ ] Prompt displays correctly
- [ ] Aliases work
- [ ] Functions work
- [ ] Performance < 500ms

**For Installation Changes:**
- [ ] Works on clean machine
- [ ] Handles existing dotfiles
- [ ] Can resume after interruption
- [ ] Rollback works on failure

### Code Style and Linting

#### Shell Scripts (REQUIRED)

**Shellcheck Compliance:**
```bash
# All shell scripts MUST pass shellcheck
shellcheck --severity=error script.sh

# Run on all scripts
find bin/ -type f -name "*.sh" -o -name "*.bash" | \
  xargs shellcheck --severity=error

# Common fixes:
# - Quote variables: "$var" not $var
# - Use [[ ]] not [ ]
# - Declare functions: func() { ... }
# - Handle errors: set -euo pipefail
```

**Style Guidelines:**
- Use `set -euo pipefail` for safety
- Quote all variables: `"$var"`
- Use `[[  ]]` for conditionals (not `[ ]`)
- Prefer `$(command)` over backticks
- Use `readonly` for constants
- Add comments for complex logic
- Include usage() function with --help

**Example:**
```bash
#!/usr/bin/env bash
#
# script-name - Brief description
#

set -euo pipefail

# Constants
readonly VERSION="1.0.0"
readonly CONFIG_FILE="${HOME}/.config"

usage() {
    cat << EOF
script-name - Brief description

USAGE:
    script-name [OPTIONS]

OPTIONS:
    --help    Show this help
EOF
}

main() {
    local arg="${1:-}"

    if [[ "$arg" == "--help" ]]; then
        usage
        exit 0
    fi

    # Script logic here
}

main "$@"
```

#### Python Scripts (REQUIRED)

**PEP 8 Compliance:**
```bash
# Check with flake8 or ruff
flake8 script.py
ruff check script.py

# Format with black
black script.py
```

**UV Script Headers (REQUIRED):**
```python
#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "requests",
#     "pyyaml",
# ]
# ///

import requests

def main():
    # Script logic
    pass

if __name__ == "__main__":
    main()
```

**Guidelines:**
- Scripts < 500 lines: Single file with UV header
- Scripts > 500 lines: Convert to pip package
- Use type hints
- Add docstrings
- Follow PEP 8

#### Markdown/Documentation

**Style:**
- No emojis (MINDSET Rule 2)
- Clear headings structure
- Code blocks with language identifiers
- Link to relevant sections
- Examples for all commands

**Linting:**
```bash
# Check markdown links
markdown-link-check README.md

# Validate in CI
.github/workflows/ci.yml runs link checks
```

### Pull Request Process

#### 1. Prepare PR

```bash
# Update from main
git checkout main
git pull origin main

# Rebase feature branch
git checkout feat/add-fish-shell-support
git rebase main

# Push feature branch
git push -u origin feat/add-fish-shell-support
```

#### 2. Create PR

**Via GitHub CLI:**
```bash
gh pr create \
  --title "feat: add fish shell configuration support" \
  --body "$(cat <<EOF
## Description
Adds basic fish shell support to the dotfiles system.

## Changes
- Added fish configuration directory structure
- Updated LinkingManifest.json with fish symlinks
- Integrated fish installation in install script

## Testing
- [x] Fresh installation works
- [x] Symlinks created correctly
- [x] Fish shell loads without errors
- [x] Shellcheck passes
- [x] CI passes

## OpenSpec
- Proposal: openspec/changes/add-fish-shell-support/
- Validation: passed

## Breaking Changes
None

## Related Issues
Closes #42
EOF
)"
```

**Via GitHub Web:**
- Navigate to repository
- Click "Pull requests" → "New pull request"
- Select base: `main`, compare: `feat/add-fish-shell-support`
- Fill in template
- Click "Create pull request"

#### 3. PR Checks (Automated)

**CI Runs:**
- Shellcheck on all scripts
- Pre-commit hooks (emojis, lowercase, commits)
- Installation test (dry-run)
- Documentation link validation
- OpenSpec validation

**Required Reviews:**
- 1 approval minimum
- All checks must pass

#### 4. Address Feedback

```bash
# Make requested changes
vim bin/core/some-script

# Commit updates
git add bin/core/some-script
git commit -m "fix: address PR feedback on error handling"

# Push updates
git push
```

#### 5. Merge

**Options:**
- **Squash and merge** (preferred for feature branches)
- **Rebase and merge** (for clean linear history)
- **Merge commit** (for releases)

**After Merge:**
```bash
# Delete feature branch
git branch -d feat/add-fish-shell-support
git push origin --delete feat/add-fish-shell-support

# Update main
git checkout main
git pull origin main
```

### CI/CD Pipeline

**GitHub Actions Workflow:** `.github/workflows/ci.yml`

**Stages:**

**1. Validate (runs on all PRs and pushes):**
- Shellcheck all scripts (errors only)
- Check for emojis (MINDSET Rule 2)
- Check for uppercase directories (MINDSET Rule 1)
- Validate LinkingManifest.json syntax
- Validate OpenSpec proposals
- Check markdown links

**2. Test macOS:**
- Run installation (dry-run)
- Test link-dotfiles
- Test script help messages
- Verify shell startup

**3. Test Linux:**
- Run installation (dry-run)
- Test link-dotfiles
- Verify dependencies

**4. Documentation:**
- Check for broken markdown links
- Validate required docs present
- Scan for TODO/FIXME comments

**Triggers:**
- Push to main, develop
- Pull requests to main, develop
- Manual workflow dispatch

**Status Checks:**
- All checks must pass before merge
- PR cannot be merged if CI fails

### Release Strategy

**Versioning:** Semantic Versioning (SemVer)
- `MAJOR.MINOR.PATCH`
- `1.0.0`, `1.1.0`, `1.1.1`, `2.0.0`

**Release Process:**

1. **Update Version**
```bash
# Update install script version
vim install
# Change: readonly VERSION="1.1.0"

# Commit
git commit -am "chore: bump version to 1.1.0"
```

2. **Create Tag**
```bash
# Annotated tag with changelog
git tag -a v1.1.0 -m "Release v1.1.0

Changes:
- feat: Add fish shell support
- fix: Symlink creation permissions
- docs: Improve onboarding guide
"

# Push tag
git push origin v1.1.0
```

3. **Create GitHub Release**
```bash
# Via GitHub CLI
gh release create v1.1.0 \
  --title "v1.1.0" \
  --notes "See CHANGELOG.md for details"

# Or via GitHub web UI
```

4. **Update CHANGELOG.md**
```markdown
## [1.1.0] - 2024-01-15

### Added
- Fish shell configuration support
- Interactive dotfiles-help command

### Fixed
- Symlink creation permission handling
- Shell history secret exposure

### Changed
- Improved error messages in install script
```

**Release Cadence:**
- **Major**: Breaking changes (rare, coordinated)
- **Minor**: New features (monthly)
- **Patch**: Bug fixes (as needed)

---

## 6. Architecture Decisions

### Design Patterns

#### 1. Repository Pattern for Configuration

**Decision:** Store all configurations in versioned Git repository

**Rationale:**
- Version control for dotfiles
- Sync across machines via Git
- History and rollback capability
- Collaboration via pull requests

**Implementation:**
- All configs in `~/.dotfiles` (or similar)
- Symlinks from home directory to repo
- LinkingManifest.json declares mappings

**Trade-offs:**
- Pro: Full history, easy sync
- Con: Large binary files (if any) bloat repo
- Mitigation: Use .gitignore for generated files

#### 2. Declarative Symlink Management

**Decision:** JSON manifest defines all symlinks, script applies them

**Rationale:**
- Single source of truth
- Self-documenting
- Platform-aware
- Testable (dry-run mode)

**Implementation:**
- `LinkingManifest.json` with schema
- `bin/core/link-dotfiles` parses and creates
- Validation via jq and pre-commit hooks

**Alternative Considered:** Imperative scripts (install.sh creates symlinks)
- Rejected: Hard to maintain, no documentation, error-prone

#### 3. Lazy Loading Framework

**Decision:** Defer loading of heavy tools until first use

**Rationale:**
- Shell startup < 500ms target
- Most tools not needed immediately
- Transparent to user

**Implementation:**
- `zsh/lib/lazy-load.zsh` provides framework
- Stub functions check if tool needed
- Load on first invocation
- Applied to: mise, nvm, rbenv, SDKMAN

**Example:**
```zsh
# Traditional (slow):
eval "$(mise activate zsh)"  # 200-300ms

# Lazy loading (fast):
mise() {
    unfunction mise
    eval "$(command mise activate zsh)"
    mise "$@"
}
# 0ms until mise command actually run
```

**Performance Gain:** 400-850ms per startup

#### 4. Environment Context Switching

**Decision:** Single config repo supports multiple environments via flag

**Rationale:**
- Work and personal use same base config
- Context-specific settings loaded conditionally
- Avoid maintaining separate repos

**Implementation:**
- `~/.work_mode` file stores state ("work" or "personal")
- `zsh/.zshrc` checks state and loads appropriate config
- `work-config.zsh` vs `personal-config.zsh`

**Alternative Considered:** Separate repos for work/personal
- Rejected: Duplicate configs, harder to keep in sync

### State Management

**Shell State:**
- Managed by zsh framework (Prezto)
- Environment variables in .zprofile
- Aliases/functions in .zshrc
- No persistent state (except ~/.work_mode)

**Script State:**
- Generally stateless (idempotent)
- Temp files in /tmp (cleaned on exit)
- Logs in `logs/` (optional)

**Configuration State:**
- Files: Plain text (zsh, bash, gitconfig)
- Compiled: .zwc bytecode for performance
- Symlinks: Declared in manifest, actual links in filesystem

### Error Handling Strategy

**Shell Scripts:**

**Fail-Fast Approach:**
```bash
set -euo pipefail
# -e: Exit on error
# -u: Exit on undefined variable
# -o pipefail: Exit on pipe failure
```

**Explicit Error Checking:**
```bash
if ! command -v jq &>/dev/null; then
    log_error "jq is required but not installed"
    exit 1
fi
```

**Graceful Degradation:**
```bash
# Optional features degrade gracefully
if command -v fzf &>/dev/null; then
    # Use fzf
else
    # Fall back to basic selection
fi
```

**User-Friendly Messages:**
```bash
log_error "Failed to create symlink: $target"
log_info "Run 'link-dotfiles --verbose' for details"
```

**Exit Codes:**
- 0: Success
- 1: General error
- 2: Prerequisites not met
- 3: User cancelled
- 4: Configuration error

### Logging and Monitoring

**Logging Strategy:**

**Console Output:**
- Color-coded by severity (red=error, yellow=warning, blue=info, green=success)
- Structured format: `[LEVEL] message`
- Progress indicators for long operations

**File Logging:**
- Optional: `logs/` directory for verbose output
- Install log: `logs/install.log`
- Sync log: `logs/sync.log`
- Rotated manually (not automated)

**No Telemetry:**
- No external monitoring
- No usage tracking
- Fully local

**Debugging:**
```bash
# Verbose output
./install --verbose

# Dry-run to preview
./install --dry-run

# Shell script debugging
bash -x bin/core/some-script

# Zsh profiling
zsh -xv 2>&1 | tee zsh-debug.log
```

### Security Measures

#### 1. Credential Storage

**Mechanism:** OS-level encrypted storage
- macOS: Keychain (encrypted by FileVault)
- Linux: gnome-keyring or kwallet

**Access Control:**
- Requires user login password
- Per-user isolation
- No plaintext storage

**Audit:**
```bash
# List stored credentials
security dump-keychain | grep dotfiles

# Remove specific credential
security delete-generic-password -s "dotfiles-OPENAI_API_KEY"
```

#### 2. Shell History Protection

**Problem:** Secrets exposed in history via positional args

**Solution:** Interactive input only
```bash
# INSECURE (deprecated)
store-api-key KEY "secret"  # Shows in history!

# SECURE (enforced)
store-api-key KEY  # Prompts for value (hidden)
```

**Cleanup:**
```bash
# Remove exposed secrets from history
clear-secret-history

# Scans ~/.zsh_history for patterns
# Removes lines with store-api-key + positional args
# Backs up before modifying
```

#### 3. Pre-commit Secret Scanning

**Hooks Check:**
- .env files for plaintext secrets
- Scripts for hardcoded credentials
- Commit messages for accidentally included secrets

**Block Commit If:**
- API keys detected (pattern: `sk-...`, `ghp_...`)
- Passwords in plaintext
- Private keys (.pem, .key files)

#### 4. Repository Security

**Recommendations:**
- Keep repository private
- Use SSH keys for GitHub (not HTTPS passwords)
- Enable 2FA on GitHub
- Rotate credentials regularly
- Use different credentials per environment (dev/staging/prod)

**Gitignore Patterns:**
```gitignore
# Secrets
.env
.env.local
*.key
*.pem
secrets/

# Credentials
.credentials
.secrets
```

### Performance Optimizations

#### 1. Shell Startup Performance

**Target:** < 500ms cold start, < 200ms warm

**Optimizations:**

**Compiled Configs (.zwc):**
```bash
# Compile all zsh files
zsh-compile

# Creates .zwc bytecode files
# 20-50% faster loading
```

**Lazy Loading:**
- Defer mise, nvm, rbenv, SDKMAN until used
- Save 400-850ms per startup

**Completion Caching:**
```zsh
# Cache for 24 hours
zstyle ':completion:*' cache-path ~/.zcompcache
zstyle ':completion:*' use-cache yes

# Refresh daily
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qNmh+24) ]]; then
    compinit
else
    compinit -C
fi
```

**Reduced History:**
- 10k entries (vs 100k default)
- Faster history searches
- Less disk I/O

**Single compinit Call:**
- Was: Called 3 times (prezto, plugins, manual)
- Now: Called once with cache
- Save: 50-100ms

**Background Operations:**
```zsh
# Load FZF in background (non-blocking)
(source <(fzf --zsh) &)
```

**Measurement:**
```bash
# Quick benchmark (10 runs)
zsh-benchmark
# Output: Average: 450ms, Min: 420ms, Max: 480ms

# Detailed profiling
zsh-benchmark --detailed
# Shows function-by-function timing
```

#### 2. Script Performance

**Caching:**
```bash
# Cache expensive operations
if [[ ! -f /tmp/package-list.cache ]] || \
   [[ $(find /tmp/package-list.cache -mtime +1) ]]; then
    brew list > /tmp/package-list.cache
fi
```

**Parallel Execution:**
```bash
# Run independent tasks in parallel
task1 &
task2 &
wait
```

**Avoid Subshells:**
```bash
# Slow (subshell)
count=$(grep -c pattern file)

# Fast (built-in)
count=0
while IFS= read -r line; do
    ((count++))
done < <(grep pattern file)
```

#### 3. Git Operations

**Shallow Clones:**
```bash
# Don't need full history
git clone --depth 1 https://...
```

**Sparse Checkout:**
```bash
# Only checkout needed directories
git sparse-checkout set bin/ zsh/
```

---

## 7. Common Tasks

### Adding a New Script

**Step-by-Step:**

#### 1. Choose Category and Name

```bash
# Determine category
# - bin/core/ : General utilities
# - bin/credentials/ : Security-related
# - bin/git/ : Git enhancements
# - bin/macos/ : macOS-specific
# - bin/ide/ : IDE integration

# Choose descriptive name (verb-led)
# Examples: backup-configs, list-dependencies, sync-credentials
```

#### 2. Create Script File

```bash
# Create file
touch bin/core/new-script-name

# Make executable
chmod +x bin/core/new-script-name
```

#### 3. Add Script Template

```bash
#!/usr/bin/env bash
#
# new-script-name - Brief description
#
# Category: core
# Platform: darwin, linux (or darwin only, linux only)

set -euo pipefail

usage() {
    cat << EOF
new-script-name - Brief description

USAGE:
    new-script-name [OPTIONS] [ARGUMENTS]

OPTIONS:
    --flag          Description
    --help, -h      Show this help

EXAMPLES:
    # Example 1
    new-script-name --flag value

    # Example 2
    new-script-name argument

REQUIREMENTS:
    - dependency1
    - dependency2

PLATFORM: darwin | linux | all

SEE ALSO:
    related-script1, related-script2
EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h)
            usage
            exit 0
            ;;
        --flag)
            FLAG_VALUE="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Main logic here
main() {
    echo "Script logic goes here"
}

main "$@"
```

#### 4. Test Script

```bash
# Test help
bin/core/new-script-name --help

# Test shellcheck
shellcheck bin/core/new-script-name

# Test functionality
bin/core/new-script-name --flag test

# Test error handling
bin/core/new-script-name --invalid-flag
```

#### 5. Verify Discovery

```bash
# Check interactive help finds it
dotfiles-help
# Navigate to category, verify script appears

# Check direct help
dotfiles-help new-script-name
```

#### 6. Commit

```bash
git add bin/core/new-script-name
git commit -m "feat(core): add new-script-name utility

Adds utility to [brief description of functionality].

Usage: new-script-name [options]

Co-authored-by: factory-droid[bot] <138933559+factory-droid[bot]@users.noreply.github.com>"
```

### Adding a Configuration File

**Example: Add new shell configuration**

#### 1. Create Config File

```bash
# Create file in appropriate directory
touch zsh/my-custom-config.zsh
```

#### 2. Write Configuration

```zsh
# my-custom-config.zsh
# Custom shell configuration

# Aliases
alias myalias='command'

# Functions
myfunction() {
    echo "My function"
}

# Environment variables
export MY_VAR="value"
```

#### 3. Source in Main Config

```bash
# Add to zsh/.zshrc
source "${ZDOTDIR:-$HOME}/.config/zsh/my-custom-config.zsh"
```

#### 4. Add Symlink to Manifest (if needed)

```bash
# Edit LinkingManifest.json
jq '.links.shell.zsh += [{
    "source": "zsh/my-custom-config.zsh",
    "target": "~/.config/zsh/my-custom-config.zsh",
    "description": "My custom configuration"
}]' LinkingManifest.json > tmp.json && mv tmp.json LinkingManifest.json
```

#### 5. Test

```bash
# Validate manifest
jq empty LinkingManifest.json

# Test linking
bin/core/link-dotfiles --dry-run

# Source and test
source zsh/my-custom-config.zsh
myfunction
```

### Writing a Test

**For Shell Scripts: Use Shellcheck**

```bash
# Create test script
cat > tests/test-new-script.sh << 'EOF'
#!/usr/bin/env bash

# Test suite for new-script-name

set -euo pipefail

# Test 1: Help flag works
test_help() {
    if bin/core/new-script-name --help &>/dev/null; then
        echo "PASS: Help flag works"
    else
        echo "FAIL: Help flag broken"
        return 1
    fi
}

# Test 2: Script is executable
test_executable() {
    if [[ -x bin/core/new-script-name ]]; then
        echo "PASS: Script is executable"
    else
        echo "FAIL: Script not executable"
        return 1
    fi
}

# Test 3: Shellcheck passes
test_shellcheck() {
    if shellcheck bin/core/new-script-name; then
        echo "PASS: Shellcheck passes"
    else
        echo "FAIL: Shellcheck errors"
        return 1
    fi
}

# Run all tests
main() {
    test_help || exit 1
    test_executable || exit 1
    test_shellcheck || exit 1
    echo "All tests passed"
}

main "$@"
EOF

chmod +x tests/test-new-script.sh

# Run tests
tests/test-new-script.sh
```

**For Complex Testing: Consider BATS Framework**

```bash
# Install BATS
brew install bats-core  # macOS
# or
git clone https://github.com/bats-core/bats-core.git

# Create BATS test file
cat > tests/test-new-script.bats << 'EOF'
#!/usr/bin/env bats

@test "help flag displays usage" {
    run bin/core/new-script-name --help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "USAGE" ]]
}

@test "invalid flag shows error" {
    run bin/core/new-script-name --invalid
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Unknown option" ]]
}

@test "script passes shellcheck" {
    run shellcheck bin/core/new-script-name
    [ "$status" -eq 0 ]
}
EOF

# Run BATS tests
bats tests/test-new-script.bats
```

### Debugging Common Runtime Errors

#### Error: "jq: command not found"

**Symptom:**
```
./install: line 45: jq: command not found
```

**Cause:** jq not installed

**Debug:**
```bash
# Check if jq exists
command -v jq || echo "jq not found"

# Check PATH
echo $PATH

# Check install location
which jq 2>/dev/null || echo "Not in PATH"
```

**Fix:**
```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq

# CentOS/RHEL
sudo yum install jq

# Verify
jq --version
```

#### Error: "Permission denied" on symlink creation

**Symptom:**
```
ln: ~/.zshrc: Permission denied
```

**Cause:** Target already exists or parent directory not writable

**Debug:**
```bash
# Check if target exists
ls -la ~/.zshrc

# Check parent directory permissions
ls -lad ~

# Check if symlink already exists
readlink ~/.zshrc
```

**Fix:**
```bash
# Backup existing file
cp ~/.zshrc ~/.zshrc.backup

# Remove existing (if not important)
rm ~/.zshrc

# Retry symlink creation
bin/core/link-dotfiles --apply

# Or use --backup flag
bin/core/link-dotfiles --apply --backup
```

#### Error: Shell startup is slow (> 1s)

**Symptom:** Shell takes 2-3 seconds to start

**Debug:**
```bash
# Measure startup
zsh-benchmark

# Detailed profiling
zsh-benchmark --detailed

# Check if configs compiled
ls -la ~/.zshrc.zwc

# Check lazy loading enabled
grep "lazy-load" ~/.zshrc
```

**Fix:**
```bash
# Compile configs
zsh-compile

# Enable lazy loading (should be default)
# Edit zsh/.zshrc to include:
# source "${ZDOTDIR:-$HOME}/.config/zsh/lib/lazy-load.zsh"

# Trim history
zsh-trim-history

# Verify improvement
zsh-benchmark
```

### Updating Dependencies

#### Update Homebrew Packages

```bash
# Update Homebrew itself
brew update

# Update all packages
brew upgrade

# Update specific package
brew upgrade git

# Check outdated
brew outdated

# Generate new Brewfile
brew bundle dump --file=packages/homebrew/Brewfile --force

# Commit changes
git add packages/homebrew/Brewfile
git commit -m "chore(deps): update Homebrew packages"
```

#### Update Git Submodules

```bash
# Update all submodules
git submodule update --remote

# Update specific submodule
git submodule update --remote path/to/submodule

# Commit updates
git add .gitmodules path/to/submodule
git commit -m "chore(deps): update git submodules"
```

#### Update Shell Framework (Prezto)

```bash
# Navigate to Prezto directory
cd ~/.zprezto

# Pull latest changes
git pull origin master

# Return to dotfiles
cd ~/.dotfiles

# Test shell startup
zsh

# If working, commit submodule update
git add .zprezto
git commit -m "chore(deps): update Prezto framework"
```

---

## 8. Potential Gotchas

### Hidden Configurations

#### 1. ~/.work_mode File

**What:** Hidden state file controlling environment mode

**Location:** `~/.work_mode`

**Content:** Single word: "work" or "personal"

**Impact:** Determines which config loaded (.zshrc checks this)

**Gotcha:** If file missing or corrupted, defaults to personal mode

**Fix:**
```bash
# Check current state
cat ~/.work_mode

# Set explicitly
echo "work" > ~/.work_mode  # or "personal"

# Or use script
work-mode work
```

#### 2. Compiled .zwc Files

**What:** Bytecode compiled from .zsh files for faster loading

**Location:** Next to .zsh files (e.g., `.zshrc.zwc`)

**Impact:** If .zwc is outdated, changes to .zsh won't take effect

**Gotcha:** Editing .zshrc doesn't update .zshrc.zwc automatically

**Fix:**
```bash
# Remove all .zwc files
find ~/.config/zsh -name "*.zwc" -delete

# Recompile
zsh-compile

# Or source .zshrc to auto-recompile
source ~/.zshrc
```

#### 3. LinkingManifest.json Platform Filters

**What:** Symlinks can be platform-specific

**Location:** `LinkingManifest.json` `"platform": ["darwin"]`

**Impact:** Some configs only linked on macOS or Linux

**Gotcha:** Missing symlinks on one platform, present on another

**Fix:**
```bash
# Check platform
uname -s

# Preview what will be linked
bin/core/link-dotfiles --dry-run

# Verify platform filters in manifest
jq '.links[][] | select(.platform) | {source, platform}' LinkingManifest.json
```

### Required Environment Variables

#### ZDOTDIR

**What:** Zsh config directory location

**Default:** `$HOME` (looks for `~/.zshrc`)

**This Project:** `~/.config/zsh` (set via .zprofile)

**Impact:** If not set, zsh can't find configs

**Set In:** `zsh/.zprofile` (symlinked to `~/.zprofile`)

**Gotcha:** If .zprofile not sourced, ZDOTDIR not set

**Fix:**
```bash
# Check current value
echo $ZDOTDIR

# Should be: ~/.config/zsh

# If not set, manually source
source ~/.zprofile

# Or explicitly set
export ZDOTDIR="${HOME}/.config/zsh"
```

#### PATH Modifications

**What:** Custom paths added to PATH in .zprofile

**Additions:**
- `~/.local/bin` - Custom scripts
- `/opt/homebrew/bin` - Homebrew (Apple Silicon)
- `/usr/local/bin` - Homebrew (Intel)

**Impact:** Without these, commands not found

**Gotcha:** PATH can be overwritten by other configs

**Fix:**
```bash
# Check current PATH
echo $PATH

# Should include: ~/.local/bin, /opt/homebrew/bin

# If missing, source .zprofile
source ~/.zprofile

# Or manually add
export PATH="${HOME}/.local/bin:/opt/homebrew/bin:$PATH"
```

### External Service Dependencies

#### macOS Keychain

**What:** Credential storage backend (macOS only)

**Commands:** `security` CLI tool

**Impact:** Without Keychain access, credentials fail

**Gotchas:**
- Keychain locked: Need to unlock with login password
- Different keychain: `security list-keychains` shows active
- Keychain permissions: May need to authorize access

**Fix:**
```bash
# List keychains
security list-keychains

# Unlock default keychain
security unlock-keychain

# Find stored credentials
security dump-keychain | grep dotfiles

# Test storage/retrieval
store-api-key TEST_KEY
get-api-key TEST_KEY
```

#### Git Remote

**What:** Repository hosted on GitHub (or GitLab, etc.)

**Commands:** `git pull`, `git push`, `syncenv`

**Impact:** Sync features require remote access

**Gotchas:**
- No internet: Sync fails
- SSH key not configured: Authentication fails
- HTTPS with password: Deprecated, use SSH or token

**Fix:**
```bash
# Check remote URL
git remote -v

# Should be: git@github.com:user/dotfiles.git (SSH)
# Or: https://github.com/user/dotfiles.git (HTTPS)

# Switch to SSH
git remote set-url origin git@github.com:user/dotfiles.git

# Test connection
ssh -T git@github.com

# If fails, configure SSH key:
ssh-keygen -t ed25519 -C "your@email.com"
cat ~/.ssh/id_ed25519.pub
# Add to GitHub Settings -> SSH Keys
```

### Known Issues

#### 1. Homebrew Installation Slow on First Run

**Symptom:** `./install` takes 20-30 minutes on fresh macOS

**Cause:** Homebrew installation + Xcode Command Line Tools download

**Workaround:**
- Pre-install Homebrew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- Or run with `--skip-brew` and install packages manually

#### 2. Zsh Completion Cache Stale

**Symptom:** Tab completion doesn't show new commands

**Cause:** 24-hour cache not refreshed

**Fix:**
```bash
# Force recompile
rm ~/.zcompdump*
zsh
```

#### 3. Symlinks Break After Repo Move

**Symptom:** All symlinks broken, shell can't find configs

**Cause:** Symlinks are absolute paths, repo moved location

**Fix:**
```bash
# Re-run link-dotfiles from new location
cd /new/location/.dotfiles
bin/core/link-dotfiles --apply --force

# Or update LinkingManifest.json if hardcoded paths
```

#### 4. Pre-commit Hooks Reject Valid Commits

**Symptom:** Hook fails on commit with unclear error

**Cause:** Hook script has bug or dependency missing

**Workaround:**
```bash
# Skip hooks temporarily (not recommended)
git commit --no-verify -m "message"

# Or fix hook script
vim bin/git/hooks/problematic-hook
shellcheck bin/git/hooks/problematic-hook

# Or disable specific hook
# Edit .pre-commit-config.yaml, remove offending hook
```

### Performance Bottlenecks

#### 1. History File Too Large

**Symptom:** Shell startup slow, history commands lag

**Cause:** ~/.zsh_history has 100k+ entries

**Impact:** 100-200ms added to startup

**Fix:**
```bash
# Check history size
wc -l ~/.zsh_history

# Trim to 10k entries
zsh-trim-history

# Verify improvement
zsh-benchmark
```

#### 2. Too Many Plugins

**Symptom:** Shell startup > 1 second even after optimization

**Cause:** Prezto modules or external plugins load unconditionally

**Impact:** Each plugin adds 50-200ms

**Fix:**
```bash
# Review loaded modules
grep "zstyle ':prezto:load' pmodule" ~/.zpreztorc

# Disable unused modules
# Edit zsh/.zpreztorc, comment out:
# zstyle ':prezto:load' pmodule 'unused-module'

# Measure impact
zsh-benchmark --detailed
```

#### 3. Network Operations on Startup

**Symptom:** Slow startup, especially on poor connection

**Cause:** Scripts check for updates or fetch remote data

**Impact:** 500-2000ms added, unpredictable

**Fix:**
```bash
# Identify network calls
strace -e connect zsh 2>&1 | grep connect

# Move to background or async
# Edit .zshrc, wrap in:
# (network-operation &)
```

### Technical Debt Hotspots

#### 1. Install Script Monolith

**Issue:** `install` script is 469 lines, does too much

**Debt:** Hard to test, maintain, extend

**Plan:** Break into modular scripts:
- `install-homebrew`
- `install-dependencies`
- `install-packages`
- `configure-shell`

#### 2. No Automated Tests

**Issue:** Manual testing only, no CI test suite

**Debt:** Regressions not caught, refactoring risky

**Plan:** Add BATS test framework:
- Unit tests for individual scripts
- Integration tests for install flow
- CI runs test suite on PRs

#### 3. Hardcoded Paths

**Issue:** Some scripts have hardcoded `~/.dotfiles` paths

**Debt:** Breaks if repo in different location

**Plan:** Use `DOTFILES_ROOT` variable consistently

#### 4. Documentation Drift

**Issue:** Some scripts lack --help, docs outdated

**Debt:** Users can't discover features, docs mislead

**Plan:** Enforce --help in all scripts, auto-generate docs

---

## 9. Documentation and Resources

### Project Documentation Files

#### Core Documents

**README.md** - Project overview, features, quick start
**Location:** `/README.md`
**Coverage:** High-level, for first-time visitors

**ONBOARDING.md** (This file) - Comprehensive developer guide
**Location:** `/ONBOARDING.md`
**Coverage:** Deep dive, architecture, workflows

**QUICKSTART.md** - Minimal 5-minute setup
**Location:** `/QUICKSTART.md`
**Coverage:** Essential commands only

**MINDSET.MD** - Constitutional rules and guidelines
**Location:** `/MINDSET.MD`
**Coverage:** Project principles, script standards

**AGENTS.md** - OpenSpec workflow instructions
**Location:** `/AGENTS.md`
**Coverage:** AI assistant guidelines, proposal process

#### Script Documentation

**docs/scripts/README.md** - Script documentation overview
**Location:** `/docs/scripts/README.md`
**Coverage:** All 67 scripts cataloged

**docs/scripts/quick-reference.md** - One-page cheat sheet
**Location:** `/docs/scripts/quick-reference.md`
**Coverage:** Quick lookups by task/category/frequency

**Interactive Help:**
```bash
dotfiles-help              # Interactive menu
dotfiles-help script-name  # Specific script help
dotfiles-help --search keyword  # Search scripts
```

#### OpenSpec Documentation

**openspec/AGENTS.md** - Proposal workflow
**openspec/project.md** - Project conventions
**openspec/changes/*/proposal.md** - Individual proposals
**openspec/changes/*/specs/** - Requirement specifications

#### Configuration Documentation

**LinkingManifest.json** - Self-documenting symlink definitions
Each entry has `"description"` field explaining purpose

**Inline Comments:**
- Shell scripts: `#` comments
- Zsh configs: `#` comments
- Git configs: `#` comments
- YAML configs: `#` comments

### External Documentation

#### Zsh & Prezto

**Zsh Manual:**
- https://zsh.sourceforge.io/Doc/
- Man pages: `man zsh`, `man zshbuiltins`

**Prezto Framework:**
- https://github.com/sorin-ionescu/prezto
- Module docs: https://github.com/sorin-ionescu/prezto/tree/master/modules

**Powerlevel10k Theme:**
- https://github.com/romkatv/powerlevel10k
- Configuration: `p10k configure`

#### Git

**Git Documentation:**
- https://git-scm.com/doc
- Man pages: `man git`, `man git-config`

**Conventional Commits:**
- https://www.conventionalcommits.org/
- Guide: Commit message specification

**GitHub Flow:**
- https://guides.github.com/introduction/flow/
- Workflow: Branch, PR, merge

#### Homebrew

**Homebrew Docs:**
- https://docs.brew.sh/
- Man pages: `man brew`, `brew help`

**Brewfile:**
- https://github.com/Homebrew/homebrew-bundle
- Usage: `brew bundle --help`

#### Security

**macOS Keychain:**
- Man pages: `man security`
- Guide: https://developer.apple.com/documentation/security/keychain_services

**OpenSSL:**
- https://www.openssl.org/docs/
- Encryption guide for credfile/credmatch

#### Development Tools

**Shellcheck:**
- https://www.shellcheck.net/
- Wiki: https://github.com/koalaman/shellcheck/wiki

**jq:**
- https://stedolan.github.io/jq/
- Manual: `man jq`

**OpenSpec:**
- https://github.com/openspec-dev/openspec (if public)
- CLI help: `openspec --help`

### Style Guides

**Shell Scripting:**
- Google Shell Style Guide: https://google.github.io/styleguide/shellguide.html
- Bash Best Practices: https://github.com/anordal/shellharden/blob/master/how_to_do_things_safely_in_bash.md

**Python:**
- PEP 8: https://www.python.org/dev/peps/pep-0008/
- Type Hints: https://docs.python.org/3/library/typing.html

**Markdown:**
- CommonMark: https://commonmark.org/
- GitHub Flavored: https://github.github.com/gfm/

### Internal Knowledge Base

**ai_docs/knowledge_base/**
- IDE-specific AI configurations
- Custom prompts and workflows
- Architecture decision records (informal)

**ai_docs/reports/**
- Code review outputs
- Session summaries
- Task completion reports

### Getting Help

**In-Project:**
```bash
# Interactive help system
dotfiles-help

# Specific script help
script-name --help

# Quick reference
cat docs/scripts/quick-reference.md

# Install help
./install --help
```

**External:**
- GitHub Issues: Report bugs, request features
- GitHub Discussions: Ask questions, share tips
- Pull Requests: Propose changes with context

---

## 10. Next Steps - Onboarding Checklist

### Day 1: Environment Setup

**Phase 1: Prerequisites (30 minutes)**
- [ ] Verify Git 2.30+ installed: `git --version`
- [ ] Verify Bash 4.0+ installed: `bash --version`
- [ ] Install jq: `brew install jq` (macOS) or `sudo apt-get install jq` (Linux)
- [ ] Install Xcode Command Line Tools: `xcode-select --install` (macOS only)
- [ ] Verify Perl available: `perl --version`

**Phase 2: Clone and Install (30 minutes)**
- [ ] Clone repository: `git clone <repo-url> ~/.dotfiles`
- [ ] Change to directory: `cd ~/.dotfiles`
- [ ] Review structure: `ls -la`
- [ ] Run installation: `./install`
- [ ] Restart shell: `exec zsh`
- [ ] Verify prompt shows environment (WORK or HOME:PERSONAL)

**Phase 3: Basic Configuration (30 minutes)**
- [ ] Set environment mode: `work-mode personal` (or work)
- [ ] Restart shell: `exec zsh`
- [ ] Measure performance: `zsh-benchmark` (should be < 500ms)
- [ ] Store test credential: `store-api-key TEST_KEY` (interactive prompt)
- [ ] Retrieve credential: `get-api-key TEST_KEY` (should output value)
- [ ] Explore scripts: `dotfiles-help`

### Day 2: Understanding the Codebase

**Phase 4: Read Documentation (2 hours)**
- [ ] Read README.md - Project overview
- [ ] Read ONBOARDING.md (this file) - Comprehensive guide
- [ ] Read MINDSET.MD - Constitutional rules
- [ ] Read AGENTS.md - OpenSpec workflow
- [ ] Read docs/scripts/quick-reference.md - Script cheat sheet

**Phase 5: Explore Structure (2 hours)**
- [ ] Review `bin/` - Understand script categories (core, credentials, git, macos)
- [ ] Review `zsh/` - Understand shell configuration layout
- [ ] Review `git/` - Understand git configuration consolidation
- [ ] Review `packages/` - Understand package management approach
- [ ] Review `openspec/` - Understand proposal process
- [ ] Review `LinkingManifest.json` - Understand symlink declarations

**Phase 6: Review Key Scripts (2 hours)**
- [ ] Read `install` - Understand installation flow
- [ ] Read `bin/core/link-dotfiles` - Understand symlink management
- [ ] Read `bin/core/work-mode` - Understand environment switching
- [ ] Read `bin/credentials/store-api-key` - Understand secure credential storage
- [ ] Read `zsh/.zshrc` - Understand shell initialization
- [ ] Read `zsh/lib/lazy-load.zsh` - Understand performance optimization

### Day 3: Making Changes

**Phase 7: Setup Development Tools (1 hour)**
- [ ] Install pre-commit hooks: `bin/core/setup-git-hooks`
- [ ] Test hooks: `pre-commit run --all-files`
- [ ] Install shellcheck: `brew install shellcheck` (macOS) or `sudo apt-get install shellcheck` (Linux)
- [ ] Install openspec (optional): `pipx install openspec`
- [ ] Configure Git user: `git config user.name "Your Name"`
- [ ] Configure Git email: `git config user.email "your@email.com"`

**Phase 8: Make a Test Change (2 hours)**
- [ ] Create feature branch: `git checkout -b feat/test-onboarding-change`
- [ ] Add simple script: `touch bin/core/hello-world` && `chmod +x bin/core/hello-world`
- [ ] Write basic script with --help
- [ ] Test script: `bin/core/hello-world --help`
- [ ] Lint script: `shellcheck bin/core/hello-world`
- [ ] Commit change: `git commit -m "feat(core): add hello-world test script"`
- [ ] Verify commit format: `git log -1`

**Phase 9: Test Workflow (1 hour)**
- [ ] Test dry-run installation: `./install --dry-run`
- [ ] Test symlink management: `bin/core/link-dotfiles --dry-run`
- [ ] Test interactive help: `dotfiles-help`
- [ ] Test credential storage: `store-api-key ANOTHER_TEST_KEY`
- [ ] Test performance measurement: `zsh-benchmark --detailed`
- [ ] Clean up test branch: `git checkout main && git branch -D feat/test-onboarding-change`

### Day 4: Advanced Topics

**Phase 10: OpenSpec Workflow (2 hours)**
- [ ] Review existing proposals: `ls openspec/changes/`
- [ ] Read a proposal: `cat openspec/changes/add-pre-commit-hooks-and-ci/proposal.md`
- [ ] Review specs: `cat openspec/changes/add-pre-commit-hooks-and-ci/specs/*/spec.md`
- [ ] Understand validation: `openspec validate add-pre-commit-hooks-and-ci --strict` (if installed)
- [ ] Draft a simple proposal (practice, don't commit)

**Phase 11: Deep Dive into Area of Interest (2 hours)**

Choose one area and explore deeply:

**Option A: Shell Configuration**
- [ ] Profile shell startup: `zsh -xv 2>&1 | tee profile.log`
- [ ] Review lazy loading: `cat zsh/lib/lazy-load.zsh`
- [ ] Test without lazy loading (comment out, measure difference)
- [ ] Experiment with completion caching
- [ ] Measure impact: `zsh-benchmark --detailed`

**Option B: Credential Management**
- [ ] Review security architecture: `cat bin/credentials/store-api-key`
- [ ] Test different input modes (interactive, stdin, file)
- [ ] Review macOS Keychain integration: `man security`
- [ ] Test credential search: `credmatch list`
- [ ] Test history cleaning: `clear-secret-history --dry-run`

**Option C: Installation System**
- [ ] Trace install flow: `./install --verbose --dry-run`
- [ ] Review phase implementations in install script
- [ ] Test platform detection
- [ ] Test dependency checking
- [ ] Review error handling patterns

**Option D: Git Integration**
- [ ] Review git config: `cat git/.gitconfig`
- [ ] Test conventional commit: `bin/git/conventional-commit`
- [ ] Review pre-commit hooks: `cat bin/git/hooks/*`
- [ ] Test hook execution: `pre-commit run --all-files`
- [ ] Review CI workflow: `cat .github/workflows/ci.yml`

**Phase 12: Contributing (1 hour)**
- [ ] Review CONTRIBUTING.md (if exists) or this ONBOARDING.md section 5
- [ ] Identify a small improvement (typo, doc update, minor fix)
- [ ] Create branch following naming convention
- [ ] Make change and commit with conventional format
- [ ] Run pre-commit hooks
- [ ] Push branch: `git push -u origin <branch-name>`
- [ ] Create PR (via `gh pr create` or GitHub web)

### Ongoing: Best Practices

**Daily:**
- [ ] Use `work-mode` to switch contexts as needed
- [ ] Use `syncenv` or `home-sync` to keep dotfiles synchronized
- [ ] Use `conventional-commit` for proper commit messages
- [ ] Check `zsh-benchmark` periodically to maintain performance

**Weekly:**
- [ ] Review `dotfiles-help` for scripts you haven't tried
- [ ] Check for Homebrew updates: `brew outdated`
- [ ] Run `clear-secret-history` for security hygiene
- [ ] Review `git log` to understand recent changes

**Monthly:**
- [ ] Update dependencies: `brew upgrade`
- [ ] Review and close completed OpenSpec proposals
- [ ] Clean up old branches: `git branch -d merged-branch-name`
- [ ] Compile configs: `zsh-compile` (if making many changes)

### Optional: Advanced Setup

**For Contributors:**
- [ ] Set up OpenSpec CLI: `pipx install openspec`
- [ ] Configure GitHub CLI: `gh auth login`
- [ ] Set up BATS testing framework: `brew install bats-core`
- [ ] Configure pre-commit locally: `pre-commit install --install-hooks`

**For macOS Developers:**
- [ ] Review iOS tools: `ls bin/ios/`
- [ ] Review macOS tools: `ls bin/macos/`
- [ ] Configure Xcode integration: `bin/ide/open-dotfiles-config`
- [ ] Review Brewfile: `cat packages/homebrew/Brewfile`

**For Multi-Machine Users:**
- [ ] Set up `syncenv` on all machines
- [ ] Configure work-mode appropriately per machine
- [ ] Test sync: `syncenv` on machine 1, verify on machine 2
- [ ] Set up background sync service: `home-sync-service install` (optional)

---

## Congratulations!

You've completed the comprehensive onboarding process. You should now:
- Have a working development environment
- Understand the repository structure and architecture
- Know how to make changes following the project's workflows
- Be familiar with key components and their purposes
- Have made at least one test change
- Understand how to get help and where to find documentation

**Next Actions:**
- Look for "good first issue" labels in GitHub Issues
- Review open pull requests to understand code review standards
- Join discussions to learn about planned features
- Start contributing to areas that interest you

**Need Help?**
- Interactive help: `dotfiles-help`
- Documentation: `docs/scripts/`
- Quick reference: `docs/scripts/quick-reference.md`
- GitHub Issues: Report bugs or ask questions
- Maintainers: Tag in PR comments for guidance

Welcome to the project!
