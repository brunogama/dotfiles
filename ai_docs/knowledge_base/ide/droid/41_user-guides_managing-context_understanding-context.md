# https://docs.factory.ai/user-guides/managing-context/understanding-context

[Skip to main content](https://docs.factory.ai/user-guides/managing-context/understanding-context#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Understanding Context in Factory
[Welcome](https://docs.factory.ai/welcome)[CLI](https://docs.factory.ai/cli/getting-started/overview)[Web Platform](https://docs.factory.ai/web/getting-started/overview)[Onboarding](https://docs.factory.ai/onboarding)[Pricing](https://docs.factory.ai/pricing)[Changelog](https://docs.factory.ai/changelog/1-8)
  * [GitHub](https://github.com/factory-ai/factory)
  * [Discord](https://discord.gg/EQ2DQM2F)


##### Welcome
On this page
  * [What is Context?](https://docs.factory.ai/user-guides/managing-context/understanding-context#what-is-context%3F)
  * [How Context Works](https://docs.factory.ai/user-guides/managing-context/understanding-context#how-context-works)
  * [Context Limits and Optimization](https://docs.factory.ai/user-guides/managing-context/understanding-context#context-limits-and-optimization)
  * [Understanding Token Limits](https://docs.factory.ai/user-guides/managing-context/understanding-context#understanding-token-limits)
  * [Best Practices for Context Management](https://docs.factory.ai/user-guides/managing-context/understanding-context#best-practices-for-context-management)
  * [Next Steps](https://docs.factory.ai/user-guides/managing-context/understanding-context#next-steps)


# Understanding Context in Factory
Copy page
Learn about what context means in Factory, how it works, and best practices for managing it effectively
Copy page
##
[​](https://docs.factory.ai/user-guides/managing-context/understanding-context#what-is-context%3F)
What is Context?
Context in Factory represents all the information relevant to your current development task. Unlike traditional development environments where context lives across multiple tools and tabs, Factory brings everything together in one place, allowing AI to understand and assist with your work more effectively.
##
[​](https://docs.factory.ai/user-guides/managing-context/understanding-context#how-context-works)
How Context Works
## Smart Aggregation
Factory automatically collects and organizes context from your connected tools and repositories.
## Intelligent Understanding
Our AI analyzes relationships between different pieces of information to provide relevant insights.
## Selective Focus
Prioritize the most relevant information for your current task to maintain optimal performance.
##
[​](https://docs.factory.ai/user-guides/managing-context/understanding-context#context-limits-and-optimization)
Context Limits and Optimization
###
[​](https://docs.factory.ai/user-guides/managing-context/understanding-context#understanding-token-limits)
Understanding Token Limits
Tokens are the fundamental units that Factory uses to process text. Each session has a context limit based on the underlying LLM being used.
What are Tokens?
In a nutshell, tokens are discrete units of text that language models use to process and understand content. They represent the atomic elements of text processing, where words, subwords, or individual characters are converted into numerical values that the AI can analyze. Understanding token usage is crucial for optimizing context management and ensuring efficient AI interactions within Factory. Below is a slightly more detailed explanation.**Basic Concepts:**
  * Tokens can be words, parts of words, or even single characters
  * Common words are usually single tokens (e.g., “the”, “is”, “Factory”)
  * Longer or uncommon words might be split into multiple tokens
  * Punctuation marks and spaces count as tokens

**Example Tokenization:** The sentence “I heard a dog bark loudly” becomes:
  * I
  * heard
  * a
  * dog
  * bark
  * loudly

**Token Limits:**
  * Maximum context window: ~120,000 tokens
  * Optimal working range: 10,000-60,000 tokens
  * Includes all context sources: code, documentation, conversation history


###
[​](https://docs.factory.ai/user-guides/managing-context/understanding-context#best-practices-for-context-management)
Best Practices for Context Management
1
Start Focused
Begin with core context essential to your task:
  * Main files
  * Directly related tickets
  * Immediate documentation needs


2
Add Context Gradually
Expand context as needed:
  * Add related PRs when reviewing code
  * Include additional documentation when exploring features
  * Bring in historical context for deeper understanding


3
Maintain Context Hygiene
Regularly review and update your context:
  * Remove outdated or irrelevant information
  * Update stale documentation
  * Refresh context when switching tasks


4
Monitor Context Size
Keep an eye on your context usage:
  * Stay within the 40,000-80,000 token sweet spot
  * Use the context panel to track token usage
  * Remove unnecessary context when approaching limits


##
[​](https://docs.factory.ai/user-guides/managing-context/understanding-context#next-steps)
Next Steps
## [Explore Context TypesLearn about different types of context and how to use them effectively](https://docs.factory.ai/user-guides/managing-context/context-types)## [Context RetrievalDiscover how to bring context into your Factory workspace](https://docs.factory.ai/user-guides/managing-context/context-retrieval)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
