# Custom Commands and Pre-defined Prompts in Kiro

**Source**: https://kiro.dev/docs/hooks/ and related pages  
**Last Updated**: 2025-10-13

## Overview

Kiro provides two main mechanisms for creating custom commands and pre-defined prompts:

1. **Agent Hooks** - Automated triggers that execute predefined prompts when specific events occur
2. **Steering Files** - Persistent project knowledge that can be manually included in conversations

## Agent Hooks - Custom Automated Commands

Agent Hooks are powerful automation tools that execute predefined agent actions when specific events occur in your IDE.

### How Agent Hooks Work

The Agent Hook system follows a three-step process:

1. **Event Detection**: The system monitors for specific events in your IDE
2. **Prompt Execution**: When an event occurs, a predefined prompt is sent to the agent
3. **Automated Action**: The agent processes the prompt and performs the requested actions

### Hook Types

#### 1. On File Create
Trigger when new files matching specific patterns are created.

**Use Cases:**
- Generate boilerplate code for new components
- Add license headers to new files
- Set up test files when creating implementation files

**Example: React Component Setup**
```
When a new React component file is created, add:
1. Import statements for React and necessary hooks
2. A functional component with TypeScript props interface
3. Export statement
4. Basic styling if applicable
5. A skeleton test file in the appropriate directory
```

#### 2. On File Save
Trigger when files matching specific patterns are saved.

**Use Cases:**
- Run linting and formatting
- Update related files
- Generate documentation
- Run tests for changed files

**Example: Update Test Coverage**
```
When a JavaScript/TypeScript file is saved:
1. Identify the corresponding test file
2. Update tests to maintain coverage for any new functions
3. Run the tests to verify they pass
4. Update any snapshots if necessary
```

#### 3. On File Delete
Trigger when files matching specific patterns are deleted.

**Use Cases:**
- Clean up related files
- Update import references in other files
- Maintain project integrity

**Example: Clean Up References**
```
When a component file is deleted:
1. Find all imports of this component across the codebase
2. Remove or comment out those import statements
3. Suggest replacements if appropriate
```

#### 4. Manual Trigger
Manually execute a hook - **This is the closest to custom commands!**

**Use Cases:**
- On-demand code reviews
- Documentation generation
- Security scanning
- Performance optimization

**Example: Code Review Button**
```
Review the current file for:
1. Code quality issues
2. Potential bugs
3. Performance optimizations
4. Security vulnerabilities
5. Accessibility concerns
```

### Creating Agent Hooks

#### Using the Explorer View
1. Navigate to the **Agent Hooks** section in the Kiro panel
2. Click the **+** button to create a new hook
3. Define the hook workflow using natural language in the input field
4. Press **Enter** or click **Submit** to proceed
5. Configure the hook settings and save

#### Using the Command Palette
1. Open the command palette with `Cmd + Shift + P` (Mac) or `Ctrl + Shift + P` (Windows/Linux)
2. Type `Kiro: Open Kiro Hook UI`
3. Follow the on-screen instructions to create your hook

### Hook Examples

#### Security Pre-Commit Scanner
**Trigger Type:** File Save  
**Target:** `**/*`

```
Review changed files for potential security issues:
1. Look for API keys, tokens, or credentials in source code
2. Check for private keys or sensitive credentials
3. Scan for encryption keys or certificates
4. Identify authentication tokens or session IDs
5. Flag passwords or secrets in configuration files
6. Detect IP addresses containing sensitive data
7. Find hardcoded internal URLs
8. Spot database connection credentials

For each issue found:
1. Highlight the specific security risk
2. Suggest a secure alternative approach
3. Recommend security best practices
```

#### Internationalization Helper
**Trigger Type:** File Save  
**Target:** `src/locales/en/*.json`

```
When an English locale file is updated:
1. Identify which string keys were added or modified
2. Check all other language files for these keys
3. For missing keys, add them with a "NEEDS_TRANSLATION" marker
4. For modified keys, mark them as "NEEDS_REVIEW"
5. Generate a summary of changes needed across all languages
```

#### Documentation Generator
**Trigger Type:** Manual Trigger

```
Generate comprehensive documentation for the current file:
1. Extract function and class signatures
2. Document parameters and return types
3. Provide usage examples based on existing code
4. Update the README.md with any new exports
5. Ensure documentation follows project standards
```

#### Test Coverage Maintainer
**Trigger Type:** File Save  
**Target:** `src/**/*.{js,ts,jsx,tsx}`

```
When a source file is modified:
1. Identify new or modified functions and methods
2. Check if corresponding tests exist and cover the changes
3. If coverage is missing, generate test cases for the new code
4. Run the tests to verify they pass
5. Update coverage reports
```

### Integration with MCP

Agent Hooks can be enhanced with Model Context Protocol (MCP) capabilities:

1. **Access to External Tools**: Hooks can leverage MCP servers to access specialized tools and APIs
2. **Enhanced Context**: MCP provides additional context for more intelligent hook actions
3. **Domain-Specific Knowledge**: Specialized MCP servers can provide domain expertise

**Example: Validate Figma Design**

**Trigger Type:** File Save Hook  
**Target:** `*.css` `*.html`

```
Use the Figma MCP to analyze the updated html or css files and check that they follow
established design patterns in the figma design. Verify elements like hero sections,
feature highlights, navigation elements, colors, and button placements align.
```

## Steering Files - Manual Custom Prompts

Steering files with **manual inclusion** mode act as pre-defined prompts that can be invoked on-demand.

### Manual Inclusion Mode

Configure a steering file with manual inclusion:

```yaml
---
inclusion: manual
---
```

Files are available on-demand by referencing them with `#steering-file-name` in your chat messages.

### Use Cases for Manual Steering Files

- Specialized workflows
- Troubleshooting guides
- Migration procedures
- Context-heavy documentation that's only needed occasionally

### Example Manual Steering Files

#### Troubleshooting Guide
**File:** `.kiro/steering/troubleshooting-guide.md`

```yaml
---
inclusion: manual
---

# Troubleshooting Guide

When debugging issues in this project:

1. Check the logs in `logs/` directory
2. Verify environment variables are set correctly
3. Ensure all dependencies are installed
4. Check for common issues in KNOWN_ISSUES.md
5. Review recent changes in git history
6. Test in isolation to identify the failing component
```

**Usage in chat:** `#troubleshooting-guide help me debug this error`

#### Performance Optimization
**File:** `.kiro/steering/performance-optimization.md`

```yaml
---
inclusion: manual
---

# Performance Optimization Guidelines

When optimizing code:

1. Profile first - measure before optimizing
2. Focus on hot paths identified by profiling
3. Consider algorithmic improvements before micro-optimizations
4. Use appropriate data structures
5. Minimize allocations in tight loops
6. Cache expensive computations
7. Use lazy evaluation where appropriate
8. Benchmark changes to verify improvements
```

**Usage in chat:** `#performance-optimization optimize this function`

## Context Providers - Built-in Commands

Kiro also provides built-in context providers that act like commands:

| Provider | Description | Example |
|----------|-------------|---------|
| `#codebase` | Find relevant files across project | `#codebase explain authentication` |
| `#file` | Reference specific files | `#auth.ts explain this` |
| `#folder` | Reference folder contents | `#components/ what do we have?` |
| `#git diff` | Reference current Git changes | `#git diff explain changes` |
| `#terminal` | Include terminal output | `#terminal help fix this error` |
| `#problems` | Include all problems | `#problems help resolve these` |
| `#url` | Include web documentation | `#url:https://docs.example.com` |
| `#code` | Include code snippets | `#code:const x = 1; explain` |
| `#repository` | Repository structure map | `#repository how is this organized?` |
| `#current` | Currently active file | `#current explain this` |
| `#steering` | Include steering files | `#steering:standards.md review` |
| `#docs` | Reference documentation | `#docs:api.md explain endpoint` |
| `#mcp` | Access MCP tools | `#mcp:aws-docs configure S3` |

## Best Practices

### For Agent Hooks

1. **Keep prompts focused** - One clear task per hook
2. **Use clear language** - Write instructions as if explaining to a colleague
3. **Include context** - Reference relevant files or patterns
4. **Test thoroughly** - Verify hooks work as expected before relying on them
5. **Document purpose** - Add comments explaining why the hook exists

### For Manual Steering Files

1. **Use descriptive names** - Make it clear what the file contains
2. **Keep them specialized** - Don't create catch-all files
3. **Update regularly** - Keep content current with project changes
4. **Include examples** - Show how to use the guidance
5. **Link to files** - Use `#[[file:path]]` to reference live code

## RefactorFlow Application

For RefactorFlow, we can create custom hooks and manual steering files:

### Suggested Manual Hooks

1. **Swift 6 Code Review** - Manual trigger for comprehensive Swift 6 concurrency review
2. **Tuist Validation** - Manual trigger to validate Tuist manifests
3. **SOLID Compliance Check** - Manual trigger for architecture review
4. **Pre-commit Validation** - File save hook for pre-commit checks

### Suggested Manual Steering Files

1. `.kiro/steering/swift6-migration.md` - Swift 6 migration patterns
2. `.kiro/steering/refactoring-patterns.md` - RefactorFlow-specific patterns
3. `.kiro/steering/troubleshooting.md` - Common issues and solutions
4. `.kiro/steering/performance-optimization.md` - Performance guidelines

## Summary

**For Custom Commands:**
- Use **Manual Trigger Hooks** for on-demand commands
- Create hooks via Agent Hooks section in Kiro panel
- Write natural language instructions for what the command should do

**For Pre-defined Prompts:**
- Use **Manual Inclusion Steering Files** for reusable prompts
- Reference with `#steering-file-name` in chat
- Store in `.kiro/steering/` directory

Both mechanisms provide powerful ways to create custom, reusable commands and prompts tailored to your project's needs.
