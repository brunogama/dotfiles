# https://docs.z.ai/devpack/tool/droid

Source: [https://docs.z.ai/devpack/tool/droid](https://docs.z.ai/devpack/tool/droid)

---

[Skip to main content](https://docs.z.ai/devpack/tool/droid#content-area)
🚀 **GLM Coding Plan — built for devs: 3× usage, 1/7 cost** • [Limited-Time Offer ➞](https://z.ai/subscribe?utm_campaign=Platform_Ops&_channel_track_key=DaprgHIc)
[Z.AI DEVELOPER DOCUMENT home page![light logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/dark.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=75deefa9dea5bdbc84d4da68885c267f)![dark logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/light.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=c1ecf1af358fa8eeab8c06052337f8f6)](https://z.ai/model-api)
English
Search...
⌘K
  * [API Keys](https://z.ai/manage-apikey/apikey-list)
  * [Payment Method](https://z.ai/manage-apikey/billing)


Search...
Navigation
Tool Guide
Factory Droid
[Guides](https://docs.z.ai/guides/overview/quick-start)[API Reference](https://docs.z.ai/api-reference/introduction)[Scenario Example](https://docs.z.ai/scenario-example/develop-tools/claude)[Coding Plan](https://docs.z.ai/devpack/overview)[Released Notes](https://docs.z.ai/release-notes/new-released)[Terms and Policy](https://docs.z.ai/legal-agreement/privacy-policy)[Help Center](https://docs.z.ai/help/faq)
##### GLM Coding Plan
  * [Overview](https://docs.z.ai/devpack/overview)
  * [Quick Start](https://docs.z.ai/devpack/quick-start)
  * [FAQs](https://docs.z.ai/devpack/faq)


##### MCP Guide
  * [Vision MCP Server](https://docs.z.ai/devpack/mcp/vision-mcp-server)
  * [Web Search MCP Server](https://docs.z.ai/devpack/mcp/search-mcp-server)


##### Tool Guide
  * [Claude Code](https://docs.z.ai/devpack/tool/claude)
  * [Cline](https://docs.z.ai/devpack/tool/cline)
  * [Open Code](https://docs.z.ai/devpack/tool/opencode)
  * [Kilo Code](https://docs.z.ai/devpack/tool/kilo)
  * [Roo Code](https://docs.z.ai/devpack/tool/roo)
  * [Crush](https://docs.z.ai/devpack/tool/crush)
  * [Goose](https://docs.z.ai/devpack/tool/goose)
  * [Factory Droid](https://docs.z.ai/devpack/tool/droid)
  * [Other Tools](https://docs.z.ai/devpack/tool/others)


##### Campaign Rules
  * [Invite Friends, Get Credits](https://docs.z.ai/devpack/credit-campaign-rules)


On this page
  * [Step 1: Installing Factory Droid](https://docs.z.ai/devpack/tool/droid#step-1%3A-installing-factory-droid)
  * [Step 2: Configuring Z.AI GLM Models](https://docs.z.ai/devpack/tool/droid#step-2%3A-configuring-z-ai-glm-models)
  * [1. Get Your Z.AI API Key](https://docs.z.ai/devpack/tool/droid#1-get-your-z-ai-api-key)
  * [2. Configure Custom Models](https://docs.z.ai/devpack/tool/droid#2-configure-custom-models)
  * [Step 3: Start Using Factory Droid](https://docs.z.ai/devpack/tool/droid#step-3%3A-start-using-factory-droid)
  * [1. Launch Droid](https://docs.z.ai/devpack/tool/droid#1-launch-droid)
  * [2. Select Your Z.AI Model](https://docs.z.ai/devpack/tool/droid#2-select-your-z-ai-model)
  * [3. Start Coding](https://docs.z.ai/devpack/tool/droid#3-start-coding)
  * [Key Features](https://docs.z.ai/devpack/tool/droid#key-features)
  * [Resources](https://docs.z.ai/devpack/tool/droid#resources)


Tool Guide
# Factory Droid
Copy page
Methods for Using the GLM Coding Plan in Factory Droid
Copy page
Factory Droid is an enterprise-grade AI coding agent that lives in your terminal and handles end-to-end development workflows. Works seamlessly with [Z.AI’s GLM Coding Plan](https://z.ai/subscribe) for high-performance models at exceptional value.
## 
[​](https://docs.z.ai/devpack/tool/droid#step-1%3A-installing-factory-droid)
Step 1: Installing Factory Droid
**macOS / Linux:**
Copy
```
curl -fsSL https://app.factory.ai/cli | sh

```

**Windows:**
Copy
```
irm https://app.factory.ai/cli/windows | iex

```

## 
[​](https://docs.z.ai/devpack/tool/droid#step-2%3A-configuring-z-ai-glm-models)
Step 2: Configuring Z.AI GLM Models
### 
[​](https://docs.z.ai/devpack/tool/droid#1-get-your-z-ai-api-key)
1. Get Your Z.AI API Key
  1. Visit the [Z.AI API Console](https://z.ai/manage-apikey/apikey-list)
  2. Create an API key if you don’t have one


### 
[​](https://docs.z.ai/devpack/tool/droid#2-configure-custom-models)
2. Configure Custom Models
Factory Droid uses BYOK (Bring Your Own Key) to connect with Z.AI’s GLM models. **Configuration file location**
  * macOS/Linux: `~/.factory/config.json`
  * Windows: `%USERPROFILE%\.factory\config.json`

**For GLM Coding Plan subscribers:**
Copy
```
{
 "custom_models": [
  {
   "model_display_name": "GLM-4.6 [Z.AI]",
   "model": "glm-4.6",
   "base_url": "https://api.z.ai/api/coding/paas/v4",
   "api_key": "YOUR_ZAI_API_KEY",
   "provider": "generic-chat-completion-api",
   "max_tokens": 131072
  }
 ]
}

```

**For standard Z.AI api users:**
Copy
```
{
 "custom_models": [
  {
   "model_display_name": "GLM-4.5 [Z.AI]",
   "model": "glm-4.6",
   "base_url": "https://api.z.ai/api/paas/v4",
   "api_key": "YOUR_ZAI_API_KEY",
   "provider": "generic-chat-completion-api",
   "max_tokens": 131072
  }
 ]
}

```

**Important notes**
  * GLM Coding Plan users must use the Coding API endpoint: `https://api.z.ai/api/coding/paas/v4`
  * Standard plan users use the common API endpoint: `https://api.z.ai/api/paas/v4`
  * Replace `YOUR_ZAI_API_KEY` with your actual API key
  * API keys are stored locally and never uploaded to Factory servers


## 
[​](https://docs.z.ai/devpack/tool/droid#step-3%3A-start-using-factory-droid)
Step 3: Start Using Factory Droid
### 
[​](https://docs.z.ai/devpack/tool/droid#1-launch-droid)
1. Launch Droid
Navigate to your project directory and start droid:
Copy
```
cd /path/to/your/project
droid

```

On first launch, you’ll be prompted to sign in via your browser to connect to Factory’s services.
### 
[​](https://docs.z.ai/devpack/tool/droid#2-select-your-z-ai-model)
2. Select Your Z.AI Model
Once droid is running, use the `/model` command to select your Z.AI GLM model:
Copy
```
/model

```

Your custom Z.AI models will appear in a separate “Custom models” section. Select the GLM model you configured.
### 
[​](https://docs.z.ai/devpack/tool/droid#3-start-coding)
3. Start Coding
Use droid for tasks like analyzing code, implementing features, fixing bugs, reviewing changes, and more.
## 
[​](https://docs.z.ai/devpack/tool/droid#key-features)
Key Features
**Specification Mode**
  * Press **Shift+Tab** to activate
  * Describe features in plain language
  * Get automatic planning before implementation
  * Approve plans before any code changes

**Auto-Run Mode**
  * **Low** : Edits and read-only commands
  * **Medium** : Reversible commands (package installs, builds, local git, etc.)
  * **High** : All commands except explicitly dangerous ones
  * Cycle modes with **Shift+Tab**

**IDE Integration**
  * **VS Code/Cursor/Windsurf** : Auto-installs when you run `droid`
  * **JetBrains** : Install plugin from marketplace
  * Features: Interactive diffs, auto-shares current file/selection, quick launch

**AGENTS.md — Project Conventions** Document your workflow at repo root:
Copy
```
# Build & Test
- Test: `npm test`
- Build: `npm run build`
# Conventions
- TypeScript strict mode
- 100-char line limit
- Tests required for features

```

Droid automatically follows your team’s practices. **Additional Features**
  * Cost tracking with `/cost` command
  * SOC-2 compliant with enterprise deployment options
  * Integrations: Jira, Notion, Slack, GitHub
  * MCP (Model Context Protocol) support
  * Transparent review workflow for every change


## 
[​](https://docs.z.ai/devpack/tool/droid#resources)
Resources
  * **Documentation** : [docs.factory.ai](https://docs.factory.ai/cli/getting-started/overview)
  * **BYOK Configuration** : [docs.factory.ai/cli/byok/overview](https://docs.factory.ai/cli/byok/overview)
  * **Support** : support@factory.ai


Was this page helpful?
YesNo
[Goose](https://docs.z.ai/devpack/tool/goose)[Other Tools](https://docs.z.ai/devpack/tool/others)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
