# Enhance Pre-Commit with Security and Quality Checks

## Why

Current pre-commit configuration lacks critical security and quality checks:

**Security Gaps:**
- ❌ No automatic secret detection before commit
- ❌ API keys, passwords, tokens can be accidentally committed
- ❌ No scanning for AWS keys, GitHub tokens, private keys
- ❌ Relies on manual review to catch secrets
- ❌ Droid-Shield secret detection happens too late (at push time)

**Quality Gaps:**
- ❌ Makefiles not linted (can have syntax errors)
- ❌ Python scripts only formatted (black), not validated for PEP 8 compliance
- ❌ No checks for Python code quality issues (unused imports, undefined vars)
- ❌ Shellcheck exists but no explicit validation step
- ❌ No verification that scripts are actually shellcheck-compliant

**Impact:**
- Secrets accidentally committed to git history
- Manual secret removal requires history rewrite
- Makefile syntax errors not caught until runtime
- Python quality issues slip through
- Inconsistent code quality standards

## What Changes

**Add Secret Detection:**
- Integrate **Yelp's detect-secrets** hook
- Scan all files for common secret patterns before commit
- Detect: API keys, passwords, AWS keys, private keys, tokens
- Create `.secrets.baseline` for legitimate secrets (false positives)
- Block commits containing new secrets

**Add Makefile Linting:**
- Integrate **checkmake** for Makefile validation
- Check for: syntax errors, style issues, best practices
- Validate target names, phony declarations, variable usage

**Enhance Python Validation:**
- Add **flake8** for PEP 8 compliance checking
- Validate: code style, unused imports, undefined variables
- Configure to work with black (line length 88)
- Add **pylint** for deeper code quality analysis (optional/warning only)

**Strengthen Shell Script Validation:**
- Keep existing shellcheck hook
- Add explicit validation that scripts pass shellcheck
- Ensure all `.sh` files and scripts without extension are checked
- Fail on shellcheck warnings (not just errors)

**Configuration Improvements:**
- Update `.pre-commit-config.yaml` with new hooks
- Create `.secrets.baseline` for baseline secrets
- Create `.flake8` config for Python linting
- Update CONTRIBUTING.md with new requirements

## Impact

**Files Created:**
- `.secrets.baseline` - Baseline for detect-secrets (allow known patterns)
- `.flake8` - Flake8 configuration for Python linting

**Files Modified:**
- `.pre-commit-config.yaml` - Add detect-secrets, checkmake, flake8
- `CONTRIBUTING.md` - Document new quality requirements
- `README.md` - Update pre-commit hooks list
- `ONBOARDING.md` - Add secret detection workflow
- `CHANGELOG.md` - Document new security features

**Breaking Changes:**
- Existing code may fail new quality checks (but can be fixed)
- Python scripts may need imports cleanup
- Makefiles may need style fixes

**Benefits:**
- ✅ Automatic secret detection before commit
- ✅ Prevent accidental credential leaks
- ✅ Catch Makefile syntax errors early
- ✅ Enforce PEP 8 compliance for Python
- ✅ Higher code quality standards
- ✅ Comprehensive pre-commit validation

**Risks:**
- **Medium:** Existing code may not pass new checks (mitigated by --no-verify option)
- **Low:** False positives in secret detection (mitigated by baseline file)
- **Low:** Stricter checks may slow commits slightly (acceptable trade-off)
