# https://docs.z.ai/guides/image/cogview-4

Source: [https://docs.z.ai/guides/image/cogview-4](https://docs.z.ai/guides/image/cogview-4)

---

[Skip to main content](https://docs.z.ai/guides/image/cogview-4#content-area)
🚀 **GLM Coding Plan — built for devs: 3× usage, 1/7 cost** • [Limited-Time Offer ➞](https://z.ai/subscribe?utm_campaign=Platform_Ops&_channel_track_key=DaprgHIc)
[Z.AI DEVELOPER DOCUMENT home page![light logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/dark.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=75deefa9dea5bdbc84d4da68885c267f)![dark logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/light.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=c1ecf1af358fa8eeab8c06052337f8f6)](https://z.ai/model-api)
English
Search...
⌘K
  * [API Keys](https://z.ai/manage-apikey/apikey-list)
  * [Payment Method](https://z.ai/manage-apikey/billing)


Search...
Navigation
Image Generation Models
CogView-4
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
  * [ Overview](https://docs.z.ai/guides/image/cogview-4#overview)
  * [ Usage](https://docs.z.ai/guides/image/cogview-4#usage)
  * [ Resources](https://docs.z.ai/guides/image/cogview-4#resources)
  * [ Introducting CogView-4](https://docs.z.ai/guides/image/cogview-4#introducting-cogview-4)
  * [ Examples](https://docs.z.ai/guides/image/cogview-4#examples)
  * [ Quick Start](https://docs.z.ai/guides/image/cogview-4#quick-start)


Image Generation Models
# CogView-4
Copy page
Copy page
##
[​](https://docs.z.ai/guides/image/cogview-4#overview)
Overview
CogView-4 is Z.AI’s first open-source text-to-image model. It has comprehensive improvements in semantic understanding, image generation quality, and the ability to generate both English and Chinese text. It supports bilingual input of any length in Chinese and English and can generate images of any resolution within a specified range.
## Price
$0.01 / image
## Input Modality
Text
## Output Modality
Image
##
[​](https://docs.z.ai/guides/image/cogview-4#usage)
Usage
Food & Beverage Promotion
Generates visually appealing, detailed, and realistic food images based on dish names, ingredient characteristics, and style requirements, incorporating creative text elements. Suitable for menu design, food delivery platform displays, and offline posters.
E-commerce Product Images
Quickly generates high-resolution product display images based on product features and selling points, adding bilingual promotional text as needed. Fits the image requirements for different product pages and campaign visuals on e-commerce platforms.
Game Asset Creation
Produces high-resolution, detailed character illustrations and concept art based on game worldviews and character settings, meeting the needs of multi-resolution production.
Educational Material Illustrations
Analyzes teaching text content and automatically generates matching illustrations and scene images, adapted to the layout and resolution requirements of various educational materials, enhancing the visualization of knowledge.
Cultural & Tourism Promotion
Generates promotional images in different sizes based on cultural and tourism themes, skillfully combining text with region-specific visual elements to increase the appeal of cultural and tourism marketing.
##
[​](https://docs.z.ai/guides/image/cogview-4#resources)
Resources
  * [API Documentation](https://docs.z.ai/api-reference/image/generate-image): Learn how to call the API.


##
[​](https://docs.z.ai/guides/image/cogview-4#introducting-cogview-4)
Introducting CogView-4
1
### Achieved SOTA Performance at Release
DPG-Bench (Dense Prompt Graph Benchmark) is a benchmark for evaluating text-to-image generation models, focusing on the model’s performance in complex semantic alignment and instruction following.At the time of release, CogView-4 ranked first overall in the DPG-Bench benchmark test, achieving SOTA performance among open-source text-to-image models.![Description](https://cdn.bigmodel.cn/markdown/1749449849627DPG-Bench.png?attname=DPG-Bench.png)
2
### Better Chinese Understanding and Generation
Technically, CogView-4 replaced the English-only T5 encoder with the bilingual GLM-4 encoder and trained the model using bilingual image-text data, enabling the model to handle bilingual prompts.CogView-4 supports Chinese and English prompts and is especially good at understanding and following Chinese prompts, greatly lowering the prompt threshold for users. It is the first open-source text-to-image model capable of generating Chinese characters in the images, making it particularly suitable for creative needs in advertising, short videos, and other fields.
3
### Any Resolution and Any-Length Prompts
CogView-4 implements a mixed training paradigm of text descriptions (captions) of any length and images of any resolution. The model supports input prompts of any length and can generate images at any resolution within the supported range. This not only provides users with more creative freedom but also improves training efficiency.
##
[​](https://docs.z.ai/guides/image/cogview-4#examples)
Examples
  * Food & Beverage Promotion
  * E-commerce Product Images
  * Game Asset Creation
  * Cultural & Tourism Promotion


## Prompt
Close-up, commercial food photography, intense indoor lighting, extreme detail. A Christmas dinner table, a corner of the table where a long-haired orange tabby cat leans its head close to a plate, greedily sniffing the festive feast with an expression of pure delight. The table features roast chicken, plants, salad, champagne, and gold-rimmed porcelain tea sets. Afternoon sunlight bathes the cat’s profile in golden light, casting a soft glow over both the food and its fur. A Christmas tree adorns the background. The image emphasizes the texture of the food and the cat’s coat, featuring strong lighting and a warm, festive Christmas atmosphere.
## Display
![Description](https://mintcdn.com/zhipu-32152247/aOvZujLeW4WS84Ft/resource/cogview-1.png?fit=max&auto=format&n=aOvZujLeW4WS84Ft&q=85&s=6e96f8a615cfdd325a7abb4369d6396c)
##
[​](https://docs.z.ai/guides/image/cogview-4#quick-start)
Quick Start
  * cURL
  * Python
  * Java


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

Please note that the output of the CogView-4 model is an image URL. You will need to download the image using this URL.
Was this page helpful?
YesNo
[GLM-4.5V](https://docs.z.ai/guides/vlm/glm-4.5v)[CogVideoX-3](https://docs.z.ai/guides/video/cogvideox-3)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
![Description](https://cdn.bigmodel.cn/markdown/1749449849627DPG-Bench.png?attname=DPG-Bench.png)
![Description](https://mintcdn.com/zhipu-32152247/aOvZujLeW4WS84Ft/resource/cogview-1.png?w=560&fit=max&auto=format&n=aOvZujLeW4WS84Ft&q=85&s=d391a485c5c270d9c6391ad33a3f2730)
