# https://docs.factory.ai/cli/byok/overview

[Skip to main content](https://docs.factory.ai/cli/byok/overview#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Bring Your Own Key
Overview
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
  * [Configuration Reference](https://docs.factory.ai/cli/byok/overview#configuration-reference)
  * [Supported Fields](https://docs.factory.ai/cli/byok/overview#supported-fields)
  * [Understanding Providers](https://docs.factory.ai/cli/byok/overview#understanding-providers)
  * [Prompt Caching](https://docs.factory.ai/cli/byok/overview#prompt-caching)
  * [Verifying Prompt Caching](https://docs.factory.ai/cli/byok/overview#verifying-prompt-caching)
  * [Quick Start](https://docs.factory.ai/cli/byok/overview#quick-start)
  * [Using Custom Models](https://docs.factory.ai/cli/byok/overview#using-custom-models)
  * [Troubleshooting](https://docs.factory.ai/cli/byok/overview#troubleshooting)
  * [Model not appearing in selector](https://docs.factory.ai/cli/byok/overview#model-not-appearing-in-selector)
  * [”Invalid provider” error](https://docs.factory.ai/cli/byok/overview#%E2%80%9Dinvalid-provider%E2%80%9D-error)
  * [Authentication errors](https://docs.factory.ai/cli/byok/overview#authentication-errors)
  * [Local model won’t connect](https://docs.factory.ai/cli/byok/overview#local-model-won%E2%80%99t-connect)
  * [Rate limiting or quota errors](https://docs.factory.ai/cli/byok/overview#rate-limiting-or-quota-errors)
  * [Billing](https://docs.factory.ai/cli/byok/overview#billing)


Bring Your Own Key
# Overview
Copy page
Connect your own API keys, use open source models, or run local models
Copy page
Factory CLI supports custom model configurations through BYOK (Bring Your Own Key). Use your own OpenAI or Anthropic keys, connect to any open source model providers, or run models locally on your hardware. Once configured, switch between models using the `/model` command.
Your API keys remain local and are not uploaded to Factory servers. Custom models are only available in the CLI and won’t appear in Factory’s web or mobile platforms.
![Model selector showing custom models](https://mintcdn.com/factory/76eHQsYrywYjfJno/images/custom_models.png?fit=max&auto=format&n=76eHQsYrywYjfJno&q=85&s=5e8af07b3c42614e2c32c43e8a04d146) [Install the CLI with the 5-minute quickstart →](https://docs.factory.ai/cli/getting-started/quickstart)
##
[​](https://docs.factory.ai/cli/byok/overview#configuration-reference)
Configuration Reference
Add custom models in `~/.factory/config.json` under the `custom_models` array.
###
[​](https://docs.factory.ai/cli/byok/overview#supported-fields)
Supported Fields
Field| Required| Description
---|---|---
`model_display_name`| ✓| Human-friendly name shown in model selector
`model`| ✓| Model identifier sent via API (e.g., `claude-sonnet-4-5-20250929`, `gpt-5-codex`, `qwen3:4b`)
`base_url`| ✓| API endpoint base URL
`api_key`| ✓| Your API key for the provider. Can’t be empty.
`provider`| ✓| One of: `anthropic`, `openai`, or `generic-chat-completion-api`
`max_tokens`| ✓| Maximum output tokens for model responses
##
[​](https://docs.factory.ai/cli/byok/overview#understanding-providers)
Understanding Providers
Factory supports three provider types that determine API compatibility: Provider| API Format| Use For| Documentation
---|---|---|---
`anthropic`| Anthropic Messages API (v1/messages)| Anthropic models on their official API or compatible proxies| [Anthropic Messages API](https://docs.claude.com/en/api/messages)
`openai`| OpenAI Responses API| OpenAI models on their official API or compatible proxies. Required for the newest models like GPT-5 and GPT-5-Codex.| [OpenAI Responses API](https://platform.openai.com/docs/api-reference/responses)
`generic-chat-completion-api`| OpenAI Chat Completions API| OpenRouter, Fireworks, Together AI, Ollama, vLLM, and most open-source providers| [OpenAI Chat Completions API](https://platform.openai.com/docs/api-reference/chat)
Factory is actively verifying Droid’s performance on popular models, but we cannot guarantee that all custom models will work out of the box. Only Anthropic and OpenAI models accessed via their official APIs are fully tested and benchmarked.
**Model Size Consideration** : Models below 30 billion parameters have shown significantly lower performance on agentic coding tasks. While these smaller models can be useful for experimentation and learning, they are generally not recommended for production coding work or complex software engineering tasks.
##
[​](https://docs.factory.ai/cli/byok/overview#prompt-caching)
Prompt Caching
Factory CLI automatically uses prompt caching when available to reduce API costs:
  * **Official providers (`anthropic` , `openai`)**: Factory attempts to use prompt caching via the official APIs. Caching behavior follows each provider’s implementation and requirements.
  * **Generic providers (`generic-chat-completion-api`)**: Prompt caching support varies by provider and cannot be guaranteed. Some providers may support caching, while others may not.


###
[​](https://docs.factory.ai/cli/byok/overview#verifying-prompt-caching)
Verifying Prompt Caching
To check if prompt caching is working correctly with your custom model:
  1. Run a conversation with your custom model
  2. Use the `/cost` command in Droid CLI to view cost breakdowns
  3. Look for cache hit rates and savings in the output

If you’re not seeing expected caching savings, consult your provider’s documentation about their prompt caching support and requirements.
##
[​](https://docs.factory.ai/cli/byok/overview#quick-start)
Quick Start
Choose a provider from the left navigation to see specific configuration examples:
  * **[Fireworks AI](https://docs.factory.ai/cli/byok/fireworks)** - High-performance inference for open-source models
  * **[Baseten](https://docs.factory.ai/cli/byok/baseten)** - Deploy and serve custom models
  * **[DeepInfra](https://docs.factory.ai/cli/byok/deepinfra)** - Cost-effective inference for open-source models
  * **[Hugging Face](https://docs.factory.ai/cli/byok/huggingface)** - Connect to models on HF Inference API
  * **[Ollama](https://docs.factory.ai/cli/byok/ollama)** - Run models locally or in the cloud
  * **[OpenRouter](https://docs.factory.ai/cli/byok/openrouter)** - Access multiple providers through a single interface
  * **[OpenAI& Anthropic](https://docs.factory.ai/cli/byok/openai-anthropic)** - Use your own API keys for official models
  * **[Google Gemini](https://docs.factory.ai/cli/byok/google-gemini)** - Access Google’s Gemini models


##
[​](https://docs.factory.ai/cli/byok/overview#using-custom-models)
Using Custom Models
Once configured, access your custom models in the CLI:
  1. Use the `/model` command
  2. Your custom models appear in a separate “Custom models” section below Factory-provided models
  3. Select any model to start using it

Custom models display with the name you set in `model_display_name`, making it easy to identify different providers and configurations.
##
[​](https://docs.factory.ai/cli/byok/overview#troubleshooting)
Troubleshooting
###
[​](https://docs.factory.ai/cli/byok/overview#model-not-appearing-in-selector)
Model not appearing in selector
  * Check JSON syntax in `~/.factory/config.json`
  * Restart the CLI after making configuration changes
  * Verify all required fields are present


###
[​](https://docs.factory.ai/cli/byok/overview#%E2%80%9Dinvalid-provider%E2%80%9D-error)
”Invalid provider” error
  * Provider must be exactly `anthropic`, `openai`, or `generic-chat-completion-api`
  * Check for typos and ensure proper capitalization


###
[​](https://docs.factory.ai/cli/byok/overview#authentication-errors)
Authentication errors
  * Verify your API key is valid and has available credits
  * Check that the API key has proper permissions
  * Confirm the base URL matches your provider’s documentation


###
[​](https://docs.factory.ai/cli/byok/overview#local-model-won%E2%80%99t-connect)
Local model won’t connect
  * Ensure your local server is running (e.g., `ollama serve`)
  * Verify the base URL is correct and includes `/v1/` suffix if required
  * Check that the model is pulled/available locally


###
[​](https://docs.factory.ai/cli/byok/overview#rate-limiting-or-quota-errors)
Rate limiting or quota errors
  * Check your provider’s rate limits and usage quotas
  * Monitor your usage through your provider’s dashboard


##
[​](https://docs.factory.ai/cli/byok/overview#billing)
Billing
  * You pay your provider directly with no Factory markup or usage fees
  * Track costs and usage in your provider’s dashboard


[Model Context Protocol](https://docs.factory.ai/cli/configuration/mcp)[Fireworks AI](https://docs.factory.ai/cli/byok/fireworks)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
![Model selector showing custom models](https://mintcdn.com/factory/76eHQsYrywYjfJno/images/custom_models.png?w=560&fit=max&auto=format&n=76eHQsYrywYjfJno&q=85&s=b84709a21e42815a025af7923560d8e2)
