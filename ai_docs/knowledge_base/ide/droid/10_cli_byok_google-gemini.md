# https://docs.factory.ai/cli/byok/google-gemini

[Skip to main content](https://docs.factory.ai/cli/byok/google-gemini#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Bring Your Own Key
Google Gemini
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
  * [Configuration](https://docs.factory.ai/cli/byok/google-gemini#configuration)
  * [Getting Started](https://docs.factory.ai/cli/byok/google-gemini#getting-started)
  * [Notes](https://docs.factory.ai/cli/byok/google-gemini#notes)


Bring Your Own Key
# Google Gemini
Copy page
Access Google’s Gemini models using your Gemini AI API key
Copy page
Connect to Google’s Gemini models for advanced AI capabilities with multimodal support.
##
[​](https://docs.factory.ai/cli/byok/google-gemini#configuration)
Configuration
Configuration examples for `~/.factory/config.json`:
Copy
Ask AI
```
{
 "custom_models": [
  {
   "model_display_name": "Gemini 2.5 Pro [Google]",
   "model": "gemini-2.5-pro",
   "base_url": "https://generativelanguage.googleapis.com/v1beta/",
   "api_key": "YOUR_GEMINI_API_KEY",
   "provider": "generic-chat-completion-api",
   "max_tokens": 32000
  },
  {
   "model_display_name": "Gemini 1.5 Pro [Google]",
   "model": "gemini-1.5-pro",
   "base_url": "https://generativelanguage.googleapis.com/v1beta/",
   "api_key": "YOUR_GEMINI_API_KEY",
   "provider": "generic-chat-completion-api",
   "max_tokens": 1048576
  },
  {
   "model_display_name": "Gemini 1.5 Flash [Google]",
   "model": "gemini-1.5-flash",
   "base_url": "https://generativelanguage.googleapis.com/v1beta/",
   "api_key": "YOUR_GEMINI_API_KEY",
   "provider": "generic-chat-completion-api",
   "max_tokens": 1048576
  }
 ]
}

```

##
[​](https://docs.factory.ai/cli/byok/google-gemini#getting-started)
Getting Started
  1. Go to [makersuite.google.com/app/apikey](https://makersuite.google.com/app/apikey)
  2. Click “Create API Key”
  3. Copy your API key
  4. Add it to your Factory configuration


##
[​](https://docs.factory.ai/cli/byok/google-gemini#notes)
Notes
  * Base URL uses the `v1beta` API version
  * Gemini models use the `generic-chat-completion-api` provider type


[OpenAI & Anthropic](https://docs.factory.ai/cli/byok/openai-anthropic)[Overview](https://docs.factory.ai/cli/droid-exec/overview)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
