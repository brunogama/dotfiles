# https://docs.z.ai/guides/video/vidu-q1

Source: [https://docs.z.ai/guides/video/vidu-q1](https://docs.z.ai/guides/video/vidu-q1)

---

[Skip to main content](https://docs.z.ai/guides/video/vidu-q1#content-area)
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
Vidu Q1
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
  * [ Overview](https://docs.z.ai/guides/video/vidu-q1#overview)
  * [ Capability Description](https://docs.z.ai/guides/video/vidu-q1#capability-description)
  * [ Usage](https://docs.z.ai/guides/video/vidu-q1#usage)
  * [ Resources](https://docs.z.ai/guides/video/vidu-q1#resources)
  * [ Introducting ViduQ1](https://docs.z.ai/guides/video/vidu-q1#introducting-viduq1)
  * [ Quick Start](https://docs.z.ai/guides/video/vidu-q1#quick-start)
  * [1. Text-to-Video Generation](https://docs.z.ai/guides/video/vidu-q1#1-text-to-video-generation)
  * [2. Image-to-Video Generation](https://docs.z.ai/guides/video/vidu-q1#2-image-to-video-generation)
  * [3. Start and End Frame](https://docs.z.ai/guides/video/vidu-q1#3-start-and-end-frame)


Video Generation Models
# Vidu Q1
Copy page
Copy page
##
[​](https://docs.z.ai/guides/video/vidu-q1#overview)
Overview
Vidu Q1 is the next-generation video generation model from Vidu, designed for high-quality video creation. It consistently outputs 5-second, 24-frame, 1080P video clips. Through advanced optimization of visual clarity, Vidu Q1 delivers significantly enhanced image quality with notable improvements in issues such as hand distortion and frame jitter. The model achieves photorealistic rendering that closely resembles real-world scenes, while maintaining stylistic accuracy in 2D animation. Transitions between the first and last frames are exceptionally smooth, making Vidu Q1 well-suited for demanding creative applications in film, advertising, and animated short productions.
  * viduq1-image
  * viduq1-start-end
  * viduq1-text


## Price
$0.4 / video
## Capability
Image-to-Video Generation
## Duration
5S
## Clarity
1080P
##
[​](https://docs.z.ai/guides/video/vidu-q1#capability-description)
Capability Description
## Image-to-Video Generation
Generate a video by providing a starting frame or both starting and ending frames along with corresponding text descriptions.
## Start and End Frame
Support input of two images: the first uploaded image is treated as the starting frame, and the second as the ending frame. The model uses these images as input parameters to generate the video.
## Text-to-Video Generation
Generate a video from a text prompt; currently supports both a general style and an anime style optimized for animation.
The URL link for the video generated by the model is valid for one day. Please save it as soon as possible if needed.
##
[​](https://docs.z.ai/guides/video/vidu-q1#usage)
Usage
Film Generation
  * By inputting script excerpts, concept art, and other materials, users can generate promotional videos, visual effects shots, and auxiliary film assets
  * Delivers theatrical-level clarity and visual quality with complete frame details
  * Provides professional-grade video transitions with natural scene flow


Anime Production
  * Input character designs and storyboard scripts to quickly generate 2D animated sequences and stylized anime shorts
  * Supports styles such as Chinese animation and Japanese anime
  * Enables storyline extension and creative regeneration of classic IPs


Short Drama Production
  * Automatically generate short videos or micro-dramas from novel chapters or scripted scenes
  * Covers diverse genres such as romance, mystery, and historical drama
  * Optimized for multi-platform distribution needs


Advertising & Marketing
  * Quickly generate highly engaging brand ads, e-commerce product videos, and interactive ads (e.g., virtual try-on) based on product images and feature descriptions
  * Supports adaptation to various platform dimensions and creative formats


##
[​](https://docs.z.ai/guides/video/vidu-q1#resources)
Resources
[API Documentation](https://docs.z.ai/api-reference/video/cogvideox-3&vidu): Learn how to call the API.
##
[​](https://docs.z.ai/guides/video/vidu-q1#introducting-viduq1)
Introducting ViduQ1
1
### Cinematic-Level Visual Clarity
The model delivers a comprehensive upgrade in visual detail restoration.
2
### Precise Resolution of Visual Artifacts
Movements are smooth and natural—hand gestures during product demonstrations in e-commerce livestreams are accurately rendered and compliant. Visual jitter is minimized through dynamic frame interpolation technology, ensuring fluid and stable footage even in motion-heavy scenes such as running shots or vehicle perspectives.
3
### Multi-Style Artistic Expression
The realistic style aims for lifelike visuals—urban landscapes and character portraits in city promos are rendered with striking realism. The animated style focuses on authenticity, accurately capturing everything from the hand-drawn lines of Japanese anime to the saturated colors of Western cartoons. By inputting anime character designs, the model generates dynamic story segments that closely match the original IP’s visual style, boosting the efficiency of derivative content creation.
  * Realistic Style
  * Animated Style


4
### Industry-Leading Transition Smoothness
The start and end frame transition technology reaches a new level, using dynamic frame prediction and style fusion algorithms to overcome the limitations of “mechanical stitching” in video transitions.
##
[​](https://docs.z.ai/guides/video/vidu-q1#quick-start)
Quick Start
###
[​](https://docs.z.ai/guides/video/vidu-q1#1-text-to-video-generation)
1. Text-to-Video Generation
  * Curl
  * Python


Copy
```
curl --location --request POST 'https://api.z.ai/api/paas/v4/videos/generations' \
--header 'Authorization: Bearer {your apikey}' \
--header 'Content-Type: application/json' \
--data-raw '{
  "model": "viduq1-text",
  "style": "anime",
  "prompt": "Peter Rabbit drives a small car along the road, his face filled with joy and happiness.",
  "duration": 5,
  "aspect_ratio": "16:9",
  "size": "1920x1080",
  "movement_amplitude": "auto"
}'

```

###
[​](https://docs.z.ai/guides/video/vidu-q1#2-image-to-video-generation)
2. Image-to-Video Generation
  * Curl
  * Python


Copy
```
curl --location --request POST 'https://api.z.ai/api/paas/v4/videos/generations' \
--header 'Authorization: Bearer {your apikey}' \
--header 'Content-Type: application/json' \
--data-raw '{
  "model":"viduq1-image",
  "image_url":"https://example.com/path/to/your/image.jpg",
  "prompt":"Peter Rabbit drives a small car along the road, his face filled with joy and happiness.",
  "duration":5,
  "size":"1920x1080",
  "movement_amplitude":"auto"
}'

```

###
[​](https://docs.z.ai/guides/video/vidu-q1#3-start-and-end-frame)
3. Start and End Frame
  * Curl
  * Python


Copy
```
curl --location --request POST 'https://api.z.ai/api/paas/v4/videos/generations' \
--header 'Authorization: Bearer {your apikey}' \
--header 'Content-Type: application/json' \
--data-raw '{
  "model":"viduq1-start-end",
  "image_url":["https://example.com/path/to/your/image.jpg","https://example.com/path/to/your/image1.jpg"],
  "prompt":"Peter Rabbit drives a small car along the road, his face filled with joy and happiness.",
  "duration":5,
  "size":"1920x1080",
  "movement_amplitude":"auto"
}'

```

Was this page helpful?
YesNo
[CogVideoX-3](https://docs.z.ai/guides/video/cogvideox-3)[Vidu 2](https://docs.z.ai/guides/video/vidu2)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
