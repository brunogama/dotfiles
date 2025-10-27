# https://docs.factory.ai/cli/configuration/cli-reference

[Skip to main content](https://docs.factory.ai/cli/configuration/cli-reference#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Configuration
CLI Reference
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
  * [Installation](https://docs.factory.ai/cli/configuration/cli-reference#installation)
  * [CLI commands](https://docs.factory.ai/cli/configuration/cli-reference#cli-commands)
  * [CLI flags](https://docs.factory.ai/cli/configuration/cli-reference#cli-flags)
  * [Autonomy levels](https://docs.factory.ai/cli/configuration/cli-reference#autonomy-levels)
  * [Available models](https://docs.factory.ai/cli/configuration/cli-reference#available-models)
  * [Slash commands (interactive mode)](https://docs.factory.ai/cli/configuration/cli-reference#slash-commands-interactive-mode)
  * [MCP command reference](https://docs.factory.ai/cli/configuration/cli-reference#mcp-command-reference)
  * [Authentication](https://docs.factory.ai/cli/configuration/cli-reference#authentication)
  * [Exit codes](https://docs.factory.ai/cli/configuration/cli-reference#exit-codes)
  * [Common workflows](https://docs.factory.ai/cli/configuration/cli-reference#common-workflows)
  * [Code review](https://docs.factory.ai/cli/configuration/cli-reference#code-review)
  * [Testing and debugging](https://docs.factory.ai/cli/configuration/cli-reference#testing-and-debugging)
  * [Refactoring](https://docs.factory.ai/cli/configuration/cli-reference#refactoring)
  * [CI/CD integration](https://docs.factory.ai/cli/configuration/cli-reference#ci%2Fcd-integration)
  * [See also](https://docs.factory.ai/cli/configuration/cli-reference#see-also)


Configuration
# CLI Reference
Copy page
Complete reference for droid command-line interface, including commands and flags
Copy page
##
[​](https://docs.factory.ai/cli/configuration/cli-reference#installation)
Installation
macOS/Linux
Windows
Copy
Ask AI
```
curl -fsSL https://app.factory.ai/cli | sh

```

The CLI operates in two modes:
  * **Interactive (`droid`)** - Chat-first REPL with slash commands
  * **Non-interactive (`droid exec`)** - Single-shot execution for automation and scripting


##
[​](https://docs.factory.ai/cli/configuration/cli-reference#cli-commands)
CLI commands
Command| Description| Example
---|---|---
`droid`| Start interactive REPL| `droid`
`droid "query"`| Start REPL with initial prompt| `droid "explain this project"`
`droid exec "query"`| Execute task without interactive mode| `droid exec "summarize src/auth"`
`droid exec -f prompt.md`| Load prompt from file| `droid exec -f .factory/prompts/review.md`
`cat file | droid exec`| Process piped content| `git diff | droid exec "draft release notes"`
`droid exec -s <id> "query"`| Resume existing session in exec mode| `droid exec -s session-123 "continue"`
`droid exec --list-tools`| List available tools, then exit| `droid exec --list-tools`
##
[​](https://docs.factory.ai/cli/configuration/cli-reference#cli-flags)
CLI flags
Customize droid’s behavior with command-line flags: Flag| Description| Example
---|---|---
`-f, --file <path>`| Read prompt from a file| `droid exec -f plan.md`
`-m, --model <id>`| Select a specific model (see [model IDs](https://docs.factory.ai/cli/configuration/cli-reference#available-models))| `droid exec -m claude-opus-4-1-20250805`
`-s, --session-id <id>`| Continue an existing session| `droid exec -s session-abc123`
`--auto <level>`| Set [autonomy level](https://docs.factory.ai/cli/configuration/cli-reference#autonomy-levels) (`low`, `medium`, `high`)| `droid exec --auto medium "run tests"`
`--enabled-tools <ids>`| Force-enable specific tools (comma or space separated)| `droid exec --enabled-tools ApplyPatch,Bash`
`--disabled-tools <ids>`| Disable specific tools for this run| `droid exec --disabled-tools execute-cli`
`--list-tools`| Print available tools and exit| `droid exec --list-tools`
`-o, --output-format <format>`| Output format (`text`, `json`, `stream-json`)| `droid exec -o json "document API"`
`--input-format <format>`| Input format (`stream-json` for multi-turn)| `droid exec --input-format stream-json -o stream-json`
`-r, --reasoning-effort <level>`| Override reasoning effort (`off`, `none`, `low`, `medium`, `high`)| `droid exec -r high "debug flaky test"`
`--spec-model <id>`| Use a different model for specification planning| `droid exec --spec-model claude-sonnet-4-5-20250929`
`--use-spec`| Start in specification mode (plan before executing)| `droid exec --use-spec "add user profiles"`
`--skip-permissions-unsafe`| Skip all permission prompts (⚠️ use with extreme caution)| `droid exec --skip-permissions-unsafe`
`--cwd <path>`| Execute from a specific working directory| `droid exec --cwd ../service "run tests"`
`--delegation-url <url>`| Override delegation service endpoint| `droid exec --delegation-url https://custom.factory.ai`
`-v, --version`| Display CLI version| `droid -v`
`-h, --help`| Show help information| `droid --help`
Use `--output-format json` for scripting and automation, allowing you to parse droid’s responses programmatically.
##
[​](https://docs.factory.ai/cli/configuration/cli-reference#autonomy-levels)
Autonomy levels
`droid exec` uses tiered autonomy to control what operations the agent can perform. Only raise access when the environment is safe. Level| Intended for| Notable allowances
---|---|---
 _(default)_|  Read-only reconnaissance| File reads, git diffs, environment inspection
`--auto low`| Safe edits| Create/edit files, run formatters, non-destructive commands
`--auto medium`| Local development| Install dependencies, build/test, local git commits
`--auto high`| CI/CD & orchestration| Git push, deploy scripts, long-running operations
`--skip-permissions-unsafe`| Isolated sandboxes only| Removes all guardrails (⚠️ use only in disposable containers)
**Examples:**
Copy
Ask AI
```
# Default (read-only)
droid exec "Analyze the auth system and create a plan"
# Low autonomy - safe edits
droid exec --auto low "Add JSDoc comments to all functions"
# Medium autonomy - development work
droid exec --auto medium "Install deps, run tests, fix issues"
# High autonomy - deployment
droid exec --auto high "Run tests, commit, and push changes"

```

`--skip-permissions-unsafe` removes all safety checks. Use **only** in isolated environments like Docker containers.
##
[​](https://docs.factory.ai/cli/configuration/cli-reference#available-models)
Available models
Model ID| Name| Reasoning support| Default reasoning
---|---|---|---
`claude-sonnet-4-5-20250929`| Claude Sonnet 4.5| Yes| off
`gpt-5-codex`| GPT-5 Codex (Auto)| No| none
`gpt-5-2025-08-07`| GPT-5| Yes| medium
`claude-opus-4-1-20250805`| Claude Opus 4.1| Yes| off
`claude-haiku-4-5-20251001`| Claude Haiku 4.5| Yes| off
`glm-4.6`| Droid Core (GLM-4.6)| No| none
Custom models configured via [BYOK](https://docs.factory.ai/cli/configuration/byok) use the format: `custom:<alias>` See [Choosing Your Model](https://docs.factory.ai/cli/user-guides/choosing-your-model) for detailed guidance on which model to use for different tasks.
##
[​](https://docs.factory.ai/cli/configuration/cli-reference#slash-commands-interactive-mode)
Slash commands (interactive mode)
Available when running `droid` in interactive mode. Type the command at the prompt: Command| Description
---|---
`/account`| Open Factory account settings in browser
`/billing`| View and manage billing settings
`/bug [title]`| Create a bug report with session data and logs
`/clear`| Start a new session (alias for `/new`)
`/compress [prompt]`| Compress session and move to new one with summary
`/cost`| Show token usage statistics
`/help`| Show available slash commands
`/mcp`| Manage Model Context Protocol servers
`/model`| Switch AI model mid-session
`/new`| Start a new session
`/sessions`| List and select previous sessions
`/settings`| Configure application settings
`/status`| Show current droid status and configuration
`/terminal-setup`| Configure terminal keybindings for Shift+Enter
For detailed information on slash commands, see the [interactive mode documentation](https://docs.factory.ai/cli/getting-started/quickstart#useful-slash-commands).
###
[​](https://docs.factory.ai/cli/configuration/cli-reference#mcp-command-reference)
MCP command reference
The `/mcp` command manages Model Context Protocol servers:
Copy
Ask AI
```
/mcp list          # List all configured servers
/mcp add <name> <command>  # Add stdio-based server
/mcp add --type http <url>  # Add HTTP-based server
/mcp remove <name>      # Remove a server
/mcp get <name>       # Show server details
/mcp enable <name>      # Enable a disabled server
/mcp disable <name>     # Temporarily disable a server

```

See [MCP Configuration](https://docs.factory.ai/cli/configuration/mcp) for complete documentation.
##
[​](https://docs.factory.ai/cli/configuration/cli-reference#authentication)
Authentication
  1. Generate an API key at [app.factory.ai/settings/api-keys](https://app.factory.ai/settings/api-keys)
  2. Set the environment variable:


macOS/Linux
Windows (PowerShell)
Windows (CMD)
Copy
Ask AI
```
export FACTORY_API_KEY=fk-...

```

**Persist the variable** in your shell profile (`~/.bashrc`, `~/.zshrc`, or PowerShell `$PROFILE`) for long-term use.
Never commit API keys to source control. Use environment variables or secure secret management.
##
[​](https://docs.factory.ai/cli/configuration/cli-reference#exit-codes)
Exit codes
Code| Meaning
---|---
`0`| Success
`1`| General runtime error
`2`| Invalid CLI arguments/options
##
[​](https://docs.factory.ai/cli/configuration/cli-reference#common-workflows)
Common workflows
###
[​](https://docs.factory.ai/cli/configuration/cli-reference#code-review)
Code review
Copy
Ask AI
```
# Analysis only
droid exec "Review this PR for security issues"
# With modifications
droid exec --auto low "Review code and add missing type hints"

```

###
[​](https://docs.factory.ai/cli/configuration/cli-reference#testing-and-debugging)
Testing and debugging
Copy
Ask AI
```
# Investigation
droid exec "Analyze failing tests and explain root cause"
# Fix and verify
droid exec --auto medium "Fix failing tests and run test suite"

```

###
[​](https://docs.factory.ai/cli/configuration/cli-reference#refactoring)
Refactoring
Copy
Ask AI
```
# Planning
droid exec "Create refactoring plan for auth module"
# Execution
droid exec --auto low --use-spec "Refactor auth module"

```

###
[​](https://docs.factory.ai/cli/configuration/cli-reference#ci%2Fcd-integration)
CI/CD integration
Copy
Ask AI
```
# GitHub Actions example
- name: Run Droid Analysis
 env:
  FACTORY_API_KEY: ${{ secrets.FACTORY_API_KEY }}
 run: |
  droid exec --auto medium -f .github/prompts/deploy.md

```

##
[​](https://docs.factory.ai/cli/configuration/cli-reference#see-also)
See also
  * [Quickstart guide](https://docs.factory.ai/cli/getting-started/quickstart) - Getting started with Factory CLI
  * [Interactive mode](https://docs.factory.ai/cli/getting-started/quickstart) - Shortcuts, input modes, and features
  * [Choosing your model](https://docs.factory.ai/cli/user-guides/choosing-your-model) - Model selection guidance
  * [Settings](https://docs.factory.ai/cli/configuration/settings) - Configuration options
  * [Custom commands](https://docs.factory.ai/cli/configuration/custom-slash-commands) - Create your own shortcuts
  * [Custom droids](https://docs.factory.ai/cli/configuration/custom-droids) - Build specialized agents
  * [Droid Exec overview](https://docs.factory.ai/cli/droid-exec/overview) - Detailed automation guide
  * [MCP configuration](https://docs.factory.ai/cli/configuration/mcp) - External tool integration


[Implementing Large Features](https://docs.factory.ai/cli/user-guides/implementing-large-features)[Custom Slash Commands](https://docs.factory.ai/cli/configuration/custom-slash-commands)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
