# Credential Security Specification

## MODIFIED Requirements

### Requirement: Secure Credential Input Methods
The credential storage system SHALL provide multiple secure input methods that prevent exposure in shell history, process lists, and terminal output.

#### Scenario: Interactive Mode Default
- **GIVEN** user runs `store-api-key "MY_KEY"` without value argument
- **WHEN** terminal is a TTY
- **THEN** system prompts "Enter value for MY_KEY:"
- **AND** input is hidden (not echoed to terminal)
- **AND** value is stored in Keychain
- **AND** command in history shows only `store-api-key "MY_KEY"`

#### Scenario: Stdin Mode for Automation
- **GIVEN** user runs `echo "secret" | store-api-key "MY_KEY" --stdin`
- **WHEN** secret is piped via stdin
- **THEN** system reads value from stdin without prompting
- **AND** value is stored in Keychain
- **AND** no secret appears in command line
- **AND** command in history shows only `... | store-api-key "MY_KEY" --stdin`

#### Scenario: File Mode for Persistent Secrets
- **GIVEN** file `~/.secrets/api.key` contains secret value
- **AND** file has permissions 600 (owner read/write only)
- **WHEN** user runs `store-api-key "MY_KEY" --from-file ~/.secrets/api.key`
- **THEN** system reads value from file
- **AND** value is stored in Keychain
- **AND** no secret appears in command line

#### Scenario: File Mode Permission Check
- **GIVEN** file `~/.secrets/api.key` has permissions 644 (world-readable)
- **WHEN** user runs `store-api-key "MY_KEY" --from-file ~/.secrets/api.key`
- **THEN** system rejects with error "File permissions too open (644), must be 600"
- **AND** no value is stored

#### Scenario: Non-TTY Interactive Failure
- **GIVEN** script runs `store-api-key "MY_KEY"` without value
- **AND** stdin is not a TTY (e.g., cron job, CI)
- **WHEN** no --stdin or --from-file flag provided
- **THEN** system exits with error "Not a TTY, use --stdin or --from-file"
- **AND** exit code is 2

### Requirement: Backward Compatibility with Warnings
The system SHALL maintain backward compatibility with old positional argument usage while warning users of security risks.

#### Scenario: Legacy Positional Arguments with Warning
- **GIVEN** user runs `store-api-key "MY_KEY" "secret-value"`
- **WHEN** both key and value are provided as positional args
- **THEN** system displays warning to stderr:
  ```
  [WARNING]  WARNING: Passing secrets as command arguments exposes them in shell history!
  [WARNING]  Use --stdin, --from-file, or interactive mode instead.
  [WARNING]  This usage will be deprecated in v2.0
  ```
- **AND** value is still stored (backward compatible)
- **AND** warning is shown every time (not suppressed)

#### Scenario: Suppress Warning Flag
- **GIVEN** user runs `store-api-key "MY_KEY" "secret-value" --no-warning`
- **WHEN** --no-warning flag is provided
- **THEN** no warning is displayed
- **AND** value is stored normally
- **AND** useful for scripts that cannot be immediately migrated

### Requirement: CredMatch Secure Master Password Input
The credmatch system SHALL support secure master password input to prevent exposure.

#### Scenario: Interactive Master Password Prompt
- **GIVEN** user runs `credmatch store "MY_KEY" "secret-value"`
- **WHEN** master password is not provided
- **THEN** system prompts "Enter master password:"
- **AND** input is hidden
- **AND** credential is stored with encrypted master password
- **AND** command in history shows `credmatch store "MY_KEY" "secret-value"`

#### Scenario: Master Password from Stdin
- **GIVEN** user runs `echo "master-pass" | credmatch store --master-stdin "KEY" "value"`
- **WHEN** --master-stdin flag provided
- **THEN** system reads master password from stdin
- **AND** credential is stored
- **AND** no password visible in command line

#### Scenario: Master Password from Environment
- **GIVEN** environment variable `CREDMATCH_MASTER_PASSWORD="my-pass"` is set
- **WHEN** user runs `credmatch store "KEY" "value"`
- **AND** no master password argument provided
- **THEN** system reads from environment variable
- **AND** credential is stored
- **AND** no password visible in command line

#### Scenario: Master Password from Keychain (Preferred)
- **GIVEN** master password stored via `store-api-key "CREDMATCH_MASTER_PASSWORD" "pass"`
- **WHEN** user runs `credmatch store "KEY" "value"`
- **THEN** system automatically retrieves master password from Keychain
- **AND** no prompting occurs
- **AND** credential is stored
- **AND** fully automated secure workflow

### Requirement: CredFile Secure Usage
The credfile wrapper SHALL use secure input methods internally and expose same security to users.

#### Scenario: CredFile Uses Secure Master Password
- **GIVEN** master password stored in Keychain as `CREDMATCH_MASTER_PASSWORD`
- **WHEN** user runs `credfile put "my-file" ~/secret.txt`
- **THEN** credfile retrieves master password from Keychain via `get-api-key`
- **AND** calls credmatch with secure method
- **AND** no master password appears in process list

#### Scenario: CredFile Value Input Secured
- **GIVEN** user stores file with credfile
- **WHEN** credfile internally calls credmatch
- **THEN** credfile uses stdin or environment variable method
- **AND** never uses positional arguments with secrets
- **AND** no secrets visible in process list

### Requirement: Process List Protection
Secrets SHALL NOT appear in process list (`ps aux`, `top`, etc.) during execution.

#### Scenario: No Secrets in Process Arguments
- **GIVEN** user runs `store-api-key "KEY"` in interactive mode
- **WHEN** another user runs `ps aux` during execution
- **THEN** process list shows `store-api-key "KEY"` only
- **AND** no secret value is visible
- **AND** works even during prompt waiting

#### Scenario: No Secrets in Environment (Optionally)
- **GIVEN** user runs `CREDMATCH_MASTER_PASSWORD="secret" credmatch store ...`
- **WHEN** another user runs `ps auxe` (shows environment)
- **THEN** environment variables MAY be visible (platform-dependent)
- **AND** documentation warns about this
- **AND** recommends Keychain method instead

### Requirement: Shell History Protection
Secrets SHALL NOT be recorded in shell history files.

#### Scenario: Interactive Mode Leaves Clean History
- **GIVEN** user runs `store-api-key "OPENAI_API_KEY"` interactively
- **AND** enters secret at prompt
- **WHEN** user runs `history | grep store-api-key`
- **THEN** history shows `store-api-key "OPENAI_API_KEY"` only
- **AND** no secret value appears

#### Scenario: Stdin Mode Leaves Clean History
- **GIVEN** user runs `cat secret.txt | store-api-key "KEY" --stdin`
- **WHEN** user runs `history | grep store-api-key`
- **THEN** history shows `cat secret.txt | store-api-key "KEY" --stdin`
- **AND** no secret value appears (assuming secret.txt is generic filename)

#### Scenario: File Mode Leaves Clean History
- **GIVEN** user runs `store-api-key "KEY" --from-file ~/.secrets/api.key`
- **WHEN** user runs `history | grep store-api-key`
- **THEN** history shows full command with file path
- **AND** no secret value appears

### Requirement: History Cleanup Utility
System SHALL provide utility to detect and remove potentially exposed secrets from history.

#### Scenario: Clear Sensitive History Commands
- **GIVEN** history contains `store-api-key "KEY" "exposed-secret"`
- **WHEN** user runs `clear-secret-history`
- **THEN** system searches history for credential commands with suspicious patterns
- **AND** shows preview: "Found 3 potentially sensitive commands:"
- **AND** prompts: "Remove these from history? (y/N)"
- **AND** if yes, removes lines from `~/.zsh_history` and `~/.bash_history`
- **AND** confirms: "Removed 3 commands from history"

#### Scenario: Clear History Patterns Detected
- **GIVEN** history file contains various credential commands
- **WHEN** `clear-secret-history` scans history
- **THEN** system detects patterns:
  - `store-api-key ".*" ".*"` (two string args)
  - `credmatch store ".*" ".*" ".*"` (three string args)
  - `export .*PASSWORD=.*` (password in export)
  - `MASTER_PASSWORD=".*"` (inline password)
- **AND** flags for review/removal

## ADDED Requirements

### Requirement: Documentation Security Updates
All documentation SHALL use secure credential input patterns exclusively.

#### Scenario: Documentation Examples Are Secure
- **GIVEN** documentation files (ONBOARDING.md, README_IMPROVEMENTS.md, etc.)
- **WHEN** reviewed for credential examples
- **THEN** all examples use:
  - Interactive mode: `store-api-key "KEY"` (no value)
  - Stdin mode: `echo "..." | store-api-key "KEY" --stdin`
  - File mode: `store-api-key "KEY" --from-file file`
- **AND** no examples use positional value arguments
- **AND** security warnings are prominently displayed

#### Scenario: Security Warning Banner in Docs
- **GIVEN** credential management documentation section
- **WHEN** user reads documentation
- **THEN** clear security warning is displayed at top:
  ```
  [WARNING]  SECURITY WARNING
  Never pass secrets as command-line arguments!
  Always use interactive mode, stdin, or file input.
  Command-line arguments are exposed in:
  - Shell history (~/.zsh_history)
  - Process lists (ps aux)
  - Terminal recordings
  - System logs
  ```

### Requirement: Help Text Security Guidance
Command help text SHALL guide users toward secure usage patterns.

#### Scenario: Help Shows Secure Examples First
- **GIVEN** user runs `store-api-key --help`
- **WHEN** help text is displayed
- **THEN** interactive mode is listed first
- **AND** stdin/file modes listed second
- **AND** positional args listed last with warning
- **AND** examples show secure patterns

#### Scenario: Help Includes Security Section
- **GIVEN** user runs `credmatch --help`
- **WHEN** help text is displayed
- **THEN** includes "SECURITY BEST PRACTICES" section
- **AND** explains exposure risks
- **AND** recommends Keychain for master password

## Testing Requirements

### Requirement: Automated Security Tests
Test suite SHALL verify secrets are not exposed through common attack vectors.

#### Scenario: Test Shell History Does Not Contain Secrets
- **GIVEN** test runs `store-api-key "TEST_KEY"` with hidden input "test-secret"
- **WHEN** test checks last 100 lines of `$HISTFILE`
- **THEN** "test-secret" does NOT appear in history
- **AND** test passes

#### Scenario: Test Process List Does Not Contain Secrets
- **GIVEN** test runs `store-api-key "TEST_KEY" --from-file /tmp/test-secret` in background
- **WHEN** test runs `ps aux` during execution
- **THEN** "test-secret" does NOT appear in output
- **AND** only command and flag visible
- **AND** test passes

#### Scenario: Test Deprecation Warning Appears
- **GIVEN** test runs `store-api-key "KEY" "value"`
- **WHEN** stderr is captured
- **THEN** warning message contains "shell history"
- **AND** warning contains "deprecated"
- **AND** test passes

## Success Metrics

### Requirement: Zero Secret Exposure Rate
After implementation, zero secrets SHALL be exposed via command line in normal usage.

#### Scenario: Audit Success Metric
- **GIVEN** 1000 credential storage operations
- **WHEN** using recommended patterns (interactive/stdin/file/Keychain)
- **THEN** zero secrets appear in shell history
- **AND** zero secrets appear in process lists
- **AND** success rate is 100%

### Requirement: User Adoption of Secure Patterns
Users SHALL migrate from insecure to secure patterns.

#### Scenario: Migration Metric Tracking
- **GIVEN** telemetry or usage analysis
- **WHEN** tracking credential command usage patterns
- **THEN** interactive mode usage > 70%
- **AND** stdin/file mode usage > 20%
- **AND** positional arg usage < 10% (and declining)
- **AND** migration successful
