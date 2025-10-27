# Remove Language Runtimes from Homebrew

## Why

Installing language runtimes (Python, Node, Ruby) via Homebrew creates version management conflicts and limits flexibility. Official installation methods (pyenv, nvm, rbenv) provide better version control, project-specific versions, and don't interfere with system tools or other package managers.

Current issues:
- Homebrew updates can break project-specific version requirements
- Cannot easily switch between multiple versions per project
- Conflicts with mise, nvm, rbenv that are already configured in lazy-load.zsh
- Brew-installed versions take precedence over version managers

## What Changes

- Remove `python`, `python@3.9` from Brewfile
- Remove `node` from Brewfile
- Keep `rbenv` in Brewfile initially (manages Ruby versions, not Ruby itself)
- Add installation instructions in install script for official methods:
  - Python: via pyenv or python.org official installer
  - Node: via nvm (already lazy-loaded in lazy-load.zsh)
  - Ruby: via rbenv + ruby-build (already lazy-loaded in lazy-load.zsh)
- Update documentation to reflect new installation approach
- Validate that lazy-load.zsh properly handles these version managers

## Impact

- Affected specs: package-management (new capability)
- Affected code:
  - `Packages/Homebrew/Brewfile` (remove lines 12-13, 54)
  - `install` script (add language runtime installation logic)
  - `docs/guides/` (update installation documentation)
  - `Zsh/lib/lazy-load.zsh` (already supports rbenv, nvm - validate works)
- Migration: Users must manually uninstall brew-installed languages and install via official methods
- Benefits:
  - Better version control per project
  - No conflicts with version managers
  - Industry-standard approach
  - Consistent with existing lazy-load.zsh setup
