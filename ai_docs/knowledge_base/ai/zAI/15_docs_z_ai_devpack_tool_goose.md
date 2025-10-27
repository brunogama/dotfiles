# https://docs.z.ai/devpack/tool/goose

Source: [https://docs.z.ai/devpack/tool/goose](https://docs.z.ai/devpack/tool/goose)

---

[Skip to main content](https://docs.z.ai/devpack/tool/goose#content-area)
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
Goose
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
  * [Step 1: Installing Goose Desktop](https://docs.z.ai/devpack/tool/goose#step-1%3A-installing-goose-desktop)
  * [Step 2: Creating a New Provider](https://docs.z.ai/devpack/tool/goose#step-2%3A-creating-a-new-provider)
  * [Step 3: Select Anthropic Compatible and Configure](https://docs.z.ai/devpack/tool/goose#step-3%3A-select-anthropic-compatible-and-configure)
  * [Step 4: Switching Models](https://docs.z.ai/devpack/tool/goose#step-4%3A-switching-models)
  * [Step 5: Start Using Goose with GLM](https://docs.z.ai/devpack/tool/goose#step-5%3A-start-using-goose-with-glm)
  * [Step 6: Vision and Search MCP](https://docs.z.ai/devpack/tool/goose#step-6%3A-vision-and-search-mcp)


Tool Guide
# Goose
Copy page
Methods for Using the GLM Coding Plan in Goose
Copy page
Goose is an AI agent tool that supports local or desktop environments and offers a CLI interface. It integrates with multiple models and connects to external tools and APIs via the MCP protocol to automate engineering tasks such as code generation, debugging, testing, and deployment. Goose is delivering a more stable and efficient functional experience with the [GLM Coding Plan](https://z.ai/subscribe?utm_source=zai&utm_medium=link&utm_term=devpack-integration&utm_campaign=Platform_Ops&_channel_track_key=w3mNdY8g).
## 
[​](https://docs.z.ai/devpack/tool/goose#step-1%3A-installing-goose-desktop)
Step 1: Installing Goose Desktop
  1. Visit the official Goose documentation: [Goose Quickstart](https://block.github.io/goose/docs/quickstart/).
  2. Choose the installer for your operating system and complete the setup for Goose Desktop.


## 
[​](https://docs.z.ai/devpack/tool/goose#step-2%3A-creating-a-new-provider)
Step 2: Creating a New Provider
  1. Open the Goose Desktop application and navigate to the main interface.
  2. Locate and click **“Create New Provider”** in the left-hand menu (as shown in the figure).
  3. Follow the prompts to enter the required information and complete the new Provider creation.

![Description](https://cdn.bigmodel.cn/markdown/1758091325715goose-1.jpeg?attname=goose-1.jpeg)
## 
[​](https://docs.z.ai/devpack/tool/goose#step-3%3A-select-anthropic-compatible-and-configure)
Step 3: Select Anthropic Compatible and Configure
  1. During Provider Setup, select the **Anthropic Compatible**.
  2. Complete the following required configurations:


  * **Base URL** : `https://api.z.ai/api/anthropic`
  * **API Key** : Your Z.ai API key
  * **Model** : Select `GLM-4.6`(standard, complex tasks) or `GLM-4.5-air`(lightweight, faster response) based on your requirements.


  1. Save your settings to complete the configuration.

![Description](https://cdn.bigmodel.cn/markdown/1759307955720image.png?attname=image.png)
## 
[​](https://docs.z.ai/devpack/tool/goose#step-4%3A-switching-models)
Step 4: Switching Models
  1. After configuration, return to the Goose desktop main interface.
  2. Locate and click “**Switch Models** ” at the bottom of the main interface.
  3. Select the newly created Provider from the dropdown list.
  4. Verify the new Provider has successfully switched to the current model.

![Description](https://cdn.bigmodel.cn/markdown/1758091346221goose-3.jpeg?attname=goose-3.jpeg)
## 
[​](https://docs.z.ai/devpack/tool/goose#step-5%3A-start-using-goose-with-glm)
Step 5: Start Using Goose with GLM
  1. Once the provider is active, you can start interacting with Goose powered by GLM-4.6.
  2. Enter your request, and Goose will automatically invoke the GLM-4.6 model based on your configuration to generate a response.

![Description](https://cdn.bigmodel.cn/markdown/1758091350444goose-4.jpeg?attname=goose-4.jpeg)
## 
[​](https://docs.z.ai/devpack/tool/goose#step-6%3A-vision-and-search-mcp)
Step 6: Vision and Search MCP
Refer to the [Vision MCP Server](https://docs.z.ai/devpack/mcp/vision-mcp-server) and [Search MCP Server](https://docs.z.ai/devpack/mcp/search-mcp-server) documentation; once configured, you can use them in Goose.
Was this page helpful?
YesNo
[Crush](https://docs.z.ai/devpack/tool/crush)[Factory Droid](https://docs.z.ai/devpack/tool/droid)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
