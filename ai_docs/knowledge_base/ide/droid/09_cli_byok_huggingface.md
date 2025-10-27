# https://docs.factory.ai/cli/byok/huggingface

[Skip to main content](https://docs.factory.ai/cli/byok/huggingface#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Bring Your Own Key
Hugging Face
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
  * [Configuration](https://docs.factory.ai/cli/byok/huggingface#configuration)
  * [Getting Started](https://docs.factory.ai/cli/byok/huggingface#getting-started)
  * [Notes](https://docs.factory.ai/cli/byok/huggingface#notes)


Bring Your Own Key
# Hugging Face
Copy page
Connect to models hosted on Hugging Face’s Inference Providers
Copy page
Connect to thousands of models hosted on Hugging Face’s Inference Providers. Learn more in the [Inference Providers documentation](https://huggingface.co/docs/inference-providers/en/index).
**Model Performance** : Models below 30 billion parameters have shown significantly lower performance on agentic coding tasks. While HuggingFace hosts many smaller models that can be useful for experimentation, they are generally not recommended for production coding work. Consider using models with 30B+ parameters for complex software engineering tasks.
##
[​](https://docs.factory.ai/cli/byok/huggingface#configuration)
Configuration
Configuration examples for `~/.factory/config.json`:
Copy
Ask AI
```
{
 "custom_models": [
  {
   "model_display_name": "GPT OSS 120B [HF Router]",
   "model": "openai/gpt-oss-120b:fireworks-ai",
   "base_url": "https://router.huggingface.co/v1",
   "api_key": "YOUR_HF_TOKEN",
   "provider": "generic-chat-completion-api",
   "max_tokens": 32768
  },
  {
   "model_display_name": "Llama 4 Scout 17B [HF Router]",
   "model": "meta-llama/Llama-4-Scout-17B-16E-Instruct:fireworks-ai",
   "base_url": "https://router.huggingface.co/v1",
   "api_key": "YOUR_HF_TOKEN",
   "provider": "generic-chat-completion-api",
   "max_tokens": 16384
  }
 ]
}

```

##
[​](https://docs.factory.ai/cli/byok/huggingface#getting-started)
Getting Started
  1. Sign up at [huggingface.co](https://huggingface.co)
  2. Get your token from [huggingface.co/settings/tokens](https://huggingface.co/settings/tokens)
  3. Browse models at [huggingface.co/models](https://huggingface.co/models?pipeline_tag=text-generation&inference_provider=all&sort=trending)
  4. Add desired models to your configuration


##
[​](https://docs.factory.ai/cli/byok/huggingface#notes)
Notes
  * Model names must match the exact Hugging Face repository ID
  * Some models require accepting license agreements on HF website first
  * Large models may not be available on free tier


[DeepInfra](https://docs.factory.ai/cli/byok/deepinfra)[Ollama](https://docs.factory.ai/cli/byok/ollama)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
