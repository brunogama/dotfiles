# https://docs.z.ai/guides/capabilities/cache

Source: [https://docs.z.ai/guides/capabilities/cache](https://docs.z.ai/guides/capabilities/cache)

---

[Skip to main content](https://docs.z.ai/guides/capabilities/cache#content-area)
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
Context Caching
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
  * [Features](https://docs.z.ai/guides/capabilities/cache#features)
  * [Code Examples](https://docs.z.ai/guides/capabilities/cache#code-examples)
  * [Best Practices](https://docs.z.ai/guides/capabilities/cache#best-practices)
  * [Use Cases](https://docs.z.ai/guides/capabilities/cache#use-cases)
  * [Important Notes](https://docs.z.ai/guides/capabilities/cache#important-notes)
  * [Billing Information](https://docs.z.ai/guides/capabilities/cache#billing-information)


Capabilities
# Context Caching
Copy page
Copy page
Context caching functionality significantly reduces token consumption and response latency by caching repeated context content. When you repeatedly use the same system prompts or conversation history in dialogues, the caching mechanism automatically identifies and reuses this content, thereby improving performance and reducing costs.
## 
[​](https://docs.z.ai/guides/capabilities/cache#features)
Features
  * **Automatic Cache Recognition** : Implicit caching that intelligently identifies repeated context content without manual configuration
  * **Significant Cost Reduction** : Cached tokens are billed at lower prices, dramatically saving costs
  * **Improved Response Speed** : Reduces processing time for repeated content, accelerating model responses
  * **Transparent Billing** : Detailed display of cached token counts in response field `usage.prompt_tokens_details.cached_tokens`
  * **Wide Compatibility** : Supports all mainstream models, including GLM-4.6, GLM-4.5 series, etc.


> Context caching works by computing input message content and identifying content that is identical or highly similar to previous requests. When repeated content is detected, the system reuses previous computation results, avoiding redundant token processing.
This mechanism is particularly suitable for the following scenarios:
  * System prompt reuse: In multi-turn conversations, system prompts usually remain unchanged, and caching can significantly reduce token consumption for this part.
  * Repetitive tasks: For tasks that process similar content with consistent instructions multiple times, caching can improve efficiency.
  * Multi-turn conversation history: In complex conversations, historical messages often contain a lot of repeated information, and caching can effectively reduce token usage for this part.


## 
[​](https://docs.z.ai/guides/capabilities/cache#code-examples)
Code Examples
  * cURL
  * Python SDK


**Basic Caching Example**
Copy
```
# First request - establish cache
curl --location 'https://api.z.ai/api/paas/v4/chat/completions' \
--header 'Authorization: Bearer YOUR_API_KEY' \
--header 'Content-Type: application/json' \
--data '{
  "model": "glm-4.6",
  "messages": [
    {
      "role": "system",
      "content": "You are a professional data analyst, skilled at explaining data trends and providing business insights."
    },
    {
      "role": "user",
      "content": "How to analyze user retention rate?"
    }
  ]
}'

```

**Cache Reuse Example**
Copy
```
# Second request - reuse system prompt cache
curl --location 'https://api.z.ai/api/paas/v4/chat/completions' \
--header 'Authorization: Bearer YOUR_API_KEY' \
--header 'Content-Type: application/json' \
--data '{
  "model": "glm-4.6",
  "messages": [
    {
      "role": "system",
      "content": "You are a professional data analyst, skilled at explaining data trends and providing business insights."
    },
    {
      "role": "user",
      "content": "What is funnel analysis?"
    }
  ]
}'

```

Response contains context cache token usage information:
Copy
```
{
 "usage": {
  "prompt_tokens": 1200,
  "completion_tokens": 300,
  "total_tokens": 1500,
  "prompt_tokens_details": {
   "cached_tokens": 800
  }
 }
}

```

## 
[​](https://docs.z.ai/guides/capabilities/cache#best-practices)
Best Practices
  * System Prompt Optimization
  * Document Content Reuse
  * Conversation History Management


Use stable system prompts
Copy
```
# Recommended: Use stable system prompts
system_prompt = """
You are a professional technical consultant with the following characteristics:
- Deep technical background and rich project experience
- Able to provide accurate and practical technical advice
- Good at explaining complex concepts in clear and concise language
Please provide professional technical guidance based on user questions.
"""
# Avoid: Frequently changing system prompts
# system_prompt = f"Current time: {datetime.now()}, you are an assistant..." # Different every time

```

## 
[​](https://docs.z.ai/guides/capabilities/cache#use-cases)
Use Cases
## Multi-turn Conversations
  * Intelligent customer service systems
  * Personal assistant services


## Batch Processing
  * Code review batch processing
  * Content batch analysis


## Template Applications
  * Report generation templates
  * Standardized process handling


## Education and Training
  * Homework grading assistance
  * Learning material analysis


## 
[​](https://docs.z.ai/guides/capabilities/cache#important-notes)
Important Notes
  * Understanding Cache Mechanism
  * Cost Optimization Suggestions
  * Performance Considerations
  * Best Practices


  * Caching is automatically triggered based on content similarity, no manual configuration required
  * Identical content has the highest cache hit rate
  * Minor formatting differences may affect cache effectiveness
  * Cache has reasonable time limits, will recalculate after expiration


## 
[​](https://docs.z.ai/guides/capabilities/cache#billing-information)
Billing Information
Context caching uses a differentiated billing strategy:
  * New content tokens: Billed at standard prices
  * Cache hit tokens: Billed at discounted prices (usually 50% of standard price)
  * Output tokens: Billed at standard prices

Billing example:
Copy
```
Assuming standard price is 0.01 /1K tokens:
Request details:
- Total input tokens: 2000
- Cache hit tokens: 1200
- New content tokens: 800
- Output tokens: 500
Billing calculation:
- New content cost: 800 × 0.01/1000 = 0.008
- Cache cost: 1200 × 0.005/1000 = 0.006
- Output cost: 500 × 0.01/1000 = 0.005
- Total cost: 0.019
Compared to no cache (2500 × 0.01/1000 = 0.025), saves 24%

```

Was this page helpful?
YesNo
[Function Calling](https://docs.z.ai/guides/capabilities/function-calling)[Structured Output](https://docs.z.ai/guides/capabilities/struct-output)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
