# Refactor Language Runtime to Official Version Managers

## Why

Currently, Python, Ruby, and Node.js are installed via Homebrew, which:
- Installs only single system-wide versions (limited flexibility)
- Mixes language runtimes with system package management
- Doesn't support per-project version switching
- Uses Homebrew's build process instead of official upstream sources

The industry-standard approach uses dedicated version managers:
- **pyenv** - Official Python version manager (from python-build)
- **rbenv** - Official Ruby version manager (from ruby-build)
- **nvm** - Official Node.js version manager (from Node.js community)

These tools install directly from official language sources and provide per-project version management.

## What Changes

- Remove `python`, `python@3.9`, and `node` from Brewfile
- Remove `rbenv` from Brewfile (will install via official installer)
- Add installer phase for pyenv (official installer script)
- Add installer phase for rbenv (official installer script)
- Add installer phase for nvm (official installer script)
- Install latest stable version of each language after manager installation
- Update zsh configuration to load version managers properly
- Keep existing lazy-loading optimizations for performance
- Add version manager configuration files

## Impact

**Benefits:**
- Official upstream installations from language maintainers
- Per-project version support via `.python-version`, `.ruby-version`, `.nvmrc`
- Industry-standard tooling (most widely documented/supported)
- Better compatibility with project-specific version requirements
- Automatic installation of latest stable versions on setup
- No mixing of system packages with language runtimes

**Breaking Changes:**
- Users relying on Homebrew Python/Node paths will need to update their scripts
- PATH order changes (version manager shims take precedence)
- Homebrew-installed language tools must be uninstalled manually

**Affected specs:**
- `homebrew-package-management` - Remove language runtimes from Brewfile
- `installer` - Add version manager installation phases
- `pyenv-version-management` - Define pyenv setup and configuration
- `rbenv-version-management` - Define rbenv setup and configuration
- `nvm-version-management` - Define nvm setup and configuration

**Affected code:**
- `packages/homebrew/Brewfile` - Remove python, node, rbenv entries
- `install` script - Add pyenv, rbenv, nvm installation phases
- `zsh/.zshrc` - Ensure version managers initialize correctly
- `zsh/lib/lazy-load.zsh` - Keep lazy-loading for performance
- Documentation files referencing language installation

**Migration Path:**
1. Existing users: Run `./install` to trigger version manager installation
2. Installers will run official install scripts from:
   - pyenv: `https://pyenv.run`
   - rbenv: `https://github.com/rbenv/rbenv-installer`
   - nvm: `https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh`
3. Each manager will install the latest stable language version
4. Old Homebrew versions can be removed: `brew uninstall python ruby node rbenv`
5. Verify with `which python`, `which ruby`, `which node` pointing to shims
