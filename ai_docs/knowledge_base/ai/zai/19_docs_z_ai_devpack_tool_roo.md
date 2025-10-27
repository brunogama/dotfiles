# https://docs.z.ai/devpack/tool/roo

Source: [https://docs.z.ai/devpack/tool/roo](https://docs.z.ai/devpack/tool/roo)

---

[Skip to main content](https://docs.z.ai/devpack/tool/roo#content-area)
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
Roo Code
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
  * [Step 1: Installing the Roo Code Plugin](https://docs.z.ai/devpack/tool/roo#step-1%3A-installing-the-roo-code-plugin)
  * [1. Open the Extensions Marketplace](https://docs.z.ai/devpack/tool/roo#1-open-the-extensions-marketplace)
  * [2. Install the Plugin](https://docs.z.ai/devpack/tool/roo#2-install-the-plugin)
  * [Step 2: Configuring API Settings](https://docs.z.ai/devpack/tool/roo#step-2%3A-configuring-api-settings)
  * [Configuration Details](https://docs.z.ai/devpack/tool/roo#configuration-details)
  * [Step 3: Permission Setup and Usage](https://docs.z.ai/devpack/tool/roo#step-3%3A-permission-setup-and-usage)
  * [1. Configure Permissions](https://docs.z.ai/devpack/tool/roo#1-configure-permissions)
  * [2. Start Coding](https://docs.z.ai/devpack/tool/roo#2-start-coding)
  * [Step 4: Vision and Search MCP](https://docs.z.ai/devpack/tool/roo#step-4%3A-vision-and-search-mcp)


Tool Guide
# Roo Code
Copy page
Methods for Using the GLM Coding Plan in Roo Code Plugin
Copy page
Roo Code is an intelligent VS Code plugin that assists with project analysis, code generation, and refactoring—making the development process smoother and more efficient. Roo Code becomes even more powerful with the [GLM Coding Plan](https://z.ai/subscribe?utm_source=zai&utm_medium=link&utm_term=devpack-integration&utm_campaign=Platform_Ops&_channel_track_key=w3mNdY8g) — giving you greater efficiency and stability in project management and code optimization.
Using the GLM Coding Plan, you need config the exclusive Coding API <https://api.z.ai/api/coding/paas/v4> instead of the Common API <https://api.z.ai/api/paas/v4>
##
[​](https://docs.z.ai/devpack/tool/roo#step-1%3A-installing-the-roo-code-plugin)
Step 1: Installing the Roo Code Plugin
###
[​](https://docs.z.ai/devpack/tool/roo#1-open-the-extensions-marketplace)
1. Open the Extensions Marketplace
a. Launch VS Code b. Click the Extensions Marketplace icon on the left sidebar c. Enter `Roo Code` in the search bar d. Locate the `Roo Code` plugin ![Description](https://cdn.bigmodel.cn/markdown/1753687765281r1.png?attname=r1.png)
###
[​](https://docs.z.ai/devpack/tool/roo#2-install-the-plugin)
2. Install the Plugin
a. Click the `Install` button to begin installation b. After installation, select “Trust the Author”
##
[​](https://docs.z.ai/devpack/tool/roo#step-2%3A-configuring-api-settings)
Step 2: Configuring API Settings
###
[​](https://docs.z.ai/devpack/tool/roo#configuration-details)
Configuration Details
Fill in the following information as specified:
> If your Roo Code version is lower and does not have the `China Coding Plan` option, please update the plugin to the latest version first.
  * **API Provider** : Select `Z AI`
  * **Z AI Entrypoint** ：Select `International Coding Plan (https://api.z.ai/api/coding/paas/v4/)`
  * **Z AI API Key** : Input your Z.AI API Key
  * **Model** : Select `glm-4.6` or other model in the list

![Description](https://cdn.bigmodel.cn/markdown/1760942980972image.png?attname=image.png)
##
[​](https://docs.z.ai/devpack/tool/roo#step-3%3A-permission-setup-and-usage)
Step 3: Permission Setup and Usage
###
[​](https://docs.z.ai/devpack/tool/roo#1-configure-permissions)
1. Configure Permissions
Select the permissions you wish to enable based on your needs:
  * File read/write operations
  * Auto-approve execution
  * Project access permissions

![Description](https://cdn.bigmodel.cn/markdown/1753687800340r4.png?attname=r4.png)
###
[​](https://docs.z.ai/devpack/tool/roo#2-start-coding)
2. Start Coding
Enter your requirements in the input box, and Roo Code will assist with:
  * Summarizing the current project structure
  * Analyzing key modules and functionalities
  * Code refactoring and optimization
  * Generating documentation and comments
  * Issue diagnosis and repair suggestions


##
[​](https://docs.z.ai/devpack/tool/roo#step-4%3A-vision-and-search-mcp)
Step 4: Vision and Search MCP
Refer to the [Vision MCP Server](https://docs.z.ai/devpack/mcp/vision-mcp-server) and [Search MCP Server](https://docs.z.ai/devpack/mcp/search-mcp-server) documentation; once configured, you can use them in Roo Code.
Was this page helpful?
YesNo
[Kilo Code](https://docs.z.ai/devpack/tool/kilo)[Crush](https://docs.z.ai/devpack/tool/crush)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
![Description](https://cdn.bigmodel.cn/markdown/1753687765281r1.png?attname=r1.png)
![Description](https://cdn.bigmodel.cn/markdown/1760942980972image.png?attname=image.png)
![Description](https://cdn.bigmodel.cn/markdown/1753687800340r4.png?attname=r4.png)
