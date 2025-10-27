# https://docs.z.ai/devpack/tool/others

Source: [https://docs.z.ai/devpack/tool/others](https://docs.z.ai/devpack/tool/others)

---

[Skip to main content](https://docs.z.ai/devpack/tool/others#content-area)
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
Other Tools
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
  * [Step 1: Supported Tools](https://docs.z.ai/devpack/tool/others#step-1%3A-supported-tools)
  * [Step 2: Install and Config](https://docs.z.ai/devpack/tool/others#step-2%3A-install-and-config)
  * [1. Install Cursor](https://docs.z.ai/devpack/tool/others#1-install-cursor)
  * [2. Create a New Provider/Model](https://docs.z.ai/devpack/tool/others#2-create-a-new-provider%2Fmodel)
  * [3. Save and Switch Models](https://docs.z.ai/devpack/tool/others#3-save-and-switch-models)
  * [4. Get Started](https://docs.z.ai/devpack/tool/others#4-get-started)
  * [Step 3: Replacing the API URL](https://docs.z.ai/devpack/tool/others#step-3%3A-replacing-the-api-url)
  * [Summary](https://docs.z.ai/devpack/tool/others#summary)


Tool Guide
# Other Tools
Copy page
Methods for using the GLM Coding Plan in other tools
Copy page
You can easily integrate the **GLM-4.6** model into any tool that supports the **OpenAI API protocol**. Simply replace **the default API endpoint** with the one provided by [GLM Coding Plan](https://z.ai/subscribe?utm_source=zai&utm_medium=link&utm_term=devpack-integration&utm_campaign=Platform_Ops&_channel_track_key=w3mNdY8g), and unlock the full power of Z.AI.
Using the GLM Coding Plan, you need config the exclusive Coding API <https://api.z.ai/api/coding/paas/v4> instead of the Common API <https://api.z.ai/api/paas/v4>
##
[​](https://docs.z.ai/devpack/tool/others#step-1%3A-supported-tools)
Step 1: Supported Tools
Any tool supporting the **OpenAI Protocol** can run on **GLM-4.6**.Simply replace the default OpenAI API URL and set your API key. Below are some common and popular tools supporting the **OpenAI Protocol** that can integrate `GLM-4.6` using the same approach:
  * **Cursor**
  * **Gemini CLI**
  * **Cherry studio**
  * …


##
[​](https://docs.z.ai/devpack/tool/others#step-2%3A-install-and-config)
Step 2: Install and Config
> Core Steps:
>   1. Select an OpenAI-compatible provider.
>   2. **Add/Replace the OpenAI Base URL with`https://api.z.ai/api/coding/paas/v4`.**
>   3. **Enter your Z.AI API Key and select`GLM-4.6` , `GLM-4.5` or `GLM-4.5-air`.**
>

Using **Cursor** as an example (Note: Custom configuration is only supported in Cursor Pro and higher versions), the following steps demonstrate how to integrate the `GLM-4.6` model via the OpenAI protocol. Similarly, other tools supporting the OpenAI protocol can adopt the same configuration approach.
###
[​](https://docs.z.ai/devpack/tool/others#1-install-cursor)
1. Install Cursor
Download and install Cursor from the official website.
###
[​](https://docs.z.ai/devpack/tool/others#2-create-a-new-provider%2Fmodel)
2. Create a New Provider/Model
In Cursor, navigate to the “**Models** ” section and click the “**Add Custom Model** ”. ![Description](https://cdn.bigmodel.cn/markdown/176032216013820251013-100735.jpeg?attname=20251013-100735.jpeg)
  * Select the **OpenAI Protocol**.
  * Configure the **OpenAI API Key** (obtained from the Z.AI).
  * In **Override OpenAI Base URL** , replace the default URL with `https://api.z.ai/api/coding/paas/v4`.
  * Enter the model you wish to use, such as `GLM-4.6`, `GLM-4.5` or `GLM-4.5-air`.
  * Note: In Cursor, the model name must be entered in uppercase, such as `GLM-4.6`.

![Description](https://cdn.bigmodel.cn/markdown/176032218295020251013-100740.jpeg?attname=20251013-100740.jpeg)
###
[​](https://docs.z.ai/devpack/tool/others#3-save-and-switch-models)
3. Save and Switch Models
After configuration, save your settings and select the newly created **GLM-4.6 Provider** on the homepage.
###
[​](https://docs.z.ai/devpack/tool/others#4-get-started)
4. Get Started
With this setup, you can begin using the **GLM-4.6** model for code generation, debugging, task analysis, and more. ![Description](https://cdn.bigmodel.cn/markdown/176032221518820251013-100745.jpeg?attname=20251013-100745.jpeg)
##
[​](https://docs.z.ai/devpack/tool/others#step-3%3A-replacing-the-api-url)
Step 3: Replacing the API URL
  1. **Locate the API configuration section in your tool** :

For example, in **Goose** , this is typically where you set the API address in the configuration file; In **VS Code** plugins or **IntelliJ IDEA** plugins, configuration is usually done through the plugin’s settings interface.
  1. **Replace the OpenAI Base URL** :

Replace the default OpenAI API URL with `https://api.z.ai/api/coding/paas/v4`.
  1. **Enter API Key and Select Model** :


  * Enter your **Z.ai API Key**.
  * Select `GLM-4.6`(standard, complex tasks) or `GLM-4.5-air`(lightweight, faster response) based on your requirements.


##
[​](https://docs.z.ai/devpack/tool/others#summary)
Summary
By following these steps, you can integrate the **GLM-4.6** model into any tool supporting the **OpenAI protocol**. Simply replace the API endpoint and enter the corresponding API key to leverage the **GLM-4.6** model for powerful code generation, debugging, and analysis tasks within these tools. Integration with **GLM-4.6** is straightforward for any tool supporting the OpenAI protocol.
Was this page helpful?
YesNo
[Factory Droid](https://docs.z.ai/devpack/tool/droid)[Invite Friends, Get Credits](https://docs.z.ai/devpack/credit-campaign-rules)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
