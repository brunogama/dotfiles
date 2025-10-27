# https://docs.z.ai/api-reference/image/generate-image

Source: [https://docs.z.ai/api-reference/image/generate-image](https://docs.z.ai/api-reference/image/generate-image)

---

[Skip to main content](https://docs.z.ai/api-reference/image/generate-image#content-area)
🚀 **GLM Coding Plan — built for devs: 3× usage, 1/7 cost** • [Limited-Time Offer ➞](https://z.ai/subscribe?utm_campaign=Platform_Ops&_channel_track_key=DaprgHIc)
[Z.AI DEVELOPER DOCUMENT home page![light logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/dark.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=75deefa9dea5bdbc84d4da68885c267f)![dark logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/light.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=c1ecf1af358fa8eeab8c06052337f8f6)](https://z.ai/model-api)
English
Search...
⌘K
  * [API Keys](https://z.ai/manage-apikey/apikey-list)
  * [Payment Method](https://z.ai/manage-apikey/billing)


Search...
Navigation
Image API
Generate Image
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


Generate Image
cURL
Copy
```
curl --request POST \
 --url https://api.z.ai/api/paas/v4/images/generations \
 --header 'Authorization: Bearer <token>' \
 --header 'Content-Type: application/json' \
 --data '{
 "model": "cogView-4-250304",
 "prompt": "A cute little kitten sitting on a sunny windowsill, with the background of blue sky and white clouds.",
 "size": "1024x1024"
}'
```

200
default
Copy
```
{
 "created": 1760335349,
 "data": [
  {
   "url": "<string>"
  }
 ],
 "content_filter": [
  {
   "role": "assistant",
   "level": 1
  }
 ]
}
```

Image API
# Generate Image
Copy page
Use [CogView-4](https://docs.z.ai/guides/image/cogview-4) series models to generate high-quality images from text prompts. `CogView-4-250304` is suitable for image generation tasks, with quick and accurate understanding of user text descriptions to let `AI` express images more precisely and personally.
Copy page
POST
/
paas
/
v4
/
images
/
generations
Try it
Generate Image
cURL
Copy
```
curl --request POST \
 --url https://api.z.ai/api/paas/v4/images/generations \
 --header 'Authorization: Bearer <token>' \
 --header 'Content-Type: application/json' \
 --data '{
 "model": "cogView-4-250304",
 "prompt": "A cute little kitten sitting on a sunny windowsill, with the background of blue sky and white clouds.",
 "size": "1024x1024"
}'
```

200
default
Copy
```
{
 "created": 1760335349,
 "data": [
  {
   "url": "<string>"
  }
 ],
 "content_filter": [
  {
   "role": "assistant",
   "level": 1
  }
 ]
}
```

#### Authorizations
[​](https://docs.z.ai/api-reference/image/generate-image#authorization-authorization)
Authorization
string
header
required
Use the following format for authentication: Bearer [<your api key>](https://z.ai/manage-apikey/apikey-list)
#### Body
application/json
[​](https://docs.z.ai/api-reference/image/generate-image#body-model)
model
enum<string>
required
Model code
Available options: 
`cogview-4-250304`
Example:
`"cogview-4-250304"`
[​](https://docs.z.ai/api-reference/image/generate-image#body-prompt)
prompt
string
required
The text description of the image to be generated.
Example:
`"A cute little kitten."`
[​](https://docs.z.ai/api-reference/image/generate-image#body-quality)
quality
enum<string>
default:standard
The quality of the generated image. Default is `standard`. `hd`: Generates a more detailed and rich image with higher overall consistency, but takes about `20` seconds. `standard`: Generates an image quickly, suitable for scenarios with higher requirements for generation speed, takes about `5-10` seconds. This parameter is only supported for `cogview-4-250304`.
Available options: 
`hd`, 
`standard`
[​](https://docs.z.ai/api-reference/image/generate-image#body-size)
size
string
default:1024x1024
Image size, default is `1024x1024`, recommended enum values: `1024x1024` (default), `768x1344`, `864x1152`, `1344x768`, `1152x864`, `1440x720`, `720x1440`. Custom parameter: Both width and height must be between `512px-2048px`, and must be divisible by `16`, and the maximum pixel count must not exceed `2^21px`.
Example:
`"1024x1024"`
[​](https://docs.z.ai/api-reference/image/generate-image#body-user-id)
user_id
string
Unique ID of the end user, helping the platform intervene in illegal activities, inappropriate content generation, or other abuses. ID length: 6 to 128 characters.
Required string length: `6 - 128`
#### Response
200
application/json
Processing successful
[​](https://docs.z.ai/api-reference/image/generate-image#response-created)
created
integer
Request creation time, in `Unix` timestamp format, unit is seconds.
Example:
`1760335349`
[​](https://docs.z.ai/api-reference/image/generate-image#response-data)
data
object[]
Array, containing the generated image `URL`. Currently, the array only contains one image.
Hide child attributes
[​](https://docs.z.ai/api-reference/image/generate-image#response-data-url)
url
string
required
Image link. The temporary link expires after `30` days, please store it promptly.
[​](https://docs.z.ai/api-reference/image/generate-image#response-content-filter)
content_filter
object[]
Array, containing content safety related information.
Hide child attributes
[​](https://docs.z.ai/api-reference/image/generate-image#response-content-filter-role)
role
enum<string>
Safety enforcement stage, including `role = assistant` model inference, `role = user` user input, `role = history` historical context.
Available options: 
`assistant`, 
`user`, 
`history`
[​](https://docs.z.ai/api-reference/image/generate-image#response-content-filter-level)
level
integer
Severity level `level 0-3`, `level 0` is most severe, `3` is least severe.
Required range: `0 <= x <= 3`
Was this page helpful?
YesNo
[Chat Completion](https://docs.z.ai/api-reference/llm/chat-completion)[Generate Video(Async)](https://docs.z.ai/api-reference/video/generate-video)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
