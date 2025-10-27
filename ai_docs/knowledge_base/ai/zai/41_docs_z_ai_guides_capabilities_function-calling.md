# https://docs.z.ai/guides/capabilities/function-calling

Source: [https://docs.z.ai/guides/capabilities/function-calling](https://docs.z.ai/guides/capabilities/function-calling)

---

[Skip to main content](https://docs.z.ai/guides/capabilities/function-calling#content-area)
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
Function Calling
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
  * [Features](https://docs.z.ai/guides/capabilities/function-calling#features)
  * [Core Parameter Description](https://docs.z.ai/guides/capabilities/function-calling#core-parameter-description)
  * [Response Parameter Description](https://docs.z.ai/guides/capabilities/function-calling#response-parameter-description)
  * [Features](https://docs.z.ai/guides/capabilities/function-calling#features-2)
  * [Code Examples](https://docs.z.ai/guides/capabilities/function-calling#code-examples)
  * [Scenario Examples](https://docs.z.ai/guides/capabilities/function-calling#scenario-examples)
  * [Best Practices](https://docs.z.ai/guides/capabilities/function-calling#best-practices)
  * [Parameter Design](https://docs.z.ai/guides/capabilities/function-calling#parameter-design)
  * [Error Handling](https://docs.z.ai/guides/capabilities/function-calling#error-handling)
  * [Input Validation](https://docs.z.ai/guides/capabilities/function-calling#input-validation)
  * [Permission Control](https://docs.z.ai/guides/capabilities/function-calling#permission-control)


Capabilities
# Function Calling
Copy page
Copy page
Function Calling allows AI models to call external functions and APIs, greatly expanding the capability boundaries of intelligent agents, enabling them to perform specific operations and obtain real-time data.
##
[​](https://docs.z.ai/guides/capabilities/function-calling#features)
Features
Function calling provides AI models with the ability to interact with external systems, supporting various complex application scenarios and integration requirements.
###
[​](https://docs.z.ai/guides/capabilities/function-calling#core-parameter-description)
Core Parameter Description
  * **`tools`**: Defines the list of callable functions, including function names, descriptions, and parameter specifications
  * **`tool_choice`**: Controls function calling strategy, can be set to`auto` , `none`, or specify a function name
  * **`model`**: Uses models that support function calling, such as`glm-4-plus` , `glm-4.6`, etc.


###
[​](https://docs.z.ai/guides/capabilities/function-calling#response-parameter-description)
Response Parameter Description
Key fields in function calling responses:
  * **`tool_calls`**: Contains information about functions the model decides to call
  * **`function.name`**: Name of the called function
  * **`function.arguments`**: Function call parameters (JSON format string)
  * **`id`**: Unique identifier for the tool call


###
[​](https://docs.z.ai/guides/capabilities/function-calling#features-2)
Features
## Structured Output
  * Automatic function parameter parsing
  * Type validation and conversion
  * Error handling and retry
  * Result formatting


## Multi-function Support
  * Define multiple functions simultaneously
  * Function chaining calls
  * Conditional function selection
  * Parallel function execution


## Flexible Integration
  * RESTful API integration
  * Database operations
  * File system access
  * Third-party service calls


##
[​](https://docs.z.ai/guides/capabilities/function-calling#code-examples)
Code Examples
By defining function tools and handling function calls, AI models can perform various external operations:
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
import json
from zai import ZaiClient
# Initialize client
client = ZaiClient(api_key='your_api_key')
# Define weather query function
def get_weather(city: str) -> dict:
  """Get weather information for specified city"""
  # This should call a real weather API
  weather_data = {
    "city": city,
    "temperature": "22°C",
    "condition": "Sunny",
    "humidity": "65%",
    "wind_speed": "5 km/h"
  }
  return weather_data
# Define function tools
tools = [
  {
    "type": "function",
    "function": {
      "name": "get_weather",
      "description": "Get current weather information for specified city",
      "parameters": {
        "type": "object",
        "properties": {
          "city": {
            "type": "string",
            "description": "City name, e.g.: Beijing, Shanghai"
          }
        },
        "required": ["city"]
      }
    }
  }
]
# Make conversation request
response = client.chat.completions.create(
  model="glm-4-plus", # Use model that supports function calling
  messages=[
    {"role": "user", "content": "How's the weather in Beijing today?"}
  ],
  tools=tools,     # Pass function tools
  tool_choice="auto"  # Automatically choose whether to call functions
)
# Handle function calls
message = response.choices[0].message
messages = [{"role": "user", "content": "How's the weather in Beijing today?"}]
messages.append(message.model_dump())
if message.tool_calls:
  for tool_call in message.tool_calls:
    if tool_call.function.name == "get_weather":
      # Parse parameters and call function
      args = json.loads(tool_call.function.arguments)
      weather_result = get_weather(args.get("city"))
      # Return function result to model
      messages.append({
        "role": "tool",
        "content": json.dumps(weather_result, ensure_ascii=False),
        "tool_call_id": tool_call.id
      })
  # Get final answer
  final_response = client.chat.completions.create(
    model="glm-4-plus",
    messages=messages,
    tools=tools
  )
  print(final_response.choices[0].message.content)
else:
  print(message.content)

```

##
[​](https://docs.z.ai/guides/capabilities/function-calling#scenario-examples)
Scenario Examples
When using function calling, please ensure proper security validation and permission control for external APIs and database operations.
Multi-function Assistant
Copy
```
import json
import requests
from datetime import datetime
from zai import ZaiClient
class FunctionAgent:
  def __init__(self, api_key):
    self.client = ZaiClient(api_key=api_key)
    self.tools = self._define_tools()
  def _define_tools(self):
    return [
      {
        "type": "function",
        "function": {
          "name": "get_current_time",
          "description": "Get current time",
          "parameters": {
            "type": "object",
            "properties": {},
            "required": []
          }
        }
      },
      {
        "type": "function",
        "function": {
          "name": "calculate",
          "description": "Perform mathematical calculations",
          "parameters": {
            "type": "object",
            "properties": {
              "expression": {
                "type": "string",
                "description": "Mathematical expression, e.g.: 2+3*4"
              }
            },
            "required": ["expression"]
          }
        }
      },
      {
        "type": "function",
        "function": {
          "name": "search_web",
          "description": "Search web information",
          "parameters": {
            "type": "object",
            "properties": {
              "query": {
                "type": "string",
                "description": "Search keywords"
              }
            },
            "required": ["query"]
          }
        }
      }
    ]
  def get_current_time(self):
    """Get current time"""
    return {
      "current_time": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
      "timezone": "Asia/Shanghai"
    }
  def calculate(self, expression: str):
    """Safe mathematical calculation"""
    try:
      # Simple security check
      allowed_chars = set('0123456789+-*/().')
      if not all(c in allowed_chars or c.isspace() for c in expression):
        return {"error": "Expression contains disallowed characters"}
      result = eval(expression)
      return {
        "expression": expression,
        "result": result
      }
    except Exception as e:
      return {"error": f"Calculation error: {str(e)}"}
  def search_web(self, query: str):
    """Simulate web search"""
    # This should call a real search API
    return {
      "query": query,
      "results": [
        {"title": f"Search result 1 about {query}", "url": "https://example1.com"},
        {"title": f"Search result 2 about {query}", "url": "https://example2.com"}
      ]
    }
  def execute_function(self, function_name: str, arguments: dict):
    """Execute function call"""
    if function_name == "get_current_time":
      return self.get_current_time()
    elif function_name == "calculate":
      return self.calculate(arguments.get("expression", ""))
    elif function_name == "search_web":
      return self.search_web(arguments.get("query", ""))
    else:
      return {"error": f"Unknown function: {function_name}"}
  def chat(self, user_message: str):
    """Handle user message"""
    messages = [{"role": "user", "content": user_message}]
    response = self.client.chat.completions.create(
      model="glm-4-plus",
      messages=messages,
      tools=self.tools,
      tool_choice="auto"
    )
    message = response.choices[0].message
    messages.append(message.model_dump())
    # Handle function calls
    if message.tool_calls:
      for tool_call in message.tool_calls:
        function_name = tool_call.function.name
        arguments = json.loads(tool_call.function.arguments)
        # Execute function
        result = self.execute_function(function_name, arguments)
        # Add function result
        messages.append({
          "role": "tool",
          "content": json.dumps(result, ensure_ascii=False),
          "tool_call_id": tool_call.id
        })
      # Get final answer
      final_response = self.client.chat.completions.create(
        model="glm-4-plus",
        messages=messages,
        tools=self.tools
      )
      return final_response.choices[0].message.content
    else:
      return message.content
# Usage example
agent = FunctionAgent("your_api_key")
# Test different types of requests
print(agent.chat("What time is it now?"))
print(agent.chat("Help me calculate 15 * 23 + 7"))
print(agent.chat("Search for the latest developments in artificial intelligence"))

```

Database Query
Copy
```
import sqlite3
def query_database(sql: str) -> dict:
  """Execute database query"""
  try:
    conn = sqlite3.connect('example.db')
    cursor = conn.cursor()
    cursor.execute(sql)
    results = cursor.fetchall()
    conn.close()
    return {
      "success": True,
      "data": results,
      "row_count": len(results)
    }
  except Exception as e:
    return {
      "success": False,
      "error": str(e)
    }
# Function definition
db_tool = {
  "type": "function",
  "function": {
    "name": "query_database",
    "description": "Execute SQL query",
    "parameters": {
      "type": "object",
      "properties": {
        "sql": {
          "type": "string",
          "description": "SQL query statement"
        }
      },
      "required": ["sql"]
    }
  }
}

```

File Operations
Copy
```
import os
import json
def file_operations(operation: str, file_path: str, content: str = None) -> dict:
  """File operation function"""
  try:
    if operation == "read":
      with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
      return {"success": True, "content": content}
    elif operation == "write":
      with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
      return {"success": True, "message": "File written successfully"}
    elif operation == "list":
      files = os.listdir(file_path)
      return {"success": True, "files": files}
    else:
      return {"success": False, "error": "Unsupported operation"}
  except Exception as e:
    return {"success": False, "error": str(e)}
# Function definition
file_tool = {
  "type": "function",
  "function": {
    "name": "file_operations",
    "description": "Execute file operations",
    "parameters": {
      "type": "object",
      "properties": {
        "operation": {
          "type": "string",
          "enum": ["read", "write", "list"],
          "description": "Operation type"
        },
        "file_path": {
          "type": "string",
          "description": "File path"
        },
        "content": {
          "type": "string",
          "description": "Content to write (only required for write operation)"
        }
      },
      "required": ["operation", "file_path"]
    }
  }
}

```

API Integration
Copy
```
import requests
def call_external_api(url: str, method: str = "GET", headers: dict = None, data: dict = None) -> dict:
  """Call external API"""
  try:
    if method.upper() == "GET":
      response = requests.get(url, headers=headers, params=data)
    elif method.upper() == "POST":
      response = requests.post(url, headers=headers, json=data)
    else:
      return {"success": False, "error": "Unsupported HTTP method"}
    return {
      "success": True,
      "status_code": response.status_code,
      "data": response.json() if response.headers.get('content-type', '').startswith('application/json') else response.text
    }
  except Exception as e:
    return {"success": False, "error": str(e)}
# Function definition
api_tool = {
  "type": "function",
  "function": {
    "name": "call_external_api",
    "description": "Call external API",
    "parameters": {
      "type": "object",
      "properties": {
        "url": {
          "type": "string",
          "description": "API endpoint URL"
        },
        "method": {
          "type": "string",
          "enum": ["GET", "POST"],
          "description": "HTTP method"
        },
        "headers": {
          "type": "object",
          "description": "Request headers"
        },
        "data": {
          "type": "object",
          "description": "Request data"
        }
      },
      "required": ["url"]
    }
  }
}

```

##
[​](https://docs.z.ai/guides/capabilities/function-calling#best-practices)
Best Practices
## Function Design Principles
  * Single responsibility: Each function should do one thing
  * Clear naming: Function and parameter names should be meaningful
  * Complete description: Provide detailed function and parameter descriptions


## Security Considerations
  * Input validation: Strictly validate all input parameters
  * Permission control: Limit function access permissions
  * Logging: Record function call logs


###
[​](https://docs.z.ai/guides/capabilities/function-calling#parameter-design)
Parameter Design
Copy
```
# Good parameter design
{
  "type": "object",
  "properties": {
    "city": {
      "type": "string",
      "description": "City name, supports Chinese and English, e.g.: Beijing, Shanghai, New York",
      "examples": ["Beijing", "Shanghai", "New York"]
    },
    "unit": {
      "type": "string",
      "enum": ["celsius", "fahrenheit"],
      "description": "Temperature unit",
      "default": "celsius"
    }
  },
  "required": ["city"]
}

```

###
[​](https://docs.z.ai/guides/capabilities/function-calling#error-handling)
Error Handling
Copy
```
def robust_function(param: str) -> dict:
  """Robust function implementation"""
  try:
    # Parameter validation
    if not param or not isinstance(param, str):
      return {
        "success": False,
        "error": "Invalid parameter",
        "error_code": "INVALID_PARAM"
      }
    # Business logic
    result = process_data(param)
    return {
      "success": True,
      "data": result,
      "timestamp": datetime.now().isoformat()
    }
  except ValueError as e:
    return {
      "success": False,
      "error": f"Data error: {str(e)}",
      "error_code": "DATA_ERROR"
    }
  except Exception as e:
    return {
      "success": False,
      "error": f"System error: {str(e)}",
      "error_code": "SYSTEM_ERROR"
    }

```

###
[​](https://docs.z.ai/guides/capabilities/function-calling#input-validation)
Input Validation
Copy
```
def secure_function(user_input: str) -> dict:
  """Secure function implementation"""
  # Input length limit
  if len(user_input) > 1000:
    return {"error": "Input too long"}
  # Dangerous character filtering
  dangerous_chars = ['<', '>', '&', '"', "'"]
  if any(char in user_input for char in dangerous_chars):
    return {"error": "Input contains dangerous characters"}
  # SQL injection protection
  sql_keywords = ['DROP', 'DELETE', 'UPDATE', 'INSERT']
  if any(keyword in user_input.upper() for keyword in sql_keywords):
    return {"error": "Input contains dangerous keywords"}
  return {"success": True, "processed_input": user_input}

```

###
[​](https://docs.z.ai/guides/capabilities/function-calling#permission-control)
Permission Control
Copy
```
def check_permissions(user_id: str, operation: str) -> bool:
  """Check user permissions"""
  user_permissions = get_user_permissions(user_id)
  return operation in user_permissions
def protected_function(user_id: str, operation: str, data: dict) -> dict:
  """Function requiring permission validation"""
  if not check_permissions(user_id, operation):
    return {
      "success": False,
      "error": "Insufficient permissions",
      "error_code": "PERMISSION_DENIED"
    }
  # Execute operation
  return perform_operation(operation, data)

```

It is recommended to provide detailed documentation and examples for each function to help the model better understand the function’s purpose and usage.
Function calling involves code execution. Please ensure appropriate security measures are implemented, including input validation, permission control, and error handling.
Was this page helpful?
YesNo
[Tool Streaming Output](https://docs.z.ai/guides/capabilities/stream-tool)[Context Caching](https://docs.z.ai/guides/capabilities/cache)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
