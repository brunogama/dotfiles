# Quick Plan

Create a detailed implementation plan based on the user's requirements provided through the USER_PROMPT' variable.
Analyze the request, think through the implementation approach, and save a comprehensive specification document to
`PLAN_OUTPUT_DIRECTORY/<name-of-plan>,md`that can be used as a blueprint for actual development work.

## Variables

USER_PROMPT: $ARGUMENTS CWD: run `realpath .` PLAN_OUTPUT_DIRECTORY: CWD/specs/'

## Instructions

- Carefully analyze the user's requirements provided in the USER_PROMPT variable
- Think deeply about the best approach to implement the requested functionality or solve the problem
- Create a concise implementation plan that includes:
  - Clear problem statement and objectives
  - Technical approach and architecture decisions
  - Step-by-step implementation guide
  - Potential challenges and solutions
  - Testing strategy
  - Success criteria
- Generate a descriptive, kebab-case filename based on the main topic of the plan
- Save the complete implementation plan to `PLAN_OUTPUT_DIRECTORY/<descriptive-name>,md`
- Ensure the plan is detailed enough that another developer could follow it to implement the solution
- Include code examples or pseudo-code where appropriate to clarify complex concepts
- Consider edge cases, error handling, and scalability concerns
- Structure the document with clear sections and proper markdown formatting

## Workflow

1.Analyze Requirements- THINK HARD and the USER_PROMPT to understand core problem and desired outcome 2. Design Solution
\- Develop technical approach including architecture decisions and implementation strategy

- Please use tree-of-thought reasoning:
  1. First, generate 3 completely different strategic approaches to this problem
  1. For each approach, outline the specific tactics and expected outcomes
  1. Evaluate the pros/cons of each path
  1. Select the most promising approach

3. Document Plan - Structure a comprehensive markdown document with problem statement, implementation steps,
1. Generate Filename - Create a descriptive kebab-case filename based on the plan's main topic 5. Save & Report - Write
   the plan to `PLAN_OUTPUT_DIRECTORY/<filename>.md` and provide a summary of key components

## Report

After creating and saving the implementation plan, provide a concise report with the following format:

```
Implementation Plan Created

File: PLAN_OUTPUT_DIRECTORY/<filename>.md
Topic: <brief description of what the plan covers>
Key Components:
- <main component 1>
- <main component 2>
- <main component 3>
```
