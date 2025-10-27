# https://docs.factory.ai/cli/getting-started/common-use-cases

[Skip to main content](https://docs.factory.ai/cli/getting-started/common-use-cases#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Getting Started
Common Use Cases
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
  * [Understanding a new codebase](https://docs.factory.ai/cli/getting-started/common-use-cases#understanding-a-new-codebase)
  * [Fixing bugs and debugging](https://docs.factory.ai/cli/getting-started/common-use-cases#fixing-bugs-and-debugging)
  * [Building features](https://docs.factory.ai/cli/getting-started/common-use-cases#building-features)
  * [Working with tests](https://docs.factory.ai/cli/getting-started/common-use-cases#working-with-tests)
  * [Safe refactoring](https://docs.factory.ai/cli/getting-started/common-use-cases#safe-refactoring)
  * [Documentation and communication](https://docs.factory.ai/cli/getting-started/common-use-cases#documentation-and-communication)
  * [Enterprise integration](https://docs.factory.ai/cli/getting-started/common-use-cases#enterprise-integration)
  * [Getting the most value](https://docs.factory.ai/cli/getting-started/common-use-cases#getting-the-most-value)
  * [Next steps](https://docs.factory.ai/cli/getting-started/common-use-cases#next-steps)


Getting Started
# Common Use Cases
Copy page
Practical, day‑one workflows you can run in the interactive terminal UI.
Copy page
Droid excels at real-world development tasks. This guide shows practical workflows you can use immediately, with specific prompts that get great results.
##
[​](https://docs.factory.ai/cli/getting-started/common-use-cases#understanding-a-new-codebase)
Understanding a new codebase
**Start with the big picture:**
Copy
Ask AI
```
Analyze this codebase and explain the overall architecture.
What technologies and frameworks does this project use?
Where are the main entry points and how is testing set up?

```

**Drill down into specifics:**
Copy
Ask AI
```
Explain how user authentication flows through this system.
What are the main components in the frontend and how do they interact?
Show me where the API routes are defined and list the key handlers.

```

**Navigate by domain:**
Copy
Ask AI
```
Where does payment processing happen? Walk me through a typical payment flow.
Find all the database models and explain their relationships.
Show me the error handling patterns used throughout this codebase.

```

Droid leverages organizational knowledge and can read through your entire project structure to provide comprehensive explanations with relevant file references and architectural insights.
##
[​](https://docs.factory.ai/cli/getting-started/common-use-cases#fixing-bugs-and-debugging)
Fixing bugs and debugging
**From error message to solution:**
Copy
Ask AI
```
I'm seeing this error in production:
TypeError: Cannot read properties of undefined (reading 'title')
at src/components/PostCard.tsx:37:14
Help me reproduce locally and fix it. Explain the root cause first.

```

**Using logs for debugging:**
Copy
Ask AI
```
Here are the server logs from the last hour showing 500 errors.
Find the failing code path and propose a fix with proper error handling.

```

**Systematic debugging:**
Copy
Ask AI
```
Users report that file uploads fail randomly with "Network timeout" errors.
The upload logic is in src/upload/handler.ts.
Add logging to diagnose the issue and implement retry logic.

```

Droid will analyze error patterns, create failing tests to reproduce issues, propose minimal fixes, and verify the solution works.
##
[​](https://docs.factory.ai/cli/getting-started/common-use-cases#building-features)
Building features
**Enterprise workflow integration:**
Copy
Ask AI
```
Implement the feature described in this Jira ticket: https://company.atlassian.net/browse/PROJ-123
Follow our security standards and include comprehensive error handling.

```

**API development:**
Copy
Ask AI
```
Add a PATCH /users/:id endpoint with email uniqueness validation.
Return 200 on success, 400 on invalid payload, 404 if user missing.
Update the OpenAPI spec and add integration tests.
Similar patterns exist in src/routes/users/get.ts.

```

**Using Specification Mode:** For complex features, use [Specification Mode](https://docs.factory.ai/cli/user-guides/specification-mode) to automatically get planning before implementation. This ensures proper architecture and reduces iterations.
##
[​](https://docs.factory.ai/cli/getting-started/common-use-cases#working-with-tests)
Working with tests
**Test-driven development:**
Copy
Ask AI
```
Write comprehensive tests for the user registration flow first.
Don't implement the actual registration logic yet.
Include tests for validation, duplicate emails, and password requirements.

```

**Fixing failing tests:**
Copy
Ask AI
```
Run tests and fix the first failing test.
Explain the root cause before making changes.
Show me the diff before applying any fixes.

```

**Improving test coverage:**
Copy
Ask AI
```
Identify untested critical paths in the payment processing module.
Propose specific test cases and implement them with proper mocks.

```

##
[​](https://docs.factory.ai/cli/getting-started/common-use-cases#safe-refactoring)
Safe refactoring
**Structure improvements:**
Copy
Ask AI
```
Refactor the authentication module into smaller files with no behavior change.
Keep the public API identical and run all tests after each change.

```

**Dependency updates:**
Copy
Ask AI
```
Replace the deprecated bcrypt library with bcryptjs project-wide.
Update all imports and ensure compatibility across the codebase.
Show a summary of all files changed.

```

**Code quality:**
Copy
Ask AI
```
Extract the shared date utility functions into a separate module.
Update imports across the repository and run tests to confirm identical behavior.

```

##
[​](https://docs.factory.ai/cli/getting-started/common-use-cases#documentation-and-communication)
Documentation and communication
**API documentation:**
Copy
Ask AI
```
Generate comprehensive OpenAPI specification for the payments service.
Include request/response examples and error codes.
Create a TypeScript SDK based on the spec.

```

**Code explanations:**
Copy
Ask AI
```
Explain the relationship between the AutoScroller and ViewUpdater classes using a diagram.
Document the data flow and key methods for new team members.

```

**Release management:**
Copy
Ask AI
```
Summarize all changes in this branch and draft a pull request description.
Include breaking changes and migration notes for API consumers.

```

##
[​](https://docs.factory.ai/cli/getting-started/common-use-cases#enterprise-integration)
Enterprise integration
**Team tool integration:** If you’ve integrated platforms through Factory’s dashboard, droid can automatically read context when you paste links to specific tickets or documents:
Copy
Ask AI
```
Read this Jira ticket and implement the feature: https://company.atlassian.net/browse/PROJ-123
Include all the acceptance criteria and follow our security standards.

```

Copy
Ask AI
```
Use the requirements from this Notion spec to implement the user preferences API: https://notion.so/team/user-prefs-spec
Follow the data structure and validation rules outlined in the document.

```

**Security-focused development:**
Copy
Ask AI
```
Add file upload functionality with proper validation to prevent directory traversal attacks.
Follow the security patterns used in our existing document upload feature.
Include rate limiting and file type validation.

```

**Compliance considerations:**
Copy
Ask AI
```
Review this authentication implementation for GDPR compliance.
Ensure proper data encryption and user consent handling.
Add audit logging for all user data access.

```

##
[​](https://docs.factory.ai/cli/getting-started/common-use-cases#getting-the-most-value)
Getting the most value
**Be specific and direct:** Instead of “fix the login bug,” try “fix the authentication timeout where users get logged out after 5 minutes instead of the configured 30 minutes.” **Provide verification steps:** Tell droid how to confirm success—run specific tests, check that services start cleanly, or verify UI behavior. **Use organizational knowledge:** Reference team conventions, existing patterns, and established practices. Droid learns from your codebase and can help maintain consistency. **Leverage the review workflow:** Always review proposed changes before approval. The transparent diff view helps you understand modifications and provide feedback for better future results.
##
[​](https://docs.factory.ai/cli/getting-started/common-use-cases#next-steps)
Next steps
Ready to try these workflows? Head to the [Quickstart](https://docs.factory.ai/cli/getting-started/quickstart) to get droid running, or dive into [Specification Mode](https://docs.factory.ai/cli/user-guides/specification-mode) for complex feature development. For more communication tips, see [How to Talk to a Droid](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid) to learn proven prompting patterns that get better results. For more communication tips, see [How to Talk to a Droid](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid) to learn proven prompting patterns that get better results.
[How to Talk to a Droid](https://docs.factory.ai/cli/getting-started/how-to-talk-to-a-droid)[Become a Power User](https://docs.factory.ai/cli/user-guides/become-a-power-user)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
