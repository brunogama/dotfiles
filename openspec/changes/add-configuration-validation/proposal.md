# Configuration Validation

## Why

Configuration files like LinkingManifest.json and OpenSpec proposals can contain errors that cause runtime failures. Manual validation is error-prone and inconsistent. Pre-deployment validation prevents broken configurations from being committed.

## What Changes

- Add automated validation for LinkingManifest.json against JSON schema
- Extend OpenSpec validation for all proposal files
- Add comprehensive shell script validation with shellcheck
- Create unified validation CLI tool
- Add pre-commit hooks for automatic validation

## Impact

- Affected specs: New capability `configuration-validation`
- Affected code:
  - New: `bin/core/validate-config` unified validator
  - New: `schemas/LinkingManifest.schema.json` JSON schema
  - Modified: `bin/git/hooks/validate-manifest` enhanced validation
  - Modified: `bin/git/hooks/validate-openspec` enhanced validation
  - New: `bin/git/hooks/validate-shell-scripts` comprehensive linting
  - Modified: `.pre-commit-config.yaml` add validation hooks
