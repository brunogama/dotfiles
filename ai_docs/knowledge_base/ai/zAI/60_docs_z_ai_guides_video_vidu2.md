# https://docs.z.ai/guides/video/vidu2

Source: [https://docs.z.ai/guides/video/vidu2](https://docs.z.ai/guides/video/vidu2)

---

[Skip to main content](https://docs.z.ai/guides/video/vidu2#content-area)
🚀 **GLM Coding Plan — built for devs: 3× usage, 1/7 cost** • [Limited-Time Offer ➞](https://z.ai/subscribe?utm_campaign=Platform_Ops&_channel_track_key=DaprgHIc)
[Z.AI DEVELOPER DOCUMENT home page![light logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/dark.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=75deefa9dea5bdbc84d4da68885c267f)![dark logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/light.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=c1ecf1af358fa8eeab8c06052337f8f6)](https://z.ai/model-api)
English
Search...
⌘K
  * [API Keys](https://z.ai/manage-apikey/apikey-list)
  * [Payment Method](https://z.ai/manage-apikey/billing)


Search...
Navigation
Video Generation Models
Vidu 2
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
  * [ Overview](https://docs.z.ai/guides/video/vidu2#overview)
  * [ Capability Description](https://docs.z.ai/guides/video/vidu2#capability-description)
  * [ Usage](https://docs.z.ai/guides/video/vidu2#usage)
  * [ Resources](https://docs.z.ai/guides/video/vidu2#resources)
  * [ Introducting Vidu2](https://docs.z.ai/guides/video/vidu2#introducting-vidu2)
  * [ Quick Start](https://docs.z.ai/guides/video/vidu2#quick-start)
  * [1. Image-to-Video Generation](https://docs.z.ai/guides/video/vidu2#1-image-to-video-generation)
  * [2. Start and End Frame](https://docs.z.ai/guides/video/vidu2#2-start-and-end-frame)
  * [3. Reference-based Video Generation](https://docs.z.ai/guides/video/vidu2#3-reference-based-video-generation)


Video Generation Models
# Vidu 2
Copy page
Copy page
## 
[​](https://docs.z.ai/guides/video/vidu2#overview)
Overview
Vidu 2 is a next-generation video generation model that strikes a balance between speed and quality. It focuses on image-to-video generation and keyframe-based video creation, supporting 720P resolution for videos up to 4 seconds long. With significantly faster generation speed and reduced cost, it addresses color distortion issues in image-to-video outputs, delivering stable and controllable visuals ideal for e-commerce scenarios. Enhanced semantic understanding between keyframes and improved consistency with multiple reference images make Vidu 2 a highly efficient tool for mass production in pan-entertainment, internet content, anime short series, and advertising.
  * vidu2-image
  * vidu2-start-end
  * vidu2-reference


## Price
$0.2 / video
## Capability
Image-to-Video Generation
## Duration
4S
## Clarity
720P
## 
[​](https://docs.z.ai/guides/video/vidu2#capability-description)
Capability Description
## Image-to-Video Generation
Generate a video by providing a starting frame or both starting and ending frames along with corresponding text descriptions.
## Start and End Frame
Support input of two images: the first uploaded image is treated as the starting frame, and the second as the ending frame. The model uses these images as input parameters to generate the video.
## Reference-based Video Generation
Generate a video from a text prompt; currently supports both a general style and an anime style optimized for animation.
The URL link for the video generated by the model is valid for one day. Please save it as soon as possible if needed.
## 
[​](https://docs.z.ai/guides/video/vidu2#usage)
Usage
General Entertainment Content Generation
  * Input a single frame or IP elements to quickly generate short videos with coherent storylines and interactive special effects
  * Supports diverse visual styles from anime-inspired to realistic
  * Tailored for mass production of UGC creative content on short video platforms


Anime Short Drama Production
  * Input static character images or keyframes to generate smooth animated sequences and micro-dramas
  * Accurately reproduce detailed character movements (e.g., facial expressions)
  * Supports mass production in various styles such as Chinese and Japanese anime
  * Designed to meet animation studios’ needs for IP-based content expansion


Advertising & E-commerce Marketing
  * Input real product images to intelligently generate dynamic advertising videos
  * Clearly showcase product features such as 3C details and beauty product textures
  * Automatically adapt to various platform formats, such as vertical videos for Tiktok and horizontal layouts for social feeds


## 
[​](https://docs.z.ai/guides/video/vidu2#resources)
Resources
[API Documentation](https://docs.z.ai/api-reference/video/cogvideox-3&vidu): Learn how to call the API.
## 
[​](https://docs.z.ai/guides/video/vidu2#introducting-vidu2)
Introducting Vidu2
1
### Efficient Video Generation Speed
With optimized model computing architecture, video rendering efficiency is significantly enhanced. This allows daily content teams to respond quickly to trending topics, and enables e-commerce sellers to mass-produce product display videos on demand—greatly reducing content delivery time and helping creators seize traffic windows.
2
### Cost-Effective 720P Output
The cost of generating 720P resolution videos has dropped to 40% of the Q1 version. Small and medium-sized brands can now create batch videos for multiple SKUs, while advertising teams can test creative concepts like “product close-ups + scenario storytelling” at a lower cost—meeting full-platform marketing needs without breaking the content budget.
3
### Stable and Controllable Image-to-Video Generation
  * The model addresses the “texture color shift” issue—accurately restoring details like the silky glow of satin or the matte finish of leather in clothing videos. In e-commerce scenarios, product colors are displayed more realistically.
  * Dynamic frame compensation is optimized, ensuring smooth, shake-free motion for rotating 3C products or hand demonstrations in beauty tutorials.
  * Multiple visual styles are supported, enabling eye-catching content like “product close-up + stylized camera movement,” ideal for e-commerce main images and short-form promotional videos.


4
### Semantically Enhanced Keyframe Transition
The model strikes a balance between creativity and stability, delivering significantly improved performance and semantic understanding—making it the optimal solution for keyframe-based video generation.By accurately analyzing scene logic and action continuity, transitions between frames are smooth and natural, enhancing narrative coherence throughout the content.
5
### Enhanced Consistency of Multiple Reference Images
When inputting multi-element materials, the visual style of the generated video (such as tone and lighting) can be highly unified.For example, in a cultural tourism promotional video, the transition between scenes such as the sunrise over an ancient city, street market scenes, and folk performances maintains consistency with the “Chinese style filter.”In anime IP derivative content, the actions and expressions of characters in different plot scenes can also strictly adhere to the original settings, facilitating the coherent creation of multi-scene, multi-element content.![020f485a Fb03 4698 8a6c F9f89b5b7361 Jpe](https://mintcdn.com/zhipu-32152247/fQm1SxNtD2jBDQ3i/images/020f485a-fb03-4698-8a6c-f9f89b5b7361.jpeg?fit=max&auto=format&n=fQm1SxNtD2jBDQ3i&q=85&s=58735848f5131388d223ffdf59b83af6)
## 
[​](https://docs.z.ai/guides/video/vidu2#quick-start)
Quick Start
### 
[​](https://docs.z.ai/guides/video/vidu2#1-image-to-video-generation)
1. Image-to-Video Generation
  * Curl
  * Python
  * Java


Copy
```
curl --location --request POST 'https://api.z.ai/api/paas/v4/videos/generations' \
--header 'Authorization: Bearer {your apikey}' \
--header 'Content-Type: application/json' \
--data-raw '{
  "model":"vidu2-image",
  "image_url":"https://example.com/path/to/your/image.jpg",
  "prompt":"Peter Rabbit drives a small car along the road, his face filled with joy and happiness.",
  "duration":4,
  "size":"720x480",
  "movement_amplitude":"auto"
}'

```

### 
[​](https://docs.z.ai/guides/video/vidu2#2-start-and-end-frame)
2. Start and End Frame
  * Curl
  * Python


Copy
```
curl --location --request POST 'https://api.z.ai/api/paas/v4/videos/generations' \
--header 'Authorization: Bearer {your apikey}' \
--header 'Content-Type: application/json' \
--data-raw '{
  "model":"vidu2-start-end",
  "image_url":["https://example.com/path/to/your/image1.jpg","https://example.com/path/to/your/image2.jpg"],
  "prompt":"Peter Rabbit drives a small car along the road, his face filled with joy and happiness.",
  "duration":4,
  "size":"720x480",
  "movement_amplitude":"auto"
}'

```

### 
[​](https://docs.z.ai/guides/video/vidu2#3-reference-based-video-generation)
3. Reference-based Video Generation
  * Curl
  * Python


Copy
```
curl --location --request POST 'https://api.z.ai/api/paas/v4/videos/generations' \
--header 'Authorization: Bearer {your apikey}' \
--header 'Content-Type: application/json' \
--data-raw '{
  "model":"vidu2-reference",
  "image_url":["https://example.com/path/to/your/image1.jpg","https://example.com/path/to/your/image2.jpg","https://example.com/path/to/your/image3.jpg"],
  "prompt":"Peter Rabbit drives a small car along the road, his face filled with joy and happiness.",
  "duration":4,
  "aspect_ratio":"16:9",
  "size":"720x480",
  "movement_amplitude":"auto",
  "with_audio":true
}'

```

Was this page helpful?
YesNo
[Vidu Q1](https://docs.z.ai/guides/video/vidu-q1)[CogView-4](https://docs.z.ai/guides/image/cogview-4)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
![020f485a Fb03 4698 8a6c F9f89b5b7361 Jpe](https://mintcdn.com/zhipu-32152247/fQm1SxNtD2jBDQ3i/images/020f485a-fb03-4698-8a6c-f9f89b5b7361.jpeg?w=560&fit=max&auto=format&n=fQm1SxNtD2jBDQ3i&q=85&s=599872e93e6b377dc35242b18b7c2b14)
