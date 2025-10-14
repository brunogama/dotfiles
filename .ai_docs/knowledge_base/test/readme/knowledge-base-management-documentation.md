---
title: Knowledge Base Management Documentation
source_url: file:///Users/bruno/Developer/Inbox/RefactorFlow/Tooling/KnoledgeBase/kb-tools/README.md
last_fetched: '2025-10-12T19:53:54.995100+00:00'
checksum: sha256:0685ae6f96dfe678cb8c62f94a8ad93d73fec17363dedc4bdc06228148724bf4
type: official_documentation
fetch_method: local_file
---

<!-- file: knowledge-base-management-documentation.md -->

<!-- section: knowledge-base-management-documentation -->

# Knowledge Base Management Documentation

This document provides comprehensive documentation for RefactorBuddy's Agent Knowledge Base system, as defined in
[ADR-009: Agent Knowledge Base Architecture](adr/ADR-009-agent-knowledge-base-architecture.md).

**Quick Links**: [Getting Started](#getting-started) | [Command-Line Tools](#command-line-tools) |
[MCP Server](#mcp-server) | [Workflows](#workflows) | [Troubleshooting](#troubleshooting)

<!-- endsection -->

<!-- section: table-of-contents -->

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Command-Line Tools](#command-line-tools)
- [MCP Server](#mcp-server)
- [File Formats](#file-formats)
- [Workflows](#workflows)
- [CI Integration](#ci-integration)
- [Troubleshooting](#troubleshooting)

<!-- endsection -->

<!-- section: overview -->

## Overview

The Knowledge Base system provides a centralized repository of external documentation and reference materials for AI
agents. It enables:

- **Automatic fetching** of external documentation sources
- **Version tracking** with SHA-256 checksums
- **Section-level access** via md-tree explode separators
- **Searchable metadata** through YAML indexes
- **Agent integration** via MCP (Model Context Protocol) server

### Key Features

- **500MB storage limit** with automatic size monitoring
- **Multiple fetch methods**: HTTP, Git, API
- **HTML to Markdown conversion** for web sources
- **Daily CI validation** of source health
- **Structured metadata** with YAML front matter

<!-- endsection -->

<!-- section: architecture -->

## Architecture

### Directory Structure

```
.ai_docs/knowledge_base/
├── swift/
│   ├── language/
│   │   ├── concurrency-guide.md
│   │   ├── async-programming.md
│   │   └── index.yml
│   └── frameworks/
│       └── index.yml
├── dependencies/
│   ├── sourcekitten/
│   ├── swiftsyntax/
│   └── indexstoredb/
├── tools/
│   ├── tuist/
│   └── xcode/
├── project/
│   ├── constitution.md (symlink)
│   └── adrs/ (symlink)
├── patterns/
├── mcp-config.json
└── update.log
```

### Components

1. **Python Scripts** (4 scripts, ~700 lines):

   - `update_knowledge_base.py` - Main update orchestrator
   - `fetch_kb_source.py` - Source fetcher with multiple methods
   - `validate_kb_indexes.py` - YAML schema validation
   - `validate_kb_sources.py` - URL health checking

1. **MCP Server** (~500 lines):

   - `knowledge_base_server.py` - Exposes 5 tools for agent access

1. **Configuration**:

   - `pyproject.toml` - uv package configuration
   - `mcp-config.json` - MCP server settings

<!-- endsection -->

<!-- section: getting-started -->

## Getting Started

### Prerequisites

- Python 3.11+
- [uv](https://github.com/astral-sh/uv) package manager
- Git (for repository fetching)

### Installation

1. Install dependencies using uv:

```bash
<!-- endsection -->

<!-- section: install-with-dev-dependencies -->
# Install with dev dependencies
uv sync --all-extras

<!-- endsection -->

<!-- section: or-install-just-runtime-dependencies -->
# Or install just runtime dependencies
uv sync
```

2. Verify installation:

```bash
<!-- endsection -->

<!-- section: check-all-commands-are-available -->
# Check all commands are available
uv run update-kb --help
uv run fetch-kb-source --help
uv run validate-kb-indexes --help
uv run validate-kb-sources --help
uv run kb-server --help
```

### Quick Start

1. **Create initial directory structure**:

```bash
mkdir -p .ai_docs/knowledge_base/swift/language
```

2. **Create an index file** (`.ai_docs/knowledge_base/swift/language/index.yml`):

```yaml
title: "Swift Language Knowledge"
version: "1.0.0"
last_updated: "2025-10-11T10:00:00Z"

sources:
  - name: "Swift Language Guide"
    url: "https://docs.swift.org/swift-book/LanguageGuide/"
    type: "official_documentation"
    fetch_frequency: "weekly"
    validation: "checksum"

files:
  - path: "concurrency-guide.md"
    title: "Swift Concurrency Guide"
    topics: ["async-await", "actors", "task-groups"]
    agent_relevance: ["swift-pro", "ios-architect"]

domains: ["swift", "language", "core"]
```

3. **Fetch sources**:

```bash
uv run update-kb --domain swift
```

4. **Validate**:

```bash
uv run validate-kb-indexes
uv run validate-kb-sources
```

5. **Start MCP server**:

```bash
uv run kb-server
```

<!-- endsection -->

<!-- section: command-line-tools -->

## Command-Line Tools

### update-kb

Updates knowledge base from external sources.

**Usage:**

```bash
<!-- endsection -->

<!-- section: update-all-sources -->
# Update all sources
uv run update-kb --all

<!-- endsection -->

<!-- section: update-specific-domain -->
# Update specific domain
uv run update-kb --domain swift

<!-- endsection -->

<!-- section: update-specific-source-by-name -->
# Update specific source by name
uv run update-kb --source "Swift Language Guide"

<!-- endsection -->

<!-- section: custom-kb-root -->
# Custom KB root
uv run update-kb --all --kb-root /path/to/kb
```

**Features:**

- Respects `fetch_frequency` setting (daily, weekly, monthly)
- Calculates SHA-256 checksums for validation
- Updates YAML front matter automatically
- Logs all operations to `update.log`

**Exit Codes:**

- `0`: Success
- `1`: Errors encountered during update

### fetch-kb-source

Fetches a specific source from a URL.

**Usage:**

```bash
<!-- endsection -->

<!-- section: fetch-http-source -->
# Fetch HTTP source
uv run fetch-kb-source \
  --url https://docs.swift.org/swift-book/ \
  --output swift/language/ \
  --type official_documentation

<!-- endsection -->

<!-- section: clone-git-repository -->
# Clone git repository
uv run fetch-kb-source \
  --url https://github.com/apple/swift-evolution \
  --output swift/evolution/ \
  --type git_repository

<!-- endsection -->

<!-- section: with-maximum-recursion-depth -->
# With maximum recursion depth
uv run fetch-kb-source \
  --url https://example.com/docs/ \
  --output custom/ \
  --max-depth 3
```

**Features:**

- Auto-detects fetch method (HTTP vs Git)
- Converts HTML to Markdown
- Injects md-tree explode separators
- Handles pagination and multi-page documentation

### validate-kb-indexes

Validates all index.yml files in the knowledge base.

**Usage:**

```bash
<!-- endsection -->

<!-- section: standard-validation -->
# Standard validation
uv run validate-kb-indexes

<!-- endsection -->

<!-- section: strict-mode-warnings--errors -->
# Strict mode (warnings = errors)
uv run validate-kb-indexes --strict

<!-- endsection -->

<!-- section: custom-kb-root -->
# Custom KB root
uv run validate-kb-indexes --kb-root /path/to/kb
```

**Validation Checks:**

- **YAML Schema**: Validates against `IndexSchema` (Pydantic model)
- **File References**: Ensures all referenced files exist
- **URL Accessibility**: HEAD requests to check source URLs
- **Storage Limit**: Verifies total size \< 500MB
- **Version Format**: Checks semver compliance (e.g., "1.0.0")

**Exit Codes:**

- `0`: All validations passed (or warnings only in non-strict mode)
- `1`: Validation errors found (or warnings in strict mode)

### validate-kb-sources

Checks health of external documentation sources.

**Usage:**

```bash
<!-- endsection -->

<!-- section: check-sources-only -->
# Check sources only
uv run validate-kb-sources

<!-- endsection -->

<!-- section: also-check-links-within-markdown-files -->
# Also check links within markdown files
uv run validate-kb-sources --check-links

<!-- endsection -->

<!-- section: custom-kb-root -->
# Custom KB root
uv run validate-kb-sources --kb-root /path/to/kb
```

**Health Checks:**

- **URL Accessibility**: HTTP HEAD/GET requests
- **SSL Validation**: Checks certificate validity
- **Broken Link Detection**: Validates links in markdown
- **Response Codes**: Reports 4xx and 5xx errors

**Exit Codes:**

- `0`: All URLs healthy
- `1`: Failed URLs detected

<!-- endsection -->

<!-- section: mcp-server -->

## MCP Server

The Knowledge Base MCP Server exposes 5 tools for agent access.

### Starting the Server

```bash
uv run kb-server
```

The server runs via stdio and can be integrated with Claude Code or other MCP clients.

### Available Tools

#### 1. kb_search

Search knowledge base by topic or domain.

**Parameters:**

- `query` (required): Search query (topic or keyword)
- `domain` (optional): Filter by domain (e.g., 'swift', 'dependencies')
- `max_results` (optional): Maximum results to return (default: 10)

**Example:**

```json
{
  "query": "concurrency",
  "domain": "swift",
  "max_results": 5
}
```

**Returns:**

```
Found 2 results for 'concurrency':

1. Swift Concurrency Guide
   Path: swift/language/concurrency-guide.md
   Topics: async-await, actors, task-groups

2. Advanced Concurrency Patterns
   Path: swift/patterns/concurrency-advanced.md
   Topics: concurrency, performance, optimization
```

#### 2. kb_read_file

Read a specific knowledge base file.

**Parameters:**

- `path` (required): Relative path from KB root (e.g., 'swift/language/concurrency.md')

**Example:**

```json
{
  "path": "swift/language/concurrency-guide.md"
}
```

**Returns:** Full file contents including YAML front matter and md-tree separators.

#### 3. kb_extract_section

Extract a specific section from a KB file using md-tree separators.

**Parameters:**

- `path` (required): Relative path from KB root
- `section` (required): Section name (slug from md-tree separator)

**Example:**

```json
{
  "path": "swift/language/concurrency-guide.md",
  "section": "async-await"
}
```

**Returns:** Only the content between `<!-- section: async-await -->` and `<!-- endsection -->`.

#### 4. kb_list_domains

List all available domains in the knowledge base.

**Parameters:** None

**Returns:**

```
Available domains:

- dependencies/sourcekitten
- patterns
- project
- swift
- swift/language
- tools
```

#### 5. kb_get_metadata

Get YAML front matter metadata from a KB file.

**Parameters:**

- `path` (required): Relative path from KB root

**Example:**

```json
{
  "path": "swift/language/concurrency-guide.md"
}
```

**Returns:**

```yaml
title: "Swift Concurrency Guide"
source_url: "https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html"
last_fetched: "2025-10-11T10:30:00Z"
checksum: "sha256:abc123..."
domains: ["swift", "concurrency"]
agent_refs: ["swift-pro", "ios-architect"]
```

<!-- endsection -->

<!-- section: file-formats -->

## File Formats

### Index File (index.yml)

**Schema:**

```yaml
title: string                 # Index title (required)
version: string               # Semver version (required, e.g., "1.0.0")
last_updated: string          # ISO 8601 timestamp (required)

sources:                      # List of external sources
  - name: string              # Source name (required)
    url: string               # Source URL (required, must be valid HTTP(S))
    type: string              # Source type (required)
    fetch_frequency: string   # "daily" | "weekly" | "monthly" | "on_update"
    validation: string        # "checksum" | "timestamp" | "none"
    last_fetched: string      # ISO 8601 timestamp (optional)

files:                        # List of KB files
  - path: string              # Relative path (required)
    title: string             # File title (required)
    topics: [string]          # List of topics (optional)
    agent_relevance: [string] # Relevant agents (optional)

domains: [string]             # List of domains (optional)

ide_integration:              # IDE integration settings (optional)
  xcode:
    indexable: boolean
    autocomplete_prefix: string
```

### Markdown File with YAML Front Matter

**Format:**

```markdown
---
title: "Document Title"
source_url: "https://example.com/source"
last_fetched: "2025-10-11T10:30:00Z"
checksum: "sha256:abc123..."
domains: ["domain1", "domain2"]
agent_refs: ["agent1", "agent2"]
---

<!-- file: path/to/file.md -->

<!-- endsection -->

<!-- section: main-title -->
# Main Title

<!-- section: section-name -->
<!-- endsection -->

<!-- section: section-title -->
## Section Title

Section content here...

<!-- endsection -->

<!-- section: another-section -->
<!-- endsection -->

<!-- section: another-section -->
## Another Section

More content...

<!-- endsection -->

<!-- endfile -->
```

<!-- endsection -->

<!-- section: workflows -->

## Workflows

### Daily Update Workflow

1. **Fetch updates** (for sources due based on frequency):

```bash
uv run update-kb --all
```

2. **Validate indexes**:

```bash
uv run validate-kb-indexes
```

3. **Check source health**:

```bash
uv run validate-kb-sources
```

4. **Review logs**:

```bash
tail -f .ai_docs/knowledge_base/update.log
```

### Adding a New Domain

1. **Create directory structure**:

```bash
mkdir -p .ai_docs/knowledge_base/new-domain
```

2. **Create index.yml**:

```bash
cat > .ai_docs/knowledge_base/new-domain/index.yml << 'EOF'
title: "New Domain Knowledge"
version: "1.0.0"
last_updated: "2025-10-11T10:00:00Z"

sources:
  - name: "Example Source"
    url: "https://example.com/docs"
    type: "official_documentation"
    fetch_frequency: "weekly"

domains: ["new-domain"]
EOF
```

3. **Fetch sources**:

```bash
uv run update-kb --domain new-domain
```

4. **Validate**:

```bash
uv run validate-kb-indexes
```

### Adding a New Source to Existing Domain

1. **Edit index.yml**:

```yaml
sources:
  # Existing sources...
  - name: "New Source Name"
    url: "https://new-source.com/docs"
    type: "api_reference"
    fetch_frequency: "weekly"
    validation: "checksum"
```

2. **Fetch the new source**:

```bash
uv run update-kb --source "New Source Name"
```

3. **Add file reference to index**:

```yaml
files:
  # Existing files...
  - path: "new-source-docs.md"
    title: "New Source Documentation"
    topics: ["api", "reference"]
    agent_relevance: ["backend-architect"]
```

<!-- endsection -->

<!-- section: ci-integration -->

## CI Integration

### GitHub Actions Example

```yaml
name: Knowledge Base Validation

on:
  schedule:
    - cron: '0 2 * * *'  # Daily at 2 AM
  push:
    paths:
      - '.ai_docs/knowledge_base/**'

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install uv
        uses: astral-sh/setup-uv@v2

      - name: Install dependencies
        run: uv sync

      - name: Update knowledge base
        run: uv run update-kb --all

      - name: Validate indexes
        run: uv run validate-kb-indexes --strict

      - name: Check source health
        run: uv run validate-kb-sources

      - name: Upload logs
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: kb-logs
          path: .ai_docs/knowledge_base/update.log
```

### Pre-commit Hook Example

```bash
#!/bin/bash
<!-- endsection -->

<!-- section: githookspre-commit -->
# .git/hooks/pre-commit

if git diff --cached --name-only | grep -q '^.ai_docs/knowledge_base/'; then
  echo "Validating knowledge base..."
  uv run validate-kb-indexes --strict || exit 1
  echo "Knowledge base validation passed"
fi
```

<!-- endsection -->

<!-- section: troubleshooting -->

## Troubleshooting

### Common Issues

#### Issue: "No module named 'yaml'"

**Solution:**

```bash
uv sync --all-extras
```

#### Issue: "Storage limit exceeded"

**Solution:**

1. Check current size:

```bash
du -sh .ai_docs/knowledge_base
```

2. Identify large files:

```bash
find .ai_docs/knowledge_base -type f -size +10M
```

3. Remove or compress large files
1. Update index files to remove references

#### Issue: "URL check failed" for valid URLs

**Solution:**

- Some servers block HEAD requests. The validator automatically falls back to GET.
- If the URL is valid but still fails, it may be blocking bot user agents.
- Add the URL to a whitelist or skip health checks for specific domains.

#### Issue: "YAML schema validation failed"

**Solution:**

1. Check error message for specific field
1. Verify version format is semver (e.g., "1.0.0")
1. Ensure required fields are present: `title`, `version`, `last_updated`
1. Validate `fetch_frequency` is one of: daily, weekly, monthly, on_update

### Debugging

Enable debug logging:

```bash
export LOG_LEVEL=DEBUG
uv run update-kb --all
```

Check logs:

```bash
tail -100 .ai_docs/knowledge_base/update.log
```

Test single source fetch:

```bash
uv run fetch-kb-source \
  --url https://example.com/test \
  --output test/ \
  --type documentation
```

<!-- endsection -->

<!-- section: best-practices -->

## Best Practices

1. **Regular Updates**: Run `update-kb --all` daily via CI
1. **Version Control**: Commit index.yml files but consider .gitignoring fetched .md files
1. **Storage Management**: Monitor size, clean old/unused sources
1. **Source Selection**: Prioritize official documentation over third-party
1. **Metadata Quality**: Keep topics and agent_relevance up to date
1. **Section Granularity**: Use md-tree sections for documents > 200 lines
1. **Health Monitoring**: Enable daily source health checks in CI

<!-- endsection -->

<!-- section: references -->

## References

- [ADR-009: Agent Knowledge Base Architecture](adr/ADR-009-agent-knowledge-base-architecture.md)
- [ADR-008: Structured Agent Communication Protocol](adr/ADR-008-structured-agent-communication-protocol.md)
- [RefactorBuddy Constitution v5.1.0](.specify/memory/constitution.md)
- [MCP Specification](https://spec.modelcontextprotocol.io/)
- [uv Documentation](https://docs.astral.sh/uv/)

<!-- endsection -->

<!-- section: support -->

## Support

For issues or questions:

1. Check this documentation
1. Review ADR-009 for architectural details
1. Open an issue on GitHub
1. Contact the RefactorBuddy team

<!-- endsection -->

<!-- endfile -->
