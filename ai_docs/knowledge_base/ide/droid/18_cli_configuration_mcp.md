# https://docs.factory.ai/cli/configuration/mcp

[Skip to main content](https://docs.factory.ai/cli/configuration/mcp#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Configuration
Model Context Protocol
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
  * [Overview](https://docs.factory.ai/cli/configuration/mcp#overview)
  * [Usage](https://docs.factory.ai/cli/configuration/mcp#usage)
  * [Global Options](https://docs.factory.ai/cli/configuration/mcp#global-options)
  * [Available Commands](https://docs.factory.ai/cli/configuration/mcp#available-commands)
  * [Commands](https://docs.factory.ai/cli/configuration/mcp#commands)
  * [list](https://docs.factory.ai/cli/configuration/mcp#list)
  * [add](https://docs.factory.ai/cli/configuration/mcp#add)
  * [Adding stdio servers](https://docs.factory.ai/cli/configuration/mcp#adding-stdio-servers)
  * [Adding Streamable HTTP servers](https://docs.factory.ai/cli/configuration/mcp#adding-streamable-http-servers)
  * [remove](https://docs.factory.ai/cli/configuration/mcp#remove)
  * [get](https://docs.factory.ai/cli/configuration/mcp#get)
  * [enable](https://docs.factory.ai/cli/configuration/mcp#enable)
  * [disable](https://docs.factory.ai/cli/configuration/mcp#disable)
  * [Getting Help](https://docs.factory.ai/cli/configuration/mcp#getting-help)
  * [Configuration](https://docs.factory.ai/cli/configuration/mcp#configuration)
  * [Transport Types](https://docs.factory.ai/cli/configuration/mcp#transport-types)
  * [Stdio Transport](https://docs.factory.ai/cli/configuration/mcp#stdio-transport)
  * [Streamable HTTP Transport](https://docs.factory.ai/cli/configuration/mcp#streamable-http-transport)
  * [Environment Variables](https://docs.factory.ai/cli/configuration/mcp#environment-variables)
  * [Error Handling](https://docs.factory.ai/cli/configuration/mcp#error-handling)
  * [Examples](https://docs.factory.ai/cli/configuration/mcp#examples)


Configuration
# Model Context Protocol
Copy page
Manage MCP servers and configurations in droid CLI
Copy page
The `/mcp` command provides comprehensive management of MCP servers within Factory CLI, allowing you to configure, monitor, and maintain Model Context Protocol server connections.
Factory CLI supports both **stdio-based** and **Streamable HTTP** MCP servers, allowing you to connect to local processes or remote MCP endpoints.
##
[​](https://docs.factory.ai/cli/configuration/mcp#overview)
Overview
MCP (Model Context Protocol) servers extend Factory’s capabilities by providing additional tools and context. The `/mcp` command lets you:
  * List all configured MCP servers and their status
  * Add new MCP servers to your configuration
  * Remove existing servers
  * View detailed information about specific servers


##
[​](https://docs.factory.ai/cli/configuration/mcp#usage)
Usage
Copy
Ask AI
```
/mcp [options] [command]

```

###
[​](https://docs.factory.ai/cli/configuration/mcp#global-options)
Global Options
Option| Description
---|---
`-h, --help`| Display help for command
###
[​](https://docs.factory.ai/cli/configuration/mcp#available-commands)
Available Commands
Command| Description
---|---
`list`| List configured MCP servers and their status
`add <name> <command-or-url>`| Add a new MCP server to the configuration
`remove <name>`| Remove an MCP server from the configuration
`get <name>`| Show details about a specific MCP server
`enable <name> [name2...]`| Enable one or more disabled servers
`disable <name> [name2...]`| Disable one or more servers temporarily
`help [command]`| Display help for a specific command
If no command is specified, `/mcp` defaults to the `list` command.
##
[​](https://docs.factory.ai/cli/configuration/mcp#commands)
Commands
###
[​](https://docs.factory.ai/cli/configuration/mcp#list)
list
Lists all configured MCP servers and displays their current status.
Copy
Ask AI
```
/mcp list [options]

```

**Options:**
  * `-h, --help` - Display help for the list command

**Example:**
Copy
Ask AI
```
/mcp list

```

###
[​](https://docs.factory.ai/cli/configuration/mcp#add)
add
Adds a new MCP server to your configuration. Factory CLI supports two types of MCP servers: stdio (local processes) and Streamable HTTP (remote endpoints).
####
[​](https://docs.factory.ai/cli/configuration/mcp#adding-stdio-servers)
Adding stdio servers
Stdio servers run as local processes and communicate via standard input/output streams.
Copy
Ask AI
```
/mcp add <name> <command> [options]

```

**Arguments:**
  * `name` - Server name (used as identifier)
  * `command` - Command to start the server

**Options:**
  * `-e, --env <key=value...>` - Environment variables (stdio only, can be used multiple times)
  * `-h, --help` - Display help for the add command

**Examples:** Add a basic stdio server:
Copy
Ask AI
```
/mcp add myserver "node /path/to/server.js"

```

Add a stdio server with environment variables:
Copy
Ask AI
```
/mcp add myserver "python server.py" -e API_KEY=secret123 -e DEBUG=true

```

####
[​](https://docs.factory.ai/cli/configuration/mcp#adding-streamable-http-servers)
Adding Streamable HTTP servers
Streamable HTTP servers are remote MCP endpoints accessed via HTTP/HTTPS URLs.
Copy
Ask AI
```
/mcp add --type http <name> <url> [options]

```

**Arguments:**
  * `name` - Server name (used as identifier)
  * `url` - HTTP/HTTPS URL of the MCP server endpoint

**Options:**
  * `-H, --header <key: value...>` - HTTP headers (http only, can be used multiple times)
  * `-h, --help` - Display help for the add command

**Examples:** Add a basic HTTP server:
Copy
Ask AI
```
/mcp add myserver https://api.example.com/mcp --type http

```

Add an HTTP server with authentication header:
Copy
Ask AI
```
/mcp add myserver https://api.example.com/mcp --type http -H "Authorization: Bearer token123"

```

Add an HTTP server with multiple headers:
Copy
Ask AI
```
/mcp add myserver https://api.example.com/mcp --type http -H "Authorization: Bearer token" -H "X-API-Key: secret"

```

###
[​](https://docs.factory.ai/cli/configuration/mcp#remove)
remove
Removes an MCP server from the configuration.
Copy
Ask AI
```
/mcp remove [options] <name>

```

**Arguments:**
  * `name` - Server name to remove

**Options:**
  * `-h, --help` - Display help for the remove command

**Example:**
Copy
Ask AI
```
/mcp remove myserver

```

###
[​](https://docs.factory.ai/cli/configuration/mcp#get)
get
Shows detailed information about a specific MCP server.
Copy
Ask AI
```
/mcp get [options] <name>

```

**Arguments:**
  * `name` - Server name to get details for

**Options:**
  * `-h, --help` - Display help for the get command

**Example:**
Copy
Ask AI
```
/mcp get myserver

```

###
[​](https://docs.factory.ai/cli/configuration/mcp#enable)
enable
Enables one or more previously disabled MCP servers. Enabled servers will be available for use in your sessions.
Copy
Ask AI
```
/mcp enable <name> [name2 name3...]

```

**Arguments:**
  * `name` - Server name(s) to enable (can specify multiple)

**Options:**
  * `-h, --help` - Display help for the enable command

**Examples:**
Copy
Ask AI
```
# Enable a single server
/mcp enable myserver
# Enable multiple servers at once
/mcp enable server1 server2 server3

```

**Notes:**
  * Servers must already exist in your configuration
  * If a server is already enabled, the command has no effect
  * Use `/mcp list` to see which servers are currently disabled


###
[​](https://docs.factory.ai/cli/configuration/mcp#disable)
disable
Temporarily disables one or more MCP servers without removing them from your configuration. Disabled servers won’t be available for use but can be re-enabled later.
Copy
Ask AI
```
/mcp disable <name> [name2 name3...]

```

**Arguments:**
  * `name` - Server name(s) to disable (can specify multiple)

**Options:**
  * `-h, --help` - Display help for the disable command

**Examples:**
Copy
Ask AI
```
# Disable a single server
/mcp disable myserver
# Disable multiple servers at once
/mcp disable server1 server2 server3

```

**Notes:**
  * Disabled servers remain in your configuration and can be re-enabled with `/mcp enable`
  * Use this when you want to temporarily stop using a server without losing its configuration
  * Disabled servers appear in `/mcp list` with a “disabled” indicator


##
[​](https://docs.factory.ai/cli/configuration/mcp#getting-help)
Getting Help
You can get help for the `/mcp` command and its subcommands in several ways:
  * `/mcp --help` or `/mcp -h` - Show general help
  * `/mcp help` - Show general help
  * `/mcp help <command>` - Show help for a specific command
  * `/mcp <command> --help` - Show help for a specific command

**Examples:**
Copy
Ask AI
```
/mcp --help
/mcp help add
/mcp add --help

```

##
[​](https://docs.factory.ai/cli/configuration/mcp#configuration)
Configuration
MCP server configurations are stored in a configuration file managed by Factory CLI. Each server configuration includes:
  * **Name** : Unique identifier for the server
  * **Type** : Server type (stdio or http)
  * **Type-specific settings** : Command/args/env for stdio, URL/headers for http
  * **Disabled** : Optional flag to temporarily disable a server


##
[​](https://docs.factory.ai/cli/configuration/mcp#transport-types)
Transport Types
Factory CLI supports two transport methods for MCP servers:
###
[​](https://docs.factory.ai/cli/configuration/mcp#stdio-transport)
Stdio Transport
The stdio transport method runs MCP servers as local processes:
  * Communication happens over standard input/output streams
  * Servers must implement the MCP protocol over stdin/stdout
  * Most common transport method for MCP servers
  * No network configuration or ports are required
  * Best for: Local tools, file system operations, development servers


###
[​](https://docs.factory.ai/cli/configuration/mcp#streamable-http-transport)
Streamable HTTP Transport
The Streamable HTTP transport method connects to remote MCP servers over HTTP/HTTPS:
  * Communication happens via HTTP requests with streaming responses
  * Servers are accessed via URL endpoints
  * Supports authentication via custom headers
  * No local process management needed
  * Best for: Cloud-hosted MCP servers, shared team resources, documentation servers


##
[​](https://docs.factory.ai/cli/configuration/mcp#environment-variables)
Environment Variables
When adding servers, you can specify environment variables using the `-e` or `--env` flag:
Copy
Ask AI
```
/mcp add myserver "node server.js" -e NODE_ENV=production -e PORT=3000 -e API_URL=https://api.example.com

```

Environment variables must be in `KEY=VALUE` format. If a value contains an equals sign, everything after the first `=` is treated as the value.
##
[​](https://docs.factory.ai/cli/configuration/mcp#error-handling)
Error Handling
The `/mcp` command provides clear error messages for common issues:
  * **Invalid environment variable format** : Check that variables use `KEY=VALUE` format
  * **Invalid header format** : Check that headers use `KEY: VALUE` format (note the colon and space)
  * **Server already exists** : Use a different name or remove the existing server first
  * **Invalid server type** : Must be “stdio” or “http”
  * **Wrong options for server type** : `--env` is only for stdio servers, `--header` is only for HTTP servers
  * **Invalid URL format** : For HTTP servers, provide a valid HTTP/HTTPS URL
  * **Unknown command** : Use `/mcp --help` to see available commands
  * **Missing arguments** : Ensure all required arguments are provided


##
[​](https://docs.factory.ai/cli/configuration/mcp#examples)
Examples
Here are some common usage patterns: **List all servers:**
Copy
Ask AI
```
/mcp
# or
/mcp list

```

**Add a Node.js MCP server:**
Copy
Ask AI
```
/mcp add nodejs-server "node /path/to/mcp-server.js"

```

**Add a Python server with environment variables:**
Copy
Ask AI
```
/mcp add python-server "python /path/to/server.py" -e DEBUG=1 -e CONFIG_PATH=/etc/config

```

**Add Factory documentation MCP server (Streamable HTTP):**
Copy
Ask AI
```
/mcp add --type http factory-docs https://docs.factory.ai/mcp

```

**Add GitHub MCP server with authentication (Streamable HTTP):**
Copy
Ask AI
```
/mcp add --type http github https://mcp.githubcopilot.com -H "Authorization: Bearer YOUR_GITHUB_TOKEN"

```

**View server details:**
Copy
Ask AI
```
/mcp get nodejs-server

```

**Remove a server:**
Copy
Ask AI
```
/mcp remove nodejs-server

```

**Get help for a specific command:**
Copy
Ask AI
```
/mcp help add

```

MCP servers extend Factory’s capabilities by providing additional tools and context. Use stdio servers for local tools and processes, or Streamable HTTP servers to connect to remote MCP endpoints like documentation servers and shared team resources.
[Mixed Models](https://docs.factory.ai/cli/configuration/mixed-models)[Overview](https://docs.factory.ai/cli/byok/overview)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
