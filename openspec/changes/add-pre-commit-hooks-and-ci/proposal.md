# Add Pre-commit Hooks and CI for Code Quality

## Why

**QUALITY & CONSISTENCY ISSUE**: MINDSET constitutional rules are not automatically enforced, allowing violations to slip through code review.

### Current Problems

**1. Manual Enforcement:**
- Constitutional rules rely on manual code review
- Easy to miss violations (emojis, uppercase directories, shellcheck errors)
- Inconsistent application across contributors
- Violations discovered late in review process

**2. No Automation:**
- No pre-commit hooks to catch issues before commit
- No CI to validate pull requests
- Shellcheck errors can be committed
- Documentation quality not validated

**3. MINDSET Rules Not Enforced:**
```
Rule 1: All directories MUST be lowercase
Rule 2: No emojis in documentation or code
Rule 3: Shell scripts must pass shellcheck
Rule 4: Idempotent system modifications
```

**Impact:**
- Time wasted in code review catching trivial issues
- Inconsistent code quality
- Documentation with emojis slips through
- Broken scripts can be committed

## What Changes

### 1. Pre-commit Hook Configuration

Create `.pre-commit-config.yaml` with comprehensive checks:

```yaml
repos:
  # Shellcheck - validate all shell scripts
  - repo: https://github.com/shellcheck-dev/shellcheck-precommit
    rev: v0.9.0
    hooks:
      - id: shellcheck
        args: ['--severity=error']

  # Trailing whitespace
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-merge-conflict
      - id: mixed-line-ending

  # Custom local hooks
  - repo: local
    hooks:
      # Check for emojis (MINDSET Rule 2)
      - id: no-emojis
        name: Check for emojis in files
        entry: scripts/hooks/check-no-emojis
        language: script
        types: [text]

      # Check for uppercase directories (MINDSET Rule 1)
      - id: lowercase-dirs
        name: Check directories are lowercase
        entry: scripts/hooks/check-lowercase-dirs
        language: script
        pass_filenames: false

      # Validate LinkingManifest.json
      - id: validate-manifest
        name: Validate LinkingManifest.json
        entry: scripts/hooks/validate-manifest
        language: script
        files: LinkingManifest\.json$

      # OpenSpec validation
      - id: openspec-validate
        name: Validate OpenSpec proposals
        entry: scripts/hooks/validate-openspec
        language: script
        files: openspec/changes/.*\.(md|yaml)$

      # Conventional commit message
      - id: conventional-commit
        name: Check conventional commit format
        entry: scripts/hooks/check-commit-msg
        language: script
        stages: [commit-msg]
```

### 2. Custom Hook Scripts

**bin/git/hooks/check-no-emojis:**
```bash
#!/usr/bin/env bash
# Check for emojis in staged files

set -euo pipefail

# Unicode emoji ranges
EMOJI_PATTERN='[\x{1F300}-\x{1F9FF}\x{2600}-\x{26FF}\x{2700}-\x{27BF}]'

FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(md|sh|zsh|bash|txt)$' || true)

if [[ -z "$FILES" ]]; then
    exit 0
fi

FOUND=false

for file in $FILES; do
    if grep -P "$EMOJI_PATTERN" "$file" &>/dev/null; then
        echo "ERROR: Emojis found in $file"
        echo "MINDSET Rule 2: No emojis allowed in documentation or code"
        FOUND=true
    fi
done

if [[ "$FOUND" == "true" ]]; then
    echo ""
    echo "See MINDSET.MD for constitutional rules"
    exit 1
fi
```

**bin/git/hooks/check-lowercase-dirs:**
```bash
#!/usr/bin/env bash
# Check all directories are lowercase

set -euo pipefail

# Get all directories in repo (exclude .git)
DIRS=$(find . -type d -not -path "./.git/*" -not -path "./.git" | sed 's|^\./||')

FOUND=false

for dir in $DIRS; do
    # Check if directory name contains uppercase
    if [[ "$dir" =~ [A-Z] ]]; then
        echo "ERROR: Uppercase directory found: $dir"
        echo "MINDSET Rule 1: All directories MUST be lowercase"
        FOUND=true
    fi
done

if [[ "$FOUND" == "true" ]]; then
    echo ""
    echo "Rename directories to lowercase:"
    echo "  mv Directory directory"
    echo ""
    echo "See MINDSET.MD for constitutional rules"
    exit 1
fi
```

**bin/git/hooks/validate-manifest:**
```bash
#!/usr/bin/env bash
# Validate LinkingManifest.json syntax and structure

set -euo pipefail

MANIFEST="LinkingManifest.json"

if [[ ! -f "$MANIFEST" ]]; then
    exit 0
fi

# Check JSON syntax
if ! jq empty "$MANIFEST" 2>/dev/null; then
    echo "ERROR: Invalid JSON in $MANIFEST"
    exit 1
fi

# Check required fields
REQUIRED_FIELDS=("links" "version")

for field in "${REQUIRED_FIELDS[@]}"; do
    if ! jq -e ".$field" "$MANIFEST" &>/dev/null; then
        echo "ERROR: Missing required field '$field' in $MANIFEST"
        exit 1
    fi
done

echo "LinkingManifest.json is valid"
```

**bin/git/hooks/validate-openspec:**
```bash
#!/usr/bin/env bash
# Validate OpenSpec proposals

set -euo pipefail

# Only validate if openspec is available
if ! command -v openspec &>/dev/null; then
    echo "WARN: openspec not installed, skipping validation"
    exit 0
fi

# Get changed proposals
CHANGED_PROPOSALS=$(git diff --cached --name-only | grep "openspec/changes/" | cut -d'/' -f3 | sort -u || true)

if [[ -z "$CHANGED_PROPOSALS" ]]; then
    exit 0
fi

FAILED=false

for proposal in $CHANGED_PROPOSALS; do
    echo "Validating OpenSpec proposal: $proposal"
    if ! openspec validate "$proposal" --strict; then
        FAILED=true
    fi
done

if [[ "$FAILED" == "true" ]]; then
    echo ""
    echo "Fix OpenSpec validation errors before committing"
    exit 1
fi
```

**bin/git/hooks/check-commit-msg:**
```bash
#!/usr/bin/env bash
# Validate conventional commit message format

set -euo pipefail

COMMIT_MSG_FILE="$1"
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# Skip if merge commit
if echo "$COMMIT_MSG" | grep -q "^Merge"; then
    exit 0
fi

# Conventional commit pattern
PATTERN='^(feat|fix|docs|style|refactor|test|chore|perf|ci|build|revert)(\(.+\))?!?: .{1,100}'

if ! echo "$COMMIT_MSG" | grep -qE "$PATTERN"; then
    cat << EOF
ERROR: Commit message does not follow Conventional Commits format

Your message:
  $COMMIT_MSG

Required format:
  <type>(<scope>): <description>

Types:
  feat:     New feature
  fix:      Bug fix
  docs:     Documentation only
  style:    Formatting changes
  refactor: Code restructuring
  test:     Adding tests
  chore:    Maintenance
  perf:     Performance improvement
  ci:       CI/CD changes
  build:    Build system changes
  revert:   Revert previous commit

Examples:
  feat: add zsh-benchmark script
  fix(install): handle missing jq gracefully
  docs: update README with performance tips

See: https://www.conventionalcommits.org/
EOF
    exit 1
fi
```

### 3. GitHub Actions CI Configuration

Create `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  lint:
    name: Lint and Validation
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y shellcheck jq

      - name: Shellcheck
        run: |
          echo "Running shellcheck on all scripts..."
          find bin/ -type f -executable | xargs shellcheck --severity=error

      - name: Check for emojis
        run: |
          echo "Checking for emojis in documentation..."
          if grep -rP '[\x{1F300}-\x{1F9FF}\x{2600}-\x{26FF}]' \
            --include="*.md" \
            --include="*.sh" \
            --include="*.zsh" \
            .; then
            echo "ERROR: Emojis found (violates MINDSET.MD Rule 2)"
            exit 1
          fi
          echo "No emojis found"

      - name: Check lowercase directories
        run: |
          echo "Checking all directories are lowercase..."
          FOUND=false
          while IFS= read -r dir; do
            if [[ "$dir" =~ [A-Z] ]]; then
              echo "ERROR: Uppercase directory: $dir"
              FOUND=true
            fi
          done < <(find . -type d -not -path "./.git/*" | sed 's|^\./||')

          if [[ "$FOUND" == "true" ]]; then
            echo "ERROR: Uppercase directories found (violates MINDSET.MD Rule 1)"
            exit 1
          fi
          echo "All directories are lowercase"

      - name: Validate LinkingManifest.json
        run: |
          echo "Validating LinkingManifest.json..."
          jq empty LinkingManifest.json

          # Check required fields
          jq -e '.links' LinkingManifest.json > /dev/null
          jq -e '.version' LinkingManifest.json > /dev/null

          echo "LinkingManifest.json is valid"

      - name: Check trailing whitespace
        run: |
          echo "Checking for trailing whitespace..."
          if git grep -n '[[:space:]]$' -- '*.md' '*.sh' '*.zsh' '*.yaml' '*.json'; then
            echo "ERROR: Trailing whitespace found"
            exit 1
          fi
          echo "No trailing whitespace"

  test:
    name: Test Installation
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest]

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Test dry-run installation
        run: |
          ./install --dry-run

      - name: Test link-dotfiles
        run: |
          sudo apt-get install -y jq || brew install jq
          bin/core/link-dotfiles --dry-run

  openspec:
    name: OpenSpec Validation
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Install OpenSpec
        run: |
          # Install openspec CLI
          npm install -g @cloudy-ts/openspec || echo "OpenSpec not available"

      - name: Validate proposals
        run: |
          if command -v openspec &> /dev/null; then
            for proposal in openspec/changes/*/; do
              echo "Validating $(basename $proposal)..."
              openspec validate "$(basename $proposal)" --strict || true
            done
          else
            echo "OpenSpec not available, skipping"
          fi
```

### 4. Installation Script

Create `bin/core/setup-git-hooks`:

```bash
#!/usr/bin/env bash
# Setup git hooks for this repository

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
HOOKS_DIR="$REPO_ROOT/.git/hooks"

echo "Setting up git hooks..."

# Install pre-commit framework if not installed
if ! command -v pre-commit &>/dev/null; then
    echo "Installing pre-commit..."
    if command -v brew &>/dev/null; then
        brew install pre-commit
    elif command -v pip3 &>/dev/null; then
        pip3 install pre-commit
    else
        echo "ERROR: Cannot install pre-commit. Install manually:"
        echo "  macOS: brew install pre-commit"
        echo "  Linux: pip3 install pre-commit"
        exit 1
    fi
fi

# Install hooks from .pre-commit-config.yaml
echo "Installing pre-commit hooks..."
cd "$REPO_ROOT"
pre-commit install
pre-commit install --hook-type commit-msg

echo "Git hooks installed successfully!"
echo ""
echo "To run hooks manually:"
echo "  pre-commit run --all-files"
```

### 5. Documentation Updates

**Update CONTRIBUTING.md:**
```markdown
## Pre-commit Hooks

This repository uses pre-commit hooks to enforce code quality:

```bash
# Install hooks (one-time)
bin/core/setup-git-hooks

# Manually run all hooks
pre-commit run --all-files

# Skip hooks (not recommended)
git commit --no-verify
```

Hooks check:
- Shellcheck (no errors)
- No emojis (MINDSET Rule 2)
- Lowercase directories (MINDSET Rule 1)
- Conventional commits
- LinkingManifest.json validity
- OpenSpec proposals
```

## Impact

### Files Created
- `.pre-commit-config.yaml` - Pre-commit configuration
- `.github/workflows/ci.yml` - GitHub Actions CI
- `bin/core/setup-git-hooks` - Hook installation script
- `bin/git/hooks/check-no-emojis` - Emoji detection
- `bin/git/hooks/check-lowercase-dirs` - Directory case validation
- `bin/git/hooks/validate-manifest` - Manifest validation
- `bin/git/hooks/validate-openspec` - OpenSpec validation
- `bin/git/hooks/check-commit-msg` - Commit message validation

### Files Modified
- `install` - Add hook setup phase
- `CONTRIBUTING.md` - Document pre-commit usage
- `README.md` - Add CI badge

### Breaking Changes
**None** - All checks are additive:
- Pre-commit hooks can be bypassed with `--no-verify`
- CI is informational on first run
- Existing commits are not affected

### New Capabilities
- Automatic MINDSET rule enforcement
- Early detection of issues (before push)
- CI validation on pull requests
- Consistent code quality
- Faster code review (trivial issues caught automatically)

## Expected Benefits

### Time Savings
- **Developer**: Catch issues locally before push (< 5 seconds)
- **Reviewer**: No time spent on trivial issues (shellcheck, emojis, formatting)
- **CI**: Fast feedback (< 2 minutes for full suite)

### Quality Improvements
- **100% enforcement** of MINDSET rules
- **Zero shellcheck errors** in committed code
- **Consistent formatting** (trailing whitespace, EOL)
- **Valid configurations** (JSON, YAML)
- **Conventional commits** maintained

### Workflow Benefits
- Issues caught immediately
- Clear error messages with fixes
- Fast local feedback loop
- Confidence in CI passing
- Reduced review iterations

## Migration Path

### Phase 1: Setup (Non-Breaking)
1. Create `.pre-commit-config.yaml`
2. Create hook scripts in `bin/git/hooks/`
3. Create `setup-git-hooks` installer
4. Test hooks locally

### Phase 2: CI (Informational)
1. Create `.github/workflows/ci.yml`
2. Configure to run on PRs
3. Initially set to non-blocking (allow failures)
4. Monitor for false positives

### Phase 3: Documentation
1. Update CONTRIBUTING.md
2. Update README.md with CI badge
3. Add troubleshooting guide
4. Document bypass procedures

### Phase 4: Enforcement
1. Make CI required for merges
2. Team announcement about hooks
3. Offer help for setup
4. Address edge cases

### Phase 5: Refinement
1. Add more checks as needed
2. Optimize check performance
3. Improve error messages
4. Gather feedback

## Testing Strategy

### Local Testing
```bash
# Install hooks
bin/core/setup-git-hooks

# Test emoji detection
echo "# Test " > test.md
git add test.md
git commit -m "test"  # Should fail

# Test directory case
mkdir TestDir
git add TestDir
git commit -m "test"  # Should fail

# Test shellcheck
echo '#!/bin/bash\necho $undefined' > bin/core/test
git add bin/core/test
git commit -m "test"  # Should fail

# Test conventional commit
git commit -m "bad message"  # Should fail
git commit -m "feat: good message"  # Should pass
```

### CI Testing
1. Create PR with violations
2. Verify CI catches issues
3. Fix issues
4. Verify CI passes
5. Merge

### Edge Cases
- Large files (performance)
- Binary files (skip checks)
- Generated files (exclusions)
- Merge commits (special handling)
- Revert commits (allow)

## Success Criteria

- [OK] Pre-commit hooks install successfully
- [OK] All MINDSET rules enforced
- [OK] Shellcheck catches errors
- [OK] Conventional commits validated
- [OK] CI runs on all PRs
- [OK] CI completes in < 5 minutes
- [OK] Clear error messages
- [OK] Bypass mechanism available
- [OK] Documentation complete
- [OK] Team trained

## Configuration Options

### Skip Specific Hooks
```bash
# Skip emoji check
SKIP=no-emojis git commit -m "feat: add feature"

# Skip all hooks
git commit --no-verify
```

### Configure .pre-commit-config.yaml
```yaml
# Exclude files from checks
exclude: '^(docs/legacy/|\.ai_docs/)'

# Skip specific hooks
- id: no-emojis
  exclude: '^ai_docs/'
```

### CI Environment Variables
```yaml
env:
  SKIP_EMOJI_CHECK: false
  SHELLCHECK_SEVERITY: error
```

## Future Enhancements

- **Performance**: Cache shellcheck results
- **More checks**: Python linting, markdown linting
- **Auto-fix**: Format code automatically
- **Notification**: Slack/Discord integration
- **Metrics**: Track check failures over time
- **Dashboard**: Visualize code quality trends
