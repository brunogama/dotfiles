# https://docs.factory.ai/cli/configuration/custom-slash-commands

[Skip to main content](https://docs.factory.ai/cli/configuration/custom-slash-commands#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Configuration
Custom Slash Commands
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
  * [1 · Discovery & naming](https://docs.factory.ai/cli/configuration/custom-slash-commands#1-%C2%B7-discovery-%26-naming)
  * [2 · Markdown commands](https://docs.factory.ai/cli/configuration/custom-slash-commands#2-%C2%B7-markdown-commands)
  * [3 · Executable commands](https://docs.factory.ai/cli/configuration/custom-slash-commands#3-%C2%B7-executable-commands)
  * [4 · Managing commands](https://docs.factory.ai/cli/configuration/custom-slash-commands#4-%C2%B7-managing-commands)
  * [5 · Usage patterns](https://docs.factory.ai/cli/configuration/custom-slash-commands#5-%C2%B7-usage-patterns)
  * [6 · Examples](https://docs.factory.ai/cli/configuration/custom-slash-commands#6-%C2%B7-examples)
  * [Code review rubric (Markdown)](https://docs.factory.ai/cli/configuration/custom-slash-commands#code-review-rubric-markdown)
  * [Daily standup helper (Markdown)](https://docs.factory.ai/cli/configuration/custom-slash-commands#daily-standup-helper-markdown)
  * [Regression smoke test (Executable)](https://docs.factory.ai/cli/configuration/custom-slash-commands#regression-smoke-test-executable)


Configuration
# Custom Slash Commands
Copy page
Extend the CLI with reusable Markdown prompts or executable scripts that run from the chat input.
Copy page
Custom slash commands turn repeatable prompts or setup steps into `/shortcuts`. Droid scans a pair of `.factory/commands` folders, turns each file into a command, and pipes the result straight into the conversation or your terminal session.
##
[​](https://docs.factory.ai/cli/configuration/custom-slash-commands#1-%C2%B7-discovery-%26-naming)
1 · Discovery & naming
Scope| Location| Purpose
---|---|---
**Workspace**| `<repo>/.factory/commands`|  Project-specific commands shared with teammates. Overrides any personal command with the same slug.
**Personal**| `~/.factory/commands`|  Always scanned. Stores private or cross-project shortcuts.
  * Only Markdown (`*.md`) files and files with a leading shebang (`#!`) are registered.
  * Filenames are slugged (lowercase, spaces → `-`, non URL-safe characters dropped). `Code Review.mdx` becomes `/code-review`.
  * Invoke commands from chat with `/command-name optional arguments`. Slash suggestions use the description pulled from the file.
  * Run `/commands` to open the **Custom Commands** manager UI for browsing, reloading (`R`), or importing commands.
  * Commands must live at the top level of the `commands` directory. Nested folders are ignored today.


##
[​](https://docs.factory.ai/cli/configuration/custom-slash-commands#2-%C2%B7-markdown-commands)
2 · Markdown commands
Markdown files render into a system notification that seeds droid’s next turn. Optional YAML frontmatter controls autocomplete metadata.
Copy
Ask AI
```
---
description: Send a code review checklist
argument-hint: <branch-name>
---
Please review `$ARGUMENTS` and summarize any merge blockers, test gaps, and risky areas.
- Highlight security or performance concerns
- Suggest follow-up tasks with owners
- List files that need attention

```

Frontmatter key| Purpose
---|---
`description`| Overrides the generated summary shown in slash suggestions.
`argument-hint`| Appends inline usage hints (e.g., `/code-review <branch-name>`).
`allowed-tools`| Reserved for future use. Safe to omit.
`$ARGUMENTS` expands to everything typed after the command name. If you do not reference `$ARGUMENTS`, the body is sent unchanged.
Markdown output is wrapped in a system notification so the next agent turn immediately sees the prompt.
Positional placeholders like `$1` or `$2` are not supported yet—use `$ARGUMENTS` and parse inside the prompt if you need structured input.
##
[​](https://docs.factory.ai/cli/configuration/custom-slash-commands#3-%C2%B7-executable-commands)
3 · Executable commands
Executable files must start with a valid shebang so the CLI can call the interpreter.
Copy
Ask AI
```
#!/usr/bin/env bash
set -euo pipefail
echo "Preparing $1"
npm install
npm run lint
echo "Ready to deploy $1"

```

  * The executable receives the command arguments (`/deploy feature/login` → `$1=feature/login`).
  * Scripts run from the current working directory and inherit your environment, so they have the same permissions you do.
  * Stdout and stderr (up to 64 KB) plus the script contents are posted back to the chat transcript for transparency. Failures still surface their logs.


##
[​](https://docs.factory.ai/cli/configuration/custom-slash-commands#4-%C2%B7-managing-commands)
4 · Managing commands
  * **Edit or add** files directly in `.factory/commands`. The CLI rescans on launch; press `R` inside `/commands` to reload without restarting.
  * **Import** existing `.agents` or `.claude` commands: open `/commands`, press `I`, select entries, and they copy into your Factory directory.
  * **Remove** a command by deleting its file. Since workspace commands win precedence, deleting the repo version reveals the personal fallback if one exists.


##
[​](https://docs.factory.ai/cli/configuration/custom-slash-commands#5-%C2%B7-usage-patterns)
5 · Usage patterns
  * Keep project workflows under version control inside the repo’s `.factory/commands` so teammates share the same shortcuts.
  * Build idempotent scripts that are safe to rerun; document any cleanup steps in the file itself.
  * Use Markdown templates for checklists, code review rubrics, onboarding instructions, or context packets you frequently provide to droid.
  * Review executable commands like any other source code—treat secrets carefully and prefer referencing environment variables already loaded in your shell.


##
[​](https://docs.factory.ai/cli/configuration/custom-slash-commands#6-%C2%B7-examples)
6 · Examples
###
[​](https://docs.factory.ai/cli/configuration/custom-slash-commands#code-review-rubric-markdown)
Code review rubric (Markdown)
Copy
Ask AI
```
---
description: Ask droid for a structured code review
argument-hint: <branch-or-PR>
---
Review `$ARGUMENTS` and respond with:
1. **Summary** – What changed and why it matters.
2. **Correctness** – Tests, edge cases, and regressions to check.
3. **Risks** – Security, performance, or migration concerns.
4. **Follow-up** – Concrete TODOs for the author.
Include file paths alongside any specific feedback.

```

Invoke with `/review feature/login-flow` to seed droid with a consistent checklist before it inspects the diff.
###
[​](https://docs.factory.ai/cli/configuration/custom-slash-commands#daily-standup-helper-markdown)
Daily standup helper (Markdown)
Copy
Ask AI
```
---
description: Summarize progress for standup
---
Draft a standup update using:
- **Yesterday:** Key wins, merged PRs, or blockers cleared.
- **Today:** Planned work items and their goals.
- **Risks:** Anything at risk of slipping, support needed, or cross-team dependencies.
Keep it to three short bullet sections.

```

Use `/standup` after droid reviews your git history or TODO list to generate a polished update.
###
[​](https://docs.factory.ai/cli/configuration/custom-slash-commands#regression-smoke-test-executable)
Regression smoke test (Executable)
Copy
Ask AI
```
#!/usr/bin/env bash
set -euo pipefail
target=${1:-"src"}
echo "Running lint + unit tests for $target"
npm run lint -- "$target"
npm test -- --runTestsByPath "$target"
echo "Collecting git status"
git status --short
echo "Done"

```

Saved as `smoke.sh`, this shows up as `/smoke`. Pass a path (`/smoke src/widgets/__tests__/widget.test.tsx`) to constrain the checks and share the aggregated output with everyone on the thread. Once set up, custom slash commands compress multi-step prompts or environment setup into a single keystroke, keeping your focus on guiding droid instead of repeating boilerplate.
[CLI Reference](https://docs.factory.ai/cli/configuration/cli-reference)[IDE Integrations](https://docs.factory.ai/cli/configuration/ide-integrations)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
