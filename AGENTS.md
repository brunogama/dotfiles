# Dotfiles Project

Modern Unix dotfiles with environment management, automated sync, and secure credential storage.

## Core Functionality

### Environment Management

- `work-mode [work|personal|status]` - Switch between work/home environments
- Prompt shows: **WORK** (orange) or **HOME:PERSONAL** (blue)
- Config: `~/.config/zsh/{work,personal}-config.zsh`

### Sync and Backup

- `home-sync [sync|push|pull|status]` - Sync dotfiles across machines
- `home-sync-service [start|stop|status]` - Background sync daemon

### Credentials

- `credfile <file>` - Manage secure credential files (keychain + encrypted)
- `credmatch <pattern>` - Search/decrypt credentials by pattern

### Dotfiles Management

- `./install` - One-command installation (idempotent)
- `./install --dry-run` - Preview installation without changes
- `./install --yes` - Non-interactive installation for CI
- `link-dotfiles` - Preview convention-based links
- `link-dotfiles --apply --yes` - Create collision-free managed links
- `link-dotfiles --force --yes --apply` - Replace non-matching existing targets

## Project Structure

```text
.gitignore           # Symlink → git/.gitignore
.gitmodules          # Symlink → git/.gitmodules
home/                # Common files mapped below $HOME
home-darwin/         # macOS overrides mapped below $HOME
bin/                 # Executable scripts
├── core/            # Core utilities
├── credentials/     # Credential management
├── git/             # Git scripts and hooks
├── ide/             # IDE tooling
├── ios/             # iOS development (macOS only)
└── macos/           # macOS-specific scripts
git/                  # Git configuration (scripts in bin/git/)
├── .gitconfig
├── .gitignore       # Actual file, symlinked to root
├── .gitmodules      # Actual file, symlinked to root
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
```

## Code Quality Rules

### Shell Scripts

- **MUST** pass `shellcheck` with no errors
- **NO** COMMENT DISABLING SHELLCHECK ISSUE
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

### Local CI/CD quality gate

- Before creating or updating a pull request, run `scripts/local-ci.sh` and require every locally executable stage to pass.
- Treat a failed stage as a pull-request blocker. GitHub-only stages are recorded as skips in the results table.
- The runner isolates each macOS stage in a temporary workspace with its own `HOME`, XDG configuration, cache, state, and temporary paths. It must not write to the developer environment.
- The GitHub-only script help-message probe is intentionally skipped locally because arbitrary `--help` handlers may access host credentials or services.
- When changing macOS jobs in `.github/workflows/`, update `scripts/local-ci.sh` in the same change so its stage names, runtime pins, filesystem isolation, and destructive-stage handling match the workflow.
- Re-run the local CI executor after macOS workflow changes and require the updated executable stages to pass before creating or updating the pull request.

## Agent infrastructure

### Required startup

For agent-infrastructure changes, read `CLAUDE.md`, `docs/domain.md`,
`docs/sop-conventions.md`, and `learnings/CORRECTIONS.md` before editing.

### Skill lifecycle

No skill becomes permanent without collection, induction, deduction,
de-duplication, and explicit human approval. Stage drafts only under the
harness-specific `_candidates/<skill-name>/` directory. Do not promote a
candidate or record it as active without approval.

### Quality

- Run `uv run scripts/qa_repository.py .` before completing agent-infrastructure changes.
- Request a fresh agent review using `qa/QA_AGENT.md` after deterministic QA passes.
- Never enable or execute an external skill source before review.
- Do not place credentials, tokens, or private URLs in generated prompts or workflows.
