# https://docs.z.ai/devpack/mcp/search-mcp-server

Source: [https://docs.z.ai/devpack/mcp/search-mcp-server](https://docs.z.ai/devpack/mcp/search-mcp-server)

---

[Skip to main content](https://docs.z.ai/devpack/mcp/search-mcp-server#content-area)
🚀 **GLM Coding Plan — built for devs: 3× usage, 1/7 cost** • [Limited-Time Offer ➞](https://z.ai/subscribe?utm_campaign=Platform_Ops&_channel_track_key=DaprgHIc)
[Z.AI DEVELOPER DOCUMENT home page![light logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/dark.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=75deefa9dea5bdbc84d4da68885c267f)![dark logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/light.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=c1ecf1af358fa8eeab8c06052337f8f6)](https://z.ai/model-api)
English
Search...
⌘K
  * [API Keys](https://z.ai/manage-apikey/apikey-list)
  * [Payment Method](https://z.ai/manage-apikey/billing)


Search...
Navigation
MCP Guide
Web Search MCP Server
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
  * [Product Overview](https://docs.z.ai/devpack/mcp/search-mcp-server#product-overview)
  * [Features](https://docs.z.ai/devpack/mcp/search-mcp-server#features)
  * [Supported Tools](https://docs.z.ai/devpack/mcp/search-mcp-server#supported-tools)
  * [Authentication Configuration](https://docs.z.ai/devpack/mcp/search-mcp-server#authentication-configuration)
  * [Getting API Key](https://docs.z.ai/devpack/mcp/search-mcp-server#getting-api-key)
  * [Installation and Usage](https://docs.z.ai/devpack/mcp/search-mcp-server#installation-and-usage)
  * [Quick Start](https://docs.z.ai/devpack/mcp/search-mcp-server#quick-start)
  * [Supported Clients](https://docs.z.ai/devpack/mcp/search-mcp-server#supported-clients)
  * [Usage Example](https://docs.z.ai/devpack/mcp/search-mcp-server#usage-example)
  * [Troubleshooting](https://docs.z.ai/devpack/mcp/search-mcp-server#troubleshooting)
  * [Related Resources](https://docs.z.ai/devpack/mcp/search-mcp-server#related-resources)


MCP Guide
# Web Search MCP Server
Copy page
Copy page
Web Search MCP Server is a Z.AI search capability implementation based on the Model Context Protocol (MCP), providing powerful Z.AI search capabilities for MCP-compatible clients such as Claude Code and Cline, including web search, real-time information retrieval, and other features.
##
[​](https://docs.z.ai/devpack/mcp/search-mcp-server#product-overview)
Product Overview
This Remote MCP Server with search capabilities is an exclusive server developed by Z.AI for **GLM Coding Plan Pro or higher tiers users** , empowering your Code Agent with search capabilities and unlimited access to real-time information and web resources.
##
[​](https://docs.z.ai/devpack/mcp/search-mcp-server#features)
Features
## Web Search
Supports comprehensive web search to retrieve the latest web information and resources
## Real-time Information
Retrieves real-time updated information including news, stock prices, weather, and more
## Remote Service
HTTP protocol-based remote MCP service, no local installation required
##
[​](https://docs.z.ai/devpack/mcp/search-mcp-server#supported-tools)
Supported Tools
This server implements the Model Context Protocol and can be used with any MCP-compatible client. Currently provides the following tools:
  * **`webSearchPrime`**- Search web information, returning results including page titles, URLs, summaries, site names, site icons, and more.


##
[​](https://docs.z.ai/devpack/mcp/search-mcp-server#authentication-configuration)
Authentication Configuration
###
[​](https://docs.z.ai/devpack/mcp/search-mcp-server#getting-api-key)
Getting API Key
Using Search MCP Server requires a valid api key. Please visit the corresponding platform to obtain:
  * Z.AI Platform (Z.AI)


Platform URL: <https://z.ai/model-api> Get Token: [Z.AI Console](https://z.ai/manage-apikey/apikey-list)
##
[​](https://docs.z.ai/devpack/mcp/search-mcp-server#installation-and-usage)
Installation and Usage
###
[​](https://docs.z.ai/devpack/mcp/search-mcp-server#quick-start)
Quick Start
1
Get API Key
Visit [Z.AI Console](https://z.ai/manage-apikey/apikey-list) to get your api key
2
Configure MCP Client
Choose the appropriate configuration method based on your client
3
Start Using
After configuration is complete, you can use search functionality in the client
###
[​](https://docs.z.ai/devpack/mcp/search-mcp-server#supported-clients)
Supported Clients
  * Claude Code
  * Cline (VS Code)
  * OpenCode
  * Crush
  * Goose
  * Roo Code, Kilo Code and Other MCP Clients


**One-click Installation Command** Be sure to replace `your_api_key` with the API Key you obtained.
Copy
```
claude mcp add -s user -t http web-search-prime https://api.z.ai/api/mcp/web_search_prime/mcp --header "Authorization: Bearer your_api_key"

```

**Manual Configuration** Edit Claude Code’s configuration file `.claude.json` in the user directory, MCP section:
Copy
```
{
 "mcpServers": {
  "web-search-prime": {
   "type": "http",
   "url": "https://api.z.ai/api/mcp/web_search_prime/mcp",
   "headers": {
    "Authorization": "Bearer your_api_key"
   }
  }
 }
}

```

##
[​](https://docs.z.ai/devpack/mcp/search-mcp-server#usage-example)
Usage Example
Through the previous step of installing the Search MCP server to the client, you can directly use MCP in your Coding client. You can directly use search functionality in conversations:
  * “Help me search for the latest AI technology developments”
  * “Find best practices for Python asynchronous programming”


##
[​](https://docs.z.ai/devpack/mcp/search-mcp-server#troubleshooting)
Troubleshooting
Invalid API Key
**Issue:** Receiving invalid api key error**Solutions:**
  1. Confirm the api key is correctly copied
  2. Check if the api key is activated
  3. Confirm the api key has sufficient balance
  4. Check if the Authorization header format is correct


Connection Timeout
**Issue:** MCP server connection timeout**Solutions:**
  1. Check network connection
  2. Confirm firewall settings
  3. Verify the server URL is correct
  4. Increase timeout settings


Empty Search Results
**Issue:** Search returns empty results**Solutions:**
  1. Try using different search keywords
  2. Check if the search query is too specific
  3. Confirm network connection is normal
  4. Contact technical support for assistance


##
[​](https://docs.z.ai/devpack/mcp/search-mcp-server#related-resources)
Related Resources
  * [Model Context Protocol (MCP) Official Documentation](https://modelcontextprotocol.io/)
  * [Claude Code MCP Configuration Guide](https://docs.anthropic.com/en/docs/claude-code/mcp)
  * [Z.AI API Reference](https://docs.z.ai/api-reference/introduction)
  * [GLM Coding Plan Overview](https://docs.z.ai/devpack/overview)


Was this page helpful?
YesNo
[Vision MCP Server](https://docs.z.ai/devpack/mcp/vision-mcp-server)[Claude Code](https://docs.z.ai/devpack/tool/claude)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
