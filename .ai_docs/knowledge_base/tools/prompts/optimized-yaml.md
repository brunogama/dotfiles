# YAML Notation Optimization for LLM Processing

**Context:** You are tasked with converting a block of text into a YAML notation that is ultra optimized for large
language model (LLM) consumption. The YAML output must maximize parsing efficiency, minimize ambiguity, and ensure all
information is structured for rapid, lossless ingestion by LLMs. The YAML must be concise, use explicit keys, and avoid
redundancy. All shell commands for any file or system operations must be routed through the DesktopCommander MCP server
with explicit timeouts.

**DesktopCommander MCP Setup:**

- All shell commands must be executed via DesktopCommander MCP functions.
- Use absolute file paths and specify timeouts (minimum 10000ms for simple commands).
- Never run shell commands directly.

**Instructions:**

Step 1: Analyze the Input Text

- Action: Read and analyze the provided text to identify all distinct data elements, logical groupings, and
  relationships.
- Objective: Ensure all relevant information is captured and structured.
- Rationale: Proper analysis is required to avoid information loss or misrepresentation.
- Example: For a requirements document, identify sections, requirements, and metadata.
- MCP Routing: If reading from a file, use mcp_desktop-commander_read_file(path, length=1000).

Step 2: Define a Flat, Explicit YAML Schema

- Action: Design a YAML schema that uses explicit, descriptive keys for each data element, avoiding nested or ambiguous
  structures unless necessary.
- Objective: Maximize LLM parsing speed and minimize confusion.
- Rationale: Flat, explicit schemas are easier for LLMs to tokenize and process.
- Example:
  ```yaml
  title: "Project Requirements"
  requirements:
    - id: 1
      description: "User login must be secure"
      priority: "high"
  ```
- MCP Routing: No shell command required.

Step 3: Normalize and Tokenize Data

- Action: Convert all data into normalized, token-friendly formats (e.g., lowercase keys, snake_case, quoted strings for
  text, lists for repeated items).
- Objective: Ensure consistency and reduce LLM tokenization errors.
- Rationale: Normalized data improves LLM comprehension and reduces ambiguity.
- Example:
  ```yaml
  user_name: "john_doe"
  access_rights:
    - "read"
    - "write"
  ```
- MCP Routing: No shell command required.

Step 4: Remove Redundancy and Irrelevant Content

- Action: Exclude any duplicate, irrelevant, or non-informative content from the YAML output.
- Objective: Minimize YAML size and maximize information density.
- Rationale: LLMs process smaller, denser YAML more efficiently.
- Example: Omit repeated explanations or boilerplate.
- MCP Routing: No shell command required.

Step 5: Output the YAML in a Single Code Block

- Action: Present the final YAML as a single, properly indented code block.
- Objective: Ensure the output is ready for direct ingestion by downstream LLMs or tools.
- Rationale: Proper formatting is required for lossless parsing.
- Example:
  ```yaml
  key1: "value1"
  key2: "value2"
  ```
- MCP Routing: If writing to a file, use mcp_desktop-commander_write_file(path, content, mode="rewrite").

Shell Command Reference:

- mcp_desktop-commander_read_file(path, length=1000): Read file contents.
- mcp_desktop-commander_write_file(path, content, mode): Write YAML output to file.

**Final Notes:**

- Always use absolute paths for file operations.
- Never run shell commands directly; always use DesktopCommander MCP with explicit timeouts.
- Ensure YAML output is as flat, explicit, and concise as possible for optimal LLM performance.
- Validate YAML syntax before outputting.
