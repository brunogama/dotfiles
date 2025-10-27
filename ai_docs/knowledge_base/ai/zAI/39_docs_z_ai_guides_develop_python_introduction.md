# https://docs.z.ai/guides/develop/python/introduction

Source: [https://docs.z.ai/guides/develop/python/introduction](https://docs.z.ai/guides/develop/python/introduction)

---

[Skip to main content](https://docs.z.ai/guides/develop/python/introduction#content-area)
🚀 **GLM Coding Plan — built for devs: 3× usage, 1/7 cost** • [Limited-Time Offer ➞](https://z.ai/subscribe?utm_campaign=Platform_Ops&_channel_track_key=DaprgHIc)
[Z.AI DEVELOPER DOCUMENT home page![light logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/dark.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=75deefa9dea5bdbc84d4da68885c267f)![dark logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/light.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=c1ecf1af358fa8eeab8c06052337f8f6)](https://z.ai/model-api)
English
Search...
⌘K
  * [API Keys](https://z.ai/manage-apikey/apikey-list)
  * [Payment Method](https://z.ai/manage-apikey/billing)


Search...
Navigation
SDKs Guide
Official Python SDK
[Guides](https://docs.z.ai/guides/overview/quick-start)[API Reference](https://docs.z.ai/api-reference/introduction)[Scenario Example](https://docs.z.ai/scenario-example/develop-tools/claude)[Coding Plan](https://docs.z.ai/devpack/overview)[Released Notes](https://docs.z.ai/release-notes/new-released)[Terms and Policy](https://docs.z.ai/legal-agreement/privacy-policy)[Help Center](https://docs.z.ai/help/faq)
##### Get Started
  * [Quick Start](https://docs.z.ai/guides/overview/quick-start)
  * [Overview](https://docs.z.ai/guides/overview/overview)
  * [Pricing](https://docs.z.ai/guides/overview/pricing)
  * [Core Parameters](https://docs.z.ai/guides/overview/concept-param)
  * SDKs Guide
    * [HTTP API Calls](https://docs.z.ai/guides/develop/http/introduction)
    * [Official Python SDK](https://docs.z.ai/guides/develop/python/introduction)
    * [Official Java SDK](https://docs.z.ai/guides/develop/java/introduction)
    * [OpenAI Python SDK](https://docs.z.ai/guides/develop/openai/python)
    * [LangChain Integration](https://docs.z.ai/guides/develop/langchain/introduction)
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
  * [Core Advantages](https://docs.z.ai/guides/develop/python/introduction#core-advantages)
  * [Supported Features](https://docs.z.ai/guides/develop/python/introduction#supported-features)
  * [Technical Specifications](https://docs.z.ai/guides/develop/python/introduction#technical-specifications)
  * [Environment Requirements](https://docs.z.ai/guides/develop/python/introduction#environment-requirements)
  * [Dependency Management](https://docs.z.ai/guides/develop/python/introduction#dependency-management)
  * [Quick Start](https://docs.z.ai/guides/develop/python/introduction#quick-start)
  * [Environment Requirements](https://docs.z.ai/guides/develop/python/introduction#environment-requirements-2)
  * [Install SDK](https://docs.z.ai/guides/develop/python/introduction#install-sdk)
  * [Install using pip](https://docs.z.ai/guides/develop/python/introduction#install-using-pip)
  * [Verify Installation](https://docs.z.ai/guides/develop/python/introduction#verify-installation)
  * [Get API Key](https://docs.z.ai/guides/develop/python/introduction#get-api-key)
  * [Create Client](https://docs.z.ai/guides/develop/python/introduction#create-client)
  * [Basic Conversation](https://docs.z.ai/guides/develop/python/introduction#basic-conversation)
  * [Streaming Conversation](https://docs.z.ai/guides/develop/python/introduction#streaming-conversation)
  * [Multi-turn Conversation](https://docs.z.ai/guides/develop/python/introduction#multi-turn-conversation)
  * [Complete Example](https://docs.z.ai/guides/develop/python/introduction#complete-example)
  * [Error Handling](https://docs.z.ai/guides/develop/python/introduction#error-handling)
  * [Advanced Configuration](https://docs.z.ai/guides/develop/python/introduction#advanced-configuration)
  * [Advanced Features](https://docs.z.ai/guides/develop/python/introduction#advanced-features)
  * [Function Calling](https://docs.z.ai/guides/develop/python/introduction#function-calling)
  * [Defining and Using Functions](https://docs.z.ai/guides/develop/python/introduction#defining-and-using-functions)
  * [Web Search Tool](https://docs.z.ai/guides/develop/python/introduction#web-search-tool)
  * [Video Generation](https://docs.z.ai/guides/develop/python/introduction#video-generation)
  * [Streaming Processing](https://docs.z.ai/guides/develop/python/introduction#streaming-processing)
  * [Getting Help](https://docs.z.ai/guides/develop/python/introduction#getting-help)


SDKs Guide
# Official Python SDK
Copy page
Copy page
Z.AI Python SDK is the official Python development toolkit provided by Z.AI, offering Python developers convenient and efficient AI model integration solutions.
### 
[​](https://docs.z.ai/guides/develop/python/introduction#core-advantages)
Core Advantages
## Simple and Easy
Pythonic API design, comprehensive documentation and examples for quick start
## Complete Features
Supports Z.AI’s full range of models, including language, vision, image generation, etc.
## High Performance
Async support, connection pool management, optimized network request handling
## Type Safety
Complete type hints, IDE-friendly, reducing development errors
### 
[​](https://docs.z.ai/guides/develop/python/introduction#supported-features)
Supported Features
  * **💬 Chat Conversations** : Support for single-turn and multi-turn conversations, streaming and non-streaming responses
  * **🔧 Function Calling** : Enable AI models to call your custom functions
  * **👁️ Vision Understanding** : Image analysis, visual understanding
  * **🎨 Image Generation** : Generate high-quality images from text descriptions
  * **🎬 Video Generation** : Creative content generation from text to video
  * **🔊 Speech Processing** : Speech-to-text, text-to-speech
  * **📊 Text Embedding** : Text vectorization, supporting semantic search
  * **🤖 Intelligent Assistants** : Build professional AI assistant applications
  * **🛡️ Content Moderation** : Text and image content safety detection


## 
[​](https://docs.z.ai/guides/develop/python/introduction#technical-specifications)
Technical Specifications
### 
[​](https://docs.z.ai/guides/develop/python/introduction#environment-requirements)
Environment Requirements
  * **Python Version** : Python 3.8 or higher
  * **Package Manager** : pip or poetry
  * **Network Requirements** : HTTPS connection support
  * **API Key** : Valid Z.AI API key required


### 
[​](https://docs.z.ai/guides/develop/python/introduction#dependency-management)
Dependency Management
The SDK adopts a modular design, allowing you to selectively install functional modules as needed:
  * **Core Module** : Basic API calling functionality
  * **Async Module** : Asynchronous and concurrent processing support
  * **Utility Module** : Utility tools and auxiliary functions


## 
[​](https://docs.z.ai/guides/develop/python/introduction#quick-start)
Quick Start
### 
[​](https://docs.z.ai/guides/develop/python/introduction#environment-requirements-2)
Environment Requirements
## Python Version
Python 3.8 or higher
## Package Manager
poetry (recommended), uv (recommended), pip
Supports Python 3.8, 3.9, 3.10, 3.11, 3.12 versions, cross-platform compatible with Windows, macOS, Linux
### 
[​](https://docs.z.ai/guides/develop/python/introduction#install-sdk)
Install SDK
#### 
[​](https://docs.z.ai/guides/develop/python/introduction#install-using-pip)
Install using pip
Copy
```
# Install latest version
pip install zai-sdk
# Or specify version
pip install zai-sdk==0.0.4

```

#### 
[​](https://docs.z.ai/guides/develop/python/introduction#verify-installation)
Verify Installation
Copy
```
import zai
print(zai.__version__)

```

### 
[​](https://docs.z.ai/guides/develop/python/introduction#get-api-key)
Get API Key
  1. Access [Z.AI Open Platform](https://z.ai/model-api), Register or Login.
  2. Create an API Key in the [API Keys](https://z.ai/manage-apikey/apikey-list) management page.
  3. Copy your API Key for use.


It is recommended to set the API Key as an environment variable: `export ZAI_API_KEY=your-api-key`
Domestic Z.AI platform uses ZaiClient
Copy
```
Domestic API URL: https://api.z.ai/api/paas/v4/

```

#### 
[​](https://docs.z.ai/guides/develop/python/introduction#create-client)
Create Client
  * Environment Variable
  * Direct Setting


Copy
```
from zai import ZaiClient
import os
# Read API Key from environment variable
client = ZaiClient(api_key=os.getenv("ZAI_API_KEY"))
# Or use directly (if environment variable is set)
client = ZaiClient()

```

#### 
[​](https://docs.z.ai/guides/develop/python/introduction#basic-conversation)
Basic Conversation
Copy
```
from zai import ZaiClient
# Initialize client
client = ZaiClient(api_key="your-api-key")
# Create chat completion
response = client.chat.completions.create(
  model="glm-4.6",
  messages=[
    {"role": "user", "content": "Hello, please introduce yourself, Z.ai!"}
  ]
)
print(response.choices[0].message.content)

```

#### 
[​](https://docs.z.ai/guides/develop/python/introduction#streaming-conversation)
Streaming Conversation
Copy
```
# Create streaming chat request
from zai import ZaiClient
# Initialize client
client = ZaiClient(api_key="your-api-key")
# Create chat completion
response = client.chat.completions.create(
  model='glm-4.6',
  messages=[
    {'role': 'system', 'content': 'You are an AI writer.'},
    {'role': 'user', 'content': 'Tell a story about AI.'},
  ],
  stream=True,
)
for chunk in response:
  if chunk.choices[0].delta.content:
    print(chunk.choices[0].delta.content, end='')

```

#### 
[​](https://docs.z.ai/guides/develop/python/introduction#multi-turn-conversation)
Multi-turn Conversation
Copy
```
from zai import ZaiClient
client = ZaiClient(api_key="your-api-key")
response = client.chat.completions.create(
  model="glm-4.6", # Please fill in the model name you want to call
  messages=[
    {"role": "user", "content": "As a marketing expert, please create an attractive slogan for my product"},
    {"role": "assistant", "content": "Of course, to create an attractive slogan, please tell me some information about your product"},
    {"role": "user", "content": "Z.AI Open Platform"},
    {"role": "assistant", "content": "Ignite the future, Z.AI draws infinite possibilities, making innovation within reach!"},
    {"role": "user", "content": "Create a more precise and attractive slogan"}
  ],
)
print(response.choices[0].message.content)

```

### 
[​](https://docs.z.ai/guides/develop/python/introduction#complete-example)
Complete Example
Copy
```
from zai import ZaiClient
import os
def main():
  # Initialize client
  client = ZaiClient(api_key=os.getenv("ZAI_API_KEY"))
  print("Welcome to Z.ai Chatbot! Type 'quit' to exit.")
  # Conversation history
  conversation = [
    {"role": "system", "content": "You are a friendly AI assistant"}
  ]
  while True:
    # Get user input
    user_input = input("You: ")
    if user_input.lower() == 'quit':
      break
    try:
      # Add user message
      conversation.append({"role": "user", "content": user_input})
      # Create chat request
      response = client.chat.completions.create(
        model="glm-4.6",
        messages=conversation,
        temperature=0.6,
        max_tokens=1000
      )
      # Get AI response
      ai_response = response.choices[0].message.content
      print(f"AI: {ai_response}")
      # Add AI response to conversation history
      conversation.append({"role": "assistant", "content": ai_response})
    except Exception as e:
      print(f"Error occurred: {e}")
  print("Goodbye!")
if __name__ == "__main__":
  main()

```

### 
[​](https://docs.z.ai/guides/develop/python/introduction#error-handling)
Error Handling
Copy
```
from zai import ZaiClient
import zai
def robust_chat(message):
  client = ZaiClient(api_key="your-api-key")
  try:
    response = client.chat.completions.create(
      model="glm-4.6",
      messages=[{"role": "user", "content": message}]
    )
    return response.choices[0].message.content
  except zai.core.APIStatusError as err:
    return f"API status error: {err}"
  except zai.core.APITimeoutError as err:
    return f"Request timeout: {err}"
  except Exception as err:
    return f"Other error: {err}"
# Usage example
result = robust_chat("Hello")
print(result)

```

### 
[​](https://docs.z.ai/guides/develop/python/introduction#advanced-configuration)
Advanced Configuration
Copy
```
import httpx
from zai import ZaiClient
# Custom HTTP client
httpx_client = httpx.Client(
  limits=httpx.Limits(
    max_keepalive_connections=20,
    max_connections=100
  ),
  timeout=30.0
)
# Create client with custom configuration
client = ZaiClient(
  api_key="your-api-key",
  base_url="https://api.z.ai/api/paas/v4/",
  timeout=httpx.Timeout(timeout=300.0, connect=8.0),
  max_retries=3,
  http_client=httpx_client
)

```

## 
[​](https://docs.z.ai/guides/develop/python/introduction#advanced-features)
Advanced Features
### 
[​](https://docs.z.ai/guides/develop/python/introduction#function-calling)
Function Calling
Function calling allows AI models to call functions you define to get real-time information or perform specific operations.
#### 
[​](https://docs.z.ai/guides/develop/python/introduction#defining-and-using-functions)
Defining and Using Functions
Copy
```
from zai import ZaiClient
import json
# Define functions
def get_weather(location, date=None):
  """Get weather information"""
  # Simulate weather API call
  return {
    "location": location,
    "date": date or "today",
    "weather": "sunny",
    "temperature": "25°C",
    "humidity": "60%"
  }
def get_stock_price(symbol):
  """Get stock price"""
  # Simulate stock API call
  return {
    "symbol": symbol,
    "price": 150.25,
    "change": "+2.5%"
  }
# Function descriptions
tools = [
  {
    "type": "function",
    "function": {
      "name": "get_weather",
      "description": "Get weather information for a specified location",
      "parameters": {
        "type": "object",
        "properties": {
          "location": {
            "type": "string",
            "description": "Location name"
          },
          "date": {
            "type": "string",
            "description": "Date in YYYY-MM-DD format"
          }
        },
        "required": ["location"]
      }
    }
  },
  {
    "type": "function",
    "function": {
      "name": "get_stock_price",
      "description": "Get current stock price",
      "parameters": {
        "type": "object",
        "properties": {
          "symbol": {
            "type": "string",
            "description": "Stock symbol"
          }
        },
        "required": ["symbol"]
      }
    }
  }
]
# Use function calling
client = ZaiClient(api_key="your-api-key")
response = client.chat.completions.create(
  model='glm-4.6',
  messages=[
    {'role': 'user', 'content': 'How\'s the weather in Beijing today?'}
  ],
  tools=tools,
  tool_choice="auto"
)
# Handle function calling
if response.choices[0].message.tool_calls:
  for tool_call in response.choices[0].message.tool_calls:
    function_name = tool_call.function.name
    function_args = json.loads(tool_call.function.arguments)
    if function_name == "get_weather":
      result = get_weather(**function_args)
      print(f"Weather info: {result}")
    elif function_name == "get_stock_price":
      result = get_stock_price(**function_args)
      print(f"Stock info: {result}")
else:
  print(response.choices[0].message.content)

```

### 
[​](https://docs.z.ai/guides/develop/python/introduction#web-search-tool)
Web Search Tool
Copy
```
from zai import ZaiClient
# Initialize client
client = ZaiClient(api_key="your-api-key")
# Use web search tool
response = client.chat.completions.create(
  model='glm-4.6',
  messages=[
    {'role': 'system', 'content': 'You are a helpful assistant.'},
    {'role': 'user', 'content': 'What is artificial intelligence?'},
  ],
  tools=[
    {
      'type': 'web_search',
      'web_search': {
        'search_query': 'What is artificial intelligence?',
        'search_result': True,
      },
    }
  ],
  temperature=0.5,
  max_tokens=2000,
)
print(response)

```

### 
[​](https://docs.z.ai/guides/develop/python/introduction#video-generation)
Video Generation
Copy
```
from zai import ZaiClient
import time
client = ZaiClient(api_key="your-api-key")
# Submit generation task
response = client.videos.generations(
  model="cogvideox-3", # Video generation model to use
  image_url=image_url, # Provided image URL or Base64 encoding
  prompt="Make the scene come alive",
  quality="speed", # Output mode: "quality" for quality priority, "speed" for speed priority
  with_audio=True,
  size="1920x1080", # Video resolution, supports up to 4K (e.g., "3840x2160")
  fps=30, # Frame rate, can be 30 or 60
)
print(response)
# Get generation result
time.sleep(60) # Wait for a while to ensure video generation is complete
result = client.videos.retrieve_videos_result(id=response.id)
print(result)

```

### 
[​](https://docs.z.ai/guides/develop/python/introduction#streaming-processing)
Streaming Processing
Copy
```
class StreamProcessor:
  def __init__(self, client):
    self.client = client
    self.full_response = ""
  def stream_chat(self, messages, model="glm-4.6", callback=None):
    """Streaming chat processing"""
    stream = self.client.chat.completions.create(
      model=model,
      messages=messages,
      stream=True
    )
    self.full_response = ""
    for chunk in stream:
      if chunk.choices[0].delta.content is not None:
        content = chunk.choices[0].delta.content
        self.full_response += content
        if callback:
          callback(content, self.full_response)
        else:
          print(content, end="", flush=True)
    print() # New line
    return self.full_response
# Usage example
processor = StreamProcessor(client)
# Custom callback function
def on_token_received(token, full_text):
  # You can implement real-time processing logic here
  print(token, end="", flush=True)
response = processor.stream_chat(
  messages=[{"role": "user", "content": "Write a Python function to calculate Fibonacci sequence"}],
  callback=on_token_received
)

```

## 
[​](https://docs.z.ai/guides/develop/python/introduction#getting-help)
Getting Help
## [GitHub RepositoryView source code, submit issues, contribute](https://github.com/zai-org/z-ai-sdk-python)## [API ReferenceView complete API documentation](https://docs.z.ai/api-reference)## [Example ProjectsBrowse more practical application examples](https://github.com/zai-org/z-ai-sdk-python/tree/main/examples)## [Best PracticesLearn best practices for SDK usage](https://github.com/zai-org/z-ai-sdk-python)
This SDK is developed based on the latest API specifications from Z.AI, ensuring synchronization with platform features. It is recommended to regularly update to the latest version for the best experience.
Was this page helpful?
YesNo
[HTTP API Calls](https://docs.z.ai/guides/develop/http/introduction)[Official Java SDK](https://docs.z.ai/guides/develop/java/introduction)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
