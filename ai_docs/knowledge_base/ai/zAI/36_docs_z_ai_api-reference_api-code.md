# https://docs.z.ai/api-reference/api-code

Source: [https://docs.z.ai/api-reference/api-code](https://docs.z.ai/api-reference/api-code)

---

[Skip to main content](https://docs.z.ai/api-reference/api-code#content-area)
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
Errors
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
  * [HTTP Status Code](https://docs.z.ai/api-reference/api-code#http-status-code)
  * [Business Error Codes](https://docs.z.ai/api-reference/api-code#business-error-codes)
  * [Error Shapes](https://docs.z.ai/api-reference/api-code#error-shapes)
  * [Error Example](https://docs.z.ai/api-reference/api-code#error-example)


Using the APIs
# Errors
Copy page
Copy page
When calling the API, the response code consists of two parts: the outer layer is the HTTP status code, and the inner layer is the business error code defined by Z.AI in the response body, which provides a more detailed error description.
## 
[​](https://docs.z.ai/api-reference/api-code#http-status-code)
HTTP Status Code
Code| Reason| Solution  
---|---|---  
200| Business processing successful| -  
400| Parameter error| Check if the interface parameters are correct  
400| File content anomaly| Check if the jsonl file content meets the requirements  
401| Authentication failure or Token timeout| Confirm if the API KEY and authentication token are correctly generated  
404| Fine-tuning feature not available| Contact customer service to activate this feature  
404| Fine-tuning task does not exist| Ensure the fine-tuning task ID is correct  
429| Interface request concurrency exceeded| Adjust the request frequency or contact business to increase concurrency  
429| File upload frequency too fast| Wait briefly and then request again  
429| Account balance exhausted| Recharge the account to ensure sufficient balance  
429| Account anomaly| Account has violation, please contact platform customer service to unlock  
429| Terminal account anomaly| Terminal user has violation, account has been locked  
434| No API permission, fine-tuning API and file management API are in beta phase, we will open soon| Wait for the interface to be officially open or contact platform customer service to apply for beta  
435| File size exceeds 100MB| Use a jsonl file smaller than 100MB or upload in batches  
500| Server error occurred while processing the request| Try again later or contact customer service  
## 
[​](https://docs.z.ai/api-reference/api-code#business-error-codes)
Business Error Codes
Error Category| Code| Error Message  
---|---|---  
Basic Error| 500| Internal Error  
Authentication Error| 1000| Authentication Failed  
| 1001| Authentication parameter not received in Header, unable to authenticate  
| 1002| Invalid Authentication Token, please confirm the correct transmission of the Authentication Token  
| 1003| Authentication Token expired, please regenerate/obtain  
| 1004| Authentication failed with the provided Authentication Token  
| 1100| Account Read/Write  
Account Error| 1110| Your account is currently inactive. Please check your account information  
| 1111| Your account does not exist  
| 1112| Your account has been locked, please contact customer service to unlock  
| 1113| Your account is in arrears, please recharge and try again  
| 1120| Unable to successfully access your account, please try again later  
| 1121| Account has irregular activities and has been locked  
API Call Error| 1200| API Call Error  
| 1210| Incorrect API call parameters, please check the documentation  
| 1211| Model does not exist, please check the model code  
| 1212| Current model does not support `${method}` call method  
| 1213| `${field}` parameter not received properly  
| 1214| Invalid `${field}` parameter. Please check the documentation  
| 1215| `${field1}` and `${field2}` cannot be set simultaneously, please check the documentation  
| 1220| You do not have permission to access `${API_name}`  
| 1221| API `${API_name}` has been taken offline  
| 1222| API `${API_name}` does not exist  
| 1230| API call process error  
| 1231| You already have a request: `${request_id}`  
| 1234| Network error, error id: `${error_id}`, please contact customer service  
API Policy Block Error| 1300| API call blocked by policy  
| 1301| System detected potentially unsafe or sensitive content in input or generation. Please avoid using prompts that may generate sensitive content. Thank you for your cooperation.  
| 1302| High concurrency usage of this API, please reduce concurrency or contact customer service to increase limits  
| 1303| High frequency usage of this API, please reduce frequency or contact customer service to increase limits  
| 1304| Daily call limit for this API reached. For more requests, please contact customer service to purchase  
| 1308| Usage limit reached for . Your limit will reset at `${next_flush_time}`  
| 1309| Your GLM Coding Plan package has expired and is temporarily unavailable. You can resume using it after renewing the subscription on the official website. <https://z.ai/subscribe>  
## 
[​](https://docs.z.ai/api-reference/api-code#error-shapes)
Error Shapes
Errors are always returned as JSON, with a top-level error object that includes a `code` and `message` value.
Copy
```
{
 "error": {
  "code": "1214",
  "message": "Input cannot be empty"
 }
}

```

## 
[​](https://docs.z.ai/api-reference/api-code#error-example)
Error Example
The following is the response message of a curl request, where 401 is the HTTP status code and 1002 is the business error code.
Copy
```
* We are completely uploaded and fine
< HTTP/2 401
< date: Wed, 20 Mar 2024 03:06:05 GMT
< content-type: application/json
< set-cookie: acw_tc=76b20****a0e42;path=/;HttpOnly;Max-Age=1800
< server: nginx/1.21.6
< vary: Origin
< vary: Access-Control-Request-Method
< vary: Access-Control-Request-Headers
<
* Connection #0 to host open.z.ai left intact
{"error":{"code":"1002","message":"Authorization Token is invalid, please ensure that the Authorization Token is correctly provided."}}

```

> **Note** : When using streaming (SSE) calls, if the API terminates abnormally during inference, the above error codes will not be returned. Instead, the reason for the exception will be provided in the `finish_reason` parameter of the response body. For details, please refer to the description of the `finish_reason` parameter.
Was this page helpful?
YesNo
[Introduction](https://docs.z.ai/api-reference/introduction)[Rate Limits](https://docs.z.ai/api-reference/rate-limit)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
