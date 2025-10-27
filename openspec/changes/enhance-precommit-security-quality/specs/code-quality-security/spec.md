# Code Quality and Security Specification Delta

## ADDED Requirements

### Requirement: Pre-Commit SHALL Detect Secrets Before Commit
The project SHALL use detect-secrets to scan for secrets before allowing commits.

**Tool:** Yelp's detect-secrets
**Configuration:** `.secrets.baseline` for known false positives

#### Scenario: User attempts to commit file with API key
- **WHEN** developer commits file containing API key pattern
- **THEN** detect-secrets hook SHALL fail the commit
- **AND** hook SHALL show which file contains potential secret
- **AND** hook SHALL show line number and secret type
- **AND** commit SHALL be blocked until secret removed

#### Scenario: Legitimate secret pattern in code example
- **WHEN** documentation contains example API key (e.g., "AKIAIOSFODNN7EXAMPLE")
- **THEN** it SHALL be added to `.secrets.baseline`
- **AND** hook SHALL allow commit with baseline entry
- **AND** baseline SHALL be reviewed and approved

#### Scenario: Update secrets baseline
- **WHEN** new false positive is detected
- **THEN** developer SHALL run `detect-secrets scan --baseline .secrets.baseline`
- **AND** developer SHALL audit new entries
- **AND** developer SHALL commit updated baseline

**Detected Secret Types:**
- AWS Access Keys (AKIA...)
- GitHub Tokens (ghp_..., gho_...)
- Private Keys (BEGIN PRIVATE KEY)
- Generic API Keys (high entropy strings)
- Passwords in URLs
- Slack tokens
- Base64 high entropy strings

### Requirement: Makefiles SHALL Pass Linting
All Makefile and *.mk files SHALL pass checkmake validation.

**Tool:** checkmake
**Validation Level:** Errors must be fixed, warnings should be fixed

#### Scenario: Makefile with syntax error
- **WHEN** developer commits Makefile with syntax error
- **THEN** checkmake hook SHALL fail
- **AND** hook SHALL show specific error and line number
- **AND** commit SHALL be blocked

#### Scenario: Makefile with style issues
- **WHEN** Makefile has style issues (e.g., missing .PHONY)
- **THEN** checkmake SHALL report warnings
- **AND** developer SHOULD fix warnings
- **AND** commit MAY proceed with warnings (errors block)

**Checkmake Validations:**
- Phony target declarations
- Target name conventions
- Variable usage patterns
- Tab vs space indentation
- Makefile best practices

### Requirement: Python Code SHALL Comply with PEP 8
All Python files SHALL pass flake8 validation for PEP 8 compliance.

**Tool:** flake8
**Configuration:** `.flake8` config file
**Line Length:** 88 characters (match black formatter)

#### Scenario: Python file with PEP 8 violations
- **WHEN** developer commits Python file with PEP 8 violations
- **THEN** flake8 hook SHALL fail
- **AND** hook SHALL list all violations with line numbers
- **AND** commit SHALL be blocked

#### Scenario: Python file with unused imports
- **WHEN** Python file has unused imports
- **THEN** flake8 SHALL report F401 error
- **AND** developer SHALL remove unused imports
- **AND** commit SHALL be blocked until fixed

#### Scenario: Python file formatted by black
- **WHEN** Python file is formatted by black
- **THEN** flake8 SHALL not conflict with black formatting
- **AND** E203 and W503 SHALL be ignored (black compatibility)
- **AND** max line length SHALL be 88

**Flake8 Error Categories:**
- E: PEP 8 errors (indentation, whitespace)
- F: PyFlakes errors (undefined names, unused imports)
- W: PEP 8 warnings (deprecated features)
- C: Complexity warnings (if enabled)

### Requirement: Shell Scripts SHALL Pass Shellcheck Warnings
All shell scripts SHALL pass shellcheck at warning level (not just errors).

**Tool:** shellcheck
**Severity:** warning (--severity=warning)
**External Sourcing:** enabled (-x flag)

#### Scenario: Shell script with shellcheck warning
- **WHEN** developer commits shell script with SC2086 (unquoted variable)
- **THEN** shellcheck hook SHALL fail
- **AND** hook SHALL show warning code and explanation
- **AND** commit SHALL be blocked until fixed

#### Scenario: Shell script sources external file
- **WHEN** script uses `source` or `.` to load external file
- **THEN** shellcheck SHALL follow external references (-x flag)
- **AND** SHALL validate sourced files
- **AND** SHALL report issues in sourced files

**Critical Shellcheck Issues Caught:**
- SC2086: Unquoted variables (security risk)
- SC2046: Unquoted command substitution
- SC2006: Deprecated backtick syntax
- SC2181: Checking $? instead of command directly
- SC2001: Sed used where bash substitution suffices

### Requirement: Configuration Files SHALL Define Quality Standards
Project SHALL maintain explicit configuration for all quality tools.

**Required Configuration Files:**
- `.pre-commit-config.yaml` - Pre-commit hook definitions
- `.secrets.baseline` - Known false positives for detect-secrets
- `.flake8` - Flake8/PEP 8 configuration for Python

#### Scenario: Developer sets up new machine
- **WHEN** developer runs `pre-commit install`
- **THEN** all hooks SHALL be configured automatically
- **AND** all config files SHALL be read
- **AND** quality standards SHALL be enforced consistently

### Requirement: False Positives SHALL Be Auditable
The secrets baseline SHALL contain only audited false positives.

**Baseline File:** `.secrets.baseline`
**Format:** JSON with hashed secrets and metadata

#### Scenario: Review secrets baseline
- **WHEN** reviewing `.secrets.baseline` in pull request
- **THEN** reviewer SHALL verify each entry is legitimate
- **AND** reviewer SHALL confirm no real secrets in baseline
- **AND** entries SHALL have clear context (filename, line number)

#### Scenario: Accidental real secret in baseline
- **WHEN** real secret is accidentally added to baseline
- **THEN** it SHALL be removed from baseline immediately
- **AND** it SHALL be removed from git history
- **AND** secret SHALL be rotated/invalidated

## MODIFIED Requirements

### Requirement: Pre-Commit Hooks SHALL Include Security Checks
Previously pre-commit focused on code quality. Now pre-commit hooks SHALL include security scanning.

**Before:**
- Code quality checks only (shellcheck, black, isort)
- No secret detection
- No security scanning

**After:**
- Code quality checks maintained
- Secret detection with detect-secrets
- Comprehensive security scanning before commit

#### Scenario: Developer commits with pre-commit enabled
- **WHEN** developer makes a commit
- **THEN** all quality hooks SHALL run (shellcheck, black, isort, flake8)
- **AND** security hooks SHALL run (detect-secrets)
- **AND** configuration hooks SHALL run (checkmake for Makefiles)
- **AND** commit SHALL be blocked if any hook fails

### Requirement: Code Quality Standards SHALL Be Enforced Automatically
Previously code quality was recommended. Now it SHALL be enforced at commit time.

**Before:**
- Black formatting recommended
- Shellcheck recommended
- PEP 8 compliance recommended

**After:**
- Black formatting enforced (already implemented)
- Shellcheck warnings enforced (strengthened)
- PEP 8 compliance enforced (new: flake8)
- Makefile quality enforced (new: checkmake)
- Secret detection enforced (new: detect-secrets)

#### Scenario: Developer submits PR with quality issues
- **WHEN** developer tries to commit code with quality issues
- **THEN** pre-commit SHALL block the commit locally
- **AND** developer SHALL fix issues before committing
- **AND** PR SHALL only contain quality-compliant code

## VALIDATION

### Pre-Implementation Checks
```bash
# Verify detect-secrets not configured
grep detect-secrets .pre-commit-config.yaml && echo "Already added" || echo "Not found"

# Verify checkmake not configured
grep checkmake .pre-commit-config.yaml && echo "Already added" || echo "Not found"

# Verify flake8 not configured
grep flake8 .pre-commit-config.yaml && echo "Already added" || echo "Not found"

# Verify baseline doesn't exist
ls .secrets.baseline && echo "Exists" || echo "Not found"

# Verify flake8 config doesn't exist
ls .flake8 && echo "Exists" || echo "Not found"
```

### Post-Implementation Checks
```bash
# Verify all new hooks added
grep -q detect-secrets .pre-commit-config.yaml && echo "[OK] detect-secrets"
grep -q checkmake .pre-commit-config.yaml && echo "[OK] checkmake"
grep -q flake8 .pre-commit-config.yaml && echo "[OK] flake8"

# Verify config files exist
test -f .secrets.baseline && echo "[OK] .secrets.baseline"
test -f .flake8 && echo "[OK] .flake8"

# Test detect-secrets
echo "AKIA0123456789ABCDEF" > test-secret.txt
git add test-secret.txt
git commit -m "test" && echo "FAIL: Secret not detected" || echo "[OK] Secret detected"
rm test-secret.txt

# Test checkmake (if Makefile has issues)
pre-commit run checkmake --all-files

# Test flake8 on Python files
pre-commit run flake8 --all-files

# Test shellcheck warnings
pre-commit run shellcheck --all-files

# Run all hooks
pre-commit run --all-files
```

### Functional Tests

**Test 1: Secret Detection**
```bash
# Create file with fake API key
echo "aws_access_key_id = AKIAIOSFODNN7EXAMPLE" > test.txt

# Try to commit (should fail)
git add test.txt
git commit -m "test: add config" 2>&1 | grep "detect-secrets" && echo "PASS"

# Add to baseline
detect-secrets scan --baseline .secrets.baseline test.txt

# Try again (should pass)
git commit -m "test: add config"  # Should succeed with baseline
```

**Test 2: Makefile Linting**
```bash
# Create Makefile with issue
echo -e "test:\n echo 'hi'" > Makefile  # Missing space (not tab)

# Try to commit (should fail)
git add Makefile
git commit -m "test: add makefile" 2>&1 | grep "checkmake" && echo "PASS"
```

**Test 3: Python PEP 8**
```bash
# Create Python file with long line
echo "x = 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890" > test.py

# Try to commit (should fail)
git add test.py
git commit -m "test: add python" 2>&1 | grep "flake8" && echo "PASS"
```

**Test 4: Shellcheck Warnings**
```bash
# Create script with unquoted variable
echo '#!/bin/bash' > test.sh
echo 'echo $1' >> test.sh  # SC2086: Should be quoted

# Try to commit (should fail)
chmod +x test.sh
git add test.sh
git commit -m "test: add script" 2>&1 | grep "shellcheck" && echo "PASS"
```

### Acceptance Criteria
- [ ] detect-secrets hook configured and working
- [ ] .secrets.baseline exists and audited
- [ ] checkmake hook configured for Makefiles
- [ ] flake8 hook configured for Python
- [ ] .flake8 config file created
- [ ] Shellcheck enforces warnings (not just errors)
- [ ] All hooks run on `pre-commit run --all-files`
- [ ] Test secret is detected and blocks commit
- [ ] Test Makefile issue blocks commit
- [ ] Test Python PEP 8 issue blocks commit
- [ ] Test shellcheck warning blocks commit
- [ ] False positives can be added to baseline
- [ ] Documentation updated (CONTRIBUTING, README, ONBOARDING)
- [ ] CHANGELOG.md updated with security enhancements
