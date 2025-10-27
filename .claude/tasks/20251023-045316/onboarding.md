# Onboarding: Bruno's Dotfiles Project

**Task ID:** 20251023-045316  
**Date:** 2025-10-23  
**Session:** Comprehensive project onboarding

---

##  Project Overview

### Purpose
Modern, organized dotfiles management system for macOS with:
- Work/Personal environment switching with visual prompt indicators
- Automated synchronization across machines
- Secure credential storage using macOS Keychain
- Clean Unix-native structure without complex abstractions

### Tech Stack
- **Shell:** ZSH with Prezto + Powerlevel10k
- **Languages:** Bash (scripts), Python (with uv for deps)
- **VCS:** Git with GitHub (brunogama/dotfiles)
- **Package Manager:** Homebrew
- **Documentation:** OpenSpec for change proposals

### Repository
- **GitHub:** https://github.com/brunogama/dotfiles
- **Local Path:** `~/.config-fixing-dot-files-bugs` (worktree for testing)
- **Install Path:** `~/.config/dotfiles` (normal installation)
- **Scripts Path:** `~/.local/bin` (symlinked scripts)

---

##  Architecture

### Directory Structure

```
dotfiles/
├── config/                 # Application configurations
│   ├── zsh/               # Shell config, Powerlevel10k, work/personal configs
│   ├── git/               # Git config, aliases, hooks, scripts
│   ├── homebrew/          # Brewfiles for package management
│   ├── macos-preferences/ # macOS system settings
│   ├── mise/              # Version manager config
│   ├── fish/              # Fish shell config
│   ├── ios-cli/           # iOS development tools config
│   └── sync-service/      # Background sync configuration
│
├── scripts/               # Executable utilities (~5868 LOC)
│   ├── core/             # Essential: work-mode, home-sync, path-lookup
│   ├── git/              # Git workflows: WIP, savepoints, conventional commits
│   ├── credentials/      # Secure storage: credfile, credmatch, keychain
│   ├── macos/            # macOS tools: brew-sync, settings dump
│   └── ide/              # IDE helpers: open-dotfiles-config
│
├── docs/                  # Documentation
│   ├── guides/           # User guides (WORK_SECRETS, HOME_SYNC, etc.)
│   ├── api/              # API docs for Claude, Anthropic, OpenAI
│   └── man/              # Man pages for scripts
│
├── openspec/              # Spec-driven development
│   ├── AGENTS.md         # OpenSpec workflow documentation
│   ├── project.md        # Project metadata
│   ├── changes/          # Active change proposals
│   └── specs/            # Capability specifications
│
├── .claude/               # Claude Code integration
│   ├── agents/           # Custom AI agents (18 specialized agents)
│   ├── commands/         # Slash commands for workflows
│   ├── hooks/            # Event hooks (pre/post tool use, TTS, etc.)
│   ├── output-styles/    # Response formatting templates
│   ├── status_lines/     # Custom status line scripts
│   └── settings.json     # Permissions and config
│
├── .factory/              # Factory.ai integration
│   └── commands/         # OpenSpec commands
│
├── Makefile              # Standard Unix installation interface
├── install               # One-line installer script
├── AGENTS.md             # AI assistant instructions (concise)
├── CLAUDE.md             # Claude-specific instructions (synced with AGENTS.md)
└── README.md             # User-facing documentation
```

---

##  Recent Changes

### Current State (commit b19db8d)
**Branch:** main  
**Last Commit:** `feat: add environment switching with prompt indicators`

### What Was Implemented
1. **Environment Detection System**
   - `.zshrc` now checks `DOTFILES_ENV` variable
   - Auto-loads `work-config.zsh` or `personal-config.zsh`
   - Defaults to personal environment

2. **work-mode Script Enhancement**
   - Refactored from marker file (`~/.work-machine`) to env variable
   - Commands: `work-mode [work|personal|status]`
   - Safely edits `~/.zshenv` to set/unset `DOTFILES_ENV`
   - Includes migration from old system
   - Interactive shell reload option

3. **Prompt Indicators**
   - Work: **WORK** (orange, color 208) on right side
   - Personal: **HOME:PERSONAL** (blue, color 39)
   - Dynamic updates with `work-profile [dev|prod|staging]`
   - Powered by Powerlevel10k `prompt_env_context` function

4. **OpenSpec Documentation**
   - Created two change proposals:
     - `add-env-prompt-indicator` (completed)
     - `add-env-switch-command` (completed)
   - All tasks marked complete with test results

### Branch Structure
- `main` - Current working branch (new features)
- `bugged-main` - Old state before environment switching (commit 67dfbbc)
- `origin/feature/fixing-dot-files-bugs` - Feature branch

---

##  Key Systems

### 1. Environment Management

**Purpose:** Switch between work and personal contexts

**Components:**
- `work-mode` script - CLI for switching
- `.zshenv` - Stores `DOTFILES_ENV` variable
- `.zshrc` - Detects and loads appropriate config
- `work-config.zsh` - Work-specific aliases, vars, secrets
- `personal-config.zsh` - Personal aliases, vars
- `.p10k.zsh` - Prompt indicators via `prompt_env_context()`

**Usage:**
```bash
work-mode work      # Switch to work
work-mode personal  # Switch to personal
work-mode status    # Check current environment
```

**Variables:**
- `DOTFILES_ENV` - Set to "work" or unset (in ~/.zshenv)
- `WORK_ENV` - Set by work-config.zsh, used for prompt
- `HOME_ENV` - Set by personal-config.zsh, used for prompt

### 2. Credential Management

**Purpose:** Secure storage for API keys, tokens, passwords

**Components:**
- `credfile` - Encrypt/decrypt files using macOS Keychain
- `credmatch` - Search encrypted credentials
- Work secrets functions in `work-config.zsh`
- Keychain integration via `security` command

**Usage:**
```bash
# Work secrets (loaded from keychain)
ws                      # Load all work secrets
ws-store KEY "value"    # Store new secret
ws-list                 # List available secrets
ws-get KEY              # Get specific secret

# Encrypted files
credfile file.txt       # Encrypt/decrypt file
credmatch "pattern"     # Search credentials
```

### 3. Sync System

**Purpose:** Synchronize dotfiles across machines

**Components:**
- `home-sync` - Manual sync script (push/pull/sync)
- `home-sync-service` - Background daemon
- `config/sync-service/config.yml` - Sync configuration

**Usage:**
```bash
home-sync sync          # Full sync
home-sync push          # Push changes
home-sync pull          # Pull changes
home-sync-service start # Start background sync
```

### 4. Git Workflow Enhancements

**Purpose:** Streamline git operations

**Scripts:**
- `git-wip.sh` - Quick work-in-progress commits
- `git-save-all.sh` - Savepoint system
- `git-restore-wip.sh` - Restore from WIP
- `git-conventional-commit.sh` - Enforce conventional commits
- `interactive-cherry-pick` - Visual cherry-pick UI

**Aliases (in git config):**
```bash
git save    # Quick savepoint
git wip     # Work in progress commit
git unwip   # Undo WIP commit
```

### 5. Homebrew Management

**Purpose:** Declarative package management

**Components:**
- `brew-sync` - Sync installed packages with Brewfile
- `Brewfile` - Package declarations
- `Brewfile.generated` - Auto-generated from current installs

**Usage:**
```bash
brew-sync install   # Install from Brewfile
brew-sync sync      # Two-way sync
brew-sync update    # Update all packages
```

---

##  Development Patterns

### Code Quality Standards

#### Shell Scripts (Bash/Zsh)
- **MUST** pass `shellcheck` with no errors
- Use `set -euo pipefail` for robustness
- Quote all variables: `"$var"` not `$var`
- Prefer `[[` over `[` for conditionals
- Use functions for code organization
- Include color output for UX (GREEN, BLUE, YELLOW, RED, NC)
- Include help text and usage examples

**Template:**
```bash
#!/usr/bin/env bash
set -euo pipefail

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Functions here

case "${1:-help}" in
    "command")
        # Implementation
        ;;
    "help"|*)
        cat << 'EOF'
Usage: script [command]
EOF
        ;;
esac
```

#### Python Scripts
- **MUST** adhere to PEP 8
- **MUST** use `uv` for dependency management
- Single-file scripts: inline metadata with `uv run`

**Template:**
```python
#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "requests",
# ]
# ///

"""Script description here."""

def main():
    pass

if __name__ == "__main__":
    main()
```

#### Git Commits
- Use conventional commits: `feat:`, `fix:`, `chore:`, `docs:`, etc.
- Include co-author line:
  ```
  Co-authored-by: factory-droid[bot] <138933559+factory-droid[bot]@users.noreply.github.com>
  ```
- Keep first line under 72 characters
- Use body for detailed explanations

### OpenSpec Workflow

**When to Create Proposals:**
- New features or capabilities
- Breaking changes
- Architecture changes
- Performance optimizations that change behavior

**Process:**
1. Check `openspec list` for conflicts
2. Create proposal: `openspec/changes/[change-id]/`
3. Files needed:
   - `proposal.md` - Why, what, impact
   - `tasks.md` - Implementation checklist
   - `design.md` - Technical decisions (if complex)
   - `specs/[capability]/spec.md` - Delta specs
4. Validate: `openspec validate [change-id] --strict`
5. Implement sequentially following tasks.md
6. Mark tasks complete as you go
7. Archive after deployment: `openspec archive [change-id]`

**Spec Delta Format:**
```markdown
## ADDED Requirements
### Requirement: Feature Name
Description...

#### Scenario: Use case
- **WHEN** condition
- **THEN** expected behavior

## MODIFIED Requirements
### Requirement: Existing Feature
[Full updated requirement text]

## REMOVED Requirements
### Requirement: Deprecated Feature
**Reason:** Why removing
**Migration:** How to handle
```

---

##  Important Files

### Configuration Files
| File | Purpose |
|------|---------|
| `config/zsh/.zshrc` | Main shell config, env detection, aliases |
| `config/zsh/.p10k.zsh` | Powerlevel10k theme config (1737 lines) |
| `config/zsh/work-config.zsh` | Work-specific config |
| `config/zsh/personal-config.zsh` | Personal config |
| `~/.zshenv` | Environment variable storage (DOTFILES_ENV) |
| `config/git/.gitconfig` | Git configuration |
| `Makefile` | Installation targets and commands |

### Key Scripts
| Script | Purpose | LOC |
|--------|---------|-----|
| `work-mode` | Environment switcher | 169 |
| `home-sync` | Dotfiles sync | ~450 |
| `home-sync-service` | Background sync daemon | ~290 |
| `credfile` | File encryption | ~150 |
| `credmatch` | Credential search | ~100 |

### Documentation
| File | Purpose |
|------|---------|
| `AGENTS.md` / `CLAUDE.md` | AI assistant instructions |
| `README.md` | User-facing docs |
| `docs/guides/WORK_SECRETS_GUIDE.md` | Credential management |
| `docs/guides/HOME_SYNC_SERVICE_GUIDE.md` | Sync system |
| `openspec/AGENTS.md` | OpenSpec workflow |

---

##  Common Workflows

### Daily Usage

**Check Current Environment:**
```bash
work-mode status
```

**Switch to Work:**
```bash
work-mode work
exec zsh  # Or answer 'y' to reload prompt
```

**Load Work Secrets:**
```bash
ws                    # Load all secrets
ws-list              # See what's available
work-profile prod    # Switch to production profile
```

**Sync Dotfiles:**
```bash
home-sync sync       # Full sync
home-sync push       # Push local changes
```

### Development Workflow

**1. Make Changes:**
```bash
# Edit configs in config/
# Edit scripts in scripts/
# Test locally
```

**2. Create Proposal (if significant):**
```bash
# Check for conflicts
openspec list

# Create proposal directory
mkdir -p openspec/changes/add-new-feature/{specs/capability}

# Write proposal.md, tasks.md, spec deltas
# Validate
openspec validate add-new-feature --strict
```

**3. Implement:**
```bash
# Follow tasks.md sequentially
# Update tasks.md as you complete items
# Test each component
```

**4. Commit:**
```bash
git status
git diff
git add .
git commit -m "feat: add new feature

- Detail 1
- Detail 2

Co-authored-by: factory-droid[bot] <138933559+factory-droid[bot]@users.noreply.github.com>"
```

**5. Push:**
```bash
git push origin main
```

### Script Development

**1. Create Script:**
```bash
touch scripts/core/my-script
chmod +x scripts/core/my-script
```

**2. Write with Template:**
```bash
#!/usr/bin/env bash
set -euo pipefail

# Include colors, functions, help text
```

**3. Validate:**
```bash
shellcheck scripts/core/my-script
bash -n scripts/core/my-script  # Syntax check
```

**4. Test:**
```bash
./scripts/core/my-script
```

**5. Install:**
```bash
make install-scripts
```

### Testing Environment Switch

**Manual Test:**
```bash
# Check current state
work-mode status
echo $DOTFILES_ENV
echo $WORK_ENV
echo $HOME_ENV

# Switch and verify
work-mode work
grep DOTFILES_ENV ~/.zshenv
source ~/.zshrc
# Check prompt shows WORK

# Switch back
work-mode personal
grep DOTFILES_ENV ~/.zshenv
source ~/.zshrc
# Check prompt shows HOME:PERSONAL
```

---

##  Integration Points

### Claude Code
- **Location:** `.claude/`
- **Settings:** `.claude/settings.json` - Permissions and status line
- **Hooks:** Pre/post tool use, TTS, notifications
- **Agents:** 18 specialized agents for different tasks
- **Commands:** Slash commands for workflows
- **Status Line:** Python script with uv

### Factory.ai
- **Location:** `.factory/`
- **Commands:** OpenSpec proposal, apply, archive
- **Droid Shield:** Secret detection in commits

### Prezto (ZSH Framework)
- **Location:** `~/.zprezto/`
- **Installed:** Via `make setup-prezto`
- **Modules:** git, syntax-highlighting, autosuggestions, prompt

### Powerlevel10k (Prompt Theme)
- **Config:** `config/zsh/.p10k.zsh`
- **Custom Segment:** `prompt_env_context()` for environment indicator
- **Elements:** LEFT: dir, vcs, prompt_char; RIGHT: status, time, env_context

---

##  Resources

### Documentation
- **OpenSpec Docs:** `openspec/AGENTS.md`
- **Work Secrets:** `docs/guides/WORK_SECRETS_GUIDE.md`
- **Home Sync:** `docs/guides/HOME_SYNC_SERVICE_GUIDE.md`
- **Homebrew Management:** `docs/guides/HOMEBREW_MANAGEMENT_GUIDE.md`

### External Links
- **GitHub Repo:** https://github.com/brunogama/dotfiles
- **Prezto:** https://github.com/sorin-ionescu/prezto
- **Powerlevel10k:** https://github.com/romkatv/powerlevel10k
- **OpenSpec:** (internal pattern, see openspec/AGENTS.md)

### Commands Reference
```bash
# Environment
work-mode [work|personal|status]

# Sync
home-sync [sync|push|pull|status]
home-sync-service [start|stop|status]

# Credentials
ws / load-work-secrets
ws-store KEY "value"
ws-list / ws-get KEY

# Installation
make install
make install-[zsh|git|scripts|homebrew]
make uninstall / make backup / make clean

# OpenSpec
openspec list [--specs]
openspec show [item]
openspec validate [change] --strict
openspec archive <change-id> [--yes]

# Git Helpers
git wip / git unwip
git save / git undo
```

---

##  Key Learnings

### Architecture Decisions
1. **No frameworks:** Prefer simple bash over complex tools
2. **Flat structure:** Easy navigation, no deep nesting
3. **Standard tools:** Makefile, symlinks, standard Unix utilities
4. **Spec-driven:** OpenSpec for major changes
5. **Security first:** Keychain integration, encrypted storage

### Conventions
- Scripts in `scripts/` by category
- Configs in `config/` by application
- Docs in `docs/` by type
- Proposals in `openspec/changes/`
- Symlinks from `~/.config/` and `~/.local/bin`

### Pain Points Addressed
- **Environment confusion:** Solved with prompt indicators
- **Manual switching:** Solved with `work-mode` command
- **Secret management:** Solved with keychain + credfile
- **Sync drift:** Solved with home-sync service
- **Package drift:** Solved with brew-sync

---

## [YES] Onboarding Checklist

- [x] Understand project purpose and goals
- [x] Map directory structure
- [x] Identify key systems (env, sync, credentials)
- [x] Review recent changes (environment switching)
- [x] Learn coding standards (shellcheck, PEP 8, uv)
- [x] Understand OpenSpec workflow
- [x] Document common workflows
- [x] Map integration points (Claude, Factory, Prezto)
- [x] Compile command reference
- [x] Note architecture decisions

---

##  Next Session Start Here

**Quick Context:**
1. This is a dotfiles project with environment switching
2. Main branch has latest features (work-mode, prompt indicators)
3. All scripts must pass shellcheck
4. Python uses uv for dependencies
5. Use OpenSpec for significant changes
6. Current state: All changes committed and pushed
7. Environment switching: `work-mode [work|personal|status]`

**Current Status:**
- [YES] Environment switching implemented and tested
- [YES] Prompt indicators working (WORK/HOME:PERSONAL)
- [YES] OpenSpec proposals completed
- [YES] Committed to main branch (b19db8d)
- [YES] Pushed to GitHub (brunogama/dotfiles)
-  Default branch set to main (may need manual confirmation)

**Ready to work on:** Any new features, fixes, or enhancements!

---

**Onboarding Complete:** 2025-10-23 04:53:16
