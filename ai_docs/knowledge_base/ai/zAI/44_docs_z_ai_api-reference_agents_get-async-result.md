# https://docs.z.ai/api-reference/agents/get-async-result

Source: [https://docs.z.ai/api-reference/agents/get-async-result](https://docs.z.ai/api-reference/agents/get-async-result)

---

[Skip to main content](https://docs.z.ai/api-reference/agents/get-async-result#content-area)
🚀 **GLM Coding Plan — built for devs: 3× usage, 1/7 cost** • [Limited-Time Offer ➞](https://z.ai/subscribe?utm_campaign=Platform_Ops&_channel_track_key=DaprgHIc)
[Z.AI DEVELOPER DOCUMENT home page![light logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/dark.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=75deefa9dea5bdbc84d4da68885c267f)![dark logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/light.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=c1ecf1af358fa8eeab8c06052337f8f6)](https://z.ai/model-api)
English
Search...
⌘K
  * [API Keys](https://z.ai/manage-apikey/apikey-list)
  * [Payment Method](https://z.ai/manage-apikey/billing)


Search...
Navigation
Agent API
Retrieve Result
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
cURL
Copy
```
curl --request POST \
 --url https://api.z.ai/api/v1/agents/async-result \
 --header 'Authorization: Bearer <token>' \
 --header 'Content-Type: application/json' \
 --data '{
 "agent_id": "<string>",
 "async_id": "<string>"
}'
```

200
default
Copy
```
{
 "status": "<string>",
 "agent_id": "<string>",
 "async_id": "<string>",
 "choices": [
  {
   "index": 123,
   "finish_reason": "<string>",
   "message": [
    {
     "role": "<string>",
     "content": [
      {
       "type": "<string>",
       "video_url": "<string>"
      }
     ]
    }
   ]
  }
 ]
}
```

Agent API
# Retrieve Result
Copy page
This endpoint is used to query the result of an asynchronous request.
Copy page
POST
/
v1
/
agents
/
async-result
Try it
cURL
cURL
Copy
```
curl --request POST \
 --url https://api.z.ai/api/v1/agents/async-result \
 --header 'Authorization: Bearer <token>' \
 --header 'Content-Type: application/json' \
 --data '{
 "agent_id": "<string>",
 "async_id": "<string>"
}'
```

200
default
Copy
```
{
 "status": "<string>",
 "agent_id": "<string>",
 "async_id": "<string>",
 "choices": [
  {
   "index": 123,
   "finish_reason": "<string>",
   "message": [
    {
     "role": "<string>",
     "content": [
      {
       "type": "<string>",
       "video_url": "<string>"
      }
     ]
    }
   ]
  }
 ]
}
```

#### Authorizations
[​](https://docs.z.ai/api-reference/agents/get-async-result#authorization-authorization)
Authorization
string
header
required
Use the following format for authentication: Bearer [<your api key>](https://z.ai/manage-apikey/apikey-list)
#### Headers
[​](https://docs.z.ai/api-reference/agents/get-async-result#parameter-accept-language)
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
[​](https://docs.z.ai/api-reference/agents/get-async-result#body-agent-id)
agent_id
string
Agent ID: `vidu_template_agent`.
[​](https://docs.z.ai/api-reference/agents/get-async-result#body-async-id)
async_id
string
Task ID from async response.
#### Response
200
application/json
Processing successful
[​](https://docs.z.ai/api-reference/agents/get-async-result#response-status)
status
string
`pending` (processing), `success` (completed), `failed` (failed).
[​](https://docs.z.ai/api-reference/agents/get-async-result#response-agent-id)
agent_id
string
Agent ID
[​](https://docs.z.ai/api-reference/agents/get-async-result#response-async-id)
async_id
string
Asynchronous task ID.
[​](https://docs.z.ai/api-reference/agents/get-async-result#response-choices)
choices
object[]
Agent output.
Hide child attributes
[​](https://docs.z.ai/api-reference/agents/get-async-result#response-choices-index)
index
integer
Result index.
[​](https://docs.z.ai/api-reference/agents/get-async-result#response-choices-finish-reason)
finish_reason
string
Reason for model inference termination. Can be ‘stop’, ‘tool_calls’, ‘length’, ‘sensitive’, or ‘network_error’.
[​](https://docs.z.ai/api-reference/agents/get-async-result#response-choices-message)
message
object[]
Hide child attributes
[​](https://docs.z.ai/api-reference/agents/get-async-result#response-message-role)
role
string
Role: fixed as `assistant`.
[​](https://docs.z.ai/api-reference/agents/get-async-result#response-message-content)
content
object[]
Video file metadata
Hide child attributes
[​](https://docs.z.ai/api-reference/agents/get-async-result#response-content-type)
type
string
object type: `video_url`.
[​](https://docs.z.ai/api-reference/agents/get-async-result#response-content-video-url)
video_url
string
MP4 video URL.
Was this page helpful?
YesNo
[File Upload](https://docs.z.ai/api-reference/agents/file-upload)[Conversation History](https://docs.z.ai/api-reference/agents/agent-conversation)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
