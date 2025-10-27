# https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint

[Skip to main content](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Cookbook
Automated Lint Fixes
[Welcome](https://docs.factory.ai/welcome)[CLI](https://docs.factory.ai/cli/getting-started/overview)[Web Platform](https://docs.factory.ai/web/getting-started/overview)[Onboarding](https://docs.factory.ai/onboarding)[Pricing](https://docs.factory.ai/pricing)[Changelog](https://docs.factory.ai/changelog/1-8)
  * [GitHub](https://github.com/factory-ai/factory)
  * [Discord](https://discord.gg/EQ2DQM2F)


##### Getting Started
  * [Overview](https://docs.factory.ai/cli/getting-started/overview)
  * [Quickstart](https://docs.factory.ai/cli/getting-started/quickstart)
  * [Video Walkthrough](https://docs.factory.ai/cli/getting-started/video-walkthrough)
  * [How to Talk to a Droid](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid)
  * [Common Use Cases](https://docs.factory.ai/cli/getting-started/common-use-cases)


##### User Guides
  * [Become a Power User](https://docs.factory.ai/cli/user-guides/become-a-power-user)
  * [Specification Mode](https://docs.factory.ai/cli/user-guides/specification-mode)
  * [Auto-Run Mode](https://docs.factory.ai/cli/user-guides/auto-run)
  * [Choosing Your Model](https://docs.factory.ai/cli/user-guides/choosing-your-model)
  * [Implementing Large Features](https://docs.factory.ai/cli/user-guides/implementing-large-features)


##### Configuration
  * [CLI Reference](https://docs.factory.ai/cli/configuration/cli-reference)
  * [Custom Slash Commands](https://docs.factory.ai/cli/configuration/custom-slash-commands)
  * [IDE Integrations](https://docs.factory.ai/cli/configuration/ide-integrations)
  * [Custom Droids (Subagents)](https://docs.factory.ai/cli/configuration/custom-droids)
  * [AGENTS.md](https://docs.factory.ai/cli/configuration/agents-md)
  * [Settings](https://docs.factory.ai/cli/configuration/settings)
  * [Mixed Models](https://docs.factory.ai/cli/configuration/mixed-models)
  * [Model Context Protocol](https://docs.factory.ai/cli/configuration/mcp)
  * Bring Your Own Key


##### Droid Exec (Headless)
  * [Overview](https://docs.factory.ai/cli/droid-exec/overview)
  * Cookbook
    * [Automated Code Review](https://docs.factory.ai/cli/droid-exec/cookbook/code-review)
    * [Organize Imports](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-imports)
    * [Improve Error Messages](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-error-messages)
    * [Automated Lint Fixes](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint)


##### Account
  * [Security](https://docs.factory.ai/cli/account/security)
  * [Droid Shield](https://docs.factory.ai/cli/account/droid-shield)


On this page
  * [How it works](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#how-it-works)
  * [Get the script](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#get-the-script)
  * [Prerequisites](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#prerequisites)
  * [Basic usage](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#basic-usage)
  * [Preview violations (dry run)](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#preview-violations-dry-run)
  * [Apply fixes](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#apply-fixes)
  * [Real-world transformations](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#real-world-transformations)
  * [Example 1: Simple GET Handler](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#example-1%3A-simple-get-handler)
  * [Example 2: Cron Job Handler](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#example-2%3A-cron-job-handler)
  * [Best practices](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#best-practices)


Cookbook
# Automated Lint Fixes
Copy page
Automatically fix ESLint violations across your codebase using Droid Exec
Copy page
This tutorial demonstrates how to use Droid Exec to automatically fix ESLint violations across your codebase. The script identifies files with lint errors and intelligently fixes them while preserving functionality.
This approach works with any ESLint rule - from simple formatting issues to complex architectural patterns.
##
[​](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#how-it-works)
How it works
The script:
  1. **Finds violations** : Runs ESLint to identify all route.ts files missing middleware
  2. **Analyzes context** : Determines the appropriate middleware type based on the route path
  3. **Adds middleware** : Inserts the correct handle*Middleware call as the first statement
  4. **Preserves logic** : Wraps existing code in the middleware callback
  5. **Maintains types** : Ensures TypeScript types are correctly preserved
  6. **Formats code** : Maintains consistent code style


##
[​](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#get-the-script)
Get the script
View full script source
Copy
Ask AI
```
#!/bin/bash
# Droid Route Middleware Fix Script
# Automatically adds required middleware to NextJS API routes that are missing them
#
# Usage: ./droid-fix-route-middleware.sh [directory]
# Example: ./droid-fix-route-middleware.sh apps/factory-app
set -e
# Configuration
CONCURRENCY=${CONCURRENCY:-5}
DRY_RUN=${DRY_RUN:-false}
TARGET_DIR="${1:-.}"
ESLINT_RULE="factory/require-route-middleware"
# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'
# Temp files for tracking
TEMP_DIR=$(mktemp -d)
VIOLATIONS_FILE="$TEMP_DIR/violations.txt"
PROCESSED_COUNT=0
FIXED_COUNT=0
FAILED_COUNT=0
# Cleanup on exit
trap "rm -rf $TEMP_DIR" EXIT
# Function to detect violations using ESLint
find_violations() {
  echo -e "${BLUE}Scanning for route middleware violations...${NC}"
  # Run ESLint with the specific rule and capture violations
  # Using --format json for easier parsing
  npx eslint "$TARGET_DIR" \
    --ext .ts,.tsx \
    --rule "${ESLINT_RULE}: error" \
    --format json 2>/dev/null | \
    jq -r '.[] | select(.errorCount > 0) | .filePath' > "$VIOLATIONS_FILE" || true
  # Alternative approach if the above doesn't work - find all route.ts files
  # and check them individually
  if [ ! -s "$VIOLATIONS_FILE" ]; then
    find "$TARGET_DIR" -type f -name "route.ts" \
      ! -path "*/node_modules/*" \
      ! -path "*/.next/*" \
      ! -path "*/dist/*" \
      ! -path "*/build/*" | while read -r file; do
      # Check if file has middleware violations
      if npx eslint "$file" \
        --rule "${ESLINT_RULE}: error" \
        --format compact 2>&1 | grep -q "require-route-middleware"; then
        echo "$file" >> "$VIOLATIONS_FILE"
      fi
    done
  fi
}
# Function to determine the appropriate middleware type based on route path
get_middleware_type() {
  local filepath="$1"
  # Check for specific route patterns
  if [[ "$filepath" == *"/api/cron/"* ]]; then
    echo "cron"
  elif [[ "$filepath" == *"/api/webhooks/"* ]]; then
    echo "public"
  elif [[ "$filepath" == *"/api/admin/"* ]]; then
    echo "admin"
  elif [[ "$filepath" == *"/api/auth/"* ]] && [[ "$filepath" != *"/logout"* ]]; then
    echo "public"
  elif [[ "$filepath" == *"/api/health"* ]] || [[ "$filepath" == *"/api/echo"* ]]; then
    echo "public"
  elif [[ "$filepath" == *"factory-admin"* ]]; then
    echo "admin"
  else
    echo "authenticated"
  fi
}
# Function to process a single file
process_file() {
  local filepath="$1"
  local filename=$(basename "$filepath")
  local middleware_type=$(get_middleware_type "$filepath")
  echo -e "${BLUE}Processing: $filepath${NC}"
  echo -e " Detected type: $middleware_type middleware needed"
  # The AI prompt for adding middleware
  local prompt="Fix the middleware violations in $filepath by adding the appropriate middleware handler.
IMPORTANT CONTEXT:
This is a NextJS API route file that needs middleware added to each exported HTTP handler (GET, POST, PUT, DELETE, etc.).
The middleware must be the FIRST statement in each handler function.
Based on the route type ($middleware_type), use the appropriate middleware:
1. For 'authenticated' routes (require user login):
\`\`\`typescript
import { handleAuthenticatedMiddleware } from '@/app/api/_utils/middleware';
export async function GET(req: NextRequest) {
 return handleAuthenticatedMiddleware(req, async ({ req, user }) => {
  // Existing route logic here
  // 'user' is the authenticated UserRecord
  return NextResponse.json({ data });
 });
}
\`\`\`
2. For 'public' routes (no auth required):
\`\`\`typescript
import { handlePublicMiddleware } from '@/app/api/_utils/middleware';
export async function POST(req: NextRequest) {
 return handlePublicMiddleware(req, async (req) => {
  // Existing route logic here
  return NextResponse.json({ data });
 });
}
\`\`\`
3. For 'cron' routes (require cron secret):
\`\`\`typescript
import { handleCronMiddleware } from '@/app/api/_utils/middleware';
export async function POST(req: NextRequest) {
 return handleCronMiddleware(req, async (req) => {
  // Existing route logic here
  return NextResponse.json({ success: true });
 });
}
\`\`\`
4. For 'admin' routes (require admin role):
\`\`\`typescript
import { handleAuthenticatedMiddleware, AdminRole } from '@/app/api/_utils/middleware';
export async function GET(req: NextRequest) {
 return handleAuthenticatedMiddleware(
  req,
  async ({ req, user }) => {
   // Existing route logic here
   return NextResponse.json({ data });
  },
  { requiredRole: AdminRole.ADMIN_1 }
 );
}
\`\`\`
Additional options can be passed:
- \`context\`: String for error logging context
- \`requireCsrf\`: Boolean to enable CSRF validation
- \`requiredRole\`: AdminRole enum value for role-based access
INSTRUCTIONS:
1. Add the appropriate import for the middleware function if not present
2. Wrap the ENTIRE body of each exported HTTP handler with the middleware call
3. The middleware should return the result of the middleware function
4. Move ALL existing logic inside the middleware callback
5. Preserve all existing imports, types, and logic exactly as-is
6. If the handler already uses try-catch for error handling, you can remove it as the middleware handles errors
7. Ensure the callback parameters match the middleware type (some provide 'user', others just 'req')
Only modify the route handlers to add middleware. Return the complete fixed file."
  if [ "$DRY_RUN" = "true" ]; then
    echo -e "${YELLOW} [DRY RUN] Would add $middleware_type middleware${NC}"
    return 0
  fi
  # Run droid to fix the middleware
  if droid exec --auto low "$prompt" 2>/dev/null; then
    # Verify the fix worked by running ESLint again
    if npx eslint "$filepath" \
      --rule "${ESLINT_RULE}: error" \
      --no-eslintrc \
      --plugin factory \
      --format compact 2>&1 | grep -q "require-route-middleware"; then
      echo -e "${RED} ✗ Failed to fix all violations${NC}"
      ((FAILED_COUNT++))
    else
      echo -e "${GREEN} ✓ Fixed middleware violations${NC}"
      ((FIXED_COUNT++))
    fi
    ((PROCESSED_COUNT++))
  else
    echo -e "${RED} ✗ Failed to process${NC}"
    ((FAILED_COUNT++))
  fi
}
# Export function and variables for parallel execution
export -f process_file get_middleware_type
export DRY_RUN GREEN YELLOW BLUE RED NC ESLINT_RULE
# Main execution
echo -e "${BLUE}=== Droid Route Middleware Fix ===${NC}"
echo -e "${BLUE}Directory: $TARGET_DIR${NC}"
echo -e "${BLUE}Concurrency: $CONCURRENCY${NC}"
[ "$DRY_RUN" = "true" ] && echo -e "${YELLOW}DRY RUN MODE${NC}"
echo ""
# Find violations
find_violations
VIOLATION_COUNT=$(wc -l < "$VIOLATIONS_FILE" 2>/dev/null | tr -d ' ' || echo 0)
if [ "$VIOLATION_COUNT" -eq 0 ]; then
  echo -e "${GREEN}No middleware violations found!${NC}"
  exit 0
fi
echo -e "${YELLOW}Found $VIOLATION_COUNT files with middleware violations${NC}\n"
# Process files in parallel
cat "$VIOLATIONS_FILE" | xargs -n 1 -P "$CONCURRENCY" -I {} bash -c 'process_file "$@"' _ {}
# Show summary
echo -e "\n${BLUE}=== Summary ===${NC}"
echo -e "${GREEN}Files processed: $PROCESSED_COUNT${NC}"
if [ "$DRY_RUN" = "false" ]; then
  echo -e "${GREEN}Files fixed: $FIXED_COUNT${NC}"
  [ "$FAILED_COUNT" -gt 0 ] && echo -e "${RED}Files failed: $FAILED_COUNT${NC}"
fi
if [ "$DRY_RUN" = "false" ] && [ "$FIXED_COUNT" -gt 0 ]; then
  echo -e "\n${BLUE}Next steps:${NC}"
  echo " npm run lint      # Verify all violations are fixed"
  echo " npm run typecheck   # Check TypeScript compilation"
  echo " npm run test      # Run tests"
  echo " git diff       # Review changes"
  echo " git add -A      # Stage changes"
  echo " git commit -m 'fix: add required middleware to API routes'"
fi
# Exit with error if some files failed
[ "$FAILED_COUNT" -gt 0 ] && exit 1
exit 0

```

**Critical for Success** : When customizing this script for your own lint rules, always include concrete before/after examples in the prompt you give to Droid Exec. This dramatically improves accuracy.Good prompt structure:
  1. Describe the violation to fix
  2. Show a “before” code example with the violation
  3. Show an “after” code example with the fix applied
  4. List any edge cases or patterns to preserve

The more specific your examples, the better Droid will understand and implement the fix pattern.
##
[​](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#prerequisites)
Prerequisites
Before you begin, ensure you have completed the [Droid Exec installation](https://docs.factory.ai/cli/droid-exec/overview#installation)
##
[​](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#basic-usage)
Basic usage
###
[​](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#preview-violations-dry-run)
Preview violations (dry run)
Always start with a dry run to see which files need fixing before making changes.
The dry run shows you which files violate the middleware rule and what type of middleware would be added:
Copy
Ask AI
```
# Preview what would happen (no changes made)
DRY_RUN=true ./droid-fix-route-middleware.sh apps/factory-admin/src/app/api
# Example output:
# === Droid Route Middleware Fix ===
# Directory: apps/factory-admin/src/app/api
# Concurrency: 5
# DRY RUN MODE
#
# Scanning for route middleware violations...
# Found 3 files with middleware violations
#
# Processing: apps/factory-admin/src/app/api/health/route.ts
#  Detected type: public middleware needed
#  [DRY RUN] Would add public middleware
# Processing: apps/factory-admin/src/app/api/orgs/route.ts
#  Detected type: admin middleware needed
#  [DRY RUN] Would add admin middleware
# Processing: apps/factory-admin/src/app/api/cron/batch-friction/poll-and-report/route.ts
#  Detected type: cron middleware needed
#  [DRY RUN] Would add cron middleware
#
# === Summary ===
# Files processed: 0

```

**How dry run works:**
  * When `DRY_RUN=true`: Identifies violations and shows what middleware type would be added
  * When `DRY_RUN=false` (default): Actually fixes the violations by adding middleware

This helps you:
  * Understand which routes are missing middleware
  * Verify the correct middleware type will be used
  * Estimate the scope of changes


###
[​](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#apply-fixes)
Apply fixes
Once ready, run the actual fix:
Copy
Ask AI
```
# Fix all violations in a directory
./droid-fix-route-middleware.sh apps/factory-admin/src/app/api
# Example output:
# === Droid Route Middleware Fix ===
# Directory: apps/factory-admin/src/app/api
# Concurrency: 5
#
# Scanning for route middleware violations...
# Found 3 files with middleware violations
#
# Processing: apps/factory-admin/src/app/api/health/route.ts
#  Detected type: public middleware needed
# Processing: apps/factory-admin/src/app/api/cron/batch-friction/poll-and-report/route.ts
#  Detected type: cron middleware needed
# Processing: apps/factory-admin/src/app/api/orgs/route.ts
#  Detected type: admin middleware needed
# ✓ Fixed middleware violations
# ✓ Fixed middleware violations
# ✓ Fixed middleware violations

```

##
[​](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#real-world-transformations)
Real-world transformations
###
[​](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#example-1%3A-simple-get-handler)
Example 1: Simple GET Handler
  * Before
  * After


Missing middleware - no authentication check!
Copy
Ask AI
```
// apps/factory-app/src/app/api/sessions/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { getFirestoreInstance } from '@factory/services/firebase/admin';
export async function GET(req: NextRequest) {
 const searchParams = req.nextUrl.searchParams;
 const userId = searchParams.get('userId');
 ...
 return NextResponse.json({
  sessions: sessions.docs.map(doc => doc.data())
 });
}

```

###
[​](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#example-2%3A-cron-job-handler)
Example 2: Cron Job Handler
  * Before
  * After


Cron job without authorization - anyone could trigger it!
Copy
Ask AI
```
// apps/factory-admin/src/app/api/cron/batch-friction/poll-and-report/route.ts
export async function GET(request: NextRequest) {
 logInfo('[poll-report] Starting poll and report workflow');
 const results = {
  polledBatches: 0,
  processedBatches: 0,
  failedBatches: [],
  reportGenerated: false,
  reportError: null,
 };
 // ... rest of the cron job logic ...
 return NextResponse.json({
  success,
  message,
  summary: {
   processedBatches: results.processedBatches,
   failedBatches: results.failedBatches.length,
   reportGenerated: results.reportGenerated,
  },
 });
}

```

##
[​](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint#best-practices)
Best practices
Follow these best practices for safe and effective middleware addition.
1
Start with dry run
Preview changes before applying:
Copy
Ask AI
```
# See what would be fixed without making changes
DRY_RUN=true ./droid-fix-route-middleware.sh apps

```

2
Process by app
Fix one application at a time for easier review:
Copy
Ask AI
```
# Fix factory-app routes
./droid-fix-route-middleware.sh apps/factory-app
npm run typecheck -- --filter=factory-app
git add -A && git commit -m "fix(factory-app): add required middleware to API routes"
# Fix factory-admin routes
./droid-fix-route-middleware.sh apps/factory-admin
npm run typecheck -- --filter=factory-admin
git add -A && git commit -m "fix(factory-admin): add required middleware to API routes"

```

[Improve Error Messages](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-error-messages)[Security](https://docs.factory.ai/cli/account/security)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
