# https://docs.factory.ai/cli/user-guides/become-a-power-user

[Skip to main content](https://docs.factory.ai/cli/user-guides/become-a-power-user#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
User Guides
Become a Power User
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
  * [Factory IDE Plugin — Real-time context awareness](https://docs.factory.ai/cli/user-guides/become-a-power-user#factory-ide-plugin-%E2%80%94-real-time-context-awareness)
  * [Spec Mode — Explore and plan first, code second](https://docs.factory.ai/cli/user-guides/become-a-power-user#spec-mode-%E2%80%94-explore-and-plan-first%2C-code-second)
  * [AGENTS.md — Your preferences, remembered](https://docs.factory.ai/cli/user-guides/become-a-power-user#agents-md-%E2%80%94-your-preferences%2C-remembered)
  * [Agent Readiness — Let your tools do the teaching](https://docs.factory.ai/cli/user-guides/become-a-power-user#agent-readiness-%E2%80%94-let-your-tools-do-the-teaching)
  * [Combining all four for maximum impact](https://docs.factory.ai/cli/user-guides/become-a-power-user#combining-all-four-for-maximum-impact)


User Guides
# Become a Power User
Copy page
Maximize Droid performance with IDE integration, smart planning, and project optimization.
Copy page
Want Droid to work faster, smarter, and with fewer iterations? These four power features transform good results into exceptional ones. Each technique saves tokens, reduces tool calls, and ships better code.
## Fewer Tool Calls
IDE plugin provides real-time context so Droid sees what you see
## Better First Attempts
Spec Mode explores before coding, preventing false starts
## Consistent Quality
AGENTS.md captures your standards once, applies them always
## Self-Correcting Code
Linters and tests let Droid fix issues before you even see them
##
[​](https://docs.factory.ai/cli/user-guides/become-a-power-user#factory-ide-plugin-%E2%80%94-real-time-context-awareness)
Factory IDE Plugin — Real-time context awareness
Make sure to install Factory IDE plugin for Droid. The Factory IDE plugin acts as an MCP server that gives Droid immediate awareness of your development environment. No more explaining what file you’re looking at or copying error messages—Droid sees exactly what you see. **What Droid gets automatically:**
  * Open files and selected lines
  * VSCode error highlighting and diagnostics
  * Project structure and active terminal output
  * Your cursor position and recent edits

**Without the plugin:**
Copy
Ask AI
```
"Fix 'Property user does not exist on type AuthContext' error in auth.ts"

```

**With the plugin:**
Copy
Ask AI
```
"Fix error"

```

The plugin eliminates entire categories of back-and-forth. Droid knows the context, sees the errors that you see, and understands your intent from minimal input.
**Quick setup:** Install the Factory extension from VSCode marketplace.
##
[​](https://docs.factory.ai/cli/user-guides/become-a-power-user#spec-mode-%E2%80%94-explore-and-plan-first%2C-code-second)
Spec Mode — Explore and plan first, code second
Complex features need exploration before implementation. Spec Mode prevents costly false starts by letting Droid investigate your codebase thoroughly before writing a single line of code.
1
Activate Spec Mode
Press **Shift+Tab** when starting complex work
2
Describe your goal
Write 1-2 sentences about what you want or provide fully-featured existing technical specs.
3
Droid explores
Searches relevant files, understands patterns, identifies dependencies
4
Review the plan
Get a detailed specification with implementation steps before any changes
5
Approve and execute
Only after you approve does Droid start making changes
**Perfect for:**
  * Features touching 2+ files
  * Architectural changes
  * Unfamiliar codebases
  * Security-sensitive work

Without Spec Mode, Droid might jump into implementation too early and not do the work in the exact way you would like. With it, you get a detailed specification and a chance to correct the path before too many tokens are wasted.
Spec Mode isn’t just for features—use it for complex debugging, refactoring, or any task where understanding comes before doing.
##
[​](https://docs.factory.ai/cli/user-guides/become-a-power-user#agents-md-%E2%80%94-your-preferences%2C-remembered)
AGENTS.md — Your preferences, remembered
AGENTS.md captures your coding standards, project conventions, and personal preferences in one place. Droid reads it automatically for every task. **What to document:** Category| Examples
---|---
**Code style**|  ”Use arrow functions, not function declarations” “Prefer early returns over nested conditionals”
**Testing**|  ”Every new endpoint needs integration tests” “Use factories, not fixtures for test data”
**Architecture**|  ”Services go in src/services with matching interfaces” “All database queries use the repository pattern”
**Tooling**|  ”Run `npm run verify` before marking any task complete” “Deploy with `scripts/deploy.sh`, never manual commands”
**Mistakes to avoid**|  ”Never commit .env files” “Don’t use any! type annotations”
**Start simple, evolve over time:** Create `AGENTS.md` in your project root:
Copy
Ask AI
```
# Project Guidelines
## Testing
- Run `npm test` before completing any feature
- New features need unit tests
- API changes need integration tests
## Code Style
- Use TypeScript strict mode
- Prefer composition over inheritance
- Keep functions under 20 lines
## Common Commands
- Lint: `npm run lint:fix`
- Test: `npm test`
- Build: `npm run build`

```

Every time Droid repeats a mistake or you explain something twice, add it to AGENTS.md. Within weeks, you’ll have a personalized assistant that knows exactly how you work.
**Pro tip:** Include examples of good code from your project. “Follow the pattern in src/services/UserService.ts” gives Droid a concrete template.
##
[​](https://docs.factory.ai/cli/user-guides/become-a-power-user#agent-readiness-%E2%80%94-let-your-tools-do-the-teaching)
Agent Readiness — Let your tools do the teaching
Make your project self-correcting. When Droid can run the same verification tools as your CI/CD pipeline, it fixes problems immediately instead of waiting for you to point them out.
## Linters
ESLint, Pylint catch style issues instantly
## Type Checkers
TypeScript, mypy prevent type errors before runtime
## Fast Tests
Unit tests that run in seconds provide immediate feedback
## Pre-commit Hooks
Husky, pre-commit ensure consistency before commits
**Critical:** Keep verification fast. Slow tests will make the end-to-end work slower.
##
[​](https://docs.factory.ai/cli/user-guides/become-a-power-user#combining-all-four-for-maximum-impact)
Combining all four for maximum impact
These features compound. IDE plugin provides context → Spec Mode uses that context for better planning → AGENTS.md ensures consistent implementation → Agent readiness catches issues immediately.
**Getting started?** Install the IDE plugin first—it’s the fastest path to better results. Then add AGENTS.md with just your test commands. Build from there.
[Common Use Cases](https://docs.factory.ai/cli/getting-started/common-use-cases)[Specification Mode](https://docs.factory.ai/cli/user-guides/specification-mode)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
