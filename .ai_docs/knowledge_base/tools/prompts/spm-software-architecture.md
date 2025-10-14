Software Architecture Analysis and Documentation for Root SPM Package

Context: The goal is to perform a comprehensive software architecture analysis of the root Swift Package Manager (SPM)
package for the project located at `/Users/bi002853/Developer/application/`. The deliverable is a Markdown document
following the structure of `ai/templates/my-templates/spm-package-software-structure.md`, to be saved as
`ai/memorybank/snake_cased_main_package_name__-__snake_cased_spm_package_name__-__package_architecture.md`. The analysis
must reflect the actual modular, layered, and Clean Architecture patterns used in the codebase, referencing real
modules, layers, and dependencies.

DesktopCommander MCP Setup: All shell commands, file reads, and writes must be routed through the DesktopCommander MCP
server. Use absolute paths and specify timeouts (≥10000ms for simple commands, ≥60000ms for build/long operations).
Never execute shell commands directly.

Instructions:

Step 1: Identify the Root SPM Package and Its Structure

- Action: Confirm the root SPM package is defined by `/Users/bi002853/Developer/application/Package.swift` and enumerate
  its main modules.
- Objective: Establish the scope and boundaries of the architecture analysis.
- Rationale: The root package aggregates all business domains and shared modules.
- Example: List modules such as Core, CoreFrontend, Cards, CustomerRelationship, DigitalAccount, Insurance, Integrity,
  Marketplace, Investments, Onboarding, Shared, DependencyInjection, InternationalAccount, DigitalCredit.
- MCP Routing: Use `mcp_desktop-commander_read_file` to read `/Users/bi002853/Developer/application/Package.swift`
  (length=1000).

Step 2: Gather Module and Directory Structure

- Action: Recursively list all files and directories under `/Users/bi002853/Developer/application/` excluding .gitignore
  patterns.
- Objective: Map the physical structure of the package and its modules.
- Rationale: Accurate structure is required for the architecture and for referencing in the documentation.
- Example: Use `find /Users/bi002853/Developer/application/ -print`.
- MCP Routing: Use `mcp_desktop-commander_start_process` with
  `command="find /Users/bi002853/Developer/application/ -print"`, `timeout_ms=60000`.

Step 3: Analyze Architectural Patterns and Layering

- Action: Identify and describe the main architectural patterns (e.g., Clean Architecture, MVVM, modularization) and how
  layers are organized (Presentation, Domain, Data, DTO, Entity, Config, Exception, Utility).
- Objective: Document the logical and physical separation of concerns.
- Rationale: This provides clarity on maintainability, extensibility, and testability.
- Example: Reference Clean Architecture, MVVM, Clean Flow, Strategy Pattern, and show how modules like Core, Cards,
  etc., are layered.
- MCP Routing: Use `mcp_desktop-commander_read_file` to read `ai/memorybank/software-architecture-and-patterns.md`
  (length=1000) for existing architectural documentation.

Step 4: Document Module Dependencies and Interactions

- Action: For each main module, describe its dependencies and how it interacts with other modules.
- Objective: Clarify coupling, shared utilities, and cross-module communication.
- Rationale: Understanding dependencies is key for refactoring and onboarding.
- Example: Core provides shared utilities, Cards depends on Core, etc.
- MCP Routing: Use `mcp_desktop-commander_read_file` to read relevant `Package.swift` files for each module (e.g.,
  `/Users/bi002853/Developer/application/Core/Package.swift`).

Step 5: Populate the Documentation Template

- Action: Fill out each section of `ai/templates/my-templates/spm-package-software-structure.md` with project-specific
  details:
  - Overview (purpose, integration, main modules)
  - Architecture (layered organization, module structure)
  - UML Class Diagrams (use Mermeid, adapt to real classes)
  - Sequence Diagrams (show data flow, e.g., UI to persistence)
  - Example Usage (SwiftUI/UIKit integration)
  - Terminology Mapping (Portuguese → English, if relevant)
  - Frameworks & App Types Covered
- Objective: Produce a comprehensive, accurate, and readable architecture document.
- Rationale: Ensures the documentation is actionable and aligned with the codebase.
- Example: Use real module names, directory paths, and class names from the project.
- MCP Routing: Any script or formatting utility must be executed via DesktopCommander MCP.

Step 6: Save the Completed Document

- Action: Write the final Markdown document to
  `/Users/bi002853/Developer/application/ai/memorybank/snake_cased_main_package_name__-__snake_cased_spm_package_name__-__package_architecture.md`.
- Objective: Persist the architecture analysis for future reference and onboarding.
- Rationale: Centralizes architectural knowledge for the team.
- Example: Use `mcp_desktop-commander_write_file` with the full absolute path and `mode="rewrite"`.
- MCP Routing: All file writes must use `mcp_desktop-commander_write_file`.

Shell Command Reference

- `mcp_desktop-commander_read_file(path, length=1000)`: Read file contents.
- `mcp_desktop-commander_start_process(command, timeout_ms)`: Run shell commands/scripts.
- `mcp_desktop-commander_write_file(path, content, mode)`: Write output to file.

Final Notes

- Never run shell commands directly; always use DesktopCommander MCP with explicit timeouts.
- Use absolute paths for all file operations.
- Ensure the output file is named
  `snake_cased_main_package_name__-__snake_cased_spm_package_name__-__package_architecture.md` in the memorybank
  directory.
- Reference real modules, layers, and patterns from the codebase.
- Adapt all template sections to the actual project structure and terminology.
