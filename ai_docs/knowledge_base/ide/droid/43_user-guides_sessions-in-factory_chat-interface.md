# https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface

[Skip to main content](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#content-area)
[Factory Documentation home page![light logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/light.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=d542d979e6c1a1ab8ddddac1a646a327)![dark logo](https://mintcdn.com/factory/znfImxXlrso1kEgo/logo/dark.svg?fit=max&auto=format&n=znfImxXlrso1kEgo&q=85&s=5c00942d328806f6cdcc3c0b95cda358)](https://docs.factory.ai/)
Search...
⌘K
Search...
Navigation
Using the Chat Interface
[Welcome](https://docs.factory.ai/welcome)[CLI](https://docs.factory.ai/cli/getting-started/overview)[Web Platform](https://docs.factory.ai/web/getting-started/overview)[Onboarding](https://docs.factory.ai/onboarding)[Pricing](https://docs.factory.ai/pricing)[Changelog](https://docs.factory.ai/changelog/1-8)
  * [GitHub](https://github.com/factory-ai/factory)
  * [Discord](https://discord.gg/EQ2DQM2F)


##### Welcome
On this page
  * [Overview](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#overview)
  * [Key Features](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#key-features)
  * [Using @ Commands](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#using-%40-commands)
  * [Available Commands](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#available-commands)
  * [Chat History](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#chat-history)
  * [Visual History Graph](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#visual-history-graph)
  * [History Features](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#history-features)
  * [Best Practices](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#best-practices)
  * [1. Clear Communication](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#1-clear-communication)
  * [2. Context Management](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#2-context-management)
  * [3. History Navigation](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#3-history-navigation)
  * [4. Effective Questioning](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#4-effective-questioning)
  * [Advanced Features](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#advanced-features)
  * [Code Interaction](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#code-interaction)
  * [File Handling](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#file-handling)
  * [Keyboard Shortcuts](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#keyboard-shortcuts)
  * [Troubleshooting](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#troubleshooting)
  * [Next Steps](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#next-steps)


# Using the Chat Interface
Copy page
Learn how to effectively communicate with Factory through its chat interface, including advanced features and chat history management
Copy page
##
[​](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#overview)
Overview
The chat interface is your primary means of interaction with Factory. It combines natural language communication with powerful context-aware features to help you accomplish your development tasks efficiently.
##
[​](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#key-features)
Key Features
## Context Integration
Seamlessly incorporate code, documentation, and other context
## @ Commands
Quick access to repositories, files, and external resources
## Chat History
Navigate and branch conversations with visual history tracking
##
[​](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#using-%40-commands)
Using @ Commands
Factory provides several @ commands for quick context access:
###
[​](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#available-commands)
Available Commands
@file
Access specific files:
Copy
Ask AI
```
@file src/main.js

```

Brings in file contents and history
@ticket
Link to issue tracking:
Copy
Ask AI
```
@ticket PROJ-123

```

Retrieves ticket details and comments
@pr
Reference pull requests:
Copy
Ask AI
```
@pr 456

```

Includes PR description and changes
##
[​](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#chat-history)
Chat History
The chat history feature helps you navigate and manage your conversations effectively.
###
[​](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#visual-history-graph)
Visual History Graph
1
Access History
Open the Chat History panel to view a visual graph of your conversation
2
Navigate Branches
Click on different nodes to move between conversation states
3
Create Branches
Start new conversation branches from any point in history
4
Track Context
See how context changes affect your conversation flow
###
[​](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#history-features)
History Features
  * **Branch Management** : Create and switch between different conversation paths
  * **Context Tracking** : Visualize when context was added or modified
  * **State Navigation** : Jump to specific points in your conversation
  * **Branch Comparison** : Compare different approaches to the same problem


##
[​](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#best-practices)
Best Practices
###
[​](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#1-clear-communication)
1. Clear Communication
  * Use specific, detailed questions
  * Break complex requests into steps
  * Provide necessary context upfront
  * Ask for clarification when needed


###
[​](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#2-context-management)
2. Context Management
  * Use @ commands strategically
  * Keep context relevant and focused
  * Update context when requirements change
  * Remove outdated context


###
[​](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#3-history-navigation)
3. History Navigation
  * Create branches for different approaches
  * Label important conversation points
  * Use history to compare solutions
  * Clean up unused branches


###
[​](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#4-effective-questioning)
4. Effective Questioning
  * Start broad, then narrow down
  * Include relevant details
  * Reference specific context
  * Follow up on unclear points


##
[​](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#advanced-features)
Advanced Features
###
[​](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#code-interaction)
Code Interaction
Copy
Ask AI
```
# You can share code directly in chat
def example():
  return "Hello, World!"

```

###
[​](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#file-handling)
File Handling
  * Upload files directly to chat
  * Reference uploaded files in conversation
  * Export chat contents and fragments


###
[​](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#keyboard-shortcuts)
Keyboard Shortcuts
  * `↑`: Edit last message
  * `Cmd/Ctrl + K`: Command palette
  * `Cmd/Ctrl + /`: Quick commands
  * `Cmd/Ctrl + B`: Toggle sidebar


##
[​](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#troubleshooting)
Troubleshooting
Context Not Loading
  * Verify file paths
  * Check repository access
  * Refresh context panel
  * Clear cache if needed


History Issues
  * Ensure stable connection
  * Check for browser updates
  * Clear browser cache
  * Reload session if needed


##
[​](https://docs.factory.ai/user-guides/sessions-in-factory/chat-interface#next-steps)
Next Steps
## [Explore FragmentsLearn how to work with code and content fragments](https://docs.factory.ai/user-guides/sessions-in-factory/how-to-use-fragments)## [Master SessionsUnderstand how to manage your workspace effectively](https://docs.factory.ai/user-guides/sessions-in-factory/sessions)
⌘I
[github](https://github.com/factory-ai/factory)[discord](https://discord.gg/EQ2DQM2F)[twitter](https://twitter.com/factoryAI)[linkedin](https://www.linkedin.com/company/factory-hq/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=factory)
Assistant
Responses are generated using AI and may contain mistakes.
