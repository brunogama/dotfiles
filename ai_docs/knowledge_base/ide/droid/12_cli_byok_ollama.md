# https://docs.factory.ai/cli/byok/ollama

[Skip to main content](https://docs.factory.ai/cli/byok/ollama#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Bring Your Own Key
Ollama
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
  * [Local Ollama](https://docs.factory.ai/cli/byok/ollama#local-ollama)
  * [Configuration](https://docs.factory.ai/cli/byok/ollama#configuration)
  * [Setup](https://docs.factory.ai/cli/byok/ollama#setup)
  * [Approximate Hardware Requirements](https://docs.factory.ai/cli/byok/ollama#approximate-hardware-requirements)
  * [Ollama Cloud](https://docs.factory.ai/cli/byok/ollama#ollama-cloud)
  * [Recommended Cloud Model](https://docs.factory.ai/cli/byok/ollama#recommended-cloud-model)
  * [Configuration](https://docs.factory.ai/cli/byok/ollama#configuration-2)
  * [Getting Started with Cloud Models](https://docs.factory.ai/cli/byok/ollama#getting-started-with-cloud-models)
  * [Troubleshooting](https://docs.factory.ai/cli/byok/ollama#troubleshooting)
  * [Local server not connecting](https://docs.factory.ai/cli/byok/ollama#local-server-not-connecting)
  * [Model not found](https://docs.factory.ai/cli/byok/ollama#model-not-found)
  * [Notes](https://docs.factory.ai/cli/byok/ollama#notes)


Bring Your Own Key
# Ollama
Copy page
Run models locally on your hardware or use Ollama Cloud
Copy page
Run models locally on your hardware with Ollama, or use Ollama Cloud for hosted inference.
**Performance Notice** : Models below 30 billion parameters have shown significantly lower performance on agentic coding tasks. While smaller models (7B, 13B) can be useful for experimentation and learning, they are generally not recommended for production coding work or complex software engineering tasks.
##
[​](https://docs.factory.ai/cli/byok/ollama#local-ollama)
Local Ollama
Run models entirely on your machine with no internet required.
###
[​](https://docs.factory.ai/cli/byok/ollama#configuration)
Configuration
Configuration examples for `~/.factory/config.json`:
Copy
Ask AI
```
{
 "custom_models": [
  {
   "model_display_name": "Qwen 2.5 Coder 32B [Local]",
   "model": "qwen2.5-coder:32b",
   "base_url": "http://localhost:11434/v1",
   "api_key": "not-needed", # add any non-empty value
   "provider": "generic-chat-completion-api",
   "max_tokens": 16000
  },
  {
   "model_display_name": "Qwen 2.5 Coder 7B [Local]",
   "model": "qwen2.5-coder:7b",
   "base_url": "http://localhost:11434/v1",
   "api_key": "not-needed", # add any non-empty value
   "provider": "generic-chat-completion-api",
   "max_tokens": 4000
  }
 ]
}

```

###
[​](https://docs.factory.ai/cli/byok/ollama#setup)
Setup
**Context Window Configuration** : For optimal performance with Factory, ensure you set the context window to at least 32,000 tokens. You can either:
  * Use the context window slider in the Ollama app (set to 32k minimum)
  * Set environment variable before starting: `OLLAMA_CONTEXT_LENGTH=32000 ollama serve`

Without adequate context, the experience will be significantly degraded.
  1. Install Ollama from [ollama.com/download](https://ollama.com/download)
  2. Pull desired models:
Copy
Ask AI
```
# Recommended models
ollama pull qwen2.5-coder:32b
ollama pull qwen2.5-coder:7b

```

  3. Start the Ollama server with extra context:
Copy
Ask AI
```
OLLAMA_CONTEXT_LENGTH=32000 ollama serve

```

  4. Add configurations to Factory config


###
[​](https://docs.factory.ai/cli/byok/ollama#approximate-hardware-requirements)
Approximate Hardware Requirements
Model Size| RAM Required| VRAM (GPU)
---|---|---
3B params| 4GB| 3GB
7B params| 8GB| 6GB
13B params| 16GB| 10GB
30B params| 32GB| 20GB
70B params| 64GB| 40GB
##
[​](https://docs.factory.ai/cli/byok/ollama#ollama-cloud)
Ollama Cloud
Use Ollama’s cloud service for hosted model inference without local hardware requirements
###
[​](https://docs.factory.ai/cli/byok/ollama#recommended-cloud-model)
Recommended Cloud Model
The best performance for agentic coding has been observed with **qwen3-coder:480b**. For a full list of available cloud models, visit: [ollama.com/search?c=cloud](https://ollama.com/search?c=cloud)
###
[​](https://docs.factory.ai/cli/byok/ollama#configuration-2)
Configuration
Copy
Ask AI
```
{
 "custom_models": [
  {
   "model_display_name": "qwen3-coder [Online]",
   "model": "qwen3-coder:480b-cloud",
   "base_url": "http://localhost:11434/v1/",
   "api_key": "not-needed", # add any non-empty value
   "provider": "generic-chat-completion-api",
   "max_tokens": 128000
  }
 ]
}

```

###
[​](https://docs.factory.ai/cli/byok/ollama#getting-started-with-cloud-models)
Getting Started with Cloud Models
  1. Ensure Ollama is installed and running locally
  2. Cloud models are accessed through your local Ollama instance - no API key needed
  3. Add the configuration above to your Factory config
  4. The model will automatically use cloud compute when requested


##
[​](https://docs.factory.ai/cli/byok/ollama#troubleshooting)
Troubleshooting
###
[​](https://docs.factory.ai/cli/byok/ollama#local-server-not-connecting)
Local server not connecting
  * Ensure Ollama is running: `ollama serve`
  * Check if port 11434 is available
  * Try `curl http://localhost:11434/api/tags` to test


###
[​](https://docs.factory.ai/cli/byok/ollama#model-not-found)
Model not found
  * Pull the model first: `ollama pull model-name`
  * Check exact model name with `ollama list`


##
[​](https://docs.factory.ai/cli/byok/ollama#notes)
Notes
  * Local API doesn’t require authentication (use any placeholder for `api_key`)
  * Models are stored in `~/.ollama/models/`


[Hugging Face](https://docs.factory.ai/cli/byok/huggingface)[OpenRouter](https://docs.factory.ai/cli/byok/openrouter)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
