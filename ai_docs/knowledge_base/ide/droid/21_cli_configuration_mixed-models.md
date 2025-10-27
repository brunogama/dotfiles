# https://docs.factory.ai/cli/configuration/mixed-models

[Skip to main content](https://docs.factory.ai/cli/configuration/mixed-models#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Configuration
Mixed Models
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
  * [What are mixed models?](https://docs.factory.ai/cli/configuration/mixed-models#what-are-mixed-models%3F)
  * [Why use mixed models?](https://docs.factory.ai/cli/configuration/mixed-models#why-use-mixed-models%3F)
  * [How to configure mixed models](https://docs.factory.ai/cli/configuration/mixed-models#how-to-configure-mixed-models)
  * [Accessing the Configuration](https://docs.factory.ai/cli/configuration/mixed-models#accessing-the-configuration)
  * [Configuration Options](https://docs.factory.ai/cli/configuration/mixed-models#configuration-options)
  * [Selecting a Model](https://docs.factory.ai/cli/configuration/mixed-models#selecting-a-model)
  * [Model Compatibility](https://docs.factory.ai/cli/configuration/mixed-models#model-compatibility)
  * [Compatibility Rules](https://docs.factory.ai/cli/configuration/mixed-models#compatibility-rules)
  * [Reasoning Effort Configuration](https://docs.factory.ai/cli/configuration/mixed-models#reasoning-effort-configuration)
  * [Common Configurations](https://docs.factory.ai/cli/configuration/mixed-models#common-configurations)
  * [Anthropic Models](https://docs.factory.ai/cli/configuration/mixed-models#anthropic-models)
  * [OpenAI Models](https://docs.factory.ai/cli/configuration/mixed-models#openai-models)
  * [How It Works](https://docs.factory.ai/cli/configuration/mixed-models#how-it-works)
  * [Checking Your Configuration](https://docs.factory.ai/cli/configuration/mixed-models#checking-your-configuration)
  * [Clearing your mixed models configuration](https://docs.factory.ai/cli/configuration/mixed-models#clearing-your-mixed-models-configuration)
  * [Best Practices](https://docs.factory.ai/cli/configuration/mixed-models#best-practices)
  * [Troubleshooting](https://docs.factory.ai/cli/configuration/mixed-models#troubleshooting)
  * [Related Resources](https://docs.factory.ai/cli/configuration/mixed-models#related-resources)


Configuration
# Mixed Models
Copy page
Use a different AI model for Specification Mode planning than your default model for maximum flexibility and optimization.
Copy page
##
[​](https://docs.factory.ai/cli/configuration/mixed-models#what-are-mixed-models%3F)
What are mixed models?
Mixed models allow you to use a different AI model specifically for Specification Mode planning while keeping a separate default model for regular coding sessions. This gives you the flexibility to optimize both planning and implementation phases independently. For example, you might want to use a more powerful model for comprehensive specification planning, while using a faster model for day-to-day implementation work.
##
[​](https://docs.factory.ai/cli/configuration/mixed-models#why-use-mixed-models%3F)
Why use mixed models?
Different models excel at different tasks. Separating your spec mode model from your default model lets you:
## Optimize for Planning
Use a more thorough, analytical model for specification planning that considers edge cases and architectural decisions.
## Balance Speed & Cost
Keep a faster, more economical model for regular coding while reserving powerful models for critical planning phases.
## Match Task Complexity
Complex features benefit from advanced reasoning during planning, while simpler tasks can use standard models.
## Flexible Workflows
Switch between different model combinations to find what works best for your specific use cases.
##
[​](https://docs.factory.ai/cli/configuration/mixed-models#how-to-configure-mixed-models)
How to configure mixed models
###
[​](https://docs.factory.ai/cli/configuration/mixed-models#accessing-the-configuration)
Accessing the Configuration
  1. Run `droid` to start the CLI
  2. Enter `/model` to open the model selector
  3. Navigate to **“Configure Spec Mode Model”** (first option in the list)
  4. Press **Enter** to begin configuration


###
[​](https://docs.factory.ai/cli/configuration/mixed-models#configuration-options)
Configuration Options
When you open the configurator, you’ll see three options:
  * **Yes, configure spec mode model** - Select a different model for Specification Mode
  * **No, keep using [current configuration/main model]** - Exit without making changes
  * **Clear spec mode model (use main model)** - Remove the spec mode model and use your default model for everything _(only shown if you already have a spec mode model configured)_


###
[​](https://docs.factory.ai/cli/configuration/mixed-models#selecting-a-model)
Selecting a Model
  1. Choose **“Yes, configure spec mode model”**
  2. Browse the list of available models
  3. Select your preferred model for Specification Mode
  4. If the model supports reasoning, choose your reasoning effort level
  5. The configuration is saved automatically


Only compatible models will be available in the selector based on your current default model. See [Model Compatibility](https://docs.factory.ai/cli/configuration/mixed-models#model-compatibility) below.
##
[​](https://docs.factory.ai/cli/configuration/mixed-models#model-compatibility)
Model Compatibility
Not all model combinations work together due to how different AI providers handle reasoning traces and context. Here are the compatibility rules:
###
[​](https://docs.factory.ai/cli/configuration/mixed-models#compatibility-rules)
Compatibility Rules
OpenAI Models
**OpenAI models can only pair with other OpenAI models**
  * Main model: GPT-5 → Spec model: GPT-5-Codex ✅
  * Main model: GPT-5 → Spec model: Sonnet 4.5 ❌

OpenAI’s internal reasoning format is encrypted and is incompatible with other model providers.
Anthropic Models with Reasoning
**Anthropic models with reasoning enabled can only pair with other Anthropic models**
  * Main model: Sonnet 4.5 (reasoning on) → Spec model: Sonnet 4.5 ✅
  * Main model: Sonnet 4.5 (reasoning on) → Spec model: GPT-5 ❌

When extended thinking is active, reasoning traces must stay within the same provider.
Anthropic Models without Reasoning
**Anthropic models with reasoning off can pair with non-OpenAI models**
  * Main model: Sonnet 4.5 (reasoning off) → Spec model: Any non-OpenAI model ✅
  * Main model: Sonnet 4.5 (reasoning off) → Spec model: DeepSeek ✅

Without reasoning enabled, cross-provider compatibility is possible.
**Why these restrictions?** Model providers encrypt their reasoning traces differently. When reasoning is active, the spec model must be able to read and continue the reasoning chain from the main model, which requires matching providers.
##
[​](https://docs.factory.ai/cli/configuration/mixed-models#reasoning-effort-configuration)
Reasoning Effort Configuration
If you select an Anthropic model that supports reasoning (like Sonnet 4.5), you’ll be prompted to choose a reasoning effort level:
  * **Off** - No extended thinking, faster responses
  * **Low** - Brief consideration, balanced speed and depth
  * **Medium** - Moderate thinking time for complex decisions
  * **High** - Deep analysis for critical architectural choices

The reasoning effort for your spec mode model is independent of your default model’s reasoning setting, giving you complete control over each phase.
For specification planning, **Medium** or **High** reasoning effort often produces better results since thorough analysis during planning prevents issues during implementation.
##
[​](https://docs.factory.ai/cli/configuration/mixed-models#common-configurations)
Common Configurations
Here are some effective model combinations for different scenarios:
###
[​](https://docs.factory.ai/cli/configuration/mixed-models#anthropic-models)
Anthropic Models
**Best for:** Most development workflows, flexible reasoning control
  * **Default model:** Haiku 4.5 or Sonnet 4.5 (select reasoning of your choice if supported)
  * **Spec mode model:** Sonnet 4.5 (reasoning: high)
  * **Benefits:** Fast implementation with deep planning analysis


###
[​](https://docs.factory.ai/cli/configuration/mixed-models#openai-models)
OpenAI Models
**Best for:** Teams using OpenAI models exclusively, cost-conscious projects
  * **Default model:** GPT-5-Codex
  * **Spec mode model:** GPT-5 (high reasoning)
  * **Benefits:** Consistent reasoning format, specialized coding model for specs


##
[​](https://docs.factory.ai/cli/configuration/mixed-models#how-it-works)
How It Works
Once configured, Droid automatically uses your spec mode model whenever you enter Specification Mode:
  1. **Activate Specification Mode** with **Shift+Tab**
  2. **Provide your feature description**
  3. **Droid uses your spec mode model** to analyze, plan, and generate the specification
  4. **Review and approve** the generated spec
  5. **Implementation uses your default model** to write the actual code


Your default model is always used for regular coding sessions and implementation work. The spec mode model is only active during the planning phase of Specification Mode.
##
[​](https://docs.factory.ai/cli/configuration/mixed-models#checking-your-configuration)
Checking Your Configuration
To see which models you’re currently using:
  1. Enter `/model` in the CLI
  2. Your current default model is highlighted
  3. If you have a spec mode model configured, it’s displayed at the top of the selector


##
[​](https://docs.factory.ai/cli/configuration/mixed-models#clearing-your-mixed-models-configuration)
Clearing your mixed models configuration
If you want to go back to using a single model for everything:
  1. Enter `/model` in the CLI
  2. Navigate to **“Configure Spec Mode Model”**
  3. Press **Enter**
  4. Select **“Clear spec mode model (use main model)”**
  5. Confirm by pressing **Enter**

Your default model will now be used for both regular coding and Specification Mode.
##
[​](https://docs.factory.ai/cli/configuration/mixed-models#best-practices)
Best Practices
Start with the same model
If you’re new to Specification Mode, start by using your default model for both modes. Once you’re comfortable, experiment with different spec mode models to see if it improves your planning quality.
Consider your project complexity
Simple projects may not need separate models. For complex systems with intricate dependencies, using a more powerful spec mode model can prevent costly mistakes during implementation.
Match reasoning to task importance
Use higher reasoning effort for architectural decisions and lower effort for routine feature additions. Adjust both your default and spec mode reasoning independently.
Respect compatibility rules
Don’t try to force incompatible model combinations. The restrictions exist for good technical reasons and violations will be prevented by the CLI.
Monitor your usage
More powerful models and higher reasoning efforts increase cost. Balance quality needs with budget constraints by using premium configurations selectively.
##
[​](https://docs.factory.ai/cli/configuration/mixed-models#troubleshooting)
Troubleshooting
Can't select the model I want
**Cause:** The model is incompatible with your current default model.**Solution:** Check the [Model Compatibility](https://docs.factory.ai/cli/configuration/mixed-models#model-compatibility) rules above. You may need to change your default model first, or adjust reasoning settings to enable compatibility.
Spec mode model was automatically cleared
**Cause:** You changed your default model to one that’s incompatible with your configured spec mode model.**Solution:** This is expected behavior. Configure a new spec mode model that’s compatible with your new default model, or continue using the default model for both modes.
Reasoning effort selector doesn't appear
**Cause:** The selected model doesn’t support reasoning, or you’re using a non-Anthropic model combination.**Solution:** This is normal. Not all models support reasoning configuration. The model will use its default behavior.
##
[​](https://docs.factory.ai/cli/configuration/mixed-models#related-resources)
Related Resources
## [Specification ModeLearn how to use Specification Mode for planning and implementing features.](https://docs.factory.ai/cli/user-guides/specification-mode)## [SettingsConfigure other aspects of how Droid behaves and integrates with your workflow.](https://docs.factory.ai/cli/configuration/settings)## [Choosing Your ModelUnderstand the differences between available models and how to choose the right one.](https://docs.factory.ai/cli/user-guides/choosing-your-model)## [BYOKBring your own API keys to use custom models with Factory.](https://docs.factory.ai/cli/byok/overview)
[Settings](https://docs.factory.ai/cli/configuration/settings)[Model Context Protocol](https://docs.factory.ai/cli/configuration/mcp)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
