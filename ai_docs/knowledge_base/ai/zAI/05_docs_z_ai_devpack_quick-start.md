# https://docs.z.ai/devpack/quick-start

Source: [https://docs.z.ai/devpack/quick-start](https://docs.z.ai/devpack/quick-start)

---

[Skip to main content](https://docs.z.ai/devpack/quick-start#content-area)
🚀 **GLM Coding Plan — built for devs: 3× usage, 1/7 cost** • [Limited-Time Offer ➞](https://z.ai/subscribe?utm_campaign=Platform_Ops&_channel_track_key=DaprgHIc)
[Z.AI DEVELOPER DOCUMENT home page![light logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/dark.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=75deefa9dea5bdbc84d4da68885c267f)![dark logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/light.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=c1ecf1af358fa8eeab8c06052337f8f6)](https://z.ai/model-api)
English
Search...
⌘K
  * [API Keys](https://z.ai/manage-apikey/apikey-list)
  * [Payment Method](https://z.ai/manage-apikey/billing)


Search...
Navigation
GLM Coding Plan
Quick Start
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
  * [Getting Started](https://docs.z.ai/devpack/quick-start#getting-started)
  * [Feature Examples](https://docs.z.ai/devpack/quick-start#feature-examples)
  * [Advanced Features](https://docs.z.ai/devpack/quick-start#advanced-features)


GLM Coding Plan
# Quick Start
Copy page
Copy page
This guide will help you get started with [GLM Coding Plan](https://z.ai/subscribe?utm_source=zai&utm_medium=link&utm_term=quickstart&utm_campaign=Platform_Ops&_channel_track_key=DRUfXN42) in minutes—from subscribing to using the GLM-4.6 model in coding tools.
## 
[​](https://docs.z.ai/devpack/quick-start#getting-started)
Getting Started
1
Register or Login
  * Access [Z.AI Open Platform](https://z.ai/model-api), Register or Login. ![description](https://mintcdn.com/zhipu-32152247/tXQnmemMntMF1TeM/resource/quickstart-1.png?fit=max&auto=format&n=tXQnmemMntMF1TeM&q=85&s=a888ed8ef0db74f61a2c3ade2c9d5901)


2
Subscribe to GLM Coding Plan
After logging in, navigate to the [GLM Coding Plan](https://z.ai/subscribe?utm_source=zai&utm_medium=link&utm_term=quickstart&utm_campaign=Platform_Ops&_channel_track_key=DRUfXN42) to select your preferred subscription plan.![description](https://mintcdn.com/zhipu-32152247/tXQnmemMntMF1TeM/resource/quickstart-2.png?fit=max&auto=format&n=tXQnmemMntMF1TeM&q=85&s=d80f9382635a3910c6f6949a485a0fc2)
3
Obtain API Key
After subscribing, navigate to your account dashboard and click [API Keys](https://z.ai/manage-apikey/apikey-list) to generate a new API Key.![description](https://mintcdn.com/zhipu-32152247/tXQnmemMntMF1TeM/resource/quickstart-3.png?fit=max&auto=format&n=tXQnmemMntMF1TeM&q=85&s=65e4a2f900d7ace56ea241a2d0e12ab7)
Safeguard your API Key by keeping it confidential and avoiding hard-coding it in your code. We recommend storing it in environment variables or configuration files.
4
Select Coding Tool
GLM Coding Plan supports multiple mainstream coding tools. Choose based on your preference:
## [Claude Code](https://docs.z.ai/devpack/tool/claude)## [Roo Code](https://docs.z.ai/devpack/tool/roo)## [Kilo Code](https://docs.z.ai/devpack/tool/kilo)## [Cline](https://docs.z.ai/devpack/tool/cline)## [OpenCode](https://docs.z.ai/devpack/tool/opencode)## [Crush](https://docs.z.ai/devpack/tool/crush)## [Goose](https://docs.z.ai/devpack/tool/goose)## [Other Tools](https://docs.z.ai/devpack/tool/others)
5
Configuring Coding Tools
Using Claude Code as an example, configure the GLM-4.6 model:
  * Claude Code
  * Other Tools


**1. Install Claude Code** Prerequisite: You need to install [Node.js 18 or latest version](https://nodejs.org/en/download/)
Copy
```
# Open your terminal and install Claude Code
npm install -g @anthropic-ai/claude-code
# Create your working directory (e.g., `your-project`) and navigate to it using `cd`
cd your-project
# After installation, run `claude` to enter the Claude Code interactive interface
claude

```

**2. Configure Environment Variables** After installing Claude Code, set up environment variables using one of the following two methods by enter the following commands in the **Mac OS terminal** or **Windows cmd** :
**Note** : When setting environment variables, the terminal will not return any output. This is normal, as long as no error message appears, the configuration has been applied successfully.
**Method 1: Using a Script (Recommended for First-Time Users)**
Copy
```
curl -O "http://bigmodel-us3-prod-marketplace.cn-wlcb.ufileos.com/1753683755292-30b3431f487b4cc1863e57a81d78e289.sh?ufileattname=claude_code_prod_zai.sh"

```

**Method 2: Manual Configuration**
Mac OS
Windows
Copy
```
export ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic
export ANTHROPIC_AUTH_TOKEN=YOUR_API_KEY

```

6
Start Coding
Once configured, you can begin coding with GLM-4.6!
  * Natural Language Programming
  * Code Debugging
  * Code Optimization


Copy
```
# Using Natural Language Commands in Claude Code
Please create a React component containing a user login form

```

GLM-4.6 will automatically:
  * Analyze requirements and formulate an implementation plan
  * Generate complete React component code
  * Include form validation and styling
  * Ensure code runs directly


## 
[​](https://docs.z.ai/devpack/quick-start#feature-examples)
Feature Examples
## Smart Code Completion
Generates real-time completion suggestions based on context, reducing manual input and significantly boosting development efficiency.
Copy
```
// Type function name, GLM-4.6 auto-completes implementation
function calculateTotal(items) {
  // GLM-4.6 automatically generates complete function implementation
}

```

## Code Repository Q&A
Ask questions about your team’s codebase anytime to maintain a holistic understanding.
Copy
```
Q: How is user authentication implemented in this project?
A: GLM-4.6 analyzes your codebase and provides detailed explanations of the authentication process and related files.

```

## Automated Task Management
One-click fixes for lint issues, merge conflicts, and release note generation.
Copy
```
# Auto-fix code style issues
Fix all ESLint errors
# Auto-generate documentation
Generate detailed documentation for this API

```

## 
[​](https://docs.z.ai/devpack/quick-start#advanced-features)
Advanced Features
Vision MCP Server (Pro Plan Exclusive)
Pro and higher tier users can utilize the Vision MCP Server, which employs the flagship visual reasoning model GLM-4.5V to comprehend and analyze image content.
  * Analyze UI design mockups and generate corresponding code
  * Understand flowcharts and architecture diagrams
  * Extract text and information from screenshots

For detailed usage instructions, refer to the [Vision MCP Server](https://docs.z.ai/devpack/mcp/vision-mcp-server) documentation.
Web Search MCP Server (Pro Plan Exclusive)
Pro and higher tier users can utilize the Web Search MCP Server to access the latest technical information.
  * Search for the latest technical documentation and API changes
  * Obtain the latest information on open-source projects
  * Find solutions and best practices

For detailed usage instructions, refer to the [Web Search MCP Server](https://docs.z.ai/devpack/mcp/search-mcp-server) documentation.
Was this page helpful?
YesNo
[Overview](https://docs.z.ai/devpack/overview)[FAQs](https://docs.z.ai/devpack/faq)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
![description](https://mintcdn.com/zhipu-32152247/tXQnmemMntMF1TeM/resource/quickstart-1.png?w=560&fit=max&auto=format&n=tXQnmemMntMF1TeM&q=85&s=ad32625cd94dd558c563b2d8d6cdf507)
![description](https://mintcdn.com/zhipu-32152247/tXQnmemMntMF1TeM/resource/quickstart-2.png?w=560&fit=max&auto=format&n=tXQnmemMntMF1TeM&q=85&s=e6bc7f999c0f03277c68e60a088e39d1)
![description](https://mintcdn.com/zhipu-32152247/tXQnmemMntMF1TeM/resource/quickstart-3.png?w=560&fit=max&auto=format&n=tXQnmemMntMF1TeM&q=85&s=3ebdcae387e230eb8cf0f965fb008a7b)
