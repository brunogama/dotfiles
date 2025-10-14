---
title: Configuration - Docs - Kiro
source_url: https://kiro.dev/docs/mcp/configuration/
last_fetched: '2025-10-12T21:39:53.964997+00:00'
checksum: sha256:cba7a733f12d11f03e323054d0f9642ab5d6360515ffcfaeb9f3e89690033071
type: official_documentation
fetch_method: crawl4ai
---

<!-- file: configuration---docs---kiro.md -->

[![Kiro](https://kiro.dev/images/kiro-wordmark.png?h=0ad65a93) {PREVIEW} ](https://kiro.dev/)

- [Changelog](https://kiro.dev/changelog/)
- [Pricing](https://kiro.dev/pricing/)
- [Docs](https://kiro.dev/docs/)
- Resources

``` ⌘``K ``` Join Waitlist
[ ![Kiro](https://kiro.dev/images/kiro-wordmark.png?h=0ad65a93) {PREVIEW} ](https://kiro.dev/) ``` ⌘``K ```
Documentation [Get started](https://kiro.dev/docs/getting-started/) [Editor](https://kiro.dev/docs/editor/interface/)
[Specs](https://kiro.dev/docs/specs/) [Chat](https://kiro.dev/docs/chat/) [Hooks](https://kiro.dev/docs/hooks/)
[Steering](https://kiro.dev/docs/steering/) [MCP](https://kiro.dev/docs/mcp/)
[Configuration](https://kiro.dev/docs/mcp/configuration/)[Servers](https://kiro.dev/docs/mcp/servers/)[Tools](https://kiro.dev/docs/mcp/usage/)[Best Practices](https://kiro.dev/docs/mcp/security/)
[Guides](https://kiro.dev/docs/guides/) [Billing](https://kiro.dev/docs/billing/)
[Privacy and security](https://kiro.dev/docs/privacy-and-security/)
[Reference](https://kiro.dev/docs/reference/troubleshooting/)

1. [Docs](https://kiro.dev/docs)
1. [MCP](https://kiro.dev/docs/mcp)
1. Configuration

<!-- section: configuration -->

# Configuration

This guide provides detailed information on configuring Model Context Protocol (MCP) servers with Kiro, including
configuration file structure, server setup, and best practices.

<!-- endsection -->

<!-- section: httpskirodevdocsmcpconfigurationconfiguration-file-structureconfiguration-file-structure -->

## [](https://kiro.dev/docs/mcp/configuration/#configuration-file-structure)Configuration File Structure

MCP configuration files use JSON format with the following structure:

```json
{
  "mcpServers": {
    "server-name": {
      "command": "command-to-run-server",
      "args": ["arg1", "arg2"],
      "env": {
        "ENV_VAR1": "value1",
        "ENV_VAR2": "value2"
      },
      "disabled": false,
      "autoApprove": ["tool_name1", "tool_name2"]
    }
  }
}


```

### [](https://kiro.dev/docs/mcp/configuration/#configuration-properties)Configuration Properties

| Property      | Type    | Required | Description                                     |
| ------------- | ------- | -------- | ----------------------------------------------- |
| `command`     | String  | Yes      | The command to run the MCP server               |
| `args`        | Array   | Yes      | Arguments to pass to the command                |
| `env`         | Object  | No       | Environment variables for the server process    |
| `disabled`    | Boolean | No       | Whether the server is disabled (default: false) |
| `autoApprove` | Array   | No       | Tool names to auto-approve without prompting    |

<!-- endsection -->

<!-- section: httpskirodevdocsmcpconfigurationconfiguration-locationsconfiguration-locations -->

## [](https://kiro.dev/docs/mcp/configuration/#configuration-locations)Configuration Locations

You can configure MCP servers at two levels:

1. **Workspace Level** : `.kiro/settings/mcp.json`
   - Applies only to the current workspace
   - Ideal for project-specific MCP servers
1. **User Level** : `~/.kiro/settings/mcp.json`
   - Applies globally across all workspaces
   - Best for MCP servers you use frequently

If both files exist, configurations are merged with workspace settings taking precedence.

<!-- endsection -->

<!-- section: httpskirodevdocsmcpconfigurationcreating-configuration-filescreating-configuration-files -->

## [](https://kiro.dev/docs/mcp/configuration/#creating-configuration-files)Creating Configuration Files

### [](https://kiro.dev/docs/mcp/configuration/#using-the-command-palette)Using the Command Palette

1. Open the command palette:
   - Mac: `Cmd + Shift + P`
   - Windows/Linux: `Ctrl + Shift + P`
1. Search for "MCP" and select one of these options:
   - **Kiro: Open workspace MCP config (JSON)** - For workspace-level configuration
   - **Kiro: Open user MCP config (JSON)** - For user-level configuration

### [](https://kiro.dev/docs/mcp/configuration/#using-the-kiro-panel)Using the Kiro Panel

1. Open the Kiro panel
1. Select the **Open MCP Config** icon

```json
{
  "mcpServers": {
    "web-search": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-bravesearch"
      ],
      "env": {
        "BRAVE_API_KEY": "your-api-key"
      }
    }
  }
}


```

<!-- endsection -->

<!-- section: httpskirodevdocsmcpconfigurationenvironment-variablesenvironment-variables -->

## [](https://kiro.dev/docs/mcp/configuration/#environment-variables)Environment Variables

Many MCP servers require environment variables for authentication or configuration:

```json
{
  "mcpServers": {
    "server-name": {
      "env": {
        "API_KEY": "your-api-key",
        "DEBUG": "true",
        "TIMEOUT": "30000"
      }
    }
  }
}


```

<!-- endsection -->

<!-- section: httpskirodevdocsmcpconfigurationdisabling-servers-temporarilydisabling-servers-temporarily -->

## [](https://kiro.dev/docs/mcp/configuration/#disabling-servers-temporarily)Disabling Servers Temporarily

To temporarily disable an MCP server without removing its configuration:

```json
{
  "mcpServers": {
    "server-name": {
      "disabled": true
    }
  }
}


```

<!-- endsection -->

<!-- section: httpskirodevdocsmcpconfigurationsecurity-best-practicessecurity-best-practices -->

## [](https://kiro.dev/docs/mcp/configuration/#security-best-practices)Security Best Practices

When configuring MCP servers:

- **Don't commit configuration files** with sensitive tokens to version control
- **Use environment variables** for sensitive information when possible
- **Review tool permissions** before adding them to `autoApprove`
- **Use workspace-level configs** for project-specific servers
- **Regularly rotate API keys and tokens** used in configurations

<!-- endsection -->

<!-- section: httpskirodevdocsmcpconfigurationtroubleshooting-configuration-issuestroubleshooting-configuration-issues -->

## [](https://kiro.dev/docs/mcp/configuration/#troubleshooting-configuration-issues)Troubleshooting Configuration Issues

If your MCP configuration isn't working:

1. **Validate JSON syntax** :
   - Ensure your JSON is valid with no syntax errors
   - Check for missing commas, quotes, or brackets
1. **Verify command paths** :
   - Make sure the command specified exists in your PATH
   - Try running the command directly in your terminal
1. **Check environment variables** :
   - Verify that all required environment variables are set
   - Check for typos in environment variable names
1. **Restart Kiro** :
   - Changes to MCP configuration require a restart
   - Close and reopen Kiro to apply changes

Page updated: July 8, 2025 [MCP](https://kiro.dev/docs/mcp/) [Servers](https://kiro.dev/docs/mcp/servers/) On this page

- [Configuration File Structure](https://kiro.dev/docs/mcp/configuration/#configuration-file-structure)
- [Configuration Properties](https://kiro.dev/docs/mcp/configuration/#configuration-properties)
- [Configuration Locations](https://kiro.dev/docs/mcp/configuration/#configuration-locations)
- [Creating Configuration Files](https://kiro.dev/docs/mcp/configuration/#creating-configuration-files)
- [Using the Command Palette](https://kiro.dev/docs/mcp/configuration/#using-the-command-palette)
- [Using the Kiro Panel](https://kiro.dev/docs/mcp/configuration/#using-the-kiro-panel)
- [Environment Variables](https://kiro.dev/docs/mcp/configuration/#environment-variables)
- [Disabling Servers Temporarily](https://kiro.dev/docs/mcp/configuration/#disabling-servers-temporarily)
- [Security Best Practices](https://kiro.dev/docs/mcp/configuration/#security-best-practices)
- [Troubleshooting Configuration Issues](https://kiro.dev/docs/mcp/configuration/#troubleshooting-configuration-issues)

______________________________________________________________________

![Kiro](https://kiro.dev/images/kiro-wordmark.png?h=0ad65a93) Product

- [About Kiro](https://kiro.dev/about/)
- [Pricing](https://kiro.dev/pricing/)
- [Changelog](https://kiro.dev/changelog/)
- [Downloads](https://kiro.dev/downloads/)

Resources

- [Documentation](https://kiro.dev/docs/)
- [Blog](https://kiro.dev/blog/)
- [FAQs](https://kiro.dev/faq/)
- [Report a bug](https://github.com/kirodotdev/Kiro/issues/new/choose)
- [Suggest an idea](https://github.com/kirodotdev/Kiro/issues/new?template=feature_request.yml)
- [Billing support](https://support.aws.amazon.com/#/contacts/kiro)

Social

- [](https://discord.gg/kirodotdev)
- [](https://www.linkedin.com/showcase/kirodotdev)
- [](https://x.com/kirodotdev)
- [](https://www.instagram.com/kirodotdev)
- [](https://www.youtube.com/@kirodotdev)
- [](https://bsky.app/profile/kiro.dev)
- [](https://www.twitch.tv/kirodotdev)

[](https://aws.amazon.com)
[Site Terms](https://aws.amazon.com/terms/)[License](https://kiro.dev/license/)[Responsible AI Policy](https://aws.amazon.com/ai/responsible-ai/policy/)[Legal](https://aws.amazon.com/legal/)[Privacy Policy](https://aws.amazon.com/privacy/)[Cookie Preferences](https://kiro.dev/docs/mcp/configuration/)

<!-- endsection -->

<!-- endfile -->
