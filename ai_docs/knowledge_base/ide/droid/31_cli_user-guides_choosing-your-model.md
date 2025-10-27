# https://docs.factory.ai/cli/user-guides/choosing-your-model

[Skip to main content](https://docs.factory.ai/cli/user-guides/choosing-your-model#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
User Guides
Choosing Your Model
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
  * [1 · Current stack rank (October 2025)](https://docs.factory.ai/cli/user-guides/choosing-your-model#1-%C2%B7-current-stack-rank-october-2025)
  * [2 · Match the model to the job](https://docs.factory.ai/cli/user-guides/choosing-your-model#2-%C2%B7-match-the-model-to-the-job)
  * [3 · Switching models mid-session](https://docs.factory.ai/cli/user-guides/choosing-your-model#3-%C2%B7-switching-models-mid-session)
  * [4 · Reasoning effort settings](https://docs.factory.ai/cli/user-guides/choosing-your-model#4-%C2%B7-reasoning-effort-settings)
  * [5 · Bring Your Own Keys (BYOK)](https://docs.factory.ai/cli/user-guides/choosing-your-model#5-%C2%B7-bring-your-own-keys-byok)
  * [Open-source models](https://docs.factory.ai/cli/user-guides/choosing-your-model#open-source-models)
  * [6 · Keep notes on what works](https://docs.factory.ai/cli/user-guides/choosing-your-model#6-%C2%B7-keep-notes-on-what-works)


User Guides
# Choosing Your Model
Copy page
Balance accuracy, speed, and cost by picking the right model and reasoning level for each CLI task.
Copy page
Model quality evolves quickly, and we tune the CLI defaults as the ecosystem shifts. Use this guide as a snapshot of how the major options compare today, and expect to revisit it as we publish updates. This guide was last updated on Wednesday, October 23rd 2025.
##
[​](https://docs.factory.ai/cli/user-guides/choosing-your-model#1-%C2%B7-current-stack-rank-october-2025)
1 · Current stack rank (October 2025)
Rank| Model| Why we reach for it
---|---|---
1| **Claude Sonnet 4.5**|  Recommended daily driver. Excellent balance of quality, speed, and cost for most development tasks. Current CLI default.
2| **GPT-5 Codex**|  Fast iteration loops with strong coding performance. Great for implementation-heavy work at lower cost than Sonnet.
3| **Claude Haiku 4.5**|  Fast and cost-effective for routine tasks, quick iterations, and high-volume automation. Best for speed-sensitive workflows.
4| **Droid Core (GLM-4.6)**|  Open-source model with 0.25× token multiplier. Lightning-fast and budget-friendly for automation, bulk edits, and air-gapped environments.
5| **GPT-5**|  Strong generalist from OpenAI. Choose when you prefer OpenAI ergonomics or need specific GPT features.
6| **Claude Opus 4.1**|  Highest capability for extremely complex work. Use when you need maximum reasoning power for critical architecture decisions or tough problems.
We ship model updates regularly. When a new release overtakes the list above, we update this page and the CLI defaults.
##
[​](https://docs.factory.ai/cli/user-guides/choosing-your-model#2-%C2%B7-match-the-model-to-the-job)
2 · Match the model to the job
Scenario| Recommended model
---|---
**Deep planning, architecture reviews, ambiguous product specs**|  Start with **Sonnet 4.5** for strong reasoning at practical cost. Use **GPT-5 Codex** for faster iteration or **Haiku 4.5** for lighter tasks.
**Full-feature development, large refactors**| **Sonnet 4.5** is the recommended daily driver. Try **GPT-5 Codex** when you want faster loops or **Droid Core** for high-volume work.
**Repeatable edits, summarization, boilerplate generation**| **Haiku 4.5** or **Droid Core** for speed and cost savings. **GPT-5** or **Sonnet 4.5** when you need higher quality.
**CI/CD or automation loops**|  Favor **Haiku 4.5** or **Droid Core** for predictable throughput at low cost. Use **Sonnet 4.5** or **Codex** for complex automation.
**High-volume automation, frequent quick turns**| **Haiku 4.5** for speedy feedback loops. **Droid Core** when cost is critical or you need air-gapped deployment.
**Claude Opus 4.1** remains available for extremely complex architecture decisions or critical work where you need maximum reasoning capability. Most tasks don’t require Opus-level power—start with Sonnet 4.5 and escalate only if needed.
Tip: you can swap models mid-session with `/model` or by toggling in the settings panel (`Shift+Tab` → **Settings**).
##
[​](https://docs.factory.ai/cli/user-guides/choosing-your-model#3-%C2%B7-switching-models-mid-session)
3 · Switching models mid-session
  * Use `/model` (or **Shift+Tab → Settings → Model**) to swap without losing your chat history.
  * If you change providers (e.g. Anthropc to OpenAI), the CLI converts the session transcript between Anthropic and OpenAI formats. The translation is lossy—provider-specific metadata is dropped—but we have not seen accuracy regressions in practice.
  * For the best context continuity, switch models at natural milestones: after a commit, once a PR lands, or when you abandon a failed approach and reset the plan.
  * If you flip back and forth rapidly, expect the assistant to spend a turn re-grounding itself; consider summarizing recent progress when you switch.


##
[​](https://docs.factory.ai/cli/user-guides/choosing-your-model#4-%C2%B7-reasoning-effort-settings)
4 · Reasoning effort settings
  * Anthropic models (Opus/Sonnet/Haiku) show modest gains between Low and High.
  * GPT models respond much more to higher reasoning effort—bumping **GPT-5** or **GPT-5 Codex** to **High** can materially improve planning and debugging.
  * Reasoning effort increases latency and cost, so start Low for simple work and escalate when you need more depth.


Change reasoning effort from `/model` → **Reasoning effort** , or via the settings menu.
##
[​](https://docs.factory.ai/cli/user-guides/choosing-your-model#5-%C2%B7-bring-your-own-keys-byok)
5 · Bring Your Own Keys (BYOK)
Factory ships with managed Anthropic and OpenAI access. If you prefer to run against your own accounts, BYOK is opt-in—see [Bring Your Own Keys](https://docs.factory.ai/cli/configuration/byok) for setup steps, supported providers, and billing notes.
###
[​](https://docs.factory.ai/cli/user-guides/choosing-your-model#open-source-models)
Open-source models
**Droid Core (GLM-4.6)** is an open-source alternative available in the CLI. It’s useful for:
  * **Air-gapped environments** where external API calls aren’t allowed
  * **Cost-sensitive projects** needing unlimited local inference
  * **Privacy requirements** where code cannot leave your infrastructure
  * **Experimentation** with open-source model capabilities

**Note:** GLM-4.6 does not support image attachments. For image-based workflows, use Claude or GPT models. To use open-source models, you’ll need to configure them via BYOK with a local inference server (like Ollama) or a hosted provider. See [BYOK documentation](https://docs.factory.ai/cli/configuration/byok) for setup instructions.
##
[​](https://docs.factory.ai/cli/user-guides/choosing-your-model#6-%C2%B7-keep-notes-on-what-works)
6 · Keep notes on what works
  * Track high-impact workflows (e.g., spec generation vs. quick edits) and which combinations of model + reasoning effort feel best.
  * Ping the community or your Factory contact when you notice a model regression so we can benchmark and update this guidance quickly.


[Auto-Run Mode](https://docs.factory.ai/cli/user-guides/auto-run)[Implementing Large Features](https://docs.factory.ai/cli/user-guides/implementing-large-features)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
