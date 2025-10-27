# https://docs.z.ai/api-reference/agents/agent

Source: [https://docs.z.ai/api-reference/agents/agent](https://docs.z.ai/api-reference/agents/agent)

---

[Skip to main content](https://docs.z.ai/api-reference/agents/agent#content-area)
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
Agent Chat
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
 --url https://api.z.ai/api/v1/agents \
 --header 'Authorization: Bearer <token>' \
 --header 'Content-Type: application/json' \
 --data '{
 "agent_id": "general_translation",
 "stream": true,
 "messages": [
  {
   "role": "user",
   "content": [
    {
     "type": "text",
     "text": "<string>"
    }
   ]
  }
 ],
 "custom_variables": {
  "source_lang": "auto",
  "target_lang": "zh-CN",
  "glossary": "<string>",
  "strategy": "general",
  "strategy_config": {
   "general": {
    "suggestion": "<string>"
   },
   "cot": {
    "reason_lang": "from"
   }
  }
 }
}'
```

200
General Translation
Copy
```
{ "id": "<string>", "agent_id": "<string>", "choices": [  {   "index": 123,   "finish_reason": "<string>",   "messages": [    {     "role": "<string>",     "content": {      "text": "<string>",      "type": "<string>"     }    }   ]  } ], "usage": {  "prompt_tokens": 123,  "completion_tokens": 123,  "total_tokens": 123,  "total_calls": 123 }}
```

Agent API
# Agent Chat
Copy page
General Translation: General Translation API provides large model-based multilingual translation services, including general translation, paraphrase translation, two-step translation, and three-pass translation strategies. It supports automatic language detection, glossary customization, translation suggestions, and streaming output. Users only need to call the Translation API, input the text to be processed, specify the source language (auto-detection supported) and target language to receive high-quality translation results.
Popular Special Effects Videos: Popular special effects videos are intelligent templates launched based on trending features from pan-entertainment platforms, designed to precisely adapt to short video creative production needs. Currently, three effect templates are available: `French Kiss`, `Body Shake Dance`, and `Sexy Me`. After selecting a template, users only need to upload an image and enter corresponding prompts to generate a special effects video.
GLM Slide/Poster Agent: An intelligent creation agent built for working people and creators. It goes beyond traditional engineering-style assembly tools—supporting one-click generation of slides or posters from natural language instructions. By natively integrating content generation with layout aesthetics and design conventions, it helps you quickly produce polished, professional-grade materials while lowering design barriers and boosting creative efficiency.
Copy page
POST
/
v1
/
agents
Try it
cURL
cURL
Copy
```
curl --request POST \
 --url https://api.z.ai/api/v1/agents \
 --header 'Authorization: Bearer <token>' \
 --header 'Content-Type: application/json' \
 --data '{
 "agent_id": "general_translation",
 "stream": true,
 "messages": [
  {
   "role": "user",
   "content": [
    {
     "type": "text",
     "text": "<string>"
    }
   ]
  }
 ],
 "custom_variables": {
  "source_lang": "auto",
  "target_lang": "zh-CN",
  "glossary": "<string>",
  "strategy": "general",
  "strategy_config": {
   "general": {
    "suggestion": "<string>"
   },
   "cot": {
    "reason_lang": "from"
   }
  }
 }
}'
```

200
General Translation
Copy
```
{ "id": "<string>", "agent_id": "<string>", "choices": [  {   "index": 123,   "finish_reason": "<string>",   "messages": [    {     "role": "<string>",     "content": {      "text": "<string>",      "type": "<string>"     }    }   ]  } ], "usage": {  "prompt_tokens": 123,  "completion_tokens": 123,  "total_tokens": 123,  "total_calls": 123 }}
```

#### Authorizations
[​](https://docs.z.ai/api-reference/agents/agent#authorization-authorization)
Authorization
string
header
required
Use the following format for authentication: Bearer [<your api key>](https://z.ai/manage-apikey/apikey-list)
#### Headers
[​](https://docs.z.ai/api-reference/agents/agent#parameter-accept-language)
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
  * General Translation
  * Popular Special Effects Videos
  * GLM Slide/Poster


[​](https://docs.z.ai/api-reference/agents/agent#body-agent-id)
agent_id
enum<string>
required
Agent ID: `general_translation`.
Available options: 
`general_translation`
[​](https://docs.z.ai/api-reference/agents/agent#body-messages)
messages
object[]
required
Session message body.
Hide child attributes
[​](https://docs.z.ai/api-reference/agents/agent#body-messages-role)
role
enum<string>
default:user
required
User input role: `user`
Available options: 
`user`
Example:
`"user"`
[​](https://docs.z.ai/api-reference/agents/agent#body-messages-content)
content
object[]
required
Content list.
Hide child attributes
[​](https://docs.z.ai/api-reference/agents/agent#body-content-type)
type
enum<string>
default:text
required
Supported type: `text`.
Available options: 
`text`
[​](https://docs.z.ai/api-reference/agents/agent#body-content-text)
text
string
required
User text input.
[​](https://docs.z.ai/api-reference/agents/agent#body-stream)
stream
boolean
False for sync calls (default). True for streaming.
[​](https://docs.z.ai/api-reference/agents/agent#body-custom-variables)
custom_variables
object
Hide child attributes
[​](https://docs.z.ai/api-reference/agents/agent#body-custom-variables-source-lang)
custom_variables.source_lang
enum<string>
Supported language codes (default: `auto`):
  * `auto`: Auto Detect
  * `zh-CN`: Simplified Chinese
  * `zh-TW`: Traditional Chinese
  * `wyw`: Classical Chinese
  * `yue`: Cantonese
  * `en`: English
  * `ja`: Japanese
  * `ko`: Korean
  * `fr`: French
  * `de`: German
  * `es`: Spanish
  * `ru`: Russian
  * `pt`: Portuguese
  * `it`: Italian
  * `ar`: Arabic
  * `hi`: Hindi
  * `bg`: Bulgarian
  * `cs`: Czech
  * `da`: Danish
  * `el`: Greek
  * `et`: Estonian
  * `fi`: Finnish
  * `hu`: Hungarian
  * `id`: Indonesian
  * `lt`: Lithuanian
  * `lv`: Latvian
  * `nl`: Dutch
  * `no`: Norwegian Bokmål
  * `pl`: Polish
  * `ro`: Romanian
  * `sk`: Slovak
  * `sl`: Slovenian
  * `sv`: Swedish
  * `th`: Thai
  * `tr`: Turkish
  * `uk`: Ukrainian
  * `vi`: Vietnamese
  * `my`: Burmese
  * `ms`: Malay
  * `Pinyin`: Pinyin
  * `IPA`: International Phonetic Alphabet


Available options: 
`auto`, 
`zh-CN`, 
`zh-TW`, 
`wyw`, 
`yue`, 
`en`, 
`ja`, 
`ko`, 
`fr`, 
`de`, 
`es`, 
`ru`, 
`pt`, 
`it`, 
`ar`, 
`hi`, 
`bg`, 
`cs`, 
`da`, 
`el`, 
`et`, 
`fi`, 
`hu`, 
`id`, 
`lt`, 
`lv`, 
`nl`, 
`no`, 
`pl`, 
`ro`, 
`sk`, 
`sl`, 
`sv`, 
`th`, 
`tr`, 
`uk`, 
`vi`, 
`my`, 
`ms`, 
`Pinyin`, 
`IPA`
[​](https://docs.z.ai/api-reference/agents/agent#body-custom-variables-target-lang)
custom_variables.target_lang
enum<string>
Target language code (default: `zh-CN`):
  * `zh-CN`: Simplified Chinese
  * `zh-TW`: Traditional Chinese
  * `wyw`: Classical Chinese
  * `yue`: Cantonese
  * `en`: English
  * `en-GB`: English (British)
  * `en-US`: English (American)
  * `ja`: Japanese
  * `ko`: Korean
  * `fr`: French
  * `de`: German
  * `es`: Spanish
  * `ru`: Russian
  * `pt`: Portuguese
  * `it`: Italian
  * `ar`: Arabic
  * `hi`: Hindi
  * `bg`: Bulgarian
  * `cs`: Czech
  * `da`: Danish
  * `el`: Greek
  * `et`: Estonian
  * `fi`: Finnish
  * `hu`: Hungarian
  * `id`: Indonesian
  * `lt`: Lithuanian
  * `lv`: Latvian
  * `nl`: Dutch
  * `no`: Norwegian Bokmål
  * `pl`: Polish
  * `ro`: Romanian
  * `sk`: Slovak
  * `sl`: Slovenian
  * `sv`: Swedish
  * `th`: Thai
  * `tr`: Turkish
  * `uk`: Ukrainian
  * `vi`: Vietnamese
  * `my`: Burmese
  * `ms`: Malay
  * `Pinyin`: Pinyin
  * `IPA`: International Phonetic Alphabet .


Available options: 
`zh-CN`, 
`zh-TW`, 
`wyw`, 
`yue`, 
`en`, 
`en-GB`, 
`en-US`, 
`ja`, 
`ko`, 
`fr`, 
`de`, 
`es`, 
`ru`, 
`pt`, 
`it`, 
`ar`, 
`hi`, 
`bg`, 
`cs`, 
`da`, 
`el`, 
`et`, 
`fi`, 
`hu`, 
`id`, 
`lt`, 
`lv`, 
`nl`, 
`no`, 
`pl`, 
`ro`, 
`sk`, 
`sl`, 
`sv`, 
`th`, 
`tr`, 
`uk`, 
`vi`, 
`my`, 
`ms`, 
`Pinyin`, 
`IPA`
[​](https://docs.z.ai/api-reference/agents/agent#body-custom-variables-glossary)
custom_variables.glossary
string
Glossary ID.
[​](https://docs.z.ai/api-reference/agents/agent#body-custom-variables-strategy)
custom_variables.strategy
enum<string>
Translation strategy (default: `general`)，Optional:
  * `general`: General Translation
  * `paraphrase`: Paraphrase Translation
  * `two_step`: Two-Step Translation
  * `three_step`: Three-Stage Translation
  * `reflection`: Reflection Translation; cot: COT Translation


Available options: 
`general`, 
`paraphrase`, 
`two_step`, 
`three_step`, 
`reflection`
[​](https://docs.z.ai/api-reference/agents/agent#body-custom-variables-strategy-config)
custom_variables.strategy_config
object
Strategy parameters.
Hide child attributes
[​](https://docs.z.ai/api-reference/agents/agent#body-custom-variables-strategy-config-general)
custom_variables.strategy_config.general
object
Hide child attributes
[​](https://docs.z.ai/api-reference/agents/agent#body-custom-variables-strategy-config-general-suggestion)
custom_variables.strategy_config.general.suggestion
string
Translation suggestions or style requirements (e.g., terminology mapping, style guidelines).
[​](https://docs.z.ai/api-reference/agents/agent#body-custom-variables-strategy-config-cot)
custom_variables.strategy_config.cot
object
Parameters when strategy is `cot`.
Hide child attributes
[​](https://docs.z.ai/api-reference/agents/agent#body-custom-variables-strategy-config-cot-reason-lang)
custom_variables.strategy_config.cot.reason_lang
enum<string>
Language for translation reasoning, values: [`from`｜`to`], default: `to`.
Available options: 
`from`, 
`to`
#### Response
200
application/json
Processing successful
  * General Translation
  * Popular Special Effects Videos
  * GLM Slide/Poster


[​](https://docs.z.ai/api-reference/agents/agent#response-id)
id
string
Task ID.
[​](https://docs.z.ai/api-reference/agents/agent#response-agent-id)
agent_id
string
Agent ID.
[​](https://docs.z.ai/api-reference/agents/agent#response-status)
status
string
Task status.
[​](https://docs.z.ai/api-reference/agents/agent#response-choices)
choices
object[]
Model output content.
Hide child attributes
[​](https://docs.z.ai/api-reference/agents/agent#response-choices-index)
index
integer
Result index.
[​](https://docs.z.ai/api-reference/agents/agent#response-choices-finish-reason)
finish_reason
string
Termination reason: `stop` (normal completion), `tool_calls` (model calls), `length` (token limit exceeded), `sensitive` (content flagged), `network_error` (model inference error).
[​](https://docs.z.ai/api-reference/agents/agent#response-choices-messages)
messages
object
Model response message.
Hide child attributes
[​](https://docs.z.ai/api-reference/agents/agent#response-messages-role)
messages.role
string
Dialog role (default: `assistant`).
[​](https://docs.z.ai/api-reference/agents/agent#response-messages-content)
messages.content
object
Inference result
Hide child attributes
[​](https://docs.z.ai/api-reference/agents/agent#response-messages-content-type)
messages.content.type
string
Result type.
[​](https://docs.z.ai/api-reference/agents/agent#response-messages-content-text)
messages.content.text
string
Result content.
[​](https://docs.z.ai/api-reference/agents/agent#response-usage)
usage
object
Token usage statistics.
Hide child attributes
[​](https://docs.z.ai/api-reference/agents/agent#response-usage-prompt-tokens)
usage.prompt_tokens
integer
Input tokens count.
[​](https://docs.z.ai/api-reference/agents/agent#response-usage-completion-tokens)
usage.completion_tokens
integer
Output tokens count.
[​](https://docs.z.ai/api-reference/agents/agent#response-usage-total-tokens)
usage.total_tokens
integer
Total tokens count.
[​](https://docs.z.ai/api-reference/agents/agent#response-usage-total-calls)
usage.total_calls
integer
Total number of calls
Was this page helpful?
YesNo
[Web Search](https://docs.z.ai/api-reference/tools/web-search)[File Upload](https://docs.z.ai/api-reference/agents/file-upload)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
