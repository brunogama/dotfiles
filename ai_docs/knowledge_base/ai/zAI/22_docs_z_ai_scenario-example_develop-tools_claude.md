# https://docs.z.ai/scenario-example/develop-tools/claude

Source: [https://docs.z.ai/scenario-example/develop-tools/claude](https://docs.z.ai/scenario-example/develop-tools/claude)

---

[Skip to main content](https://docs.z.ai/scenario-example/develop-tools/claude#content-area)
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
Claude Code
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
  * [Step 1: Installing the Claude Code](https://docs.z.ai/scenario-example/develop-tools/claude#step-1%3A-installing-the-claude-code)
  * [Step 2: Config GLM Coding Plan](https://docs.z.ai/scenario-example/develop-tools/claude#step-2%3A-config-glm-coding-plan)
  * [Step 3: Start with Claude Code](https://docs.z.ai/scenario-example/develop-tools/claude#step-3%3A-start-with-claude-code)
  * [FAQ](https://docs.z.ai/scenario-example/develop-tools/claude#faq)
  * [How to Switch the Model in Use](https://docs.z.ai/scenario-example/develop-tools/claude#how-to-switch-the-model-in-use)
  * [Vision and Search MCP](https://docs.z.ai/scenario-example/develop-tools/claude#vision-and-search-mcp)
  * [Manual Configuration Not Work](https://docs.z.ai/scenario-example/develop-tools/claude#manual-configuration-not-work)
  * [Recommended Claude Code Version](https://docs.z.ai/scenario-example/develop-tools/claude#recommended-claude-code-version)


Develop Tools
# Claude Code
Copy page
Methods for integrating the latest GLM-4.5 series models from Z.AI with Claude Code
Copy page
[GLM Coding Plan](https://z.ai/subscribe?utm_source=zai&utm_medium=link&utm_term=glm-coding-plan&utm_campaign=Platform_Ops&_channel_track_key=38C6fsgR) — designed for Claude Code users, starting at $3/month to enjoy a premium coding experience! Exclusive to PRO and higher plans: [Vision Understanding MCP Server](https://docs.z.ai/devpack/mcp/vision-mcp-server) [Web Search MCP Server](https://docs.z.ai/scenario-example/develop-tools/\(/devpack/mcp/search-mcp-server\))
Z.AI’s GLM-4.6 models can be integrated with Claude Code through an Anthropic API-compatible endpoint. This allows Claude Code to communicate with GLM-4.6 without requiring any code modifications to Claude Code itself.
## 
[​](https://docs.z.ai/scenario-example/develop-tools/claude#step-1%3A-installing-the-claude-code)
Step 1: Installing the Claude Code
  * Recommended Installation Method
  * Cursor Guided Installation Method


Prerequisites: [Node.js 18 or newer](https://nodejs.org/en/download/)
Copy
```
# Install Claude Code
npm install -g @anthropic-ai/claude-code
# Navigate to your project
cd your-awesome-project
# Complete
claude

```

**Note** : If you encounter permission issues during installation, try using `sudo` (MacOS/Linux) or running the command prompt as an administrator (Windows) to re-execute the installation command.
## 
[​](https://docs.z.ai/scenario-example/develop-tools/claude#step-2%3A-config-glm-coding-plan)
Step 2: Config GLM Coding Plan
1
Get API Key
  * Access [Z.AI Open Platform](https://z.ai/model-api), Register or Login.
  * Create an API Key in the [API Keys](https://z.ai/manage-apikey/apikey-list) management page.
  * Copy your API Key for use.


2
Configure Environment Variables
Set up environment variables using one of the following methods in the **macOS Linux** or **Windows** :
**Note** : Some commands show no output when setting environment variables — that’s normal as long as no errors appear.
  * For first-time use in scripts (Mac/Linux)
  * Manual configuration (Windows MacOS Linux)


Just run the following command in your terminal
Copy
```
curl -O "https://cdn.bigmodel.cn/install/claude_code_zai_env.sh" && bash ./claude_code_zai_env.sh

```

The script will automatically modify `~/.claude/settings.json` to configure the following environment variables
Copy
```
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "your_zai_api_key",
    "ANTHROPIC_BASE_URL": "https://api.z.ai/api/anthropic",
    "API_TIMEOUT_MS": "3000000"
  }
}

```

## 
[​](https://docs.z.ai/scenario-example/develop-tools/claude#step-3%3A-start-with-claude-code)
Step 3: Start with Claude Code
Once the configuration is complete, you can start using **Claude Code** in your terminal or cmd:
Copy
```
cd your-project-directory
claude

```

> If prompted with “Do you want to use this API key,” select “Yes.”
After launching, grant Claude Code permission to access files in your folder as shown below: ![Description](https://cdn.bigmodel.cn/markdown/1753631613096claude-2.png?attname=claude-2.png) You can use Claude Code for development Now!
## 
[​](https://docs.z.ai/scenario-example/develop-tools/claude#faq)
FAQ
### 
[​](https://docs.z.ai/scenario-example/develop-tools/claude#how-to-switch-the-model-in-use)
How to Switch the Model in Use
Mapping between Claude Code internal model environment variables and GLM models, with the default configuration as follows:
  * `ANTHROPIC_DEFAULT_OPUS_MODEL`: `GLM-4.6`
  * `ANTHROPIC_DEFAULT_SONNET_MODEL`: `GLM-4.6`
  * `ANTHROPIC_DEFAULT_HAIKU_MODEL`: `GLM-4.5-Air`


If adjustments are needed, you can directly modify the configuration file (for example, ~/.claude/settings.json in Claude Code) to switch to other models.
It is generally not recommended to manually adjust the model mapping, as hardcoding the model mapping makes it inconvenient to automatically update to the latest model when the GLM Coding Plan models are updated.
  1. Configure `~/.claude/settings.json` with the following content:


Copy
```
{
 "env": {
  "ANTHROPIC_DEFAULT_HAIKU_MODEL": "glm-4.5-air",
  "ANTHROPIC_DEFAULT_SONNET_MODEL": "glm-4.6",
  "ANTHROPIC_DEFAULT_OPUS_MODEL": "glm-4.6"
 }
}

```

  1. Open a new terminal window and run `claude` to start Claude Code, enter `/status` to check the current model status.

![Description](https://cdn.bigmodel.cn/markdown/1759420390607image.png?attname=image.png)
### 
[​](https://docs.z.ai/scenario-example/develop-tools/claude#vision-and-search-mcp)
Vision and Search MCP
Refer to the [Vision MCP Server](https://docs.z.ai/scenario-example/mcp/vision-mcp-server) and [Search MCP Server](https://docs.z.ai/scenario-example/mcp/search-mcp-server) documentation; once configured, you can use them in Claude Code.
### 
[​](https://docs.z.ai/scenario-example/develop-tools/claude#manual-configuration-not-work)
Manual Configuration Not Work
If you manually modified the `~/.claude/settings.json` configuration file but found the changes did not take effect, refer to the following troubleshooting steps.
  * Close all Claude Code windows, open a new command-line window, and run `claude` again to start.
  * If the issue persists, try deleting the `~/.claude/settings.json` file and then reconfigure the environment variables; Claude Code will automatically generate a new configuration file.
  * Confirm that the JSON format of the configuration file is correct, check the variable names, and ensure there are no missing or extra commas; you can use an online JSON validator tool to check.


### 
[​](https://docs.z.ai/scenario-example/develop-tools/claude#recommended-claude-code-version)
Recommended Claude Code Version
We recommend using the latest version of Claude Code. You can check the current version and upgrade with the following commands:
> We have verified compatibility with Claude Code 2.0.14 and other versions.
Copy
```
# Check the current version
claude --version
2.0.14 (Claude Code)
# Upgrade to the latest
claude update

```

Was this page helpful?
YesNo
[Cline](https://docs.z.ai/scenario-example/develop-tools/cline)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
![Description](https://cdn.bigmodel.cn/markdown/1753631613096claude-2.png?attname=claude-2.png)
![Description](https://cdn.bigmodel.cn/markdown/1759420390607image.png?attname=image.png)
