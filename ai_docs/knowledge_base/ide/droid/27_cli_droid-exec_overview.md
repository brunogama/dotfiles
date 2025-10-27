# https://docs.factory.ai/cli/droid-exec/overview

[Skip to main content](https://docs.factory.ai/cli/droid-exec/overview#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Droid Exec (Headless)
Overview
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


##### Account
  * [Security](https://docs.factory.ai/cli/account/security)
  * [Droid Shield](https://docs.factory.ai/cli/account/droid-shield)


On this page
  * [Droid Exec (Headless CLI)](https://docs.factory.ai/cli/droid-exec/overview#droid-exec-headless-cli)
  * [Summary and goals](https://docs.factory.ai/cli/droid-exec/overview#summary-and-goals)
  * [Execution model](https://docs.factory.ai/cli/droid-exec/overview#execution-model)
  * [Installation](https://docs.factory.ai/cli/droid-exec/overview#installation)
  * [Quickstart](https://docs.factory.ai/cli/droid-exec/overview#quickstart)
  * [Autonomy Levels](https://docs.factory.ai/cli/droid-exec/overview#autonomy-levels)
  * [DEFAULT (no flags) - Read-only Mode](https://docs.factory.ai/cli/droid-exec/overview#default-no-flags-read-only-mode)
  * [--auto low - Low-risk Operations](https://docs.factory.ai/cli/droid-exec/overview#auto-low-low-risk-operations)
  * [--auto medium - Development Operations](https://docs.factory.ai/cli/droid-exec/overview#auto-medium-development-operations)
  * [--auto high - Production Operations](https://docs.factory.ai/cli/droid-exec/overview#auto-high-production-operations)
  * [--skip-permissions-unsafe - Bypass All Checks](https://docs.factory.ai/cli/droid-exec/overview#skip-permissions-unsafe-bypass-all-checks)
  * [Fail-fast Behavior](https://docs.factory.ai/cli/droid-exec/overview#fail-fast-behavior)
  * [Output formats and artifacts](https://docs.factory.ai/cli/droid-exec/overview#output-formats-and-artifacts)
  * [text (default)](https://docs.factory.ai/cli/droid-exec/overview#text-default)
  * [json](https://docs.factory.ai/cli/droid-exec/overview#json)
  * [debug](https://docs.factory.ai/cli/droid-exec/overview#debug)
  * [Working directory](https://docs.factory.ai/cli/droid-exec/overview#working-directory)
  * [Models and reasoning effort](https://docs.factory.ai/cli/droid-exec/overview#models-and-reasoning-effort)
  * [Batch and parallel patterns](https://docs.factory.ai/cli/droid-exec/overview#batch-and-parallel-patterns)
  * [Unique usage examples](https://docs.factory.ai/cli/droid-exec/overview#unique-usage-examples)
  * [Exit behavior](https://docs.factory.ai/cli/droid-exec/overview#exit-behavior)
  * [Best practices](https://docs.factory.ai/cli/droid-exec/overview#best-practices)


Droid Exec (Headless)
# Overview
Copy page
Non-interactive execution mode for CI/CD pipelines and automation scripts.
Copy page
#
[​](https://docs.factory.ai/cli/droid-exec/overview#droid-exec-headless-cli)
Droid Exec (Headless CLI)
Droid Exec is Factory’s headless execution mode designed for automation workflows. Unlike the interactive CLI, `droid exec` runs as a one-shot command that completes a task and exits, making it ideal for CI/CD pipelines, shell scripts, and batch processing.
##
[​](https://docs.factory.ai/cli/droid-exec/overview#summary-and-goals)
Summary and goals
Droid Exec is a one-shot task runner designed to:
  * Produce readable logs, and structured artifacts when requested
  * Enforce opt-in for mutations/command execution (secure-by-default)
  * Fail fast on permission violations with clear errors
  * Support simple composition for batch and parallel work


## Non-Interactive
Single run execution that writes to stdout/stderr for CI/CD integration
## Secure by Default
Read-only by default with explicit opt-in for mutations via autonomy levels
## Composable
Designed for shell scripting, parallel execution, and pipeline integration
## Clean Output
Structured output formats and artifacts for automated processing
##
[​](https://docs.factory.ai/cli/droid-exec/overview#execution-model)
Execution model
  * Non-interactive single run that writes to stdout/stderr.
  * Default is spec-mode: the agent is only allowed to execute read-only operations.
  * Add `--auto` to enable edits and commands; risk tiers gate what can run.

CLI help (excerpt):
Copy
Ask AI
```
Usage: droid exec [options] [prompt]
Execute a single command (non-interactive mode)
Arguments:
 prompt             The prompt to execute
Options:
 -o, --output-format <format>  Output format (default: "text")
 -f, --file <path>        Read prompt from file
 --auto <level>         Autonomy level: low|medium|high
 --skip-permissions-unsafe    Skip ALL permission checks (unsafe)
 -s, --session-id <id>      Existing session to continue (requires a prompt)
 -m, --model <id>        Model ID to use
 -r, --reasoning-effort <level> Reasoning effort: off|low|medium|high
 --cwd <path>          Working directory path
 -h, --help           display help for command

```

Supported models (examples):
  * gpt-5-codex (default)
  * gpt-5-2025-08-07
  * claude-sonnet-4-20250514
  * claude-opus-4-1-20250805


##
[​](https://docs.factory.ai/cli/droid-exec/overview#installation)
Installation
1
Install Droid CLI
macOS/Linux
Windows
Copy
Ask AI
```
curl -fsSL https://app.factory.ai/cli | sh

```

2
Get Factory API Key
Generate your API key from the [Factory Settings Page](https://app.factory.ai/settings/api-keys)
3
Set Environment Variable
Export your API key as an environment variable:
Copy
Ask AI
```
export FACTORY_API_KEY=fk-...

```

##
[​](https://docs.factory.ai/cli/droid-exec/overview#quickstart)
Quickstart
  * Direct prompt:
    * `droid exec "analyze code quality"`
    * `droid exec "fix the bug in src/main.js" --auto low`
  * From file:
    * `droid exec -f prompt.md`
  * Pipe:
    * `echo "summarize repo structure" | droid exec`
  * Session continuation:
    * `droid exec --session-id <session-id> "continue with next steps"`


##
[​](https://docs.factory.ai/cli/droid-exec/overview#autonomy-levels)
Autonomy Levels
Droid exec uses a tiered autonomy system to control what operations the agent can perform. By default, it runs in read-only mode, requiring explicit flags to enable modifications.
###
[​](https://docs.factory.ai/cli/droid-exec/overview#default-no-flags-read-only-mode)
DEFAULT (no flags) - Read-only Mode
The safest mode for reviewing planned changes without execution:
  * ✅ Reading files or logs: cat, less, head, tail, systemctl status
  * ✅ Display commands: echo, pwd
  * ✅ Information gathering: whoami, date, uname, ps, top
  * ✅ Git read operations: git status, git log, git diff
  * ✅ Directory listing: ls, find (without -delete or -exec)
  * ❌ No modifications to files or system
  * **Use case:** Safe for reviewing what changes would be made


Copy
Ask AI
```
# Analyze and plan refactoring without making changes
droid exec "Analyze the authentication system and create a detailed plan for migrating from session-based auth to OAuth2. List all files that would need changes and describe the modifications required."
# Review code quality and generate report
droid exec "Review the codebase for security vulnerabilities, performance issues, and code smells. Generate a prioritized list of improvements needed."
# Understand project structure
droid exec "Analyze the project architecture and create a dependency graph showing how modules interact with each other."

```

###
[​](https://docs.factory.ai/cli/droid-exec/overview#auto-low-low-risk-operations)
`--auto low` - Low-risk Operations
Enables basic file operations while blocking system changes:
  * ✅ File creation/editing in project directories
  * ❌ No system modifications or package installations
  * **Use case:** Documentation updates, code formatting, adding comments


Copy
Ask AI
```
# Safe file operations
droid exec --auto low "add JSDoc comments to all functions"
droid exec --auto low "fix typos in README.md"

```

###
[​](https://docs.factory.ai/cli/droid-exec/overview#auto-medium-development-operations)
`--auto medium` - Development Operations
Operations that may have significant side effects, but these side effects are typically harmless and straightforward to recover from. Adds common development tasks to low-risk operations:
  * Installing packages from trusted sources: npm install, pip install (without sudo)
  * Network requests to trusted endpoints: curl, wget to known APIs
  * Git operations that modify local repositories: git commit, git checkout, git pull (but not git push)
  * Building code with tools like make, npm run build, mvn compile
  * ❌ No git push, sudo commands, or production changes
  * **Use case:** Local development, testing, dependency management


Copy
Ask AI
```
# Development tasks
droid exec --auto medium "install deps, run tests, fix issues"
droid exec --auto medium "update packages and resolve conflicts"

```

###
[​](https://docs.factory.ai/cli/droid-exec/overview#auto-high-production-operations)
`--auto high` - Production Operations
Commands that may have security implications such as data transfers between untrusted sources or execution of unknown code, or major side effects such as irreversible data loss or modifications of production systems/deployments.
  * Running arbitrary/untrusted code: curl | bash, eval, executing downloaded scripts
  * Exposing ports or modifying firewall rules that could allow external access
  * Git push operations that modify remote repositories: git push, git push —force
  * Irreversible actions to production deployments, database migrations, or other sensitive operations
  * Commands that access or modify sensitive information like passwords or keys
  * ❌ Still blocks: sudo rm -rf /, system-wide changes
  * **Use case:** CI/CD pipelines, automated deployments


Copy
Ask AI
```
# Full workflow automation
droid exec --auto high "fix bug, test, commit, and push to main"
droid exec --auto high "deploy to staging after running tests"

```

###
[​](https://docs.factory.ai/cli/droid-exec/overview#skip-permissions-unsafe-bypass-all-checks)
`--skip-permissions-unsafe` - Bypass All Checks
DANGEROUS: This mode allows ALL operations without confirmation. Only use in completely isolated environments like Docker containers or throwaway VMs.
  * ⚠️ Allows ALL operations without confirmation
  * ⚠️ Can execute irreversible operations
  * Cannot be combined with —auto flags
  * **Use case:** Isolated environments


Copy
Ask AI
```
# In a disposable Docker container for CI testing
docker run --rm -v $(pwd):/workspace alpine:latest sh -c "
 apk add curl bash &&
 curl -fsSL https://app.factory.ai/cli | sh &&
 droid exec --skip-permissions-unsafe 'Install all system dependencies, modify system configs, run integration tests that require root access, and clean up test databases'
"
# In ephemeral GitHub Actions runner for rapid iteration
# where the runner is destroyed after each job
droid exec --skip-permissions-unsafe "Modify /etc/hosts for test domains, install custom kernel modules, run privileged container tests, and reset network interfaces"
# In a temporary VM for security testing
droid exec --skip-permissions-unsafe "Run penetration testing tools, modify firewall rules, test privilege escalation scenarios, and generate security audit reports"

```

###
[​](https://docs.factory.ai/cli/droid-exec/overview#fail-fast-behavior)
Fail-fast Behavior
If a requested action exceeds the current autonomy level, droid exec will:
  1. Stop immediately with a clear error message
  2. Return a non-zero exit code
  3. Not perform any partial changes

This ensures predictable behavior in automation scripts and CI/CD pipelines.
##
[​](https://docs.factory.ai/cli/droid-exec/overview#output-formats-and-artifacts)
Output formats and artifacts
Droid exec supports three output formats for different use cases:
###
[​](https://docs.factory.ai/cli/droid-exec/overview#text-default)
text (default)
Human-readable output for direct consumption or logs:
Copy
Ask AI
```
$ droid exec --auto low "create a python file that prints 'hello world'"
Perfect! I've created a Python file named `hello_world.py` in your home directory that prints 'hello world' when executed.

```

###
[​](https://docs.factory.ai/cli/droid-exec/overview#json)
json
Structured JSON output for parsing in scripts and automation:
Copy
Ask AI
```
$ droid exec "summarize this repository" --output-format json
{
 "type": "result",
 "subtype": "success",
 "is_error": false,
 "duration_ms": 5657,
 "num_turns": 1,
 "result": "This is a Factory documentation repository containing guides for CLI tools, web platform features, and onboarding procedures...",
 "session_id": "8af22e0a-d222-42c6-8c7e-7a059e391b0b"
}

```

Use JSON format when you need to:
  * Parse the result in a script
  * Check success/failure programmatically
  * Extract session IDs for continuation
  * Process results in a pipeline


###
[​](https://docs.factory.ai/cli/droid-exec/overview#debug)
debug
Streaming messages showing the agent’s execution in real-time:
Copy
Ask AI
```
$ droid exec "run ls command" --output-format debug
{"type":"message","role":"user","text":"run ls command"}
{"type":"message","role":"assistant","text":"I'll run the ls command to list the contents..."}
{"type":"tool_call","toolName":"Execute","parameters":{"command":"ls -la"}}
{"type":"tool_result","value":"total 16\ndrwxr-xr-x@ 8 user staff..."}
{"type":"message","role":"assistant","text":"The ls command has been executed successfully..."}

```

Debug format is useful for:
  * Monitoring agent behavior
  * Troubleshooting execution issues
  * Understanding tool usage patterns
  * Real-time progress tracking

For automated pipelines, you can also direct the agent to write specific artifacts:
Copy
Ask AI
```
droid exec --auto low "Analyze dependencies and write to deps.json"
droid exec --auto low "Generate metrics report in CSV format to metrics.csv"

```

##
[​](https://docs.factory.ai/cli/droid-exec/overview#working-directory)
Working directory
  * Use `--cwd` to scope execution:


Copy
Ask AI
```
droid exec --cwd /home/runner/work/repo "Map internal packages and dump graphviz DOT to deps.dot"

```

##
[​](https://docs.factory.ai/cli/droid-exec/overview#models-and-reasoning-effort)
Models and reasoning effort
  * Choose a model with `-m` and adjust reasoning with `-r`:


Copy
Ask AI
```
droid exec -m claude-sonnet-4-20250514 -r medium -f plan.md

```

##
[​](https://docs.factory.ai/cli/droid-exec/overview#batch-and-parallel-patterns)
Batch and parallel patterns
Shell loops (bounded concurrency):
Copy
Ask AI
```
# Process files in parallel (GNU xargs -P)
find src -name "*.ts" -print0 | xargs -0 -P 4 -I {} \
 droid exec --auto low "Refactor file: {} to use modern TS patterns"

```

Background job parallelization:
Copy
Ask AI
```
# Process multiple directories in parallel with job control
for path in packages/ui packages/models apps/factory-app; do
 (
  cd "$path" &&
  droid exec --auto low "Run targeted analysis and write report.md"
 ) &
done
wait # Wait for all background jobs to complete

```

Chunked inputs:
Copy
Ask AI
```
# Split large file lists into manageable chunks
git diff --name-only origin/main...HEAD | split -l 50 - /tmp/files_
for f in /tmp/files_*; do
 list=$(tr '\n' ' ' < "$f")
 droid exec --auto low "Review changed files: $list and write to review.json"
done
rm /tmp/files_* # Clean up temporary files

```

Workflow Automation (CI/CD):
Copy
Ask AI
```
# Dead code detection and cleanup suggestions
name: Code Cleanup Analysis
on:
 schedule:
  - cron: '0 1 * * 0' # Weekly on Sundays
 workflow_dispatch:
jobs:
 cleanup-analysis:
  strategy:
   matrix:
    module: ['src/components', 'src/services', 'src/utils', 'src/hooks']
  steps:
   - uses: actions/checkout@v4
   - run: droid exec --cwd "${{ matrix.module }}" --auto low "Identify unused exports, dead code, and deprecated patterns. Generate cleanup recommendations in cleanup-report.md"

```

##
[​](https://docs.factory.ai/cli/droid-exec/overview#unique-usage-examples)
Unique usage examples
License header enforcer:
Copy
Ask AI
```
git ls-files "*.ts" | xargs -I {} \
 droid exec --auto low "Ensure {} begins with the Apache-2.0 header; add it if missing"

```

API contract drift check (read-only):
Copy
Ask AI
```
droid exec "Compare openapi.yaml operations to our TypeScript client methods and write drift.md with any mismatches"

```

Security sweep:
Copy
Ask AI
```
droid exec --auto low "Run a quick audit for sync child_process usage and propose fixes; write findings to sec-audit.csv"

```

##
[​](https://docs.factory.ai/cli/droid-exec/overview#exit-behavior)
Exit behavior
  * 0: success
  * Non-zero: failure (permission violation, tool error, unmet objective). Treat non-zero as failed in CI.


##
[​](https://docs.factory.ai/cli/droid-exec/overview#best-practices)
Best practices
  * Favor `--auto low`; keep mutations minimal and commit/push in scripted steps.
  * Avoid `--skip-permissions-unsafe` unless fully sandboxed.
  * Ask the agent to emit artifacts your pipeline can verify.
  * Use `--cwd` to constrain scope in monorepos.


[Google Gemini](https://docs.factory.ai/cli/byok/google-gemini)[Automated Code Review](https://docs.factory.ai/cli/droid-exec/cookbook/code-review)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
