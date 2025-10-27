---
description: Convert text into LLM-optimized YAML format with systematic analysis and validation
inputs: [text_input]
---

# YAML Notation Optimization for LLM Processing

## Variables

- INPUT_TEXT: $1
- CWD: execute `realpath .`
- TIMESTAMP: execute `date +%Y-%m-%d_%H-%M-%S`
- YAML_VALIDATOR: execute `command -v yq || echo 'yq_not_found'`

## Workflow

### Phase 1: Analysis

- Parse INPUT_TEXT to identify data elements and relationships
- Extract key-value pairs, lists, and hierarchical structures
- Identify redundant or ambiguous information

### Phase 2: Design

- Create flat YAML schema (maximum 2 nesting levels)
- Apply snake_case naming convention to all keys
- Normalize data types and formats

### Phase 3: Optimization

- Remove redundancy while preserving essential information
- Convert complex structures to explicit key-value pairs
- Ensure all text values are properly quoted

### Phase 4: Validation

- Verify YAML syntax validity
- Confirm no ambiguous relationships exist
- Validate complete information preservation

## Instructions

Transform any text input into LLM-optimized YAML following these constraints:

**Structure Requirements:**

- Maximum 2 levels of nesting
- Explicit keys for all data elements
- Snake_case for all keys
- Quoted strings for all text values
- Lists for repeated elements

**Content Requirements:**

- Remove all redundancy
- Preserve essential information
- Normalize data formats
- Single code block output

**Quality Standards:**

- Valid YAML syntax
- No ambiguous relationships
- Complete information preservation
- LLM-ready format

**Tool Integration:** Use DesktopCommander MCP for all file operations with absolute paths and minimum 10000ms timeout.

## Example Patterns

### Requirements Document

**Input:** "The system must support user authentication with secure password policies and role-based access control."

**Output:**

```yaml
system_requirements:
  authentication:
    enabled: true
    password_policy:
      security_level: "high"
    access_control:
      type: "role_based"
```

### Configuration Data

**Input:** "Database connection: host=localhost, port=5432, user=admin, password=secret123, ssl=true"

**Output:**

```yaml
database_config:
  host: "localhost"
  port: 5432
  user: "admin"
  password: "secret123"
  ssl_enabled: true
```

### Process Instructions

**Input:** "To deploy: 1) Build the application, 2) Run tests, 3) Deploy to staging, 4) Run integration tests, 5) Deploy
to production"

**Output:**

```yaml
deployment_process:
  steps:
    - action: "build"
      target: "application"
    - action: "test"
      scope: "unit"
    - action: "deploy"
      environment: "staging"
    - action: "test"
      scope: "integration"
    - action: "deploy"
      environment: "production"
```

## Report

```text
YAML Optimization Summary:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Input Length: {{input_length}} characters
 Structure Levels: {{nesting_levels}}
 Optimizations Applied: {{optimization_count}}
[YES] Syntax Valid: {{syntax_valid}}
 LLM Ready: {{llm_ready}}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Quality Checklist

Before finalizing, verify:

- [ ] All data elements have explicit keys
- [ ] Structure is flat and LLM-parseable
- [ ] No redundancy or ambiguity
- [ ] Valid YAML syntax
- [ ] Complete information preservation
- [ ] Ready for immediate LLM consumption
