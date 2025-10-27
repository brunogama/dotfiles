# Implementation Tasks

## 1. Update Homebrew Configuration

- [x] 1.1 Remove `python` from Brewfile
- [x] 1.2 Remove `python@3.9` from Brewfile
- [x] 1.3 Remove `node` from Brewfile
- [x] 1.4 Remove `rbenv` from Brewfile
- [x] 1.5 Keep build dependencies (openssl, libyaml, libffi)
- [x] 1.6 Verify Brewfile syntax is valid
- [x] 1.7 Test Brewfile with `brew bundle check`

## 2. Add pyenv Installation to Installer

- [x] 2.1 Create `phase_pyenv()` function in install script
- [x] 2.2 Check if `$HOME/.pyenv` exists
- [x] 2.3 Download and execute official pyenv installer from `https://pyenv.run`
- [x] 2.4 Add dry-run support for pyenv installation
- [x] 2.5 Add confirmation prompt for pyenv installation
- [x] 2.6 Determine latest stable Python version
- [x] 2.7 Install latest Python via `pyenv install <version>`
- [x] 2.8 Set global Python version via `pyenv global <version>`
- [x] 2.9 Verify installation with `pyenv version`
- [x] 2.10 Add error handling for failed installations
- [x] 2.11 Log success/failure messages

## 3. Add rbenv Installation to Installer

- [x] 3.1 Create `phase_rbenv()` function in install script
- [x] 3.2 Check if `$HOME/.rbenv` exists
- [x] 3.3 Download and execute official rbenv-installer
- [x] 3.4 Add dry-run support for rbenv installation
- [x] 3.5 Add confirmation prompt for rbenv installation
- [x] 3.6 Determine latest stable Ruby version
- [x] 3.7 Install latest Ruby via `rbenv install <version>`
- [x] 3.8 Set global Ruby version via `rbenv global <version>`
- [x] 3.9 Install bundler gem via `gem install bundler`
- [x] 3.10 Run `rbenv rehash` to update shims
- [x] 3.11 Verify installation with `rbenv version`
- [x] 3.12 Add error handling for failed installations
- [x] 3.13 Log success/failure messages

## 4. Add nvm Installation to Installer

- [x] 4.1 Create `phase_nvm()` function in install script
- [x] 4.2 Check if `$HOME/.nvm` exists
- [x] 4.3 Download and execute official nvm installer
- [x] 4.4 Add dry-run support for nvm installation
- [x] 4.5 Add confirmation prompt for nvm installation
- [x] 4.6 Source nvm.sh after installation
- [x] 4.7 Install latest LTS Node.js via `nvm install --lts`
- [x] 4.8 Set default alias via `nvm alias default 'lts/*'`
- [x] 4.9 Verify installation with `nvm current`
- [x] 4.10 Verify node and npm commands work
- [x] 4.11 Add error handling for failed installations
- [x] 4.12 Log success/failure messages

## 5. Update Installer Phase Ordering

- [x] 5.1 Call `phase_pyenv` after `phase_bundle`
- [x] 5.2 Call `phase_rbenv` after `phase_pyenv`
- [x] 5.3 Call `phase_nvm` after `phase_rbenv`
- [x] 5.4 Ensure version managers installed before symlinks
- [x] 5.5 Update phase numbering in comments and logs
- [x] 5.6 Update main() function execution order

## 6. Update Zsh Configuration

- [x] 6.1 Verify pyenv lazy-loading exists in zsh/.zshrc or lazy-load.zsh
- [x] 6.2 Verify rbenv lazy-loading exists in zsh/.zshrc or lazy-load.zsh
- [x] 6.3 Verify nvm lazy-loading exists in zsh/.zshrc or lazy-load.zsh
- [x] 6.4 Ensure NVM_DIR is set to `$HOME/.nvm`
- [x] 6.5 Ensure lazy-load triggers for `python`, `ruby`, `node`, `npm`, `gem`
- [x] 6.6 Test lazy-loading performance (should not slow zsh startup)
- [x] 6.7 Verify PATH priority (shims before system paths)

## 7. Update Documentation

- [x] 7.1 Update CLAUDE.md with version manager installation details
- [x] 7.2 Update README.md with version manager usage
- [x] 7.3 Add migration guide for existing users
- [x] 7.4 Document how to install specific language versions
- [x] 7.5 Document per-project version files (.python-version, .ruby-version, .nvmrc)
- [x] 7.6 Update installation time estimate (may take longer with language compilation)

## 8. Testing

- [x] 8.1 Test fresh installation with `./install --dry-run`
- [ ] 8.2 Test fresh installation with `./install` (requires clean environment)
- [ ] 8.3 Test skip flags (--skip-brew, --skip-packages) (requires clean environment)
- [ ] 8.4 Verify pyenv installed to `$HOME/.pyenv` (requires actual install)
- [ ] 8.5 Verify rbenv installed to `$HOME/.rbenv` (requires actual install)
- [ ] 8.6 Verify nvm installed to `$HOME/.nvm` (requires actual install)
- [ ] 8.7 Verify `which python` points to pyenv shim (requires actual install)
- [ ] 8.8 Verify `which ruby` points to rbenv shim (requires actual install)
- [ ] 8.9 Verify `which node` points to nvm-managed binary (requires actual install)
- [ ] 8.10 Test `python --version` shows installed version (requires actual install)
- [ ] 8.11 Test `ruby --version` shows installed version (requires actual install)
- [ ] 8.12 Test `node --version` shows installed version (requires actual install)
- [ ] 8.13 Test npm global package installation (no sudo required) (requires actual install)
- [ ] 8.14 Test zsh startup time (ensure lazy-loading works) (requires actual install)
- [ ] 8.15 Test on clean macOS system (VM or fresh user) (deferred)

## 9. Cleanup and Validation

- [x] 9.1 Run shellcheck on modified install script
- [x] 9.2 Ensure all functions ≤40 lines
- [x] 9.3 Ensure install script ≤600 lines
- [ ] 9.4 Test error handling (network failures, invalid versions) (deferred - requires actual install)
- [x] 9.5 Verify all log messages are clear and helpful
- [x] 9.6 Check for any hardcoded paths or versions
- [x] 9.7 Validate OpenSpec proposal: `openspec validate refactor-language-runtime-to-official-managers --strict`

## 10. Migration Support

- [x] 10.1 Add migration notes to install script output
- [x] 10.2 Detect existing Homebrew python/ruby/node and warn user
- [x] 10.3 Provide uninstall commands in summary
- [ ] 10.4 Test upgrade path (existing dotfiles with Homebrew languages) (deferred - requires actual install)
- [ ] 10.5 Verify existing projects work after migration (deferred - requires actual install)
