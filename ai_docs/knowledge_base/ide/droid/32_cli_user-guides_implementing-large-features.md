# https://docs.factory.ai/cli/user-guides/implementing-large-features

[Skip to main content](https://docs.factory.ai/cli/user-guides/implementing-large-features#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
User Guides
Implementing Large Features
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
  * [When to use this workflow](https://docs.factory.ai/cli/user-guides/implementing-large-features#when-to-use-this-workflow)
  * [The workflow](https://docs.factory.ai/cli/user-guides/implementing-large-features#the-workflow)
  * [Phase 1: Master planning with Specification Mode](https://docs.factory.ai/cli/user-guides/implementing-large-features#phase-1%3A-master-planning-with-specification-mode)
  * [Phase 2: Iterative implementation](https://docs.factory.ai/cli/user-guides/implementing-large-features#phase-2%3A-iterative-implementation)
  * [Start a fresh session](https://docs.factory.ai/cli/user-guides/implementing-large-features#start-a-fresh-session)
  * [Reference the master plan](https://docs.factory.ai/cli/user-guides/implementing-large-features#reference-the-master-plan)
  * [Use Specification Mode for complex phases](https://docs.factory.ai/cli/user-guides/implementing-large-features#use-specification-mode-for-complex-phases)
  * [Commit frequently](https://docs.factory.ai/cli/user-guides/implementing-large-features#commit-frequently)
  * [Create phase-specific PRs](https://docs.factory.ai/cli/user-guides/implementing-large-features#create-phase-specific-prs)
  * [Phase 3: Validation and testing strategy](https://docs.factory.ai/cli/user-guides/implementing-large-features#phase-3%3A-validation-and-testing-strategy)
  * [Test each phase independently](https://docs.factory.ai/cli/user-guides/implementing-large-features#test-each-phase-independently)
  * [Use feature flags for gradual rollout](https://docs.factory.ai/cli/user-guides/implementing-large-features#use-feature-flags-for-gradual-rollout)
  * [Automated testing at phase boundaries](https://docs.factory.ai/cli/user-guides/implementing-large-features#automated-testing-at-phase-boundaries)
  * [Best practices](https://docs.factory.ai/cli/user-guides/implementing-large-features#best-practices)
  * [Recovery strategies](https://docs.factory.ai/cli/user-guides/implementing-large-features#recovery-strategies)


User Guides
# Implementing Large Features
Copy page
A systematic approach to tackling complex, multi-phase development projects using specification planning and iterative implementation.
Copy page
Large-scale features require careful planning and systematic execution to avoid overwhelming complexity. This guide outlines a proven workflow for breaking down massive projects into manageable phases, using specification mode for planning and iterative implementation with frequent validation.
## Systematic Planning
Break complex features into discrete, manageable phases with clear boundaries
## Incremental Progress
Implement one phase at a time with validation and testing at each step
## Version Control Strategy
Use git commits and PRs to track progress and enable safe rollbacks
## Continuous Validation
Test functionality incrementally rather than waiting until the end
##
[​](https://docs.factory.ai/cli/user-guides/implementing-large-features#when-to-use-this-workflow)
When to use this workflow
This approach is ideal for: **Massive refactors** - Touching 100+ files across your entire codebase
Copy
Ask AI
```
"Migrate from REST API to GraphQL across all frontend components"

```

**Major component migrations** - Replacing core system dependencies
Copy
Ask AI
```
"Switch from Stripe to a new billing provider across the entire payment system"

```

**Large feature implementations** - New functionality spanning 30+ files
Copy
Ask AI
```
"Add comprehensive user roles and permissions system to the existing application"

```

##
[​](https://docs.factory.ai/cli/user-guides/implementing-large-features#the-workflow)
The workflow
1
Create the master plan
Use Specification Mode to create comprehensive documentation breaking the project into major phases.
2
Phase-by-phase implementation
Start new sessions for each phase, referencing the master plan document.
3
Frequent commits and PRs
Create git commits and pull requests corresponding to each completed phase.
4
Incremental validation
Test and validate functionality after each phase rather than at the end.
5
Update the plan
Mark completed phases and adjust remaining work based on learnings.
##
[​](https://docs.factory.ai/cli/user-guides/implementing-large-features#phase-1%3A-master-planning-with-specification-mode)
Phase 1: Master planning with Specification Mode
Start by using **Shift+Tab** to enter Specification Mode and create a comprehensive breakdown: **Example prompt:**
Copy
Ask AI
```
Create a detailed implementation plan for migrating our entire authentication system
from Firebase Auth to Auth0. This affects user login, registration, session management,
role-based access control, and integrations across 50+ components.
Break this into major phases that can be implemented independently with clear
testing and validation points. Each phase should be completable in 1-2 days
and have minimal dependencies on other phases.

```

**Specification Mode will generate:**
  * **Phase breakdown** - 4-6 major implementation phases
  * **Dependencies mapping** - Which phases must be completed before others
  * **Testing strategy** - How to validate each phase works correctly
  * **Risk assessment** - Potential issues and mitigation strategies
  * **Rollback plan** - How to safely revert if needed

**Save the plan** - Approve the specification and save it as `IMPLEMENTATION_PLAN.md` in your project root.
##
[​](https://docs.factory.ai/cli/user-guides/implementing-large-features#phase-2%3A-iterative-implementation)
Phase 2: Iterative implementation
For each phase in your plan:
###
[​](https://docs.factory.ai/cli/user-guides/implementing-large-features#start-a-fresh-session)
Start a fresh session
Begin each phase with a new droid session to maintain focus and clean context.
###
[​](https://docs.factory.ai/cli/user-guides/implementing-large-features#reference-the-master-plan)
Reference the master plan
**Example prompt for Phase 1:**
Copy
Ask AI
```
I'm implementing Phase 1 of the authentication migration plan documented in
IMPLEMENTATION_PLAN.md.
Phase 1 focuses on setting up Auth0 configuration and creating the basic
authentication service without affecting existing Firebase integration.
Please read the plan document and implement this phase, then update the
document to mark Phase 1 as complete.

```

###
[​](https://docs.factory.ai/cli/user-guides/implementing-large-features#use-specification-mode-for-complex-phases)
Use Specification Mode for complex phases
For phases involving significant changes, use **Shift+Tab** to get detailed planning:
Copy
Ask AI
```
Following IMPLEMENTATION_PLAN.md, implement Phase 3: Update all login components
to use the new Auth0 service while maintaining backward compatibility with
the existing Firebase auth as fallback.

```

###
[​](https://docs.factory.ai/cli/user-guides/implementing-large-features#commit-frequently)
Commit frequently
After each phase completion, ask Droid to commit your changes:
Copy
Ask AI
```
Commit all changes for Phase 1 of the auth migration with a detailed message.

```

Copy
Ask AI
```
Create a commit for the Auth0 service setup work with bullet points for each major change.

```

Droid will stage all changes and create the commit with proper co-authorship attribution.
###
[​](https://docs.factory.ai/cli/user-guides/implementing-large-features#create-phase-specific-prs)
Create phase-specific PRs
Ask Droid to create pull requests for each completed phase:
Copy
Ask AI
```
Create a PR for the auth migration Phase 1 work on a new branch called auth-migration-phase-1.

```

Copy
Ask AI
```
Open a pull request with a comprehensive description of what was completed and testing done.

```

Droid will create the branch, push the changes, and generate a detailed PR description based on the commits and changes made.
##
[​](https://docs.factory.ai/cli/user-guides/implementing-large-features#phase-3%3A-validation-and-testing-strategy)
Phase 3: Validation and testing strategy
###
[​](https://docs.factory.ai/cli/user-guides/implementing-large-features#test-each-phase-independently)
Test each phase independently
Don’t wait until the end - validate functionality after each phase: **Phase 1 completion:**
Copy
Ask AI
```
Run the authentication tests and verify the Auth0 service works in isolation.
Test user registration, login, and logout with the new service.

```

**Phase 2 completion:**
Copy
Ask AI
```
Test the migration script with a subset of test users. Verify data integrity
and that users can log in with both old and new systems.

```

###
[​](https://docs.factory.ai/cli/user-guides/implementing-large-features#use-feature-flags-for-gradual-rollout)
Use feature flags for gradual rollout
Copy
Ask AI
```
Add a feature flag for auth0-migration with 10% rollout that can be controlled by environment variable.

```

Copy
Ask AI
```
Implement progressive rollout logic using feature flags to gradually migrate users from Firebase to Auth0.

```

###
[​](https://docs.factory.ai/cli/user-guides/implementing-large-features#automated-testing-at-phase-boundaries)
Automated testing at phase boundaries
Copy
Ask AI
```
Run the full test suite after each phase including unit, integration, and e2e tests.

```

Copy
Ask AI
```
Set up automated testing that validates auth migration functionality at each phase boundary.

```

##
[​](https://docs.factory.ai/cli/user-guides/implementing-large-features#best-practices)
Best practices
**Start with read-only changes** - Begin phases with analysis and preparation before making modifications. **Maintain backward compatibility** - Keep old systems working while new ones are being built. **Use feature toggles** - Allow gradual rollout and quick rollback if needed. **Document learnings** - Update your plan based on discoveries during implementation. **Test boundary conditions** - Focus testing on the interfaces between old and new systems. **Plan for rollback** - Each phase should be reversible if critical issues are discovered. **Communicate progress** - Keep stakeholders updated with regular progress reports.
##
[​](https://docs.factory.ai/cli/user-guides/implementing-large-features#recovery-strategies)
Recovery strategies
If a phase encounters major issues:
  1. **Immediate rollback** - Use git to revert to the last stable state
  2. **Issue analysis** - Document what went wrong and why
  3. **Plan adjustment** - Update remaining phases based on learnings
  4. **Stakeholder communication** - Update timelines and expectations

The systematic approach ensures large features are delivered reliably while maintaining code quality and system stability throughout the process. Ready to tackle your next large-scale feature? Start with **Shift+Tab** to create your master implementation plan!
[Choosing Your Model](https://docs.factory.ai/cli/user-guides/choosing-your-model)[CLI Reference](https://docs.factory.ai/cli/configuration/cli-reference)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
