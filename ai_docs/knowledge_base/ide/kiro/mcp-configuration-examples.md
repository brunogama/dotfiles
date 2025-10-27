---
title: MCP Configuration Examples
source_url: https://kiro.dev/docs/mcp/configuration/
last_fetched: '2025-10-12T22:00:00Z'
checksum: sha256:examples
type: reference
fetch_method: manual
---

<!-- file: mcp-configuration-examples.md -->

<!-- section: mcp-configuration-examples -->

# MCP Configuration Examples

Common patterns for configuring MCP servers in Kiro IDE.

<!-- endsection -->

<!-- section: basic-server-configuration -->

## Basic Server Configuration

### Minimal Configuration

```json
{
  "mcpServers": {
    "my-server": {
      "command": "node",
      "args": ["server.js"]
    }
  }
}
```

### With Environment Variables

```json
{
  "mcpServers": {
    "api-server": {
      "command": "python",
      "args": ["-m", "my_server"],
      "env": {
        "API_KEY": "your-api-key",
        "DEBUG": "true"
      }
    }
  }
}
```

<!-- endsection -->

<!-- section: python-servers -->

## Python Servers

### Using uv (Recommended)

```json
{
  "mcpServers": {
    "python-server": {
      "command": "uv",
      "args": [
        "run",
        "path/to/server.py"
      ],
      "env": {
        "PYTHONPATH": "."
      }
    }
  }
}
```

### Using uvx (Package Manager)

```json
{
  "mcpServers": {
    "package-server": {
      "command": "uvx",
      "args": [
        "package-name@latest"
      ],
      "env": {
        "FASTMCP_LOG_LEVEL": "ERROR"
      }
    }
  }
}
```

### Using python -m

```json
{
  "mcpServers": {
    "module-server": {
      "command": "python",
      "args": [
        "-m",
        "my_module.server"
      ]
    }
  }
}
```

<!-- endsection -->

<!-- section: node-servers -->

## Node.js Servers

### Using npx

```json
{
  "mcpServers": {
    "npm-server": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-example"
      ]
    }
  }
}
```

### Using node

```json
{
  "mcpServers": {
    "local-server": {
      "command": "node",
      "args": [
        "dist/index.js"
      ],
      "env": {
        "NODE_ENV": "production"
      }
    }
  }
}
```

<!-- endsection -->

<!-- section: auto-approval-patterns -->

## Auto-Approval Patterns

### Auto-Approve All Tools

```json
{
  "mcpServers": {
    "trusted-server": {
      "command": "uv",
      "args": ["run", "server.py"],
      "autoApprove": [
        "tool_1",
        "tool_2",
        "tool_3"
      ]
    }
  }
}
```

### Auto-Approve Read-Only Tools

```json
{
  "mcpServers": {
    "kb-server": {
      "command": "uv",
      "args": ["run", "kb_server.py"],
      "autoApprove": [
        "search",
        "read",
        "list",
        "get_metadata"
      ]
    }
  }
}
```

### No Auto-Approval (Require All Confirmations)

```json
{
  "mcpServers": {
    "sensitive-server": {
      "command": "python",
      "args": ["server.py"],
      "autoApprove": []
    }
  }
}
```

<!-- endsection -->

<!-- section: multiple-servers -->

## Multiple Servers

### Multiple Independent Servers

```json
{
  "mcpServers": {
    "knowledge-base": {
      "command": "uv",
      "args": ["run", "kb_server.py"],
      "env": {
        "KB_ROOT": ".ai_docs/knowledge_base"
      },
      "autoApprove": ["search", "read"]
    },
    "web-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-bravesearch"],
      "env": {
        "BRAVE_API_KEY": "your-key"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"],
      "args": ["/allowed/path"]
    }
  }
}
```

<!-- endsection -->

<!-- section: disabled-servers -->

## Disabled Servers

### Temporarily Disable

```json
{
  "mcpServers": {
    "my-server": {
      "command": "node",
      "args": ["server.js"],
      "disabled": true
    }
  }
}
```

### Conditional Disable (Development)

```json
{
  "mcpServers": {
    "production-server": {
      "command": "python",
      "args": ["server.py"],
      "env": {
        "ENVIRONMENT": "production"
      },
      "disabled": false
    },
    "dev-server": {
      "command": "python",
      "args": ["dev_server.py"],
      "env": {
        "ENVIRONMENT": "development"
      },
      "disabled": true
    }
  }
}
```

<!-- endsection -->

<!-- section: environment-variables -->

## Environment Variables

### API Keys

```json
{
  "mcpServers": {
    "api-server": {
      "command": "uvx",
      "args": ["api-server@latest"],
      "env": {
        "API_KEY": "your-api-key",
        "API_SECRET": "your-secret"
      }
    }
  }
}
```

### Logging Configuration

```json
{
  "mcpServers": {
    "debug-server": {
      "command": "python",
      "args": ["-m", "server"],
      "env": {
        "LOG_LEVEL": "DEBUG",
        "LOG_FILE": "server.log",
        "FASTMCP_LOG_LEVEL": "DEBUG"
      }
    }
  }
}
```

### Custom Paths

```json
{
  "mcpServers": {
    "path-server": {
      "command": "python",
      "args": ["server.py"],
      "env": {
        "DATA_DIR": "/path/to/data",
        "CONFIG_FILE": "/path/to/config.json",
        "CACHE_DIR": "/tmp/cache"
      }
    }
  }
}
```

<!-- endsection -->

<!-- section: workspace-vs-user-level -->

## Workspace vs User Level

### Workspace Level (.kiro/settings/mcp.json)

Project-specific servers:

```json
{
  "mcpServers": {
    "project-kb": {
      "command": "uv",
      "args": ["run", "Tooling/kb-server.py"],
      "env": {
        "KB_ROOT": ".ai_docs/knowledge_base"
      }
    }
  }
}
```

### User Level (~/.kiro/settings/mcp.json)

Global servers for all workspaces:

```json
{
  "mcpServers": {
    "web-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-bravesearch"],
      "env": {
        "BRAVE_API_KEY": "your-global-key"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "your-token"
      }
    }
  }
}
```

### Merged Configuration

If both exist, workspace settings override user settings:

**User (~/.kiro/settings/mcp.json)**:

```json
{
  "mcpServers": {
    "web-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-bravesearch"]
    }
  }
}
```

**Workspace (.kiro/settings/mcp.json)**:

```json
{
  "mcpServers": {
    "web-search": {
      "disabled": true
    },
    "project-kb": {
      "command": "uv",
      "args": ["run", "kb_server.py"]
    }
  }
}
```

**Result**: `web-search` is disabled, `project-kb` is active.

<!-- endsection -->

<!-- section: common-patterns -->

## Common Patterns

### Knowledge Base Server

```json
{
  "mcpServers": {
    "refactorflow-kb": {
      "command": "uv",
      "args": [
        "run",
        "Tooling/KnoledgeBase/kb-mcp-tools/knowledge_base_server.py"
      ],
      "env": {
        "KB_ROOT": ".ai_docs/knowledge_base",
        "LOG_LEVEL": "INFO"
      },
      "disabled": false,
      "autoApprove": [
        "kb_search",
        "kb_read_file",
        "kb_extract_section",
        "kb_list_domains",
        "kb_get_metadata"
      ]
    }
  }
}
```

### AWS Documentation Server

```json
{
  "mcpServers": {
    "aws-docs": {
      "command": "uvx",
      "args": ["awslabs.aws-documentation-mcp-server@latest"],
      "env": {
        "FASTMCP_LOG_LEVEL": "ERROR"
      },
      "disabled": false,
      "autoApprove": []
    }
  }
}
```

### Filesystem Server

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/username/Documents"
      ],
      "autoApprove": ["read_file", "list_directory"]
    }
  }
}
```

<!-- endsection -->

<!-- section: security-best-practices -->

## Security Best Practices

### Don't Commit Secrets

[NO] **Bad** - Secrets in version control:

```json
{
  "mcpServers": {
    "api-server": {
      "env": {
        "API_KEY": "sk-1234567890abcdef"
      }
    }
  }
}
```

[YES] **Good** - Use environment variables:

```json
{
  "mcpServers": {
    "api-server": {
      "env": {
        "API_KEY": "${API_KEY}"
      }
    }
  }
}
```

### Review Auto-Approve Carefully

[NO] **Bad** - Auto-approve write operations:

```json
{
  "autoApprove": [
    "delete_file",
    "write_file",
    "execute_command"
  ]
}
```

[YES] **Good** - Only auto-approve read operations:

```json
{
  "autoApprove": [
    "read_file",
    "list_directory",
    "get_metadata"
  ]
}
```

### Use Workspace-Level for Project-Specific

[YES] **Good** - Project-specific in workspace:

```
.kiro/settings/mcp.json  # Project KB server
```

[YES] **Good** - Personal tools in user config:

```
~/.kiro/settings/mcp.json  # Personal API keys
```

<!-- endsection -->

<!-- section: troubleshooting -->

## Troubleshooting

### Server Not Starting

Check command exists:

```bash
which uv
which node
which python
```

Test command manually:

```bash
uv run path/to/server.py
```

### Invalid JSON

Validate JSON syntax:

- Check for missing commas
- Check for trailing commas (not allowed in JSON)
- Check for unquoted keys
- Check for unclosed brackets

### Tools Not Appearing

1. Restart Kiro
1. Check server logs in Kiro Panel
1. Verify `autoApprove` tool names match exactly
1. Reconnect MCP servers (Cmd+Shift+P → "MCP: Reconnect")

<!-- endsection -->

<!-- endfile -->
