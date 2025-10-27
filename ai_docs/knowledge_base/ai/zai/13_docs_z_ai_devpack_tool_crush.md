# https://docs.z.ai/devpack/tool/crush

Source: [https://docs.z.ai/devpack/tool/crush](https://docs.z.ai/devpack/tool/crush)

---

[Skip to main content](https://docs.z.ai/devpack/tool/crush#content-area)
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
Crush
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
  * [Step 1: Installing Crush](https://docs.z.ai/devpack/tool/crush#step-1%3A-installing-crush)
  * [Step 2: Configuring the GLM Model](https://docs.z.ai/devpack/tool/crush#step-2%3A-configuring-the-glm-model)
  * [1. Obtain Your Z.AI API Key](https://docs.z.ai/devpack/tool/crush#1-obtain-your-z-ai-api-key)
  * [2. Launch Crush and Select Model](https://docs.z.ai/devpack/tool/crush#2-launch-crush-and-select-model)
  * [3. Enter your Z.AI API key](https://docs.z.ai/devpack/tool/crush#3-enter-your-z-ai-api-key)
  * [Step 3: Modify Crush Configuration](https://docs.z.ai/devpack/tool/crush#step-3%3A-modify-crush-configuration)
  * [1. Locate the Configuration File](https://docs.z.ai/devpack/tool/crush#1-locate-the-configuration-file)
  * [2. Switch to the GLM Coding Plan Endpoint](https://docs.z.ai/devpack/tool/crush#2-switch-to-the-glm-coding-plan-endpoint)
  * [Step 4: Complete Configuration and Pick model](https://docs.z.ai/devpack/tool/crush#step-4%3A-complete-configuration-and-pick-model)
  * [Step 5: Vision and Search MCP](https://docs.z.ai/devpack/tool/crush#step-5%3A-vision-and-search-mcp)


Tool Guide
# Crush
Copy page
Methods for Using the GLM Coding Plan in Crush
Copy page
Crush is a powerful AI coding agent for the terminal (CLI + TUI). It supports multiple models to handle code generation, debugging, file operations, and more — all inside your command line. Crush is supercharged with the [GLM Coding Plan](https://z.ai/subscribe?utm_source=zai&utm_medium=link&utm_term=devpack-integration&utm_campaign=Platform_Ops&_channel_track_key=w3mNdY8g), making your terminal workflow smarter and more efficient.
Using the GLM Coding Plan, you need config the exclusive Coding API <https://api.z.ai/api/coding/paas/v4> instead of the Common API <https://api.z.ai/api/paas/v4>
##
[​](https://docs.z.ai/devpack/tool/crush#step-1%3A-installing-crush)
Step 1: Installing Crush
Select the appropriate installation method based on your system:
  * Homebrew (Recommended for macOS)
  * NPM (Cross-Platform)
  * Arch Linux
  * Nix


Copy
```
brew install charmbracelet/tap/crush

```

##
[​](https://docs.z.ai/devpack/tool/crush#step-2%3A-configuring-the-glm-model)
Step 2: Configuring the GLM Model
###
[​](https://docs.z.ai/devpack/tool/crush#1-obtain-your-z-ai-api-key)
1. Obtain Your Z.AI API Key
Visit Z.AI to get your [API Key](https://z.ai/manage-apikey/apikey-list).
###
[​](https://docs.z.ai/devpack/tool/crush#2-launch-crush-and-select-model)
2. Launch Crush and Select Model
Run the crush command to start the application:
Copy
```
crush

```

In the model selection interface, choose one of the following models:
  * glm-4.6 : Highest performance, strong coding version
  * glm-4.5 : Standard version, suitable for complex tasks
  * glm-4.5-air : Lightweight version, faster response


###
[​](https://docs.z.ai/devpack/tool/crush#3-enter-your-z-ai-api-key)
3. Enter your Z.AI API key
Enter the API Key obtained from Z.AI at the prompt. ![Description](https://cdn.bigmodel.cn/markdown/1759228565353crush.png?attname=crush.png)
##
[​](https://docs.z.ai/devpack/tool/crush#step-3%3A-modify-crush-configuration)
Step 3: Modify Crush Configuration
###
[​](https://docs.z.ai/devpack/tool/crush#1-locate-the-configuration-file)
1. Locate the Configuration File
Depending on your OS, the configuration file can be found at:
MacOS/Linux
Windows
Copy
```
~/.config/crush/providers.json

```

###
[​](https://docs.z.ai/devpack/tool/crush#2-switch-to-the-glm-coding-plan-endpoint)
2. Switch to the GLM Coding Plan Endpoint
Open `providers.json` and update the GLM section. Replace the default endpoint:
Copy
```
"https://api.z.ai/api/paas/v4"

```

with the **GLM Coding Plan** endpoint:
Copy
```
"https://api.z.ai/api/coding/paas/v4"

```

This ensures full compatibility with the GLM-4.6 subscription plan.
##
[​](https://docs.z.ai/devpack/tool/crush#step-4%3A-complete-configuration-and-pick-model)
Step 4: Complete Configuration and Pick model
Press `ctrl+p`, choose “Switch Model” After configuration, you can now:
  * Generate and optimize code using GLM-4.6
  * Conduct technical Q&A and debugging
  * Execute complex programming tasks
  * Experience the powerful capabilities of Z.AI


##
[​](https://docs.z.ai/devpack/tool/crush#step-5%3A-vision-and-search-mcp)
Step 5: Vision and Search MCP
Refer to the [Vision MCP Server](https://docs.z.ai/devpack/mcp/vision-mcp-server) and [Search MCP Server](https://docs.z.ai/devpack/mcp/search-mcp-server) documentation; once configured, you can use them in Crush.
Was this page helpful?
YesNo
[Roo Code](https://docs.z.ai/devpack/tool/roo)[Goose](https://docs.z.ai/devpack/tool/goose)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
![Description](https://cdn.bigmodel.cn/markdown/1759228565353crush.png?attname=crush.png)
