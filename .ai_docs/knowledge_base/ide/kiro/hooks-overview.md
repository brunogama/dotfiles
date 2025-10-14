---
title: "Kiro Agent Hooks - Overview"
source: "https://kiro.dev/docs/hooks/"
fetched: "2025-10-13"
topics:
  - kiro
  - hooks
  - automation
  - workflow
  - ide
domains:
  - ide/kiro
---

# Hooks

Agent Hooks are powerful automation tools that streamline your development workflow by automatically executing predefined agent actions when specific events occur in your IDE. With hooks, you eliminate the need to manually request routine tasks and ensure consistency across your codebase.

## What are Agent Hooks?

Agent Hooks are automated triggers that execute predefined agent actions when specific events occur in your IDE. Rather than manually asking for routine tasks to be performed, hooks set up automated responses to events such as:

- Saving files
- Creating new files
- Deleting files

Agent Hooks transform your development workflow through intelligent automation. By setting up hooks for common tasks, you can:

- Maintain consistent code quality
- Prevent security vulnerabilities
- Reduce manual overhead
- Standardize team processes
- Create faster development cycles

Whether you're working on a small project or managing a large codebase, Agent Hooks help ensure that routine tasks are handled automatically and consistently, allowing you to focus on building great software.

## How Agent Hooks Work

The Agent Hook system follows a simple three-step process:

1. **Event Detection**: The system monitors for specific events in your IDE
2. **Prompt Execution**: When an event occurs, a predefined prompt is sent to the agent
3. **Automated Action**: The agent processes the prompt and performs the requested actions

This automation flow eliminates repetitive tasks and ensures consistency across your codebase.

## Setting Up Agent Hooks

Creating and managing hooks is straightforward:

### Using the Explorer View

1. Navigate to the **Agent Hooks** section in the Kiro panel
2. Click the **+** button to create a new hook
3. Define the hook workflow using natural language in the input field
4. Press **Enter** or click **Submit** to proceed
5. Configure the hook settings and save

### Using the Command Palette

You can also use the Command Palette to navigate to the Hook UI:

1. Open the command palette with `Cmd + Shift + P` (Mac) or `Ctrl + Shift + P` (Windows/Linux)
2. Type `Kiro: Open Kiro Hook UI`
3. Follow the on-screen instructions to create your hook

## Next Steps

Now that you have created a hook file, you can further learn about hooks here:

- **[Hook Types](https://kiro.dev/docs/hooks/types)** - Learn about different trigger types and their use cases
- **[Management](https://kiro.dev/docs/hooks/management)** - Learn how to organize, edit, and maintain your hooks
- **[Best Practices](https://kiro.dev/docs/hooks/best-practices)** - Follow patterns for effective hook design
- **[Examples](https://kiro.dev/docs/hooks/examples)** - See examples and templates you can use

## Key Benefits

- **Consistency**: Ensure all team members follow the same processes
- **Efficiency**: Automate repetitive tasks to save time
- **Quality**: Maintain code standards automatically
- **Security**: Catch potential issues before they reach production
- **Scalability**: Handle routine tasks across large codebases

## Common Use Cases

- Auto-update tests when code changes
- Maintain translation files across languages
- Run spell-check on documentation
- Validate code formatting on save
- Update dependencies automatically
- Generate documentation from code changes
