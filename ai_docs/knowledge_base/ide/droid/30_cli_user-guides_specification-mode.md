# https://docs.factory.ai/cli/user-guides/specification-mode

[Skip to main content](https://docs.factory.ai/cli/user-guides/specification-mode#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
User Guides
Specification Mode
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
  * [How it works](https://docs.factory.ai/cli/user-guides/specification-mode#how-it-works)
  * [Example workflow](https://docs.factory.ai/cli/user-guides/specification-mode#example-workflow)
  * [How to activate Specification Mode](https://docs.factory.ai/cli/user-guides/specification-mode#how-to-activate-specification-mode)
  * [What happens during planning](https://docs.factory.ai/cli/user-guides/specification-mode#what-happens-during-planning)
  * [Writing effective requests](https://docs.factory.ai/cli/user-guides/specification-mode#writing-effective-requests)
  * [Enterprise integration](https://docs.factory.ai/cli/user-guides/specification-mode#enterprise-integration)
  * [Benefits](https://docs.factory.ai/cli/user-guides/specification-mode#benefits)
  * [AGENTS.md integration](https://docs.factory.ai/cli/user-guides/specification-mode#agents-md-integration)
  * [Breaking down large features](https://docs.factory.ai/cli/user-guides/specification-mode#breaking-down-large-features)
  * [Specification approval options](https://docs.factory.ai/cli/user-guides/specification-mode#specification-approval-options)
  * [Saving your specifications as Markdown](https://docs.factory.ai/cli/user-guides/specification-mode#saving-your-specifications-as-markdown)
  * [What happens after approval](https://docs.factory.ai/cli/user-guides/specification-mode#what-happens-after-approval)


User Guides
# Specification Mode
Copy page
Turn plain-English specifications into production-ready code with automatic planning and review.
Copy page
Specification Mode transforms simple feature descriptions into working code with automatic planning and safety checks. You provide a brief description of what you want, and droid creates a detailed specification and implementation plan before making any changes.
## Simple Input
Just 4-6 sentences describing what you want built
## Automatic Planning
Droid creates detailed specs and implementation plans
## Safe Execution
No code changes until you approve the complete plan
## Enterprise Ready
Built-in security, compliance, and team standards
##
[​](https://docs.factory.ai/cli/user-guides/specification-mode#how-it-works)
How it works
1
Describe your feature
Provide a simple description in 4-6 sentences. No need to write formal specifications.
2
Droid creates the spec
Droid analyzes your request and generates a complete specification with acceptance criteria, implementation plan, and technical details. You can optionally use [mixed models](https://docs.factory.ai/cli/configuration/mixed-models) to configure a different model for planning.
3
Review and approve
You review the generated specification and implementation plan. Request changes or approve as-is.
4
Implementation
Only after approval does droid begin making actual code changes, showing each modification for review.
##
[​](https://docs.factory.ai/cli/user-guides/specification-mode#example-workflow)
Example workflow
**Your input:**
Copy
Ask AI
```
Add a feature for users to export their personal data.
It should create a ZIP file with their profile, posts, and uploaded files.
Send them an email when it's ready. Make sure it follows GDPR requirements.
The export should work for accounts up to 2GB of data.

```

**Droid generates:**
  * Complete specification with detailed acceptance criteria
  * Technical implementation plan covering backend, frontend, and email
  * File-by-file breakdown of changes needed
  * Testing strategy and verification steps
  * Security and compliance considerations

**You approve, then droid implements** the complete solution while showing each change for review.
Specification Mode must be manually activated using **Shift+Tab** in the CLI. It does not automatically activate.
##
[​](https://docs.factory.ai/cli/user-guides/specification-mode#how-to-activate-specification-mode)
How to activate Specification Mode
To enter Specification Mode, press **Shift+Tab** while in the CLI. This will enable the specification planning workflow for your next request.
##
[​](https://docs.factory.ai/cli/user-guides/specification-mode#what-happens-during-planning)
What happens during planning
**Analysis phase (read-only):**
  * Examines your existing codebase and patterns
  * Reviews related files and dependencies
  * Studies your AGENTS.md conventions
  * Gathers context from external sources

**Planning phase:**
  * Develops comprehensive implementation strategy
  * Identifies all files that need changes
  * Plans sequence of modifications
  * Considers testing and verification steps

**Safety guarantees:**
  * Cannot edit files during analysis
  * Cannot run commands that modify anything
  * Cannot create, delete, or move files
  * All exploration is read-only until you approve


##
[​](https://docs.factory.ai/cli/user-guides/specification-mode#writing-effective-requests)
Writing effective requests
**Focus on outcomes:** Describe what the software should accomplish, not how to build it.
Copy
Ask AI
```
Users need to be able to reset their passwords using email verification.
The reset link should expire after 24 hours for security.
Include rate limiting to prevent abuse.

```

**Include important constraints:**
Copy
Ask AI
```
Add user data export functionality that works for accounts up to 5GB.
Must comply with GDPR and include audit logging.
Should complete within 10 minutes and not impact application performance.

```

**Reference existing patterns:**
Copy
Ask AI
```
Add a notification system similar to how we handle email confirmations.
Use the same background job pattern as our existing report generation.
Follow the authentication patterns we use for other sensitive operations.

```

**Be specific about verification:** Tell droid how to confirm the implementation works correctly. **Consider the full user journey:** Describe the complete experience, not just technical requirements. **Include error scenarios:** Specify how failures should be handled and communicated to users. **Think about scale:** Mention performance requirements and expected usage patterns.
##
[​](https://docs.factory.ai/cli/user-guides/specification-mode#enterprise-integration)
Enterprise integration
Reference external requirements by pasting links:
Copy
Ask AI
```
Implement the user management features described in this Jira ticket:
https://company.atlassian.net/browse/PROJ-123
Follow our security standards and include comprehensive error handling.

```

If you’ve integrated platforms through Factory’s dashboard, droid can read context from tickets, documents, and specs during analysis.
##
[​](https://docs.factory.ai/cli/user-guides/specification-mode#benefits)
Benefits
## Safety First
No accidental changes during exploration. See the complete plan before any modifications.
## Thorough Planning
Comprehensive analysis leads to better architecture decisions and fewer surprises.
## Full Control
Complete visibility into what will be done before any code changes happen.
## Better Outcomes
Well-planned implementations are more likely to be correct, complete, and maintainable.
##
[​](https://docs.factory.ai/cli/user-guides/specification-mode#agents-md-integration)
AGENTS.md integration
Document your project conventions to enhance Specification Mode’s planning. See [AGENTS.md](https://docs.factory.ai/cli/configuration/agents-md) for more information. Specification Mode automatically incorporates these conventions, ensuring consistency with your team’s standards.
##
[​](https://docs.factory.ai/cli/user-guides/specification-mode#breaking-down-large-features)
Breaking down large features
For complex features spanning multiple components, break them into focused phases: **Phase 1:**
Copy
Ask AI
```
Implement user data export backend API and job processing.
Focus only on the server-side functionality, not the UI yet.

```

**Phase 2:**
Copy
Ask AI
```
Add the frontend UI for data export using the API from Phase 1.
Include progress indicators and download management.

```

This approach allows you to validate each phase before proceeding to the next.
##
[​](https://docs.factory.ai/cli/user-guides/specification-mode#specification-approval-options)
Specification approval options
After droid presents the specification, choose how to continue:
  1. **Proceed with implementation** – Approve the plan and keep normal (manual) execution controls.
  2. **Proceed, and allow file edits and read-only commands (Low)** – Enable low autonomy auto-run so droid can edit files and run safe read-only commands automatically.
  3. **Proceed, and allow reversible commands (Medium)** – Enable medium autonomy auto-run so droid can also run reversible commands without additional prompts.
  4. **Proceed, and allow all commands (High)** – Enable high autonomy auto-run for fully automated execution, including commands that are not easily reversible.
  5. **No, keep iterating on spec** – Stay in Specification Mode to refine the plan before implementation.

Selecting any auto-run option sets the corresponding autonomy level for the rest of the session. Choosing to keep iterating leaves Specification Mode active so you can continue shaping the plan.
##
[​](https://docs.factory.ai/cli/user-guides/specification-mode#saving-your-specifications-as-markdown)
Saving your specifications as Markdown
Specification Mode can automatically write the approved plan to disk. Open the CLI settings and enable **Save spec as Markdown** to turn this on.
  * By default, plans are saved to `.factory/docs` inside the nearest project-level `.factory` directory. If none exists, the CLI falls back to `~/.factory/docs` in your home directory.
  * Use the **Spec save directory** setting to pick between the project directory, your home directory, or a custom path. Custom values support absolute paths, `~` expansion, `.factory/...` shortcuts, and relative paths from the current workspace.
  * The CLI creates the target directory if it does not exist and writes the Markdown exactly as shown in the approval dialog.
  * Files are named `YYYY-MM-DD-slug.md`, where the slug comes from the spec title or first heading, and a counter is appended if a file with the same name already exists.


##
[​](https://docs.factory.ai/cli/user-guides/specification-mode#what-happens-after-approval)
What happens after approval
Once you approve a specification plan, droid systematically implements the changes while showing each modification for review. You maintain full control through the approval workflow, ensuring quality and alignment with requirements. For simpler changes that don’t need comprehensive planning, droid can proceed directly while still showing all modifications for approval. Ready to try Specification Mode? Start with a simple description of what you want to build, and let droid handle the specification and planning complexity.
[Become a Power User](https://docs.factory.ai/cli/user-guides/become-a-power-user)[Auto-Run Mode](https://docs.factory.ai/cli/user-guides/auto-run)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
