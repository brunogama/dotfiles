# Configuration Validation Specification

## ADDED Requirements

### Requirement: LinkingManifest Schema Validation
The system SHALL validate LinkingManifest.json against a JSON schema.

#### Scenario: Valid manifest
- **WHEN** LinkingManifest.json conforms to schema
- **THEN** validation passes with no errors

#### Scenario: Invalid manifest structure
- **WHEN** LinkingManifest.json has invalid structure
- **THEN** validation fails with detailed error message and location

#### Scenario: Missing required fields
- **WHEN** LinkingManifest.json is missing required fields
- **THEN** validation reports which fields are missing

#### Scenario: Invalid field types
- **WHEN** LinkingManifest.json has incorrect field types
- **THEN** validation reports type mismatches with expected types

### Requirement: OpenSpec Proposal Validation
The system SHALL validate OpenSpec proposals for structural correctness.

#### Scenario: Proposal structure validation
- **WHEN** proposal.md exists
- **THEN** validation checks for required sections (Why, What Changes, Impact)

#### Scenario: Tasks checklist validation
- **WHEN** tasks.md exists
- **THEN** validation checks for proper markdown checklist format

#### Scenario: Spec delta validation
- **WHEN** spec deltas exist
- **THEN** validation checks for proper ADDED/MODIFIED/REMOVED sections

#### Scenario: Scenario format validation
- **WHEN** spec deltas contain scenarios
- **THEN** validation ensures scenarios use proper #### Scenario: format

### Requirement: Shell Script Validation
The system SHALL validate shell scripts for quality and safety.

#### Scenario: Shellcheck integration
- **WHEN** shell script is validated
- **THEN** shellcheck static analysis is run and errors are reported

#### Scenario: Required header check
- **WHEN** shell script is validated
- **THEN** script MUST have #!/usr/bin/env bash and set -euo pipefail

#### Scenario: Function length check
- **WHEN** shell script contains functions
- **THEN** functions MUST be 40 lines or fewer

#### Scenario: File length check
- **WHEN** shell script is validated
- **THEN** file MUST be 400 lines or fewer

#### Scenario: Getopts usage check
- **WHEN** shell script accepts arguments
- **THEN** script MUST use getopts for argument parsing

### Requirement: Unified Validator CLI
The system SHALL provide a unified CLI tool for all configuration validation.

#### Scenario: Manifest validation command
- **WHEN** validate-config manifest is run
- **THEN** LinkingManifest.json is validated

#### Scenario: OpenSpec validation command
- **WHEN** validate-config openspec is run
- **THEN** all OpenSpec proposals are validated

#### Scenario: Shell scripts validation command
- **WHEN** validate-config shell-scripts is run
- **THEN** all shell scripts in bin/ are validated

#### Scenario: Validate all command
- **WHEN** validate-config --all is run
- **THEN** all configurations are validated and results are aggregated

### Requirement: Pre-commit Hook Integration
The system SHALL validate configurations automatically before commits.

#### Scenario: Manifest validation on commit
- **WHEN** LinkingManifest.json is modified
- **THEN** pre-commit hook validates it before commit

#### Scenario: OpenSpec validation on commit
- **WHEN** OpenSpec files are modified
- **THEN** pre-commit hook validates them before commit

#### Scenario: Shell script validation on commit
- **WHEN** shell scripts are modified
- **THEN** pre-commit hook validates them before commit

#### Scenario: Commit blocking on errors
- **WHEN** validation finds errors
- **THEN** commit is blocked until errors are fixed

### Requirement: Validation Error Reporting
The system SHALL provide clear and actionable validation error messages.

#### Scenario: Structured error output
- **WHEN** validation fails
- **THEN** errors are reported with file path, line number, and description

#### Scenario: Error severity levels
- **WHEN** validation issues are found
- **THEN** issues are classified as error, warning, or info

#### Scenario: Fix suggestions
- **WHEN** validation error has known fix
- **THEN** error message includes suggestion for how to fix

#### Scenario: Validation report
- **WHEN** validation completes
- **THEN** summary report shows total issues by severity

### Requirement: Auto-fix Capability
The system SHALL automatically fix certain validation issues when requested.

#### Scenario: Auto-fix invocation
- **WHEN** validate-config is run with --fix flag
- **THEN** auto-fixable issues are corrected automatically

#### Scenario: Safe fixes only
- **WHEN** auto-fix runs
- **THEN** only safe, non-destructive fixes are applied

#### Scenario: Fix confirmation
- **WHEN** auto-fix completes
- **THEN** report shows which issues were fixed

### Requirement: Validation Rule Configuration
The system SHALL allow configuration of validation rules.

#### Scenario: Rule toggles
- **WHEN** validation configuration file exists
- **THEN** specific rules can be enabled or disabled

#### Scenario: Custom rule parameters
- **WHEN** validation rules have parameters
- **THEN** parameters can be customized in configuration

#### Scenario: Rule documentation
- **WHEN** developer needs to understand validation rules
- **THEN** all rules are documented with examples

### Requirement: Validation Performance
The system SHALL perform validation efficiently without blocking development workflow.

#### Scenario: Fast validation
- **WHEN** validation runs on single file
- **THEN** validation completes in less than 1 second

#### Scenario: Incremental validation
- **WHEN** only some files are changed
- **THEN** only changed files are validated

#### Scenario: Parallel validation
- **WHEN** multiple files are validated
- **THEN** validation runs in parallel when possible

### Requirement: Validation Documentation
The system SHALL provide comprehensive documentation for validation system.

#### Scenario: Validation guide
- **WHEN** developer reads validation documentation
- **THEN** guide explains how to run validators and interpret results

#### Scenario: Rule reference
- **WHEN** developer needs to understand specific rule
- **THEN** reference documents all rules with examples

#### Scenario: Troubleshooting guide
- **WHEN** validation errors occur
- **THEN** documentation provides troubleshooting steps
