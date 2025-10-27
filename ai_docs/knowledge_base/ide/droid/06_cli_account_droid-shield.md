# https://docs.factory.ai/cli/account/droid-shield

[Skip to main content](https://docs.factory.ai/cli/account/droid-shield#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Account
Droid Shield
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
  * [What is Droid Shield?](https://docs.factory.ai/cli/account/droid-shield#what-is-droid-shield%3F)
  * [How Droid Shield Works](https://docs.factory.ai/cli/account/droid-shield#how-droid-shield-works)
  * [What Droid Shield Detects](https://docs.factory.ai/cli/account/droid-shield#what-droid-shield-detects)
  * [Detection Algorithm](https://docs.factory.ai/cli/account/droid-shield#detection-algorithm)
  * [When Droid Shield Activates](https://docs.factory.ai/cli/account/droid-shield#when-droid-shield-activates)
  * [Managing Droid Shield Settings](https://docs.factory.ai/cli/account/droid-shield#managing-droid-shield-settings)
  * [In the CLI](https://docs.factory.ai/cli/account/droid-shield#in-the-cli)
  * [What to Do if Secrets are Detected](https://docs.factory.ai/cli/account/droid-shield#what-to-do-if-secrets-are-detected)
  * [Recommended Actions](https://docs.factory.ai/cli/account/droid-shield#recommended-actions)
  * [If You Get a False Positive](https://docs.factory.ai/cli/account/droid-shield#if-you-get-a-false-positive)
  * [Best Practices](https://docs.factory.ai/cli/account/droid-shield#best-practices)
  * [Limitations](https://docs.factory.ai/cli/account/droid-shield#limitations)
  * [Related Resources](https://docs.factory.ai/cli/account/droid-shield#related-resources)
  * [Need Help?](https://docs.factory.ai/cli/account/droid-shield#need-help%3F)


Account
# Droid Shield
Copy page
Automatic secret detection to prevent accidental exposure of credentials in your git commits and pushes.
Copy page
##
[​](https://docs.factory.ai/cli/account/droid-shield#what-is-droid-shield%3F)
What is Droid Shield?
Droid Shield is a built-in security feature that automatically scans un-committed changes for potential secrets before committing and pushing them to remote. It acts as a safety net to prevent accidental exposure of sensitive credentials like API keys, tokens, and passwords in your version control history.
##
[​](https://docs.factory.ai/cli/account/droid-shield#how-droid-shield-works)
How Droid Shield Works
When you use Droid to perform `git commit` or `git push` operations, Droid Shield automatically:
  1. **Scans the diff** - Analyzes only the lines being added (not removed or unchanged)
  2. **Detects secrets** - Uses pattern matching to identify potential credentials
  3. **Blocks execution** - Stops the git operation if secrets are detected
  4. **Reports findings** - Shows exactly where potential secrets were found


Droid Shield only scans git operations performed through Droid. Manual git commands run outside of Droid are not affected.
##
[​](https://docs.factory.ai/cli/account/droid-shield#what-droid-shield-detects)
What Droid Shield Detects
Droid Shield scans for a wide range of credential patterns, including:
## API Keys & Tokens
Factory API keys, GitHub tokens, GitLab tokens, npm tokens, and API keys from (e.g. AWS, Google Cloud, Stripe, SendGrid) and more.
## Authentication Credentials
(e.g. JWT, OAuth, session tokens), and URLs with embedded credentials.
## Private Keys
(e.g. SSH private keys, PGP keys, age secret keys, OpenSSH keys), and other cryptographic key formats.
## Service-Specific Secrets
(e.g. Slack webhooks and tokens, Twilio credentials, Mailchimp keys, Square OAuth secrets, Azure storage keys).
###
[​](https://docs.factory.ai/cli/account/droid-shield#detection-algorithm)
Detection Algorithm
Droid Shield uses smart pattern matching with randomness validation:
  * **Pattern matching** - Identifies credentials by format
  * **Randomness check** - Validates that captured values look like actual secrets
  * **Context awareness** - Considers variable names and assignment patterns to reduce false positives


##
[​](https://docs.factory.ai/cli/account/droid-shield#when-droid-shield-activates)
When Droid Shield Activates
Droid Shield automatically activates during these git operations:
  * **`git commit`**- Scans staged changes before creating the commit
  * **`git push`**- Scans commits that would be pushed to the remote


If secrets are detected, the git operation is blocked to prevent credential exposure. You’ll need to remove the secrets before proceeding.
##
[​](https://docs.factory.ai/cli/account/droid-shield#managing-droid-shield-settings)
Managing Droid Shield Settings
###
[​](https://docs.factory.ai/cli/account/droid-shield#in-the-cli)
In the CLI
You can toggle Droid Shield on or off through the settings menu:
  1. Run `droid`
  2. Enter `/settings`
  3. Toggle **“Droid Shield”** setting
  4. Changes take effect immediately


Droid Shield is **enabled by default** for your protection. We strongly recommend keeping it enabled.
##
[​](https://docs.factory.ai/cli/account/droid-shield#what-to-do-if-secrets-are-detected)
What to Do if Secrets are Detected
When Droid Shield detects potential secrets, you’ll see an error message like:
Copy
Ask AI
```
Droid-Shield has detected potential secrets in 2 location(s) across files:
src/config.ts, .env.example
If you would like to override, you can either:
1. Perform the commit/push yourself manually
2. Disable Droid Shield by running /settings and toggling the "Droid Shield" option

```

###
[​](https://docs.factory.ai/cli/account/droid-shield#recommended-actions)
Recommended Actions
1
Review the findings
Carefully examine the files and lines mentioned to identify what was detected.
2
Remove the secrets
  * Use environment variables instead of hardcoded credentials
  * Move secrets to secure credential stores
  * Add sensitive files to `.gitignore`
  * Use git filter-branch or BFG Repo-Cleaner if secrets were already committed


3
Retry the operation
Once secrets are removed, run the git command again through Droid.
**Never disable Droid Shield just to bypass the check.** Exposed credentials can lead to security breaches, unauthorized access, and compliance violations.
###
[​](https://docs.factory.ai/cli/account/droid-shield#if-you-get-a-false-positive)
If You Get a False Positive
Droid Shield uses conservative patterns to err on the side of caution. If you believe a detection is a false positive:
  1. **Verify it’s not a real secret** - Double-check that the value isn’t sensitive
  2. **Use a manual commit** - Perform the git operation yourself outside of Droid
  3. **Report the pattern** - Contact support@factory.ai if you encounter recurring false positives


##
[​](https://docs.factory.ai/cli/account/droid-shield#best-practices)
Best Practices
Use environment variables
Store all secrets in environment variables or secure credential managers, never hardcode them in source files.
Copy
Ask AI
```
# Good - Using environment variable
const apiKey = process.env.FACTORY_API_KEY;
# Bad - Hardcoded secret
const apiKey = "fk-abc123xyz789...";

```

Keep Droid Shield enabled
Droid Shield provides an essential safety layer. Keep it enabled at all times, especially in team environments.
Review before committing
Even with Droid Shield, manually review your changes before committing to ensure no sensitive data is included.
Educate your team
Make sure all team members understand how Droid Shield works and why it’s important to keep it enabled.
##
[​](https://docs.factory.ai/cli/account/droid-shield#limitations)
Limitations
**Droid Shield is a detection tool, not a guarantee.** While it catches many common secret patterns, it cannot detect:
  * Custom secret formats not in the pattern database
  * Secrets that don’t follow recognizable patterns
  * Obfuscated or encoded credentials
  * Business logic vulnerabilities or code security issues

Always follow security best practices and never rely solely on automated tools for secret protection.
##
[​](https://docs.factory.ai/cli/account/droid-shield#related-resources)
Related Resources
## [Security OverviewLearn about Factory’s comprehensive security features and best practices.](https://docs.factory.ai/cli/account/security)## [SettingsConfigure Droid settings including Droid Shield preferences.](https://docs.factory.ai/cli/configuration/settings)
##
[​](https://docs.factory.ai/cli/account/droid-shield#need-help%3F)
Need Help?
## Security Questions
Email our security team: **security@factory.ai**
## False Positives
Contact **support@factory.ai** to report persistent false positive patterns.
[Security](https://docs.factory.ai/cli/account/security)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
