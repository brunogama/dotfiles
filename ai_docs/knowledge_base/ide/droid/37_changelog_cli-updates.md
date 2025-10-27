# https://docs.factory.ai/changelog/cli-updates

[Skip to main content](https://docs.factory.ai/changelog/cli-updates#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Changelog
CLI Updates
[Welcome](https://docs.factory.ai/welcome)[CLI](https://docs.factory.ai/cli/getting-started/overview)[Web Platform](https://docs.factory.ai/web/getting-started/overview)[Onboarding](https://docs.factory.ai/onboarding)[Pricing](https://docs.factory.ai/pricing)[Changelog](https://docs.factory.ai/changelog/1-8)
  * [GitHub](https://github.com/factory-ai/factory)
  * [Discord](https://discord.gg/EQ2DQM2F)


##### Changelog
  * [Factory Release 1.8](https://docs.factory.ai/changelog/1-8)
  * [CLI Updates](https://docs.factory.ai/changelog/cli-updates)


FiltersClear
ImprovementsNew releases
Changelog
# CLI Updates
Copy page
Recent features and improvements to Factory CLI
Copy page
[​](https://docs.factory.ai/changelog/cli-updates#october-21-25)
October 21-25
New releasesImprovements
`v0.22.3`
##
[​](https://docs.factory.ai/changelog/cli-updates#new-features-and-enhancements)
New features and enhancements
  * **Detailed transcript view (Ctrl+O)** : Press Ctrl+O to view comprehensive tool execution details with complete breakdowns for all tool types including Execute, Edit, MultiEdit, Create, and more
  * **Customizable completion sounds** : Configure sound notifications when commands complete, with support for different sounds in focus mode and custom sound file paths
  * **Terminal setup support** : Added automated setup support for Warp, iTerm2, and macOS Terminal with automatic terminal indicators for improved integration
  * **PowerShell update** : Now uses `pwsh.exe` for better PowerShell compatibility and reliability on Windows systems
  * **Drag-and-drop image support** : Attach images to CLI sessions via drag-and-drop for easier multimodal interactions
  * **Custom models in subagents** : Added support for using custom models when executing subagents via Task tool
  * **Custom droid descriptions** : Moved custom droid descriptions to Task tool for better organization and usability
  * **`droid exec`custom model support** : Added support for custom models in droid exec sessions


##
[​](https://docs.factory.ai/changelog/cli-updates#bug-fixes-and-stability)
Bug fixes and stability
  * Resolved issues with prompt caching to improve performance and reduce costs
  * Added model ID logging on CLI tool execution for better observability
  * Limited messages rendered in Ctrl+O view to improve performance with large transcripts
  * Fixed sound files not being included in SEA binary releases
  * Fixed readonly value change issues that caused unexpected behavior
  * Fixed ExitSpecMode flickering issues for smoother user experience
  * Removed duplicate custom models header in settings
  * Improved session persistence to legacy sessions to maintain backward compatibility
  * Fixed infinite render issues on Windows systems
  * Fixed 400 error handling and validation
  * Added model validation error messages for better debugging
  * Fixed certificate loading timing to occur after logging initialization


[​](https://docs.factory.ai/changelog/cli-updates#october-14-20)
October 14-20
Improvements
`v0.21.3`
##
[​](https://docs.factory.ai/changelog/cli-updates#new-features-and-enhancements-2)
New features and enhancements
  * **MCP OAuth support** : Added OAuth authentication support for Model Context Protocol in TUI for secure server connections
  * **System certificates support** : Added support for loading system certificates on Windows and macOS, with additional Windows system certificates support
  * **Fuzzy search implementation** : New fuzzy search for improved CLI command and option discovery
  * **Rewind fork workflow** : Added ability to rewind and fork from previous points in conversation sessions
  * **Bug report enhancements** : Added version, OS, and shell information to bug reports for better troubleshooting
  * **Live updates for subagent tool** : Added real-time progress updates when using the Task tool
  * **Enhanced custom droid prompts** : Improved prompts to encourage more proactive usage of custom droids
  * **Droid Shield optional setting** : Made Droid Shield an optional configurable setting with toggle support


##
[​](https://docs.factory.ai/changelog/cli-updates#bug-fixes-and-stability-2)
Bug fixes and stability
  * Added session_id to stream-json output format for better tracking and debugging
  * Enhanced authentication flow for smoother onboarding
  * Streamlined first-run experience by removing redundant onboarding steps
  * Fixed OAuth callback server port collision issues that prevented authentication
  * Fixed certificate loading timing issues causing TLS errors
  * Improved error metadata logging for better debugging
  * Fixed terminal setup issues across different shell environments
  * Better error messages when ripgrep (rg) isn’t available in PATH
  * Improved handling of corrupted unicode normalization in file paths
  * Fixed impact level default value handling


[​](https://docs.factory.ai/changelog/cli-updates#september-30-october-13)
September 30 - October 13
Improvements
`v0.19.8`
##
[​](https://docs.factory.ai/changelog/cli-updates#new-features-and-enhancements-3)
New features and enhancements
  * **`droid exec`Slack integration** : Added `slack_post_message` tool to droid exec for posting updates to Slack channels
  * **`droid exec`streaming JSON input mode** : Added streaming JSON input mode for multi-turn exec sessions for better automation workflows
  * **`droid exec`tool configuration** : Added ability to enable/disable specific tools in droid exec sessions
  * **`droid exec`pre-created session IDs** : Added support for pre-created session IDs in droid exec for better session management
  * **Initial prompt support** : Added support for launching TUI with an initial prompt via command line
  * **GLM-4.6 support** : Added LLM proxy support for GLM-4.6 with Fireworks, Baseten, and DeepInfra providers
  * **Azure OpenAI for GPT-5** : Added Azure OpenAI support for GPT-5 Codex in TUI
  * **Custom droid generation** : Added auto-generation of custom droids using LLM for faster setup
  * **MCP streamable HTTP servers** : Added support for streamable HTTP MCP servers
  * **Model selector refresh** : Updated model selector UI with improved organization and image support warnings
  * **Tab key auto-complete** : Tab key now auto-completes custom commands without submitting for better UX


##
[​](https://docs.factory.ai/changelog/cli-updates#bug-fixes-and-stability-3)
Bug fixes and stability
  * **`droid exec`session continuation fix** : Fixed droid exec to correctly continue an existing session instead of overwriting session data
  * Dynamic reasoning label for Codex models in UI
  * AGENTS.md source paths now shown in settings for better transparency
  * Better error messages when custom model JSON configuration is broken
  * Manual update instructions when auto-update isn’t available
  * Fixed task subagents to properly terminate on abort
  * Fixed file rename retry logic on Windows systems
  * Fixed backslash rendering issues on Windows
  * Major improvements to custom subagents reliability
  * Fixed task tool subagents prompt for better execution
  * Don’t stop agent on cancelled file edits in spec mode
  * Validated working directory exists before executing ripgrep
  * Fixed subagents to inherit model from TUI parent session
  * Truncated large MCP tool results to prevent context overflow
  * Fixed /cost command with Fireworks cached input
  * Added user-agent header to LLM requests for better tracking
  * Locked down file system permissions for better security
  * Fixed rendering for failed edit calls in spec mode
  * Fixed compaction logic and retry without tool results
  * Applied output transforms before compaction/caching
  * Persisted session’s token usage for accurate cost tracking
  * Fixed /new command to reset timer and sessionId properly
  * Fixed compaction retry without tool results
  * Fixed screenshot reading with unicode normalization fallback


[Factory Release 1.8](https://docs.factory.ai/changelog/1-8)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
