# https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/github-cloud

[Skip to main content](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/github-cloud#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Integrating With Your Engineering System
GitHub Cloud
[Welcome](https://docs.factory.ai/welcome)[CLI](https://docs.factory.ai/cli/getting-started/overview)[Web Platform](https://docs.factory.ai/web/getting-started/overview)[Onboarding](https://docs.factory.ai/onboarding)[Pricing](https://docs.factory.ai/pricing)[Changelog](https://docs.factory.ai/changelog/1-8)
  * [GitHub](https://github.com/factory-ai/factory)
  * [Discord](https://discord.gg/EQ2DQM2F)


##### Onboarding
  * [Welcome to Factory Onboarding - Enterprise](https://docs.factory.ai/onboarding)
  * Creating Your Factory
  * Integrating With Your Engineering System
    * [GitHub Cloud](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/github-cloud)
    * [GitHub Enterprise Server](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/github-enterprise-server)
    * [GitLab Cloud Integration](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/gitlab-cloud)
    * [GitLab Self-Hosted](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/gitlab-self-hosted)
    * [Jira](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/jira)
    * [Linear](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/linear)
    * [Google Drive](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/googledrive)
    * [Notion](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/notion)
    * [Sentry](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/sentry)
    * [PagerDuty](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/pagerduty)
    * [Slack](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/slack)
  * Configuring Your Review Droid


On this page
  * [Prerequisites](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/github-cloud#prerequisites)
  * [Integration Steps](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/github-cloud#integration-steps)
  * [Verification](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/github-cloud#verification)
  * [Best Practices](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/github-cloud#best-practices)
  * [Troubleshooting](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/github-cloud#troubleshooting)


Integrating With Your Engineering System
# GitHub Cloud
Copy page
Step-by-step guide to connect Factory with your GitHub Cloud repositories
Copy page
This guide will walk you through the process of integrating Factory with GitHub Cloud, enabling the Factory platform to access and work with your repositories.
##
[​](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/github-cloud#prerequisites)
Prerequisites
  * A Factory account with admin privileges
  * Admin access to your GitHub organization


##
[​](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/github-cloud#integration-steps)
Integration Steps
1
Access Factory Platform
Log in to your Factory account and navigate to the Integrations section in your Settings.
2
Initiate GitHub Integration
Click on “Connect” next to Github to start the integration process. Select Manage Github Permissions.
3
Authorize Factory's GitHub App
You’ll be redirected to GitHub. Click “Authorize” to allow Factory’s secure OAuth2 GitHub Application access to your organization.
4
Configure Repository Access
Select the repositories you want Factory to access. You can choose specific repositories or grant access to all current and future repositories.
5
Set Up Permissions
Factory requires specific permissions to function optimally. Review and approve the following permissions:
  * **Actions and Metadata** (Read Access): Allows Factory to access GitHub Actions data for understanding CI processes and diagnosing test failures.
  * **Code** (Read and Write Access): Necessary for Factory to review code and create pull requests. Note that Factory cannot merge code autonomously.
  * **Commit Statuses** (Read and Write Access): Enables Factory to track and update commit statuses.
  * **Discussions** (Read and Write Access): Allows Factory to analyze and participate in repository discussions.
  * **Issues** (Read and Write Access): Enables Factory to interact with issues for automated ticket handling.
  * **Pull Requests** (Read and Write Access): Necessary for Factory to analyze and facilitate code reviews.
  * **Workflows** (Read and Write Access): Allows Factory to manage and potentially correct failed CI runs.


6
Confirm Integration
After granting permissions, you’ll be redirected back to Factory. Confirm that the integration status shows as “Connected”.
##
[​](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/github-cloud#verification)
Verification
To ensure the integration is working correctly:
  1. Create a test repository or use an existing one with minimal sensitive data.
  2. Initiate a simple workflow, such as creating a pull request.
  3. Verify that Factory can access and interact with the repository as expected.


##
[​](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/github-cloud#best-practices)
Best Practices
  * Regularly review and audit the permissions granted to Factory.
  * Use repository-specific settings to fine-tune access levels for sensitive projects.
  * Keep your GitHub organization’s security settings up-to-date.


##
[​](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/github-cloud#troubleshooting)
Troubleshooting
If you encounter issues during integration:
  * Ensure you have the necessary admin rights on both Factory and GitHub.
  * Check GitHub’s audit logs for any permission-related issues.
  * Verify that your organization doesn’t have conflicting third-party application restrictions.

For persistent problems, contact Factory support with specific error messages or screenshots. ## [Security and ComplianceLearn about Factory’s security measures and how we protect your data](https://docs.factory.ai/user-guides/build-with-factory/security-compliance)
[Overview of Factory Integrations](https://docs.factory.ai/onboarding/creating-your-factory/basic-integrations)[GitHub Enterprise Server](https://docs.factory.ai/onboarding/integrating-with-your-engineering-system/github-enterprise-server)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
