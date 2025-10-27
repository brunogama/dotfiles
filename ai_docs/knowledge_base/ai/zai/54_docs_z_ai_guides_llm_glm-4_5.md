# https://docs.z.ai/guides/llm/glm-4.5

Source: [https://docs.z.ai/guides/llm/glm-4.5](https://docs.z.ai/guides/llm/glm-4.5)

---

[Skip to main content](https://docs.z.ai/guides/llm/glm-4.5#content-area)
🚀 **GLM Coding Plan — built for devs: 3× usage, 1/7 cost** • [Limited-Time Offer ➞](https://z.ai/subscribe?utm_campaign=Platform_Ops&_channel_track_key=DaprgHIc)
[Z.AI DEVELOPER DOCUMENT home page![light logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/dark.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=75deefa9dea5bdbc84d4da68885c267f)![dark logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/light.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=c1ecf1af358fa8eeab8c06052337f8f6)](https://z.ai/model-api)
English
Search...
⌘K
  * [API Keys](https://z.ai/manage-apikey/apikey-list)
  * [Payment Method](https://z.ai/manage-apikey/billing)


Search...
Navigation
Language Models
GLM-4.5
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
  * [ Overview](https://docs.z.ai/guides/llm/glm-4.5#overview)
  * [ GLM-4.5 Serials](https://docs.z.ai/guides/llm/glm-4.5#glm-4-5-serials)
  * [GLM-4.5](https://docs.z.ai/guides/llm/glm-4.5#glm-4-5)
  * [GLM-4.5-Air](https://docs.z.ai/guides/llm/glm-4.5#glm-4-5-air)
  * [GLM-4.5-X](https://docs.z.ai/guides/llm/glm-4.5#glm-4-5-x)
  * [GLM-4.5-AirX](https://docs.z.ai/guides/llm/glm-4.5#glm-4-5-airx)
  * [GLM-4.5-Flash](https://docs.z.ai/guides/llm/glm-4.5#glm-4-5-flash)
  * [ Capability](https://docs.z.ai/guides/llm/glm-4.5#capability)
  * [ Introducting GLM-4.5](https://docs.z.ai/guides/llm/glm-4.5#introducting-glm-4-5)
  * [Overview](https://docs.z.ai/guides/llm/glm-4.5#overview-2)
  * [Higher Parameter Efficiency](https://docs.z.ai/guides/llm/glm-4.5#higher-parameter-efficiency)
  * [Low Cost, High Speed](https://docs.z.ai/guides/llm/glm-4.5#low-cost%2C-high-speed)
  * [Real-World Evaluation](https://docs.z.ai/guides/llm/glm-4.5#real-world-evaluation)
  * [ Usage](https://docs.z.ai/guides/llm/glm-4.5#usage)
  * [ Resources](https://docs.z.ai/guides/llm/glm-4.5#resources)
  * [ Quick Start](https://docs.z.ai/guides/llm/glm-4.5#quick-start)
  * [Thinking Mode](https://docs.z.ai/guides/llm/glm-4.5#thinking-mode)
  * [Samples Code](https://docs.z.ai/guides/llm/glm-4.5#samples-code)


Language Models
# GLM-4.5
Copy page
Copy page
##
[​](https://docs.z.ai/guides/llm/glm-4.5#overview)
Overview
[GLM Coding Plan](https://z.ai/subscribe?utm_source=zai&utm_medium=link&utm_term=guide&utm_content=glm-coding-plan&utm_campaign=Platform_Ops&_channel_track_key=Xz9zVAvo) — designed for Claude Code users, starting at $3/month to enjoy a premium coding experience!
GLM-4.5 and GLM-4.5-Air are our latest flagship models, purpose-built as foundational models for agent-oriented applications. Both leverage a Mixture-of-Experts (MoE) architecture. GLM-4.5 has a total parameter count of 355B with 32B active parameters per forward pass, while GLM-4.5-Air adopts a more streamlined design with 106B total parameters and 12B active parameters. Both models share a similar training pipeline: an initial pretraining phase on 15 trillion tokens of general-domain data, followed by targeted fine-tuning on datasets covering code, reasoning, and agent-specific tasks. The context length has been extended to 128k tokens, and reinforcement learning was applied to further enhance reasoning, coding, and agent performance. GLM-4.5 and GLM-4.5-Air are optimized for tool invocation, web browsing, software engineering, and front-end development. They can be integrated into code-centric agents such as Claude Code and Roo Code, and also support arbitrary agent applications through tool invocation APIs. Both models support hybrid reasoning modes, offering two execution modes: Thinking Mode for complex reasoning and tool usage, and Non-Thinking Mode for instant responses. These modes can be toggled via the `thinking.type`parameter (with `enabled` and `disabled` settings), and dynamic thinking is enabled by default.
## Input Modalities
Text
## Output Modalitie
Text
## Context Length
128K
## Maximum Output Tokens
96K
##
[​](https://docs.z.ai/guides/llm/glm-4.5#glm-4-5-serials)
GLM-4.5 Serials
GLM
###
[​](https://docs.z.ai/guides/llm/glm-4.5#glm-4-5)
GLM-4.5
Our most powerful reasoning model, with 355 billion parameters
AIR
###
[​](https://docs.z.ai/guides/llm/glm-4.5#glm-4-5-air)
GLM-4.5-Air
Cost-Effective Lightweight Strong Performance
X
###
[​](https://docs.z.ai/guides/llm/glm-4.5#glm-4-5-x)
GLM-4.5-X
High Performance Strong Reasoning Ultra-Fast Response
AirX
###
[​](https://docs.z.ai/guides/llm/glm-4.5#glm-4-5-airx)
GLM-4.5-AirX
Lightweight Strong Performance Ultra-Fast Response
FLASH
###
[​](https://docs.z.ai/guides/llm/glm-4.5#glm-4-5-flash)
GLM-4.5-Flash
Free Strong Performance Excellent for Reasoning Coding & Agents
##
[​](https://docs.z.ai/guides/llm/glm-4.5#capability)
Capability
## Deep Thinking
Enable deep thinking mode for more advanced reasoning and analysis
## Streaming Output
Support real-time streaming responses to enhance user interaction experience
## Function Call
Powerful tool invocation capabilities, enabling integration with various external toolsets
## Context Caching
Intelligent caching mechanism to optimize performance in long conversations
## Structured Output
Support for structured output formats like JSON, facilitating system integration
##
[​](https://docs.z.ai/guides/llm/glm-4.5#introducting-glm-4-5)
Introducting GLM-4.5
###
[​](https://docs.z.ai/guides/llm/glm-4.5#overview-2)
Overview
The first-principle measure of AGI lies in integrating more general intelligence capabilities without compromising existing functions. GLM-4.5 represents our first complete realization of this concept. It combines advanced reasoning, coding, and agent capabilities within a single model, achieving a significant technological breakthrough by natively fusing reasoning, coding, and agent abilities to meet the complex demands of agent-based applications. To comprehensively evaluate the model’s general intelligence, we selected 12 of the most representative benchmark suites, including MMLU Pro, AIME24, MATH 500, SciCode, GPQA, HLE, LiveCodeBench, SWE-Bench, Terminal-bench, TAU-Bench, BFCL v3, and BrowseComp. Based on the aggregated average scores, GLM-4.5 ranks second globally among all models, first among domestic models, and first among open-source models. ![Description](https://mintcdn.com/zhipu-32152247/fQm1SxNtD2jBDQ3i/resource/benchmark-0.png?fit=max&auto=format&n=fQm1SxNtD2jBDQ3i&q=85&s=d565bc82527cd77841a018a7e9fe2df0) ![Description](https://mintcdn.com/zhipu-32152247/fQm1SxNtD2jBDQ3i/resource/benchmark-1.png?fit=max&auto=format&n=fQm1SxNtD2jBDQ3i&q=85&s=a296f62a9517735d7af5b0580094065b)
###
[​](https://docs.z.ai/guides/llm/glm-4.5#higher-parameter-efficiency)
**Higher Parameter Efficiency**
GLM-4.5 has half the number of parameters of DeepSeek-R1 and one-third that of Kimi-K2, yet it outperforms them on multiple standard benchmark tests. This is attributed to the higher parameter efficiency of GLM architecture. Notably, GLM-4.5-Air, with 106 billion total parameters and 12 billion active parameters, achieves a significant breakthrough—surpassing models such as Gemini 2.5 Flash, Qwen3-235B, and Claude 4 Opus on reasoning benchmarks like Artificial Analysis, ranking among the top three domestic models in performance. On charts such as SWE-Bench Verified, the GLM-4.5 series lies on the Pareto frontier for performance-to-parameter ratio, demonstrating that at the same scale, the GLM-4.5 series delivers optimal performance. ![Description](https://mintcdn.com/zhipu-32152247/fQm1SxNtD2jBDQ3i/resource/benchmark-2.png?fit=max&auto=format&n=fQm1SxNtD2jBDQ3i&q=85&s=0ab97aeb6f7d4cef4e2b33fcb76231b4)
###
[​](https://docs.z.ai/guides/llm/glm-4.5#low-cost%2C-high-speed)
**Low Cost, High Speed**
Beyond performance optimization, the GLM-4.5 series also achieves breakthroughs in cost and efficiency, resulting in pricing far lower than mainstream models: API call costs are as low as $0.2 per million input tokens and $1.1 per million output tokens. At the same time, the high-speed version demonstrates a generation speed exceeding 100 tokens per second in real-world tests, supporting low-latency and high-concurrency deployment scenarios—balancing cost-effectiveness with user interaction experience. ![Description](https://mintcdn.com/zhipu-32152247/fQm1SxNtD2jBDQ3i/resource/benchmark2.png?fit=max&auto=format&n=fQm1SxNtD2jBDQ3i&q=85&s=d39c7575956dbe42a1c437e3cf14279f)
###
[​](https://docs.z.ai/guides/llm/glm-4.5#real-world-evaluation)
**Real-World Evaluation**
Real-world performance matters more than leaderboard rankings. To evaluate GLM-4.5’s effectiveness in practical Agent Coding scenarios, we integrated it into Claude Code and benchmarked it against Claude 4 Sonnet, Kimi-K2, and Qwen3-Coder. The evaluation consisted of 52 programming and development tasks spanning six major domains, executed in isolated container environments with multi-turn interaction tests. As shown in the results (below), GLM-4.5 demonstrates a strong competitive advantage over other open-source models, particularly in tool invocation reliability and task completion rate. While there remains room for improvement compared to Claude 4 Sonnet, GLM-4.5 delivers a largely comparable experience in most scenarios. To ensure transparency, we have released all [52 test problems along with full agent trajectories](https://huggingface.co/datasets/zai-org/CC-Bench-trajectories) for industry validation and reproducibility. ![Description](https://mintcdn.com/zhipu-32152247/fQm1SxNtD2jBDQ3i/resource/expr1.jpeg?fit=max&auto=format&n=fQm1SxNtD2jBDQ3i&q=85&s=f8b051792b065926cf99bed4648197e0)
##
[​](https://docs.z.ai/guides/llm/glm-4.5#usage)
Usage
  * Web Development
  * AI Assistant
  * Smart Office
  * Intelligent Question Answering
  * Complex Text Translation
  * Content Creation
  * Virtual Characters


**Core Capability:** _Coding Skills_ → Intelligent code generation | Real-time code completion | Automated bug fixing
  * Supports major languages including Python, JavaScript, and Java.
  * Generates well-structured, scalable, high-quality code based on natural language instructions.
  * Focuses on real-world development needs, avoiding templated or generic outputs.

**Use Case:** Complete refactoring-level tasks within 1 hour; generate full product prototypes in 5 minutes.
##
[​](https://docs.z.ai/guides/llm/glm-4.5#resources)
Resources
  * [API Documentation](https://docs.z.ai/api-reference/llm/chat-completion): Learn how to call the API.


##
[​](https://docs.z.ai/guides/llm/glm-4.5#quick-start)
Quick Start
###
[​](https://docs.z.ai/guides/llm/glm-4.5#thinking-mode)
Thinking Mode
GLM-4.5 offers a “Deep Thinking Mode” that users can enable or disable by setting the `thinking.type` parameter. This parameter supports two values: `enabled` (enabled) and `disabled` (disabled). By default, dynamic thinking is enabled.
  * **Simple Tasks (No Thinking Required):** For straightforward requests that do not require complex reasoning (e.g., fact retrieval or classification), thinking is unnecessary. Examples include:
    * When was Z.AI founded?
    * Translate the sentence “I love you” into Chinese.
  * **Moderate Tasks (Default/Some Thinking Required):** Many common requests require stepwise processing or deeper understanding. The GLM-4.5 series can flexibly apply thinking capabilities to handle tasks such as:
    * Why does Jupiter have more moons than Saturn, despite Saturn being larger?
    * Compare the advantages and disadvantages of flying versus taking the high-speed train from Beijing to Shanghai.

**Difficult Tasks (Maximum Thinking Capacity):** For truly complex challenges—such as solving advanced math problems, network-related questions, or coding issues—these tasks require the model to fully engage its reasoning and planning abilities, often involving many internal steps before arriving at an answer. Examples include:
  * Explain in detail how different experts in a Mixture-of-Experts (MoE) model collaborate.
  * Based on the recent week’s fluctuations of the Shanghai Composite Index and current political information, should I invest in a stock index ETF? Why?


###
[​](https://docs.z.ai/guides/llm/glm-4.5#samples-code)
Samples Code
  * cURL
  * Official Python SDK
  * Official Java SDK
  * OpenAI Python SDK


**Basic Call**
Copy
```
curl -X POST "https://api.z.ai/api/paas/v4/chat/completions" \
 -H "Content-Type: application/json" \
 -H "Authorization: Bearer your-api-key" \
 -d '{
  "model": "glm-4.5",
  "messages": [
   {
    "role": "user",
    "content": "As a marketing expert, please create an attractive slogan for my product."
   },
   {
    "role": "assistant",
    "content": "Sure, to craft a compelling slogan, please tell me more about your product."
   },
   {
    "role": "user",
    "content": "Z.AI Open Platform"
   }
  ],
  "thinking": {
   "type": "enabled"
  },
  "max_tokens": 4096,
  "temperature": 0.6
 }'

```

**Streaming Call**
Copy
```
curl -X POST "https://api.z.ai/api/paas/v4/chat/completions" \
 -H "Content-Type: application/json" \
 -H "Authorization: Bearer your-api-key" \
 -d '{
  "model": "glm-4.5",
  "messages": [
   {
    "role": "user",
    "content": "As a marketing expert, please create an attractive slogan for my product."
   },
   {
    "role": "assistant",
    "content": "Sure, to craft a compelling slogan, please tell me more about your product."
   },
   {
    "role": "user",
    "content": "Z.AI Open Platform"
   }
  ],
  "thinking": {
   "type": "enabled"
  },
  "stream": true,
  "max_tokens": 4096,
  "temperature": 0.6
 }'

```

Was this page helpful?
YesNo
[GLM-4.6](https://docs.z.ai/guides/llm/glm-4.6)[GLM-4-32B-0414-128K](https://docs.z.ai/guides/llm/glm-4-32b-0414-128k)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
![Description](https://mintcdn.com/zhipu-32152247/fQm1SxNtD2jBDQ3i/resource/benchmark-0.png?w=560&fit=max&auto=format&n=fQm1SxNtD2jBDQ3i&q=85&s=148a0bf8b7521d83038120f905dd6405)
![Description](https://mintcdn.com/zhipu-32152247/fQm1SxNtD2jBDQ3i/resource/benchmark-1.png?w=560&fit=max&auto=format&n=fQm1SxNtD2jBDQ3i&q=85&s=6cbaf319c9f8da2ed44676b778b2f5ed)
![Description](https://mintcdn.com/zhipu-32152247/fQm1SxNtD2jBDQ3i/resource/benchmark-2.png?w=560&fit=max&auto=format&n=fQm1SxNtD2jBDQ3i&q=85&s=affcf850f56f6592379fb9577bd59d00)
![Description](https://mintcdn.com/zhipu-32152247/fQm1SxNtD2jBDQ3i/resource/benchmark2.png?w=560&fit=max&auto=format&n=fQm1SxNtD2jBDQ3i&q=85&s=a66679e1487639408b67b6e09c3c3567)
![Description](https://mintcdn.com/zhipu-32152247/fQm1SxNtD2jBDQ3i/resource/expr1.jpeg?w=560&fit=max&auto=format&n=fQm1SxNtD2jBDQ3i&q=85&s=793e94d145f933d9684b39a145ca814f)
