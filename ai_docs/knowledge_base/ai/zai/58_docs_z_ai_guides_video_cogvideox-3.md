# https://docs.z.ai/guides/video/cogvideox-3

Source: [https://docs.z.ai/guides/video/cogvideox-3](https://docs.z.ai/guides/video/cogvideox-3)

---

[Skip to main content](https://docs.z.ai/guides/video/cogvideox-3#content-area)
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
CogVideoX-3
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
  * [ Overview](https://docs.z.ai/guides/video/cogvideox-3#overview)
  * [ Usage](https://docs.z.ai/guides/video/cogvideox-3#usage)
  * [ Resources](https://docs.z.ai/guides/video/cogvideox-3#resources)
  * [ Introducting CogVideoX-3](https://docs.z.ai/guides/video/cogvideox-3#introducting-cogvideox-3)
  * [ Quick Start](https://docs.z.ai/guides/video/cogvideox-3#quick-start)


Video Generation Models
# CogVideoX-3
Copy page
Copy page
##
[​](https://docs.z.ai/guides/video/cogvideox-3#overview)
Overview
CogVideoX-3 features new frame generation capabilities that significantly improve image stability and clarity. It also delivers superior performance in handling subjects with significant movement, better adheres to instructions, and provides more realistic simulations. Additionally, it enhances the rendering of high-definition real-world and 3D-style scenes.
## Price
$0.2 / video
## Input Modality
Image / Text / Start and End Frame
## Output Modality
Video
##
[​](https://docs.z.ai/guides/video/cogvideox-3#usage)
Usage
Advertising and Marketing
Input product images or copy to quickly generate dynamic ads in multiple styles, supporting scene transitions and realistic lighting rendering.
Short Video Creation
Convert single-frame images or text scripts into smooth, naturally animated short videos, covering both realistic and 3D styles.
Tourism Promotion
Upload scenic spot photos and promotional text to generate immersive tourism short videos with realistic natural landscapes.
Film and TV Production
Input storyboards or character design images to automatically generate dynamic preview clips, simulating seamless camera movements and realistic physical interactions.
##
[​](https://docs.z.ai/guides/video/cogvideox-3#resources)
Resources
  * [API Documentation](https://docs.z.ai/api-reference/video/cogvideox-3&vidu): Learn how to call the API.


##
[​](https://docs.z.ai/guides/video/cogvideox-3#introducting-cogvideox-3)
Introducting CogVideoX-3
1
### Significantly Improved Subject Clarity
Videos generated by CogVideoX-3 feature clear subjects, stable frames, reduced distortion issues, and support for subjects to move extensively, resulting in more natural and fluid dynamic performance.Prompt| Video
---|---
The petals were blown by the wind, spinning continuously and transforming into a person.|
Nezha happily took a sip of wine, then showed off the brand of wine.![wine](https://cdn.bigmodel.cn/markdown/1752546583242cogvideo1.png?attname=cogvideo1.png)|
2
### Better Command Compliance and Realistic Physical Simulation
Deeply understands the intent of text commands and accurately reproduces creative requirements. Whether it is having a character perform specific actions or simulating natural physical phenomena, it can be presented in accordance with real-world logic.Prompt| Video
---|---
A pair of hands holding a fruit knife, slicing a whole red tomato into slices.|
In an open-plan office, an employee is looking down at his phone. Suddenly, the manager appears and taps him on the shoulder. Startled, he quickly puts his phone away.|
3
### Enhanced High-Definition Realistic-Style Scenes and 3D-Style Scene Rendering
For realistic styles, it can create high-definition textures akin to real-life photography; when switching to 3D styles, it can precisely shape three-dimensional forms and scene atmospheres, effortlessly handling multiple styles.Prompt| Video
---|---
A high-angle shot captures Dou E and the sky. Dou E was an innocent woman from ancient China who was wrongfully accused. At this moment, she is looking up and shouting. Under the scorching June sun, white snow falls from the sky, scattering upon contact with bloodstains. Her clothes flutter slightly, accompanied by a 3D particle wind.|
A stylish anthropomorphic snow leopard wearing a white leopard-print fashion coat, super fluffy, plush, thick, and luxurious, walking the runway in ultra-high definition with a cinematic feel, reminiscent of a blockbuster movie, like a Victoria’s Secret fashion show. The runway is lined with spectators taking photos on both sides.|
4
### Added Start and End Frame Generation
Supports users providing start and end frames, automatically generating seamless transition content, allowing static frames to naturally connect into dynamic narratives, and linking complete creative concepts.Prompt| Start Frame| End Frame| Video
---|---|---|---
The Dragon King transforms into Ao Bing, with ink wash-style shading. The main character slowly transforms, highlighting the details of the transformation. The camera rotates smoothly, creating a natural and fluid transition.| ![](https://cdn.bigmodel.cn/markdown/1752547571093cogvideo2.png?attname=cogvideo2.png)| ![](https://cdn.bigmodel.cn/markdown/1752547589957cogvideo3.png?attname=cogvideo3.png)|
The character holds a gun in both hands and shoots wildly at the computer screen. The computer catches fire, explodes, and shatters into pieces, sending debris flying everywhere. The office lights flicker.| ![](https://cdn.bigmodel.cn/markdown/1752547801491cogvideo4.png?attname=cogvideo4.png)| ![](https://cdn.bigmodel.cn/markdown/1752547813297cogvideo5.png?attname=cogvideo5.png)|
##
[​](https://docs.z.ai/guides/video/cogvideox-3#quick-start)
Quick Start
  * Text-to-Video Generation
  * Image-to-Video Generation
  * Start and End Frame


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

Copy
```
from zai import ZaiClient
client = ZaiClient(api_key="your-api-key")
# Generate video
response = client.videos.generations(
  model="cogvideox-3",
  prompt="A cat is playing with a ball.",
  quality="quality", # Output mode, "quality" for quality priority, "speed" for speed priority
  with_audio=True, # Whether to include audio
  size="1920x1080", # Video resolution, supports up to 4K (e.g., "3840x2160")
  fps=30, # Frame rate, can be 30 or 60
)
print(response)
# Get video result
result = client.videos.retrieve_videos_result(id=response.id)
print(result)

```

Was this page helpful?
YesNo
[CogView-4](https://docs.z.ai/guides/image/cogview-4)[Vidu Q1](https://docs.z.ai/guides/video/vidu-q1)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
![](https://cdn.bigmodel.cn/markdown/1752547813297cogvideo5.png?attname=cogvideo5.png)
