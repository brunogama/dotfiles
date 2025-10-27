# https://docs.z.ai/api-reference/agents/file-upload

Source: [https://docs.z.ai/api-reference/agents/file-upload](https://docs.z.ai/api-reference/agents/file-upload)

---

[Skip to main content](https://docs.z.ai/api-reference/agents/file-upload#content-area)
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
File Upload
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
 --url https://api.z.ai/api/paas/v4/files \
 --header 'Authorization: Bearer <token>' \
 --header 'Content-Type: multipart/form-data' \
 --form purpose=agent \
 --form file=@example-file
```

200
default
Copy
```
{
 "id": "<string>",
 "object": "<string>",
 "bytes": 123,
 "filename": "<string>",
 "purpose": "<string>",
 "created_at": 123
}
```

Agent API
# File Upload
Copy page
This API is designed for uploading auxiliary files (such as glossaries, terminology lists) to support the translation service. It allows users to upload reference materials that can enhance translation accuracy and consistency.
Copy page
POST
/
paas
/
v4
/
files
Try it
cURL
cURL
Copy
```
curl --request POST \
 --url https://api.z.ai/api/paas/v4/files \
 --header 'Authorization: Bearer <token>' \
 --header 'Content-Type: multipart/form-data' \
 --form purpose=agent \
 --form file=@example-file
```

200
default
Copy
```
{
 "id": "<string>",
 "object": "<string>",
 "bytes": 123,
 "filename": "<string>",
 "purpose": "<string>",
 "created_at": 123
}
```

## 
[​](https://docs.z.ai/api-reference/agents/file-upload#file-limitations)
File Limitations
  * Maximum 100 files
  * Maximum 100MB per file
  * Files retained for 180 days
  * Supported formats: pdf, doc, xlsx, ppt, txt, jpg, png


#### Authorizations
[​](https://docs.z.ai/api-reference/agents/file-upload#authorization-authorization)
Authorization
string
header
required
Use the following format for authentication: Bearer [<your api key>](https://z.ai/manage-apikey/apikey-list)
#### Body
multipart/form-data
[​](https://docs.z.ai/api-reference/agents/file-upload#body-purpose)
purpose
enum<string>
default:agent
required
Upload purpose (agent)
Available options: 
`agent`
[​](https://docs.z.ai/api-reference/agents/file-upload#body-file)
file
file
required
File to upload. Limit to `100MB`. Allowed formats: `pdf`, `doc`, `xlsx`, `ppt`, `txt`, `jpg`, `png`.
#### Response
200
application/json
Processing successful
[​](https://docs.z.ai/api-reference/agents/file-upload#response-id)
id
string
Unique identifier of the uploaded file.
[​](https://docs.z.ai/api-reference/agents/file-upload#response-object)
object
string
Object type.
[​](https://docs.z.ai/api-reference/agents/file-upload#response-bytes)
bytes
integer
File size in bytes.
[​](https://docs.z.ai/api-reference/agents/file-upload#response-filename)
filename
string
Name of the uploaded file.
[​](https://docs.z.ai/api-reference/agents/file-upload#response-purpose)
purpose
string
Purpose of the uploaded file.
[​](https://docs.z.ai/api-reference/agents/file-upload#response-created-at)
created_at
integer
Timestamp of file creation.
Was this page helpful?
YesNo
[Agent Chat](https://docs.z.ai/api-reference/agents/agent)[Retrieve Result](https://docs.z.ai/api-reference/agents/get-async-result)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
