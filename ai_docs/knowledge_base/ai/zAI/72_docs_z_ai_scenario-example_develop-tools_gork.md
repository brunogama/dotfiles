# https://docs.z.ai/scenario-example/develop-tools/gork

Source: [https://docs.z.ai/scenario-example/develop-tools/gork](https://docs.z.ai/scenario-example/develop-tools/gork)

---

[Skip to main content](https://docs.z.ai/scenario-example/develop-tools/gork#content-area)
🚀 **GLM Coding Plan — built for devs: 3× usage, 1/7 cost** • [Limited-Time Offer ➞](https://z.ai/subscribe?utm_campaign=Platform_Ops&_channel_track_key=DaprgHIc)
[Z.AI DEVELOPER DOCUMENT home page![light logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/dark.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=75deefa9dea5bdbc84d4da68885c267f)![dark logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/light.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=c1ecf1af358fa8eeab8c06052337f8f6)](https://z.ai/model-api)
English
Search...
⌘K
  * [API Keys](https://z.ai/manage-apikey/apikey-list)
  * [Payment Method](https://z.ai/manage-apikey/billing)


Search...
Navigation
Develop Tools
Grok CLI
[Guides](https://docs.z.ai/guides/overview/quick-start)[API Reference](https://docs.z.ai/api-reference/introduction)[Scenario Example](https://docs.z.ai/scenario-example/develop-tools/claude)[Coding Plan](https://docs.z.ai/devpack/overview)[Released Notes](https://docs.z.ai/release-notes/new-released)[Terms and Policy](https://docs.z.ai/legal-agreement/privacy-policy)[Help Center](https://docs.z.ai/help/faq)
##### Develop Tools
  * [Claude Code](https://docs.z.ai/scenario-example/develop-tools/claude)
  * [Cline](https://docs.z.ai/scenario-example/develop-tools/cline)
  * [OpenCode](https://docs.z.ai/scenario-example/develop-tools/opencode)
  * [Kilo Code](https://docs.z.ai/scenario-example/develop-tools/kilo)
  * [Roo Code](https://docs.z.ai/scenario-example/develop-tools/roo)
  * [Gemini CLI](https://docs.z.ai/scenario-example/develop-tools/gemini)
  * [Grok CLI](https://docs.z.ai/scenario-example/develop-tools/gork)


On this page
  * [Step 1: Installing Grok CLI](https://docs.z.ai/scenario-example/develop-tools/gork#step-1%3A-installing-grok-cli)
  * [Step 2: Environment Configuration](https://docs.z.ai/scenario-example/develop-tools/gork#step-2%3A-environment-configuration)
  * [Step 3: Getting Started](https://docs.z.ai/scenario-example/develop-tools/gork#step-3%3A-getting-started)
  * [Notes](https://docs.z.ai/scenario-example/develop-tools/gork#notes)


Develop Tools
# Grok CLI
Copy page
Quick Start Guide for Connecting to Z.AI GLM Models Using Grok CLI
Copy page
Grok CLI is a streamlined command-line AI assistant that enables quick access to Z.AI’s GLM models for conversation and code generation.
## 
[​](https://docs.z.ai/scenario-example/develop-tools/gork#step-1%3A-installing-grok-cli)
Step 1: Installing Grok CLI
Install Grok CLI globally via npm:
Copy
```
npm install -g @vibe-kit/grok-cli

```

## 
[​](https://docs.z.ai/scenario-example/develop-tools/gork#step-2%3A-environment-configuration)
Step 2: Environment Configuration
Set the API base URL and API Key:
Copy
```
export GROK_BASE_URL="https://api.z.ai/api/coding/paas/v4"
export GROK_API_KEY="your_api_key"

```

## 
[​](https://docs.z.ai/scenario-example/develop-tools/gork#step-3%3A-getting-started)
Step 3: Getting Started
Launch Grok CLI with a specified model:
Copy
```
grok --model glm-4.6

```

![Description](https://cdn.bigmodel.cn/markdown/1753631674840gemini-4.png?attname=gemini-4.png)
## 
[​](https://docs.z.ai/scenario-example/develop-tools/gork#notes)
Notes
> **Important Note** : Grok CLI currently has limited compatibility with thinking models, and thinking content will be displayed in full. Recommendations:
>   * Wait for Grok CLI to improve compatibility with thinking models
>   * Or use non-thinking versions of the models
> 

Was this page helpful?
YesNo
[Gemini CLI](https://docs.z.ai/scenario-example/develop-tools/gemini)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
![Description](https://cdn.bigmodel.cn/markdown/1753631674840gemini-4.png?attname=gemini-4.png)
