# Environment Management Specification Delta

## ADDED Requirements

### Requirement: Environment Switching Command
The dotfiles SHALL provide a command-line tool to switch between work and personal environments.

#### Scenario: Switch to work environment
- **WHEN** user runs `work-mode work` or `work-mode on`
- **THEN** the script SHALL set `export DOTFILES_ENV=work` in `~/.zshenv`
- **AND** the script SHALL prompt user to reload shell
- **AND** after reload, prompt SHALL display "WORK" indicator

#### Scenario: Switch to personal environment
- **WHEN** user runs `work-mode personal` or `work-mode off`
- **THEN** the script SHALL remove or comment out `DOTFILES_ENV` from `~/.zshenv`
- **AND** the script SHALL prompt user to reload shell
- **AND** after reload, prompt SHALL display "HOME:PERSONAL" indicator

#### Scenario: Check current environment
- **WHEN** user runs `work-mode status`
- **THEN** the script SHALL read `DOTFILES_ENV` from `~/.zshenv`
- **AND** display current environment (work or personal)
- **AND** show which config file is being loaded

### Requirement: Shell Reload Integration
The environment switching command SHALL offer to reload the shell automatically.

#### Scenario: Automatic shell reload
- **WHEN** user switches environments
- **THEN** the script SHALL offer to reload with `exec zsh`
- **AND** provide option to skip reload

#### Scenario: Manual shell reload
- **WHEN** user declines automatic reload
- **THEN** the script SHALL display reload command for user to run later

### Requirement: Backward Compatibility Migration
The script SHALL detect and migrate from old marker file system.

#### Scenario: Old marker file detected
- **WHEN** `~/.work-machine` file exists
- **AND** user runs the command
- **THEN** the script SHALL migrate to new DOTFILES_ENV system
- **AND** remove old marker file
- **AND** inform user of migration

### Requirement: Safe File Editing
The script SHALL safely modify `~/.zshenv` without corrupting it.

#### Scenario: Add DOTFILES_ENV variable
- **WHEN** setting work environment
- **THEN** the script SHALL check if DOTFILES_ENV already exists
- **AND** update existing line OR append new line
- **AND** preserve other content in file

#### Scenario: Remove DOTFILES_ENV variable
- **WHEN** switching to personal environment
- **THEN** the script SHALL remove or comment DOTFILES_ENV line
- **AND** preserve all other content in file

### Requirement: User Feedback
The script SHALL provide clear feedback about actions taken.

#### Scenario: Successful switch with feedback
- **WHEN** environment is changed
- **THEN** the script SHALL display success message with emoji/color
- **AND** show which environment is now active
- **AND** explain what changed
- **AND** show next steps (reload shell)

#### Scenario: Error handling
- **WHEN** an error occurs (e.g., permission denied)
- **THEN** the script SHALL display clear error message
- **AND** suggest resolution steps
- **AND** exit with non-zero status
