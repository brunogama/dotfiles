## ADDED Requirements

### Requirement: rbenv Installation

The system SHALL install rbenv using the official rbenv-installer script from GitHub.

#### Scenario: Install via official script
- **WHEN** rbenv is not present in `$HOME/.rbenv`
- **THEN** installer downloads the official rbenv-installer
- **AND** executes the installer script
- **AND** rbenv binary is available at `$HOME/.rbenv/bin/rbenv`

#### Scenario: Skip if already installed
- **WHEN** `$HOME/.rbenv` directory exists
- **THEN** installation is skipped
- **AND** success message is logged

### Requirement: rbenv Shell Integration

The zsh configuration SHALL initialize rbenv using lazy-loading for performance.

#### Scenario: Lazy-load rbenv
- **WHEN** zsh starts up
- **THEN** rbenv is NOT immediately initialized
- **AND** `ruby`, `gem`, `bundle` commands trigger lazy initialization
- **AND** rbenv shims directory is added to PATH after initialization

#### Scenario: PATH priority
- **WHEN** rbenv is initialized
- **THEN** `$HOME/.rbenv/shims` appears before system Ruby paths
- **AND** `which ruby` resolves to rbenv shim

### Requirement: Ruby Version Installation

After rbenv installation, the system SHALL install the latest stable Ruby version.

#### Scenario: Install latest stable Ruby
- **WHEN** rbenv is freshly installed
- **THEN** installer determines latest stable version from `rbenv install --list`
- **AND** installs that version via `rbenv install <version>`
- **AND** sets it as global default via `rbenv global <version>`
- **AND** verifies installation with `rbenv version`

#### Scenario: Verify Ruby executable
- **WHEN** Ruby installation completes
- **THEN** `ruby --version` shows the installed version
- **AND** `which ruby` points to `$HOME/.rbenv/shims/ruby`
- **AND** `gem` and `bundle` commands are available

#### Scenario: Install bundler gem
- **WHEN** Ruby installation completes
- **THEN** installer runs `gem install bundler`
- **AND** bundler is available globally
- **AND** `rbenv rehash` updates shims
