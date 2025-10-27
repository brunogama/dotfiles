# Shell Environment Specification Delta

## ADDED Requirements

### Requirement: Environment Detection and Configuration Loading
The shell configuration SHALL automatically detect and load the appropriate environment configuration (work or personal) based on user preference.

#### Scenario: Work environment selected
- **WHEN** `DOTFILES_ENV` environment variable is set to "work"
- **THEN** the shell SHALL source `work-config.zsh`
- **AND** the `WORK_ENV` variable SHALL be set
- **AND** the prompt SHALL display "WORK" or "WORK:DEFAULT" indicator

#### Scenario: Personal environment selected
- **WHEN** `DOTFILES_ENV` environment variable is set to "personal"
- **THEN** the shell SHALL source `personal-config.zsh`
- **AND** the `HOME_ENV` variable SHALL be set
- **AND** the prompt SHALL display "HOME:PERSONAL" indicator

#### Scenario: No environment specified (default behavior)
- **WHEN** no `DOTFILES_ENV` environment variable is set
- **THEN** the shell SHALL source `personal-config.zsh` as default
- **AND** the prompt SHALL display "HOME:PERSONAL" indicator

### Requirement: Prompt Environment Indicator
The shell prompt SHALL visually display the current environment context using the existing `prompt_env_context` function.

#### Scenario: Work environment indicator displayed
- **WHEN** `WORK_ENV` variable is set
- **THEN** the prompt SHALL display "WORK" text in orange color (color code 208)
- **AND** if `WORK_ENV` has a value (e.g., "development"), it SHALL be appended as "WORK:DEVELOPMENT"

#### Scenario: Home environment indicator displayed
- **WHEN** `HOME_ENV` variable is set
- **THEN** the prompt SHALL display "HOME" text in blue color (color code 39)
- **AND** if `HOME_ENV` has a value (e.g., "personal"), it SHALL be appended as "HOME:PERSONAL"

#### Scenario: No environment indicator when variables unset
- **WHEN** neither `WORK_ENV` nor `HOME_ENV` nor `PROMPT_ENVIRONMENT` are set
- **THEN** the prompt SHALL NOT display any environment indicator

### Requirement: Work Environment Configuration
The work configuration SHALL set appropriate environment variables to enable work-specific features and prompt indicators.

#### Scenario: Work environment initialized
- **WHEN** `work-config.zsh` is sourced
- **THEN** the `WORK_ENV` variable SHALL be set to "work" by default
- **AND** work-specific aliases and functions SHALL be available
- **AND** the prompt SHALL reflect the work environment state

### Requirement: Environment Switching
Users SHALL be able to switch environments by setting the `DOTFILES_ENV` variable before starting a new shell.

#### Scenario: Switch to work environment
- **WHEN** user sets `export DOTFILES_ENV=work` in their shell profile
- **THEN** new shell sessions SHALL load work configuration
- **AND** the prompt SHALL display work environment indicator

#### Scenario: Switch to personal environment
- **WHEN** user sets `export DOTFILES_ENV=personal` in their shell profile
- **THEN** new shell sessions SHALL load personal configuration
- **AND** the prompt SHALL display home environment indicator
