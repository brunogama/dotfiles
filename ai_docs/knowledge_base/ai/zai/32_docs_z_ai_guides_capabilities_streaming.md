# https://docs.z.ai/guides/capabilities/streaming

Source: [https://docs.z.ai/guides/capabilities/streaming](https://docs.z.ai/guides/capabilities/streaming)

---

[Skip to main content](https://docs.z.ai/guides/capabilities/streaming#content-area)
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
Streaming Messages
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
  * [Features](https://docs.z.ai/guides/capabilities/streaming#features)
  * [Core Parameter Description](https://docs.z.ai/guides/capabilities/streaming#core-parameter-description)
  * [Response Format Description](https://docs.z.ai/guides/capabilities/streaming#response-format-description)
  * [Code Examples](https://docs.z.ai/guides/capabilities/streaming#code-examples)
  * [Response Example](https://docs.z.ai/guides/capabilities/streaming#response-example)
  * [Application Scenarios](https://docs.z.ai/guides/capabilities/streaming#application-scenarios)


Capabilities
# Streaming Messages
Copy page
Copy page
Streaming Messages allow real-time content retrieval while the model generates responses, without waiting for the complete response to be generated. This approach can significantly improve user experience, especially when generating long text content, as users can immediately see output beginning to appear.
##
[​](https://docs.z.ai/guides/capabilities/streaming#features)
Features
Streaming messages use an incremental generation mechanism, transmitting content in chunks in real-time during the generation process, rather than waiting for the complete response to be generated before returning it all at once. This mechanism allows developers to:
  * **Real-time Response** : No need to wait for complete response, content displays progressively
  * **Improved Experience** : Reduce user waiting time, provide instant feedback
  * **Reduced Latency** : Content is transmitted as it’s generated, reducing perceived latency
  * **Flexible Processing** : Real-time processing and display during reception


###
[​](https://docs.z.ai/guides/capabilities/streaming#core-parameter-description)
Core Parameter Description
  * **`stream=True`**: Enable streaming output, must be set to`True`
  * **`model`**: Models that support streaming output, such as`glm-4.6` , `glm-4.5`, etc.


###
[​](https://docs.z.ai/guides/capabilities/streaming#response-format-description)
Response Format Description
Streaming responses use Server-Sent Events (SSE) format, with each event containing:
  * `choices[0].delta.content`: Incremental text content
  * `choices[0].delta.reasoning_content`: Incremental reasoning content
  * `choices[0].finish_reason`: Completion reason (only appears in the last chunk)
  * `usage`: Token usage statistics (only appears in the last chunk)


##
[​](https://docs.z.ai/guides/capabilities/streaming#code-examples)
Code Examples
  * cURL
  * Python


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
      "content": "Write a poem about spring"
    }
  ],
  "stream": true
}'

```

###
[​](https://docs.z.ai/guides/capabilities/streaming#response-example)
Response Example
The streaming response format is as follows:
Copy
```
data: {"id":"1","created":1677652288,"model":"glm-4.6","choices":[{"index":0,"delta":{"content":"Spring"},"finish_reason":null}]}
data: {"id":"1","created":1677652288,"model":"glm-4.6","choices":[{"index":0,"delta":{"content":" comes"},"finish_reason":null}]}
data: {"id":"1","created":1677652288,"model":"glm-4.6","choices":[{"index":0,"delta":{"content":" with"},"finish_reason":null}]}
...
data: {"id":"1","created":1677652288,"model":"glm-4.6","choices":[{"index":0,"finish_reason":"stop","delta":{"role":"assistant","content":""}}],"usage":{"prompt_tokens":8,"completion_tokens":262,"total_tokens":270,"prompt_tokens_details":{"cached_tokens":0}}}
data: [DONE]

```

##
[​](https://docs.z.ai/guides/capabilities/streaming#application-scenarios)
Application Scenarios
## Chat Applications
  * Real-time conversation experience
  * Character-by-character reply display
  * Reduced waiting time


## Content Generation
  * Article writing assistant
  * Code generation tools
  * Creative content creation


## Educational Applications
  * Online Q&A systems
  * Learning assistance tools
  * Knowledge Q&A platforms


## Customer Service Systems
  * Intelligent customer service bots
  * Real-time problem solving
  * User support systems


Was this page helpful?
YesNo
[Deep Thinking](https://docs.z.ai/guides/capabilities/thinking)[Tool Streaming Output](https://docs.z.ai/guides/capabilities/stream-tool)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
