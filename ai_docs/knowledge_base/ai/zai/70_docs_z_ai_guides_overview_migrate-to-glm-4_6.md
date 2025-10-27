# https://docs.z.ai/guides/overview/migrate-to-glm-4.6

Source: [https://docs.z.ai/guides/overview/migrate-to-glm-4.6](https://docs.z.ai/guides/overview/migrate-to-glm-4.6)

---

[Skip to main content](https://docs.z.ai/guides/overview/migrate-to-glm-4.6#content-area)
🚀 **GLM Coding Plan — built for devs: 3× usage, 1/7 cost** • [Limited-Time Offer ➞](https://z.ai/subscribe?utm_campaign=Platform_Ops&_channel_track_key=DaprgHIc)
[Z.AI DEVELOPER DOCUMENT home page![light logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/dark.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=75deefa9dea5bdbc84d4da68885c267f)![dark logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/light.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=c1ecf1af358fa8eeab8c06052337f8f6)](https://z.ai/model-api)
English
Search...
⌘K
  * [API Keys](https://z.ai/manage-apikey/apikey-list)
  * [Payment Method](https://z.ai/manage-apikey/billing)


Search...
Navigation
Get Started
Migrate to GLM-4.6
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
  * [GLM-4.6 Features](https://docs.z.ai/guides/overview/migrate-to-glm-4.6#glm-4-6-features)
  * [Migration Checklist](https://docs.z.ai/guides/overview/migrate-to-glm-4.6#migration-checklist)
  * [Start Migration](https://docs.z.ai/guides/overview/migrate-to-glm-4.6#start-migration)
  * [1. Update Model Identifier](https://docs.z.ai/guides/overview/migrate-to-glm-4.6#1-update-model-identifier)
  * [2. Update Sampling Parameters](https://docs.z.ai/guides/overview/migrate-to-glm-4.6#2-update-sampling-parameters)
  * [3. Deep Thinking (Optional)](https://docs.z.ai/guides/overview/migrate-to-glm-4.6#3-deep-thinking-optional)
  * [4. Streaming Output and Tool Calls (Optional)](https://docs.z.ai/guides/overview/migrate-to-glm-4.6#4-streaming-output-and-tool-calls-optional)
  * [5. Testing and Regression](https://docs.z.ai/guides/overview/migrate-to-glm-4.6#5-testing-and-regression)
  * [More Resources](https://docs.z.ai/guides/overview/migrate-to-glm-4.6#more-resources)


Get Started
# Migrate to GLM-4.6
Copy page
Copy page
This guide explains how to migrate your calls from GLM-4.5 or other earlier models to Z.AI GLM-4.6, our most powerful coding model to date, covering sampling parameter differences, streaming tool calls, and other key points.
##
[​](https://docs.z.ai/guides/overview/migrate-to-glm-4.6#glm-4-6-features)
GLM-4.6 Features
  * Support for larger context and output: Maximum context 200K, maximum output 128K.
  * New support for streaming output during tool calling process (`tool_stream=true`), real-time retrieval of tool call parameters.
  * Same as GLM-4.5 series, supports deep thinking (`thinking={ type: "enabled" }`).
  * Superior code performance and advanced reasoning capabilities.


##
[​](https://docs.z.ai/guides/overview/migrate-to-glm-4.6#migration-checklist)
Migration Checklist
  * Update model identifier to `glm-4.6`
  * Sampling parameters: `temperature` default value `1.0`, `top_p` default value `0.95`, recommend choosing only one for tuning
  * Deep thinking: Enabled or disable `thinking={ type: "enabled" }` as needed for complex reasoning/coding
  * Streaming response: Enable `stream=true` and properly handle `delta.reasoning_content` and `delta.content`
  * Streaming tool calls: Enable `stream=true` and `tool_stream=true` and stream-concatenate `delta.tool_calls[*].function.arguments`
  * Maximum output and context: Set `max_tokens` appropriately (GLM-4.6 maximum output 128K, context 200K)
  * Prompt optimization: Work with deep thinking, use clearer instructions and constraints
  * Development environment verification: Conduct use case testing and regression, focus on randomness, latency, parameter completeness in tool streams


##
[​](https://docs.z.ai/guides/overview/migrate-to-glm-4.6#start-migration)
Start Migration
###
[​](https://docs.z.ai/guides/overview/migrate-to-glm-4.6#1-update-model-identifier)
1. Update Model Identifier
  * Update `model` to `glm-4.6`.


Copy
```
resp = client.chat.completions.create(
  model="glm-4.6",
  messages=[{"role": "user", "content": "Briefly describe the advantages of GLM-4.6"}]
)

```

###
[​](https://docs.z.ai/guides/overview/migrate-to-glm-4.6#2-update-sampling-parameters)
2. Update Sampling Parameters
  * `temperature`: Controls randomness; higher values are more divergent, lower values are more stable.
  * `top_p`: Controls nucleus sampling; higher values expand candidate set, lower values converge candidate set.
  * `temperature` defaults to `1.0`, `top_p` defaults to `0.95`, not recommended to adjust both simultaneously.


Copy
```
# Plan A: Use temperature (recommended)
resp = client.chat.completions.create(
  model="glm-4.6",
  messages=[{"role": "user", "content": "Write a more creative brand introduction"}],
  temperature=1.0
)
# Plan B: Use top_p
resp = client.chat.completions.create(
  model="glm-4.6",
  messages=[{"role": "user", "content": "Generate more stable technical documentation"}],
  top_p=0.8
)

```

###
[​](https://docs.z.ai/guides/overview/migrate-to-glm-4.6#3-deep-thinking-optional)
3. Deep Thinking (Optional)
  * GLM-4.6 continues to support deep thinking capability, enabled by default.
  * Recommended to enable for complex reasoning and coding tasks:


Copy
```
resp = client.chat.completions.create(
  model="glm-4.6",
  messages=[{"role": "user", "content": "Design a three-tier microservice architecture for me"}],
  thinking={"type": "enabled"}
)

```

###
[​](https://docs.z.ai/guides/overview/migrate-to-glm-4.6#4-streaming-output-and-tool-calls-optional)
4. Streaming Output and Tool Calls (Optional)
  * GLM-4.6 exclusively supports real-time streaming construction and output during tool calling process, disabled by default (`False`), requires enabling both:
    * `stream=True`: Enable streaming output for responses
    * `tool_stream=True`: Enable streaming output for tool call parameters


Copy
```
response = client.chat.completions.create(
  model="glm-4.6",
  messages=[{"role": "user", "content": "How's the weather in Beijing"}],
  tools=[
    {
      "type": "function",
      "function": {
        "name": "get_weather",
        "description": "Get current weather conditions for a specified location",
        "parameters": {
          "type": "object",
          "properties": {
            "location": {"type": "string", "description": "City, eg: Beijing, Shanghai"},
            "unit": {"type": "string", "enum": ["celsius", "fahrenheit"]}
          },
          "required": ["location"]
        }
      }
    }
  ],
  stream=True,
  tool_stream=True,
)
# Initialize streaming collection variables
reasoning_content = ""
content = ""
final_tool_calls = {}
reasoning_started = False
content_started = False
# Process streaming response
for chunk in response:
  if not chunk.choices:
    continue
  delta = chunk.choices[0].delta
  # Streaming reasoning process output
  if hasattr(delta, 'reasoning_content') and delta.reasoning_content:
    if not reasoning_started and delta.reasoning_content.strip():
      print("\n🧠 Thinking Process:")
      reasoning_started = True
    reasoning_content += delta.reasoning_content
    print(delta.reasoning_content, end="", flush=True)
  # Streaming answer content output
  if hasattr(delta, 'content') and delta.content:
    if not content_started and delta.content.strip():
      print("\n\n💬 Answer Content:")
      content_started = True
    content += delta.content
    print(delta.content, end="", flush=True)
  # Streaming tool call information (parameter concatenation)
  if delta.tool_calls:
    for tool_call in delta.tool_calls:
      idx = tool_call.index
      if idx not in final_tool_calls:
        final_tool_calls[idx] = tool_call
        final_tool_calls[idx].function.arguments = tool_call.function.arguments
      else:
        final_tool_calls[idx].function.arguments += tool_call.function.arguments
# Output final tool call information
if final_tool_calls:
  print("\n📋 Function Calls Triggered:")
  for idx, tool_call in final_tool_calls.items():
    print(f" {idx}: Function Name: {tool_call.function.name}, Parameters: {tool_call.function.arguments}")

```

See: [Tool Streaming Output Documentation](https://docs.z.ai/guides/tools/stream-tool)
###
[​](https://docs.z.ai/guides/overview/migrate-to-glm-4.6#5-testing-and-regression)
5. Testing and Regression
> First verify in development environment that post-migration calls are stable, focus on:
  * Whether responses meet expectations, whether there’s excessive randomness or excessive conservatism in output
  * Whether tool streaming construction and output work normally
  * Latency and cost in long context and deep thinking scenarios


##
[​](https://docs.z.ai/guides/overview/migrate-to-glm-4.6#more-resources)
More Resources
## [Concept ParametersCommon model parameter concepts and sampling recommendations](https://docs.z.ai/guides/overview/concept-param)## [Tool Streaming OutputView tool streaming output usage details](https://docs.z.ai/guides/tools/stream-tool)## [API ReferenceView complete API documentation](https://docs.z.ai/api-reference/introduction)## [Technical SupportGet technical support and help](https://z.ai/consultation)
Was this page helpful?
YesNo
[LangChain Integration](https://docs.z.ai/guides/develop/langchain/introduction)[GLM-4.6](https://docs.z.ai/guides/llm/glm-4.6)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
