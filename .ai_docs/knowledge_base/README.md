# RefactorFlow Knowledge Base

This knowledge base contains curated documentation and reference materials for the RefactorFlow project.

## Directory Structure

```
.ai_docs/knowledge_base/
├── swift/                    # Swift language documentation
│   └── language/
│       ├── index.yml
│       ├── concurrency-guide.md
│       └── ast-manipulation.md
│
├── dependencies/             # External dependencies documentation
│   ├── sourcekitten/
│   │   ├── index.yml
│   │   └── usage-guide.md
│   ├── swiftsyntax/
│   └── indexstoredb/
│
├── tools/                    # Development tools documentation
│   ├── tuist/
│   │   ├── index.yml
│   │   └── project-generation.md
│   └── xcode/
│
├── patterns/                 # Design patterns and best practices
│   ├── index.yml
│   └── refactoring-patterns.md
│
├── project/                  # Project-specific documentation
│   ├── index.yml
│   └── architecture-overview.md
│
├── mcp-config.json          # MCP server configuration
└── README.md               # This file
```

## Quick Start

### 1. Validate the Knowledge Base

```bash
# Validate all index files
uv run validate-kb-indexes

# Check source health
uv run validate-kb-sources
```

### 2. Update Documentation

```bash
# Update all sources
uv run update-kb --all

# Update specific domain
uv run update-kb --domain swift
```

### 3. Start MCP Server

```bash
# Start the knowledge base MCP server
uv run kb-server
```

## Available Domains

- **swift**: Swift language features, concurrency, AST manipulation
- **dependencies**: SourceKitten, SwiftSyntax, IndexStoreDB documentation
- **tools**: Tuist, Xcode, and other development tools
- **patterns**: Refactoring patterns and best practices
- **project**: RefactorFlow architecture and internal documentation

## Sample Content

### Swift Concurrency Guide

- Location: `swift/language/concurrency-guide.md`
- Topics: async/await, actors, task groups, sendable protocol
- Sections: async-await, actors, task-groups, sendable

### SourceKitten Usage

- Location: `dependencies/sourcekitten/usage-guide.md`
- Topics: AST parsing, symbol resolution, refactoring operations
- Sections: installation, basic-usage, advanced-features, refactoring-operations

### Tuist Project Generation

- Location: `tools/tuist/project-generation.md`
- Topics: Project definition, build settings, dependency management
- Sections: project-definition, build-settings, workspace-management, dependencies

### Refactoring Patterns

- Location: `patterns/refactoring-patterns.md`
- Topics: Extract patterns, inline patterns, rename patterns
- Sections: extract-patterns, inline-patterns, rename-patterns, signature-patterns

## Using the MCP Server

The MCP server exposes 5 tools for agent access:

1. **kb_search**: Search by topic or domain
1. **kb_read_file**: Read a specific file
1. **kb_extract_section**: Extract a specific section
1. **kb_list_domains**: List available domains
1. **kb_get_metadata**: Get file metadata

### Example Usage

```python
# Search for concurrency topics
result = kb_search(query="concurrency", domain="swift", max_results=5)

# Read specific file
content = kb_read_file(path="swift/language/concurrency-guide.md")

# Extract specific section
section = kb_extract_section(
    path="swift/language/concurrency-guide.md",
    section="async-await"
)

# List all domains
domains = kb_list_domains()

# Get metadata
metadata = kb_get_metadata(path="swift/language/concurrency-guide.md")
```

## Maintenance

### Adding New Content

1. Create appropriate directory structure
1. Add `index.yml` with source definitions
1. Add markdown files with YAML front matter
1. Use md-tree separators for sections
1. Run validation: `uv run validate-kb-indexes`

### Updating Existing Content

1. Run update command: `uv run update-kb --source "Source Name"`
1. Verify checksum updates
1. Review changes in markdown files
1. Commit changes to version control

## Best Practices

1. **Keep sections focused**: Each section should cover one concept
1. **Use meaningful section names**: Section slugs become extraction keys
1. **Include code examples**: Practical examples aid understanding
1. **Update metadata**: Keep topics and agent_relevance current
1. **Regular validation**: Run validators before commits
1. **Monitor size**: Stay under 500MB total limit

## Troubleshooting

If you encounter issues:

1. Check validation: `uv run validate-kb-indexes --strict`
1. Review logs: `tail -f .ai_docs/knowledge_base/update.log`
1. Test single source: `uv run fetch-kb-source --url <URL> --output test/`
1. Enable debug mode: `export LOG_LEVEL=DEBUG`

## References

- [Knowledge Base Tools Documentation](../../Tooling/KnoledgeBase/kb-tools/README.md)
- [Knowledge Base Quick Reference](../../Tooling/KnoledgeBase/QUICK_REFERENCE.md)
- [ADR-009: Agent Knowledge Base Architecture](../../docs/adr/ADR-009-agent-knowledge-base-architecture.md)
- [Project Documentation](../../docs/)
