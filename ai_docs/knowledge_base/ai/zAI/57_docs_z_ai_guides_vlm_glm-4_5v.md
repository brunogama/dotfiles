# https://docs.z.ai/guides/vlm/glm-4.5v

Source: [https://docs.z.ai/guides/vlm/glm-4.5v](https://docs.z.ai/guides/vlm/glm-4.5v)

---

[Skip to main content](https://docs.z.ai/guides/vlm/glm-4.5v#content-area)
🚀 **GLM Coding Plan — built for devs: 3× usage, 1/7 cost** • [Limited-Time Offer ➞](https://z.ai/subscribe?utm_campaign=Platform_Ops&_channel_track_key=DaprgHIc)
[Z.AI DEVELOPER DOCUMENT home page![light logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/dark.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=75deefa9dea5bdbc84d4da68885c267f)![dark logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/light.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=c1ecf1af358fa8eeab8c06052337f8f6)](https://z.ai/model-api)
English
Search...
⌘K
  * [API Keys](https://z.ai/manage-apikey/apikey-list)
  * [Payment Method](https://z.ai/manage-apikey/billing)


Search...
Navigation
Visual Language Models
GLM-4.5V
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
  * [ Overview](https://docs.z.ai/guides/vlm/glm-4.5v#overview)
  * [ Usage](https://docs.z.ai/guides/vlm/glm-4.5v#usage)
  * [ Resources](https://docs.z.ai/guides/vlm/glm-4.5v#resources)
  * [ Introducting GLM-4.5V](https://docs.z.ai/guides/vlm/glm-4.5v#introducting-glm-4-5v)
  * [ Examples](https://docs.z.ai/guides/vlm/glm-4.5v#examples)
  * [ Quick Start](https://docs.z.ai/guides/vlm/glm-4.5v#quick-start)


Visual Language Models
# GLM-4.5V
Copy page
Copy page
## 
[​](https://docs.z.ai/guides/vlm/glm-4.5v#overview)
Overview
GLM-4.5V is Z.AI’s new generation of visual reasoning models based on the MOE architecture. With a total of 106B parameters and 12B activation parameters, it achieves SOTA performance among open-source VLMs of the same level in various benchmark tests, covering common tasks such as image, video, document understanding, and GUI tasks.
## Price
  * Input: $0.6 per million tokens
  * Output: $1.8 per million tokens


## Input Modality
Video / Image / Text / File
## Output Modality
Text
## Maximum Output Tokens
16K
## 
[​](https://docs.z.ai/guides/vlm/glm-4.5v#usage)
Usage
Web Page Coding
Analyze webpage screenshots or screen recording videos, understand layout and interaction logic, and generate complete and usable webpage code with one click.
Grounding
Precisely identify and locate target objects, suitable for practical scenarios such as security checks, quality inspections, content reviews, and remote sensing monitoring.
GUI Agent
Recognize and process screen images, support execution of commands like clicking and sliding, providing reliable support for intelligent agents to complete operational tasks.
Complex Long Document Interpretation
Deeply analyze complex documents spanning dozens of pages, support summarization, translation, chart extraction, and can propose insights based on content.
Image Recognition and Reasoning
Strong reasoning ability and rich world knowledge, capable of deducing background information of images without using search.
Video Understanding
Able to parse long video content and accurately infer the time, characters, events, and logical relationships within the video.
Subject Problem Solving
Can solve complex text-image combined problems, suitable for K12 educational scenarios for problem-solving and explanation.
## 
[​](https://docs.z.ai/guides/vlm/glm-4.5v#resources)
Resources
  * [API Documentation](https://docs.z.ai/api-reference/llm/chat-completion): Learn how to call the API.


## 
[​](https://docs.z.ai/guides/vlm/glm-4.5v#introducting-glm-4-5v)
Introducting GLM-4.5V
1
### Open-Source Multimodal SOTA
GLM-4.5V, based on Z.AI’s flagship GLM-4.5-Air, continues the iterative upgrade of the GLM-4.1V-Thinking technology route, achieving comprehensive performance at the same level as open-source SOTA models in 42 public visual multimodal benchmarks, covering common tasks such as image, video, document understanding, and GUI tasks.![Description](https://cdn.bigmodel.cn/markdown/1754969019359glm-4.5v-16.jpeg?attname=glm-4.5v-16.jpeg)
2
### Support Thinking and Non-Thinking
GLM-4.5V introduces a new “Thinking Mode” switch, allowing users to freely switch between quick response and deep reasoning, flexibly balancing processing speed and output quality according to task requirements.
## 
[​](https://docs.z.ai/guides/vlm/glm-4.5v#examples)
Examples
  * Web Page Coding
  * GUI Agent
  * Chart Conversion
  * Grounding


## Prompt
![Description](https://cdn.bigmodel.cn/markdown/1754969059126glm-4.5v-17.png?attname=glm-4.5v-17.png)Please generate a high - quality UI interface using CSS and HTML based on the webpage I provided.
## Display
Screenshot of the rendered web page:![Description](https://cdn.bigmodel.cn/markdown/1754969077749glm-4.5v-18.png?attname=glm-4.5v-18.png)
## 
[​](https://docs.z.ai/guides/vlm/glm-4.5v#quick-start)
Quick Start
  * cURL
  * Python
  * Java


**Basic Call**
Copy
```
curl --location 'https://api.z.ai/api/paas/v4/chat/completions' \
--header 'Authorization: Bearer YOUR_API_KEY' \
--header 'Accept-Language: en-US,en' \
--header 'Content-Type: application/json' \
--data '{
"model": "glm-4.5v",
"messages": [
  {
    "role": "user",
    "content": [
      {
        "type": "image_url",
        "image_url": {
          "url": "https://cloudcovert-1305175928.cos.ap-guangzhou.myqcloud.com/%E5%9B%BE%E7%89%87grounding.PNG"
        }
      },
      {
        "type": "text",
        "text": "Where is the second bottle of beer from the right on the table? Provide coordinates in [[xmin,ymin,xmax,ymax]] format"
      }
    ]
  }
],
"thinking": {
  "type":"enabled"
}
}'

```

**Streaming Call**
Copy
```
curl --location 'https://api.z.ai/api/paas/v4/chat/completions' \
--header 'Authorization: Bearer YOUR_API_KEY' \
--header 'Accept-Language: en-US,en' \
--header 'Content-Type: application/json' \
--data '{
"model": "glm-4.5v",
"messages": [
  {
    "role": "user",
    "content": [
      {
        "type": "image_url",
        "image_url": {
          "url": "https://cloudcovert-1305175928.cos.ap-guangzhou.myqcloud.com/%E5%9B%BE%E7%89%87grounding.PNG"
        }
      },
      {
        "type": "text",
        "text": "Where is the second bottle of beer from the right on the table? Provide coordinates in [[xmin,ymin,xmax,ymax]] format"
      }
    ]
  }
],
"thinking": {
  "type":"enabled"
},
"stream": true
}'

```

Was this page helpful?
YesNo
[GLM-4-32B-0414-128K](https://docs.z.ai/guides/llm/glm-4-32b-0414-128k)[CogView-4](https://docs.z.ai/guides/image/cogview-4)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
![Description](https://cdn.bigmodel.cn/markdown/1754969019359glm-4.5v-16.jpeg?attname=glm-4.5v-16.jpeg)
![Description](https://cdn.bigmodel.cn/markdown/1754969059126glm-4.5v-17.png?attname=glm-4.5v-17.png)
![Description](https://cdn.bigmodel.cn/markdown/1754969077749glm-4.5v-18.png?attname=glm-4.5v-18.png)
