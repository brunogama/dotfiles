# https://docs.z.ai/guides/tools/web-search

Source: [https://docs.z.ai/guides/tools/web-search](https://docs.z.ai/guides/tools/web-search)

---

[Skip to main content](https://docs.z.ai/guides/tools/web-search#content-area)
🚀 **GLM Coding Plan — built for devs: 3× usage, 1/7 cost** • [Limited-Time Offer ➞](https://z.ai/subscribe?utm_campaign=Platform_Ops&_channel_track_key=DaprgHIc)
[Z.AI DEVELOPER DOCUMENT home page![light logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/dark.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=75deefa9dea5bdbc84d4da68885c267f)![dark logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/light.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=c1ecf1af358fa8eeab8c06052337f8f6)](https://z.ai/model-api)
English
Search...
⌘K
  * [API Keys](https://z.ai/manage-apikey/apikey-list)
  * [Payment Method](https://z.ai/manage-apikey/billing)


Search...
Navigation
Tools
Web Search
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
  * [Product Overview](https://docs.z.ai/guides/tools/web-search#product-overview)
  * [Web Search API](https://docs.z.ai/guides/tools/web-search#web-search-api)
  * [MCP Server](https://docs.z.ai/guides/tools/web-search#mcp-server)
  * [Web Search in Chat](https://docs.z.ai/guides/tools/web-search#web-search-in-chat)


Tools
# Web Search
Copy page
Copy page
Z.AI provides developers with a full suite of AI search tools, covering three core services: **basic search (Web Search API)** , **retrieval-augmented generation (Web Search in Chat)** , and **intelligent search agents (Search Agent)**. Through a unified API, offering end-to-end capabilities—from raw web data retrieval and fusion of search results with LLM output, to multi-turn dialogue context management. This empowers developers to build trustworthy, real-time, and traceable AI applications at **lower cost**.
  * View [Product Price](https://docs.z.ai/guides/overview/pricing)
  * View Your [API Key](https://chat.z.ai)


##
[​](https://docs.z.ai/guides/tools/web-search#product-overview)
Product Overview
Service Module| Developer Value| Technical Features
---|---|---
Web Search API| Directly obtain **structured search results** (title/summary/link, etc.)| Multi-Search Engine Support
Web Search in Chat| Incorporate search results into large model-generated **answers with cited** **web sources**.| Seamless Integration of Real-Time Retrieval and LLM Generation
##
[​](https://docs.z.ai/guides/tools/web-search#web-search-api)
Web Search API
Web Search API is a search engine specifically designed for large language models. Building on the traditional capabilities of webpage crawling and ranking, it enhances intent recognition and returns results that are more suitable for LLM processing (webpage titles, URLs, summaries, site names, and favicons).
  1. Intent-Enhanced Retrieval: Intelligently identifies the user’s query intent and automatically determines whether web search is needed.
  2. Structured Output: Returns data formats optimized for LLMs, including titles, URLs, summaries, site names, and icons.
  3. Customizable Search Scope: Allows developers to specify the number of results, domain constraints, and time ranges. It also supports adjustable summary lengths for fine-grained search behavior control.
  4. Time-Aware Output Control: The response can include the webpage’s publication time, facilitating timeliness analysis and result ranking.

**API Call**
  * API Docs: [Web Search API](https://docs.z.ai/api-reference/tools/web-search)
  * Example: Search Financial News


Search Financial News
Copy
```
from zai import ZaiClient
client = ZaiClient(api_key="") # Fill in your own APIKey
response = client.web_search.web_search(
  search_engine="search-prime",
  search_query="search economic events",
  count=15, # The number of results to return, ranging from 1-50, default 10
  search_domain_filter="www.sohu.com", # Only access content from specified domain names.
  search_recency_filter="noLimit", # Search for content within specified date ranges
)
print(response)

```

Copy
```
WebSearchResp(
{
  "created": 1748261757,
  "id": "20250526201557dda85ca6801b467b",
  "request_id": "20250526201557dda85ca6801b467b",
  "search_result": [
    {
      "content": "1. China's outward direct investment from January to April reached $57.54 billion, a year-on-year increase of 7.5%. The trade-in policy continues to show results, with retail sales of home appliances maintaining double-digit growth for eight consecutive months.\n2. China has implemented multiple measures to accelerate the construction of a sci-tech financial system. The CSRC will support tech companies breaking through key core technologies by granting them 'green channel' access. The PBOC stated that nearly 100 institutions have issued over 250 billion yuan in sci-tech innovation bonds.\n3. In May, China's passenger car retail sales are estimated at around 1.85 million units, up 8.5% year-on-year and 5.4% month-on-month. New energy vehicle sales are expected to reach 980,000, maintaining a penetration rate of approximately 52.9%.\n4. The Beijing Humanoid Robot Innovation Center released the world's first 'Humanoid Robot Intelligence Grading' standard, establishing a 'four-dimensional, five-level' evaluation framework covering 'perception and cognition, decision-making and learning, execution performance, and collaborative interaction.'\n5. Federal Reserve Governor Waller stated that if the Trump administration's tariffs stabilize around 10%, the Fed may cut interest rates in the second half of 2025.\n6. The U.S. manufacturing PMI rose to a three-month high of 52.3 in May. The services PMI preliminary reading was 52.3, hitting a two-month high. New orders grew at their fastest pace in over a year, while price indicators reached a nearly three-year peak.\n7. The eurozone manufacturing PMI preliminary reading improved slightly to 49.2 in May, but the services PMI unexpectedly dropped sharply to 48.9, marking the worst performance in 16 months. This dragged the eurozone composite PMI down to 49.5 from 50.4 in April. Return to Sohu for more.",
      "icon": "https://sfile.chatglm.cn/searchImage/sohu_icon_new.jpg",
      "link": "https://www.sohu.com/a/897879632_121123890",
      "media": "Sohu",
      "publish_date": "2025-05-23",
      "refer": "ref_1",
      "title": "Financial Morning Briefing for May 23, 2025"
    },
    {
      "content": "1. The CSRC and seven other departments issued 'Several Measures to Support Financing for Small and Micro Enterprises,' proposing 23 specific initiatives across eight areas: increasing financing supply, reducing comprehensive financing costs, improving financing efficiency, enhancing support precision, implementing regulatory policies, strengthening risk management, improving policy safeguards, and ensuring effective implementation.\nComment: Increased support for small and micro enterprise financing, with 23 measures targeting the real economy to alleviate financing difficulties.\n2. Ministry of Commerce: From January to April 2025, China's outward direct investment across all sectors totaled $57.54 billion, up 7.5% year-on-year.\nComment: Steady growth in China's outward investment, with 'Belt and Road' cooperation likely a key driver.\nIndustry Insights\n3. Ministry of Commerce: From September 2024 to April 2025, retail sales of home appliances maintained double-digit growth for eight consecutive months. In April, retail sales of household appliances and audio-visual equipment in above-quota units surged 38.8% year-on-year, ranking first among 16 major consumer goods categories.\nComment: Strong demand for home appliances, driven by policy incentives and consumption upgrades.\n4. National Energy Administration: As of end-April, China's total installed power generation capacity reached 3.49 billion kW, up 15.9% year-on-year. From January to April, major power enterprises completed 193.3 billion yuan in power source engineering investments, up 1.6% year-on-year, while grid engineering investments totaled 140.8 billion yuan, up 14.6%.\nComment: Accelerated energy infrastructure development, with grid investment growth outpacing power source investment.\nGlobal Perspective\n5. The U.S. House Rules Committee approved Trump's comprehensive tax cut bill, paving the way for a full House vote.\nComment: Progress on Trump's tax cuts, which could stimulate U.S. consumption but exacerbate fiscal deficit pressures if enacted.\nFinancial Markets\n6. Most domestic commodity futures closed lower, with weak energy performance, widespread pressure on chemical futures, and declines in the black commodities sector. Agricultural products, particularly apple futures, also saw notable drops.\nComment: Broad-based commodity market declines reflect weak demand expectations.\n7. On Thursday, the onshore yuan closed at 7.2040 against the dollar at 16:30, up 25 basis points from the previous session. The central parity rate was adjusted up 34 basis points to 7.1903. Treasury futures mostly flatlined, with the 30-year contract down 0.04% and the 10-year contract up 0.01%.\nComment: Stabilizing yuan exchange rate, with parity rate adjustments signaling policy support.\n8. On May 22, the three major indices closed lower. Defense stocks led gains, while innovative drug concepts were active. Bank stocks bucked the trend, while pet economy concepts lagged, beauty care stocks plunged, and solid-state battery concepts retreated.\nComment: Structural divergence in A-shares as risk aversion rises, with caution advised over June U.S. debt maturity risks and potential global market corrections. Return to Sohu for more.",
      "icon": "https://sfile.chatglm.cn/searchImage/sohu_icon_new.jpg",
      "link": "https://www.sohu.com/a/897874861_121123901",
      "media": "Sohu",
      "publish_date": "2025-05-23",
      "refer": "ref_2",
      "title": "Financial Morning Briefing for May 23"
    },
    {
      "content": "According to Zhitong Finance APP, Macao's Composite Consumer Price Index (CPI) rose 0.23% year-on-year and 0.16% month-on-month in April 2025. The data, released by Macao's Statistics and Census Service on May 23, reflects subtle shifts in Macao's consumer market.\n1. Changes in Macao's CPI\nData shows that the 12-month average composite CPI as of April 2025 rose 0.42% compared to the same period a year earlier (May 2023–April 2024). Among major categories, the price index for Recreation, Sports, and Culture rose 2.47% year-on-year, while Miscellaneous Goods and Services increased 1.82%, signaling potential economic recovery.\n2. Impact of Food and Rent\nFood and non-alcoholic beverage prices rose 0.48% year-on-year, driven by higher dining-out and takeaway costs. Housing and fuel prices also increased 0.21% due to rising rents. As tourism recovers, dining demand has pushed up service fees.\nHowever, prices for Communication (-3.01%), Clothing (-2.35%), and Transport (-1.67%) declined, complicating the overall CPI trend.\n3. Month-on-Month Changes\nCompared to March 2025, April's CPI rose 0.16%. Recreation, Sports, and Culture saw the largest increase (2.6%) due to higher hotel rates. Summer clothing launches and rebounding airfares also lifted Clothing (+0.78%) and Transport (+0.42%) prices.\nDespite this, Food and non-alcoholic beverages dipped slightly (-0.04%) as lower prices for fresh fish, seafood, vegetables, and fruit offset higher dining costs.\n4. CPI Classification\nMacao's CPI is compiled into three series to reflect price impacts on households with different spending patterns. Category A (50% of households) covers monthly expenditures of 11,000–35,999 MOP, while Category B (30%) covers 36,000–71,999 MOP.\nHousing and fuel (34.47%), food (29.47%), and transport (8.33%) carry the highest weights, ensuring precise reflection of consumption trends across income groups.\n5. Outlook\nMacao's consumer market will continue to face multiple influences. While some categories show price declines, the overall mild CPI rise suggests recovery potential. With tourism rebounding and demand growing, CPI may maintain a gradual upward trend.\nIn summary, April 2025's CPI changes reflect market dynamics and new cost-of-living challenges. Authorities must monitor price impacts to craft effective policies ensuring stable living standards. Return to Sohu for more.",
      "icon": "https://sfile.chatglm.cn/searchImage/sohu_icon_new.jpg",
      "link": "https://www.sohu.com/a/898091955_121956424",
      "media": "Sohu",
      "publish_date": "2025-05-23",
      "refer": "ref_3",
      "title": "Macao's April 2025 CPI Rises Slightly: Key Drivers Explained"
    },
    {
      "content": "Zhitong Finance APP learned that on May 23, the Asset Management Association of China (AMAC) released its monthly report on private fund manager registrations and product filings. In April 2025, 1,606 new private funds were filed nationwide, with a total size of 643.72 billion yuan. This included 1,189 private securities investment funds (366.95 billion yuan), 143 private equity funds (161.01 billion yuan), and 274 venture capital funds (115.76 billion yuan).\n1. Private Fund Manager Registration Overview\n(1) Monthly Registrations\nIn April 2025, 16 institutions passed AMAC's AMBERS system, including 4 private securities investment fund managers and 12 private equity/venture capital fund managers. During the same period, 76 private fund managers were deregistered.\n(2) Existing Managers\nAs of end-April 2025, there were 19,891 private fund managers overseeing 141,579 funds with 20.22 trillion yuan in assets. This included 7,827 private securities investment fund managers, 11,867 private equity/venture capital managers, 6 asset allocation managers, and 191 others.\n(3) Geographic Distribution\nBy registered location (across 36 regions), 72.20% of managers were concentrated in Shanghai (3,714), Beijing (3,244), Shenzhen (3,012), Guangdong (ex-Shenzhen, 1,594), Zhejiang (ex-Ningbo, 1,590), and Jiangsu (1,207), accounting for 18.67%, 16.31%, 15.14%, 8.01%, 7.99%, and 6.07% respectively.\nBy AUM, the top regions were Shanghai (5.08 trillion yuan, 25.12%), Beijing (4.68 trillion yuan, 23.13%), Shenzhen (1.97 trillion yuan, 9.74%), Guangdong (ex-Shenzhen, 1.30 trillion yuan, 6.43%), Jiangsu (1.18 trillion yuan, 5.82%), and Zhejiang (ex-Ningbo, 967.16 billion yuan, 4.78%), totaling 75.02%.\n2. Private Fund Filings Overview\n(1) Monthly Filings\nApril 2025 saw 1,606 new private funds (643.72 billion yuan), including 1,189 private securities funds (366.95 billion yuan), 143 private equity funds (161.01 billion yuan), and 274 venture capital funds (115.76 billion yuan).\n(2) Existing Funds\nAs of end-April 2025, there were 141,579 private funds (20.22 trillion yuan), including 84,673 private securities funds (5.51 trillion yuan), 30,205 private equity funds (10.96 trillion yuan), and 25,830 venture capital funds (3.41 trillion yuan).",
      "icon": "https://sfile.chatglm.cn/searchImage/sohu_icon_new.jpg",
      "link": "https://www.sohu.com/a/898137965_323087",
      "media": "Sohu",
      "publish_date": "2025-05-23",
      "refer": "ref_4",
      "title": "AMAC: 1,606 New Private Funds Filed in April, Totaling 643.72 Billion Yuan"
    }
  ]
}
)

```

###
[​](https://docs.z.ai/guides/tools/web-search#mcp-server)
MCP Server
Access the [official MCP documentation](https://modelcontextprotocol.io/introduction) to learn more about the protocol. **Installation Guide**
  * Use clients that support the MCP protocol, such as Cursor and Cherry Studio.
  * Obtain an [API Key](https://z.ai/manage-apikey/apikey-list) from the Z.AI Platform.

**Using in Cursor** Cursor 0.45.6 includes MCP functionality. Cursor acts as an MCP service client and can connect to the MCP service with simple configuration. Navigation Path: Cursor Settings → [Features] → [MCP Servers] ![370b139e 8201 40a0 9c44 3faf4b1b9655 Pn](https://mintcdn.com/zhipu-32152247/fQm1SxNtD2jBDQ3i/images/370b139e-8201-40a0-9c44-3faf4b1b9655.png?fit=max&auto=format&n=fQm1SxNtD2jBDQ3i&q=85&s=ea0a9a85b3c412cfcaf112ce29b66be7) **Configure MCP Server**
Copy
```
{
 "mcpServers": {
  "z.ai-web-search-sse": {
   "url": "https://api.z.ai/api/mcp/web_search/sse?Authorization=YOUR API Key"
  }
 }
}

```

**Cursor MCP Usage** Cursor MCP must be used in Composer’s Agent mode. ![Bb97f60a B887 4e13 92d7 8156227676c7 Pn](https://mintcdn.com/zhipu-32152247/fQm1SxNtD2jBDQ3i/images/bb97f60a-b887-4e13-92d7-8156227676c7.png?fit=max&auto=format&n=fQm1SxNtD2jBDQ3i&q=85&s=03cca96249a7376deb2e3e316f969771)
##
[​](https://docs.z.ai/guides/tools/web-search#web-search-in-chat)
Web Search in Chat
Web Search in Chat allows the Completions API to call search engines, combining real-time web retrieval results with GLM’s generative capabilities to provide up-to-date and verifiable answers.
  * API Docs: [Web Search in Chat](https://docs.z.ai/api-reference/tools/web-search)
  * Example: Financial Analysis Summary


Financial Analysis Summary
Copy
```
from zai import ZaiClient
# Initialize the ZaiClient client
client = ZaiClient(api_key="YourAPIKey")
# Define tool parameters
tools = [{
  "type": "web_search",
  "web_search": {
     "enable": "True",
     "search_engine": "search-prime",
     "search_result": "True",
     "search_prompt": "You are a financial analyst. Please use concise language to summarize the key information in {{search_result}} from the web search, ranked by importance and citing the source date. Today's date is April 11, 2025.",
     "count": "5",
     "search_domain_filter": "www.sohu.com",
     "search_recency_filter": "noLimit",
     "content_size": "high"
  }
}]
# Define user message
messages = [{
  "role": "user",
  "content": "Key financial events, policy changes, and market data in April 2025"
}]
# Call the API to get a response
response = client.chat.completions.create(
  model="glm-4-air", # Model identifier
  messages=messages, # User messages
  tools=tools     # Tool parameters
)
# Print the response result
print(response)

```

Copy
```
{
  "choices": [
    {
      "finish_reason": "stop",
      "index": 0,
      "message": {
        "content": "Based on the documents you provided, here are the important financial events for April 2025, ranked by importance:\n\n1. **G20 Finance and Central Bank Ministers Meeting** - Date to be determined. The G20 meeting will discuss key issues such as global economic recovery, financial stability, and sustainable development. This will have a profound impact on the coordination of global economic policies and financial market sentiment. [Source: ref_1]\n\n2. **Preliminary Manufacturing PMI Releases for Multiple Countries and Regions** - Including France, Germany, the Eurozone, and the UK. These data will reveal the activity status of their respective manufacturing sectors, providing critical insights for investors. [Source: ref_1]\n\n3. **Eurozone Seasonally Adjusted Trade Balance for February** - Released at 17:00. The performance of the trade balance will significantly impact the euro and related markets, reflecting the region's trade conditions. [Source: ref_1]\n\n4. **Speeches by Fed Officials Moussalem and Waller** - At 21:30. Speeches by Fed officials will play a crucial role in driving market volatility and sparking discussions about the future direction of U.S. monetary policy. [Source: ref_1]\n\n5. **U.S. April S&P Global Manufacturing and Services PMI Preliminaries** - Released at 21:45. The PMI data for manufacturing and services will indicate the overall trend of economic activity, influencing investment decisions. [Source: ref_1]\n\n6. **U.S. March New Home Sales Annualized Total** - Released at 22:00. As an important indicator of economic health, new home sales will signal changes in market demand. [Source: ref_1]\n\n7. **U.S. EIA Crude Oil Inventory for the Week Ending April 18** - Released at 22:30. Crude oil inventory data will provide a key reference point for the market, affecting oil price fluctuations. [Source: ref_1]\n\n8. **Fed Releases the Beige Book on Economic Conditions** - At 02:00 the next day. The Fed's Beige Book report will summarize economic development trends, impacting investor confidence and strategies. [Source: ref_1]\n\n9. **Speech by Fed Governor Lisa Cook** - At 07:10. Governor Cook's speech may reflect the Fed's current thinking on the economic situation, influencing market sentiment and asset price fluctuations. [Source: ref_2]\n\n10. **Release of China's Core Economic Data** - Including the monthly report on residential sales prices in 70 large and medium-sized cities, Q1 GDP annual rate, total retail sales of consumer goods, and industrial added value above a designated size. These will have a significant impact on global economic growth and the healthy development of China's economy. [Source: ref_2]\n\n11. **Release of European Economic Data** - Including the UK's March CPI monthly rate, the Eurozone's seasonally adjusted current account for February, and the final annual CPI rate for March. These will provide investors with a comprehensive view of the European economy. [Source: ref_2]\n\n12. **WTO Global Trade Outlook Report** - Released at 20:00. The report may reveal the future direction of global trade and changes among countries. [Source: ref_2]\n\n13. **Release of Key U.S. Economic Indicators** - Including the March retail sales monthly rate, industrial production monthly rate, and NAHB housing market index. These will influence investors' assessment of the strength of the U.S. economic recovery. [Source: ref_2]\n\n14. **Bank of Canada Interest Rate Decision** - Released at 21:45. The direction of Canada's monetary policy is also worth noting. [Source: ref_2]\n\n15. **China's State Council Information Office Releases Q1 Import and Export Data** - Released at 10:00. The growth or decline in import and export data will directly affect GDP growth expectations and investor confidence. [Source: ref_3]\n\n16. **Canada's February Wholesale Sales Monthly Rate Data** - Released at 20:30. Wholesale sales are an important indicator of retail demand expectations, directly reflecting the health of the economy. [Source: ref_3]\n\n17. **U.S. One-Year Inflation Expectations Data for March** - Released at 23:00. This data is a key reference for assessing U.S. consumers' and businesses' views on future economic conditions. [Source: ref_3]\n\n18. **OPEC Monthly Crude Oil Market Report** - Release time to be determined. The report typically influences global crude oil market price trends. [Source: ref_3]\n\n19. **Speeches by Fed Officials** - At 00:00 and 06:00 the next day. Speeches by Fed officials will outline the future direction of Fed policy, affecting global investor expectations. [Source: ref_3]\n\nThe above events and data will have a significant impact on global market trends. Investors should closely monitor them and adjust their strategies accordingly.",
        "role": "assistant"
      }
    }
  ],
  "created": 1748311718,
  "id": "20250527100811da2f8f7243f94b02",
  "model": "glm-4-air",
  "request_id": "20250527100811da2f8f7243f94b02",
  "usage": {
    "completion_tokens": 868,
    "prompt_tokens": 4199,
    "total_tokens": 5067
  },
  "web_search": [
    {
      "content": "In the current volatile global economic climate, April 23, 2025, is set to be a major focus day for the financial world. Several important financial events and economic data will be released, keeping market participants on their toes as they anticipate the upcoming dynamics. Below is an in-depth analysis of the key events and data scheduled for the day to help you gain insights into future market trends.\n1. G20 Finance and Central Bank Ministers Meeting (Time to be determined)\nToday, the G20 has become a crucial platform for global economic governance. Finance and central bank ministers will discuss issues such as economic recovery, financial stability, and sustainable development. This meeting will not only impact the coordination of global economic policies but also have a profound effect on financial market sentiment.\n2. France April Preliminary Manufacturing PMI (15:15)\nAs the economic engine of the Eurozone, the current state of France's manufacturing sector will directly influence the region's recovery. The preliminary data will indicate the fragility or stability of France's economic recovery, providing key insights for investors.\n3. Germany April Preliminary Manufacturing PMI (15:30)\nGermany's manufacturing performance is always closely watched, serving as a barometer of the country's economic health and a significant indicator of the Eurozone's overall economic performance. The preliminary data will offer valuable references for investors to determine future market strategies.\n4. Eurozone April Preliminary Manufacturing PMI (16:00)\nFollowing this, the Eurozone's preliminary manufacturing PMI will also be released. This data is expected to reveal the activity status of the region's manufacturing sector, with markets keenly observing whether the upward trend can be sustained. This will also affect investor confidence in the euro.\n5. UK April Preliminary Manufacturing PMI (16:30)\nAfter facing multiple challenges, the recovery of the UK's manufacturing sector is critical. The preliminary PMI will further clarify whether the UK economy is on a positive trajectory, providing economic context for the upcoming general election.\n6. UK April Preliminary Services PMI (16:30)\nAs a key pillar of the UK's national economy, the services PMI directly impacts overall GDP trends. Changes in this data will offer practical suggestions for the flexibility of economic policies, especially during a period when the UK government faces numerous reform challenges.\n7. Eurozone Seasonally Adjusted Trade Balance for February (17:00)\nThe performance of the trade balance will significantly impact the euro and related markets. The positive or negative figures will directly reflect the region's trade conditions, influencing central bank monetary policies and market liquidity.\n8. Speeches by Fed Officials Moussalem and Waller (21:30)\nSpeeches by Fed officials often play a crucial role in driving market volatility. The remarks by Moussalem and Waller will spark discussions about the future direction of U.S. monetary policy, affecting interest rate decisions and economic guidance.\n9. U.S. April S&P Global Manufacturing PMI Preliminary (21:45)\nKey data on the recovery of U.S. industries is coming. Will the market see strong economic signals that boost global market sentiment? The preliminary manufacturing PMI will be the focal point of both skepticism and anticipation.\n10. U.S. April S&P Global Services PMI Preliminary (21:45)\nThe services PMI reflects the overall trend of economic activity, indicating consumer confidence and spending power. Changes in this value will also provide more guidance for investment decisions.\n11. U.S. March New Home Sales Annualized Total (22:00)\nAs an important indicator of economic health, the changes in new home sales this month may signal shifts in market demand, especially under current fluctuating interest rates.\n12. U.S. EIA Crude Oil Inventory for the Week Ending April 18 (22:30)\nAmid the recovery of global energy demand and geopolitical uncertainties, crude oil inventory data will provide a key reference point for the market, influencing oil price fluctuations.\n13. Fed Releases the Beige Book on Economic Conditions (02:00 the next day)\nThe Fed's Beige Book report will summarize economic development trends, often sparking widespread market discussions and trading volatility upon release. Whether this report brings new economic insights will directly affect investor confidence and strategies.\nSummary\nIn summary, the financial events and economic data on April 23, 2025, will profoundly impact global market trends, potentially offering rare opportunities and warnings for investors. Whether you are a policy analyst or a market participant, it is essential to closely monitor these key events and data, adjusting strategies promptly to seize market opportunities. Return to Sohu for more.",
      "icon": "https://sfile.chatglm.cn/searchImage/www_sohu_com_icon_new.jpg",
      "link": "https://www.sohu.com/a/887836650_121956424",
      "media": "Sohu",
      "publish_date": "",
      "refer": "ref_1",
      "title": "April 23 Financial Highlights: Analyzing Major Global Market Events and New Data Trends (Published: 2025-04-23 07:07:00)"
    },
    {
      "content": "In the current ever-changing global economy, the impact of financial events on the market cannot be ignored. April 16, 2025, will witness a series of highly anticipated financial activities and important data releases, forming a focal point for investors and stirring the nerves of international markets.\n1. Market Volatility and Investor Expectations\nRecently, global markets have faced numerous uncertainties, particularly regarding inflation, interest rate policies, and the winding path of economic recovery, all of which have immersed investors in a sea of analysis and predictions.\nOn April 16, the U.S., Europe, China, and other regions will release a series of heavyweight economic data, which investors eagerly anticipate. These data may provide crucial clues for future market trends. Just as every fluctuation in the stock market is a process of information transmission, only by deeply understanding this information can one make more effective investment decisions.\n2. Prelude to Key Data\n1. Important Fed Speeches\nAt 07:10, Fed Governor Lisa Cook's speech will undoubtedly attract market attention. As a member of the Fed, her views and remarks may reflect the Fed's current thinking on the economic situation. If she mentions the outlook on interest rates or views on economic recovery, this will directly impact market sentiment and the price fluctuations of various asset classes, becoming a key factor influencing the opening of the New York market.\n2. Release of China's Core Economic Data\nFollowing this, at 09:30, China will release the monthly report on residential sales prices in 70 large and medium-sized cities, outlining the current state of China's real estate market. At 10:00, a series of heavyweight economic data will be released, including Q1 GDP annual rate, total retail sales of consumer goods, and industrial added value above a designated size. The release of these data will have a significant impact on global economic growth and the healthy development of China's economy, especially against the backdrop of complex and changing international economics. Analyzing these data will provide a profound understanding of the direction of China's market.\n3. Importance of European Data\nAt 14:00, the release of the UK's March CPI monthly rate will reveal the current inflationary pressures in the UK economy. At 16:00, the Eurozone's seasonally adjusted current account for February and the final annual CPI rate for March will be released, offering investors a more comprehensive view of the European economy. In recent years, the policies of the European Central Bank have also garnered widespread market attention, and changes in inflation trends may influence future monetary policy directions.\n3. Global Trade Outlook from a Global Perspective\nAt 20:00, the World Trade Organization (WTO) will release its Global Trade Outlook Report. Faced with geopolitical risks and challenges to global supply chains, the WTO report may reveal the future direction of global trade and changes among countries. If the trends mentioned in the report diverge from investor expectations, it is bound to trigger strong market fluctuations.\n4. Release of Key U.S. Economic Indicators\nNews from the U.S. market is equally unmissable. At 20:30, the U.S. March retail sales monthly rate will be released, followed by the industrial production monthly rate at 21:15 and the NAHB housing market index before 22:00. These will directly influence investors' assessment of the strength of the U.S. economic recovery. These data, reflecting consumption and production activities, are vital indicators of economic health and can guide investors toward future trends.\nAt 22:30, the U.S. EIA crude oil inventory data for the week ending April 11 will reveal the dynamics of the global energy market. As the global economy remains volatile, fluctuations in energy prices will have a profound impact on prices, inflation, and more.\n5. Canadian Household Confidence and Interest Rate Decision\nFinally, at 21:45, the Bank of Canada will announce its interest rate decision. Faced with global economic uncertainties, the direction of Canada's monetary policy is also worth noting.\nSummary and Reflections\nBehind every data release lies profound economic significance. Although the market is full of uncertainties, for investors, in-depth analysis of each event can help build more comprehensive and scientific investment strategies.\nOn the upcoming April 16, paying attention to the changes in these financial events and data will be a shared responsibility for all market participants. We hope everyone can find their footing in this turbulent market, rationally respond to various information, and make wise choices. Return to Sohu for more.",
      "icon": "https://sfile.chatglm.cn/searchImage/www_sohu_com_icon_new.jpg",
      "link": "https://www.sohu.com/a/884753377_122066678",
      "media": "Sohu",
      "publish_date": "",
      "refer": "ref_2",
      "title": "April 16 Financial Events and Economic Data: Focus Points for Global Markets (Published: 2025-04-16 06:32:00)"
    },
    {
      "content": "As the global economic landscape continues to evolve, adjustments in macroeconomic policies and data releases by various countries are having a profound impact on the market. On April 14, 2025, multiple important financial events and data will emerge, which not only relate to the health of national economies but may also trigger chain reactions in global markets. This article provides a detailed analysis of the day's major financial events, offering deep insights for readers.\n1. Introduction to Market Phenomena: The Fluid Changes in the Global Economic Landscape\nIn recent years, the global economic situation has been highly volatile, with financial markets reacting sensitively. The economic data for Q1 2025 is about to be released, and its impact on foreign exchange, stock, and commodity markets cannot be underestimated. Especially amid the mutual influences of major economies like China, the U.S., and Europe, market investors are increasingly focusing on real-time data and changes in economic policies.\n2. State Council Information Office Releases Q1 Import and Export Data\nTime: 10:00\nChina's State Council Information Office will hold a press conference to release Q1 import and export data. This information is not just about numbers but also reveals the close ties between China and the global economic chain. The growth or decline in import and export data will directly affect GDP growth expectations, thereby influencing investor confidence.\nBy analyzing recent trade relations, it is evident that China plays a pivotal role in the global supply chain. Especially in the face of international economic fluctuations, China's import and export situation will serve as a market barometer, closely linked to trends in international commodity prices and the foreign exchange market. Achieving strong import and export performance will not only boost market confidence but also inject more vitality into domestic economic development.\n3. Canadian Wholesale Sales Data and Economic Analysis\nTime: 20:30\nOn the same day, Canada will release its February wholesale sales monthly rate data. Wholesale sales are an important indicator of retail demand expectations, directly reflecting the health of the economy.\nAnalysts point out that if the data shows strong sales growth, it may indicate a recovery in Canadian consumer confidence, while the opposite would suggest potential economic risks. Particularly during a rate hike cycle, changes in consumer spending will be especially important, influencing the Bank of Canada's monetary policy decisions and, to some extent, global market liquidity.\n4. Importance of U.S. Inflation Expectations\nTime: 23:00\nNext, the New York Fed will release the one-year inflation expectations data for March. This data is a key reference for assessing U.S. consumers' and businesses' views on future economic conditions.\nCurrently, the Fed is at a crossroads in addressing high inflation and reducing interest rate pressures. Rising inflation expectations may signal the need for further rate hikes, affecting capital market pricing. Conversely, if inflation shows signs of easing, it would indicate that policies are taking effect, potentially boosting market risk appetite.\n5. OPEC Crude Oil Market Report: A Barometer for Energy Prices\nTime: To be determined\nAround the same time, OPEC will release its monthly crude oil market report. This report typically influences global crude oil price trends.\n·\nExpand full text\nIn 2025, global energy agencies are generally facing the dual challenges of balancing market supply and demand with emission reduction policies. As global warming issues intensify, the balance between new energy development and traditional energy consumption in various countries will become increasingly important. Especially for countries reliant on oil and gas resources, this report will be a key reference for observing market adjustments.\n6. Views from Fed Officials: A Critical Moment for Market Interpretation\nTime: 00:00 and 06:00 the next day\nFed officials will deliver speeches on navigating economic uncertainties and sharing the Fed's role. These speeches will not only outline the future direction of Fed policy but also cast a shadow over economic uncertainties.\nThe market's focus on the Fed will influence global investor expectations, especially under the current intertwined scenarios of high inflation and high interest rates. Investors need to closely monitor the Fed's stance, which will not only affect the dollar's trajectory but also directly relate to the stability of commodity markets and the global financial system.\nConclusion: Financial Signals Investors Cannot Ignore\nIn summary, the major financial events and economic data on April 14, 2025, herald new changes in the global economy, warranting close attention from investors. On this day, the release of economic data and policy interpretations will intertwine, forming a barometer for market trends.\nWhile the global economy remains uncertain, investors must stay vigilant, monitor real-time information changes, and respond promptly. At the same time, diversifying investments and controlling risks will be wise choices to cope with market fluctuations. How to find stable investment opportunities in a changing economic environment is a crucial question every investor must consider.\nFinally, we hope that under the impetus of these financial events and data, a clearer and more stable development environment can emerge. Let us stay tuned and seize every possible opportunity. Return to Sohu for more.",
      "icon": "https://sfile.chatglm.cn/searchImage/www_sohu_com_icon_new.jpg",
      "link": "https://www.sohu.com/a/883713425_122066678",
      "media": "Sohu",
      "publish_date": "",
      "refer": "ref_3",
      "title": "Global Financial Hotspots: Key Events and Data Analysis Not to Be Missed on April 14 (Published: 2025-04-14 07:25:00)"
    },
    {
      "content": "As 2024 approaches, the winds of change in financial markets will continue to shape the global economic landscape. In this upcoming new year, we need to closely monitor several key events that will influence financial developments in 2025. This concerns not only investors but also every individual who cares about their financial future. This article presents the financial calendar for 2025, covering key events, policy changes, and investment opportunities in major global economies, helping you navigate your financial direction.\n1. Introduction: Where is the Future of Financial Markets?\nFinancial markets are a barometer of economic operations, with national fiscal policies, monetary policies, trade wars, and economic growth directly influencing market trends. In 2025, the economic situations in the U.S., China, and Europe will be the focus of many investors. Against the backdrop of globalization, the relationships between these regions have become particularly complex. Let’s start with the key financial events of 2025.\n2. Key Events in the 2025 Financial Calendar\nChina's Two Sessions (March)\nThe annual National People's Congress and the Chinese People's Political Consultative Conference are important indicators of China's economic policies. The 2025 Two Sessions will discuss new national economic strategies and policies. This is a critical time for investors to watch, as new policy directions will directly affect investment opportunities in the Chinese market.\nFed Interest Rate Decision Meetings (Quarterly)\nThe Fed's interest rate decisions impact not only the U.S. but also cause ripples in the global economy. In 2025, the Fed's monetary policy may undergo significant changes, and investors need to stay alert to how interest rate changes affect capital flows and stock markets.\nEuropean Central Bank Policy Meetings (Quarterly)\nAs another major economy, Europe's policy direction will directly influence global markets. The ECB may adopt tightening or easing policies during the year, and investors should monitor its relationship with inflation and economic growth.\nGlobal Climate Summit (November)\nAs climate change issues become increasingly severe, the international community has recognized the importance of environmental policies for economic growth. The 2025 Climate Summit will discuss global emission reduction targets and their impact on national economies, offering opportunities for sustainable investments.\nG20 Summit (October)\nLeaders from various countries will gather to discuss global economic and trade cooperation issues. The G20 Summit is not only a platform for policy dialogue but also a key signal for investments among economies. New cooperation frameworks and economic policies may be introduced during the summit.\nChina's Two Sessions (March)\nThe annual National People's Congress and the Chinese People's Political Consultative Conference are important indicators of China's economic policies. The 2025 Two Sessions will discuss new national economic strategies and policies. This is a critical time for investors to watch, as new policy directions will directly affect investment opportunities in the Chinese market.\nFed Interest Rate Decision Meetings (Quarterly)\nThe Fed's interest rate decisions impact not only the U.S. but also cause ripples in the global economy. In 2025, the Fed's monetary policy may undergo significant changes, and investors need to stay alert to how interest rate changes affect capital flows and stock markets.\n·\nExpand full text\nEuropean Central Bank Policy Meetings (Quarterly)\nAs another major economy, Europe's policy direction will directly influence global markets. The ECB may adopt tightening or easing policies during the year, and investors should monitor its relationship with inflation and economic growth.\nGlobal Climate Summit (November)\nAs climate change issues become increasingly severe, the international community has recognized the importance of environmental policies for economic growth. The 2025 Climate Summit will discuss global emission reduction targets and their impact on national economies, offering opportunities for sustainable investments.\nG20 Summit (October)\nLeaders from various countries will gather to discuss global economic and trade cooperation issues. The G20 Summit is not only a platform for policy dialogue but also a key signal for investments among economies. New cooperation frameworks and economic policies may be introduced during the summit.\nIn 2025, we need to conduct in-depth analysis of policy trends in various countries to assess their impact on the market.\nChina\nIn 2025, China is expected to further promote \"digital economy\" and \"green economy\" policies, thereby boosting the development of technology and environmental industries. Investors can seek to increase investments in these areas.\nUnited States\nThe Fed may continue to raise interest rates while seeking a moderate inflation target, potentially causing short-term stock market volatility. In the long run, the technology and healthcare sectors will continue to receive strong support, making them suitable for investor focus.\nEuropean Union\nFacing ongoing economic growth pressures, the ECB may adopt moderately accommodative policies, with manufacturing and services sectors receiving more support, making them suitable for related investments.\nChina\nIn 2025, China is expected to further promote \"digital economy\" and \"green economy\" policies, thereby boosting the development of technology and environmental industries. Investors can seek to increase investments in these areas.\nUnited States\nThe Fed may continue to raise interest rates while seeking a moderate inflation target, potentially causing short-term stock market volatility. In the long run, the technology and healthcare sectors will continue to receive strong support, making them suitable for investor focus.\nEuropean Union\nFacing ongoing economic growth pressures, the ECB may adopt moderately accommodative policies, with manufacturing and services sectors receiving more support, making them suitable for related investments.\nIn 2025, investors will still face opportunities and challenges. Identifying potential investment opportunities is crucial, and we can start from the following aspects:\nTechnology Industry\nAreas such as artificial intelligence, blockchain, and new energy will remain hot. It is recommended to focus on related companies and investment funds.\nGreen Investments\nIn response to climate change, countries are injecting more capital into renewable energy. Investors should consider companies related to green energy to capture investment opportunities.\nConsumer Market\nWith the expansion of the middle class, the consumer market will continue to grow, especially in China, where household consumption will become a key driver of economic growth.\nTechnology Industry\nAreas such as artificial intelligence, blockchain, and new energy will remain hot. It is recommended to focus on related companies and investment funds.\nGreen Investments\nIn response to climate change, countries are injecting more capital into renewable energy. Investors should consider companies related to green energy to capture investment opportunities.\nConsumer Market\nWith the expansion of the middle class, the consumer market will continue to grow, especially in China, where household consumption will become a key driver of economic growth.\nHowever, investors must also be wary of potential risks, including policy risks and market volatility. Thorough research before investing is essential.\n5. Summary and Expectations\nLooking ahead to 2025, the global economy still faces many uncertainties, but opportunities and challenges coexist. As investors, we must continuously learn and adapt to new situations, track global economic dynamics, and adjust our investment portfolios accordingly. We hope this 2025 financial calendar provides valuable insights, and we look forward to a promising future.\nIn the coming year, we remind everyone to stay alert, keep up with financial news, especially policy changes, international relations, and market trends. We hope every reader can find suitable investment opportunities in 2025 and reap abundant rewards!\nReturn to Sohu for more.",
      "icon": "https://sfile.chatglm.cn/searchImage/www_sohu_com_icon_new.jpg",
      "link": "https://www.sohu.com/a/844117122_122066678",
      "media": "Sohu",
      "publish_date": "",
      "refer": "ref_4",
      "title": "2025 Financial Calendar: Major Financial Events and Investment Opportunities Not to Be Missed (Published: 2025-01-01 10:37:00)"
    },
    {
      "content": "April 16, 2025, will be an important financial day, with investors needing to closely monitor a series of key economic indicators and events. First, at 07:10, Fed Governor Lisa Cook will deliver a speech, expected to provide guidance on future monetary policy directions.\nIn the morning, China will release multiple heavyweight economic data. At 09:30, the monthly report on residential sales prices in 70 large and medium-sized cities will be released, revealing trends in the real estate market. At 10:00, China's Q1 GDP annual rate, March total retail sales of consumer goods, and industrial added value above a designated size will be released, once again drawing market attention to the strength of economic recovery.\nIn the afternoon, the UK will release its March Consumer Price Index (CPI) monthly rate at 14:00, an indicator that will influence market views on inflation and central bank decisions. Following this, at 16:00, the Eurozone's seasonally adjusted current account and the final annual CPI rate for March will also be released, further affecting assessments of the Eurozone's economic situation.\nIn the evening, the World Trade Organization will release its global trade outlook report at 20:00. Subsequently, at 20:30, the U.S. March retail sales monthly rate and at 21:15 the industrial production monthly rate will be released, drawing high market attention to the health of the U.S. economy.\nAt 21:45, the Bank of Canada will announce its latest interest rate decision, with investors closely watching its impact on future monetary policy. Finally, at 22:00, the U.S. April NAHB housing market index will debut, along with the release of the U.S. February business inventory monthly rate data, providing investors with a more comprehensive market understanding.\nAt 22:30, the U.S. EIA crude oil inventory data for the week ending April 11 will be released, potentially significantly impacting oil prices and related market sentiment. Overall, April 16 will be a busy day for financial activities, holding great importance for market analysis and decision-making. Return to Sohu for more.",
      "icon": "https://sfile.chatglm.cn/searchImage/www_sohu_com_icon_new.jpg",
      "link": "https://www.sohu.com/a/884753440_122006510",
      "media": "Sohu",
      "publish_date": "",
      "refer": "ref_5",
      "title": "April 16 Financial Focus: Overview of Global Economic Data and Monetary Policy Decisions (Published: 2025-04-16 06:32:00)"
    }
  ]
}

```

Was this page helpful?
YesNo
[Structured Output](https://docs.z.ai/guides/capabilities/struct-output)[Stream Tool Call](https://docs.z.ai/guides/tools/stream-tool)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
![370b139e 8201 40a0 9c44 3faf4b1b9655 Pn](https://mintcdn.com/zhipu-32152247/fQm1SxNtD2jBDQ3i/images/370b139e-8201-40a0-9c44-3faf4b1b9655.png?w=560&fit=max&auto=format&n=fQm1SxNtD2jBDQ3i&q=85&s=e26dfd38373cf254d18bb1e95275ce59)
![Bb97f60a B887 4e13 92d7 8156227676c7 Pn](https://mintcdn.com/zhipu-32152247/fQm1SxNtD2jBDQ3i/images/bb97f60a-b887-4e13-92d7-8156227676c7.png?w=560&fit=max&auto=format&n=fQm1SxNtD2jBDQ3i&q=85&s=673b5874302dbdd01ab405c607fac73d)
