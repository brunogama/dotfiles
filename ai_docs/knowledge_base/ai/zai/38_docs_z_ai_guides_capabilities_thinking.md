# https://docs.z.ai/guides/capabilities/thinking

Source: [https://docs.z.ai/guides/capabilities/thinking](https://docs.z.ai/guides/capabilities/thinking)

---

[Skip to main content](https://docs.z.ai/guides/capabilities/thinking#content-area)
🚀 **GLM Coding Plan — built for devs: 3× usage, 1/7 cost** • [Limited-Time Offer ➞](https://z.ai/subscribe?utm_campaign=Platform_Ops&_channel_track_key=DaprgHIc)
[Z.AI DEVELOPER DOCUMENT home page![light logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/dark.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=75deefa9dea5bdbc84d4da68885c267f)![dark logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/light.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=c1ecf1af358fa8eeab8c06052337f8f6)](https://z.ai/model-api)
English
Search...
⌘K
  * [API Keys](https://z.ai/manage-apikey/apikey-list)
  * [Payment Method](https://z.ai/manage-apikey/billing)


Search...
Navigation
Capabilities
Deep Thinking
[Guides](https://docs.z.ai/guides/overview/quick-start)[API Reference](https://docs.z.ai/api-reference/introduction)[Scenario Example](https://docs.z.ai/scenario-example/develop-tools/claude)[Coding Plan](https://docs.z.ai/devpack/overview)[Released Notes](https://docs.z.ai/release-notes/new-released)[Terms and Policy](https://docs.z.ai/legal-agreement/privacy-policy)[Help Center](https://docs.z.ai/help/faq)
##### Get Started
  * [Quick Start](https://docs.z.ai/guides/overview/quick-start)
  * [Overview](https://docs.z.ai/guides/overview/overview)
  * [Pricing](https://docs.z.ai/guides/overview/pricing)
  * [Core Parameters](https://docs.z.ai/guides/overview/concept-param)
  * SDKs Guide
  * [Migrate to GLM-4.6](https://docs.z.ai/guides/overview/migrate-to-glm-4.6)


##### Language Models
  * [GLM-4.6](https://docs.z.ai/guides/llm/glm-4.6)
  * [GLM-4.5](https://docs.z.ai/guides/llm/glm-4.5)
  * [GLM-4-32B-0414-128K](https://docs.z.ai/guides/llm/glm-4-32b-0414-128k)


##### Visual Language Models
  * [GLM-4.5V](https://docs.z.ai/guides/vlm/glm-4.5v)


##### Image Generation Models
  * [CogView-4](https://docs.z.ai/guides/image/cogview-4)


##### Video Generation Models
  * [CogVideoX-3](https://docs.z.ai/guides/video/cogvideox-3)
  * [Vidu Q1](https://docs.z.ai/guides/video/vidu-q1)
  * [Vidu 2](https://docs.z.ai/guides/video/vidu2)


##### Image Generation Models
  * [CogView-4](https://docs.z.ai/guides/image/cogview-4)


##### Capabilities
  * [Deep Thinking](https://docs.z.ai/guides/capabilities/thinking)
  * [Streaming Messages](https://docs.z.ai/guides/capabilities/streaming)
  * [Tool Streaming Output](https://docs.z.ai/guides/capabilities/stream-tool)
  * [Function Calling](https://docs.z.ai/guides/capabilities/function-calling)
  * [Context Caching](https://docs.z.ai/guides/capabilities/cache)
  * [Structured Output](https://docs.z.ai/guides/capabilities/struct-output)


##### Tools
  * [Web Search](https://docs.z.ai/guides/tools/web-search)
  * [Stream Tool Call](https://docs.z.ai/guides/tools/stream-tool)


##### Agents
  * [GLM Slide/Poster Agent(beta)](https://docs.z.ai/guides/agents/slide)
  * [Translation Agent](https://docs.z.ai/guides/agents/translation)
  * [Video Effect Template Agent](https://docs.z.ai/guides/agents/video-template)


On this page
  * [Features](https://docs.z.ai/guides/capabilities/thinking#features)
  * [Core Parameters](https://docs.z.ai/guides/capabilities/thinking#core-parameters)
  * [Code Examples](https://docs.z.ai/guides/capabilities/thinking#code-examples)
  * [Response Example](https://docs.z.ai/guides/capabilities/thinking#response-example)
  * [Best Practices](https://docs.z.ai/guides/capabilities/thinking#best-practices)
  * [Application scenarios](https://docs.z.ai/guides/capabilities/thinking#application-scenarios)
  * [Notes](https://docs.z.ai/guides/capabilities/thinking#notes)


Capabilities
# Deep Thinking
Copy page
Copy page
Deep Thinking is an advanced reasoning feature that enables Chain of Thought mechanisms, allowing the model to perform deep analysis and reasoning before answering questions. This approach significantly improves the model’s accuracy and interpretability in complex tasks, particularly suitable for scenarios requiring multi-step reasoning, logical analysis, and problem-solving.
##
[​](https://docs.z.ai/guides/capabilities/thinking#features)
Features
The Deep Thinking feature currently supports the latest models in the GLM-4.5 and GLM-4.6 series. By enabling deep thinking, the model can:
  * **Multi-step Reasoning** : Break down complex problems into multiple steps for gradual analysis and resolution
  * **Logical Analysis** : Provide clear reasoning processes and logical chains
  * **Improved Accuracy** : Reduce errors and improve answer quality through deep thinking
  * **Enhanced Interpretability** : Display the thinking process to help users understand the model’s reasoning logic
  * **Intelligent Judgment** : The model automatically determines whether deep thinking is needed to optimize response efficiency


###
[​](https://docs.z.ai/guides/capabilities/thinking#core-parameters)
Core Parameters
  * **`thinking.type`**: Controls the deep thinking mode
    * `enabled` (default): Enable dynamic thinking, model automatically determines if deep thinking is needed
    * `disabled`: Disable deep thinking, provide direct answers
  * **`model`**: Models that support deep thinking, such as`glm-4.6` , `glm-4.5`, `glm-4.5v`, etc.


##
[​](https://docs.z.ai/guides/capabilities/thinking#code-examples)
Code Examples
  * cURL
  * Python SDK


**Basic Call (Enable Deep Thinking)**
Copy
```
curl --location 'https://api.z.ai/api/paas/v4/chat/completions' \
--header 'Authorization: Bearer YOUR_API_KEY' \
--header 'Content-Type: application/json' \
--data '{
  "model": "glm-4.6",
  "messages": [
    {
      "role": "user",
      "content": "Explain in detail the basic principles of quantum computing and analyze its potential impact in the field of cryptography"
    }
  ],
  "thinking": {
    "type": "enabled"
  },
  "max_tokens": 4096,
  "temperature": 1.0
}'

```

**Streaming Call (Deep Thinking + Streaming Output)**
Copy
```
curl --location 'https://api.z.ai/api/paas/v4/chat/completions' \
--header 'Authorization: Bearer YOUR_API_KEY' \
--header 'Content-Type: application/json' \
--data '{
  "model": "glm-4.6",
  "messages": [
    {
      "role": "user",
      "content": "Design a recommendation system architecture for an e-commerce website, considering user behavior, product features, and real-time requirements"
    }
  ],
  "thinking": {
    "type": "enabled"
  },
  "stream": true,
  "max_tokens": 4096,
  "temperature": 1.0
}'

```

**Disable Deep Thinking**
Copy
```
curl --location 'https://api.z.ai/api/paas/v4/chat/completions' \
--header 'Authorization: Bearer YOUR_API_KEY' \
--header 'Content-Type: application/json' \
--data '{
  "model": "glm-4.6",
  "messages": [
    {
      "role": "user",
      "content": "How is the weather today?"
    }
  ],
  "thinking": {
    "type": "disabled"
  }
}'

```

###
[​](https://docs.z.ai/guides/capabilities/thinking#response-example)
Response Example
Response format with deep thinking enabled:
Copy
```
{
 "created": 1677652288,
 "model": "glm-4.6",
 "choices": [
  {
   "index": 0,
   "message": {
    "role": "assistant",
    "content": "Artificial intelligence has tremendous application prospects in medical diagnosis...",
    "reasoning_content": "Let me analyze this question from multiple angles. First, I need to consider the technical advantages of AI in medical diagnosis..."
   },
   "finish_reason": "stop"
  }
 ],
 "usage": {
  "completion_tokens": 239,
  "prompt_tokens": 8,
  "prompt_tokens_details": {
   "cached_tokens": 0
  },
  "total_tokens": 247
 }
}

```

##
[​](https://docs.z.ai/guides/capabilities/thinking#best-practices)
Best Practices
**Recommended scenarios to enable:**
  * Complex problem analysis and solving
  * Multi-step reasoning tasks
  * Technical solution design
  * Strategy planning and decision
  * Academic research and analysis
  * Creative writing and content creation

**Can be disabled scenarios:**
  * Simple fact query
  * Basic translation tasks
  * Simple classification judgment
  * Quick question and answer requirements


##
[​](https://docs.z.ai/guides/capabilities/thinking#application-scenarios)
Application scenarios
## Academic Research
  * Research method design
  * Data analysis and explanation
  * Theory deduction and proof


## Technology Consulting
  * System architecture design
  * Technological scheme evaluation
  * Problem diagnosis and solution


## Business Analysis
  * Market trends analysis
  * Business model design
  * Investment decision support


## Education Training
  * Complex concept explanation
  * Learning path planning
  * Knowledge system building


##
[​](https://docs.z.ai/guides/capabilities/thinking#notes)
Notes
  1. **Response time** ：Enable deep thinking will increase response time, particularly for complex tasks
  2. **Token consumption** ：Thinking process will consume extra tokens, please manage your tokens
  3. **Model support** ：Ensure you’re using models that support deep thinking
  4. **Task matching** ：Choose whether to enable deep thinking according to the task complexity
  5. **Streaming output** ：Combine streaming output to see the thinking process, improving user experience


Was this page helpful?
YesNo
[CogView-4](https://docs.z.ai/guides/image/cogview-4)[Streaming Messages](https://docs.z.ai/guides/capabilities/streaming)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
