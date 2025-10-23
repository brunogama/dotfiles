# Comprehensive Onboarding Guide

## Bruno's Dotfiles Project

**Target Audience:** Senior developers new to this codebase
**Last Updated:** 2025-10-23
**Repository:** <https://github.com/brunogama/dotfiles>

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Repository Structure](#2-repository-structure)
3. [Getting Started](#3-getting-started)
4. [Key Components](#4-key-components)
5. [Development Workflow](#5-development-workflow)
6. [Architecture Decisions](#6-architecture-decisions)
7. [Common Tasks](#7-common-tasks)
8. [Potential Gotchas](#8-potential-gotchas)
9. [Documentation and Resources](#9-documentation-and-resources)
10. [Next Steps](#10-next-steps)

---

## 1. Project Overview

### Purpose

Bruno's Dotfiles is a modern, Unix-native dotfiles management system designed for macOS developers. It provides:

- **Environment Management:** Seamless switching between work and personal configurations with visual indicators
- **Automated Synchronization:** Background service for keeping configurations in sync across multiple machines
- **Secure Credential Storage:** Integration with macOS Keychain and encrypted git-based storage
- **Clean Organization:** Flat, logical structure without complex abstractions
- **AI-Assisted Development:** Deep integration with Claude Code and Factory.ai

### Main Functionality

**Core Features:**

- **work-mode:** Switch between work/personal environments with one command
- **home-sync:** Synchronize dotfiles across machines automatically
- **credfile/credmatch:** Secure credential and file encryption/storage
- **Standard Installation:** Makefile-based installation with selective component support
- **OpenSpec Integration:** Spec-driven development for major changes

**Visual Indicators:**

- Work environment shows `WORK` (orange) in shell prompt
- Personal environment shows `HOME:PERSONAL` (blue)
- Dynamic updates based on profile (dev/prod/staging)

### Tech Stack

#### Languages & Shells

- **Primary:** Bash 5.x (shell scripts)
- **Secondary:** Python 3.11+ (utilities, with `uv` for dependency management)
- **Shell:** ZSH with Prezto framework + Powerlevel10k theme

#### Frameworks & Tools

- **Prezto:** ZSH framework for prompt management and plugins
- **Powerlevel10k:** Highly customizable ZSH theme with instant prompt
- **OpenSpec:** Internal pattern for spec-driven development
- **GNU Make:** Standard Unix installation interface

#### Package Management

- **Homebrew:** macOS package manager (Brewfile-based)
- **uv:** Python package manager for single-file scripts
- **Git submodules:** For Prezto framework

#### Development Tools

- **Git:** Version control with conventional commits
- **shellcheck:** Shell script linting (mandatory for all bash scripts)
- **Claude Code:** AI coding assistant with custom hooks and agents
- **Factory.ai:** AI development platform with Droid-Shield secret detection

### Architecture Pattern

**Unix-Native Flat Structure:**

- No complex frameworks or abstractions
- Direct symlinks from `~/.config/` and `~/.local/bin`
- Simple Makefile targets for installation
- Self-contained scripts with minimal dependencies

**Design Philosophy:**

1. **Simplicity First:** Prefer straightforward bash over complex tools
2. **Standard Tools:** Use Unix conventions (Makefile, symlinks, man pages)
3. **Fast Navigation:** Flat hierarchy, easy to find anything
4. **Selective Installation:** Install only what you need
5. **Documentation-Driven:** Every script has help text and man pages

### Key Dependencies

#### Runtime Dependencies (Required)

- **macOS:** Primary target platform (10.15+)
- **ZSH:** Default shell (`/bin/zsh`)
- **Git:** Version control (2.x+)
- **Homebrew:** Package manager
- **Prezto:** ZSH framework (installed via git submodule or `make setup-prezto`)

#### Development Dependencies

- **shellcheck:** Shell script linter (required for contributions)
- **uv:** Python package manager (`curl -LsSf https://astral.sh/uv/install.sh | sh`)
- **make:** Build automation (pre-installed on macOS)

#### Optional Dependencies

- **gh:** GitHub CLI (for PR creation, branch management)
- **jq:** JSON processor (for parsing configurations)
- **fzf:** Fuzzy finder (for interactive searches)
- **bat, exa, fd, ripgrep:** Modern CLI tool replacements

#### Tool Versions

```bash
# Minimum required versions
zsh >= 5.8
git >= 2.30
python >= 3.11
shellcheck >= 0.8.0
```

**Version Constraints:**

- Prezto requires ZSH 5.1+
- Powerlevel10k requires ZSH 5.1+ and Git 2.x
- Python scripts use PEP 723 inline script metadata (Python 3.11+)
- No Node.js required (empty package.json for tooling compatibility)

---

## 2. Repository Structure

### Top-Level Directories

```
dotfiles/
├── config/              # Application configurations (symlinked to ~/.config/)
├── scripts/             # Executable utilities (symlinked to ~/.local/bin/)
├── docs/                # Documentation (guides, API docs, man pages)
├── openspec/            # Spec-driven development (proposals, specs)
├── .claude/             # Claude Code integration (agents, hooks, commands)
├── .factory/            # Factory.ai integration (OpenSpec commands)
├── .cursor/             # Cursor IDE configuration
├── .ai_docs/            # AI knowledge base (patterns, templates, workflows)
├── .github/             # GitHub configuration (copilot instructions)
├── .semgrep/            # Security scanning configuration
├── .vscode/             # VS Code configuration
├── Makefile             # Standard Unix installation interface
├── install              # One-line installer script (bash)
├── install.sh           # Legacy installer (to be deprecated)
├── Brewfile             # Homebrew dependencies
├── AGENTS.md            # AI assistant instructions
├── CLAUDE.md            # Claude-specific instructions (synced with AGENTS.md)
├── README.md            # User documentation
└── package.json         # Empty (for tooling compatibility)
```

### Config Directory Structure

```
config/
├── zsh/                 # ZSH configuration
│   ├── .zshrc          # Main ZSH config with environment detection
│   ├── .zprofile       # Login shell config
│   ├── .zpreztorc      # Prezto configuration
│   ├── .p10k.zsh       # Powerlevel10k theme config (1737 lines)
│   ├── work-config.zsh # Work-specific aliases and settings
│   ├── personal-config.zsh # Personal configuration
│   └── completion/     # Custom completions
├── git/                 # Git configuration
│   ├── .gitconfig      # Git settings (ignored, template in scripts/)
│   ├── conventional-commits-gitmessage # Commit template
│   ├── github-flow-aliases.gitconfig # Git aliases
│   ├── ignore          # Global gitignore
│   ├── ios.gitattributes # iOS project attributes
│   └── scripts/        # Git hooks and utilities
├── homebrew/            # Homebrew management
│   ├── Brewfile        # Main Brewfile
│   └── Brewfile.generated # Auto-generated from current installs
├── macos-preferences/   # macOS system settings
│   ├── system-preferences.sh # Exported preferences
│   └── domains.txt     # macOS preference domains list
├── mise/                # Mise version manager config
├── fish/                # Fish shell config (minimal)
├── ios-cli/             # iOS development CLI tools
└── sync-service/        # Background sync configuration
    └── config.yml      # Sync service settings
```

### Scripts Directory Structure

```
scripts/
├── core/                # Essential utilities (24 scripts, ~450 LOC avg)
│   ├── work-mode       # Environment switcher (169 lines)
│   ├── home-sync       # Dotfiles sync orchestration (450 lines)
│   ├── home-sync-service # Background sync daemon (290 lines)
│   ├── dotfiles-help   # Interactive help system
│   ├── createproject   # Project scaffolding (119KB - large)
│   ├── branches-current-branch # Git branch utility
│   ├── check-dependency # Dependency checker
│   ├── path-lookup     # PATH utility
│   ├── prints          # Color output utilities
│   ├── reload-shell    # Shell reloader
│   ├── update-dotfiles # Update orchestrator
│   ├── dead-code       # Swift dead code detection
│   ├── markdown_clipper # Markdown utilities
│   ├── open-xcode-with-flags # Xcode launcher
│   ├── cm, co, e, g, n, o, p, r # Single-letter shortcuts
│   └── ...
├── git/                 # Git workflow helpers (15 scripts)
│   ├── conventional-commit # Conventional commit enforcer
│   ├── git-wip.sh      # Work-in-progress commits
│   ├── git-save-all.sh # Savepoint system
│   ├── git-restore-*.sh # Restore utilities
│   ├── git-browse.sh   # Open repo in browser
│   ├── git-conventional-commit.sh # Commit helper
│   ├── git-squash-commits-*.sh # Commit squasher
│   ├── install-all-git-hooks.sh # Hook installer
│   ├── interactive-cherry-pick # Cherry-pick UI (Python)
│   └── ...
├── credentials/         # Secure credential management (9 scripts)
│   ├── credfile        # File encryption (150 lines)
│   ├── credmatch       # Credential search (100 lines)
│   ├── get-api-key     # Keychain retrieval
│   ├── store-api-key   # Keychain storage
│   ├── dump-api-keys   # Bulk export
│   ├── secure-store-api # Secure storage wrapper (ZSH)
│   ├── get-password-from-keytchain # Password retrieval
│   └── ImplementationGuide.md # Credential system docs
├── macos/               # macOS-specific tools (3 scripts)
│   ├── brew-sync       # Brewfile synchronization
│   ├── dump-macos-settings # Settings exporter
│   └── macos-prefs     # Preferences manager
└── ide/                 # IDE helpers (1 script)
    └── open-dotfiles-config # Config opener
```

### OpenSpec Directory Structure

```
openspec/
├── AGENTS.md            # OpenSpec workflow documentation
├── project.md           # Project metadata (template)
├── changes/             # Active change proposals
│   ├── add-env-prompt-indicator/ # Completed change
│   │   ├── proposal.md
│   │   ├── tasks.md
│   │   └── specs/
│   │       └── shell-environment/
│   │           └── spec.md
│   └── add-env-switch-command/ # Completed change
│       ├── proposal.md
│       ├── tasks.md
│       └── specs/
│           └── environment-management/
│               └── spec.md
└── specs/               # Current capability specifications (empty - new project)
```

### Claude Code Integration

```
.claude/
├── agents/              # 18 specialized AI agents
│   ├── agent-organizer.md
│   ├── api-documenter.md
│   ├── architect-review.md
│   ├── bug-hunter-agent.md
│   ├── cicd-engineer.md
│   ├── legacy-modernizer.md
│   ├── performance-engineer.md
│   ├── product-manager.md
│   ├── prompt-engineer.md
│   ├── qa-expert.md
│   ├── security-auditor.md
│   ├── specs-task-analyzer.md
│   ├── test-automator.md
│   └── ...
├── commands/            # Slash commands for workflows
│   ├── tools/          # Development commands
│   ├── workflows/      # Multi-step workflows
│   └── openspec/       # OpenSpec integration commands
├── hooks/               # Event hooks (Python)
│   ├── pre_tool_use.py
│   ├── post_tool_use.py
│   ├── session_start.py
│   ├── user_prompt_submit.py
│   ├── swiftlint_hook.py
│   ├── swiftformat_hook.py
│   └── utils/          # Shared utilities (LLM, TTS)
├── output-styles/       # Response formatting templates
│   ├── bullet-points.md
│   ├── markdown-focused.md
│   ├── ultra-concise.md
│   ├── yaml-structured.md
│   └── ...
├── status_lines/        # Custom status line scripts (Python with uv)
│   ├── status_line.py
│   ├── status_line_v2.py
│   └── ...
├── tasks/               # Task-specific onboarding documents
│   └── 20251023-045316/
│       └── onboarding.md
├── settings.json        # Permissions and configuration
└── settings.local.json  # Local overrides (gitignored)
```

### Non-Standard Patterns

1. **.claude/ and .factory/:** Deep AI assistant integration with hooks, agents, and custom commands
2. **.ai_docs/:** Knowledge base for AI assistants (patterns, templates, prompts)
3. **scripts/ without bin/:** Scripts go directly in categorized subdirectories, symlinked to ~/.local/bin
4. **config/ instead of individual dot-prefixed directories:** Central config directory
5. **openspec/:** Spec-driven development with proposal workflow
6. **.p10k.zsh in config/zsh/:** Massive theme configuration (1737 lines) alongside other configs
7. **Dual install systems:** Both Makefile and install script (migrating to Makefile only)
8. **Empty package.json:** Present for tooling but no Node.js dependencies
9. **Man pages in docs/man/:** Self-documenting scripts with manual pages
10. **Inline Python deps:** Using PEP 723 with uv for single-file scripts

---

## 3. Getting Started

### Prerequisites

**Required Software:**

1. **macOS 10.15+** (Catalina or later)
   - Why: Primary target platform, uses macOS-specific features (Keychain, LaunchAgents)

2. **Xcode Command Line Tools**

   ```bash
   xcode-select --install
   ```

   - Why: Required for git, make, and development tools

3. **Homebrew**

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

   - Why: Package manager for all other dependencies

4. **Git 2.30+**

   ```bash
   brew install git
   ```

   - Why: Version control and submodule support

**Recommended Software:**

1. **shellcheck**

   ```bash
   brew install shellcheck
   ```

   - Why: Required for contributing (lint shell scripts)

2. **uv (Python package manager)**

   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

   - Why: Required for Python utilities and Claude hooks

3. **Modern CLI tools**

   ```bash
   brew install bat exa fd ripgrep fzf jq
   ```

   - Why: Enhanced command-line experience with aliases

### Environment Setup Commands

**Step 1: Clone Repository**

```bash
# Option 1: One-line installer (recommended for new users)
curl -fsSL https://raw.githubusercontent.com/brunogama/dotfiles/main/install | bash

# Option 2: Manual clone (for developers)
git clone https://github.com/brunogama/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles
```

**Step 2: Install Prezto (ZSH Framework)**

```bash
# Automatic installation via Makefile
make setup-prezto

# Or manual installation
git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
```

**Step 3: Verify Prerequisites**

```bash
# Check shell version
zsh --version  # Should be 5.8+

# Check git
git --version  # Should be 2.30+

# Check Prezto
ls -la ~/.zprezto  # Should exist

# Check PATH for local bin
echo $PATH | grep -o "$HOME/.local/bin"  # Should output path
```

### Installing Dependencies

**Install All Dependencies:**

```bash
# From repository root
cd ~/.config/dotfiles

# Install Homebrew packages
brew bundle install --file=Brewfile

# Install development tools
brew install shellcheck gh jq
```

**Install Python Dependencies (for utilities):**

```bash
# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Verify uv installation
uv --version
```

### Configuration Required

**1. Git Configuration** (Required)

```bash
# Set git identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Verify
git config --global user.name
git config --global user.email
```

**2. Environment Variable** (Optional)

```bash
# Set environment preference (work or personal)
# Add to ~/.zshenv (will be created by work-mode)
export DOTFILES_ENV=work   # or personal (default)
```

**3. Secrets Configuration** (Optional, for work machines)

```bash
# Store work secrets in Keychain
work-mode work
ws-store "COMPANY_API_KEY" "your-api-key-here"
ws-store "DATABASE_URL" "postgresql://..."

# Verify
ws-list
```

**4. Sync Service** (Optional, for multi-machine setups)

```bash
# Configure sync service
home-sync setup

# Set sync interval (default: 30 minutes)
# Edit ~/.config/sync-service/config.yml
```

### Running the Project Locally

**Full Installation:**

```bash
cd ~/.config/dotfiles

# Backup existing configs
make backup

# Install everything
make install

# Verify installation
ls -la ~/.config/zsh    # Should be symlink
ls -la ~/.local/bin     # Should contain scripts
```

**Component Installation:**

```bash
# Install only ZSH
make install-zsh

# Install only Git
make install-git

# Install only scripts
make install-scripts

# Verify each component
make test  # Dry-run to see what would be installed
```

**Reload Shell:**

```bash
# Option 1: Source config
source ~/.zshrc

# Option 2: Reload shell
exec zsh

# Option 3: Start new terminal
# (CMD+T or CMD+N)
```

### Running Tests

**Test Installation (Dry-Run):**

```bash
make test
```

**Test Scripts:**

```bash
# Test shellcheck on all scripts
find scripts -type f ! -name "*.md" -exec shellcheck {} \;

# Test specific script
shellcheck scripts/core/work-mode
bash -n scripts/core/work-mode  # Syntax check
```

**Test Environment Switching:**

```bash
# Test work mode
work-mode work
source ~/.zshrc
# Check prompt shows WORK

# Test personal mode
work-mode personal
source ~/.zshrc
# Check prompt shows HOME:PERSONAL

# Check status
work-mode status
```

**Test Sync:**

```bash
# Test sync status
home-sync status

# Test dry-run sync
home-sync sync --dry-run  # If supported

# Test actual sync
home-sync sync
```

### Building for Production

**Not Applicable:** This is a dotfiles configuration project, not a compiled application.

**"Production" Setup:**

1. Install on your actual machine (not test VM)
2. Configure real credentials and secrets
3. Enable sync service for automatic updates
4. Set up work-mode for appropriate environment

**Deployment Checklist:**

```bash
# 1. Full installation
make install

# 2. Set environment
work-mode [work|personal]

# 3. Configure secrets (if work machine)
ws-store KEY "value"

# 4. Enable sync service
home-sync setup
sync-start

# 5. Verify
work-mode status
sync-status
ws-list
```

### Debugging Common Setup Issues

**Issue 1: Prezto Not Found**

```bash
# Symptom
⚠ Prezto not found at ~/.zprezto

# Solution
make setup-prezto

# Or manual
git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
```

**Issue 2: Scripts Not in PATH**

```bash
# Symptom
command not found: work-mode

# Check installation
ls -la ~/.local/bin/work-mode

# Check PATH
echo $PATH | grep "$HOME/.local/bin"

# Solution: Add to PATH
# Add to ~/.zshenv:
export PATH="$HOME/.local/bin:$PATH"

# Reload
exec zsh
```

**Issue 3: Prompt Not Showing Environment**

```bash
# Symptom
No WORK or HOME:PERSONAL indicator

# Check environment variables
echo $DOTFILES_ENV
echo $WORK_ENV
echo $HOME_ENV

# Check which config is loaded
grep -l "WORK_ENV\|HOME_ENV" ~/.config/zsh/*.zsh

# Solution: Ensure environment is set
work-mode work  # or personal
exec zsh
```

**Issue 4: Symlink Conflicts**

```bash
# Symptom
! .zshrc already exists

# Check current state
ls -la ~/.zshrc

# Backup and retry
make backup
make unlink  # Remove old symlinks
make link    # Create new ones
```

**Issue 5: Homebrew Package Failures**

```bash
# Symptom
Error: Failed to install xyz

# Update Homebrew
brew update

# Check for issues
brew doctor

# Try individual install
brew install xyz

# Skip optional packages
brew bundle install --no-upgrade --file=Brewfile
```

**Issue 6: Git Submodule Issues**

```bash
# Symptom
fatal: not a git repository (or any of the parent directories)

# Initialize submodules
git submodule update --init --recursive

# Or reclone with submodules
git clone --recurse-submodules https://github.com/brunogama/dotfiles.git
```

**Issue 7: shellcheck Failures**

```bash
# Symptom
SC2086: Quote to prevent word splitting

# Understand the error
shellcheck -x scripts/core/work-mode

# Fix quoting issues
# BAD:  echo $var
# GOOD: echo "$var"
```

**Issue 8: Python/uv Not Found**

```bash
# Symptom
command not found: uv

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add to PATH
export PATH="$HOME/.local/bin:$PATH"

# Reload
exec zsh
```

---

## 4. Key Components

### Entry Points

**Primary Entry Point: `config/zsh/.zshrc`**

- **Purpose:** Main shell configuration with environment detection
- **Location:** `config/zsh/.zshrc` → `~/.zshrc`
- **What it does:**
  1. Enables Powerlevel10k instant prompt
  2. Sources Prezto framework
  3. Detects `DOTFILES_ENV` variable
  4. Loads work-config.zsh or personal-config.zsh
  5. Sets up aliases, functions, key bindings
  6. Sources additional tools (fzf, mise, nvm, etc.)

**Key Lines:**

```zsh
# Line 27-37: Environment detection
if [[ "$DOTFILES_ENV" == "work" ]]; then
    source ~/.config/zsh/work-config.zsh
else
    source ~/.config/zsh/personal-config.zsh
fi
```

**Secondary Entry Point: `Makefile`**

- **Purpose:** Standard Unix installation interface
- **Location:** `Makefile` (root)
- **What it does:**
  1. Provides installation targets (`make install`)
  2. Handles backup creation
  3. Creates symlinks for configs and scripts
  4. Installs Prezto if missing
  5. Offers component-specific installs

**Key Targets:**

```makefile
install: backup link install-scripts  # Full installation
install-zsh: backup link-zsh          # ZSH only
install-git: backup link-git          # Git only
install-scripts: ...                  # Scripts only
```

**Tertiary Entry Point: `install` Script**

- **Purpose:** One-line installer for new users
- **Location:** `install` (root)
- **What it does:**
  1. Checks for macOS
  2. Installs Xcode Command Line Tools
  3. Installs Homebrew
  4. Clones repository
  5. Runs Makefile installation
  6. Configures shell

### Core Business Logic

**1. Environment Management (`scripts/core/work-mode`)**

**Purpose:** Switch between work and personal environments

**Key Functions:**

```bash
get_current_env()      # Read DOTFILES_ENV from ~/.zshenv
set_work_env()         # Set DOTFILES_ENV=work
set_personal_env()     # Remove DOTFILES_ENV
migrate_old_system()   # Migrate from ~/.work-machine marker
offer_reload()         # Interactive shell reload
```

**Logic Flow:**

```
work-mode work
├─> Check if already in work mode → exit if true
├─> Migrate from old marker file if exists
├─> set_work_env()
│   ├─> Create ~/.zshenv if needed
│   ├─> Remove existing DOTFILES_ENV line
│   └─> Add "export DOTFILES_ENV=work"
├─> Display success message
└─> offer_reload() → Interactive shell reload
```

**2. Synchronization (`scripts/core/home-sync`)**

**Purpose:** Orchestrate dotfiles synchronization

**Key Functions:**

```bash
sync_dotfiles()        # Full sync (pull + push)
push_changes()         # Git push with safety checks
pull_changes()         # Git pull with conflict handling
check_git_status()     # Verify clean state
backup_current()       # Create backup before sync
```

**Logic Flow:**

```
home-sync sync
├─> Check git status
├─> Backup current state
├─> Pull from remote
│   ├─> Handle conflicts
│   └─> Merge/rebase
├─> Push to remote
│   ├─> Check for divergence
│   └─> Force push if needed
└─> Report status
```

**3. Credential Management (`scripts/credentials/credfile`)**

**Purpose:** Secure file encryption and storage

**Key Functions:**

```bash
encrypt_file()         # Encrypt file with credmatch
decrypt_file()         # Decrypt file from credmatch
store_file()           # Store encrypted in git
retrieve_file()        # Retrieve from git and decrypt
```

**Logic Flow:**

```
credfile put "name" /path/to/file
├─> Read file content
├─> Base64 encode (if binary)
├─> Encrypt with credmatch (AES-256-CBC)
├─> Store in git repo
└─> Update index
```

**4. Prompt Indicator (`config/zsh/.p10k.zsh`)**

**Purpose:** Display environment in prompt

**Key Function:**

```zsh
prompt_env_context() {
  local label color
  if [[ -n ${WORK_ENV:-} ]]; then
    label='WORK'
    [[ -n ${WORK_ENV:-} ]] && label+=":${(U)WORK_ENV}"
    color=208  # Orange
  elif [[ -n ${HOME_ENV:-} ]]; then
    label='HOME'
    [[ -n ${HOME_ENV:-} ]] && label+=":${(U)HOME_ENV}"
    color=39   # Blue
  else
    return
  fi
  p10k segment -f $color -t "$label"
}
```

**Integration Point:**

```zsh
# Line 55 in .p10k.zsh
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  ...
  env_context  # Custom segment
  ...
)
```

### Database Models and Schemas

**Not Applicable:** This project doesn't use traditional databases.

**Data Storage:**

- **Credentials:** macOS Keychain (via `security` command)
- **Encrypted Files:** Git repository with credmatch (AES-256-CBC)
- **Configs:** Plain text files in git
- **Sync State:** Git metadata and LaunchAgent logs

### API Endpoints and Route Definitions

**Not Applicable:** No HTTP API.

**Command-Line Interface:**

```bash
# Environment Management API
work-mode [work|personal|status]

# Sync API
home-sync [sync|push|pull|status]
home-sync-service [start|stop|status]

# Credential API
ws                          # Load all work secrets
ws-store KEY "value"        # Store secret
ws-get KEY                  # Retrieve secret
ws-list                     # List secrets

# File Storage API
credfile put NAME /path     # Store file
credfile get NAME [/path]   # Retrieve file
credfile list               # List stored files
credfile rm NAME            # Remove file
```

### Configuration Management

**1. ZSH Configuration Hierarchy:**

```
~/.zshenv (if exists, loads first)
  ├─> export DOTFILES_ENV=work
  └─> (User-defined environment variables)

~/.zshrc (main config)
  ├─> Prezto init (~/.zprezto/init.zsh)
  ├─> Environment detection
  │   ├─> work-config.zsh (if DOTFILES_ENV=work)
  │   └─> personal-config.zsh (default)
  ├─> Aliases and functions
  ├─> Tool integrations (fzf, mise, nvm, etc.)
  └─> Powerlevel10k (~/.p10k.zsh)
```

**2. Configuration Files:**

| File | Purpose | Location | Symlinked From |
|------|---------|----------|----------------|
| `.zshrc` | Main shell config | `~/.zshrc` | `config/zsh/.zshrc` |
| `.zshenv` | Environment vars | `~/.zshenv` | Created by work-mode |
| `.zpreztorc` | Prezto config | `~/.zpreztorc` | `config/zsh/.zpreztorc` |
| `.p10k.zsh` | Prompt theme | `~/.p10k.zsh` | `config/zsh/.p10k.zsh` |
| `work-config.zsh` | Work settings | `~/.config/zsh/` | Not symlinked (sourced) |
| `personal-config.zsh` | Personal settings | `~/.config/zsh/` | Not symlinked (sourced) |

**3. Configuration Loading Order:**

```
Shell Start
├─> 1. /etc/zshenv (system-wide)
├─> 2. ~/.zshenv (user env vars, DOTFILES_ENV)
├─> 3. ~/.zshrc (main config)
│   ├─> Prezto init
│   ├─> Environment-specific config
│   └─> Tool integrations
└─> 4. ~/.p10k.zsh (prompt theme)
```

### Authentication and Authorization System

**macOS Keychain Integration:**

```bash
# Store secret in Keychain
security add-generic-password \
  -a "$USER" \
  -s "dotfiles.$KEY_NAME" \
  -w "$VALUE" \
  -U  # Update if exists

# Retrieve secret from Keychain
security find-generic-password \
  -a "$USER" \
  -s "dotfiles.$KEY_NAME" \
  -w  # Output password only
```

**Encrypted Git Storage (CredMatch):**

```bash
# Master password from Keychain
MASTER_PASSWORD=$(get-api-key CREDMATCH_MASTER_PASSWORD)

# Encrypt and store
echo "$VALUE" | \
  openssl enc -aes-256-cbc -pbkdf2 -pass "pass:$MASTER_PASSWORD" | \
  base64 | \
  git add - && git commit -m "Add $KEY"

# Decrypt and retrieve
git show HEAD:$KEY | \
  base64 -d | \
  openssl enc -d -aes-256-cbc -pbkdf2 -pass "pass:$MASTER_PASSWORD"
```

**Access Control:**

- **Keychain:** Protected by macOS user account password
- **CredMatch:** Protected by master password in Keychain
- **Environment separation:** work-config.zsh vs personal-config.zsh

### External Services Integration Points

**1. GitHub Integration (`gh` CLI)**

```bash
# Repository management
gh repo view brunogama/dotfiles
gh repo edit --default-branch main

# PR management
gh pr create --title "feat: add feature"
gh pr list --state open
```

**2. Homebrew Integration**

```bash
# Package installation
brew bundle install --file=Brewfile

# Package sync
brew bundle dump --file=config/homebrew/Brewfile.generated
```

**3. Claude Code Integration**

**Hooks:**

- `pre_tool_use.py`: Validate before tool execution
- `post_tool_use.py`: Post-process tool results
- `user_prompt_submit.py`: Process user input
- `session_start.py`: Initialize session context

**Agents:**

- 18 specialized agents for different tasks
- Custom slash commands for workflows
- Status line integration with uv

**4. Factory.ai Integration**

**Droid-Shield:**

- Secret detection in commits
- Blocks commits with exposed credentials
- Integrates with git commit workflow

**OpenSpec Commands:**

- `/openspec proposal`: Create change proposal
- `/openspec apply`: Apply approved changes
- `/openspec archive`: Archive completed changes

**5. Prezto Framework**

```bash
# Prezto modules (in .zpreztorc)
zstyle ':prezto:load' pmodule \
  'environment' \
  'terminal' \
  'editor' \
  'history' \
  'directory' \
  'spectrum' \
  'utility' \
  'completion' \
  'git' \
  'syntax-highlighting' \
  'history-substring-search' \
  'prompt'
```

**6. Powerlevel10k Theme**

```bash
# Theme configuration
ZSH_THEME="powerlevel10k/powerlevel10k"

# Custom segments
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  env_context  # Our custom environment indicator
  ...
)
```

---

## 5. Development Workflow

### Git Branch Naming Conventions

**Branch Types:**

```
main              # Main development branch (default)
feature/*         # New features (feature/add-credential-storage)
fix/*             # Bug fixes (fix/sync-race-condition)
refactor/*        # Code refactoring (refactor/simplify-sync-logic)
docs/*            # Documentation only (docs/update-onboarding)
chore/*           # Maintenance tasks (chore/update-dependencies)
```

**Examples:**

```bash
# Good branch names
feature/add-docker-support
fix/prompt-indicator-not-showing
refactor/extract-sync-functions
docs/add-quickstart-guide
chore/upgrade-shellcheck

# Bad branch names
new-feature      # Too vague
fix              # No description
my-changes       # Not descriptive
```

**Current Branches:**

```
main             # Current development (latest features)
bugged-main      # Old state before environment switching
origin/feature/fixing-dot-files-bugs  # Feature branch
```

### Commit Message Format

**Conventional Commits:**

```
<type>: <description>

[optional body]

[optional footer]

Co-authored-by: factory-droid[bot] <138933559+factory-droid[bot]@users.noreply.github.com>
```

**Types:**

- **feat:** New feature (user-facing)
- **fix:** Bug fix
- **docs:** Documentation only changes
- **style:** Formatting (no code change)
- **refactor:** Code refactoring (no behavior change)
- **perf:** Performance improvements
- **test:** Adding or fixing tests
- **chore:** Maintenance, dependencies, tooling

**Examples:**

```bash
# Good commits
feat: add environment switching with prompt indicators

- Add work/personal environment detection in .zshrc
- Update work-mode script to manage DOTFILES_ENV
- Enable prompt indicators in Powerlevel10k

Co-authored-by: factory-droid[bot] <138933559+factory-droid[bot]@users.noreply.github.com>

---

fix: restore missing dump-macos-settings script

Script was accidentally removed during reorganization.
Restored from commit 56b340c.

---

chore: update .gitignore for new structure

- Add .dotfiles-backup-* pattern
- Ignore cursor and vscode completely
- Keep API key scripts in exceptions
```

**Commit Checklist:**

- [ ] Type is correct (feat/fix/docs/etc.)
- [ ] Description is concise (<72 chars)
- [ ] Body explains why (not what)
- [ ] No secrets or credentials
- [ ] Co-author line included
- [ ] Passes pre-commit hooks
- [ ] CHANGELOG updated (if user-facing: feat/fix/perf/refactor)

### Pre-Commit Hooks

**Setup:**

```bash
# Install pre-commit
brew install pre-commit  # macOS
# or
pip install pre-commit   # via pip

# Install hooks in repository
cd ~/.config/dotfiles
pre-commit install

# Test installation
pre-commit run --all-files
```

**Available Hooks:**

```yaml
# Code Quality
- shellcheck           # Shell script linting (mandatory)
- trailing-whitespace  # Remove trailing whitespace
- end-of-file-fixer    # Ensure files end with newline
- check-yaml           # Validate YAML syntax
- check-json           # Validate JSON syntax
- mixed-line-ending    # Fix line endings (LF)

# Python (if applicable)
- black               # Code formatting
- isort               # Import sorting

# Documentation
- markdownlint        # Markdown linting
- validate-changelog  # Ensure CHANGELOG.md updated
```

**CHANGELOG Enforcement:**

Pre-commit hooks enforce CHANGELOG.md updates for user-facing changes:

```bash
# These commit types REQUIRE CHANGELOG update:
feat:      # New features → Add to "### Added"
fix:       # Bug fixes → Add to "### Fixed"
perf:      # Performance → Add to "### Changed"
refactor:  # User-visible refactoring → Add to "### Changed"

# These commit types SKIP CHANGELOG validation:
chore:     # Maintenance
docs:      # Documentation only
test:      # Tests only
ci:        # CI/CD configuration
build:     # Build system
style:     # Code formatting
```

**Example Workflow:**

```bash
# Make changes
vim scripts/core/my-script.sh

# Try to commit (will fail without CHANGELOG)
git add .
git commit -m "feat: add new script"
# ERROR: CHANGELOG.md not updated for user-facing change

# Update CHANGELOG
vim CHANGELOG.md
# Add to [Unreleased] section:
# ### Added
# - New script for doing X

# Commit again (will pass)
git add CHANGELOG.md
git commit -m "feat: add new script"
# ✓ shellcheck passed
# ✓ CHANGELOG validated
# ✓ All hooks passed
```

**Bypassing Hooks (When Needed):**

```bash
# Skip all hooks (not recommended)
git commit --no-verify -m "chore: emergency fix"

# Better: Fix the issues reported by hooks
pre-commit run --all-files  # See what's failing
# Fix the issues
git commit -m "chore: fix shellcheck issues"
```

**Troubleshooting:**

```bash
# Hooks not running?
pre-commit install  # Reinstall hooks

# Update hook versions
pre-commit autoupdate

# Clear cache
pre-commit clean

# Run specific hook
pre-commit run shellcheck --all-files
pre-commit run validate-changelog
```

### Starting a New Feature or Bugfix

**For New Features (Significant Changes):**

```bash
# Step 1: Check for conflicts
cd ~/.config/dotfiles
openspec list                    # Check active changes
openspec list --specs            # Check existing specs

# Step 2: Create change proposal
openspec validate --help         # Learn the workflow
mkdir -p openspec/changes/add-new-feature/specs/capability

# Step 3: Write proposal
cat > openspec/changes/add-new-feature/proposal.md << 'EOF'
# Add New Feature

## Why
[Problem or opportunity]

## What Changes
- [Change 1]
- [Change 2]

## Impact
- Affected specs: [list]
- Affected files: [list]
EOF

# Step 4: Create tasks
cat > openspec/changes/add-new-feature/tasks.md << 'EOF'
## 1. Implementation
- [ ] 1.1 Task 1
- [ ] 1.2 Task 2

## 2. Testing
- [ ] 2.1 Test 1

## 3. Documentation
- [ ] 3.1 Update docs
EOF

# Step 5: Create spec delta
cat > openspec/changes/add-new-feature/specs/capability/spec.md << 'EOF'
## ADDED Requirements
### Requirement: New Feature
Description...

#### Scenario: Use case
- **WHEN** condition
- **THEN** behavior
EOF

# Step 6: Validate
openspec validate add-new-feature --strict

# Step 7: Create feature branch
git checkout -b feature/add-new-feature

# Step 8: Implement following tasks.md
# (Make changes, test, commit)

# Step 9: Update tasks.md as you complete
# Change - [ ] to - [x] for completed tasks
```

**For Bug Fixes (Small Changes):**

```bash
# Step 1: Create fix branch
git checkout -b fix/fix-specific-issue

# Step 2: Make changes
# Edit files directly

# Step 3: Test fix
bash -n scripts/core/fixed-script  # Syntax check
shellcheck scripts/core/fixed-script  # Lint

# Step 4: Commit
git add scripts/core/fixed-script
git commit -m "fix: fix specific issue

Problem: [describe problem]
Solution: [describe solution]

Co-authored-by: factory-droid[bot] <138933559+factory-droid[bot]@users.noreply.github.com>"

# Step 5: Push
git push origin fix/fix-specific-issue
```

### Testing Requirements

**1. Shell Script Testing:**

```bash
# Syntax check (required)
bash -n scripts/core/work-mode

# Lint with shellcheck (required)
shellcheck scripts/core/work-mode

# Fix common issues
shellcheck -f diff scripts/core/work-mode | patch

# Test all scripts
find scripts -type f ! -name "*.md" -exec shellcheck {} \;
```

**2. Integration Testing:**

```bash
# Test environment switching
work-mode work
source ~/.zshrc
[[ "$DOTFILES_ENV" == "work" ]] && echo "✓ Work mode active"
work-mode personal
source ~/.zshrc
[[ -z "$DOTFILES_ENV" ]] && echo "✓ Personal mode active"

# Test sync
home-sync status
home-sync sync

# Test credentials
ws-store TEST_KEY "test_value"
[[ "$(ws-get TEST_KEY)" == "test_value" ]] && echo "✓ Credential storage works"
ws-get TEST_KEY | grep -q "test_value" && echo "✓ Credential retrieval works"
```

**3. Manual Testing:**

```bash
# Test installation
make test          # Dry-run
make backup        # Backup
make unlink        # Clean
make install       # Install
exec zsh           # Test

# Test scripts
work-mode --help
home-sync --help
credfile --help

# Test prompt
# Visual: Check WORK or HOME:PERSONAL appears in prompt
```

### Code Style, Linting, and Formatting Rules

**Shell Scripts (Bash/ZSH):**

**Style Guide:**

```bash
#!/usr/bin/env bash
set -euo pipefail  # REQUIRED: Exit on error, undefined var, pipe fail

# Colors (use for output)
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Functions (lowercase with underscores)
my_function() {
    local var="value"              # Use local for function variables
    echo -e "${GREEN}✓ Success${NC}"  # Colored output
}

# Variables (UPPERCASE for exports, lowercase for locals)
GLOBAL_VAR="value"
local_var="value"

# Conditionals (use [[ ]] not [ ])
if [[ "$var" == "value" ]]; then   # GOOD
    echo "Match"
fi

if [ "$var" = "value" ]; then      # BAD (but allowed)
    echo "Match"
fi

# Quoting (ALWAYS quote variables)
echo "$var"          # GOOD
echo "${var}"        # GOOD
echo $var            # BAD

# Command substitution (prefer $() over ``)
result=$(command)    # GOOD
result=`command`     # BAD

# Arrays
files=("file1" "file2")
for file in "${files[@]}"; do
    echo "$file"
done
```

**shellcheck Rules (Enforced):**

```bash
# SC2086: Quote variables
echo "$var"          # Not: echo $var

# SC2006: Use $() not ``
result=$(cmd)        # Not: result=`cmd`

# SC2046: Quote command substitution
rm "$(find . -name '*.tmp')"  # Not: rm $(find .)

# SC2164: Check cd result
cd "$dir" || exit    # Not: cd $dir

# SC2155: Separate declaration and assignment
local var
var=$(cmd)           # Not: local var=$(cmd)
```

**Python Scripts:**

**Style Guide (PEP 8):**

```python
#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "requests>=2.31.0",
# ]
# ///

"""
Module docstring.

Brief description of script purpose.
"""

import sys
from typing import Optional


def my_function(param: str) -> Optional[str]:
    """Function docstring."""
    if not param:
        return None
    return param.upper()


def main() -> int:
    """Main entry point."""
    result = my_function("test")
    print(result)
    return 0


if __name__ == "__main__":
    sys.exit(main())
```

**Formatting:**

```bash
# Line length: 88 characters (Black default)
# Indentation: 4 spaces
# String quotes: Double quotes preferred
# Imports: Grouped (stdlib, third-party, local)
```

**Git Commits:**

**Format:**

```
type: short description (<72 chars)

Longer explanation if needed. Wrap at 72 characters.
Explain why, not what (what is in the diff).

Co-authored-by: factory-droid[bot] <138933559+factory-droid[bot]@users.noreply.github.com>
```

**Rules:**

- First line: <72 characters
- Body: Wrap at 72 characters
- Blank line between subject and body
- Use imperative mood ("add" not "added")
- Include co-author line
- Reference issues/PRs if applicable

### PR Process

**1. Creation:**

```bash
# Ensure all changes committed
git status

# Push branch
git push origin feature/my-feature

# Create PR via gh CLI
gh pr create \
  --title "feat: add my feature" \
  --body "## What

Adds my feature...

## Testing

- Tested locally...
"

# Or create via GitHub web interface
# https://github.com/brunogama/dotfiles/compare
```

**2. PR Template:**

```markdown
## What

Brief description of changes.

## Why

Problem being solved or feature being added.

## How

Technical approach or implementation details.

## Testing

- [ ] Syntax check: `bash -n scripts/...`
- [ ] Lint: `shellcheck scripts/...`
- [ ] Manual testing: [describe steps]
- [ ] Integration testing: [describe tests]

## Screenshots (if applicable)

[Add screenshots]

## Checklist

- [ ] Code follows project style
- [ ] All scripts pass shellcheck
- [ ] Committed with conventional commits
- [ ] Co-author line included
- [ ] Documentation updated (if needed)
- [ ] OpenSpec proposal (if significant change)
```

**3. Review Process:**

- **Reviewers:** Automatically assigned or request manually
- **Checks:** None configured (manual review only)
- **Approval:** 1 approval required (recommended)
- **Merge:** Squash and merge preferred

**4. Post-Merge:**

```bash
# Delete feature branch
git branch -d feature/my-feature
git push origin --delete feature/my-feature

# Pull latest main
git checkout main
git pull origin main

# Archive OpenSpec proposal (if applicable)
openspec archive add-my-feature --yes
```

### CI/CD Pipeline Overview

**Current State:** No CI/CD configured

**Recommended CI/CD (Future):**

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  shellcheck:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run shellcheck
        run: |
          sudo apt-get install shellcheck
          find scripts -type f ! -name "*.md" -exec shellcheck {} \;

  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - name: Test installation
        run: make test
```

### Release Strategy

**Current Strategy:** Continuous deployment to `main` branch

**No Formal Releases:**

- No version tags
- No CHANGELOG
- No semantic versioning
- Users always pull from `main`

**Update Process:**

```bash
# On developer machine
git pull origin main
make install
exec zsh

# Or via sync service (automatic)
home-sync sync
```

**Future Release Strategy (Recommended):**

```bash
# Semantic versioning
v1.0.0  # Major.Minor.Patch

# Create release
git tag -a v1.0.0 -m "Release v1.0.0

Features:
- Environment switching
- Sync service
- Credential management
"
git push origin v1.0.0

# Generate changelog
git log v0.9.0..v1.0.0 --oneline --no-merges > CHANGELOG-v1.0.0.md
```

---

## 6. Architecture Decisions

### Design Patterns

**1. Simple Configuration Over Frameworks**

**Decision:** No framework abstractions like rcm, yadm, or chezmoi

**Rationale:**

- Direct symlinks are transparent and easy to debug
- Standard Unix tools (Make, ln) have no learning curve
- Failures are obvious and fixable
- No magic, no surprises

**Implementation:**

```makefile
# Makefile - simple symlink creation
link-zsh:
    ln -sfn $(CONFIG_DIR)/zsh $(HOME)/.config/zsh
    ln -sf $(CONFIG_DIR)/zsh/.zshrc $(HOME)/.zshrc
```

**2. Environment-Based Configuration Loading**

**Decision:** Load configs based on `DOTFILES_ENV` variable

**Rationale:**

- Single source of truth (one variable)
- Easy to switch environments
- Clean separation of work/personal
- Visual feedback via prompt

**Implementation:**

```zsh
# .zshrc
if [[ "$DOTFILES_ENV" == "work" ]]; then
    source ~/.config/zsh/work-config.zsh
else
    source ~/.config/zsh/personal-config.zsh
fi
```

**3. Script Self-Documentation**

**Decision:** All scripts include help text and usage examples

**Rationale:**

- Discoverable via `--help`
- No external documentation needed
- Examples show real usage
- Consistent UX across all scripts

**Implementation:**

```bash
# work-mode script
case "${1:-status}" in
    "help"|"-h"|"--help")
        cat << 'EOF'
Usage: work-mode [COMMAND]

COMMANDS:
  work    - Switch to work
  personal - Switch to personal
  status  - Show current
EOF
        ;;
esac
```

**4. Secure-by-Default Credentials**

**Decision:** Never store secrets in plain text git

**Rationale:**

- macOS Keychain for runtime secrets
- AES-256 encryption for synced secrets
- Git shows encrypted blobs only
- Master password protects all

**Implementation:**

```bash
# Store in Keychain
security add-generic-password \
  -a "$USER" -s "dotfiles.$KEY" -w "$VALUE"

# Sync via encrypted git (credmatch)
credmatch store "$MASTER_PASSWORD" "$KEY" "$VALUE"
```

**5. Spec-Driven Major Changes**

**Decision:** OpenSpec proposals for significant changes

**Rationale:**

- Think before coding
- Document decisions
- Review architecture
- Track why changes were made

**Implementation:**

```
openspec/changes/add-new-feature/
├── proposal.md   # Why, what, impact
├── tasks.md      # Implementation steps
└── specs/        # Requirement deltas
```

### State Management Approach

**1. Configuration State**

**Storage:** Plain text files in Git

```
config/zsh/.zshrc         # Version controlled
config/zsh/.zsh_history   # Gitignored (user-specific)
config/zsh/.zcompdump     # Gitignored (generated)
```

**Updates:** Direct file editing + git commit

**2. Environment State**

**Storage:** `~/.zshenv` file (user-created)

```bash
export DOTFILES_ENV=work  # Persisted between sessions
```

**Updates:** Via `work-mode` script (safe editing)

**3. Secrets State**

**Storage:** Dual system

- **Runtime:** macOS Keychain (`security` command)
- **Sync:** Encrypted git repository (credmatch)

**Access:**

```bash
# Runtime (from Keychain)
get-api-key "KEY_NAME"

# Sync (from encrypted git)
credmatch fetch "$MASTER_PASSWORD" "KEY_NAME"
```

**4. Sync State**

**Storage:**

- Git metadata (commits, refs)
- LaunchAgent logs (`~/Library/Logs/home-sync-service.log`)

**No Database:** All state in git and filesystem

### Error Handling Strategy

**1. Shell Scripts: Fail-Fast with set -euo pipefail**

```bash
#!/usr/bin/env bash
set -euo pipefail  # Exit on any error

# Explicit error handling for critical operations
if ! cd "$DOTFILES_DIR" 2>/dev/null; then
    echo -e "${RED}✗ Error: Cannot access $DOTFILES_DIR${NC}" >&2
    exit 1
fi

# Check dependencies
command -v git >/dev/null 2>&1 || {
    echo "Error: git is not installed" >&2
    exit 1
}

# Safe file operations
if [[ -f "$FILE" ]]; then
    backup_file "$FILE" || {
        echo "Warning: Backup failed" >&2
        # Continue anyway (non-fatal)
    }
fi
```

**2. User-Friendly Error Messages**

```bash
# Good error message
log_error() {
    echo -e "${RED}[✗]${NC} $1" >&2
    [[ -n "${2:-}" ]] && echo "   → $2" >&2
}

log_error "Failed to sync" "Check network connection and try again"

# Bad error message
echo "Error" >&2  # Too vague
```

**3. Graceful Degradation**

```bash
# Optional features fail gracefully
if command -v bat >/dev/null 2>&1; then
    cat() { bat --paging=never "$@"; }
else
    # Use standard cat if bat not available
    alias cat='/bin/cat'
fi
```

**4. Validation Before Destructive Operations**

```bash
# Validate before modifying files
if grep -q "^export DOTFILES_ENV=" "$ZSHENV"; then
    # Safe update: remove old, add new
    sed -i.bak '/^export DOTFILES_ENV=/d' "$ZSHENV"
    echo "export DOTFILES_ENV=work" >> "$ZSHENV"
    rm "${ZSHENV}.bak"
else
    # Safe add: no existing entry
    echo "export DOTFILES_ENV=work" >> "$ZSHENV"
fi
```

### Logging and Monitoring Setup

**1. Script Logging**

```bash
# Color-coded output levels
log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
log_error()   { echo -e "${RED}[✗]${NC} $1" >&2; }
```

**2. Sync Service Logging**

**Location:** `~/Library/Logs/home-sync-service.log`

**Format:**

```
[2025-10-23 12:34:56] INFO: Starting sync
[2025-10-23 12:35:01] SUCCESS: Sync completed
[2025-10-23 12:35:02] WARNING: Uncommitted changes found
[2025-10-23 12:35:03] ERROR: Push failed (exit 1)
```

**View logs:**

```bash
tail -f ~/Library/Logs/home-sync-service.log
```

**3. Git Commit History as Audit Log**

```bash
# View recent changes
git log --oneline -20

# View changes by author
git log --author="bruno"

# View changes to specific file
git log --follow -- config/zsh/.zshrc
```

**4. No External Monitoring**

- No APM (Application Performance Monitoring)
- No error tracking service (Sentry, Rollbar)
- No metrics collection (StatsD, Prometheus)

**Rationale:** Personal dotfiles, low complexity, git history sufficient

### Security Measures

**1. Secret Management**

**macOS Keychain:**

```bash
# Secure storage
security add-generic-password -s "dotfiles.KEY" -w "VALUE"

# Access requires user authentication
security find-generic-password -s "dotfiles.KEY" -w
```

**Encrypted Git (CredMatch):**

```bash
# AES-256-CBC with PBKDF2
openssl enc -aes-256-cbc -pbkdf2 \
  -pass "pass:$MASTER_PASSWORD" \
  -in plaintext -out ciphertext
```

**2. Never Commit Secrets**

**gitignore:**

```gitignore
# Credentials
*.key
*.pem
*_rsa
*credentials.json
*_token
.env*
```

**Droid-Shield:** Factory.ai secret detection in commits

**3. Audit Trail**

```bash
# Git history shows all changes
git log --all --full-history -- '*.key'

# Review before commit
git diff --cached | grep -i "password\|token\|key"
```

**4. Access Control**

- **Keychain:** Protected by macOS user password
- **CredMatch:** Protected by master password in Keychain
- **SSH Keys:** Separate from dotfiles (not tracked)

**5. Secure File Permissions**

```bash
# Scripts readable/executable
chmod 755 scripts/core/*

# Configs readable only
chmod 644 config/zsh/.zshrc

# Sensitive files (if any)
chmod 600 ~/.ssh/config
```

### Performance Optimizations

**1. Prezto Instant Prompt (Powerlevel10k)**

**Problem:** Slow shell startup

**Solution:** Instant prompt shows immediately, updates async

```zsh
# .zshrc - MUST be at top
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
```

**Result:** Sub-50ms shell startup

**2. Lazy Loading**

```zsh
# Load heavy tools only when needed
_load_nvm() {
  export NVM_DIR="$HOME/.config/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

# Only load when using node
nvm() {
  _load_nvm
  nvm "$@"
}
```

**3. Minimal Path**

```zsh
# Add to PATH only once
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
```

**4. Efficient Sync**

```bash
# Only sync if changes detected
if git diff-index --quiet HEAD --; then
    echo "No changes to sync"
    exit 0
fi

# Batch operations
git add -A && git commit -m "sync" && git push
```

**5. Script Optimization**

```bash
# Use built-ins over external commands
[[ -f "$file" ]]  # FAST (built-in)
test -f "$file"   # SLOWER (external)

# Avoid unnecessary subshells
var="value"       # FAST
var=$(echo "value")  # SLOWER

# Use arrays for iteration
files=( *.txt )
for f in "${files[@]}"; do ... done  # FAST
for f in $(ls *.txt); do ... done    # SLOW + UNSAFE
```

---

## 7. Common Tasks

### Adding a New API Endpoint

**Not Applicable:** No HTTP API in this project.

### Creating a New Database Model

**Not Applicable:** No database in this project.

### Writing a New Unit/Integration Test

**Current State:** No formal test suite

**Manual Testing Pattern:**

```bash
# 1. Create test script
cat > tests/test-work-mode.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

# Test work mode switching
work-mode work
[[ "$DOTFILES_ENV" == "work" ]] || { echo "FAIL: work mode"; exit 1; }

work-mode personal
[[ -z "$DOTFILES_ENV" ]] || { echo "FAIL: personal mode"; exit 1; }

echo "PASS: work-mode tests"
EOF

# 2. Make executable
chmod +x tests/test-work-mode.sh

# 3. Run test
./tests/test-work-mode.sh
```

**Recommended Test Framework (Future):**

```bash
# Using bats (Bash Automated Testing System)
brew install bats-core

# tests/work-mode.bats
@test "work-mode switches to work" {
  run work-mode work
  [ "$status" -eq 0 ]
  [[ "$DOTFILES_ENV" == "work" ]]
}

@test "work-mode switches to personal" {
  run work-mode personal
  [ "$status" -eq 0 ]
  [[ -z "$DOTFILES_ENV" ]]
}

# Run tests
bats tests/work-mode.bats
```

### Debugging Common Runtime Errors

**Error 1: "command not found: work-mode"**

```bash
# Diagnosis
which work-mode  # Check if in PATH
ls -la ~/.local/bin/work-mode  # Check if exists
echo $PATH | grep "$HOME/.local/bin"  # Check PATH

# Fix 1: Reinstall scripts
make install-scripts

# Fix 2: Add to PATH
export PATH="$HOME/.local/bin:$PATH"
# Add permanently to ~/.zshenv

# Fix 3: Use full path
~/.local/bin/work-mode status
```

**Error 2: "Prezto not found at ~/.zprezto"**

```bash
# Diagnosis
ls -la ~/.zprezto

# Fix: Install Prezto
make setup-prezto

# Or manual
git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
```

**Error 3: "Permission denied: ~/.zshenv"**

```bash
# Diagnosis
ls -la ~/.zshenv

# Fix: Change permissions
chmod 644 ~/.zshenv

# Or recreate
rm ~/.zshenv
work-mode work  # Recreates with correct permissions
```

**Error 4: "Sync failed: merge conflict"**

```bash
# Diagnosis
cd ~/.config/dotfiles
git status

# Fix 1: Accept local changes
git checkout --ours .
git add .
git commit -m "fix: resolve merge conflict (keep local)"

# Fix 2: Accept remote changes
git checkout --theirs .
git add .
git commit -m "fix: resolve merge conflict (keep remote)"

# Fix 3: Manual resolution
git mergetool
```

**Error 5: "Prompt not showing environment"**

```bash
# Diagnosis
echo $DOTFILES_ENV  # Should be "work" or empty
echo $WORK_ENV      # Should be set if in work mode
echo $HOME_ENV      # Should be set if in personal mode

# Fix 1: Reload shell
source ~/.zshrc

# Fix 2: Re-run work-mode
work-mode work
exec zsh

# Fix 3: Check .p10k.zsh
grep "prompt_env_context" ~/.p10k.zsh
grep "env_context" ~/.p10k.zsh | grep PROMPT_ELEMENTS
```

**Error 6: "shellcheck errors"**

```bash
# Diagnosis
shellcheck scripts/core/my-script

# Fix common issues

# SC2086: Quote variables
# BAD:  echo $var
# GOOD: echo "$var"

# SC2046: Quote command substitution
# BAD:  rm $(find . -name '*.tmp')
# GOOD: rm "$(find . -name '*.tmp')"

# SC2164: Check cd result
# BAD:  cd "$dir"
# GOOD: cd "$dir" || exit

# Apply fixes automatically (where safe)
shellcheck -f diff scripts/core/my-script | patch
```

### Updating Dependencies and Handling Breaking Changes

**1. Update Homebrew Packages**

```bash
# Update Homebrew itself
brew update

# Check outdated packages
brew outdated

# Upgrade all packages
brew upgrade

# Or upgrade specific package
brew upgrade git

# Handle breaking changes
brew info git  # Check release notes

# Update Brewfile
cd ~/.config/dotfiles
brew bundle dump --force --file=Brewfile
git add Brewfile
git commit -m "chore: update Brewfile dependencies"
```

**2. Update Prezto**

```bash
# Update Prezto
cd ~/.zprezto
git pull origin master
git submodule update --init --recursive

# Test
exec zsh

# If issues, check compatibility
git log --oneline -10  # Check recent changes
```

**3. Update Python Dependencies (uv)**

```bash
# Update uv itself
uv self update

# Update dependencies in script
# Edit script header:
# /// script
# requires-python = ">=3.12"  # Update version
# dependencies = [
#   "requests>=2.32.0",  # Update version
# ]
# ///

# Test script
uv run path/to/script.py
```

**4. Breaking Change Checklist**

```markdown
- [ ] Check CHANGELOG or release notes
- [ ] Test in development environment first
- [ ] Update all affected scripts
- [ ] Update documentation
- [ ] Test installation on clean machine
- [ ] Commit with clear breaking change note:
      feat!: upgrade to XYZ v2 (BREAKING)

      BREAKING: API changed from X to Y
      Migration: Update usage from `old` to `new`
```

### Running Migrations or Schema Updates

**Not Applicable:** No database migrations.

**Configuration Migrations:**

**Example: Migrate from marker file to env variable**

```bash
# Check for old system
if [[ -f ~/.work-machine ]]; then
    echo "Migrating from old marker file system..."

    # Read old state
    work_enabled="true"

    # Set new state
    work-mode work

    # Remove old marker
    rm ~/.work-machine

    echo "Migration complete"
fi
```

**Script migrations:**

```bash
# If scripts change location
OLD_PATH="~/bin/work-mode"
NEW_PATH="~/.local/bin/work-mode"

if [[ -f "$OLD_PATH" ]]; then
    echo "Removing old script: $OLD_PATH"
    rm "$OLD_PATH"
fi

# Reinstall
make install-scripts
```

---

## 8. Potential Gotchas

### Hidden or Non-Obvious Configs

**1. ~/.zshenv Must Exist for Environment Switching**

**Issue:** `.zshenv` is not tracked in git, must be created by user or `work-mode`

**Location:** `~/.zshenv` (in home directory)

**How it's Created:**

```bash
# Automatically by work-mode
work-mode work  # Creates ~/.zshenv with DOTFILES_ENV=work

# Or manually
echo 'export DOTFILES_ENV=work' >> ~/.zshenv
```

**Gotcha:** If deleted, environment switching stops working

**Fix:**

```bash
work-mode work  # Recreates file
```

**2. XDG_CONFIG_HOME Override**

**Issue:** If `XDG_CONFIG_HOME` is set, ZSH looks there instead of `~/.config`

**Check:**

```bash
echo $XDG_CONFIG_HOME  # Should be empty or ~/.config
```

**Fix if Different:**

```bash
# Edit ~/.zshenv
export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
```

**3. Prezto Must Be Installed Separately**

**Issue:** Prezto is not auto-installed with `make install`

**Required Step:**

```bash
make setup-prezto  # Must run once
```

**Gotcha:** Skipping this causes shell errors

**4. Scripts Need ~/.local/bin in PATH**

**Issue:** macOS doesn't include `~/.local/bin` in default PATH

**Check:**

```bash
echo $PATH | grep "$HOME/.local/bin"
```

**Fix:** Add to `~/.zshenv`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

**5. p10k.zsh is HUGE (1737 lines)**

**Issue:** `.p10k.zsh` is 1737 lines of theme configuration

**Don't Edit Manually:** Use `p10k configure` instead

```bash
p10k configure  # Interactive theme configuration
```

**6. Empty package.json**

**Issue:** `package.json` exists but has no dependencies

**Purpose:** Tooling compatibility only (eslint, prettier detection)

**Don't Run:** `npm install` (nothing to install)

### Required Environment Variables

**1. Essential Variables**

| Variable | Required | Set By | Purpose |
|----------|----------|--------|---------|
| `DOTFILES_ENV` | Optional | work-mode | Environment selection |
| `WORK_ENV` | Optional | work-config.zsh | Prompt indicator |
| `HOME_ENV` | Optional | personal-config.zsh | Prompt indicator |
| `PATH` | Yes | System/Shell | Script execution |
| `ZDOTDIR` | Recommended | ~/.zshenv | ZSH config location |
| `XDG_CONFIG_HOME` | Recommended | ~/.zshenv | Config directory |

**2. Optional Variables**

| Variable | Purpose | Set By |
|----------|---------|--------|
| `EDITOR` | Default editor | .zshrc |
| `VISUAL` | Visual editor | .zshrc |
| `GIT_PAGER` | Git diff viewer | .zshrc |
| `NVM_DIR` | Node version manager | .zshrc |
| `SDKMAN_DIR` | SDK manager | .zshrc |

**3. Missing Variable Symptoms**

```bash
# DOTFILES_ENV not set
# Symptom: Always loads personal-config.zsh
# Fix: Run work-mode work

# PATH not including ~/.local/bin
# Symptom: command not found: work-mode
# Fix: export PATH="$HOME/.local/bin:$PATH"

# ZDOTDIR not set
# Symptom: ZSH doesn't find config
# Fix: export ZDOTDIR="$HOME/.config/zsh"
```

### External Service Dependencies

**1. GitHub (Required for Git Operations)**

**Dependency:** <https://github.com>

**Used For:**

- Cloning repository
- Pushing/pulling changes
- Sync service operation

**Failure Modes:**

- No internet: Sync fails, local operations work
- GitHub down: Sync fails, local operations work
- Auth expired: Push/pull fails

**Workarounds:**

```bash
# Work offline
work-mode status  # Still works
# Editing configs works
# Sync fails gracefully
```

**2. macOS Keychain (Required for Credentials)**

**Dependency:** Built-in macOS service

**Used For:**

- Storing API keys
- Retrieving secrets

**Failure Modes:**

- Keychain locked: Prompts for password
- Keychain corrupted: Credential operations fail

**Fix:**

```bash
# Unlock keychain
security unlock-keychain ~/Library/Keychains/login.keychain-db

# Repair keychain
# Keychain Access.app → Keychain First Aid
```

**3. Homebrew (Required for Installation)**

**Dependency:** <https://brew.sh>

**Used For:**

- Installing dependencies
- Package management

**Failure Modes:**

- Homebrew not installed: Installation fails
- Repository unreachable: Updates fail

**Fix:**

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Repair Homebrew
brew doctor
```

**4. Prezto (Required for Shell Features)**

**Dependency:** <https://github.com/sorin-ionescu/prezto>

**Used For:**

- ZSH framework
- Prompt management
- Syntax highlighting

**Failure Modes:**

- Not installed: Shell lacks features
- Corrupted: Shell errors on startup

**Fix:**

```bash
# Reinstall Prezto
rm -rf ~/.zprezto
make setup-prezto
```

### Known Bugs or Edge Cases

**1. Sync Race Condition**

**Issue:** Simultaneous sync on multiple machines causes conflicts

**Scenario:**

```
Machine A: git pull → edit → git push
Machine B: git pull → edit → git push  # Conflict!
```

**Workaround:**

```bash
# Use sync service (one machine as primary)
# Or manual coordination (sync before editing)
```

**Status:** Known limitation, no fix planned

**2. Large Prezto Clone**

**Issue:** Prezto with submodules is 50MB+

**Impact:** Slow initial installation

**Workaround:**

```bash
# Shallow clone (faster but limited)
git clone --depth 1 https://github.com/sorin-ionescu/prezto.git ~/.zprezto
```

**Status:** Expected behavior

**3. shellcheck False Positives**

**Issue:** shellcheck flags intentional patterns

**Example:**

```bash
# SC2086: Intentional word splitting
files="file1 file2"
rm $files  # INTENTIONAL unquoted

# Fix: Disable warning
# shellcheck disable=SC2086
rm $files
```

**4. macOS Version Compatibility**

**Issue:** Keychain API changes between macOS versions

**Affected Versions:** 10.14 and earlier

**Workaround:**

```bash
# Use alternative credential storage
export CREDMATCH_MASTER_PASSWORD="password"  # NOT RECOMMENDED
```

**5. Empty Git Commits**

**Issue:** `git commit --allow-empty` needed for some workflows

**Scenario:** Initial commit on new branch

**Workaround:**

```bash
git commit --allow-empty -m "Initial commit"
```

### Performance Bottlenecks

**1. Slow Shell Startup**

**Bottleneck:** Loading heavy frameworks (NVM, SDKMAN)

**Measurement:**

```bash
time zsh -ic exit  # Measure startup time
```

**Solution:** Lazy loading (already implemented)

**Expected:** <100ms startup with instant prompt

**2. Large .zsh_history File**

**Bottleneck:** History file > 10MB slows down search

**Check:**

```bash
du -h ~/.config/zsh/.zsh_history
```

**Solution:**

```bash
# Truncate history (keep last 10000 lines)
tail -10000 ~/.config/zsh/.zsh_history > /tmp/history
mv /tmp/history ~/.config/zsh/.zsh_history
```

**3. Git Operations on Large Repos**

**Bottleneck:** Syncing with large history

**Measurement:**

```bash
time git pull
time git push
```

**Solution:**

```bash
# Shallow clone for new machines
git clone --depth 1 https://github.com/brunogama/dotfiles.git

# Or rewrite history (DESTRUCTIVE)
git filter-branch --prune-empty --subdirectory-filter . -- --all
```

**4. credmatch Encryption/Decryption**

**Bottleneck:** OpenSSL encryption is CPU-intensive

**Measurement:**

```bash
time credmatch store "..." "KEY" "value"
time credmatch fetch "..." "KEY"
```

**Expected:** <100ms per operation

**No Fix Needed:** Acceptable performance for typical usage

### Technical Debt Hotspots

**1. Dual Installation Systems**

**Issue:** Both `Makefile` and `install.sh` exist

**Location:** Root directory

**Problem:** Duplicate logic, maintenance burden

**Plan:** Deprecate `install.sh`, keep only `Makefile`

**Status:** Migration in progress

**2. Mixed Credential Systems**

**Issue:** Both Keychain and credmatch for different purposes

**Location:** `scripts/credentials/`

**Problem:** Confusing which to use

**Plan:** Unified credential API

**Status:** Documented, no refactor planned

**3. Large createproject Script**

**Issue:** 119KB single-file script

**Location:** `scripts/core/createproject`

**Problem:** Hard to maintain, slow to load

**Plan:** Refactor into modular structure

**Status:** Low priority (rarely used)

**4. No Test Suite**

**Issue:** Manual testing only

**Location:** Entire project

**Problem:** Regressions not caught automatically

**Plan:** Add bats test framework

**Status:** Recommended for future

**5. OpenSpec project.md is Template**

**Issue:** `openspec/project.md` has placeholders

**Location:** `openspec/project.md`

**Problem:** Not filled in for this project

**Plan:** Complete project metadata

**Status:** Low priority (docs exist elsewhere)

**6. Deprecated Stow References in README**

**Issue:** Old README mentions Stow (no longer used)

**Location:** `docs/guides/README.md`

**Problem:** Confusing instructions

**Plan:** Update or remove old README

**Status:** New README.md exists, old can be removed

---

## 9. Documentation and Resources

### Project Documentation

**1. Primary Documentation**

| File | Purpose | Audience |
|------|---------|----------|
| `README.md` | User guide | End users |
| `AGENTS.md` / `CLAUDE.md` | AI assistant instructions | AI agents |
| `ONBOARDING.md` | Comprehensive onboarding | New developers |
| `QUICKSTART.md` | Quick setup guide | New users |

**2. Guides**

| File | Topic |
|------|-------|
| `docs/guides/WORK_SECRETS_GUIDE.md` | Credential management |
| `docs/guides/HOME_SYNC_SERVICE_GUIDE.md` | Sync service setup |
| `docs/guides/HOMEBREW_MANAGEMENT_GUIDE.md` | Package management |
| `docs/guides/README.md` | Documentation index |
| `docs/guides/LICENSE.md` | MIT license |

**3. API Documentation**

| File | Topic |
|------|-------|
| `docs/api/anthropic_quick_start.md` | Claude API |
| `docs/api/openai_quick_start.md` | OpenAI API |
| `docs/api/cc_hooks_docs.md` | Claude Code hooks |
| `docs/api/user_prompt_submit_hook.md` | Hook examples |
| `docs/api/uv-single-file-scripts.md` | Python with uv |

**4. Implementation Guides**

| File | Topic |
|------|-------|
| `scripts/credentials/ImplementationGuide.md` | Credential system internals |
| `openspec/AGENTS.md` | OpenSpec workflow |

**5. Internal Documentation**

| Location | Content |
|----------|---------|
| Script headers | Usage and examples in all scripts |
| `docs/man/man1/` | Man pages for commands |
| `.claude/agents/` | AI agent definitions |
| `.ai_docs/` | AI knowledge base |

### Man Pages

**Available Man Pages:**

```bash
man credfile        # File encryption/storage
man credmatch       # Credential management
man work-mode       # Environment switching
man home-sync       # Sync service
man work-secrets    # Work secrets functions
man dotfiles-system # System overview
```

**Location:** `docs/man/man1/*.1`

**Installation:** Man pages accessible if `~/.local/share/man` in MANPATH

**Add to MANPATH:**

```bash
# Add to ~/.zshenv
export MANPATH="$HOME/.local/share/man:$MANPATH"
```

### Internal/External Wiki

**No Wiki:** All documentation in repository

**Why:**

- Single source of truth (git)
- Version controlled
- Searchable with grep/rg
- Works offline

**Find Documentation:**

```bash
# Search all docs
rg "credential" docs/

# List all markdown files
find docs -name "*.md"

# Interactive help
dotfiles-help
```

### API Documentation

**1. Swagger/OpenAPI**

**Not Applicable:** No HTTP API

**2. Command-Line API**

**Self-Documenting Scripts:**

Every script includes help text:

```bash
work-mode --help
home-sync --help
credfile --help
```

**Format:**

```
Usage: command [COMMAND] [OPTIONS]

COMMANDS:
  command1    Description
  command2    Description

OPTIONS:
  -h, --help  Show help

EXAMPLES:
  command example1
  command example2
```

**3. Shell Function API**

**Work Secrets Functions:**

Documented in `docs/guides/WORK_SECRETS_GUIDE.md`

```bash
# Available functions (in work-config.zsh)
load-work-secrets [PATTERN]  # Load secrets matching pattern
list-work-secrets            # List all secrets
store-work-secret KEY VALUE  # Store secret
get-work-secret KEY          # Get secret
backup-work-secrets          # Backup to credmatch
sync-work-secrets            # Sync from credmatch
work-profile [ENV]           # Switch work profile
```

### Database Schemas and ER Diagrams

**Not Applicable:** No database

### Deployment Guides

**"Deployment" = Installation on User Machine**

**Guides:**

1. **Quick Deployment (One-Line):**

   ```bash
   curl -fsSL https://raw.githubusercontent.com/brunogama/dotfiles/main/install | bash
   ```

2. **Manual Deployment:**
   See `README.md` → "Manual Installation"

3. **Multi-Machine Deployment:**
   See `docs/guides/HOME_SYNC_SERVICE_GUIDE.md`

**Deployment Checklist:**

```markdown
- [ ] Prerequisites installed (Xcode tools, Homebrew)
- [ ] Repository cloned
- [ ] Prezto framework installed
- [ ] Dotfiles installed (make install)
- [ ] Scripts in PATH
- [ ] Environment set (work-mode)
- [ ] Secrets configured (if work machine)
- [ ] Sync service enabled (if multi-machine)
- [ ] Shell reloaded (exec zsh)
```

### Style Guides and Coding Standards

**1. Shell Script Style Guide**

**Location:** `AGENTS.md` → "Code Quality Rules"

**Key Rules:**

- Use `set -euo pipefail`
- Quote all variables
- Use `[[` over `[`
- Pass shellcheck with no errors
- Include help text

**2. Python Style Guide**

**Standard:** PEP 8

**Enforced Rules:**

- 88 character line length
- 4 space indentation
- Double quotes for strings
- Type hints recommended

**3. Git Commit Style Guide**

**Standard:** Conventional Commits

**Format:**

```
type: description

body

Co-authored-by: factory-droid[bot] <...>
```

**4. Documentation Style Guide**

**Markdown Standard:**

- Headers: ATX-style (##)
- Code blocks: Fenced with language tags
- Lists: Dash (-) for unordered, numbers for ordered
- Emphasis: *italic*, **bold**

---

## 10. Next Steps

### Onboarding Checklist

**Day 1: Environment Setup**

- [ ] **1.1** Install Xcode Command Line Tools

  ```bash
  xcode-select --install
  ```

- [ ] **1.2** Install Homebrew

  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```

- [ ] **1.3** Clone dotfiles repository

  ```bash
  git clone https://github.com/brunogama/dotfiles.git ~/.config/dotfiles
  cd ~/.config/dotfiles
  ```

- [ ] **1.4** Install Prezto framework

  ```bash
  make setup-prezto
  ```

- [ ] **1.5** Install development tools

  ```bash
  brew install shellcheck uv gh jq bat exa fd ripgrep fzf
  ```

**Day 1: Run Project Locally**

- [ ] **2.1** Run test installation (dry-run)

  ```bash
  make test
  ```

- [ ] **2.2** Backup existing configs

  ```bash
  make backup
  # Note: Backup location displayed
  ```

- [ ] **2.3** Install all dotfiles

  ```bash
  make install
  ```

- [ ] **2.4** Reload shell

  ```bash
  exec zsh
  ```

- [ ] **2.5** Verify installation

  ```bash
  # Check symlinks
  ls -la ~/.config/zsh  # Should be symlink
  ls -la ~/.zshrc       # Should be symlink

  # Check scripts
  which work-mode       # Should be ~/.local/bin/work-mode
  work-mode --help      # Should show help

  # Check prompt
  # Visual: Should see prompt theme loaded
  ```

**Day 1: Make a Test Change**

- [ ] **3.1** Create test branch

  ```bash
  git checkout -b test/my-first-change
  ```

- [ ] **3.2** Add test alias

  ```bash
  echo 'alias hello="echo Hello from dotfiles!"' >> config/zsh/.zshrc
  ```

- [ ] **3.3** Test change

  ```bash
  source ~/.zshrc
  hello  # Should print: Hello from dotfiles!
  ```

- [ ] **3.4** Revert test change

  ```bash
  git checkout config/zsh/.zshrc
  git checkout main
  git branch -d test/my-first-change
  ```

**Day 2: Run Full Test Suite**

- [ ] **4.1** Test shellcheck on all scripts

  ```bash
  find scripts -type f ! -name "*.md" -exec shellcheck {} \;
  ```

- [ ] **4.2** Test environment switching

  ```bash
  # Test work mode
  work-mode work
  source ~/.zshrc
  # Check prompt shows WORK

  # Test personal mode
  work-mode personal
  source ~/.zshrc
  # Check prompt shows HOME:PERSONAL

  # Check status
  work-mode status
  ```

- [ ] **4.3** Test sync (if multi-machine)

  ```bash
  home-sync status
  home-sync sync --dry-run  # If supported
  ```

- [ ] **4.4** Test credential management

  ```bash
  # Store test secret
  ws-store TEST_KEY "test_value"

  # Retrieve test secret
  [[ "$(ws-get TEST_KEY)" == "test_value" ]] && echo "✓ Credentials work"

  # Clean up
  security delete-generic-password -s "dotfiles.TEST_KEY" 2>/dev/null || true
  ```

**Day 2: Walk Through Main User Flow**

- [ ] **5.1** Complete environment setup

  ```bash
  # Set environment preference
  work-mode [work|personal]

  # Configure secrets (if work)
  ws-store "COMPANY_API_KEY" "your-key"

  # Enable sync service (optional)
  home-sync setup
  sync-start
  ```

- [ ] **5.2** Customize configuration

  ```bash
  # Add personal aliases
  # Edit config/zsh/personal-config.zsh or work-config.zsh

  # Test changes
  source ~/.zshrc
  ```

- [ ] **5.3** Sync to remote (if multi-machine)

  ```bash
  cd ~/.config/dotfiles
  git add .
  git commit -m "chore: personalize configuration"
  git push origin main
  ```

**Day 3: Select First Contribution Area**

- [ ] **6.1** Review recent changes

  ```bash
  git log --oneline -20
  ```

- [ ] **6.2** Explore codebase structure

  ```bash
  # Review key components
  cat AGENTS.md
  cat ONBOARDING.md

  # Explore scripts
  ls -la scripts/core/
  ls -la scripts/git/
  ls -la scripts/credentials/

  # Review configs
  ls -la config/zsh/
  cat config/zsh/.zshrc
  ```

- [ ] **6.3** Identify improvement area

  ```markdown
  Ideas for first contribution:
  - [ ] Fix shellcheck warnings in a script
  - [ ] Add new alias or function
  - [ ] Improve documentation
  - [ ] Add test script
  - [ ] Create new utility script
  ```

- [ ] **6.4** Read OpenSpec workflow

  ```bash
  cat openspec/AGENTS.md
  openspec list --specs
  ```

- [ ] **6.5** Make first contribution

  ```bash
  # Create branch
  git checkout -b [fix|feat|docs]/my-first-contribution

  # Make changes
  # (edit files)

  # Test
  shellcheck scripts/...  # If shell script
  source ~/.zshrc         # If config change

  # Commit
  git add .
  git commit -m "type: description

  Co-authored-by: factory-droid[bot] <138933559+factory-droid[bot]@users.noreply.github.com>"

  # Push
  git push origin [branch]

  # Create PR
  gh pr create --title "type: description" --body "..."
  ```

---

## Appendix A: Quick Command Reference

```bash
### Environment Management
work-mode [work|personal|status]  # Switch environments
work-profile [dev|prod|staging]   # Switch work profile

### Sync
home-sync [sync|push|pull|status] # Manual sync
sync-start / sync-stop / sync-status # Service management

### Credentials
ws / load-work-secrets             # Load all secrets
ws-store KEY "value"               # Store secret
ws-get KEY                         # Retrieve secret
ws-list                            # List secrets
ws-backup                          # Backup to credmatch
ws-sync                            # Sync from credmatch

### File Storage
credfile put NAME /path            # Store file
credfile get NAME [/path]          # Retrieve file
credfile list                      # List files
credfile rm NAME                   # Remove file

### Installation
make install                       # Full installation
make install-[zsh|git|scripts]    # Component install
make backup                        # Backup configs
make unlink                        # Remove symlinks
make test                          # Dry-run
make clean                         # Clean backups
make setup-prezto                  # Install Prezto

### OpenSpec
openspec list [--specs]            # List changes/specs
openspec show [item]               # Show details
openspec validate [change] --strict # Validate
openspec archive <change> --yes    # Archive

### Documentation
dotfiles-help                      # Interactive help
man [credfile|work-mode|...]      # Man pages
```

---

## Appendix B: Troubleshooting Quick Reference

| Symptom | Diagnosis | Fix |
|---------|-----------|-----|
| `command not found: work-mode` | Scripts not in PATH | `export PATH="$HOME/.local/bin:$PATH"` or `make install-scripts` |
| Prompt not showing environment | DOTFILES_ENV not set | `work-mode [work|personal]` then `exec zsh` |
| Prezto not found | Not installed | `make setup-prezto` |
| Sync fails with conflicts | Merge conflict | `git checkout --ours .` or `--theirs` |
| Slow shell startup | Heavy frameworks loading | Already optimized (instant prompt) |
| shellcheck errors | Code quality issues | Fix or disable: `# shellcheck disable=SCXXXX` |
| Permission denied ~/.zshenv | Wrong permissions | `chmod 644 ~/.zshenv` |
| Keychain locked | Need authentication | `security unlock-keychain` |
| Git submodule issues | Not initialized | `git submodule update --init --recursive` |

---

## Appendix C: File Locations Quick Reference

| Purpose | Location |
|---------|----------|
| ZSH config | `~/.config/zsh/` → `config/zsh/` |
| Scripts | `~/.local/bin/` → `scripts/*/` |
| Git config | `~/.config/git/` → `config/git/` |
| Homebrew config | `~/.config/homebrew/` → `config/homebrew/` |
| Environment var | `~/.zshenv` (user-created) |
| Prezto framework | `~/.zprezto/` (git clone) |
| Sync logs | `~/Library/Logs/home-sync-service.log` |
| Backups | `~/.dotfiles-backup-YYYYMMDD-HHMMSS/` |
| Man pages | `~/.local/share/man/` (if installed) |

---

## Appendix D: External Resources

**Official Documentation:**

- Prezto: <https://github.com/sorin-ionescu/prezto>
- Powerlevel10k: <https://github.com/romkatv/powerlevel10k>
- Homebrew: <https://docs.brew.sh>
- shellcheck: <https://www.shellcheck.net>
- uv: <https://github.com/astral-sh/uv>

**Community Resources:**

- Dotfiles Guide: <https://dotfiles.github.io>
- GitHub Flow: <https://guides.github.com/introduction/flow/>
- Conventional Commits: <https://www.conventionalcommits.org>

**Internal Resources:**

- Repository: <https://github.com/brunogama/dotfiles>
- Issues: <https://github.com/brunogama/dotfiles/issues>
- Pull Requests: <https://github.com/brunogama/dotfiles/pulls>

---

**Onboarding Document Version:** 1.0
**Last Updated:** 2025-10-23
**Maintained By:** Bruno Gama

**Questions?** Create an issue on GitHub or check the documentation in `docs/`.

**Welcome to the team! 🚀**
