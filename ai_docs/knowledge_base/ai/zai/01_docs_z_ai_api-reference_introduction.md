# https://docs.z.ai/api-reference/introduction

Source: [https://docs.z.ai/api-reference/introduction](https://docs.z.ai/api-reference/introduction)

---

[Skip to main content](https://docs.z.ai/api-reference/introduction#content-area)
🚀 **GLM Coding Plan — built for devs: 3× usage, 1/7 cost** • [Limited-Time Offer ➞](https://z.ai/subscribe?utm_campaign=Platform_Ops&_channel_track_key=DaprgHIc)
[Z.AI DEVELOPER DOCUMENT home page![light logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/dark.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=75deefa9dea5bdbc84d4da68885c267f)![dark logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/light.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=c1ecf1af358fa8eeab8c06052337f8f6)](https://z.ai/model-api)
English
Search...
⌘K
  * [API Keys](https://z.ai/manage-apikey/apikey-list)
  * [Payment Method](https://z.ai/manage-apikey/billing)


Search...
Navigation
Using the APIs
Introduction
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


On this page
  * [Authentication](https://docs.z.ai/api-reference/introduction#authentication)
  * [Playground](https://docs.z.ai/api-reference/introduction#playground)
  * [Call Examples](https://docs.z.ai/api-reference/introduction#call-examples)


Using the APIs
# Introduction
Copy page
Copy page
The API reference describes the RESTful APIs you can use to interact with the Z.AI platform.
Z.AI provides standard HTTP API interfaces that support multiple programming languages and development environments, with [SDKs](https://docs.z.ai/guides/develop/python/introduction) also available.
##
[​](https://docs.z.ai/api-reference/introduction#authentication)
Authentication
The Z.AI API uses the standard **HTTP Bearer** for authentication. An API key is required, which you can create or manage on the [API Keys Page](https://z.ai/manage-apikey/apikey-list). API keys should be provided via HTTP Bearer Authentication in HTTP Request Headers.
Copy
```
Authorization: Bearer ZAI_API_KEY

```

##
[​](https://docs.z.ai/api-reference/introduction#playground)
Playground
The API Playground allows developers to quickly try out API calls. Simply click **Try it** on the API details page to get started.
  * On the API details page, there are many interactive options, such as **switching input types** , **switching tabs** , and **adding new content**.
  * You can click **Add an item** or **Add new property** to add more properties the API need.
  * **Note** that when switching the tabs, the previous properties value you need re-input or re-switch.


##
[​](https://docs.z.ai/api-reference/introduction#call-examples)
Call Examples
  * cURL
  * Official Python SDK
  * Official Java SDK
  * OpenAI Python SDK
  * OpenAI NodeJs SDK
  * OpenAI Java SDK


Copy
```
curl -X POST "https://api.z.ai/api/paas/v4/chat/completions" \
-H "Content-Type: application/json" \
-H "Accept-Language: en-US,en" \
-H "Authorization: Bearer YOUR_API_KEY" \
-d '{
  "model": "glm-4.6",
  "messages": [
    {
      "role": "system",
      "content": "You are a helpful AI assistant."
    },
    {
      "role": "user",
      "content": "Hello, please introduce yourself."
    }
  ],
  "temperature": 1.0,
  "stream": true
}'

```

Was this page helpful?
YesNo
[Errors](https://docs.z.ai/api-reference/api-code)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
