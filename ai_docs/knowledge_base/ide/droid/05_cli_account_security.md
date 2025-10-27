# https://docs.factory.ai/cli/account/security

[Skip to main content](https://docs.factory.ai/cli/account/security#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Account
Security
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
  * [Security-First Design](https://docs.factory.ai/cli/account/security#security-first-design)
  * [Key Security Features](https://docs.factory.ai/cli/account/security#key-security-features)
  * [Security Best Practices](https://docs.factory.ai/cli/account/security#security-best-practices)
  * [Essential Security Guidelines](https://docs.factory.ai/cli/account/security#essential-security-guidelines)
  * [Built-in Protections](https://docs.factory.ai/cli/account/security#built-in-protections)
  * [Enterprise Security](https://docs.factory.ai/cli/account/security#enterprise-security)
  * [Need Help?](https://docs.factory.ai/cli/account/security#need-help%3F)


Account
# Security
Copy page
How Factory CLI keeps your code and data secure with built-in protections and best practices.
Copy page
##
[​](https://docs.factory.ai/cli/account/security#security-first-design)
Security-First Design
Factory CLI (Droid) is built with security at its core. Your code stays secure through encrypted authentication, strict permissions, and enterprise-grade protections.
##
[​](https://docs.factory.ai/cli/account/security#key-security-features)
Key Security Features
## Secure Authentication
OAuth login with encrypted token storage. Tokens auto-rotate every 30 days and are stored with OS-level file permissions.
## Permission Controls
All risky operations require explicit approval. Configure tool permissions from allow/ask/reject per your security needs.
## Data Encryption
All data encrypted in transit (TLS 1.3) and at rest (AES-256 with AWS KMS). Factory never trains on your code.
## Local Execution
Shell commands and file edits run locally. Only necessary context and diffs are sent to Factory’s secure cloud.
##
[​](https://docs.factory.ai/cli/account/security#security-best-practices)
Security Best Practices
Always review suggested code and commands before approval. You control what Droid can access and execute.
###
[​](https://docs.factory.ai/cli/account/security#essential-security-guidelines)
Essential Security Guidelines
Review before approving
**Always verify proposed commands and file changes** , especially:
  * Commands that install packages or modify system files
  * Operations involving sensitive data or credentials
  * Network requests to external services
  * File operations outside your project directory


Use isolated environments
**Run Droid in containers or VMs** when working with:
  * Untrusted code repositories
  * External APIs or web services
  * Experimental or potentially risky operations
  * Shared development environments


Manage permissions carefully
**Configure tool permissions** to match your security requirements:
  * Set high-risk commands to “reject” by default
  * Use “ask” for medium-risk operations requiring oversight
  * Only “allow” low-risk commands you trust completely
  * Review permissions regularly with the Settings menu


Protect sensitive data
**Never include secrets in prompts:**
  * Use environment variables for API keys and tokens
  * Store credentials in secure credential managers
  * Exclude sensitive files from Droid’s working directory
  * Use the FACTORY_TOKEN environment variable for CI/CD


##
[​](https://docs.factory.ai/cli/account/security#built-in-protections)
Built-in Protections
Factory CLI includes multiple layers of security:
  * **Write access restriction** : Can only modify files in the project directory and subdirectories
  * **Command approval** : Risky operations require explicit user confirmation
  * **Prompt injection detection** : Analyzes requests for potentially harmful instructions
  * **Network request controls** : Web-fetching tools require approval by default
  * **Input sanitization** : Prevents command injection attacks
  * **Session isolation** : Each conversation maintains separate, secure context


##
[​](https://docs.factory.ai/cli/account/security#enterprise-security)
Enterprise Security
## SSO & Identity
SAML 2.0 / OIDC single sign-on with SCIM provisioning and role-based access controls.
## Data Governance
Zero data retention mode, customer-managed encryption keys (BYOK), and private cloud deployments.
## Compliance
SOC 2 Type II certified, GDPR compliant, with regular penetration testing and supply chain security.
## Audit & Monitoring
Complete session logging, OpenTelemetry metrics, and enterprise-managed security policies.
##
[​](https://docs.factory.ai/cli/account/security#need-help%3F)
Need Help?
## Security Questions
Email our security team: **security@factory.ai**
## Trust Center
Visit **[trust.factory.ai](https://trust.factory.ai)** for compliance documents, certifications, and security resources.
Report security vulnerabilities through our responsible disclosure program. Contact security@factory.ai for details.
[Automated Lint Fixes](https://docs.factory.ai/cli/droid-exec/cookbook/refactor-fix-lint)[Droid Shield](https://docs.factory.ai/cli/account/droid-shield)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
