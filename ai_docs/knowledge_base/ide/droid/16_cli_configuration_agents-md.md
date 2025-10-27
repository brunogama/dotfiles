# https://docs.factory.ai/cli/configuration/agents-md

[Skip to main content](https://docs.factory.ai/cli/configuration/agents-md#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Configuration
AGENTS.md
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
  * [1 · What is AGENTS.md?](https://docs.factory.ai/cli/configuration/agents-md#1-%C2%B7-what-is-agents-md%3F)
  * [Why AGENTS.md?](https://docs.factory.ai/cli/configuration/agents-md#why-agents-md%3F)
  * [What it contains:](https://docs.factory.ai/cli/configuration/agents-md#what-it-contains%3A)
  * [2 · One AGENTS.md works across many agents](https://docs.factory.ai/cli/configuration/agents-md#2-%C2%B7-one-agents-md-works-across-many-agents)
  * [3 · File locations & discovery hierarchy](https://docs.factory.ai/cli/configuration/agents-md#3-%C2%B7-file-locations-%26-discovery-hierarchy)
  * [4 · File structure & syntax](https://docs.factory.ai/cli/configuration/agents-md#4-%C2%B7-file-structure-%26-syntax)
  * [5 · Common sections](https://docs.factory.ai/cli/configuration/agents-md#5-%C2%B7-common-sections)
  * [6 · Templates & examples](https://docs.factory.ai/cli/configuration/agents-md#6-%C2%B7-templates-%26-examples)
  * [Factory-style comprehensive example](https://docs.factory.ai/cli/configuration/agents-md#factory-style-comprehensive-example)
  * [Node + React monorepo](https://docs.factory.ai/cli/configuration/agents-md#node-%2B-react-monorepo)
  * [Python microservice](https://docs.factory.ai/cli/configuration/agents-md#python-microservice)
  * [7 · Best practices](https://docs.factory.ai/cli/configuration/agents-md#7-%C2%B7-best-practices)
  * [8 · How agents use AGENTS.md](https://docs.factory.ai/cli/configuration/agents-md#8-%C2%B7-how-agents-use-agents-md)
  * [9 · When things go wrong](https://docs.factory.ai/cli/configuration/agents-md#9-%C2%B7-when-things-go-wrong)
  * [Warning signs of agent drift:](https://docs.factory.ai/cli/configuration/agents-md#warning-signs-of-agent-drift%3A)
  * [Recovery playbook:](https://docs.factory.ai/cli/configuration/agents-md#recovery-playbook%3A)
  * [10 · Getting started](https://docs.factory.ai/cli/configuration/agents-md#10-%C2%B7-getting-started)
  * [Summary](https://docs.factory.ai/cli/configuration/agents-md#summary)


Configuration
# AGENTS.md
Copy page
Teach agents everything they need to know about your project with a single Markdown file.
Copy page
##
[​](https://docs.factory.ai/cli/configuration/agents-md#1-%C2%B7-what-is-agents-md%3F)
1 · What is **AGENTS.md**?
**AGENTS.md** is a Markdown file that lives in your repository (or home directory) and acts as a _briefing packet_ for AI coding agents.
###
[​](https://docs.factory.ai/cli/configuration/agents-md#why-agents-md%3F)
Why AGENTS.md?
**README.md** files are for humans: quick starts, project descriptions, and contribution guidelines. **AGENTS.md** complements this by containing the extra, sometimes detailed context coding agents need: build steps, tests, and conventions that might clutter a README or aren’t relevant to human contributors. We intentionally kept it separate to:
  * Give agents a clear, predictable place for instructions
  * Keep READMEs concise and focused on human contributors
  * Provide precise, agent-focused guidance that complements existing README and docs


###
[​](https://docs.factory.ai/cli/configuration/agents-md#what-it-contains%3A)
What it contains:
  * Describes how to **build, test, and run** your project
  * Explains architectural patterns and conventions
  * Lists external services, environment variables, or design docs
  * Provides domain-specific vocabulary and code style rules

Agents read AGENTS.md _before_ planning any change, giving them the same tribal knowledge senior engineers already carry in their heads.
##
[​](https://docs.factory.ai/cli/configuration/agents-md#2-%C2%B7-one-agents-md-works-across-many-agents)
2 · One AGENTS.md works across many agents
Your AGENTS.md file is compatible with a growing ecosystem of AI coding agents and tools, including:
  * **Factory Droid** - Factory’s AI coding agent
  * **Cursor** - AI-powered code editor
  * **Aider** - AI pair programming in your terminal
  * **Gemini CLI** - Google’s command-line AI assistant
  * **Jules** - Google’s coding assistant
  * **Codex** - OpenAI’s code generation model
  * **Zed** - AI-enhanced editor
  * **Phoenix** - AI development platform
  * And many more emerging tools

Rather than introducing another proprietary file format, AGENTS.md uses a standard that works across the entire AI development ecosystem.
##
[​](https://docs.factory.ai/cli/configuration/agents-md#3-%C2%B7-file-locations-%26-discovery-hierarchy)
3 · File locations & discovery hierarchy
Agents look for AGENTS.md in this order (first match wins):
  1. `./AGENTS.md` in the **current working directory**
  2. The nearest parent directory up to the repo root
  3. Any `AGENTS.md` in sub-folders the agent is working inside
  4. Personal override: `~/.factory/AGENTS.md`


Multiple files can coexist. The closer one to the file being edited takes precedence.
##
[​](https://docs.factory.ai/cli/configuration/agents-md#4-%C2%B7-file-structure-%26-syntax)
4 · File structure & syntax
AGENTS.md is plain Markdown; headings provide semantic hints.
Copy
Ask AI
```
# Build & Test ← exact commands for compiling and testing
# Architecture Overview ← short description of major modules
# Security ← auth flows, API keys, sensitive data
# Git Workflows ← branching, commit conventions, PR requirements
# Conventions & Patterns ← naming, folder layout, code style

```

Agents recognize:
  * **Top-level headings** (`#`) as sections
  * **Bullet lists** for commands or rules
  * **Inline code** (```) for exact commands, filenames, env vars
  * **Links** to external docs (GitHub, Figma, Confluence…)


##
[​](https://docs.factory.ai/cli/configuration/agents-md#5-%C2%B7-common-sections)
5 · Common sections
Section| Purpose
---|---
**Build & Test**| Exact commands for compiling and running the test suite.
**Architecture Overview**|  One-paragraph summary of major modules and data flow.
**Security**|  API keys, endpoints, auth flows, rate limits, sensitive data.
**Git Workflows**|  Branching strategy, commit conventions, PR requirements.
**Conventions & Patterns**| Folder structure, naming patterns, code style, lint rules.
Include only what _future you_ will care about—brevity beats encyclopaedia-length files.
##
[​](https://docs.factory.ai/cli/configuration/agents-md#6-%C2%B7-templates-%26-examples)
6 · Templates & examples
###
[​](https://docs.factory.ai/cli/configuration/agents-md#factory-style-comprehensive-example)
Factory-style comprehensive example
Copy
Ask AI
```
# MyProject
This is an overview of My Project. It's an example app used to highlight AGENTS.md files utility.
## Core Commands
• Type-check and lint: `pnpm check`
• Auto-fix style: `pnpm check:fix`
• Run full test suite: `pnpm test --run --no-color`
• Run a single test file: `pnpm test --run <path>.test.ts`
• Start dev servers (frontend + backend): `pnpm dev`
• Build for production: `pnpm build` then `pnpm preview`
All other scripts wrap these six tasks.
## Project Layout
├─ client/ → React + Vite frontend
├─ server/ → Express backend
• Frontend code lives **only** in `client/`
• Backend code lives **only** in `server/`
• Shared, environment-agnostic helpers belong in `src/`
## Development Patterns & Constraints
Coding style
• TypeScript strict mode, single quotes, trailing commas, no semicolons.
• 100-char line limit, tabs for indent (2-space YAML/JSON/MD).
• Use interfaces for public APIs; avoid `@ts-ignore`.
• Tests first when fixing logic bugs.
• Visual diff loop for UI tweaks.
• Never introduce new runtime deps without explanation in PR description.
## Git Workflow Essentials
1. Branch from `main` with a descriptive name: `feature/<slug>` or `bugfix/<slug>`.
2. Run `pnpm check` locally **before** committing.
3. Force pushes **allowed only** on your feature branch using
  `git push --force-with-lease`. Never force-push `main`.
4. Keep commits atomic; prefer checkpoints (`feat: …`, `test: …`).
## Evidence Required for Every PR
A pull request is reviewable when it includes:
- All tests green (`pnpm test`)
- Lint & type check pass (`pnpm check`)
- Diff confined to agreed paths (see section 2)
- **Proof artifact**
 • Bug fix → failing test added first, now passes
 • Feature → new tests or visual snapshot demonstrating behavior
- One-paragraph commit / PR description covering intent & root cause
- No drop in coverage, no unexplained runtime deps

```

###
[​](https://docs.factory.ai/cli/configuration/agents-md#node-%2B-react-monorepo)
Node + React monorepo
Copy
Ask AI
```
# Build & Test
- Build: `npm run build`
- Test: `npm run test -- --runInBand`
# Run Locally
- API: `npm run dev --workspace=api`
- Web: `npm run dev --workspace=web`
- Storybook: `npm run storybook`
# Conventions
- All backend code in `packages/api/src`
- React components in `packages/web/src/components`
- Use `zod` for request validation
# Architecture Overview
The API is GraphQL (Apollo). Web uses Next.js with SSR.
# External Services
- Stripe for payments (`STRIPE_KEY`)
- S3 for uploads (`AWS_BUCKET`)
# Gotchas
- Test snapshot paths are absolute—run `npm run test -- --updateSnapshot` after refactors.

```

###
[​](https://docs.factory.ai/cli/configuration/agents-md#python-microservice)
Python microservice
Copy
Ask AI
```
# Build & Test
- Build: `pip install -e .`
- Test: `pytest`
# Run Locally
- `uvicorn app.main:app --reload`
# Conventions
- Config via Pydantic settings (`settings.py`)
- CELERY tasks live in `tasks/`

```

##
[​](https://docs.factory.ai/cli/configuration/agents-md#7-%C2%B7-best-practices)
7 · Best practices
Keep it short
Aim for **≤ 150 lines**. Long files slow the agent and bury signal.
Use concrete commands
Wrap commands in back-ticks so agents can copy-paste without guessing.
Update alongside code
Treat AGENTS.md like code—PR reviewers should nudge updates when build steps change.
One source of truth
Avoid duplicate docs; link to READMEs or design docs instead of pasting them.
Make requests precise
The more precise your guidance for the task at hand, the more likely the agent is to accomplish that task to your liking.
Verify before merging
Require objective proof: tests, lint, type check, and a diff confined to agreed paths.
##
[​](https://docs.factory.ai/cli/configuration/agents-md#8-%C2%B7-how-agents-use-agents-md)
8 · How agents use AGENTS.md
1
Ingestion
On task start, agents load the nearest AGENTS.md into their context window.
2
Planning
Build/test commands are used to form the execution plan (e.g. run tests after edits).
3
Tool selection
Folder and naming conventions steer tools like `edit_file` and `create_file`.
4
Validation
Gotchas and domain vocabulary improve reasoning and reduce hallucinations.
##
[​](https://docs.factory.ai/cli/configuration/agents-md#9-%C2%B7-when-things-go-wrong)
9 · When things go wrong
Like any development work, agent tasks sometimes need course correction when scope creeps or assumptions prove wrong. The same iteration patterns that work with human collaborators apply here.
###
[​](https://docs.factory.ai/cli/configuration/agents-md#warning-signs-of-agent-drift%3A)
Warning signs of agent drift:
  * Plans that rewrite themselves mid-execution
  * Edits outside the declared paths
  * Fixes claimed without failing tests to prove they work
  * Diffs bloated with unrelated changes


###
[​](https://docs.factory.ai/cli/configuration/agents-md#recovery-playbook%3A)
Recovery playbook:
  1. **Tighten the spec** : Narrow the directory or tests the agent may touch
  2. **Salvage the good** : Keep valid artifacts such as a failing test; revert noisy edits
  3. **Restart clean** : Launch a fresh session with improved instructions
  4. **Take over** : When you can tell the agent is failing, pair program the final changes


##
[​](https://docs.factory.ai/cli/configuration/agents-md#10-%C2%B7-getting-started)
10 · Getting started
## [Specification ModeSpecs + AGENTS.md = instant context for new features.](https://docs.factory.ai/cli/user-guides/specification-mode)## [Auto-RunReliable automation depends on accurate build & test commands.](https://docs.factory.ai/cli/user-guides/auto-run)
###
[​](https://docs.factory.ai/cli/configuration/agents-md#summary)
Summary
  1. Add **AGENTS.md** at your repo root (and optionally submodules).
  2. Document build/test commands, conventions, and gotchas— _concise & actionable_.
  3. Agents read it automatically; no extra flags required.

Pick one modest bug or small feature from your backlog. Write three clear sentences that state where to begin, how to reproduce the issue, and what proof signals completion. Run the agent through Explore → Plan → Code → Verify, review the evidence, and merge. Ship faster with fewer surprises—give your agent the playbook it needs!
[Custom Droids (Subagents)](https://docs.factory.ai/cli/configuration/custom-droids)[Settings](https://docs.factory.ai/cli/configuration/settings)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
