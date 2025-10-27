# Package Management Capability

## ADDED Requirements

### Requirement: Language Version Manager Integration
The dotfiles system SHALL provide language-specific version managers for Python, Node.js, and Ruby instead of installing single versions via Homebrew.

#### Scenario: Python version management via pyenv
- **WHEN** a user runs the install script
- **THEN** pyenv SHALL be installed via Homebrew
- **AND** pyenv SHALL NOT have Python runtimes installed by default via Homebrew
- **AND** the install script SHALL install at least one Python version via pyenv
- **AND** a global default Python version SHALL be set via `pyenv global`

#### Scenario: Node version management via nvm
- **WHEN** a user runs the install script
- **THEN** nvm SHALL be installed via official curl script (not Homebrew)
- **AND** Node.js SHALL NOT be installed via Homebrew
- **AND** the install script SHALL install the latest LTS Node version via nvm
- **AND** a default Node version SHALL be set via `nvm alias default`

#### Scenario: Ruby version management via rbenv
- **WHEN** a user runs the install script
- **THEN** rbenv SHALL be installed via Homebrew
- **AND** Ruby SHALL NOT be installed via Homebrew
- **AND** the install script SHALL install at least one Ruby version via rbenv
- **AND** a global default Ruby version SHALL be set via `rbenv global`

#### Scenario: Project-specific version detection
- **WHEN** a user navigates to a directory with version files (.nvmrc, .ruby-version, .python-version)
- **THEN** the respective version manager SHALL automatically switch to the specified version
- **AND** if the specified version is not installed, the user SHALL be prompted to install it

### Requirement: Lazy Loading Integration
The dotfiles system SHALL lazy-load version manager initialization to maintain shell startup performance.

#### Scenario: pyenv lazy loading
- **WHEN** a user invokes `python`, `pip`, or `pyenv` commands
- **THEN** pyenv SHALL be initialized on first use
- **AND** subsequent calls SHALL use the initialized environment
- **AND** shell startup time SHALL NOT increase by more than 50ms

#### Scenario: nvm lazy loading
- **WHEN** a user invokes `node`, `npm`, `npx`, or `nvm` commands
- **THEN** nvm SHALL be initialized on first use
- **AND** subsequent calls SHALL use the initialized environment
- **AND** shell startup time SHALL NOT increase by more than 50ms

#### Scenario: rbenv lazy loading
- **WHEN** a user invokes `ruby`, `gem`, or `rbenv` commands
- **THEN** rbenv SHALL be initialized on first use
- **AND** subsequent calls SHALL use the initialized environment
- **AND** shell startup time SHALL NOT increase by more than 50ms

### Requirement: Installation Script Language Runtime Phase
The install script SHALL include a dedicated phase for installing language runtimes via version managers.

#### Scenario: Skip language runtime installation
- **WHEN** a user runs install with `--skip-language-runtimes` flag
- **THEN** version managers SHALL still be installed
- **AND** language runtimes SHALL NOT be installed
- **AND** the install script SHALL complete successfully

#### Scenario: Default language runtime installation
- **WHEN** a user runs install without skip flags
- **THEN** the install script SHALL install pyenv, nvm, and rbenv
- **AND** the install script SHALL install latest stable Python 3.x via pyenv
- **AND** the install script SHALL install latest LTS Node via nvm
- **AND** the install script SHALL install latest stable Ruby 3.x via rbenv
- **AND** global default versions SHALL be set for all languages

#### Scenario: Migration from brew-installed languages
- **WHEN** a user runs install with `--migrate-languages` flag
- **AND** Homebrew-installed Python, Node, or Ruby are detected
- **THEN** the install script SHALL warn about conflicts
- **AND** the install script SHALL offer to uninstall brew versions
- **AND** after uninstallation, version manager versions SHALL be installed

### Requirement: Brewfile Language Runtime Exclusion
The Brewfile SHALL NOT include direct language runtime installations.

#### Scenario: Python not in Brewfile
- **WHEN** the Brewfile is processed
- **THEN** `brew "python"` SHALL NOT be present
- **AND** `brew "python@3.9"` SHALL NOT be present
- **AND** `brew "pyenv"` SHALL be present

#### Scenario: Node not in Brewfile
- **WHEN** the Brewfile is processed
- **THEN** `brew "node"` SHALL NOT be present
- **AND** a comment SHALL indicate nvm installation via official method

#### Scenario: Ruby not in Brewfile
- **WHEN** the Brewfile is processed
- **THEN** `brew "ruby"` SHALL NOT be present
- **AND** `brew "rbenv"` SHALL be present

### Requirement: PATH Configuration Validation
The install script SHALL validate that version manager shims appear in PATH before Homebrew binaries.

#### Scenario: Correct PATH order after installation
- **WHEN** the install script completes
- **THEN** `which python` SHALL point to pyenv shim (if pyenv installed)
- **AND** `which node` SHALL point to nvm-managed node (if nvm installed)
- **AND** `which ruby` SHALL point to rbenv shim (if rbenv installed)
- **AND** the install script SHALL warn if PATH order is incorrect

### Requirement: Documentation of Version Management
The system SHALL provide comprehensive documentation for language version management.

#### Scenario: Language version management guide exists
- **WHEN** a user reads documentation
- **THEN** `docs/guides/LANGUAGE_VERSION_MANAGEMENT.md` SHALL exist
- **AND** it SHALL document how to install specific versions
- **AND** it SHALL document how to switch versions per project
- **AND** it SHALL document version file formats (.nvmrc, .ruby-version, .python-version)

#### Scenario: Migration guide exists
- **WHEN** an existing user needs to migrate from brew-installed languages
- **THEN** `docs/guides/MIGRATION.md` SHALL exist
- **AND** it SHALL provide step-by-step migration instructions
- **AND** it SHALL document common issues and solutions
- **AND** it SHALL include troubleshooting for PATH issues

## REMOVED Requirements

None (this is a new capability).

## MODIFIED Requirements

None (this is a new capability).
