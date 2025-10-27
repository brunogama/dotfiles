## ADDED Requirements

### Requirement: pyenv Installation

The system SHALL install pyenv using the official pyenv-installer script from `https://pyenv.run`.

#### Scenario: Install via official script
- **WHEN** pyenv is not present in `$HOME/.pyenv`
- **THEN** installer downloads the official pyenv installer
- **AND** executes the installer script
- **AND** pyenv binary is available at `$HOME/.pyenv/bin/pyenv`

#### Scenario: Skip if already installed
- **WHEN** `$HOME/.pyenv` directory exists
- **THEN** installation is skipped
- **AND** success message is logged

### Requirement: pyenv Shell Integration

The zsh configuration SHALL initialize pyenv using lazy-loading for performance.

#### Scenario: Lazy-load pyenv
- **WHEN** zsh starts up
- **THEN** pyenv is NOT immediately initialized
- **AND** `python` command trigger lazy initialization
- **AND** pyenv shims directory is added to PATH after initialization

#### Scenario: PATH priority
- **WHEN** pyenv is initialized
- **THEN** `$HOME/.pyenv/shims` appears before system Python paths
- **AND** `which python` resolves to pyenv shim

### Requirement: Python Version Installation

After pyenv installation, the system SHALL install the latest stable Python version.

#### Scenario: Install latest stable Python
- **WHEN** pyenv is freshly installed
- **THEN** installer determines latest stable version from `pyenv install --list`
- **AND** installs that version via `pyenv install <version>`
- **AND** sets it as global default via `pyenv global <version>`
- **AND** verifies installation with `pyenv version`

#### Scenario: Verify Python executable
- **WHEN** Python installation completes
- **THEN** `python --version` shows the installed version
- **AND** `which python` points to `$HOME/.pyenv/shims/python`
