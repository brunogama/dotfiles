---
description: Generate a simple continuous list of all Cursor commands and MCP server functions
---

@file ../mcp.json @file ~/.cursor/mcp.json

# All Tools List Generator

Create a straightforward inventory listing all available Cursor commands and MCP server functions.

## Execution Steps

### Step 1: Discover Local Commands

- Use `list_dir` to scan `${HOME}/.cursor/commands/` for `.md` files
- If `${CWD}/.cursor/commands/` exists, scan it too
- Extract command names (filename without .md extension)
- Sort alphabetically

### Step 2: Discover MCP Servers

- Read MCP configuration from `$(pwd)/.cursor/mcp.json`
- Extract all configured server names
- Sort alphabetically

### Step 3: Enumerate MCP Functions

- For each MCP server, use `list_mcp_resources` to discover available functions
- List all function names under their respective server
- If a server is offline/unreachable (timeout after 30 seconds), note it as "unavailable"
- Sort functions alphabetically within each server

## Output Format

```markdown
# Development Tools Inventory

## Cursor Commands ({{count}})
1. code-review
2. create-rule
3. enhance-prompt
4. improve-prompt
[... continue listing all commands ...]

## MCP Server Functions

### {{server_name_1}} ({{count}} functions)
1. function_name_1
2. function_name_2
[... continue listing all functions ...]

### {{server_name_2}} ({{count}} functions)
1. function_name_1
2. function_name_2
[... continue listing all functions ...]

[... continue for all servers ...]

---
**Total:** {{command_count}} commands + {{mcp_function_count}} MCP functions = {{total_count}} tools
```

## Constraints

- Timeout: 30 seconds per MCP server query
- Error handling: If file unreadable or server unreachable, note it and continue
- No categorization or detailed analysis required—just names

```
```
