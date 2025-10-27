# https://docs.factory.ai/cli/getting-started/quickstart

[Skip to main content](https://docs.factory.ai/cli/getting-started/quickstart#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Getting Started
Quickstart
[Welcome](https://docs.factory.ai/welcome)[CLI](https://docs.factory.ai/cli/getting-started/overview)[Web Platform](https://docs.factory.ai/web/getting-started/overview)[Onboarding](https://docs.factory.ai/onboarding)[Pricing](https://docs.factory.ai/pricing)[Changelog](https://docs.factory.ai/changelog/1-8)
  * [GitHub](https://github.com/factory-ai/factory)
  * [Discord](https://discord.gg/EQ2DQM2F)


##### Getting Started
  * [Overview](https://docs.factory.ai/cli/getting-started/overview)
  * [Quickstart](https://docs.factory.ai/cli/getting-started/quickstart)
  * [Video Walkthrough](https://docs.factory.ai/cli/getting-started/video-walkthrough)
  * [How to Talk to a Droid](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid)
  * [Common Use Cases](https://docs.factory.ai/cli/getting-started/common-use-cases)


##### User Guides
  * [Become a Power User](https://docs.factory.ai/cli/user-guides/become-a-power-user)
  * [Specification Mode](https://docs.factory.ai/cli/user-guides/specification-mode)
  * [Auto-Run Mode](https://docs.factory.ai/cli/user-guides/auto-run)
  * [Choosing Your Model](https://docs.factory.ai/cli/user-guides/choosing-your-model)
  * [Implementing Large Features](https://docs.factory.ai/cli/user-guides/implementing-large-features)


##### Configuration
  * [CLI Reference](https://docs.factory.ai/cli/configuration/cli-reference)
  * [Custom Slash Commands](https://docs.factory.ai/cli/configuration/custom-slash-commands)
  * [IDE Integrations](https://docs.factory.ai/cli/configuration/ide-integrations)
  * [Custom Droids (Subagents)](https://docs.factory.ai/cli/configuration/custom-droids)
  * [AGENTS.md](https://docs.factory.ai/cli/configuration/agents-md)
  * [Settings](https://docs.factory.ai/cli/configuration/settings)
  * [Mixed Models](https://docs.factory.ai/cli/configuration/mixed-models)
  * [Model Context Protocol](https://docs.factory.ai/cli/configuration/mcp)
  * Bring Your Own Key


##### Droid Exec (Headless)
  * [Overview](https://docs.factory.ai/cli/droid-exec/overview)
  * Cookbook


##### Account
  * [Security](https://docs.factory.ai/cli/account/security)
  * [Droid Shield](https://docs.factory.ai/cli/account/droid-shield)


On this page
  * [Before you begin](https://docs.factory.ai/cli/getting-started/quickstart#before-you-begin)
  * [Step 1: Install and start droid](https://docs.factory.ai/cli/getting-started/quickstart#step-1%3A-install-and-start-droid)
  * [Step 2: Explore your codebase](https://docs.factory.ai/cli/getting-started/quickstart#step-2%3A-explore-your-codebase)
  * [Step 3: Make your first code change](https://docs.factory.ai/cli/getting-started/quickstart#step-3%3A-make-your-first-code-change)
  * [Step 4: Experience enterprise workflows](https://docs.factory.ai/cli/getting-started/quickstart#step-4%3A-experience-enterprise-workflows)
  * [Step 5: Handle version control](https://docs.factory.ai/cli/getting-started/quickstart#step-5%3A-handle-version-control)
  * [Essential controls](https://docs.factory.ai/cli/getting-started/quickstart#essential-controls)
  * [Useful slash commands](https://docs.factory.ai/cli/getting-started/quickstart#useful-slash-commands)
  * [Collaboration best practices](https://docs.factory.ai/cli/getting-started/quickstart#collaboration-best-practices)
  * [Pro tips for enterprise teams](https://docs.factory.ai/cli/getting-started/quickstart#pro-tips-for-enterprise-teams)
  * [What’s next?](https://docs.factory.ai/cli/getting-started/quickstart#what%E2%80%99s-next%3F)


Getting Started
# Quickstart
Copy page
Get productive with droid in 5 minutes using the interactive terminal UI.
Copy page
This quickstart guide will have you collaborating with Factory’s development agent in just a few minutes. You’ll experience how droid understands your codebase, makes thoughtful changes, and integrates with your existing workflow.
##
[​](https://docs.factory.ai/cli/getting-started/quickstart#before-you-begin)
Before you begin
Make sure you have:
  * A terminal open in a code project
  * Git repository (recommended for full workflow demonstration)


##
[​](https://docs.factory.ai/cli/getting-started/quickstart#step-1%3A-install-and-start-droid)
Step 1: Install and start droid
macOS/Linux
Windows
Copy
Ask AI
```
curl -fsSL https://app.factory.ai/cli | sh

```

**Linux users:** Ensure `xdg-utils` is installed for proper functionality. Install with: `sudo apt-get install xdg-utils`
Then navigate to your project and start the droid CLI.
Copy
Ask AI
```
# Navigate to your project
cd /path/to/your/project
# Start interactive session
droid

```

![Droid CLI](https://mintcdn.com/factory/pSQIcJWS0EqHRORW/images/droid_tui_intro.png?fit=max&auto=format&n=pSQIcJWS0EqHRORW&q=85&s=9946098711744d1c1b8fa50445dba229) You’ll see droid’s welcome screen in a full-screen terminal interface. If prompted, sign in via your browser to connect to Factory’s development agent.
##
[​](https://docs.factory.ai/cli/getting-started/quickstart#step-2%3A-explore-your-codebase)
Step 2: Explore your codebase
Let’s start by having droid understand your project. Try one of these questions:
Copy
Ask AI
```

> analyze this codebase and explain the overall architecture

```

Copy
Ask AI
```

> what technologies and frameworks does this project use?

```

Copy
Ask AI
```

> where are the main entry points and how is testing set up?

```

Droid reads your files contextually and leverages organizational knowledge to provide comprehensive insights about your project structure and conventions.
##
[​](https://docs.factory.ai/cli/getting-started/quickstart#step-3%3A-make-your-first-code-change)
Step 3: Make your first code change
Now let’s see droid in action with a simple modification:
Copy
Ask AI
```

> add comprehensive logging to the main application startup

```

Droid will:
  1. Analyze your current logging setup
  2. Propose specific changes with a clear plan
  3. Show you exactly what will be modified
  4. Wait for your approval before making changes

This transparent review process ensures you maintain full control over all code modifications.
##
[​](https://docs.factory.ai/cli/getting-started/quickstart#step-4%3A-experience-enterprise-workflows)
Step 4: Experience enterprise workflows
Try a more complex task that showcases droid’s enterprise capabilities:
Copy
Ask AI
```

> audit this codebase for security vulnerabilities and create a remediation plan

```

Or provide context from your team’s tools by pasting a link:
Copy
Ask AI
```

> implement the feature described in this Jira ticket: https://company.atlassian.net/browse/PROJ-123

```

If you’ve integrated these platforms through Factory’s dashboard, droid can automatically read context from Jira, Notion, Slack, and other sources. Droid can also connect to additional tools via MCP integrations for even more capabilities.
##
[​](https://docs.factory.ai/cli/getting-started/quickstart#step-5%3A-handle-version-control)
Step 5: Handle version control
Droid makes Git operations conversational and intelligent:
Copy
Ask AI
```

> review my uncommitted changes and suggest improvements before I commit

```

Copy
Ask AI
```

> create a well-structured commit with a descriptive message following our team conventions

```

Copy
Ask AI
```

> analyze the last few commits and identify any potential issues or patterns

```

##
[​](https://docs.factory.ai/cli/getting-started/quickstart#essential-controls)
Essential controls
Here are the key interactions you’ll use daily: Action| What it does| How to use
---|---|---
Send message| Submit a task or question| Type and press **Enter**
Multi-line input| Write longer prompts| **Shift+Enter** for new lines
Approve changes| Accept proposed modifications| Accept change in the TUI
Reject changes| Decline proposed modifications| Reject change in the TUI
Switch modes| Toggle between modes| **Shift+Tab**
View shortcuts| See all available commands| Press **?**
Exit session| Leave droid| **Ctrl+C** or type `exit`
###
[​](https://docs.factory.ai/cli/getting-started/quickstart#useful-slash-commands)
Useful slash commands
Quick shortcuts to common actions:
  * `/settings` - Configure droid behavior, models, and preferences
  * `/model` - Switch between AI models mid-session
  * `/mcp` - Manage Model Context Protocol servers
  * `/account` - Open your Factory account settings in browser
  * `/billing` - View and manage your billing settings
  * `/help` - See all available commands

[Learn how to create custom slash commands →](https://docs.factory.ai/cli/configuration/custom-slash-commands)
##
[​](https://docs.factory.ai/cli/getting-started/quickstart#collaboration-best-practices)
Collaboration best practices
**Be specific with context:** Instead of: “fix the bug” Try: “fix the authentication timeout issue where users get logged out after 5 minutes instead of the configured 30 minutes” **Use spec mode for complex features:** For larger features, use [Specification Mode](https://docs.factory.ai/cli/user-guides/specification-mode) which automatically provides planning before implementation without needing to explicitly request it. **Leverage organizational knowledge:**
Copy
Ask AI
```

> following our team's coding standards, implement the user preferences feature described in ticket PROJ-123

```

**Use the review workflow:** Always review droid’s proposed changes before approval. The transparent diff view helps you understand exactly what will be modified.
##
[​](https://docs.factory.ai/cli/getting-started/quickstart#pro-tips-for-enterprise-teams)
Pro tips for enterprise teams
**Security-first approach:** Droid automatically considers security implications and will flag potential vulnerabilities during code generation. **Compliance integration:** Connect your compliance tools through MCP to ensure all changes meet your organization’s standards. **Team knowledge sharing:** Droid learns from your organization’s patterns and can help maintain consistency across team members and projects.
##
[​](https://docs.factory.ai/cli/getting-started/quickstart#what%E2%80%99s-next%3F)
What’s next?
## [Common Use CasesExplore real-world scenarios and workflows](https://docs.factory.ai/cli/getting-started/common-use-cases)## [ConfigurationCustomize droid for your team’s workflow](https://docs.factory.ai/cli/configuration/settings)## [AGENTS.md GuideDocument your project conventions and commands](https://docs.factory.ai/cli/configuration/agents-md)## [IDE IntegrationUse droid within your favorite editor](https://docs.factory.ai/cli/configuration/ide-integrations)
[Overview](https://docs.factory.ai/cli/getting-started/overview)[Video Walkthrough](https://docs.factory.ai/cli/getting-started/video-walkthrough)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
![Droid CLI](https://mintcdn.com/factory/pSQIcJWS0EqHRORW/images/droid_tui_intro.png?w=560&fit=max&auto=format&n=pSQIcJWS0EqHRORW&q=85&s=6c8d77d47dba40bf917b48b32e49dd8b)
