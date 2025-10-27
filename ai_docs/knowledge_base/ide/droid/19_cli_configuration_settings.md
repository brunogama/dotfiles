# https://docs.factory.ai/cli/configuration/settings

[Skip to main content](https://docs.factory.ai/cli/configuration/settings#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Configuration
Settings
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
  * [Accessing settings](https://docs.factory.ai/cli/configuration/settings#accessing-settings)
  * [Where settings live](https://docs.factory.ai/cli/configuration/settings#where-settings-live)
  * [Available settings](https://docs.factory.ai/cli/configuration/settings#available-settings)
  * [Model](https://docs.factory.ai/cli/configuration/settings#model)
  * [Reasoning effort](https://docs.factory.ai/cli/configuration/settings#reasoning-effort)
  * [Autonomy level](https://docs.factory.ai/cli/configuration/settings#autonomy-level)
  * [Diff mode](https://docs.factory.ai/cli/configuration/settings#diff-mode)
  * [Cloud session sync](https://docs.factory.ai/cli/configuration/settings#cloud-session-sync)
  * [Sound notifications](https://docs.factory.ai/cli/configuration/settings#sound-notifications)
  * [Command allowlist & denylist](https://docs.factory.ai/cli/configuration/settings#command-allowlist-%26-denylist)
  * [Example allow/deny configuration](https://docs.factory.ai/cli/configuration/settings#example-allow%2Fdeny-configuration)
  * [Example configuration](https://docs.factory.ai/cli/configuration/settings#example-configuration)
  * [Need more?](https://docs.factory.ai/cli/configuration/settings#need-more%3F)


Configuration
# Settings
Copy page
Configure how droid behaves and integrates with your workflow.
Copy page
##
[​](https://docs.factory.ai/cli/configuration/settings#accessing-settings)
Accessing settings
To configure droid settings:
  1. Run `droid`
  2. Enter `/settings`
  3. Adjust your preferences interactively

Changes take effect immediately and are saved to your settings file.
##
[​](https://docs.factory.ai/cli/configuration/settings#where-settings-live)
Where settings live
OS| Location
---|---
macOS / Linux| `~/.factory/settings.json`
Windows| `%USERPROFILE%\.factory\settings.json`
If the file doesn’t exist, it’s created with defaults the first time you run **droid**.
##
[​](https://docs.factory.ai/cli/configuration/settings#available-settings)
Available settings
Setting| Options| Default| Description
---|---|---|---
`model`| `sonnet`, `opus`, `GPT-5`, `gpt-5-codex`, `haiku`, `droid-core`, `custom-model`| `sonnet`| The default AI model used by droid
`reasoningEffort`| `off`, `none`, `low`, `medium`, `high` (availability depends on the model)| Model-dependent default| Controls how much structured thinking the model performs.
`autonomyLevel`| `normal`, `spec`, `auto-low`, `auto-medium`, `auto-high`| `normal`| Sets the default autonomy mode when starting droid.
`cloudSessionSync`| `true`, `false`| `true`| Mirror CLI sessions to Factory web.
`diffMode`| `github`, `unified`| `github`| Choose between split GitHub-style diffs and a single-column view.
`completionSound`| `off`, `bell`| `off`| Audio cue when a response finishes.
`commandAllowlist`| Array of commands| Safe defaults provided| Commands that run without extra confirmation.
`commandDenylist`| Array of commands| Restrictive defaults provided| Commands that always require confirmation.
`includeCoAuthoredByDroid`| `true`, `false`| `true`| Automatically append the Droid co-author trailer to commits.
`enableDroidShield`| `true`, `false`| `true`| Enable secret scanning and git guardrails.
`specSaveEnabled`| `true`, `false`| `false`| Persist spec outputs to disk.
`specSaveDir`| File path| `.factory/docs`| Directory used when `specSaveEnabled` is `true`.
`enableCustomDroids`| `true`, `false`| `false`| Toggle the experimental Custom Droids feature.
###
[​](https://docs.factory.ai/cli/configuration/settings#model)
Model
Choose the default AI model that powers your droid:
  * **`sonnet`**- Claude Sonnet 4.5 (recommended, current default)
  * **`opus`**- Claude Opus 4.1 for complex tasks
  * **`GPT-5`**- Latest OpenAI model
  * **`gpt-5-codex`**- Advanced coding-focused model
  * **`haiku`**- Claude Haiku 4.5, fast and cost-effective
  * **`droid-core`**- GLM-4.6 open-source model
  * **`custom-model`**- Your own configured model via BYOK

[You can also add custom models and BYOK.](https://docs.factory.ai/cli/configuration/byok)
###
[​](https://docs.factory.ai/cli/configuration/settings#reasoning-effort)
Reasoning effort
`reasoningEffort` adjusts how much structured thinking the model performs before replying. Available values depend on the model, but typically include:
  * **`off`/`none`** – disable structured reasoning (fastest).
  * **`low`**,**`medium`**,**`high`**– progressively increase deliberation time for more complex reasoning.

Anthropic models default to `off`, while GPT-5 starts on `medium`.
###
[​](https://docs.factory.ai/cli/configuration/settings#autonomy-level)
Autonomy level
`autonomyLevel` controls how proactively droid executes commands when sessions begin. Start at `normal`, or select an `auto-*` preset to pre-authorize additional actions.
###
[​](https://docs.factory.ai/cli/configuration/settings#diff-mode)
Diff mode
Control how droid displays code changes:
  * **`github`**– Side-by-side, higher fidelity render (recommended).
  * **`unified`**– Traditional single-column diff format.


###
[​](https://docs.factory.ai/cli/configuration/settings#cloud-session-sync)
Cloud session sync
When this switch is on, every CLI session is mirrored to Factory web so you can revisit conversations in the browser:
  * **`true`**– Sync sessions to the web app.
  * **`false`**– Keep sessions local only.


###
[​](https://docs.factory.ai/cli/configuration/settings#sound-notifications)
Sound notifications
Configure audio feedback when droid completes a response:
  * **`bell`**– Use the system terminal bell
  * **`off`**– No sound notifications


Access sound settings via `/settings` or `Shift+Tab` → **Settings** in the TUI.
##
[​](https://docs.factory.ai/cli/configuration/settings#command-allowlist-%26-denylist)
Command allowlist & denylist
Use these settings to control which commands droid can execute automatically and which it must never run:
  * **`commandAllowlist`**– Commands in this array are treated as safe and run without additional confirmation, regardless of autonomy prompts. Include only low-risk utilities you rely on frequently (for example`ls` , `pwd`, `dir`).
  * **`commandDenylist`**– Commands in this array always require confirmation and are typically blocked because they are destructive or unsafe (for example recursive`rm` , `mkfs`, or privileged system operations).

Commands that appear in both lists default to the denylist behavior. Any command that is in neither list falls back to the autonomy level you selected for the session.
###
[​](https://docs.factory.ai/cli/configuration/settings#example-allow%2Fdeny-configuration)
Example allow/deny configuration
Copy
Ask AI
```
{
 "commandAllowlist": [
  "ls",
  "pwd",
  "dir"
 ],
 "commandDenylist": [
  "rm -rf /",
  "mkfs",
  "shutdown"
 ]
}

```

Review and update these arrays periodically to match your workflow and security posture, especially when sharing configurations across teams.
##
[​](https://docs.factory.ai/cli/configuration/settings#example-configuration)
Example configuration
Copy
Ask AI
```
{
 "model": "sonnet",
 "reasoningEffort": "low",
 "diffMode": "github",
 "cloudSessionSync": true,
 "completionSound": "bell"
}

```

###
[​](https://docs.factory.ai/cli/configuration/settings#need-more%3F)
Need more?
  * [CLI Overview](https://docs.factory.ai/cli/getting-started/overview) – see the main TUI workflow
  * [CLI Reference](https://docs.factory.ai/cli/configuration/cli-reference) – command flags & options
  * [IDE Integrations](https://docs.factory.ai/cli/configuration/ide-integrations) – editor-specific setup
  * [Custom models & BYOK](https://docs.factory.ai/cli/configuration/byok) - add custom models and API keys


[AGENTS.md](https://docs.factory.ai/cli/configuration/agents-md)[Mixed Models](https://docs.factory.ai/cli/configuration/mixed-models)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
