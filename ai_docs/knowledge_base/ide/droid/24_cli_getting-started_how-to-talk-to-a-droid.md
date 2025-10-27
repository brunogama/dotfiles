# https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid

[Skip to main content](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Getting Started
How to Talk to a Droid
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
  * [Core principles](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#core-principles)
  * [Writing effective prompts](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#writing-effective-prompts)
  * [Planning versus doing](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#planning-versus-doing)
  * [Managing context](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#managing-context)
  * [Common workflows](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#common-workflows)
  * [Enterprise integration](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#enterprise-integration)
  * [Session management](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#session-management)
  * [Advanced techniques](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#advanced-techniques)
  * [Examples of good prompts](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#examples-of-good-prompts)
  * [What doesn’t work well](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#what-doesn%E2%80%99t-work-well)
  * [Getting better results](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#getting-better-results)


Getting Started
# How to Talk to a Droid
Copy page
Proven techniques for writing prompts that get high-quality results from Factory’s AI agents.
Copy page
Droid works best with clear, specific instructions. Like pairing with a skilled engineer, the quality of your communication directly affects the results. This guide shows practical patterns that get better outcomes with fewer iterations.
##
[​](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#core-principles)
Core principles
**Be explicit about what you want.** Instead of “can you improve the auth system?” try “add rate limiting to login attempts with exponential backoff following the pattern in middleware/rateLimit.ts.” Droid performs best when you clearly state your goal. **Provide context upfront.** Include error messages, file paths, screenshots, or relevant documentation. If you’re implementing something from a Jira ticket or design doc, paste the link—droid can automatically read context from platforms you’ve integrated in Factory’s dashboard. **Choose your approach.** For complex features, consider using Specification Mode for automatic planning. For routine tasks, droid can proceed directly while still showing you all changes for review. See the [Planning versus doing](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#planning-versus-doing) section for detailed guidance. **Define success.** Tell droid how to verify the work is complete—run specific tests, check that a service starts cleanly, or confirm a UI matches a mockup.
##
[​](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#writing-effective-prompts)
Writing effective prompts
The best prompts are direct and include relevant details:
Copy
Ask AI
```
Add comprehensive error handling to the payment processor in src/payments/processor.ts.
Catch gateway timeouts and retry up to 3 times with exponential backoff.
Similar retry logic exists in src/notifications/sender.ts.
Run the payment integration tests to verify it works.

```

Copy
Ask AI
```
Run the build and fix all TypeScript errors. Focus on the auth module first.

```

Copy
Ask AI
```
Review my uncommitted changes with git diff and suggest improvements before I commit.

```

Copy
Ask AI
```
The login form allows empty submissions. Add client-side validation and return proper error messages.
Check that localhost:3000/login shows validation errors when fields are empty.

```

Copy
Ask AI
```
Refactor the database connection logic into a separate module but don't change any query interfaces.

```

Notice these examples:
  * State the goal clearly in the first sentence
  * Include specific files or commands when known
  * Mention related code that might help
  * Explain how to test the result
  * Keep it conversational but direct


##
[​](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#planning-versus-doing)
Planning versus doing
For complex features, use [Specification Mode](https://docs.factory.ai/cli/user-guides/specification-mode) which automatically provides planning and review before implementation:
Copy
Ask AI
```
Add user preferences API with key-value storage following REST conventions.
Include validation and comprehensive tests.

```

For straightforward tasks, droid can proceed directly while still showing you changes for approval:
Copy
Ask AI
```
Fix the failing test in tests/auth.test.ts line 42

```

Copy
Ask AI
```
Add logging to the startup sequence with appropriate log levels.

```

##
[​](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#managing-context)
Managing context
**Use AGENTS.md files** to document build commands, testing procedures, and coding standards. Droid reads these automatically, so you don’t have to repeat project conventions. See the [AGENTS.md guide](https://docs.factory.ai/cli/configuration/agents-md) for detailed setup instructions. **Mention specific files** when you know where the code lives. Use `@filename` to reference files directly, or include file paths in your prompts. This focuses droid’s attention and saves time. **Set boundaries** for changes. “Only modify files in the auth directory” or “don’t change the public API” helps contain the scope. **Reference external resources** by including URLs to tickets, docs, designs, or specs. Droid can fetch and use this information.
##
[​](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#common-workflows)
Common workflows
**Understanding code:**
Copy
Ask AI
```
Explain how user authentication flows through this system.

```

Copy
Ask AI
```
What are the main components in the frontend and how do they interact?

```

**Implementing features:**
Copy
Ask AI
```
Add a PATCH /users/:id endpoint with email uniqueness validation.
Update the OpenAPI spec and add integration tests.
Similar patterns exist in src/routes/users/get.ts.

```

**Fixing bugs:**
Copy
Ask AI
```
Users report file uploads fail randomly. Error in browser console: "Network timeout".
Upload logic is in src/upload/handler.ts. Check for timeout handling.

```

**Code review:**
Copy
Ask AI
```
Look at git diff and review these changes for security issues and maintainability.

```

**Refactoring:**
Copy
Ask AI
```
Extract the email sending logic into a separate service class.
Keep the same interfaces but make it testable in isolation.

```

##
[​](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#enterprise-integration)
Enterprise integration
Reference your team’s tools by pasting links to tickets or documents:
Copy
Ask AI
```
Implement the feature described in this Jira ticket: https://company.atlassian.net/browse/PROJ-123
Follow our security standards from the compliance docs.

```

If you’ve integrated these platforms in Factory’s dashboard, droid can automatically read context from Jira, Notion, Slack, and other sources. For additional tool connections, droid also supports MCP integrations. For security-sensitive work:
Copy
Ask AI
```
Add file upload functionality with proper validation to prevent directory traversal attacks.
Follow the security patterns used in our document upload feature.

```

##
[​](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#session-management)
Session management
Start new conversations when context gets cluttered or when switching to unrelated tasks. Fresh context often works better than accumulated noise from failed attempts. For large projects, break work into phases:
Copy
Ask AI
```
First implement the database schema changes. Don't add the API endpoints yet.

```

Then in a follow-up:
Copy
Ask AI
```
Now add the REST endpoints using the new schema. Include validation and error handling.

```

##
[​](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#advanced-techniques)
Advanced techniques
**Test-driven development:**
Copy
Ask AI
```
Write comprehensive tests for the user registration flow first.
Don't implement the actual registration logic yet.

```

**Plan-driven development:**
Copy
Ask AI
```
Create a markdown file outlining the plan for updating both backend API and React components.
Include the shared data structure and implementation order.
Then implement each part following the documented plan.

```

##
[​](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#examples-of-good-prompts)
Examples of good prompts
Here are real examples that work well:
Copy
Ask AI
```
Run git blame on the file I have open and figure out who added the rate limiting logic.

```

Copy
Ask AI
```
Look at git diff staged and remove any debug statements before I commit.

```

Copy
Ask AI
```
Convert these 5 React components to use TypeScript. Use proper interfaces for props.

```

Copy
Ask AI
```
Find the commit that introduced the caching mechanism and explain how it works.

```

Copy
Ask AI
```
Add input validation to all the forms in the admin panel. Return 400 with clear error messages.

```

Copy
Ask AI
```
Check the production logs for any errors in the last hour and suggest fixes for the most common ones.

```

##
[​](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#what-doesn%E2%80%99t-work-well)
What doesn’t work well
Avoid vague requests:
  * “Make the app better” → too broad
  * “Fix the database” → not specific enough
  * “Can you help with the frontend?” → unclear goal

Don’t make droid guess:
  * If you know the file path, include it
  * If you know the command to run, mention it
  * If there’s related code, point to it


##
[​](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid#getting-better-results)
Getting better results
Treat droid like a capable teammate. Provide the same context and guidance you’d give a colleague working on the task. Be specific about quality standards and business requirements. Remember that droid learns your organization’s patterns over time. The more consistently you use it within your codebase, the better it becomes at following your conventions. Most importantly, review the changes droid proposes. You maintain full control through the approval workflow, so take time to understand modifications and provide feedback for better future results. Ready to try these patterns? Head back to the [Quickstart](https://docs.factory.ai/cli/getting-started/quickstart) and practice with your own code.
[Video Walkthrough](https://docs.factory.ai/cli/getting-started/video-walkthrough)[Common Use Cases](https://docs.factory.ai/cli/getting-started/common-use-cases)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
