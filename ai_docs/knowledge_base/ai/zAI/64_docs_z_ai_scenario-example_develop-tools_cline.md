# https://docs.z.ai/scenario-example/develop-tools/cline

Source: [https://docs.z.ai/scenario-example/develop-tools/cline](https://docs.z.ai/scenario-example/develop-tools/cline)

---

[Skip to main content](https://docs.z.ai/scenario-example/develop-tools/cline#content-area)
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
Cline
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
  * [Step 1: Installing the Cline Plugin](https://docs.z.ai/scenario-example/develop-tools/cline#step-1%3A-installing-the-cline-plugin)
  * [1. Open the Extensions Marketplace](https://docs.z.ai/scenario-example/develop-tools/cline#1-open-the-extensions-marketplace)
  * [2. Install the Plugin](https://docs.z.ai/scenario-example/develop-tools/cline#2-install-the-plugin)
  * [Step 2: Configuring API Settings](https://docs.z.ai/scenario-example/develop-tools/cline#step-2%3A-configuring-api-settings)
  * [1. Select API Key Method](https://docs.z.ai/scenario-example/develop-tools/cline#1-select-api-key-method)
  * [2. Enter Configuration Information](https://docs.z.ai/scenario-example/develop-tools/cline#2-enter-configuration-information)
  * [Step 3: Getting Started](https://docs.z.ai/scenario-example/develop-tools/cline#step-3%3A-getting-started)
  * [Step 4: Vision and Search MCP](https://docs.z.ai/scenario-example/develop-tools/cline#step-4%3A-vision-and-search-mcp)


Develop Tools
# Cline
Copy page
A complete guide to using the Cline plugin in VS Code to connect to the Z.AI GLM model
Copy page
Cline is a powerful VS Code plugin that allows you to directly use AI models in the editor for tasks such as code generation and file operations.
## 
[​](https://docs.z.ai/scenario-example/develop-tools/cline#step-1%3A-installing-the-cline-plugin)
Step 1: Installing the Cline Plugin
### 
[​](https://docs.z.ai/scenario-example/develop-tools/cline#1-open-the-extensions-marketplace)
1. Open the Extensions Marketplace
a. Open VS Code b. Click the Extensions Marketplace icon on the left c. Enter `cline` in the search box d. Locate the `Cline` extension ![Description](https://cdn.bigmodel.cn/markdown/1753688113562c1.png?attname=c1.png)
### 
[​](https://docs.z.ai/scenario-example/develop-tools/cline#2-install-the-plugin)
2. Install the Plugin
a. Click the `Install` button to install b. After installation, choose to trust the developer ![Description](https://cdn.bigmodel.cn/markdown/1753688124582c2.jpg?attname=c2.jpg)
## 
[​](https://docs.z.ai/scenario-example/develop-tools/cline#step-2%3A-configuring-api-settings)
Step 2: Configuring API Settings
### 
[​](https://docs.z.ai/scenario-example/develop-tools/cline#1-select-api-key-method)
1. Select API Key Method
Choose `Use your own API Key` ![Description](https://cdn.bigmodel.cn/markdown/1753688131403c3.png?attname=c3.png)
### 
[​](https://docs.z.ai/scenario-example/develop-tools/cline#2-enter-configuration-information)
2. Enter Configuration Information
Fill in the relevant information according to the following settings:
  * **API Provider** : Select `OpenAI Compatible`
  * **Base URL** : Enter `https://api.z.ai/api/coding/paas/v4`
  * **API Key** : Enter your Z.AI API Key
  * **Model** : Select “Use custom” and enter the model name (e.g., `glm-4.6`)
  * **Other Configurations** : 
    * Unchecking **Support Images**
    * Adjust **Context Window Size** to `204800`
    * Adjust `temperature` and other params according to your task requirements.

![Description](https://cdn.bigmodel.cn/markdown/1759418929636image.png?attname=image.png)
## 
[​](https://docs.z.ai/scenario-example/develop-tools/cline#step-3%3A-getting-started)
Step 3: Getting Started
Once configured, you can enter your requirements in the input box to let the model assist you with various tasks, such as:
  * Creating and editing files
  * Generating code
  * Refactoring code
  * Explaining code logic
  * Debugging issues

![Description](https://cdn.bigmodel.cn/markdown/1753688145687c5.png?attname=c5.png)
## 
[​](https://docs.z.ai/scenario-example/develop-tools/cline#step-4%3A-vision-and-search-mcp)
Step 4: Vision and Search MCP
Refer to the [Vision MCP Server](https://docs.z.ai/devpack/mcp/vision-mcp-server) and [Search MCP Server](https://docs.z.ai/devpack/mcp/search-mcp-server) documentation; once configured, you can use them in Cline.
Was this page helpful?
YesNo
[Claude Code](https://docs.z.ai/scenario-example/develop-tools/claude)[OpenCode](https://docs.z.ai/scenario-example/develop-tools/opencode)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
![Description](https://cdn.bigmodel.cn/markdown/1753688113562c1.png?attname=c1.png)
![Description](https://cdn.bigmodel.cn/markdown/1753688124582c2.jpg?attname=c2.jpg)
![Description](https://cdn.bigmodel.cn/markdown/1753688131403c3.png?attname=c3.png)
![Description](https://cdn.bigmodel.cn/markdown/1753688145687c5.png?attname=c5.png)
![Description](https://cdn.bigmodel.cn/markdown/1759418929636image.png?attname=image.png)
