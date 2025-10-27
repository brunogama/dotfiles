#!/usr/bin/env bash
# Validate CHANGELOG.md is updated for user-facing changes
# Part of pre-commit hooks

set -euo pipefail

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Get commit message (from git or stdin)
COMMIT_MSG=""
if [ -f ".git/COMMIT_EDITMSG" ]; then
    COMMIT_MSG=$(head -n1 .git/COMMIT_EDITMSG)
elif [ -n "${1:-}" ]; then
    COMMIT_MSG="$1"
fi

# If no commit message available, check git log
if [ -z "$COMMIT_MSG" ]; then
    COMMIT_MSG=$(git log -1 --pretty=%B 2>/dev/null || echo "")
fi

# Extract commit type (feat, fix, chore, etc.)
COMMIT_TYPE=$(echo "$COMMIT_MSG" | grep -oE '^[a-z]+' | head -n1 || echo "")

# Commit types that require CHANGELOG update (user-facing)
USER_FACING_TYPES=("feat" "fix" "perf" "refactor")

# Commit types that don't require CHANGELOG update
SKIP_TYPES=("chore" "docs" "test" "ci" "build" "style")

# Check if commit type requires CHANGELOG update
requires_changelog=false
for type in "${USER_FACING_TYPES[@]}"; do
    if [ "$COMMIT_TYPE" = "$type" ]; then
        requires_changelog=true
        break
    fi
done

# Skip validation for non-user-facing changes
for type in "${SKIP_TYPES[@]}"; do
    if [ "$COMMIT_TYPE" = "$type" ]; then
        echo -e "${GREEN}[OK]${NC} Skipping CHANGELOG validation for $COMMIT_TYPE commit"
        exit 0
    fi
done

# If not user-facing, allow without CHANGELOG
if [ "$requires_changelog" = false ]; then
    echo -e "${GREEN}[OK]${NC} CHANGELOG validation skipped for commit type: $COMMIT_TYPE"
    exit 0
fi

# Check if CHANGELOG.md is modified in this commit
changelog_modified=false
if git diff --cached --name-only | grep -q "^CHANGELOG.md$"; then
    changelog_modified=true
fi

# If CHANGELOG not modified, fail
if [ "$changelog_modified" = false ]; then
    echo -e "${RED}[X] ERROR: CHANGELOG.md not updated for user-facing change${NC}"
    echo ""
    echo "This commit ($COMMIT_TYPE: ...) requires a CHANGELOG entry."
    echo "Please add your change to the [Unreleased] section in CHANGELOG.md"
    echo ""
    echo -e "${YELLOW}Example:${NC}"
    echo ""
    echo "  ## [Unreleased]"
    echo ""
    if [ "$COMMIT_TYPE" = "feat" ]; then
        echo "  ### Added"
        echo "  - Your new feature description"
    elif [ "$COMMIT_TYPE" = "fix" ]; then
        echo "  ### Fixed"
        echo "  - Bug fix description"
    elif [ "$COMMIT_TYPE" = "perf" ]; then
        echo "  ### Changed"
        echo "  - Performance improvement description"
    elif [ "$COMMIT_TYPE" = "refactor" ]; then
        echo "  ### Changed"
        echo "  - Refactoring change description (if user-visible)"
    fi
    echo ""
    echo -e "${YELLOW}Commit types requiring CHANGELOG:${NC} feat, fix, perf, refactor"
    echo -e "${YELLOW}Commit types skipping CHANGELOG:${NC} chore, docs, test, ci, build, style"
    echo ""
    echo "To bypass this check (not recommended): git commit --no-verify"
    exit 1
fi

# Verify [Unreleased] section exists and has content
if ! grep -q "## \[Unreleased\]" CHANGELOG.md; then
    echo -e "${RED}[X] ERROR: [Unreleased] section not found in CHANGELOG.md${NC}"
    echo "Please add an [Unreleased] section to track upcoming changes."
    exit 1
fi

# Success!
echo -e "${GREEN}[OK]${NC} CHANGELOG.md updated for $COMMIT_TYPE commit"
exit 0
