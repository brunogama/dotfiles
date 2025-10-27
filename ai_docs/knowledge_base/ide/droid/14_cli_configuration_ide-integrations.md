# https://docs.factory.ai/cli/configuration/ide-integrations

[Skip to main content](https://docs.factory.ai/cli/configuration/ide-integrations#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Configuration
IDE Integrations
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
  * [Features](https://docs.factory.ai/cli/configuration/ide-integrations#features)
  * [Installation](https://docs.factory.ai/cli/configuration/ide-integrations#installation)
  * [VS Code](https://docs.factory.ai/cli/configuration/ide-integrations#vs-code)
  * [JetBrains](https://docs.factory.ai/cli/configuration/ide-integrations#jetbrains)
  * [Usage](https://docs.factory.ai/cli/configuration/ide-integrations#usage)
  * [From your IDE](https://docs.factory.ai/cli/configuration/ide-integrations#from-your-ide)
  * [Troubleshooting](https://docs.factory.ai/cli/configuration/ide-integrations#troubleshooting)
  * [VS Code extension not installing](https://docs.factory.ai/cli/configuration/ide-integrations#vs-code-extension-not-installing)
  * [JetBrains plugin not working](https://docs.factory.ai/cli/configuration/ide-integrations#jetbrains-plugin-not-working)
  * [ESC key configuration](https://docs.factory.ai/cli/configuration/ide-integrations#esc-key-configuration)
  * [Common issues](https://docs.factory.ai/cli/configuration/ide-integrations#common-issues)
  * [Next steps](https://docs.factory.ai/cli/configuration/ide-integrations#next-steps)


Configuration
# IDE Integrations
Copy page
Run droid directly inside your editor for richer context and a smoother workflow.
Copy page
Droid works great with any Integrated Development Environment (IDE) that has a terminal. Just run `droid`, and you’re ready to go. In addition, Droid provides dedicated integrations for popular IDEs, which provide features like interactive diff viewing, selection context sharing, and more. These integrations currently exist for:
  * **Visual Studio Code** (including popular forks like Cursor, Windsurf, and VSCodium)
  * **JetBrains IDEs** (including IntelliJ, PyCharm, Android Studio, WebStorm, PhpStorm and GoLand)


##
[​](https://docs.factory.ai/cli/configuration/ide-integrations#features)
Features
  * **Quick launch** : Use keyboard shortcuts to open Droid directly from your editor, or click the Droid button in the UI
  * **Diff viewing** : Code changes can be displayed directly in the IDE diff viewer instead of the terminal
  * **Selection context** : The current selection/tab in the IDE is automatically shared with Droid
  * **File reference shortcuts** : Use keyboard shortcuts to insert file references
  * **Diagnostic sharing** : Diagnostic errors (lint, syntax, etc.) from the IDE are automatically shared with Droid as you work


##
[​](https://docs.factory.ai/cli/configuration/ide-integrations#installation)
Installation
###
[​](https://docs.factory.ai/cli/configuration/ide-integrations#vs-code)
VS Code
To install Droid on VS Code and popular forks like Cursor, Windsurf, and VSCodium:
  1. Open VS Code
  2. Open the integrated terminal
  3. Run `droid` - the extension will auto-install


You can install the [VS Code Extension here](https://marketplace.visualstudio.com/items?itemName=Factory.factory-vscode-extension).
###
[​](https://docs.factory.ai/cli/configuration/ide-integrations#jetbrains)
JetBrains
To install Droid on JetBrains IDEs like IntelliJ, PyCharm, Android Studio, WebStorm, PhpStorm and GoLand, find and install the Factory Droid plugin from the marketplace and restart your IDE. The plugin may also be auto-installed when you run `droid` in the integrated terminal. The IDE must be restarted completely to take effect.
##
[​](https://docs.factory.ai/cli/configuration/ide-integrations#usage)
Usage
###
[​](https://docs.factory.ai/cli/configuration/ide-integrations#from-your-ide)
From your IDE
Run `droid` from your IDE’s integrated terminal, and all features will be active.
##
[​](https://docs.factory.ai/cli/configuration/ide-integrations#troubleshooting)
Troubleshooting
###
[​](https://docs.factory.ai/cli/configuration/ide-integrations#vs-code-extension-not-installing)
VS Code extension not installing
  * Ensure you’re running Droid from VS Code’s integrated terminal
  * Ensure that the CLI corresponding to your IDE is installed:
    * For VS Code: `code` command should be available
    * For Cursor: `cursor` command should be available
    * For Windsurf: `windsurf` command should be available
    * For VSCodium: `codium` command should be available
    * If not installed, use `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows/Linux) and search for “Shell Command: Install ‘code’ command in PATH” (or the equivalent for your IDE)
  * Check that VS Code has permission to install extensions


###
[​](https://docs.factory.ai/cli/configuration/ide-integrations#jetbrains-plugin-not-working)
JetBrains plugin not working
  * Ensure you’re running Droid from the project root directory
  * Check that the JetBrains plugin is enabled in the IDE settings
  * Completely restart the IDE. You may need to do this multiple times


###
[​](https://docs.factory.ai/cli/configuration/ide-integrations#esc-key-configuration)
ESC key configuration
If the ESC key doesn’t interrupt Droid operations in JetBrains terminals:
  1. Go to Settings → Tools → Terminal
  2. Either:
     * Uncheck “Move focus to the editor with Escape”, or
     * Click “Configure terminal keybindings” and delete the “Switch focus to Editor” shortcut
  3. Apply the changes

This allows the ESC key to properly interrupt Droid operations.
###
[​](https://docs.factory.ai/cli/configuration/ide-integrations#common-issues)
Common issues
Symptom| Fix
---|---
**”Editor integration disabled” message**|  Verify the extension/plug-in is installed and that `editorIntegration` matches your editor
CLI cannot find Node/Bun| Ensure the `droid` binary is on the PATH VS Code/JetBrains uses (restart after install)
Missing file context| Save files; unsaved buffers older than 500 KB are skipped for performance
Stale diagnostics| Run **↻ Refresh Diagnostics** command (VS Code Command Palette)
VS Code terminal closes immediately| Check your shell’s startup scripts: they must not auto-exit
Network blocked in corporate proxy| Configure proxy variables in settings or set `HTTP_PROXY`/`HTTPS_PROXY` env vars
For additional help, email support@factory.ai with logs from `~/.factory/logs/`
##
[​](https://docs.factory.ai/cli/configuration/ide-integrations#next-steps)
Next steps
## [SettingsFine-tune thinking budget, tool permissions, and more.](https://docs.factory.ai/cli/configuration/settings)## [Specification ModeSee how editor context improves feature delivery.](https://docs.factory.ai/cli/user-guides/specification-mode)
[Custom Slash Commands](https://docs.factory.ai/cli/configuration/custom-slash-commands)[Custom Droids (Subagents)](https://docs.factory.ai/cli/configuration/custom-droids)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
