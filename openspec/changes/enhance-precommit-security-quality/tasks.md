# Implementation Tasks

## 1. Add detect-secrets Hook
- [ ] 1.1 Add Yelp detect-secrets to `.pre-commit-config.yaml`
- [ ] 1.2 Configure detect-secrets version (latest stable)
- [ ] 1.3 Set up secret detection patterns (AWS, GitHub, private keys, etc.)
- [ ] 1.4 Configure to scan all files (not just code)
- [ ] 1.5 Set appropriate detection sensitivity

## 2. Create Secrets Baseline
- [ ] 2.1 Run detect-secrets scan to create baseline: `detect-secrets scan > .secrets.baseline`
- [ ] 2.2 Review baseline for legitimate secrets that should be allowed
- [ ] 2.3 Audit baseline to ensure no real secrets included
- [ ] 2.4 Add `.secrets.baseline` to git
- [ ] 2.5 Document how to update baseline in CONTRIBUTING.md

## 3. Add Makefile Linter (checkmake)
- [ ] 3.1 Add checkmake hook to `.pre-commit-config.yaml`
- [ ] 3.2 Configure to check all Makefile and *.mk files
- [ ] 3.3 Set severity level (error, warning, info)
- [ ] 3.4 Test on existing Makefile
- [ ] 3.5 Fix any Makefile issues found

## 4. Add Python PEP 8 Validation (flake8)
- [ ] 4.1 Add flake8 hook to `.pre-commit-config.yaml`
- [ ] 4.2 Create `.flake8` configuration file
- [ ] 4.3 Set max line length to 88 (match black)
- [ ] 4.4 Configure ignored rules if needed (E203, W503 for black compatibility)
- [ ] 4.5 Set to check all `.py` files
- [ ] 4.6 Exclude venv, .venv, build directories

## 5. Configure flake8
- [ ] 5.1 Create `.flake8` config file
- [ ] 5.2 Set max-line-length = 88
- [ ] 5.3 Ignore E203 (whitespace before ':')
- [ ] 5.4 Ignore W503 (line break before binary operator)
- [ ] 5.5 Set max-complexity = 10
- [ ] 5.6 Configure exclude patterns

## 6. Strengthen Shellcheck Configuration
- [ ] 6.1 Review existing shellcheck hook in `.pre-commit-config.yaml`
- [ ] 6.2 Ensure severity includes warnings: `--severity=warning`
- [ ] 6.3 Add external sourcing check: `-x` flag
- [ ] 6.4 Ensure all shell scripts are covered (*.sh and extensionless)
- [ ] 6.5 Test on all existing scripts

## 7. Test All Hooks on Existing Code
- [ ] 7.1 Run `pre-commit run --all-files`
- [ ] 7.2 Document all failures found
- [ ] 7.3 Fix Makefile issues (if any)
- [ ] 7.4 Fix Python PEP 8 issues (if any)
- [ ] 7.5 Fix shell script issues (if any)
- [ ] 7.6 Review secret detection findings
- [ ] 7.7 Add false positives to baseline

## 8. Update .gitignore
- [ ] 8.1 Ensure `.secrets.baseline` is tracked (do NOT ignore)
- [ ] 8.2 Ensure `.flake8` is tracked
- [ ] 8.3 Update any exclude patterns if needed

## 9. Update CONTRIBUTING.md
- [ ] 9.1 Add "Secret Detection" section
- [ ] 9.2 Explain detect-secrets workflow
- [ ] 9.3 Document how to update secrets baseline
- [ ] 9.4 Add "Code Quality Standards" updates:
  - Python must pass flake8 (PEP 8 compliance)
  - Makefiles must pass checkmake
  - Shell scripts must pass shellcheck warnings
- [ ] 9.5 Add examples of fixing common issues
- [ ] 9.6 Document false positive handling

## 10. Update README.md
- [ ] 10.1 Update "Pre-Commit Hooks" section
- [ ] 10.2 Add detect-secrets to hooks list
- [ ] 10.3 Add checkmake to hooks list
- [ ] 10.4 Add flake8 to hooks list
- [ ] 10.5 Note comprehensive security scanning

## 11. Update ONBOARDING.md
- [ ] 11.1 Add secret detection workflow to "Pre-Commit Hooks" section
- [ ] 11.2 Explain what to do if secrets detected
- [ ] 11.3 Add Makefile linting to development workflow
- [ ] 11.4 Update Python code quality requirements
- [ ] 11.5 Add troubleshooting for new hooks

## 12. Create Secret Detection Guide (Optional)
- [ ] 12.1 Create `docs/guides/SECRET_MANAGEMENT.md` (optional)
- [ ] 12.2 Document detect-secrets usage
- [ ] 12.3 Explain baseline management
- [ ] 12.4 Add examples of secret patterns detected
- [ ] 12.5 Document what to do if secret committed

## 13. Test Pre-Commit Workflow
- [ ] 13.1 Test commit with no issues (should pass)
- [ ] 13.2 Test commit with secret (should fail)
- [ ] 13.3 Test commit with Makefile issue (should fail)
- [ ] 13.4 Test commit with Python PEP 8 issue (should fail)
- [ ] 13.5 Test commit with shellcheck warning (should fail)
- [ ] 13.6 Verify baseline allows known patterns
- [ ] 13.7 Test `--no-verify` bypass still works

## 14. Update CHANGELOG.md
- [ ] 14.1 Add entry under [Unreleased] → ### Added
- [ ] 14.2 Document detect-secrets integration
- [ ] 14.3 Document checkmake for Makefile linting
- [ ] 14.4 Document flake8 for Python PEP 8 validation
- [ ] 14.5 Note enhanced security and quality checks

## 15. Validation & Testing
- [ ] 15.1 Run `pre-commit run --all-files` successfully
- [ ] 15.2 Verify all hooks execute correctly
- [ ] 15.3 Test secret detection with test secret
- [ ] 15.4 Verify Makefile validated correctly
- [ ] 15.5 Verify Python scripts pass flake8
- [ ] 15.6 Verify shell scripts pass shellcheck warnings
- [ ] 15.7 Test false positive handling

## 16. Final Review
- [ ] 16.1 Proofread all documentation updates
- [ ] 16.2 Ensure all new hooks configured correctly
- [ ] 16.3 Verify baseline contains no real secrets
- [ ] 16.4 Check performance impact (should be minimal)
- [ ] 16.5 Ensure bypass still works (--no-verify)
