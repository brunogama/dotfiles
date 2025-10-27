# Implementation Tasks

## 1. Update Brewfile
- [ ] 1.1 Remove `brew "python"` from line 12
- [ ] 1.2 Remove `brew "python@3.9"` from line 13
- [ ] 1.3 Remove `brew "node"` from line 54
- [ ] 1.4 Add `brew "pyenv"` in Development Tools section
- [ ] 1.5 Add comment explaining nvm installation method
- [ ] 1.6 Verify rbenv remains in Brewfile (already present)
- [ ] 1.7 Run `brew bundle --file=Packages/Homebrew/Brewfile` to validate syntax

## 2. Update lazy-load.zsh
- [ ] 2.1 Add pyenv lazy-loading function (similar to rbenv pattern)
- [ ] 2.2 Add python command interceptor for lazy loading
- [ ] 2.3 Add pip command interceptor for lazy loading
- [ ] 2.4 Test lazy-loading with `zsh -c "python --version"`
- [ ] 2.5 Verify rbenv and nvm lazy-loading still work correctly

## 3. Update Install Script
- [ ] 3.1 Add function `install_version_managers()`
- [ ] 3.2 Add function `install_language_runtimes()`
- [ ] 3.3 Add flag `--skip-language-runtimes` support
- [ ] 3.4 Add flag `--migrate-languages` support (detect brew versions)
- [ ] 3.5 Implement nvm installation via official curl script
- [ ] 3.6 Implement pyenv Python version installation
- [ ] 3.7 Implement rbenv Ruby version installation
- [ ] 3.8 Set global default versions (pyenv global, nvm alias default, rbenv global)
- [ ] 3.9 Add PATH validation after installation
- [ ] 3.10 Add detection for existing brew-installed languages with warnings
- [ ] 3.11 Update installation phases section in install script
- [ ] 3.12 Test on fresh macOS VM or container

## 4. Documentation
- [ ] 4.1 Create `docs/guides/LANGUAGE_VERSION_MANAGEMENT.md`
- [ ] 4.2 Update `README.md` with new installation approach
- [ ] 4.3 Create `docs/guides/MIGRATION.md` for existing users
- [ ] 4.4 Update `CLAUDE.md` to reflect new package management approach
- [ ] 4.5 Add troubleshooting section for PATH issues
- [ ] 4.6 Document project-specific version files (.nvmrc, .ruby-version, .python-version)
- [ ] 4.7 Add examples for common version switching scenarios

## 5. Testing
- [ ] 5.1 Test fresh installation on macOS (with --dry-run first)
- [ ] 5.2 Test migration path from brew-installed languages
- [ ] 5.3 Verify lazy-loading adds <500ms startup time (run zsh-benchmark)
- [ ] 5.4 Test version switching with test projects
- [ ] 5.5 Verify .nvmrc, .ruby-version, .python-version auto-switching
- [ ] 5.6 Test with sample projects requiring different versions
- [ ] 5.7 Shellcheck all modified scripts
- [ ] 5.8 Validate no regression in existing functionality

## 6. CI/CD
- [ ] 6.1 Document CI-specific installation instructions
- [ ] 6.2 Add `USE_BREW_LANGUAGES` environment variable support (if needed)
- [ ] 6.3 Update GitHub Actions workflows (if any exist)
- [ ] 6.4 Test installation in CI environment

## 7. Cleanup
- [ ] 7.1 Remove any references to brew-installed languages in comments
- [ ] 7.2 Update CHANGELOG with breaking change notice
- [ ] 7.3 Archive completed proposal: `openspec archive remove-brew-language-runtimes`
- [ ] 7.4 Create GitHub issue/discussion for user feedback (if applicable)
