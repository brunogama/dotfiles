# https://docs.factory.ai/cli/byok/baseten

[Skip to main content](https://docs.factory.ai/cli/byok/baseten#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Bring Your Own Key
Baseten
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
  * [Configuration](https://docs.factory.ai/cli/byok/baseten#configuration)
  * [Getting Started](https://docs.factory.ai/cli/byok/baseten#getting-started)
  * [Notes](https://docs.factory.ai/cli/byok/baseten#notes)


Bring Your Own Key
# Baseten
Copy page
Deploy and serve custom models with enterprise-grade infrastructure
Copy page
Deploy and serve custom models with Baseten’s enterprise-grade infrastructure for ML model serving.
##
[​](https://docs.factory.ai/cli/byok/baseten#configuration)
Configuration
Add these configurations to `~/.factory/config.json`:
Copy
Ask AI
```
{
 "custom_models": [
  {
   "model_display_name": "Qwen3-Coder-480B [Baseten]",
   "model": "Qwen/Qwen3-Coder-480B-A35B-Instruct",
   "base_url": "https://inference.baseten.co/v1",
   "api_key": "YOUR_BASETEN_API_KEY",
   "provider": "generic-chat-completion-api",
   "max_tokens": 8192
  }
 ]
}

```

##
[​](https://docs.factory.ai/cli/byok/baseten#getting-started)
Getting Started
  1. Sign up at [baseten.co](https://baseten.co)
  2. Deploy a model from their model library or upload your own
  3. Get your API key from the settings page
  4. Find your model ID in the deployment dashboard
  5. Add the configuration to your Factory config


##
[​](https://docs.factory.ai/cli/byok/baseten#notes)
Notes
  * Base URL format: `https://inference.baseten.co/v1`
  * Replace `YOUR_MODEL_ID` with your deployed model’s ID from Baseten dashboard
  * Supports OpenAI-compatible API format
  * Contact Baseten for enterprise features and custom deployments


[Fireworks AI](https://docs.factory.ai/cli/byok/fireworks)[DeepInfra](https://docs.factory.ai/cli/byok/deepinfra)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
