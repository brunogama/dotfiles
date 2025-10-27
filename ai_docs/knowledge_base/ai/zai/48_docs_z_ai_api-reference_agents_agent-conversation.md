# https://docs.z.ai/api-reference/agents/agent-conversation

Source: [https://docs.z.ai/api-reference/agents/agent-conversation](https://docs.z.ai/api-reference/agents/agent-conversation)

---

[Skip to main content](https://docs.z.ai/api-reference/agents/agent-conversation#content-area)
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
Conversation History
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
 --url https://api.z.ai/api/v1/agents/conversation \
 --header 'Authorization: Bearer <token>' \
 --header 'Content-Type: application/json' \
 --data '{
 "agent_id": "<string>",
 "conversation_id": "<string>",
 "custom_variables": {
  "include_pdf": true,
  "pages": [
   {
    "position": 123,
    "width": 123,
    "height": 123
   }
  ]
 }
}'
```

200
default
Copy
```
{
 "conversation_id": "<string>",
 "agent_id": "<string>",
 "choices": [
  {
   "message": [
    {
     "role": "<string>",
     "content": [
      {
       "type": "<string>",
       "tag_cn": "<string>",
       "tag_en": "<string>",
       "file_url": "<string>",
       "image_url": "<string>"
      }
     ]
    }
   ]
  }
 ],
 "error": {
  "code": "<string>",
  "message": "<string>"
 }
}
```

Agent API
# Conversation History
Copy page
This endpoint is used to query the agent conversation history.Only support slides_glm_agent
Copy page
POST
/
v1
/
agents
/
conversation
Try it
cURL
cURL
Copy
```
curl --request POST \
 --url https://api.z.ai/api/v1/agents/conversation \
 --header 'Authorization: Bearer <token>' \
 --header 'Content-Type: application/json' \
 --data '{
 "agent_id": "<string>",
 "conversation_id": "<string>",
 "custom_variables": {
  "include_pdf": true,
  "pages": [
   {
    "position": 123,
    "width": 123,
    "height": 123
   }
  ]
 }
}'
```

200
default
Copy
```
{
 "conversation_id": "<string>",
 "agent_id": "<string>",
 "choices": [
  {
   "message": [
    {
     "role": "<string>",
     "content": [
      {
       "type": "<string>",
       "tag_cn": "<string>",
       "tag_en": "<string>",
       "file_url": "<string>",
       "image_url": "<string>"
      }
     ]
    }
   ]
  }
 ],
 "error": {
  "code": "<string>",
  "message": "<string>"
 }
}
```

#### Authorizations
[​](https://docs.z.ai/api-reference/agents/agent-conversation#authorization-authorization)
Authorization
string
header
required
Use the following format for authentication: Bearer [<your api key>](https://z.ai/manage-apikey/apikey-list)
#### Headers
[​](https://docs.z.ai/api-reference/agents/agent-conversation#parameter-accept-language)
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
[​](https://docs.z.ai/api-reference/agents/agent-conversation#body-agent-id)
agent_id
string
Agent ID
[​](https://docs.z.ai/api-reference/agents/agent-conversation#body-conversation-id)
conversation_id
string
Conversation ID
[​](https://docs.z.ai/api-reference/agents/agent-conversation#body-custom-variables)
custom_variables
object
Custom variables
Hide child attributes
[​](https://docs.z.ai/api-reference/agents/agent-conversation#body-custom-variables-include-pdf)
custom_variables.include_pdf
boolean
Is export the pdf file
[​](https://docs.z.ai/api-reference/agents/agent-conversation#body-custom-variables-pages)
custom_variables.pages
object[]
Slides Pages
Hide child attributes
[​](https://docs.z.ai/api-reference/agents/agent-conversation#body-custom-variables-pages-position)
position
number
Slide Page Position
[​](https://docs.z.ai/api-reference/agents/agent-conversation#body-custom-variables-pages-width)
width
number
Slide Width, unit: pt
[​](https://docs.z.ai/api-reference/agents/agent-conversation#body-custom-variables-pages-height)
height
number
Slide Height, unit: pt
#### Response
200
application/json
Processing successful
[​](https://docs.z.ai/api-reference/agents/agent-conversation#response-conversation-id)
conversation_id
string
Conversation ID
[​](https://docs.z.ai/api-reference/agents/agent-conversation#response-agent-id)
agent_id
string
Agent ID
[​](https://docs.z.ai/api-reference/agents/agent-conversation#response-choices)
choices
object[]
Agent output.
Hide child attributes
[​](https://docs.z.ai/api-reference/agents/agent-conversation#response-choices-message)
message
object[]
Hide child attributes
[​](https://docs.z.ai/api-reference/agents/agent-conversation#response-message-role)
role
string
Role: fixed as `assistant`.
[​](https://docs.z.ai/api-reference/agents/agent-conversation#response-message-content)
content
object[]
Content metadata
Hide child attributes
[​](https://docs.z.ai/api-reference/agents/agent-conversation#response-content-type)
type
string
Response Content type: file_url、image_url
[​](https://docs.z.ai/api-reference/agents/agent-conversation#response-content-tag-cn)
tag_cn
string
CN Tag.
[​](https://docs.z.ai/api-reference/agents/agent-conversation#response-content-tag-en)
tag_en
string
EN Tag.
[​](https://docs.z.ai/api-reference/agents/agent-conversation#response-content-file-url)
file_url
string
Output file_url content when type is file_url
[​](https://docs.z.ai/api-reference/agents/agent-conversation#response-content-image-url)
image_url
string
Output image_url content when type is image_url
[​](https://docs.z.ai/api-reference/agents/agent-conversation#response-error)
error
object
Hide child attributes
[​](https://docs.z.ai/api-reference/agents/agent-conversation#response-error-code)
error.code
string
Error code.
[​](https://docs.z.ai/api-reference/agents/agent-conversation#response-error-message)
error.message
string
Error message.
Was this page helpful?
YesNo
[Retrieve Result](https://docs.z.ai/api-reference/agents/get-async-result)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
