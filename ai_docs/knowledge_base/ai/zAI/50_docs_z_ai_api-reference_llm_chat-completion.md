# https://docs.z.ai/api-reference/llm/chat-completion

Source: [https://docs.z.ai/api-reference/llm/chat-completion](https://docs.z.ai/api-reference/llm/chat-completion)

---

[Skip to main content](https://docs.z.ai/api-reference/llm/chat-completion#content-area)
🚀 **GLM Coding Plan — built for devs: 3× usage, 1/7 cost** • [Limited-Time Offer ➞](https://z.ai/subscribe?utm_campaign=Platform_Ops&_channel_track_key=DaprgHIc)
[Z.AI DEVELOPER DOCUMENT home page![light logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/dark.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=75deefa9dea5bdbc84d4da68885c267f)![dark logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/light.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=c1ecf1af358fa8eeab8c06052337f8f6)](https://z.ai/model-api)
English
Search...
⌘K
  * [API Keys](https://z.ai/manage-apikey/apikey-list)
  * [Payment Method](https://z.ai/manage-apikey/billing)


Search...
Navigation
Model API
Chat Completion
[Guides](https://docs.z.ai/guides/overview/quick-start)[API Reference](https://docs.z.ai/api-reference/introduction)[Scenario Example](https://docs.z.ai/scenario-example/develop-tools/claude)[Coding Plan](https://docs.z.ai/devpack/overview)[Released Notes](https://docs.z.ai/release-notes/new-released)[Terms and Policy](https://docs.z.ai/legal-agreement/privacy-policy)[Help Center](https://docs.z.ai/help/faq)
##### Using the APIs
  * [Introduction](https://docs.z.ai/api-reference/introduction)
  * [Errors](https://docs.z.ai/api-reference/api-code)
  * [Rate Limits](https://z.ai/manage-apikey/rate-limits)


##### Model API
  * [POSTChat Completion](https://docs.z.ai/api-reference/llm/chat-completion)


##### Image API
  * [POSTGenerate Image](https://docs.z.ai/api-reference/image/generate-image)


##### Video API
  * [POSTGenerate Video(Async)](https://docs.z.ai/api-reference/video/generate-video)
  * [GETRetrieve Result](https://docs.z.ai/api-reference/video/get-video-status)


##### Tool API
  * [POSTWeb Search](https://docs.z.ai/api-reference/tools/web-search)


##### Agent API
  * [POSTAgent Chat](https://docs.z.ai/api-reference/agents/agent)
  * [POSTFile Upload](https://docs.z.ai/api-reference/agents/file-upload)
  * [POSTRetrieve Result](https://docs.z.ai/api-reference/agents/get-async-result)
  * [POSTConversation History](https://docs.z.ai/api-reference/agents/agent-conversation)


cURL
Basic Example
Copy
```
curl --request POST \ --url https://api.z.ai/api/paas/v4/chat/completions \ --header 'Authorization: Bearer <token>' \ --header 'Content-Type: application/json' \ --data '{ "model": "glm-4.6", "messages": [  {   "role": "system",   "content": "You are a useful AI assistant."  },  {   "role": "user",   "content": "Please tell us about the development of artificial intelligence."  } ], "temperature": 1, "max_tokens": 65536, "stream": false}'
```

200
default
Copy
```
{
 "id": "<string>",
 "request_id": "<string>",
 "created": 123,
 "model": "<string>",
 "choices": [
  {
   "index": 123,
   "message": {
    "role": "assistant",
    "content": "<string>",
    "reasoning_content": "<string>",
    "tool_calls": [
     {
      "function": {
       "name": "<string>",
       "arguments": {}
      },
      "id": "<string>",
      "type": "<string>"
     }
    ]
   },
   "finish_reason": "<string>"
  }
 ],
 "usage": {
  "prompt_tokens": 123,
  "completion_tokens": 123,
  "prompt_tokens_details": {
   "cached_tokens": 123
  },
  "total_tokens": 123
 },
 "web_search": [
  {
   "title": "<string>",
   "content": "<string>",
   "link": "<string>",
   "media": "<string>",
   "icon": "<string>",
   "refer": "<string>",
   "publish_date": "<string>"
  }
 ]
}
```

Model API
# Chat Completion
Copy page
Create a chat completion model that generates AI replies for given conversation messages. It supports multimodal inputs (text, images, audio, video, file), offers configurable parameters (like temperature, max tokens, tool use), and supports both streaming and non-streaming output modes.
Copy page
POST
/
paas
/
v4
/
chat
/
completions
Try it
cURL
Basic Example
Copy
```
curl --request POST \ --url https://api.z.ai/api/paas/v4/chat/completions \ --header 'Authorization: Bearer <token>' \ --header 'Content-Type: application/json' \ --data '{ "model": "glm-4.6", "messages": [  {   "role": "system",   "content": "You are a useful AI assistant."  },  {   "role": "user",   "content": "Please tell us about the development of artificial intelligence."  } ], "temperature": 1, "max_tokens": 65536, "stream": false}'
```

200
default
Copy
```
{
 "id": "<string>",
 "request_id": "<string>",
 "created": 123,
 "model": "<string>",
 "choices": [
  {
   "index": 123,
   "message": {
    "role": "assistant",
    "content": "<string>",
    "reasoning_content": "<string>",
    "tool_calls": [
     {
      "function": {
       "name": "<string>",
       "arguments": {}
      },
      "id": "<string>",
      "type": "<string>"
     }
    ]
   },
   "finish_reason": "<string>"
  }
 ],
 "usage": {
  "prompt_tokens": 123,
  "completion_tokens": 123,
  "prompt_tokens_details": {
   "cached_tokens": 123
  },
  "total_tokens": 123
 },
 "web_search": [
  {
   "title": "<string>",
   "content": "<string>",
   "link": "<string>",
   "media": "<string>",
   "icon": "<string>",
   "refer": "<string>",
   "publish_date": "<string>"
  }
 ]
}
```

#### Authorizations
[​](https://docs.z.ai/api-reference/llm/chat-completion#authorization-authorization)
Authorization
string
header
required
Use the following format for authentication: Bearer [<your api key>](https://z.ai/manage-apikey/apikey-list)
#### Headers
[​](https://docs.z.ai/api-reference/llm/chat-completion#parameter-accept-language)
Accept-Language
enum<string>
default:en-US,en
Config desired response language for HTTP requests.
Available options: 
`en-US,en`
Example:
`"en-US,en"`
#### Body
application/json
  * Text Model
  * Vision Model


[​](https://docs.z.ai/api-reference/llm/chat-completion#body-model)
model
enum<string>
default:glm-4.6
required
The model code to be called. GLM-4.6 are the latest flagship model series, foundational models specifically designed for agent applications.
Available options: 
`glm-4.6`, 
`glm-4.5`, 
`glm-4.5-air`, 
`glm-4.5-x`, 
`glm-4.5-airx`, 
`glm-4.5-flash`, 
`glm-4-32b-0414-128k`
Example:
`"glm-4.6"`
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-messages)
messages
(User Message · object | System Message · object | Assistant Message · object | Tool Message · object)[]
required
The current conversation message list as the model’s prompt input, provided in JSON array format, e.g.,`{“role”: “user”, “content”: “Hello”}`. Possible message types include system messages, user messages, assistant messages, and tool messages. Note: The input must not consist of system messages or assistant messages only.
Minimum length: `1`
  * User Message
  * System Message
  * Assistant Message
  * Tool Message


Hide child attributes
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-messages-role)
role
enum<string>
default:user
required
Role of the message author
Available options: 
`user`
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-messages-content)
content
string
required
Text message content
Example:
`"What opportunities and challenges will the Chinese large model industry face in 2025?"`
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-request-id)
request_id
string
Passed by the user side, needs to be unique; used to distinguish each request. If not provided by the user side, the platform will generate one by default.
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-do-sample)
do_sample
boolean
default:true
When do_sample is true, sampling strategy is enabled; when do_sample is false, sampling strategy parameters such as temperature and top_p will not take effect. Default value is `true`.
Example:
`true`
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-stream)
stream
boolean
default:false
This parameter should be set to false or omitted when using synchronous call. It indicates that the model returns all content at once after generating all content. Default value is false. If set to true, the model will return the generated content in chunks via standard Event Stream. When the Event Stream ends, a `data: [DONE]` message will be returned.
Example:
`false`
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-thinking)
thinking
object
Only supported by GLM-4.5 series and higher models. This parameter is used to control whether the model enable the chain of thought.
Hide child attributes
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-thinking-type)
thinking.type
enum<string>
default:enabled
Whether to enable the chain of thought(When enabled, GLM-4.6, GLM-4.5 and others will automatically determine whether to think, while GLM-4.5V will think compulsorily), default: enabled
Available options: 
`enabled`, 
`disabled`
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-temperature)
temperature
number
default:1
Sampling temperature, controls the randomness of the output, must be a positive number within the range: `[0.0, 1.0]`. The GLM-4.6 series default value is `1.0`, GLM-4.5 series default value is `0.6`, GLM-4-32B-0414-128K default value is `0.75`.
Required range: `0 <= x <= 1`
Example:
`1`
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-top-p)
top_p
number
default:0.95
Another method of temperature sampling, value range is: `(0.0, 1.0]`. The GLM-4.6, GLM-4.5 series default value is `0.95`, GLM-4-32B-0414-128K default value is `0.9`.
Required range: `0 <= x <= 1`
Example:
`0.95`
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-max-tokens)
max_tokens
integer
The maximum number of tokens for model output, the GLM-4.6 series supports 128K maximum output, the GLM-4.5 series supports 96K maximum output, the GLM-4.5v series supports 16K maximum output, GLM-4-32B-0414-128K supports 16K maximum output.
Required range: `1 <= x <= 98304`
Example:
`1024`
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-tool-stream)
tool_stream
boolean
default:false
Whether to enable streaming response for Function Calls. Default value is false. Only supported by GLM-4.6. Refer the [Stream Tool Call](https://docs.z.ai/guides/tools/stream-tool)
Example:
`false`
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-tools)
tools
(Function Call · object | Retrieval · object | Web Search · object)[]
A list of tools the model may call. Currently, only functions are supported as a tool. Use this to provide a list of functions the model may generate JSON inputs for. A max of 128 functions are supported.
  * Function Call
  * Retrieval
  * Web Search


Hide child attributes
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-tools-type)
type
enum<string>
default:function
required
Available options: 
`function`
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-tools-function)
function
object
required
Hide child attributes
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-function-name)
function.name
string
required
The name of the function to be called. Must be a-z, A-Z, 0-9, or contain underscores and dashes, with a maximum length of 64.
Required string length: `1 - 64`
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-function-description)
function.description
string
required
A description of what the function does, used by the model to choose when and how to call the function.
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-function-parameters)
function.parameters
object
required
Parameters defined using JSON Schema. Must pass a JSON Schema object to accurately define accepted parameters. Omit if no parameters are needed when calling the function.
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-tool-choice)
tool_choice
enum<string>
Controls how the model selects a tool. Used to control how the model selects which function to call. This is only applicable when the tool type is function. The default value is auto, and only auto is supported.
Available options: 
`auto`
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-stop)
stop
string[]
Stop word list. Generation stops when the model encounters any specified string. Currently, only one stop word is supported, in the format ["stop_word1"].
Maximum length: `1`
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-response-format)
response_format
object
Specifies the response format of the model. Defaults to text. Supports two formats:{ "type": "text" } plain text mode, returns natural language text, { "type": "json_object" } JSON mode, returns valid JSON data. When using JSON mode, it’s recommended to clearly request JSON output in the prompt.
Hide child attributes
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-response-format-type)
response_format.type
enum<string>
default:text
required
Output format type: text for plain text, json_object for JSON-formatted output.
Available options: 
`text`, 
`json_object`
[​](https://docs.z.ai/api-reference/llm/chat-completion#body-user-id)
user_id
string
Unique ID for the end user, 6–128 characters. Avoid using sensitive information.
Required string length: `6 - 128`
#### Response
200
application/json
Processing successful
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-id)
id
string
Task ID
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-request-id)
request_id
string
Request ID
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-created)
created
integer
Request creation time, Unix timestamp in seconds
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-model)
model
string
Model name
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-choices)
choices
object[]
List of model responses
Hide child attributes
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-choices-index)
index
integer
Result index.
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-choices-message)
message
object
Hide child attributes
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-message-role)
message.role
string
Current conversation role, default is ‘assistant’ (model)
Example:
`"assistant"`
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-message-content)
message.content
string
Current conversation content. Hits function is null, otherwise returns model inference result. For the GLM-4.5V series models, the output may contain the reasoning process tags `<think> </think>` or the text boundary tags `<|begin_of_box|> <|end_of_box|>`.
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-message-reasoning-content)
message.reasoning_content
string
Reasoning content, supports by GLM-4.5 series.
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-message-tool-calls)
message.tool_calls
object[]
Function names and parameters generated by the model that should be called.
Hide child attributes
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-message-tool-calls-function)
function
object
Contains the function name and JSON format parameters generated by the model.
Hide child attributes
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-function-name)
function.name
string
required
Model-generated function name.
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-function-arguments)
function.arguments
object
required
JSON format of the function call parameters generated by the model. Validate the parameters before calling the function.
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-message-tool-calls-id)
id
string
Unique identifier for the hit function.
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-message-tool-calls-type)
type
string
Tool type called by the model, currently only supports ‘function’.
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-choices-finish-reason)
finish_reason
string
Reason for model inference termination. Can be ‘stop’, ‘tool_calls’, ‘length’, ‘sensitive’, or ‘network_error’.
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-usage)
usage
object
Token usage statistics returned when the model call ends.
Hide child attributes
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-usage-prompt-tokens)
usage.prompt_tokens
number
Number of tokens in user input
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-usage-completion-tokens)
usage.completion_tokens
number
Number of output tokens
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-usage-prompt-tokens-details)
usage.prompt_tokens_details
object
Hide child attributes
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-usage-prompt-tokens-details-cached-tokens)
usage.prompt_tokens_details.cached_tokens
number
Number of tokens served from cache
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-usage-total-tokens)
usage.total_tokens
integer
Total number of tokens
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-web-search)
web_search
object[]
Search results.
Hide child attributes
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-web-search-title)
title
string
Title.
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-web-search-content)
content
string
Content summary.
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-web-search-link)
link
string
Result URL.
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-web-search-media)
media
string
Website name.
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-web-search-icon)
icon
string
Website icon.
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-web-search-refer)
refer
string
Index number.
[​](https://docs.z.ai/api-reference/llm/chat-completion#response-web-search-publish-date)
publish_date
string
Website publication date.
Was this page helpful?
YesNo
[Rate Limits](https://docs.z.ai/api-reference/rate-limit)[Generate Image](https://docs.z.ai/api-reference/image/generate-image)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
