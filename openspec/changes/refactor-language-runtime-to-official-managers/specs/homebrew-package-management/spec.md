## MODIFIED Requirements

### Requirement: Brewfile Package Declarations

The Brewfile SHALL declare system packages and tools, but SHALL NOT include language runtimes that have dedicated version managers (Python, Ruby, Node.js).

#### Scenario: Language runtimes excluded from Brewfile
- **WHEN** Brewfile is processed during installation
- **THEN** Python packages (`python`, `python@3.9`) are NOT present
- **AND** Node.js package (`node`) is NOT present
- **AND** rbenv package is NOT present
- **AND** Development tools (git, jq, etc.) remain present

#### Scenario: Dependencies remain for tools
- **WHEN** Brewfile installs packages
- **THEN** Dependencies like `openssl`, `libyaml`, `libffi` remain available
- **AND** Build tools remain available for version managers to compile languages

## REMOVED Requirements

### Requirement: Homebrew Language Runtime Installation

**Reason**: Language runtimes now installed via official version managers (pyenv, rbenv, nvm)

**Migration**: Remove from Brewfile, add installation in dedicated installer phases
