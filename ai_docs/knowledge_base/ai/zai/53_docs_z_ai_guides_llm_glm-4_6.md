# https://docs.z.ai/guides/llm/glm-4.6

Source: [https://docs.z.ai/guides/llm/glm-4.6](https://docs.z.ai/guides/llm/glm-4.6)

---

[Skip to main content](https://docs.z.ai/guides/llm/glm-4.6#content-area)
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
GLM-4.6
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
  * [ Overview](https://docs.z.ai/guides/llm/glm-4.6#overview)
  * [ Introducting GLM-4.6](https://docs.z.ai/guides/llm/glm-4.6#introducting-glm-4-6)
  * [1. Comprehensive Evaluation](https://docs.z.ai/guides/llm/glm-4.6#1-comprehensive-evaluation)
  * [2. Real-World Coding Evaluation](https://docs.z.ai/guides/llm/glm-4.6#2-real-world-coding-evaluation)
  * [ Usage](https://docs.z.ai/guides/llm/glm-4.6#usage)
  * [ Resources](https://docs.z.ai/guides/llm/glm-4.6#resources)
  * [ Quick Start](https://docs.z.ai/guides/llm/glm-4.6#quick-start)


Language Models
# GLM-4.6
Copy page
Copy page
##
[​](https://docs.z.ai/guides/llm/glm-4.6#overview)
Overview
The [GLM Coding Plan](https://z.ai/subscribe?utm_source=zai&utm_medium=link&utm_term=guide&utm_content=glm-coding-plan&utm_campaign=Platform_Ops&_channel_track_key=Xz9zVAvo) is a subscription package designed specifically for AI-powered coding. GLM-4.6 is now available in top coding tools, starting at just $3/month — powering Claude Code, Cline, OpenCode, Roo Code and more. The package is designed to make coding faster, smarter, and more reliable.
As the latest iteration in the GLM series, GLM-4.6 achieves comprehensive enhancements across multiple domains, including real-world coding, long-context processing, reasoning, searching, writing, and agentic applications. Details are as follows:
  * **Longer context window** : The context window has been expanded from 128K to 200K tokens, enabling the model to handle more complex agentic tasks.
  * **Superior coding performance** : The model achieves higher scores on code benchmarks and demonstrates better real-world performance in applications such as Claude Code、Cline、Roo Code and Kilo Code, including improvements in generating visually polished front-end pages.
  * **Advanced reasoning** : GLM-4.6 shows a clear improvement in reasoning performance and supports tool use during inference, leading to stronger overall capability.
  * **More capable agents** : GLM-4.6 exhibits stronger performance in tool use and search-based agents, and integrates more effectively within agent frameworks.
  * **Refined writing** : Better aligns with human preferences in style and readability, and performs more naturally in role-playing scenarios.


## Input Modalities
Text
## Output Modalitie
Text
## Context Length
200K
## Maximum Output Tokens
128K
##
[​](https://docs.z.ai/guides/llm/glm-4.6#introducting-glm-4-6)
Introducting GLM-4.6
###
[​](https://docs.z.ai/guides/llm/glm-4.6#1-comprehensive-evaluation)
1. Comprehensive Evaluation
In evaluations across 8 authoritative benchmarks for general model capabilities—including AIME 25, GPQA, LCB v6, HLE, and SWE-Bench Verified—GLM-4.6 achieves performance on par with Claude Sonnet 4/Claude Sonnet 4.6 on several leaderboards, solidifying its position as the top model developed in China. ![Description](https://cdn.bigmodel.cn/markdown/1759214269399glm-4.6-1.png?attname=glm-4.6-1.png)
###
[​](https://docs.z.ai/guides/llm/glm-4.6#2-real-world-coding-evaluation)
2. Real-World Coding Evaluation
To better test the model’s capabilities in practical coding tasks, we conducted 74 real-world coding tests within the Claude Code environment. The results show that GLM-4.6 surpasses Claude Sonnet 4 and other domestic models in these real-world tests. ![Description](https://cdn.bigmodel.cn/markdown/1759212585375glm-4.6-2.jpeg?attname=glm-4.6-2.jpeg) In terms of average token consumption, GLM-4.6 is over 30% more efficient than GLM-4.5, achieving the lowest consumption rate among comparable models. ![Description](https://cdn.bigmodel.cn/markdown/1759212592331glm-4.6-3.jpeg?attname=glm-4.6-3.jpeg) To ensure transparency and credibility, Z.ai has publicly released all test questions and agent trajectories for verification and reproduction. (Link: <https://huggingface.co/datasets/zai-org/CC-Bench-trajectories>).
##
[​](https://docs.z.ai/guides/llm/glm-4.6#usage)
Usage
AI Coding
Supports mainstream languages including Python, JavaScript, and Java, delivering superior aesthetics and logical layout in frontend code. Natively handles diverse agent tasks with enhanced autonomous planning and tool invocation capabilities. Excels in task decomposition, cross-tool collaboration, and dynamic adjustments, enabling flexible adaptation to complex development or office workflows.
Smart Office
Significantly enhances presentation quality in PowerPoint creation and office automation scenarios. Generates aesthetically advanced layouts with clear logical structures while preserving content integrity and expression accuracy, making it ideal for office automation systems and AI presentation tools.
Translation and Cross-Language Applications
Translation quality for minor languages (French, Russian, Japanese, Korean) and informal contexts has been further optimized, making it particularly suitable for social media, e-commerce content, and short drama translations. It maintains semantic coherence and stylistic consistency in lengthy passages while achieving superior style adaptation and localized expression, meeting the diverse needs of global enterprises and cross-border services.
Content Creation
Supports diverse content production including novels, scripts, and copywriting, achieving more natural expression through contextual expansion and emotional regulation.
Virtual Characters
Maintains consistent tone and behavior across multi-turn conversations, ideal for virtual humans, social AI, and brand personification operations, making interactions warmer and more authentic.
Intelligent Search & Deep Research
Enhances user intent understanding, tool retrieval, and result integration. Not only does it return more precise search results, but it also deeply synthesizes outcomes to support Deep Research scenarios, delivering more insightful answers to users.
##
[​](https://docs.z.ai/guides/llm/glm-4.6#resources)
Resources
  * [API Documentation](https://docs.z.ai/api-reference/llm/chat-completion): Learn how to call the API.


##
[​](https://docs.z.ai/guides/llm/glm-4.6#quick-start)
Quick Start
The following is a full sample code to help you onboard GLM-4.6 with ease.
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
"model": "glm-4.6",
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
"temperature": 1.0
}'

```

**Streaming Call**
Copy
```
curl -X POST "https://api.z.ai/api/paas/v4/chat/completions" \
-H "Content-Type: application/json" \
-H "Authorization: Bearer your-api-key" \
-d '{
"model": "glm-4.6",
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
"temperature": 1.0
}'

```

Was this page helpful?
YesNo
[Migrate to GLM-4.6](https://docs.z.ai/guides/overview/migrate-to-glm-4.6)[GLM-4.5](https://docs.z.ai/guides/llm/glm-4.5)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
![Description](https://cdn.bigmodel.cn/markdown/1759214269399glm-4.6-1.png?attname=glm-4.6-1.png)
![Description](https://cdn.bigmodel.cn/markdown/1759212585375glm-4.6-2.jpeg?attname=glm-4.6-2.jpeg)
![Description](https://cdn.bigmodel.cn/markdown/1759212592331glm-4.6-3.jpeg?attname=glm-4.6-3.jpeg)
