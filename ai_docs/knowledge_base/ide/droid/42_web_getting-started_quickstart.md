# https://docs.factory.ai/web/getting-started/quickstart

[Skip to main content](https://docs.factory.ai/web/getting-started/quickstart#content-area)
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
  * [Overview](https://docs.factory.ai/web/getting-started/overview)
  * [Quickstart](https://docs.factory.ai/web/getting-started/quickstart)


##### Core Concepts
  * Context
  * Droids


##### Machine Connection
  * Factory Bridge
  * Remote Workspaces


##### User Guides
  * Use Cases


On this page
  * [Step 1: Launch Factory](https://docs.factory.ai/web/getting-started/quickstart#step-1%3A-launch-factory)
  * [Step 2: Configure Your Session](https://docs.factory.ai/web/getting-started/quickstart#step-2%3A-configure-your-session)
  * [Local Connection (Bridge)](https://docs.factory.ai/web/getting-started/quickstart#local-connection-bridge)
  * [Remote Connection](https://docs.factory.ai/web/getting-started/quickstart#remote-connection)
  * [Step 3: Explore Your Codebase](https://docs.factory.ai/web/getting-started/quickstart#step-3%3A-explore-your-codebase)
  * [Step 4: Make Your First Code Change](https://docs.factory.ai/web/getting-started/quickstart#step-4%3A-make-your-first-code-change)
  * [Step 5: Experience Enterprise Workflows](https://docs.factory.ai/web/getting-started/quickstart#step-5%3A-experience-enterprise-workflows)
  * [Security Audit](https://docs.factory.ai/web/getting-started/quickstart#security-audit)
  * [Integration with Team Tools](https://docs.factory.ai/web/getting-started/quickstart#integration-with-team-tools)
  * [Best Practices](https://docs.factory.ai/web/getting-started/quickstart#best-practices)
  * [Be Specific with Context](https://docs.factory.ai/web/getting-started/quickstart#be-specific-with-context)
  * [Leverage Organizational Knowledge](https://docs.factory.ai/web/getting-started/quickstart#leverage-organizational-knowledge)
  * [Use the Review Workflow](https://docs.factory.ai/web/getting-started/quickstart#use-the-review-workflow)
  * [Congratulations! 🎉](https://docs.factory.ai/web/getting-started/quickstart#congratulations-%F0%9F%8E%89)
  * [Next Steps](https://docs.factory.ai/web/getting-started/quickstart#next-steps)


Getting Started
# Quickstart
Copy page
Connect to your machine and execute on tasks in just 5 minutes
Copy page
In this Quickstart Guide, you’ll learn how to launch Factory, connect to your codebase, and start making code changes with AI assistance.
Make sure you have access to Factory before getting started.
##
[​](https://docs.factory.ai/web/getting-started/quickstart#step-1%3A-launch-factory)
Step 1: Launch Factory
1
Open Factory
Open the Factory application in your browser.
![factoryhomepage.png](https://mintcdn.com/factory/Hp3lbmWjJVrQVsgq/images/web/factoryhomepage.png?fit=max&auto=format&n=Hp3lbmWjJVrQVsgq&q=85&s=431b74cd2a6aac4a928c50a80db47460)
By default, your session is configured with settings from your most recent session. First-time users will see default settings: Code Droid, remote connection, and an empty workspace.
##
[​](https://docs.factory.ai/web/getting-started/quickstart#step-2%3A-configure-your-session)
Step 2: Configure Your Session
1
Select Your Droid
Click the Droid Selection button to choose the appropriate droid based on your project needs.
![droid-selection.gif](https://mintcdn.com/factory/Hp3lbmWjJVrQVsgq/images/web/droid-selection.gif?s=752aa9547d1581a27725737ef84cac88)
2
Select Your Machine Connection
![machine-connection-start.gif](https://mintcdn.com/factory/Hp3lbmWjJVrQVsgq/images/web/machine-connection-start.gif?s=81a3f3be856a4b9d9df4cb828715e2a1)
Choose between Local (via Bridge) or Remote connection.
###
[​](https://docs.factory.ai/web/getting-started/quickstart#local-connection-bridge)
Local Connection (Bridge)
  1. Download Factory Bridge and open the application
  2. Enter the pairing code displayed in the Machine Connection menu
  3. Set your root directory to your working directory
  4. Bridge automatically scans for repositories from the root directory
  5. Select repositories relevant to this session


![bridge-connection.gif](https://mintcdn.com/factory/Hp3lbmWjJVrQVsgq/images/web/bridge-connection.gif?s=f7336e4e48227a4e5935d19d046826d6)
###
[​](https://docs.factory.ai/web/getting-started/quickstart#remote-connection)
Remote Connection
Connect to a remote workspace (requires GitHub or GitLab integration).
See our [Integrations guide](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/github-cloud) to connect GitHub or GitLab for remote workspaces.
3
Select Model and Tools
Choose your desired model and activate the necessary tools for your task.
![model-tool-selection.gif](https://mintcdn.com/factory/Hp3lbmWjJVrQVsgq/images/web/model-tool-selection.gif?s=deabf9e5446a82a7f8868a133a68e0a5)
Tools extend Factory’s capabilities. Learn more about [external integrations](https://docs.factory.ai/web/core-concepts/context/external-integrations) to connect with Jira, Notion, Slack, and other platforms.
##
[​](https://docs.factory.ai/web/getting-started/quickstart#step-3%3A-explore-your-codebase)
Step 3: Explore Your Codebase
1
Analyze Your Architecture
Start with a comprehensive overview of your project:
Copy
Ask AI
```
> Analyze this codebase and explain the overall architecture

```

Droid reads your files contextually and leverages organizational knowledge to provide comprehensive insights about your project structure and conventions.
Use the context panel to explore all context leveraged by Droid. Learn more about [context management](https://docs.factory.ai/web/core-concepts/context/understanding-context).
##
[​](https://docs.factory.ai/web/getting-started/quickstart#step-4%3A-make-your-first-code-change)
Step 4: Make Your First Code Change
1
Request a Simple Modification
Try a simple modification to see Droid in action:
Copy
Ask AI
```
> Add comprehensive logging to the main application startup

```

Droid will:
  1. Analyze your current logging setup
  2. Propose specific changes with a clear plan
  3. Show you exactly what will be modified


This transparent review process ensures you maintain full control over all code modifications.
##
[​](https://docs.factory.ai/web/getting-started/quickstart#step-5%3A-experience-enterprise-workflows)
Step 5: Experience Enterprise Workflows
1
Complex Tasks with External Context
Try more complex tasks that showcase Factory’s enterprise capabilities:
###
[​](https://docs.factory.ai/web/getting-started/quickstart#security-audit)
Security Audit
Copy
Ask AI
```
> Audit this codebase for security vulnerabilities and create a remediation plan

```

###
[​](https://docs.factory.ai/web/getting-started/quickstart#integration-with-team-tools)
Integration with Team Tools
Provide context from your team’s tools using ’@’ mentions or direct links.
If you’ve integrated these platforms through Factory’s dashboard, Droid can automatically read context from Jira, Notion, Slack, and other sources. Learn about [external integrations](https://docs.factory.ai/web/core-concepts/context/external-integrations) for additional capabilities.
##
[​](https://docs.factory.ai/web/getting-started/quickstart#best-practices)
Best Practices
###
[​](https://docs.factory.ai/web/getting-started/quickstart#be-specific-with-context)
Be Specific with Context
**Instead of:** “Fix the bug” **Try:** “Fix the authentication timeout issue where users get logged out after 5 minutes instead of the configured 30 minutes”
###
[​](https://docs.factory.ai/web/getting-started/quickstart#leverage-organizational-knowledge)
Leverage Organizational Knowledge
“Following our team’s coding standards, implement the user preferences feature described in ticket PROJ-123”
###
[​](https://docs.factory.ai/web/getting-started/quickstart#use-the-review-workflow)
Use the Review Workflow
Always review Droid’s proposed changes before approval. The transparent diff view helps you understand exactly what will be modified.
##
[​](https://docs.factory.ai/web/getting-started/quickstart#congratulations-%F0%9F%8E%89)
Congratulations! 🎉
You’ve successfully connected Factory to your codebase and made your first AI-assisted code changes.
###
[​](https://docs.factory.ai/web/getting-started/quickstart#next-steps)
Next Steps
  * Explore [Context Management features](https://docs.factory.ai/web/core-concepts/context/understanding-context)
  * Review common [Use Cases](https://docs.factory.ai/web/use-cases/overview)
  * Set up [External Integrations](https://docs.factory.ai/web/core-concepts/context/external-integrations)


[Overview](https://docs.factory.ai/web/getting-started/overview)[Understanding Context](https://docs.factory.ai/web/core-concepts/context/understanding-context)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
![factoryhomepage.png](https://mintcdn.com/factory/Hp3lbmWjJVrQVsgq/images/web/factoryhomepage.png?w=560&fit=max&auto=format&n=Hp3lbmWjJVrQVsgq&q=85&s=44cde995875c10128bee59abf8c53dae)
![droid-selection.gif](https://mintcdn.com/factory/Hp3lbmWjJVrQVsgq/images/web/droid-selection.gif?s=752aa9547d1581a27725737ef84cac88)
![machine-connection-start.gif](https://mintcdn.com/factory/Hp3lbmWjJVrQVsgq/images/web/machine-connection-start.gif?s=81a3f3be856a4b9d9df4cb828715e2a1)
![bridge-connection.gif](https://mintcdn.com/factory/Hp3lbmWjJVrQVsgq/images/web/bridge-connection.gif?s=f7336e4e48227a4e5935d19d046826d6)
![model-tool-selection.gif](https://mintcdn.com/factory/Hp3lbmWjJVrQVsgq/images/web/model-tool-selection.gif?s=deabf9e5446a82a7f8868a133a68e0a5)
