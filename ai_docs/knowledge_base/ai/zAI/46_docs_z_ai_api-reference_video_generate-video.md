# https://docs.z.ai/api-reference/video/generate-video

Source: [https://docs.z.ai/api-reference/video/generate-video](https://docs.z.ai/api-reference/video/generate-video)

---

[Skip to main content](https://docs.z.ai/api-reference/video/generate-video#content-area)
🚀 **GLM Coding Plan — built for devs: 3× usage, 1/7 cost** • [Limited-Time Offer ➞](https://z.ai/subscribe?utm_campaign=Platform_Ops&_channel_track_key=DaprgHIc)
[Z.AI DEVELOPER DOCUMENT home page![light logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/dark.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=75deefa9dea5bdbc84d4da68885c267f)![dark logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/light.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=c1ecf1af358fa8eeab8c06052337f8f6)](https://z.ai/model-api)
English
Search...
⌘K
  * [API Keys](https://z.ai/manage-apikey/apikey-list)
  * [Payment Method](https://z.ai/manage-apikey/billing)


Search...
Navigation
Video API
Generate Video(Async)
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
Text to Video Example
Copy
```
curl --request POST \ --url https://api.z.ai/api/paas/v4/videos/generations \ --header 'Authorization: Bearer <token>' \ --header 'Content-Type: application/json' \ --data '{ "model": "cogvideox-3", "prompt": "A cat is playing with a ball.", "quality": "quality", "with_audio": true, "size": "1920x1080", "fps": 30}'
```

200
default
Copy
```
{
 "model": "<string>",
 "id": "<string>",
 "request_id": "<string>",
 "task_status": "<string>"
}
```

Video API
# Generate Video(Async)
Copy page
CogVideoX is a video generation large model developed by Z.AI, equipped with powerful video generation capabilities. Simply inputting text or images allows for effortless video creation.
Vidu: A high-performance video large model that combines high consistency and high dynamism, with precise semantic understanding and exceptional reasoning speed.
Copy page
POST
/
paas
/
v4
/
videos
/
generations
Try it
cURL
Text to Video Example
Copy
```
curl --request POST \ --url https://api.z.ai/api/paas/v4/videos/generations \ --header 'Authorization: Bearer <token>' \ --header 'Content-Type: application/json' \ --data '{ "model": "cogvideox-3", "prompt": "A cat is playing with a ball.", "quality": "quality", "with_audio": true, "size": "1920x1080", "fps": 30}'
```

200
default
Copy
```
{
 "model": "<string>",
 "id": "<string>",
 "request_id": "<string>",
 "task_status": "<string>"
}
```

#### Authorizations
[​](https://docs.z.ai/api-reference/video/generate-video#authorization-authorization)
Authorization
string
header
required
Use the following format for authentication: Bearer [<your api key>](https://z.ai/manage-apikey/apikey-list)
#### Headers
[​](https://docs.z.ai/api-reference/video/generate-video#parameter-accept-language)
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
  * CogVideoX-3
  * Vidu: Text to Video
  * Vidu: Image to Video
  * Vidu: First & Last Frame to Video
  * Vidu: Ref to Video


[​](https://docs.z.ai/api-reference/video/generate-video#body-model)
model
enum<string>
required
The model code to be called.
Available options: 
`cogvideox-3`
[​](https://docs.z.ai/api-reference/video/generate-video#body-prompt)
prompt
string
Text description of the video, maximum input length of 512 characters. Either image_url or prompt must be provided, or both.
[​](https://docs.z.ai/api-reference/video/generate-video#body-quality)
quality
enum<string>
Output mode, default is `speed`.
  * `quality`: Prioritizes quality, higher generation quality.
  * `speed`: Prioritizes speed, faster generation time, relatively lower quality.


Available options: 
`speed`, 
`quality`
Example:
`"speed"`
[​](https://docs.z.ai/api-reference/video/generate-video#body-with-audio)
with_audio
boolean
Whether to generate AI sound effects. Default: `false` (no sound effects).
Example:
`false`
[​](https://docs.z.ai/api-reference/video/generate-video#body-image-url)
image_url
(string<uri> | string<byte>)[]
Provide an image based on which content will be generated. If this parameter is passed, the system will operate based on this image. Supports passing images via URL or Base64 encoding. Image requirements: images support `.png`, `.jpeg`, `.jpg` formats; image size: no more than `5M`. Either image_url and prompt can be used, or both can be passed simultaneously. First and last frames: supports inputting two images. The first uploaded image is regarded as the first frame, and the second image is regarded as the last frame. The model will generate the video based on the images passed in this parameter. First and last frame mode only supports `speed` mode
[​](https://docs.z.ai/api-reference/video/generate-video#body-size)
size
enum<string>
Default value: if not specified, the short side of the generated video is 1080 by default, and the long side is determined according to the original image ratio. Maximum support for 4K resolution. Resolution options: "1280x720", "720x1280", "1024x1024", "1080x1920", "2048x1080", "3840x2160"
Available options: 
`1280x720`, 
`720x1280`, 
`1024x1024`, 
`1920x1080`, 
`1080x1920`, 
`2048x1080`, 
`3840x2160`
Example:
`"1920x1080"`
[​](https://docs.z.ai/api-reference/video/generate-video#body-fps)
fps
enum<integer>
Video frame rate (FPS), optional values are `30` or `60`. Default: `30`.
Available options: 
`30`, 
`60`
Example:
`30`
[​](https://docs.z.ai/api-reference/video/generate-video#body-duration)
duration
enum<integer>
Video duration, default is 5 seconds, supports `5` and `10` seconds.
Available options: 
`5`, 
`10`
Example:
`5`
[​](https://docs.z.ai/api-reference/video/generate-video#body-request-id)
request_id
string
Provided by the client, must be unique; used to distinguish each request’s unique identifier. If not provided by the client, the platform will generate one by default.
[​](https://docs.z.ai/api-reference/video/generate-video#body-user-id)
user_id
string
Unique ID of the end-user, assists the platform in intervening in end-user violations, generating illegal or inappropriate information, or other abusive behaviors. ID length requirement: minimum `6` characters, maximum `128` characters.
#### Response
200
application/json
Processing successful.
[​](https://docs.z.ai/api-reference/video/generate-video#response-model)
model
string
Model name used in this call.
[​](https://docs.z.ai/api-reference/video/generate-video#response-id)
id
string
Task order number generated by the Z.AI, use this order number when calling the request result interface.
[​](https://docs.z.ai/api-reference/video/generate-video#response-request-id)
request_id
string
Task number submitted by the user during the client request or generated by the platform.
[​](https://docs.z.ai/api-reference/video/generate-video#response-task-status)
task_status
string
Processing status, `PROCESSING (processing)`,`SUCCESS (success)`, `FAIL (failure)`. Results need to be obtained via query.
Was this page helpful?
YesNo
[Generate Image](https://docs.z.ai/api-reference/image/generate-image)[Retrieve Result](https://docs.z.ai/api-reference/video/get-video-status)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
