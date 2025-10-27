# https://docs.factory.ai/cli/configuration/custom-droids

[Skip to main content](https://docs.factory.ai/cli/configuration/custom-droids#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Configuration
Custom Droids (Subagents)
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
  * [1 · What are custom droids?](https://docs.factory.ai/cli/configuration/custom-droids#1-%C2%B7-what-are-custom-droids%3F)
  * [2 · Why use them?](https://docs.factory.ai/cli/configuration/custom-droids#2-%C2%B7-why-use-them%3F)
  * [3 · Quick start](https://docs.factory.ai/cli/configuration/custom-droids#3-%C2%B7-quick-start)
  * [4 · Configuration](https://docs.factory.ai/cli/configuration/custom-droids#4-%C2%B7-configuration)
  * [Tool categories → concrete tools](https://docs.factory.ai/cli/configuration/custom-droids#tool-categories-%E2%86%92-concrete-tools)
  * [5 · Managing droids in the UI](https://docs.factory.ai/cli/configuration/custom-droids#5-%C2%B7-managing-droids-in-the-ui)
  * [5.5 · Importing Claude Code subagents](https://docs.factory.ai/cli/configuration/custom-droids#5-5-%C2%B7-importing-claude-code-subagents)
  * [How to import](https://docs.factory.ai/cli/configuration/custom-droids#how-to-import)
  * [What happens during import](https://docs.factory.ai/cli/configuration/custom-droids#what-happens-during-import)
  * [Example import flow](https://docs.factory.ai/cli/configuration/custom-droids#example-import-flow)
  * [Handling tool validation errors](https://docs.factory.ai/cli/configuration/custom-droids#handling-tool-validation-errors)
  * [6 · Using custom droids effectively](https://docs.factory.ai/cli/configuration/custom-droids#6-%C2%B7-using-custom-droids-effectively)
  * [7 · Examples](https://docs.factory.ai/cli/configuration/custom-droids#7-%C2%B7-examples)
  * [Code reviewer (project scope)](https://docs.factory.ai/cli/configuration/custom-droids#code-reviewer-project-scope)
  * [Security sweeper (personal scope)](https://docs.factory.ai/cli/configuration/custom-droids#security-sweeper-personal-scope)
  * [Task coordinator (with live progress)](https://docs.factory.ai/cli/configuration/custom-droids#task-coordinator-with-live-progress)


Configuration
# Custom Droids (Subagents)
Copy page
Create specialized subagents with their own prompts, tool access, and models that droid can delegate work to.
Copy page
Custom droids are reusable subagents defined in Markdown. Each droid carries its own system prompt, model preference, and tooling policy so you can hand off focused tasks—like code review, security checks, or research—without re-typing instructions.
Custom Droids are experimental. You must enable them in settings before they will be picked up.
##
[​](https://docs.factory.ai/cli/configuration/custom-droids#1-%C2%B7-what-are-custom-droids%3F)
1 · What are custom droids?
Custom droids live as `.md` files under either your project’s `.factory/droids/` or your personal `~/.factory/droids/` directory. When enabled, the CLI scans these folders (top-level files only), validates each definition, and exposes them as `subagent_type` targets for the **Task** tool. This lets the primary assistant spin up purpose-built helpers mid-session.
  * **Project droids** sit in `<repo>/.factory/droids/` and are shared with teammates.
  * **Personal droids** live in `~/.factory/droids/` and follow you across workspaces.
  * Project definitions override personal ones when the names match.


##
[​](https://docs.factory.ai/cli/configuration/custom-droids#2-%C2%B7-why-use-them%3F)
2 · Why use them?
  * **Faster delegation** – encode complex checklists once and reuse them with a single tool call.
  * **Stricter safety** – limit an agent to read-only, edit-only, or curated tool sets.
  * **Context isolation** – each subagent runs with a fresh context window, avoiding prompt bloat.
  * **Repeatable reviews** – capture team-specific review, testing, or release gates as code you can version.


##
[​](https://docs.factory.ai/cli/configuration/custom-droids#3-%C2%B7-quick-start)
3 · Quick start
  1. Open **Settings** (`/settings`) and toggle **Custom Droids** under the _Experimental_ section. This persists `"enableCustomDroids"` in `~/.factory/settings.json` and registers the Task tool.
  2. Restart `droid`.
  3. Run `/droids` to launch the Droids menu.
  4. Choose **Create a new Droid** , pick a storage location (project or personal), then follow the wizard to set:
     * Description of what the droid should do
     * System prompt (auto-generated or manually edited)
     * Identifier (name for the droid)
     * Model (or inherit from parent session)
     * Tools (explicit list of tool IDs)
  5. Save. The CLI writes `<name>.md` into the chosen `droids/` directory and normalizes the filename (lowercase, hyphenated).
  6. Ask droid to use it, e.g. “Run the Task tool with subagent `code-reviewer` to review this diff,” or trigger it from automation.

The loader caches scans for ~5 seconds. The current UI instantiates a fresh loader on every open, so changes usually show up on the next visit; a long-running watch is not yet enabled by default.
##
[​](https://docs.factory.ai/cli/configuration/custom-droids#4-%C2%B7-configuration)
4 · Configuration
Each droid file is Markdown with YAML frontmatter.
Copy
Ask AI
```
---
name: code-reviewer
description: Focused reviewer that checks diffs for correctness risks
model: inherit
tools: ["Read", "LS", "Grep", "Glob"]
---
You are the team's senior reviewer. Examine the diff the parent agent shares and:
- flag correctness, security, and migration risks
- list targeted follow-up tasks if changes are required
- confirm tests or manual validation needed before merge
Respond with:
Summary: <one-line finding>
Findings:
- <bullet>
- <bullet>

```

Key metadata fields: Field| Notes
---|---
`name`| Required. Lowercase letters, digits, `-`, `_`. Drives the `subagent_type` value and filename.
`description`| Optional. Shown in the UI list. Keep ≤500 chars.
`model`| `inherit` (use parent session’s model), or specify an available model name. Run `/models` in the CLI to see available options.
`tools`| Tool selection: `undefined` (all tools) or array of tool IDs like `["Read", "Edit", "Execute"]`. Case-sensitive.
Prompts must start with YAML frontmatter containing at least `name` and include a non-empty body. `DroidValidator` surfaces errors (invalid names, unknown models, unknown tools) and warnings (missing description, duplicated tools). Validation issues appear in the CLI logs when a file fails to load.
###
[​](https://docs.factory.ai/cli/configuration/custom-droids#tool-categories-%E2%86%92-concrete-tools)
Tool categories → concrete tools
Category| Tool IDs| Purpose
---|---|---
`read-only`| `Read`, `LS`, `Grep`, `Glob`| Safe analysis and file exploration
`edit`| `Create`, `Edit`, `MultiEdit`, `ApplyPatch`| Code generation and modifications
`execute`| `Execute`| Shell command execution
`web`| `WebSearch`, `FetchUrl`| Internet research and content
`mcp`| Dynamically populated (if any)| Model Context Protocol tools
Explicit arrays must use the tool names above (case-sensitive). Unknown names cause validation errors.
##
[​](https://docs.factory.ai/cli/configuration/custom-droids#5-%C2%B7-managing-droids-in-the-ui)
5 · Managing droids in the UI
`/droids` opens a modal displaying:
  * **List of droids** – shows each droid with:
    * Name and model in parentheses
    * Description preview
    * Location badge (Project / Personal)
    * Tools summary (e.g., “All tools” or count of selected tools)
  * **Create a new Droid** – launches a guided wizard:
    1. Choose location (Project or Personal)
    2. Describe what the droid should do
    3. Generate or manually edit the system prompt
    4. Confirm identifier, model, and tools
  * **Import from Claude Code** – import existing agents from `~/.claude/agents/` as custom droids
  * **Actions** – View, Edit, Delete droids, or Reload to refresh the list


##
[​](https://docs.factory.ai/cli/configuration/custom-droids#5-5-%C2%B7-importing-claude-code-subagents)
5.5 · Importing Claude Code subagents
You can import agents created in Claude Code as custom droids. This lets you reuse your existing Claude Code agents with the Factory Droid system.
###
[​](https://docs.factory.ai/cli/configuration/custom-droids#how-to-import)
How to import
  1. Run `/droids` to open the Droids menu
  2. Press **I** to start the import flow
  3. The CLI scans Claude Code agent directories:
     * **Project scope** : `<repo>/.claude/agents/` (workspace-specific agents)
     * **Personal scope** : `~/.claude/agents/` (personal agents)
  4. Review the list of available agents:
     * Agents marked `(already exists)` are pre-deselected by default
     * Pre-selected agents are those not yet imported to Factory Droids
  5. Press **Space** to toggle individual selections, **A** to toggle all
  6. Press **Enter** to import the selected agents


###
[​](https://docs.factory.ai/cli/configuration/custom-droids#what-happens-during-import)
What happens during import
The import process converts Claude Code agents into Factory Droids:
  1. **Metadata extraction** :
     * Agent name → droid `name`
     * Agent description (including examples and usage guidance) → droid `description`
     * Agent instructions → droid system prompt (body)
  2. **Configuration mapping** :
     * Model: Maps Claude Code model families to Factory models:
       * `inherit` → `inherit`
       * `sonnet` → first available Sonnet model
       * `haiku` → first available Haiku model
       * `opus` → first available Opus model
     * Tools: Maps Claude Code tool names to Factory tools (may show validation warnings if tools don’t map)
     * Location: Imports to Personal `~/.factory/droids/` by default
  3. **Tool validation** :
     * Some Claude Code tools may not have equivalents in Factory
     * Invalid tools are listed with a warning: “Invalid tools: [list]”
     * You can edit the droid to fix tool mappings or adjust tool access
  4. **File creation** :
     * Creates a `.md` file in `~/.factory/droids/` (personal location)
     * Filename is normalized (lowercase, hyphenated)
     * File format: YAML frontmatter + system prompt body
  5. **Import report** :
     * Shows success/failure for each agent
     * Imported agents are immediately available in the droid list
     * You can edit any imported droid to adjust model, tools, or prompt


###
[​](https://docs.factory.ai/cli/configuration/custom-droids#example-import-flow)
Example import flow
**Selection screen** (before import):
Copy
Ask AI
```
Import Droids (.claude/agents)
Project (<repo>/.claude/agents/):
> [x] polite-greeter
 Use this agent when the user requests a greeting, says hello, or asks for a polite
 welcome message. Examples: <example>...
 [ ] code-summarizer
 Use this agent when you need to understand what a code file does without diving into
 implementation details. Examples: <example>...
Personal (~/.claude/agents/):
 [x] security-checker
 Security analysis agent...
↑/↓ navigate • Space select • A toggle all • Enter import • B back

```

**After import** (back in droid list):
Copy
Ask AI
```
Custom Droids
> code-reviewer (gpt-5-codex)
 This droid verifies the correct base branch and committed...
 Location: Project • Tools: All tools
 polite-greeter (claude-opus-4-1-20250805)
 Use this agent when the user requests a greeting, says he...
 Location: Personal • Tools: 1 selected
 code-summarizer (claude-sonnet-4-5-20250929)
 Use this agent when you need to understand what a code fi...
 Location: Personal • Tools: All tools

```

###
[​](https://docs.factory.ai/cli/configuration/custom-droids#handling-tool-validation-errors)
Handling tool validation errors
After importing, if you see **“Invalid tools: [list]”** , it means some Claude Code tools don’t have Factory equivalents:
  1. **View the droid** (press Enter) to see the full tool list
  2. **Edit the droid** (press E) to adjust:
     * Remove invalid tools from the list
     * Keep only valid Factory tools
  3. **Check available tools** - the list shows which Factory tools are available

Common unmapped tools:
  * Claude Code tools like `Write`, `NotebookEdit`, `BrowseURL` don’t exist in Factory
  * Replace with equivalent Factory tools:
    * `Write` → `Edit`, `Create`
    * `BrowseURL` → `WebSearch`, `FetchUrl`
  * Or remove the `tools` section entirely to enable all Factory tools


##
[​](https://docs.factory.ai/cli/configuration/custom-droids#6-%C2%B7-using-custom-droids-effectively)
6 · Using custom droids effectively
  * **Invoke via the Task tool** – when custom droids are enabled, the droid may call it autonomously, or you can request it directly (“Use the subagent `security-auditor` on this change”).
  * **Choose models strategically** – use `inherit` to match the parent session, or specify a different model for specialized tasks:
    * Smaller/faster models for simple analysis and summary tasks (lower cost).
    * Larger/more capable models for complex reasoning, code review, and multi-step analysis.
    * Run `/models` in the CLI to see available options for your workspace.
  * **Limit tool access** – use explicit tool lists to restrict what a subagent can do, preventing unexpected shell commands or other dangerous operations.
  * **Leverage live updates** – the Task tool now streams live progress, showing tool calls, results, and TodoWrite updates in real time as the subagent executes.
  * **Structure output** – organize the prompt to emit sections like `Summary:` and `Findings:` so the Task tool UI can summarize results clearly.
  * **Share and collaborate** – check `.factory/droids/*.md` into your repo so teammates can use shared droids, and version-control prompt updates like code.
  * **Leverage Claude Code agents** – import your existing Claude Code agents (see section 5.5) to reuse them as custom droids in Factory.


##
[​](https://docs.factory.ai/cli/configuration/custom-droids#7-%C2%B7-examples)
7 · Examples
###
[​](https://docs.factory.ai/cli/configuration/custom-droids#code-reviewer-project-scope)
Code reviewer (project scope)
Copy
Ask AI
```
---
name: code-reviewer
description: Reviews diffs for correctness, tests, and migration fallout
model: inherit
tools: ["Read", "LS", "Grep", "Glob"]
---
You are the team's principal reviewer. Given the diff and context:
- Summarize the intent of the change.
- Flag correctness risks, missing tests, or rollback hazards.
- Call out any migrations or data changes that need coordination.
Reply with:
Summary: <one-line>
Findings:
- <issue or ✅ No blockers>
 Follow-up:
- <action or leave blank>

```

Use: “Run the subagent `code-reviewer` on the staged diff.”
###
[​](https://docs.factory.ai/cli/configuration/custom-droids#security-sweeper-personal-scope)
Security sweeper (personal scope)
Copy
Ask AI
```
---
name: security-sweeper
description: Looks for insecure patterns in recently edited files
model: inherit
tools: ["Read", "Grep", "WebSearch"]
---
Investigate the files referenced in the prompt for security issues:
- Identify injection, insecure transport, privilege escalation, or secrets exposure.
- Suggest concrete mitigations.
- Link to relevant CWE or internal standards when helpful.
Respond with:
Summary: <headline>
Findings:
- <file>: <issue>
 Mitigations:
- <recommendation>

```

###
[​](https://docs.factory.ai/cli/configuration/custom-droids#task-coordinator-with-live-progress)
Task coordinator (with live progress)
Copy
Ask AI
```
---
name: task-coordinator
description: Coordinates multi-step tasks with live progress updates
model: inherit
tools: Read, Edit, Execute, TodoWrite
---
You are a task coordinator. Break down the goal into actionable steps:
1. Use TodoWrite to create and update a task list
2. For each task, read relevant files and execute commands as needed
3. Report progress in real-time using TodoWrite updates
Keep the task list updated with completion status (pending, in_progress, completed).

```

With custom droids, you capture tribal knowledge as code. Compose specialized prompts once, assign the right tools and models, and let the primary assistant delegate heavy lifts to the subagents you design.
[IDE Integrations](https://docs.factory.ai/cli/configuration/ide-integrations)[AGENTS.md](https://docs.factory.ai/cli/configuration/agents-md)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
