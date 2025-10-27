# https://docs.z.ai/scenario-example/develop-tools/roo

Source: [https://docs.z.ai/scenario-example/develop-tools/roo](https://docs.z.ai/scenario-example/develop-tools/roo)

---

[Skip to main content](https://docs.z.ai/scenario-example/develop-tools/roo#content-area)
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
Roo Code
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
  * [Step 1: Installing the Roo Code Plugin](https://docs.z.ai/scenario-example/develop-tools/roo#step-1%3A-installing-the-roo-code-plugin)
  * [1. Open the Extensions Marketplace](https://docs.z.ai/scenario-example/develop-tools/roo#1-open-the-extensions-marketplace)
  * [2. Install the Plugin](https://docs.z.ai/scenario-example/develop-tools/roo#2-install-the-plugin)
  * [Step 2: Configuring API Settings](https://docs.z.ai/scenario-example/develop-tools/roo#step-2%3A-configuring-api-settings)
  * [Configuration Details](https://docs.z.ai/scenario-example/develop-tools/roo#configuration-details)
  * [Step 3: Permission Setup and Usage](https://docs.z.ai/scenario-example/develop-tools/roo#step-3%3A-permission-setup-and-usage)
  * [1. Configure Permissions](https://docs.z.ai/scenario-example/develop-tools/roo#1-configure-permissions)
  * [2. Start Using](https://docs.z.ai/scenario-example/develop-tools/roo#2-start-using)
  * [Step 4: Vision and Search MCP](https://docs.z.ai/scenario-example/develop-tools/roo#step-4%3A-vision-and-search-mcp)
  * [Demo](https://docs.z.ai/scenario-example/develop-tools/roo#demo)


Develop Tools
# Roo Code
Copy page
A complete guide to integrating the Roo Code plugin with the Z.AI GLM model in VS Code
Copy page
Roo Code is an intelligent VS Code plugin that assists with project analysis, code generation, refactoring, and other tasks.
##
[​](https://docs.z.ai/scenario-example/develop-tools/roo#step-1%3A-installing-the-roo-code-plugin)
Step 1: Installing the Roo Code Plugin
###
[​](https://docs.z.ai/scenario-example/develop-tools/roo#1-open-the-extensions-marketplace)
1. Open the Extensions Marketplace
a. Launch VS Code b. Click the Extensions Marketplace icon on the left sidebar c. Enter `Roo Code` in the search bar d. Locate the `Roo Code` plugin ![Description](https://cdn.bigmodel.cn/markdown/1753687765281r1.png?attname=r1.png)
###
[​](https://docs.z.ai/scenario-example/develop-tools/roo#2-install-the-plugin)
2. Install the Plugin
a. Click the `Install` button to begin installation b. After installation, select “Trust the Author” ![Description](https://cdn.bigmodel.cn/markdown/1753687776740r2.png?attname=r2.png)
##
[​](https://docs.z.ai/scenario-example/develop-tools/roo#step-2%3A-configuring-api-settings)
Step 2: Configuring API Settings
###
[​](https://docs.z.ai/scenario-example/develop-tools/roo#configuration-details)
Configuration Details
Fill in the following information as specified:
> If your Roo Code version is lower and does not have the `China Coding Plan` option, please update the plugin to the latest version first.
  * **API Provider** : Select `Z AI`
  * **Z AI Entrypoint** ：Select `International Coding Plan (https://api.z.ai/api/coding/paas/v4/)`
  * **Z AI API Key** : Input your Z.AI API Key
  * **Model** : Select `glm-4.6` or other model in the list

![Description](https://cdn.bigmodel.cn/markdown/1760942980972image.png?attname=image.png)
##
[​](https://docs.z.ai/scenario-example/develop-tools/roo#step-3%3A-permission-setup-and-usage)
Step 3: Permission Setup and Usage
###
[​](https://docs.z.ai/scenario-example/develop-tools/roo#1-configure-permissions)
1. Configure Permissions
Select the permissions you wish to enable based on your needs:
  * File read/write operations
  * Auto-approve execution
  * Project access permissions

![Description](https://cdn.bigmodel.cn/markdown/1753687800340r4.png?attname=r4.png)
###
[​](https://docs.z.ai/scenario-example/develop-tools/roo#2-start-using)
2. Start Using
Enter your requirements in the input box, and Roo Code will assist with:
  * Summarizing the current project structure
  * Analyzing key modules and functionalities
  * Code refactoring and optimization
  * Generating documentation and comments
  * Issue diagnosis and repair suggestions


##
[​](https://docs.z.ai/scenario-example/develop-tools/roo#step-4%3A-vision-and-search-mcp)
Step 4: Vision and Search MCP
Refer to the [Vision MCP Server](https://docs.z.ai/devpack/mcp/vision-mcp-server) and [Search MCP Server](https://docs.z.ai/devpack/mcp/search-mcp-server) documentation; once configured, you can use them in Roo Code.
###
[​](https://docs.z.ai/scenario-example/develop-tools/roo#demo)
Demo
Was this page helpful?
YesNo
[Kilo Code](https://docs.z.ai/scenario-example/develop-tools/kilo)[Gemini CLI](https://docs.z.ai/scenario-example/develop-tools/gemini)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
![Description](https://cdn.bigmodel.cn/markdown/1753687765281r1.png?attname=r1.png)
![Description](https://cdn.bigmodel.cn/markdown/1753687776740r2.png?attname=r2.png)
![Description](https://cdn.bigmodel.cn/markdown/1760942980972image.png?attname=image.png)
![Description](https://cdn.bigmodel.cn/markdown/1753687800340r4.png?attname=r4.png)
