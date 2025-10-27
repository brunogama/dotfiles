## ADDED Requirements

### Requirement: Version Manager Installation Phase

The installer SHALL install official version managers for Python, Ruby, and Node.js using their official installation scripts.

#### Scenario: pyenv installation
- **WHEN** installer runs on a system without pyenv
- **THEN** installer downloads and executes the official pyenv installer from `https://pyenv.run`
- **AND** pyenv is installed to `$HOME/.pyenv`
- **AND** latest stable Python version is installed via `pyenv install`

#### Scenario: rbenv installation
- **WHEN** installer runs on a system without rbenv
- **THEN** installer downloads and executes the official rbenv installer
- **AND** rbenv is installed to `$HOME/.rbenv`
- **AND** latest stable Ruby version is installed via `rbenv install`

#### Scenario: nvm installation
- **WHEN** installer runs on a system without nvm
- **THEN** installer downloads and executes the official nvm installer
- **AND** nvm is installed to `$HOME/.nvm`
- **AND** latest LTS Node.js version is installed via `nvm install --lts`

#### Scenario: Skip when already installed
- **WHEN** version manager is already installed
- **THEN** installer logs success and skips installation
- **AND** optionally updates to latest manager version
- **AND** verifies installed language version

#### Scenario: Installation in dry-run mode
- **WHEN** installer runs with `--dry-run` flag
- **THEN** version manager installation is logged but not executed
- **AND** message indicates which managers would be installed

### Requirement: Latest Language Version Installation

After installing each version manager, the installer SHALL automatically install the latest stable version of each language runtime.

#### Scenario: Install latest Python
- **WHEN** pyenv is installed successfully
- **THEN** installer runs `pyenv install $(pyenv install --list | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -1)`
- **AND** sets as global default via `pyenv global`

#### Scenario: Install latest Ruby
- **WHEN** rbenv is installed successfully
- **THEN** installer runs `rbenv install $(rbenv install --list | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -1)`
- **AND** sets as global default via `rbenv global`

#### Scenario: Install latest Node.js LTS
- **WHEN** nvm is installed successfully
- **THEN** installer runs `nvm install --lts`
- **AND** sets as default via `nvm alias default 'lts/*'`

### Requirement: Installation Phase Ordering

Version manager installation SHALL occur after Homebrew bundle but before symlink creation.

#### Scenario: Correct phase order
- **WHEN** installer executes phases
- **THEN** Phase order is: Homebrew → Dependencies → Bundle → Version Managers → Symlinks → Shell → Performance
- **AND** Version managers can use Homebrew-installed build dependencies
- **AND** Symlinks can reference version manager paths
