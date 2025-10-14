---
description: Execute comprehensive Swift 6 code review with automated issue detection and solution generation
inputs: [[$1]]
---

# Creating Effective Cursor Project Rules

This meta-rule provides comprehensive guidance on creating effective Cursor Project Rules. These are `.mdc` files stored
in your project's `~/.cursor/rules` directory that help the AI understand your specific codebase, conventions, and
preferences. Following these guidelines will help you create rules that are easily understood by both humans and the AI,
leading to more consistent and helpful AI interactions.

## What are Cursor Project Rules?

Project Rules are the recommended way to provide persistent, project-specific instructions to Cursor's AI. They live
alongside your code (in `~/.cursor/rules/`) and are automatically activated when files matching their defined patterns
(`globs`) are referenced in chat or other AI features.

Think of them as a structured knowledge base for your project, teaching the AI:

- Coding conventions and style guides
- Architectural patterns
- API usage and interfaces
- Domain-specific knowledge
- Your personal or team preferences

## Rule File Structure

While flexible, a well-structured rule file improves clarity for both humans and the AI. Consider including the
following components:

### 1. YAML Frontmatter (Crucial)

**Placement:** The YAML frontmatter block (`--- ... ---`) **must** be the absolute first content in the file. Any
leading spaces, lines, or characters can prevent the rule from loading correctly.

```yaml
---
description: Guidelines for [what this rule covers and its purpose, e.g., structuring functional React components]
globs: pattern/to/match/files/**/*.ext # See examples below
alwaysApply: false # Optional: Set to true to always include this rule
---
```

- **`description`**: A concise, semantic description. Start with phrases like "Guidelines for..." or "Instructions
  on..." This likely helps Cursor automatically select the most relevant rule when multiple match.
- **`globs`**: File pattern(s) that trigger this rule's automatic activation. Be specific. Examples:
  - `src/components/**/_.tsx,src/components/**/_.jsx` (React components)
  - `src/server/api/**/_.ts` (Server API routes)
  - `_.json,_.yaml,_.yml` (Configuration files)
  - `src/utils/!(test).ts` (Utility files, excluding tests)
  - `package.json,pnpm-lock.yaml` (Specific root files)
- **`alwaysApply`** (Optional, defaults to `false`): If `true`, the rule is included in context regardless of the files
  being referenced.

### 2. Content Sections (Recommended Structure)

Organize the rule's content logically. Using markdown headings (`##`, `###`) is recommended.

#### Introduction / Problem

- Briefly explain _what_ problem this rule solves or _what_ pattern it defines.
- Explain *why* this pattern/convention is important for this project.
- Mention _when_ this rule is typically relevant.

#### Pattern Description

- Clearly document the recommended pattern(s) or conventions.
- Use text explanations combined with clear code examples (using language-specific fenced code blocks).
- Highlight key components, functions, or concepts involved.
- If applicable, link to other relevant rules: `@See API Conventions`

#### Implementation Steps (If Applicable)

- Provide a clear, step-by-step guide if the rule describes a process.
- Use ordered lists.
- Identify decision points or variations.

#### Real-World Examples (Highly Recommended)

If the rule is clearly specific to just the current repository, reference instances of correct adherence to the rule:

- Link to _actual code_ in the current repository using relative paths: `@Example Button`.
- Briefly explain *why* the linked code is a good example of the rule.
- Keep examples focused on the rule being described.

If the rule is a generic rule that can or will apply to many repositories, inline a single comprehensive example.

#### Common Pitfalls / Anti-Patterns

- List common mistakes or deviations related to this rule.
- Explain how to recognize these issues.
- Suggest how to fix or avoid them.

**Note:** Adapt this structure based on the rule's complexity. Simpler rules might only need frontmatter and a brief
description or a few key points.

## Advanced Features

### File References (`@file`)

If the rule is clearly specific to just the current repository, include critical context files directly within your rule
using the `@file` directive. Place these *after* the frontmatter but ideally *before* the main content.

```markdown
@file ../tsconfig.json
@file ../package.json
@file ./docs/ARCHITECTURE.md
```

- Use relative paths from the rule file's location (`.cursor/rules/`).
- These files will be added to the context *whenever this rule is activated*, providing consistent background
  information to the AI.
- Use sparingly for essential files (configs, core types, architectural overviews) to avoid excessive context.

### Code Blocks

Always use fenced code blocks with language specifiers for correct rendering and syntax highlighting:

````markdown
```typescript
function greet(name: string): string {
 // Correctly formatted TypeScript
 return `Hello, ${name}!`;
}
```
````

## Rule Activation and Interaction

- **Specificity:** More specific `globs` patterns are generally preferred to avoid unintended rule overlaps. If rules
  overlap, the exact selection logic isn't documented, but clearer descriptions and more specific globs likely lead to
  better results.
- **Modularity:** Break down complex domains (like your entire backend) into smaller, more focused rules (e.g.,
  `api-routing.mdc`, `database-models.mdc`, `auth-middleware.mdc`) rather than creating one monolithic rule.
- **Avoid Overload:** A rule's activation should be as narrow as it can possibly be. The more rules an Agent can
  consider, the more likely it is to miss something.

Choose your rule's matcher type based on its purpose and scope. The choice affects both when the rule activates and how
much context it consumes:

- **Global Rules:** Always apply to every request
- **Automatic Rules:** Always apply to every request involving files that match the globs
- **Agent-Requested Rules:** The Agent may choose to read a rule, based on the rule's decription and task at hand
- **Manual Rules:** Only ever read when a human introduces them to a request's context

### Global Rules

- **Use for:** Critical, universal rules that must always be considered
- **Context impact:** ALWAYS consumes AI context
- **Best practices:**
  - Keep rules very concise
  - Use sparingly
  - Only for essential, universal guidelines

```yaml
---
description:
globs:
alwaysApply: true
---
```

### Automatic Rules

- **Use for:** Universal guidance for specific file types
- **Context impact:** Activates when working with matching files
- **Best practices:**
  - Use sparingly
  - Only include guidance that applies to all files of that type
  - ✅ Good: `globs: **/*.js`: "JavaScript style guide"
  - ❌ Bad: `globs: **/*.js`: "How to properly use React hooks"

```yaml
---
description:
globs: **/*.js,**/*.ts
alwaysApply: false
---
```

### Agent-Requested Rules

- **Use for:** Detailed guidance for specific tasks
- **Context impact:** AI may choose to consult the rule if it determines the rule applies.
- **Best practices:**
  - Can be more verbose
  - Focus on specific outcomes
  - Include detailed examples
  - Description is used to attach the rule, so it must be clear & concise

```yaml
---
description: Guidance for <outcome> when doing <task>
globs:
alwaysApply: false
---
```

### Manual Rules

- **Use for:** Guidance requiring explicit human activation/oversight; highly situational instructions; verbose
  procedures or knowledge dumps not suitable for automatic inclusion.
- **Context impact:** Only consumes context when explicitly invoked by a user. Never automatically included.
- **Best practices:**
  - Can be highly verbose and detailed.
  - Ensure `alwaysApply: false`.
  - `globs` are not used for activation.

```yaml
---
description:
globs:
alwaysApply: false
---
```

## Best Practices

- **Start Simple, Iterate:** Don't aim for perfection immediately. Start with basic rules for core conventions and
  add/refine them over time as you observe the AI's behavior and identify gaps.
- **Be Specific but Flexible:** Provide clear, actionable guidance with concrete examples. Use recommending language
  ("prefer", "consider", "typically") rather than overly rigid commands ("must", "always") unless a strict convention is
  required. Explain the *why* behind rules.
- **Focus on Patterns:** Rules should define repeatable patterns, conventions, or project knowledge, not fix one-off
  bugs.
- **Keep Rules Updated:** Regularly review rules. Update them when conventions change or code evolves. *Delete* rules
  that become obsolete or if the AI consistently follows the pattern without the rule.
- **Trust the LLM (to an extent):** While rules provide guidance, allow the LLM some flexibility. It can often infer
  patterns from the existing codebase, especially as it grows.
- **Troubleshooting:** If rules aren't activating as expected, double-check:
  - The YAML frontmatter is the _absolute first_ content in the file.
  - The `globs` pattern correctly matches the intended files.
  - File paths in `@file` directives are correct.
  - The `.mdc` file encoding is standard (UTF-8).

## Team Collaboration

- **Version Control:** Commit the `.cursor/rules` directory to your repository so rules are shared and versioned
  alongside your code.
- **Conventions:** Establish team conventions for naming, structuring, and updating rules.
- **Review Process:** Consider code reviews for changes to important rules.
- **Onboarding:** Use rules as living documentation to help onboard new team members to project standards.
- **Shared vs. Personal:** If needed, establish naming conventions (e.g., `_personal-_.mdc`) and potentially use
  `.gitignore` within `.cursor/rules` to separate team-wide rules from personal experimental ones.

## Full Rule Example

````markdown
---
description: Guidelines for structuring functional React components using TypeScript, including prop definitions, state management, and hook usage.
globs:
alwaysApply: false
---

@file ../../tsconfig.json
@file ../../tailwind.config.js

# React Functional Component Structure

## Introduction

This rule defines the standard structure for functional React components in this project to ensure consistency, readability, and maintainability. We use TypeScript for type safety and prefer hooks for state and side effects.

## Pattern Description

Components should generally follow this order:

1. `'use client'` directive (if needed)
2. Imports (React, libs, internal, types, styles)
3. Props interface definition (`ComponentNameProps`)
4. Component function definition (`function ComponentName(...)`)
5. State hooks (`useState`)
6. Other hooks (`useMemo`, `useCallback`, `useEffect`, custom hooks)
7. Helper functions (defined outside or memoized inside)
8. `useEffect` blocks
9. Return statement (JSX)

```typescript
'use client' // Only if browser APIs or hooks like useState/useEffect are needed

import React, { useState, useEffect, useCallback } from 'react';
import { cn } from '@/lib/utils'; // Example internal utility
import { type VariantProps, cva } from 'class-variance-authority';

// Define props interface
interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement>, VariantProps<typeof buttonVariants> {
 isLoading?: boolean;
}

// Define component
function Button({ className, variant, size, isLoading, children, ...props }: ButtonProps): React.ReactElement {
 // State hooks
 const [isMounted, setIsMounted] = useState(false);

 // Other hooks
 const handleClick = useCallback((event: React.MouseEvent<HTMLButtonElement>) => {
 if (isLoading) {
 event.preventDefault();
 return;
 }
 props.onClick?.(event);
 }, [isLoading, props.onClick]);

 // Effects
 useEffect(() => {
 setIsMounted(true);
 }, []);

 // Conditional rendering logic can go here

 // Return JSX
 return (
 <button
 className={cn(buttonVariants({ variant, size, className }))}
 disabled={isLoading}
 onClick={handleClick}
 {...props}
 >
 {isLoading ? 'Loading...' : children}
 </button>
 );
}

// Example variant definition (could be in the same file or imported)
const buttonVariants = cva(
 'inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:opacity-50 disabled:pointer-events-none ring-offset-background',
 {
 variants: {
 variant: {
 default: 'bg-primary text-primary-foreground hover:bg-primary/90',
 // ... other variants
 },
 size: {
 default: 'h-10 py-2 px-4',
 // ... other sizes
 },
 },
 defaultVariants: {
 variant: 'default',
 size: 'default',
 },
 }
);

export { Button, buttonVariants }; // Prefer named exports
```

## Implementation Steps

1. Define a clear `interface` for props.
2. Use standard React hooks for state and side effects.
3. Keep components focused on a single responsibility.
4. Use named exports for components.

## Real-World Examples

* @Standard Button Component
* @Complex Card Component

## Common Pitfalls

* Forgetting `'use client'` when using hooks like `useState` or `useEffect`.
* Defining helper functions directly inside the component body without `useCallback` (can cause unnecessary re-renders).
* Overly complex components; consider breaking them down.
* Not using TypeScript for props or state.

````

## Minimal Rule Template

Use this as a quick starting point for new rules:

```markdown
---
description: Guidelines for [purpose]
globs: [pattern]
alwaysApply: false
---

# [Rule Name]

## Introduction / Problem

[Why this rule exists and what problem it solves.]

## Pattern Description

[Explain the pattern with code examples.]

## Real-World Examples

* @Link to code

## Common Pitfalls

* [Common mistake 1]
* [Common mistake 2]

```
