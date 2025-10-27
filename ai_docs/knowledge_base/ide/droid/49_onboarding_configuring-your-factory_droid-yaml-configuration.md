# https://docs.factory.ai/onboarding/configuring-your-factory/droid-yaml-configuration

[Skip to main content](https://docs.factory.ai/onboarding/configuring-your-factory/droid-yaml-configuration#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Configuring Your Droid YAML
[Welcome](https://docs.factory.ai/welcome)[CLI](https://docs.factory.ai/cli/getting-started/overview)[Web Platform](https://docs.factory.ai/web/getting-started/overview)[Onboarding](https://docs.factory.ai/onboarding)[Pricing](https://docs.factory.ai/pricing)[Changelog](https://docs.factory.ai/changelog/1-8)
  * [GitHub](https://github.com/factory-ai/factory)
  * [Discord](https://discord.gg/EQ2DQM2F)


##### Onboarding
  * [Welcome to Factory Onboarding - Enterprise](https://docs.factory.ai/onboarding)
  * Creating Your Factory
  * Integrating With Your Engineering System
  * Configuring Your Review Droid


On this page
  * [Basic Structure](https://docs.factory.ai/onboarding/configuring-your-factory/droid-yaml-configuration#basic-structure)
  * [Review Settings](https://docs.factory.ai/onboarding/configuring-your-factory/droid-yaml-configuration#review-settings)
  * [Guidelines](https://docs.factory.ai/onboarding/configuring-your-factory/droid-yaml-configuration#guidelines)
  * [Auto-Review Settings](https://docs.factory.ai/onboarding/configuring-your-factory/droid-yaml-configuration#auto-review-settings)
  * [Other Review Settings](https://docs.factory.ai/onboarding/configuring-your-factory/droid-yaml-configuration#other-review-settings)
  * [Validation](https://docs.factory.ai/onboarding/configuring-your-factory/droid-yaml-configuration#validation)


# Configuring Your Droid YAML
Copy page
Learn how to customize Droid behavior using the .droid.yaml file
Copy page
The `.droid.yaml` file at the root of your project allows you to customize Droid behavior through a simple YAML configuration. This powerful tool enables you to tailor Factory’s AI-driven assistance to your specific needs.
We are constantly adding new options to configure Droid through the .droid.yaml. Your feedback helps us prioritize which options we make available first.
##
[​](https://docs.factory.ai/onboarding/configuring-your-factory/droid-yaml-configuration#basic-structure)
Basic Structure
Here’s an overview of the `.droid.yaml` structure:
Copy
Ask AI
```
review:
 guidelines:
  # Review guidelines
 auto_review:
  # Auto-review settings
 # Other review settings

```

Let’s dive into each section in detail.
##
[​](https://docs.factory.ai/onboarding/configuring-your-factory/droid-yaml-configuration#review-settings)
Review Settings
The `review` section configures how Droid performs code reviews.
###
[​](https://docs.factory.ai/onboarding/configuring-your-factory/droid-yaml-configuration#guidelines)
Guidelines
Copy
Ask AI
```
review:
 guidelines:
  - path: "**/example"
   guideline: "example guideline"

```

  * `path`: An fnmatch pattern specifying which files the guideline applies to.
  * `guideline`: The specific instruction for Droid to follow during reviews.


###
[​](https://docs.factory.ai/onboarding/configuring-your-factory/droid-yaml-configuration#auto-review-settings)
Auto-Review Settings
Copy
Ask AI
```
review:
 auto_review:
  enabled: true
  draft: false
  bot: false
  ignore_title_keywords:
   - "WIP"
   - "DO NOT MERGE"
  ignore_labels:
   - "droid-skip"
  excluded_base_branches:
   - "example_branch"

```

  * `enabled`: Enable automatic code review on pull request open (default: false).
  * `draft`: Enable automatic code review on draft pull requests (default: false).
  * `bot`: Enable automatic code review on pull requests authored by bots (default: false).
  * `ignore_title_keywords`: Skip review for pull requests with these keywords in the title.
  * `ignore_labels`: Skip review for pull requests with these labels.
  * `excluded_base_branches`: Skip review for pull requests on these base branches.


###
[​](https://docs.factory.ai/onboarding/configuring-your-factory/droid-yaml-configuration#other-review-settings)
Other Review Settings
Copy
Ask AI
```
review:
 pr_summary: true
 file_summaries: true
 tips: true
 github_action_repair: true
 path_filters:
  - "!**/*.log"
 enable_skip_reason_comments: true

```

  * `pr_summary`: Generate a summary of the pull request (default: true).
  * `file_summaries`: Generate summaries of modified files (default: true).
  * `tips`: Include Droid Tips in the review (default: true).
  * `github_action_repair`: Suggest solutions to GitHub Action failures (default: true).
  * `path_filters`: Patterns to include/exclude for review. Use cautiously.
  * `enable_skip_reason_comments`: Add comments explaining why Droid skipped a review.


##
[​](https://docs.factory.ai/onboarding/configuring-your-factory/droid-yaml-configuration#validation)
Validation
If you have access to Review Droid, it will automatically verify your `.droid.yaml` when modified in a pull request. Otherwise, use a YAML validation tool to ensure valid YAML syntax. ## [Review Droid GuidelinesLearn how to set up effective guidelines for Review Droid](https://docs.factory.ai/onboarding/configuring-your-review-droid/review-droid-guidelines)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
