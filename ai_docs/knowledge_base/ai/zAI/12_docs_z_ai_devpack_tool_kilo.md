# https://docs.z.ai/devpack/tool/kilo

Source: [https://docs.z.ai/devpack/tool/kilo](https://docs.z.ai/devpack/tool/kilo)

---

[Skip to main content](https://docs.z.ai/devpack/tool/kilo#content-area)
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
Kilo Code
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
  * [Step 1: Installing the Kilo Code Plugin](https://docs.z.ai/devpack/tool/kilo#step-1%3A-installing-the-kilo-code-plugin)
  * [1. Open the Extensions Marketplace](https://docs.z.ai/devpack/tool/kilo#1-open-the-extensions-marketplace)
  * [2. Install the Plugin](https://docs.z.ai/devpack/tool/kilo#2-install-the-plugin)
  * [Step 2. Configuring API Settings](https://docs.z.ai/devpack/tool/kilo#step-2-configuring-api-settings)
  * [1. Select API Key Authentication](https://docs.z.ai/devpack/tool/kilo#1-select-api-key-authentication)
  * [2. Enter Configuration Details](https://docs.z.ai/devpack/tool/kilo#2-enter-configuration-details)
  * [Step 3. Getting Started](https://docs.z.ai/devpack/tool/kilo#step-3-getting-started)
  * [Step 4: Vision and Search MCP](https://docs.z.ai/devpack/tool/kilo#step-4%3A-vision-and-search-mcp)


Tool Guide
# Kilo Code
Copy page
Methods for Using the GLM Coding Plan in Kilo Code plugin
Copy page
Kilo Code is a powerful VS Code plugin with support for MCP (Model Context Protocol), enabling you to generate code, debug, and manage projects directly within the editor — delivering a more efficient and intelligent development experience. Kilo Code’s performance is further enhanced with the [GLM Coding Plan](https://z.ai/subscribe?utm_source=zai&utm_medium=link&utm_term=devpack-integration&utm_campaign=Platform_Ops&_channel_track_key=w3mNdY8g),, helping you achieve greater efficiency and stability in both code creation and project collaboration.
Using the GLM Coding Plan, you need config the exclusive Coding API <https://api.z.ai/api/coding/paas/v4> instead of the Common API <https://api.z.ai/api/paas/v4>
## 
[​](https://docs.z.ai/devpack/tool/kilo#step-1%3A-installing-the-kilo-code-plugin)
Step 1: Installing the Kilo Code Plugin
### 
[​](https://docs.z.ai/devpack/tool/kilo#1-open-the-extensions-marketplace)
1. Open the Extensions Marketplace
a. Launch VS Code b. Click the Extensions Marketplace icon on the left sidebar c. Search for `Kilo Code` in the search bar d. Locate the `Kilo Code` plugin ![Description](https://cdn.bigmodel.cn/markdown/1753687809443k1.jpg?attname=k1.jpg)
### 
[​](https://docs.z.ai/devpack/tool/kilo#2-install-the-plugin)
2. Install the Plugin
a. Click the `Install` button to begin installation b. After installation, choose to trust the developer ![Description](https://cdn.bigmodel.cn/markdown/1753687816703k2.jpg?attname=k2.jpg)
## 
[​](https://docs.z.ai/devpack/tool/kilo#step-2-configuring-api-settings)
Step 2. Configuring API Settings
### 
[​](https://docs.z.ai/devpack/tool/kilo#1-select-api-key-authentication)
1. Select API Key Authentication
Choose `Use your own API key` ![Description](https://cdn.bigmodel.cn/markdown/1753687824352k3.jpg?attname=k3.jpg)
### 
[​](https://docs.z.ai/devpack/tool/kilo#2-enter-configuration-details)
2. Enter Configuration Details
Fill in the following information as specified:
> If your Kilo Code version is outdated and lacks the `International Coding Plan` option, please update the plugin to the latest version.
  * **API Provider** : Select `Z AI`
  * **Z AI Entrypoint** : Select `International Coding Plan (https://api.z.ai/api/coding/paas/v4/)`
  * **Z AI API Key** : Input your Z.AI API Key
  * **Model** : Select `glm-4.6` or any other model from the list

![Description](https://cdn.bigmodel.cn/markdown/1760943118846image.png?attname=image.png)
## 
[​](https://docs.z.ai/devpack/tool/kilo#step-3-getting-started)
Step 3. Getting Started
Once configured, you can enter prompts in the input box to leverage the AI model for various tasks, such as:
  * Analyzing database table structures
  * Calculating statistics and averages
  * Generating and optimizing SQL queries
  * Code generation and refactoring
  * Project analysis and documentation writing


## 
[​](https://docs.z.ai/devpack/tool/kilo#step-4%3A-vision-and-search-mcp)
Step 4: Vision and Search MCP
Refer to the [Vision MCP Server](https://docs.z.ai/devpack/mcp/vision-mcp-server) and [Search MCP Server](https://docs.z.ai/devpack/mcp/search-mcp-server) documentation; once configured, you can use them in Kilo Code.
Was this page helpful?
YesNo
[Open Code](https://docs.z.ai/devpack/tool/opencode)[Roo Code](https://docs.z.ai/devpack/tool/roo)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
![Description](https://cdn.bigmodel.cn/markdown/1753687809443k1.jpg?attname=k1.jpg)
![Description](https://cdn.bigmodel.cn/markdown/1753687824352k3.jpg?attname=k3.jpg)
![Description](https://cdn.bigmodel.cn/markdown/1753687816703k2.jpg?attname=k2.jpg)
