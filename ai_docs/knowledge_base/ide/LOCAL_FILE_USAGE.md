# Knowledge Base Local File Support - Quick Reference

## Overview

The Knowledge Base now supports local files via `file://` URLs, enabling you to import documentation from your local
filesystem.

## Supported File Types

| Extension            | Processing            |
| -------------------- | --------------------- |
| `.html`, `.htm`      | Converted to Markdown |
| `.md`, `.markdown`   | Used as-is            |
| Other (`.txt`, etc.) | Treated as plain text |

## Usage

### Command Line

```bash
# Local HTML file
uv run Tooling/KnoledgeBase/kb-tools/fetch_kb_source.py \
  --url file:///absolute/path/to/file.html \
  --output local/docs

# Local Markdown file
uv run Tooling/KnoledgeBase/kb-tools/fetch_kb_source.py \
  --url file:///absolute/path/to/README.md \
  --output local/readme
```

### Shell Function

```bash
# Absolute path
kb-crawl file:///Users/bruno/docs/guide.html local/guides

# Relative path (from current directory)
kb-crawl file://./docs/local-guide.html local/guides
```

### Makefile

```bash
make kb-fetch \
  URL=file:///Users/bruno/docs/guide.html \
  OUTPUT=local/guides
```

## Platform-Specific Paths

### macOS/Linux

```bash
file:///Users/bruno/docs/guide.html
file:///home/user/docs/guide.html
file://./relative/path/guide.html
```

### Windows

```bash
file:///C:/Users/bruno/docs/guide.html
file:///D:/Projects/docs/guide.html
```

## Examples

### Import Local HTML Documentation

```bash
# Convert local HTML docs to KB format
kb-crawl file:///Users/bruno/Downloads/api-docs.html dependencies/api
```

### Import Project README

```bash
# Add project README to KB
kb-crawl file://./README.md project/readme
```

### Import Multiple Files

```bash
# Import a series of local docs
kb-crawl file:///docs/intro.html local/intro
kb-crawl file:///docs/guide.html local/guide
kb-crawl file:///docs/api.html local/api
```

## Output Format

Local files produce the same output as remote URLs:

```markdown
---
title: "Document Title"
source_url: "file:///path/to/file.html"
last_fetched: "2025-10-12T10:30:00+00:00"
checksum: "sha256:abc123..."
type: "official_documentation"
fetch_method: "local_file"
---

<!-- file: document-title.md -->

# Document Title

<!-- section: introduction -->
## Introduction

Content here...

<!-- endsection -->

<!-- endfile -->
```

## Advantages

[YES] **Fast**: No network latency [YES] **Offline**: Works without internet [YES] **Private**: Keep sensitive docs local [YES]
**Versioned**: Import specific file versions [YES] **Flexible**: Any HTML/Markdown file

## Limitations

[WARNING] **No JavaScript**: Static HTML only (no dynamic content) [WARNING] **No Crawling**: Single file only (no link following) [WARNING]
**No Updates**: Manual re-import needed for changes

## Troubleshooting

### File Not Found

```
[NO] File not found: /path/to/file.html
```

**Solution**: Check path is absolute and file exists

### Permission Denied

```
[NO] Failed to read file: Permission denied
```

**Solution**: Check file permissions (`chmod +r file.html`)

### Empty File

```
[NO] File is empty or contains no content
```

**Solution**: Verify file has content

### Encoding Issues

```
[WARNING]  File read with latin-1 encoding
```

**Info**: File wasn't UTF-8, used fallback encoding (usually fine)

## Best Practices

1. **Use Absolute Paths**: More reliable than relative
1. **Check File First**: Verify file exists before importing
1. **Organize Output**: Use descriptive output directories
1. **Document Source**: Note where local files came from
1. **Version Control**: Consider committing imported files

## Integration with Existing Workflow

Local file support integrates seamlessly:

```bash
# Mix local and remote sources
kb-crawl https://docs.swift.org/swift-book/ swift/language
kb-crawl file:///Users/bruno/custom-guide.html swift/custom

# Validate all together
kb-validate

# Check status
kb-status
```

## Use Cases

### 1. Import Downloaded Documentation

```bash
# Download docs offline, then import
wget https://example.com/docs.html
kb-crawl file://./docs.html local/example
```

### 2. Import Generated Documentation

```bash
# Generate docs with tool, then import
jazzy --output docs/
kb-crawl file://./docs/index.html project/api
```

### 3. Import Legacy Documentation

```bash
# Import old HTML docs to KB format
kb-crawl file:///archive/old-docs.html legacy/docs
```

### 4. Import Private Documentation

```bash
# Keep sensitive docs local, not on web
kb-crawl file:///private/internal-api.html internal/api
```

## FAQ

**Q: Can I import a directory of files?** A: Not yet. Import files individually or write a script to loop.

**Q: Will it follow links in HTML files?** A: No. Only the specified file is imported.

**Q: Can I import PDF files?** A: Not directly. Convert to HTML/Markdown first.

**Q: Does it work with symlinks?** A: Yes, symlinks are followed automatically.

**Q: Can I use `~` for home directory?** A: No, use absolute path: `file:///Users/bruno/...`

## See Also

- [fetch_kb_source.py](../Tooling/KnoledgeBase/kb-tools/fetch_kb_source.py) - Source code
- [KB README](../Tooling/KnoledgeBase/kb-tools/README.md) - Full documentation
- [Implementation Report](.ai_docs/reports/task-summaries/2025-10-12-local-file-support.md) - Technical details
