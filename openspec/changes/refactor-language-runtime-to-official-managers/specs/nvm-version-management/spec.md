## ADDED Requirements

### Requirement: nvm Installation

The system SHALL install nvm using the official nvm installer script.

#### Scenario: Install via official script
- **WHEN** nvm is not present in `$HOME/.nvm`
- **THEN** installer downloads the official nvm installer from `https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh`
- **AND** executes the installer script
- **AND** nvm is available at `$HOME/.nvm/nvm.sh`

#### Scenario: Skip if already installed
- **WHEN** `$HOME/.nvm` directory exists
- **THEN** installation is skipped
- **AND** success message is logged

### Requirement: nvm Shell Integration

The zsh configuration SHALL source nvm using lazy-loading for performance.

#### Scenario: Lazy-load nvm
- **WHEN** zsh starts up
- **THEN** nvm is NOT immediately sourced
- **AND** `node`, `npm`, `npx` commands trigger lazy initialization
- **AND** nvm initialization sources `$HOME/.nvm/nvm.sh`

#### Scenario: NVM_DIR environment variable
- **WHEN** shell initializes
- **THEN** `NVM_DIR` is set to `$HOME/.nvm`
- **AND** nvm functions are available after lazy-load trigger

### Requirement: Node.js Version Installation

After nvm installation, the system SHALL install the latest LTS version of Node.js.

#### Scenario: Install latest LTS Node.js
- **WHEN** nvm is freshly installed
- **THEN** installer runs `nvm install --lts`
- **AND** sets LTS as default via `nvm alias default 'lts/*'`
- **AND** verifies installation with `nvm current`

#### Scenario: Verify Node.js executable
- **WHEN** Node.js installation completes
- **THEN** `node --version` shows the installed LTS version
- **AND** `npm --version` shows the bundled npm version
- **AND** `which node` points to nvm-managed Node.js binary

#### Scenario: npm global packages location
- **WHEN** Node.js is installed via nvm
- **THEN** global npm packages install to `$HOME/.nvm/versions/node/<version>/lib/node_modules`
- **AND** global binaries install to `$HOME/.nvm/versions/node/<version>/bin`
- **AND** no sudo required for global package installation
