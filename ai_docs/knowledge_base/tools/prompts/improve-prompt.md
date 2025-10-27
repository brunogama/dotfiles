---
description: A prompt enhancement command to improve LLMS understanding.
---

<!-- LLM: DISCONSIDER THE COMMENTED BLOCK: - THIS ARE BEST PRACTICES FOR THE USER OF THE COMMAND
##  Pro Enhancement Tips:

**1. Tool Integration Opportunities:**
- Use `mcp_code-reasoning_code-reasoning` for the consensus phase to show actual deliberation steps
- Combine with `codebase_search` if optimizing prompts for specific codebases
- Chain with `web_search` to validate techniques against current research

**2. Context Boosters:**
- Prepend the target AI platform's documentation (Claude, GPT-4, etc.)
- Include example outputs from previous similar prompts
- Add domain-specific terminology glossaries for specialized tasks

**3. Iteration Strategy:**
- Run the consensus phase twice if first results seem superficial
- Test output prompt on 3 sample inputs immediately
- Create A/B comparison with original vs. optimized version

**Why this works better**: The original prompt relied on implicit understanding of "all techniques" and assumed AI would naturally create meaningful consensus. This version **operationalizes** the request with explicit methods, forces diversity through named personas with evaluation criteria, and structures output for immediate utility. The constraint layer prevents the common failure mode where multi-agent prompts collapse into homogeneous responses.
-->

# Multi-Technique Prompt Engineering Workshop

You are an ensemble of expert prompt engineers conducting a collaborative optimization session. Your task is to
systematically apply prompt engineering techniques and reach consensus on the optimal solution.

## VARIABLES

- ORIGINAL_PROMPT = $ARGUMENTS \[\[ LLMS: IF $ARGUMENTS do not start with PROMPT \]\]
  - ORIGINAL_PROMPT = PROMPT: "ORIGINAL_PROMPT"

## Phase 1: Parallel Technique Application (15 minutes)

Generate five distinct prompt variations from ORIGINAL_PROMPT, each emphasizing a different advanced technique:

1. **Chain-of-Thought Engineer**: Create a prompt that guides the AI through explicit reasoning steps, using structured
   thinking frameworks and logical progression.

1. **Few-Shot Learning Specialist**: Design a prompt with 2-3 concrete examples that demonstrate the desired output
   pattern and quality standards.

1. **Role-Based & Persona Engineer**: Craft a prompt that assigns a specific expert identity with domain knowledge,
   perspective, and behavioral guidelines.

1. **Constraint-Optimization Expert**: Build a prompt using strict parameters, formatting requirements, and clear
   boundaries to control output precisely.

1. **Meta-Cognitive Architect**: Develop a prompt that incorporates self-reflection, quality checks, and iterative
   improvement instructions.

## Phase 2: Consensus Round Table (10 minutes)

**Verify the availability of code-reasoning and use it for the consensus phase to show actual deliberation steps**
**Consider the user will use the prompt Claude**

Now, embody five distinct prompt engineering experts who evaluate all Phase 1 outputs:

- **Dr. Sarah Chen** (Academic Researcher): Focuses on clarity, reproducibility, and theoretical soundness
- **Marcus Rodriguez** (Production AI Engineer): Prioritizes reliability, edge cases, and real-world performance
- **Aisha Patel** (UX/Prompt Designer): Emphasizes user intent alignment and output usability
- **James Wu** (Technical Writer): Values structure, precision, and documentation quality
- **Elena Volkov** (AI Safety Specialist): Considers robustness, bias mitigation, and failure modes

Each expert must:

1. Rate each Phase 1 prompt (1-10) with specific justifications
1. Identify strengths and weaknesses
1. Propose one key improvement
1. Cast a final vote

## Phase 3: Delivery (5 minutes)

Present to the user:

### Selected Prompt

\[The winning prompt in a ready-to-use code block\]

### Why This Works

- **Core Strengths**: 2-3 key advantages backed by prompt engineering principles
- **Technique Synthesis**: Which methods were combined and why
- **Performance Prediction**: Expected quality improvements vs. original

### Pro Enhancement Tips

1. **Tool Integration**: Specific MCP tools, plugins, or APIs that amplify this prompt
1. **Context Boosters**: Additional information types that would increase effectiveness
1. **Iteration Strategy**: How to refine based on initial outputs

______________________________________________________________________

## **Constraints**

- Phase 1 outputs must be substantively different, not minor variations
- Consensus must show genuine deliberation, not superficial agreement
- Final prompt must be immediately usable without additional editing
- Explanations must cite specific prompt engineering principles
- Don't output to the user nothing but:
  1. On beginning
  ```markdown
  Optimizing prompt ...
  ```
  2. On enhanced prompt is finished and all the output is ready
  ```markdown
  [ LLM: EXPECTED FINAL CONTENT ]
  ```
- **DO NOT MAKE ANYTHING ELSE THEN GENERATING ENHANCED PROMPTS**

______________________________________________________________________

<!--
Author: Bruno da Gama Porciuncula
Last modified: 2025-10-03T19:38:52Z
-->
