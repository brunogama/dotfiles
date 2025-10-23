# Contributing to Bruno's Dotfiles

Thank you for considering contributing! This guide will help you understand our workflow and standards.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Updating the CHANGELOG](#updating-the-changelog)
- [Commit Message Format](#commit-message-format)
- [Code Quality Standards](#code-quality-standards)
- [Pull Request Process](#pull-request-process)

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what is best for the project
- Show empathy towards other contributors

## Getting Started

### 1. Fork and Clone

```bash
# Fork the repository on GitHub, then:
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles
```

### 2. Install Development Dependencies

```bash
# Install pre-commit
brew install pre-commit  # macOS
# or
pip install pre-commit   # Linux/pip

# Install the git hooks
pre-commit install

# Test that hooks are installed
pre-commit run --all-files
```

### 3. Create a Branch

```bash
git checkout -b feature/my-new-feature
# or
git checkout -b fix/bug-description
```

## Development Workflow

### 1. Make Your Changes

- Edit files in `config/`, `scripts/`, or `docs/`
- Test your changes locally
- Follow existing code style and conventions

### 2. Test Your Changes

```bash
# Dry-run installation
make test

# Test specific components
make install-zsh
make install-git
make install-scripts

# Run shellcheck on modified scripts
shellcheck scripts/category/your-script.sh
```

### 3. Update Documentation

- Update relevant documentation in `docs/`
- Update man pages if adding/modifying scripts
- Update README.md if adding major features

### 4. Update CHANGELOG

**Required for user-facing changes** (feat, fix, perf, refactor)

See [Updating the CHANGELOG](#updating-the-changelog) below.

### 5. Commit Your Changes

```bash
git add .
git commit -m "type: description"
```

Pre-commit hooks will run automatically. Fix any issues they report.

### 6. Push and Create Pull Request

```bash
git push origin feature/my-new-feature
```

Then create a pull request on GitHub.

## Updating the CHANGELOG

### When to Update

**Required:**

- `feat:` - New features
- `fix:` - Bug fixes
- `perf:` - Performance improvements
- `refactor:` - User-visible refactoring

**Not Required:**

- `chore:` - Maintenance tasks
- `docs:` - Documentation-only changes
- `test:` - Test-only changes
- `ci:` - CI/CD configuration
- `build:` - Build system changes
- `style:` - Code style changes (no logic change)

### How to Update

Add your change to the `[Unreleased]` section in `CHANGELOG.md`:

#### For New Features (`feat:`)

```markdown
## [Unreleased]

### Added
- Environment switching with `work-mode` command
- Interactive shell reload option
- Background sync service daemon
```

#### For Bug Fixes (`fix:`)

```markdown
## [Unreleased]

### Fixed
- Git repository initialization when .git file is corrupted
- Broken symlinks in ZSH configuration
- Missing environment variable in work-mode script
```

#### For Changes (`perf:`, `refactor:`)

```markdown
## [Unreleased]

### Changed
- Improved performance of home-sync by 50%
- Refactored work-mode to use environment variables
- Updated credential storage to use native keychain
```

#### For Breaking Changes

```markdown
## [Unreleased]

### Changed
- **BREAKING**: work-mode now uses ~/.zshenv instead of marker file
  - Migration: Old ~/.work-machine file will be automatically converted
```

### Writing Good CHANGELOG Entries

**✅ Good (user-focused):**

- "Environment switching between work and personal configurations"
- "Interactive shell reload after environment changes"
- "Git repository recovery when .git file is corrupted"

**❌ Bad (implementation-focused):**

- "Refactored work-mode script to use ~/.zshenv"
- "Changed git init logic to backup first"
- "Added new function get_current_env()"

**Rules:**

- Focus on user impact, not implementation details
- Use present tense ("Add feature" not "Added feature")
- Be concise but descriptive
- Include command names in backticks
- For breaking changes, include migration instructions

## Commit Message Format

We use [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>: <description>

[optional body]

[optional footer]
```

### Types

- `feat:` - New feature
- `fix:` - Bug fix
- `perf:` - Performance improvement
- `refactor:` - Code refactoring
- `docs:` - Documentation changes
- `test:` - Test additions/changes
- `chore:` - Maintenance tasks
- `ci:` - CI/CD changes
- `build:` - Build system changes
- `style:` - Code style changes (formatting)

### Examples

```bash
# New feature
git commit -m "feat: add environment switching with work-mode command"

# Bug fix
git commit -m "fix: resolve broken symlinks in git configuration"

# Breaking change
git commit -m "refactor!: change work-mode to use environment variables

BREAKING CHANGE: work-mode now uses ~/.zshenv instead of ~/.work-machine.
Old marker file will be automatically migrated on first run."

# Documentation
git commit -m "docs: add CHANGELOG enforcement guide to CONTRIBUTING.md"

# Chore (no CHANGELOG needed)
git commit -m "chore: update .gitignore for pre-commit cache"
```

## Code Quality Standards

### Shell Scripts

All shell scripts **must**:

```bash
# 1. Start with shebang and safety flags
#!/usr/bin/env bash
set -euo pipefail

# 2. Pass shellcheck with no errors
shellcheck scripts/your-script.sh

# 3. Use proper quoting
echo "$variable"          # ✅ Good
echo $variable            # ❌ Bad

# 4. Use [[ over [
if [[ -f "$file" ]]; then  # ✅ Good
if [ -f "$file" ]; then    # ❌ Acceptable but prefer [[

# 5. Include helpful comments
# Function: Gets current environment
# Returns: "work" or "personal"
get_current_env() {
    # ...
}
```

### Python Scripts

All Python scripts **must**:

```python
# 1. Use uv for dependency management
#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.11"
# dependencies = ["requests"]
# ///

# 2. Follow PEP 8 (enforced by black)
# 3. Use type hints
def get_config(name: str) -> dict:
    """Get configuration by name."""
    # ...

# 4. Pass black and isort
black your-script.py
isort your-script.py
```

### YAML/JSON Files

```yaml
# Use consistent indentation (2 spaces for YAML)
config:
  option: value
  nested:
    item: value
```

## Pull Request Process

### 1. Before Submitting

- [ ] All tests pass (`make test`)
- [ ] Pre-commit hooks pass (`pre-commit run --all-files`)
- [ ] CHANGELOG updated (if user-facing)
- [ ] Documentation updated
- [ ] Shellcheck passes for new/modified scripts
- [ ] Commit messages follow conventional format

### 2. Pull Request Description

Include:

- **What**: Brief description of changes
- **Why**: Reason for the change
- **How**: Implementation approach (if complex)
- **Testing**: How you tested the changes
- **Breaking Changes**: Any breaking changes and migration path

Example:

```markdown
## What
Add CHANGELOG enforcement through pre-commit hooks

## Why
Contributors were forgetting to document user-facing changes, making it
difficult to generate release notes and communicate changes to users.

## How
- Created CHANGELOG.md following Keep a Changelog format
- Added .pre-commit-config.yaml with validation hook
- Created scripts/validate-changelog.sh to enforce updates
- Updated documentation

## Testing
- Tested feat commit without CHANGELOG (fails ✓)
- Tested feat commit with CHANGELOG (passes ✓)
- Tested chore commit without CHANGELOG (passes ✓)
- Ran `pre-commit run --all-files` (all pass ✓)

## Breaking Changes
None
```

### 3. Review Process

- Maintainer will review within 48 hours
- Address any feedback or requested changes
- Once approved, maintainer will merge

### 4. After Merge

- Delete your feature branch
- Pull latest main: `git checkout main && git pull`
- Your change will be in the next release!

## Questions?

- Check [ONBOARDING.md](ONBOARDING.md) for comprehensive documentation
- Check [README.md](README.md) for quick reference
- Open an issue for questions or discussion

## Thank You

Your contributions help make this project better for everyone. We appreciate your time and effort! 🎉
