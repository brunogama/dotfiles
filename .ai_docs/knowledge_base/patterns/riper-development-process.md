RIPER Method

Context You are tasked with implementing a development story using the RIPER method (Research, Identify, Plan, Execute,
Review). This systematic approach ensures thorough analysis, proper planning, and effective execution while
maintaining code quality and architectural integrity. Instructions Step 1: Research Phase Action: Conduct
comprehensive research on the requirements, existing codebase, and technical constraints. Objective: Gather all
necessary information to understand the problem domain and solution space. Rationale: Thorough research prevents
architectural misalignments and reduces implementation risks. Example: Search the codebase for related features and
existing implementations, analyze documentation and requirements to understand dependencies and integration points. Step
2: Identify Dependencies and Constraints Action: Map all technical dependencies, architectural constraints, and
integration points. Objective: Create a complete dependency graph and constraint matrix for the implementation.
Rationale: Early identification of constraints prevents late-stage refactoring and technical debt. Example: Analyze
package dependencies using swift package show-dependencies, examine architectural boundaries, and document integration
requirements. Step 3: Plan Implementation Strategy Action: Design a detailed implementation plan with clear milestones,
testing strategy, and rollback procedures. Objective: Establish a systematic approach that minimizes risk and maximizes
code quality. Rationale: Structured planning reduces implementation time and ensures comprehensive test coverage.
Example: Create implementation phases: (1) Core logic with unit tests, (2) Integration points with integration tests,
(3) UI/API layer with end-to-end tests. Step 4: Execute Implementation Action: Implement the solution
following established coding standards and best practices. Objective: Deliver working, tested code that meets all
requirements and maintains system integrity. Rationale: Disciplined implementation ensures code quality while
maintaining development velocity. Example: Write comprehensive unit tests for each component, implement
features incrementally with continuous testing, and maintain clean commit history with meaningful messages. Step 5:
Review and Validate Action: Conduct comprehensive code review, performance validation, and integration testing.
Objective: Ensure the implementation meets all requirements and maintains system integrity. Rationale: Systematic review
catches issues before production deployment and validates architectural decisions. Example: Run performance benchmarks
with comprehensive test suites, validate integration points, and conduct security review to ensure no regressions in
related components.
