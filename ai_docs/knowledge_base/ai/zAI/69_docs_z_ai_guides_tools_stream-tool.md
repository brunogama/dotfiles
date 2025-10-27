# https://docs.z.ai/guides/tools/stream-tool

Source: [https://docs.z.ai/guides/tools/stream-tool](https://docs.z.ai/guides/tools/stream-tool)

---

[Skip to main content](https://docs.z.ai/guides/tools/stream-tool#content-area)
🚀 **GLM Coding Plan — built for devs: 3× usage, 1/7 cost** • [Limited-Time Offer ➞](https://z.ai/subscribe?utm_campaign=Platform_Ops&_channel_track_key=DaprgHIc)
[Z.AI DEVELOPER DOCUMENT home page![light logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/dark.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=75deefa9dea5bdbc84d4da68885c267f)![dark logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/light.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=c1ecf1af358fa8eeab8c06052337f8f6)](https://z.ai/model-api)
English
Search...
⌘K
  * [API Keys](https://z.ai/manage-apikey/apikey-list)
  * [Payment Method](https://z.ai/manage-apikey/billing)


Search...
Navigation
Tools
Stream Tool Call
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
  * [Features](https://docs.z.ai/guides/tools/stream-tool#features)
  * [Core Parameter Description](https://docs.z.ai/guides/tools/stream-tool#core-parameter-description)
  * [Response Parameter Description](https://docs.z.ai/guides/tools/stream-tool#response-parameter-description)
  * [Code Example](https://docs.z.ai/guides/tools/stream-tool#code-example)
  * [Use Cases](https://docs.z.ai/guides/tools/stream-tool#use-cases)


Tools
# Stream Tool Call
Copy page
Copy page
Stream Tool Call is a unique feature of Z.ai’s latest GLM-4.6 model, allowing real-time access to reasoning processes, response content, and tool call information during tool invocation, providing better user experience and real-time feedback.
## 
[​](https://docs.z.ai/guides/tools/stream-tool#features)
Features
Tool calling in the latest GLM-4.6 model now supports streaming output for responses. This allows developers to stream tool usage parameters without buffering or JSON validation when calling `chat.completions`, thereby reducing call latency and providing a better user experience.
### 
[​](https://docs.z.ai/guides/tools/stream-tool#core-parameter-description)
Core Parameter Description
  * **`stream=True`**: Enable streaming output, must be set to`True`
  * **`tool_stream=True`**: Enable tool call streaming output
  * **`model`**: Use a model that supports tool calling, limited to`glm-4.6`


### 
[​](https://docs.z.ai/guides/tools/stream-tool#response-parameter-description)
Response Parameter Description
The `delta` object in streaming responses contains the following fields:
  * **`reasoning_content`**: Text content of the model’s reasoning process
  * **`content`**: Text content of the model’s response
  * **`tool_calls`**: Tool call information, including function names and parameters


## 
[​](https://docs.z.ai/guides/tools/stream-tool#code-example)
Code Example
By setting the `tool_stream=True` parameter, you can enable streaming tool call functionality:
  * Python SDK


**Install SDK**
Copy
```
# Install latest version
pip install zai-sdk
# Or specify version
pip install zai-sdk==0.0.4

```

**Verify Installation**
Copy
```
import zai
print(zai.__version__)

```

**Complete Example**
Copy
```
from zai import ZaiClient
# Initialize client
client = ZaiClient(api_key='Your API key')
# Create streaming tool call request
response = client.chat.completions.create(
  model="glm-4.6", # Use model that supports tool calling
  messages=[
    {"role": "user", "content": "How's the weather in Beijing?"},
  ],
  tools=[
    {
      "type": "function",
      "function": {
        "name": "get_weather",
        "description": "Get current weather conditions for a specified location",
        "parameters": {
          "type": "object",
          "properties": {
            "location": {"type": "string", "description": "City, e.g.: Beijing, Shanghai"},
            "unit": {"type": "string", "enum": ["celsius", "fahrenheit"]}
          },
          "required": ["location"]
        }
      }
    }
  ],
  stream=True,    # Enable streaming output
  tool_stream=True  # Enable tool call streaming output
)
# Initialize variables to collect streaming data
reasoning_content = ""   # Reasoning process content
content = ""        # Response content
final_tool_calls = {}   # Tool call information
reasoning_started = False # Reasoning process start flag
content_started = False  # Content output start flag
# Process streaming response
for chunk in response:
  if not chunk.choices:
    continue
  delta = chunk.choices[0].delta
  # Handle streaming reasoning process output
  if hasattr(delta, 'reasoning_content') and delta.reasoning_content:
    if not reasoning_started and delta.reasoning_content.strip():
      print("\n🧠 Thinking Process:")
      reasoning_started = True
    reasoning_content += delta.reasoning_content
    print(delta.reasoning_content, end="", flush=True)
  # Handle streaming response content output
  if hasattr(delta, 'content') and delta.content:
    if not content_started and delta.content.strip():
      print("\n\n💬 Response Content:")
      content_started = True
    content += delta.content
    print(delta.content, end="", flush=True)
  # Handle streaming tool call information
  if delta.tool_calls:
    for tool_call in delta.tool_calls:
      index = tool_call.index
      if index not in final_tool_calls:
        # New tool call
        final_tool_calls[index] = tool_call
        final_tool_calls[index].function.arguments = tool_call.function.arguments
      else:
        # Append tool call parameters (streaming construction)
        final_tool_calls[index].function.arguments += tool_call.function.arguments
# Output final tool call information
if final_tool_calls:
  print("\n📋 Function Calls Triggered:")
  for index, tool_call in final_tool_calls.items():
    print(f" {index}: Function Name: {tool_call.function.name}, Parameters: {tool_call.function.arguments}")

```

## 
[​](https://docs.z.ai/guides/tools/stream-tool#use-cases)
Use Cases
## Intelligent Customer Service System
  * Real-time display of query progress
  * Improve waiting experience


## Code Assistant
  * Real-time code analysis process
  * Display tool call chain


Was this page helpful?
YesNo
[Web Search](https://docs.z.ai/guides/tools/web-search)[GLM Slide/Poster Agent(beta)](https://docs.z.ai/guides/agents/slide)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
