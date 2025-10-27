# https://docs.factory.ai/cli/byok/openai-anthropic

[Skip to main content](https://docs.factory.ai/cli/byok/openai-anthropic#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Bring Your Own Key
OpenAI & Anthropic
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
    * [Overview](https://docs.factory.ai/cli/byok/overview)
    * [Fireworks AI](https://docs.factory.ai/cli/byok/fireworks)
    * [Baseten](https://docs.factory.ai/cli/byok/baseten)
    * [DeepInfra](https://docs.factory.ai/cli/byok/deepinfra)
    * [Hugging Face](https://docs.factory.ai/cli/byok/huggingface)
    * [Ollama](https://docs.factory.ai/cli/byok/ollama)
    * [OpenRouter](https://docs.factory.ai/cli/byok/openrouter)
    * [OpenAI & Anthropic](https://docs.factory.ai/cli/byok/openai-anthropic)
    * [Google Gemini](https://docs.factory.ai/cli/byok/google-gemini)


##### Droid Exec (Headless)
  * [Overview](https://docs.factory.ai/cli/droid-exec/overview)
  * Cookbook


##### Account
  * [Security](https://docs.factory.ai/cli/account/security)
  * [Droid Shield](https://docs.factory.ai/cli/account/droid-shield)


On this page
  * [Configuration](https://docs.factory.ai/cli/byok/openai-anthropic#configuration)
  * [Getting API Keys](https://docs.factory.ai/cli/byok/openai-anthropic#getting-api-keys)
  * [Anthropic](https://docs.factory.ai/cli/byok/openai-anthropic#anthropic)
  * [OpenAI](https://docs.factory.ai/cli/byok/openai-anthropic#openai)
  * [Notes](https://docs.factory.ai/cli/byok/openai-anthropic#notes)


Bring Your Own Key
# OpenAI & Anthropic
Copy page
Use your own API keys for official OpenAI and Anthropic models
Copy page
Use your own API keys for cost control and billing transparency with official OpenAI and Anthropic models.
##
[​](https://docs.factory.ai/cli/byok/openai-anthropic#configuration)
Configuration
Configuration examples for `~/.factory/config.json`:
Copy
Ask AI
```
{
 "custom_models": [
  {
   "model_display_name": "Sonnet 4.5 [Custom]",
   "model": "claude-sonnet-4-5-20250929",
   "base_url": "https://api.anthropic.com",
   "api_key": "YOUR_ANTHROPIC_KEY",
   "provider": "anthropic",
   "max_tokens": 8192
  },
  {
   "model_display_name": "GPT5-Codex [Custom]",
   "model": "gpt-5-codex",
   "base_url": "https://api.openai.com/v1",
   "api_key": "YOUR_OPENAI_KEY",
   "provider": "openai",
   "max_tokens": 16384
  }
 ]
}

```

##
[​](https://docs.factory.ai/cli/byok/openai-anthropic#getting-api-keys)
Getting API Keys
###
[​](https://docs.factory.ai/cli/byok/openai-anthropic#anthropic)
Anthropic
  1. Sign up at [console.anthropic.com](https://console.anthropic.com)
  2. Navigate to API Keys section
  3. Create a new API key
  4. Copy and use in your configuration


###
[​](https://docs.factory.ai/cli/byok/openai-anthropic#openai)
OpenAI
  1. Sign up at [platform.openai.com](https://platform.openai.com)
  2. Go to API Keys section
  3. Create a new secret key
  4. Copy and use in your configuration


##
[​](https://docs.factory.ai/cli/byok/openai-anthropic#notes)
Notes
  * These configurations use the official APIs with full prompt caching support
  * Factory automatically handles prompt caching when available
  * Use `/cost` command in CLI to view cost breakdowns and cache hit rates


[OpenRouter](https://docs.factory.ai/cli/byok/openrouter)[Google Gemini](https://docs.factory.ai/cli/byok/google-gemini)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
