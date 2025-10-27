# https://docs.z.ai/devpack/tool/opencode

Source: [https://docs.z.ai/devpack/tool/opencode](https://docs.z.ai/devpack/tool/opencode)

---

[Skip to main content](https://docs.z.ai/devpack/tool/opencode#content-area)
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
Open Code
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
  * [Step 1: Installing OpenCode](https://docs.z.ai/devpack/tool/opencode#step-1%3A-installing-opencode)
  * [Step 2: Getting Started](https://docs.z.ai/devpack/tool/opencode#step-2%3A-getting-started)
  * [Share](https://docs.z.ai/devpack/tool/opencode#share)
  * [How it works](https://docs.z.ai/devpack/tool/opencode#how-it-works)
  * [Share](https://docs.z.ai/devpack/tool/opencode#share-2)
  * [Un-share](https://docs.z.ai/devpack/tool/opencode#un-share)
  * [IDE Extensions](https://docs.z.ai/devpack/tool/opencode#ide-extensions)
  * [Installation](https://docs.z.ai/devpack/tool/opencode#installation)
  * [Usage](https://docs.z.ai/devpack/tool/opencode#usage)
  * [GitHub Workflow](https://docs.z.ai/devpack/tool/opencode#github-workflow)
  * [Features](https://docs.z.ai/devpack/tool/opencode#features)
  * [Installation](https://docs.z.ai/devpack/tool/opencode#installation-2)
  * [Examples](https://docs.z.ai/devpack/tool/opencode#examples)
  * [Resources](https://docs.z.ai/devpack/tool/opencode#resources)


Tool Guide
# Open Code
Copy page
Copy page
> Complete guide to integrating Z.AI GLM models with OpenCode CLI
OpenCode is a powerful AI coding agent that can be configured to use Z.AI’s GLM models. ![Description](https://mintcdn.com/zhipu-32152247/fQm1SxNtD2jBDQ3i/resource/opencode.png?fit=max&auto=format&n=fQm1SxNtD2jBDQ3i&q=85&s=305c63488f76257bb7a8ad31d6540ea7)
##
[​](https://docs.z.ai/devpack/tool/opencode#step-1%3A-installing-opencode)
Step 1: Installing OpenCode
The easiest way to install OpenCode is through the install script.
Copy
```
curl -fsSL https://opencode.ai/install | bash

```

You can also install it with npm:
Copy
```
npm install -g opencode-ai

```

##
[​](https://docs.z.ai/devpack/tool/opencode#step-2%3A-getting-started)
Step 2: Getting Started
  1. Head over to the [Z.AI API Console](https://z.ai/manage-apikey/apikey-list) to get your API key.
  2. Run `opencode auth login` and select **Z.AI**.


Copy
```
$ opencode auth login
┌ Add credential
│
◆ Select provider
│ ● Z.AI
│ ...
└

```

If you are subscribed to the **GLM Coding Plan** , select **Z.AI Coding Plan**.
Copy
```
$ opencode auth login
┌ Add credential
│
◆ Select provider
│ ● Z.AI Coding Plan
│ ...
└

```

  1. Enter your Z.AI API key.


Copy
```
$ opencode auth login
┌ Add credential
│
◇ Select provider
│ Z.AI Coding Plan
│
◇ Enter your API key
│ _
└

```

  1. Run `opencode` to launch OpenCode.


Copy
```
$ opencode

```

Use the `/models` command to select a model like _GLM-4.6_.
Copy
```
/models

```

  1. Vision and Search MCP

Refer to the [Vision MCP Server](https://docs.z.ai/devpack/mcp/vision-mcp-server) and [Search MCP Server](https://docs.z.ai/devpack/mcp/search-mcp-server) documentation; once configured, you can use them in OpenCode.
##
[​](https://docs.z.ai/devpack/tool/opencode#share)
Share
OpenCode’s share feature allows you to create public links to your OpenCode conversations, so you can collaborate with teammates or get help from others.
####
[​](https://docs.z.ai/devpack/tool/opencode#how-it-works)
How it works
When you share a conversation, OpenCode:
  1. Creates a unique public URL for your session
  2. Syncs your conversation history to our servers
  3. Makes the conversation accessible via the shareable link — `opencode.ai/s/<share-id>`


####
[​](https://docs.z.ai/devpack/tool/opencode#share-2)
Share
By default, conversations are not shared automatically. You can manually share them using the `/share` command:
Copy
```
/share

```

####
[​](https://docs.z.ai/devpack/tool/opencode#un-share)
Un-share
To stop sharing a conversation and remove it from public access:
Copy
```
/unshare

```

This will remove the share link and delete the data related to the conversation. Learn more about [sharing conversations](https://opencode.ai/docs/share/).
##
[​](https://docs.z.ai/devpack/tool/opencode#ide-extensions)
IDE Extensions
OpenCode integrates with VS Code, Cursor, or any IDE that supports a terminal.
####
[​](https://docs.z.ai/devpack/tool/opencode#installation)
Installation
To install OpenCode on VS Code and popular forks like Cursor, Windsurf, VSCodium:
  1. Open VS Code
  2. Open the integrated terminal
  3. Run `opencode` - the extension installs automatically


####
[​](https://docs.z.ai/devpack/tool/opencode#usage)
Usage
  * **Quick Launch** : Use `Cmd+Esc` (Mac) or `Ctrl+Esc` (Windows/Linux) to open OpenCode in a split terminal view, or focus an existing terminal session if one is already running.
  * **New Session** : Use `Cmd+Shift+Esc` (Mac) or `Ctrl+Shift+Esc` (Windows/Linux) to start a new OpenCode terminal session, even if one is already open. You can also click the OpenCode button in the UI.
  * **Context Awareness** : Automatically share your current selection or tab with OpenCode.
  * **File Reference Shortcuts** : Use `Cmd+Option+K` (Mac) or `Alt+Ctrl+K` (Linux/Windows) to insert file references. For example, `@File#L37-42`.

Learn more about [IDE integrations](https://opencode.ai/docs/ide/).
##
[​](https://docs.z.ai/devpack/tool/opencode#github-workflow)
GitHub Workflow
OpenCode integrates with your GitHub workflow. Mention `/opencode` or `/oc` in your comment, and OpenCode will execute tasks within your GitHub Actions runner.
####
[​](https://docs.z.ai/devpack/tool/opencode#features)
Features
  * **Triage issues** : Ask OpenCode to look into an issue and explain it to you.
  * **Fix and implement** : Ask OpenCode to fix an issue or implement a feature. And it will work in a new branch and submits a PR with all the changes.
  * **Secure** : OpenCode runs inside your GitHub’s runners.


####
[​](https://docs.z.ai/devpack/tool/opencode#installation-2)
Installation
Run the following command in a project that is in a GitHub repo:
Copy
```
opencode github install

```

This will walk you through installing the GitHub app, creating the workflow, and setting up secrets.
####
[​](https://docs.z.ai/devpack/tool/opencode#examples)
Examples
Here are some examples of how you can use OpenCode in GitHub.
  * **Explain an issue**

Add this comment in a GitHub issue.
Copy
```
/opencode explain this issue

```

OpenCode will read the entire thread, including all comments, and reply with a clear explanation.
  * **Fix an issue**

In a GitHub issue, say:
Copy
```
/opencode fix this

```

And OpenCode will create a new branch, implement the changes, and open a PR with the changes.
  * **Review PRs and make changes**

Leave the following comment on a GitHub PR.
Copy
```
Delete the attachment from S3 when the note is removed /oc

```

OpenCode will implement the requested change and commit it to the same PR. Learn more about [GitHub workflow](https://opencode.ai/docs/github/).
##
[​](https://docs.z.ai/devpack/tool/opencode#resources)
Resources
  * **Documentation** : [opencode.ai/docs](https://opencode.ai/docs)
  * **GitHub Issues** : [github.com/sst/opencode/issues](https://github.com/sst/opencode/issues)
  * **Discord** : [opencode.ai/discord](https://opencode.ai/discord)


Was this page helpful?
YesNo
[Cline](https://docs.z.ai/devpack/tool/cline)[Kilo Code](https://docs.z.ai/devpack/tool/kilo)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
![Description](https://mintcdn.com/zhipu-32152247/fQm1SxNtD2jBDQ3i/resource/opencode.png?w=560&fit=max&auto=format&n=fQm1SxNtD2jBDQ3i&q=85&s=6f454cae9fa436b923b0055123a01c1d)
