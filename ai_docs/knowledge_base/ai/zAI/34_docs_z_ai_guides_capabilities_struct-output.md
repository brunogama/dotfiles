# https://docs.z.ai/guides/capabilities/struct-output

Source: [https://docs.z.ai/guides/capabilities/struct-output](https://docs.z.ai/guides/capabilities/struct-output)

---

[Skip to main content](https://docs.z.ai/guides/capabilities/struct-output#content-area)
🚀 **GLM Coding Plan — built for devs: 3× usage, 1/7 cost** • [Limited-Time Offer ➞](https://z.ai/subscribe?utm_campaign=Platform_Ops&_channel_track_key=DaprgHIc)
[Z.AI DEVELOPER DOCUMENT home page![light logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/dark.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=75deefa9dea5bdbc84d4da68885c267f)![dark logo](https://mintcdn.com/zhipu-32152247/B_E8wI-eiNa1QlPV/logo/light.svg?fit=max&auto=format&n=B_E8wI-eiNa1QlPV&q=85&s=c1ecf1af358fa8eeab8c06052337f8f6)](https://z.ai/model-api)
English
Search...
⌘K
  * [API Keys](https://z.ai/manage-apikey/apikey-list)
  * [Payment Method](https://z.ai/manage-apikey/billing)


Search...
Navigation
Capabilities
Structured Output
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
  * [Features](https://docs.z.ai/guides/capabilities/struct-output#features)
  * [Core Parameters](https://docs.z.ai/guides/capabilities/struct-output#core-parameters)
  * [Code Examples](https://docs.z.ai/guides/capabilities/struct-output#code-examples)
  * [Basic Usage](https://docs.z.ai/guides/capabilities/struct-output#basic-usage)
  * [Scenario Examples](https://docs.z.ai/guides/capabilities/struct-output#scenario-examples)
  * [Best Practices](https://docs.z.ai/guides/capabilities/struct-output#best-practices)


Capabilities
# Structured Output
Copy page
Copy page
Structured output (JSON mode) ensures that AI returns JSON data conforming to predefined formats, providing reliable guarantees for programmatic processing of AI outputs.
## 
[​](https://docs.z.ai/guides/capabilities/struct-output#features)
Features
The structured output feature provides AI models with strict data format control capabilities, supporting various complex data structures and validation requirements.
### 
[​](https://docs.z.ai/guides/capabilities/struct-output#core-parameters)
Core Parameters
  * **`response_format`**: Specifies the response format, set to`{"type": "json_object"}` to enable JSON mode
  * **`model`**: Use models that support structured output, such as`glm-4.5` , `glm-4.6`, etc.
  * **`messages`**: Define the expected JSON structure and field requirements in system messages


## 
[​](https://docs.z.ai/guides/capabilities/struct-output#code-examples)
Code Examples
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

**Complete Example** The following is a complete structured output example demonstrating how to perform sentiment analysis and return structured JSON results:
Copy
```
from zai import ZaiClient
import json
# Initialize client
client = ZaiClient(api_key="your-api-key")
# Basic JSON mode
response = client.chat.completions.create(
  model="glm-4-plus",
  messages=[
    {
      "role": "system",
      "content": """
      You are a sentiment analysis expert. Please return analysis results in the following JSON format:
      {
        "sentiment": "positive/negative/neutral",
        "confidence": 0.95,
        "emotions": ["joy", "excitement"],
        "keywords": ["weather", "mood"],
        "analysis": "Detailed analysis explanation"
      }
      """
    },
    {
      "role": "user",
      "content": "Please analyze the sentiment of this sentence: 'The weather is really nice today, I'm feeling very happy!'"
    }
  ],
  response_format={
    "type": "json_object"
  }
)
# Parse results
result = json.loads(response.choices[0].message.content)
print(f"Sentiment: {result['sentiment']}")
print(f"Confidence: {result['confidence']}")
print(f"Emotions: {result['emotions']}")

```

## 
[​](https://docs.z.ai/guides/capabilities/struct-output#basic-usage)
Basic Usage
  * Simple JSON Output
  * Specify JSON Structure
  * Schema Validation


**Simple JSON Output**
Copy
```
from zai import ZaiClient
client = ZaiClient(api_key="your-api-key")
# Basic JSON mode
response = client.chat.completions.create(
  model="glm-4-plus",
  messages=[
    {
      "role": "user",
      "content": "Please analyze the sentiment of this sentence: 'The weather is really nice today, I'm feeling very happy!'"
    }
  ],
  response_format={
    "type": "json_object"
  }
)
import json
result = json.loads(response.choices[0].message.content)
print(result)

```

## 
[​](https://docs.z.ai/guides/capabilities/struct-output#scenario-examples)
Scenario Examples
When using JSON mode for data extraction, please ensure the quality and format of input data to achieve the best extraction results.
Data Extraction and Structuring Complete Implementation
Copy
```
class DataExtractor:
  def __init__(self, api_key):
    self.client = ZaiClient(api_key=api_key)
  def extract_contact_info(self, text):
    """Extract contact information"""
    schema = {
      "type": "object",
      "properties": {
        "contacts": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "name": {"type": "string"},
              "phone": {"type": "string"},
              "email": {"type": "string"},
              "company": {"type": "string"},
              "position": {"type": "string"},
              "address": {"type": "string"}
            },
            "required": ["name"]
          }
        },
        "total_count": {"type": "integer"},
        "extraction_confidence": {"type": "number"}
      },
      "required": ["contacts", "total_count"]
    }
    response = self.client.chat.completions.create(
      model="glm-4-plus",
      messages=[
        {
          "role": "system",
          "content": f"""
          You are an information extraction expert. Please extract all contact information from the text,
          return in the following JSON format:
          {json.dumps(schema, indent=2, ensure_ascii=False)}
          Note:
          - If a field has no information, do not include that field
          - phone field should be in standardized phone number format
          - email field should be a valid email address
          - extraction_confidence represents overall extraction confidence (0-1)
          """
        },
        {
          "role": "user",
          "content": f"Please extract contact information from the following text:\n\n{text}"
        }
      ],
      response_format={"type": "json_object"}
    )
    try:
      result = json.loads(response.choices[0].message.content)["properties"]
      validate(instance=result, schema=schema)
      return result
    except Exception as e:
      print(f"Extraction failed: {e}")
      return None
  def extract_product_info(self, product_description):
    """Extract product information"""
    schema = {
      "type": "object",
      "properties": {
        "product_name": {"type": "string"},
        "brand": {"type": "string"},
        "category": {"type": "string"},
        "price": {
          "type": "object",
          "properties": {
            "amount": {"type": "number"},
            "currency": {"type": "string"},
            "original_price": {"type": "number"},
            "discount": {"type": "number"}
          }
        },
        "specifications": {
          "type": "object",
          "additionalProperties": True
        },
        "features": {
          "type": "array",
          "items": {"type": "string"}
        },
        "availability": {
          "type": "object",
          "properties": {
            "in_stock": {"type": "boolean"},
            "quantity": {"type": "integer"},
            "shipping_time": {"type": "string"}
          }
        },
        "ratings": {
          "type": "object",
          "properties": {
            "average_rating": {"type": "number"},
            "total_reviews": {"type": "integer"}
          }
        }
      },
      "required": ["product_name"]
    }
    response = self.client.chat.completions.create(
      model="glm-4-plus",
      messages=[
        {
          "role": "system",
          "content": f"""
          Please extract structured information from product description, return in the following format:
          {json.dumps(schema, indent=2, ensure_ascii=False)}
          Note:
          - Price information should accurately extract values and currency units
          - specifications should include all technical specifications
          - features should list main functional features
          - Do not guess if information is unclear
          """
        },
        {
          "role": "user",
          "content": f"Product description:\n{product_description}"
        }
      ],
      response_format={"type": "json_object"}
    )
    try:
      result = json.loads(response.choices[0].message.content)
      validate(instance=result, schema=schema)
      return result
    except Exception as e:
      print(f"Product information extraction failed: {e}")
      return None
  def extract_event_info(self, event_text):
    """Extract event information"""
    schema = {
      "type": "object",
      "properties": {
        "events": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "title": {"type": "string"},
              "description": {"type": "string"},
              "start_time": {"type": "string"},
              "end_time": {"type": "string"},
              "location": {"type": "string"},
              "organizer": {"type": "string"},
              "participants": {
                "type": "array",
                "items": {"type": "string"}
              },
              "category": {"type": "string"},
              "priority": {
                "type": "string",
                "enum": ["high", "medium", "low"]
              },
              "status": {
                "type": "string",
                "enum": ["scheduled", "ongoing", "completed", "cancelled"]
              }
            },
            "required": ["title", "start_time"]
          }
        }
      },
      "required": ["events"]
    }
    response = self.client.chat.completions.create(
      model="glm-4-plus",
      messages=[
        {
          "role": "system",
          "content": f"""
          Please extract all event information from the text, return in the following format:
          {json.dumps(schema, indent=2, ensure_ascii=False)}
          Time format requirements:
          - Use ISO 8601 format: YYYY-MM-DDTHH:MM:SS
          - If only date available, use: YYYY-MM-DD
          - If time is unclear, try to infer reasonable time
          """
        },
        {
          "role": "user",
          "content": f"Please extract event information from the following text:\n\n{event_text}"
        }
      ],
      response_format={"type": "json_object"}
    )
    try:
      result = json.loads(response.choices[0].message.content)
      validate(instance=result, schema=schema)
      return result
    except Exception as e:
      print(f"Event information extraction failed: {e}")
      return None
# Usage example
extractor = DataExtractor("your_api_key")
# Extract contact information
contact_text = """
Zhang San, mobile: 13800138000, email: zhangsan@example.com,
works as Technical Director at Beijing Technology Co., Ltd.
Company address: No. 123, Technology Park, Chaoyang District, Beijing.
Li Si, phone: 010-12345678, work email: lisi@company.com,
is a Product Manager at Shanghai Innovation Company.
"""
contacts = extractor.extract_contact_info(contact_text)
if contacts:
  print(f"Extracted {contacts['total_count']} contacts")
  for contact in contacts['contacts']:
    print(f"Name: {contact['name']}")
    if 'phone' in contact:
      print(f"Phone: {contact['phone']}")

```

API Response Formatting Complete Implementation
Copy
```
class APIResponseFormatter:
  def __init__(self, api_key):
    self.client = ZaiClient(api_key=api_key)
  def format_search_results(self, query, raw_results):
    """Format search results"""
    schema = {
      "type": "object",
      "properties": {
        "query": {"type": "string"},
        "total_results": {"type": "integer"},
        "results": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "title": {"type": "string"},
              "url": {"type": "string"},
              "snippet": {"type": "string"},
              "relevance_score": {"type": "number"},
              "source_type": {"type": "string"},
              "publish_date": {"type": "string"},
              "tags": {
                "type": "array",
                "items": {"type": "string"}
              }
            },
            "required": ["title", "url", "snippet"]
          }
        },
        "suggestions": {
          "type": "array",
          "items": {"type": "string"}
        },
        "filters": {
          "type": "object",
          "properties": {
            "date_range": {"type": "string"},
            "source_types": {
              "type": "array",
              "items": {"type": "string"}
            },
            "languages": {
              "type": "array",
              "items": {"type": "string"}
            }
          }
        }
      },
      "required": ["query", "total_results", "results"]
    }
    response = self.client.chat.completions.create(
      model="glm-4-plus",
      messages=[
        {
          "role": "system",
          "content": f"""
          Please format search results into standard JSON format:
          {json.dumps(schema, indent=2, ensure_ascii=False)}
          Requirements:
          - Calculate relevance score for each result (0-1)
          - Identify content type (article, video, image, document, etc.)
          - Extract publish date (if available)
          - Generate relevant tags
          - Provide search suggestions
          """
        },
        {
          "role": "user",
          "content": f"Query: {query}\n\nRaw results:\n{raw_results}"
        }
      ],
      response_format={"type": "json_object"}
    )
    try:
      result = json.loads(response.choices[0].message.content)
      validate(instance=result, schema=schema)
      return result
    except Exception as e:
      print(f"Formatting failed: {e}")
      return None
  def format_analytics_data(self, raw_data, metrics):
    """Format analytics data"""
    schema = {
      "type": "object",
      "properties": {
        "summary": {
          "type": "object",
          "properties": {
            "total_records": {"type": "integer"},
            "date_range": {
              "type": "object",
              "properties": {
                "start_date": {"type": "string"},
                "end_date": {"type": "string"}
              }
            },
            "key_insights": {
              "type": "array",
              "items": {"type": "string"}
            }
          }
        },
        "metrics": {
          "type": "object",
          "additionalProperties": {
            "type": "object",
            "properties": {
              "current_value": {"type": "number"},
              "previous_value": {"type": "number"},
              "change_percentage": {"type": "number"},
              "trend": {
                "type": "string",
                "enum": ["up", "down", "stable"]
              },
              "unit": {"type": "string"}
            }
          }
        },
        "time_series": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "timestamp": {"type": "string"},
              "values": {
                "type": "object",
                "additionalProperties": {"type": "number"}
              }
            }
          }
        },
        "segments": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "name": {"type": "string"},
              "value": {"type": "number"},
              "percentage": {"type": "number"},
              "color": {"type": "string"}
            }
          }
        }
      },
      "required": ["summary", "metrics"]
    }
    response = self.client.chat.completions.create(
      model="glm-4-plus",
      messages=[
        {
          "role": "system",
          "content": f"""
          Please format analytics data into standard format:
          {json.dumps(schema, indent=2, ensure_ascii=False)}
          Focus indicators:{', '.join(metrics)}
          Requirements:
          - Calculate change percentage and trend
          - Provide key insights
          - Time series data sorted by time
          - Segments data contain percentage
          """
        },
        {
          "role": "user",
          "content": f"Raw data: \n{raw_data}"
        }
      ],
      response_format={"type": "json_object"}
    )
    try:
      result = json.loads(response.choices[0].message.content)
      validate(instance=result, schema=schema)
      return result
    except Exception as e:
      print(f"Analytics data formatting failed: {e}")
      return None
# Usage example
formatter = APIResponseFormatter("your_api_key")
# Format search results
raw_search = """
1. Python Programming Tutorial - https://example.com/python-tutorial
  Detailed introduction to Python basic syntax and programming concepts...
2. Python Data Analysis Practice - https://example.com/python-data
  Using pandas and numpy for data processing...
"""
formatted_results = formatter.format_search_results("Python Tutorial", raw_search)
if formatted_results:
  print(f"Found {formatted_results['total_results']} results")
  for result in formatted_results['results']:
    print(f"Title: {result['title']}")
    print(f"Relevance: {result['relevance_score']}")

```

Configuration Management and Validation Complete Implementation
Copy
```
class ConfigurationManager:
  def __init__(self, api_key):
    self.client = ZaiClient(api_key=api_key)
  def parse_config_file(self, config_text, config_type="general"):
    """Parse configuration file"""
    schemas = {
      "database": {
        "type": "object",
        "properties": {
          "connections": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "name": {"type": "string"},
                "host": {"type": "string"},
                "port": {"type": "integer"},
                "database": {"type": "string"},
                "username": {"type": "string"},
                "ssl": {"type": "boolean"},
                "pool_size": {"type": "integer"}
              },
              "required": ["name", "host", "database"]
            }
          },
          "settings": {
            "type": "object",
            "properties": {
              "timeout": {"type": "integer"},
              "retry_attempts": {"type": "integer"},
              "log_level": {
                "type": "string",
                "enum": ["DEBUG", "INFO", "WARNING", "ERROR"]
              }
            }
          }
        },
        "required": ["connections"]
      },
      "api": {
        "type": "object",
        "properties": {
          "endpoints": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "name": {"type": "string"},
                "url": {"type": "string"},
                "method": {
                  "type": "string",
                  "enum": ["GET", "POST", "PUT", "DELETE"]
                },
                "headers": {"type": "object"},
                "timeout": {"type": "integer"},
                "rate_limit": {"type": "integer"}
              },
              "required": ["name", "url", "method"]
            }
          },
          "authentication": {
            "type": "object",
            "properties": {
              "type": {
                "type": "string",
                "enum": ["bearer", "basic", "api_key"]
              },
              "credentials": {"type": "object"}
            }
          }
        },
        "required": ["endpoints"]
      }
    }
    schema = schemas.get(config_type, {
      "type": "object",
      "additionalProperties": True
    })
    response = self.client.chat.completions.create(
      model="glm-4-plus",
      messages=[
        {
          "role": "system",
          "content": f"""
          Please parse the configuration file and convert to JSON format:
          {json.dumps(schema, indent=2, ensure_ascii=False)}
          Configuration type: {config_type}
          Requirements:
          - Identify configuration items and values
          - Convert data types (string, number, boolean)
          - Handle arrays and nested objects
          - Validate required fields
          - Provide default values (if applicable)
          """
        },
        {
          "role": "user",
          "content": f"Configuration file content:\n{config_text}"
        }
      ],
      response_format={"type": "json_object"}
    )
    try:
      result = json.loads(response.choices[0].message.content)
      validate(instance=result, schema=schema)
      return result
    except Exception as e:
      print(f"Configuration parsing failed: {e}")
      return None
  def validate_configuration(self, config_data, validation_rules):
    """Validate configuration"""
    response = self.client.chat.completions.create(
      model="glm-4-plus",
      messages=[
        {
          "role": "system",
          "content": f"""
          Please validate configuration data and return validation results:
          Return format:
          {{
            "is_valid": true/false,
            "errors": [
              {{
                "field": "field_name",
                "error": "error_description",
                "severity": "error/warning/info"
              }}
            ],
            "warnings": [
              {{
                "field": "field_name",
                "message": "warning_message"
              }}
            ],
            "suggestions": [
              "improvement_suggestion_1",
              "improvement_suggestion_2"
            ]
          }}
          Validation rules: {validation_rules}
          """
        },
        {
          "role": "user",
          "content": f"Configuration data:\n{json.dumps(config_data, indent=2, ensure_ascii=False)}"
        }
      ],
      response_format={"type": "json_object"}
    )
    try:
      result = json.loads(response.choices[0].message.content)
      return result
    except Exception as e:
      print(f"Configuration validation failed: {e}")
      return None
# Usage example
config_manager = ConfigurationManager("your_api_key")
# Parse database configuration
db_config_text = """
[database]
host = localhost
port = 5432
database = myapp
username = admin
ssl = true
pool_size = 10
[settings]
timeout = 30
retry_attempts = 3
log_level = INFO
"""
config = config_manager.parse_config_file(db_config_text, "database")
if config:
  print("Parsed configuration:", json.dumps(config, indent=2, ensure_ascii=False))
  # Validate configuration
  validation_rules = [
    "Port number must be in range 1-65535",
    "Database name cannot be empty",
    "Connection pool size should be greater than 0",
    "Timeout should be reasonable (1-300 seconds)"
  ]
  validation_result = config_manager.validate_configuration(config, validation_rules)
  if validation_result:
    print(f"Configuration validity: {validation_result['is_valid']}")
    if validation_result['errors']:
      print("Errors:", validation_result['errors'])
    if validation_result['warnings']:
      print("Warnings:", validation_result['warnings'])

```

## 
[​](https://docs.z.ai/guides/capabilities/struct-output#best-practices)
Best Practices
## Schema Design Principles
  * Clarity: Field names and types should be clear and explicit
  * Completeness: Include all necessary validation rules
  * Flexibility: Consider future expansion needs


## Error Handling Strategy
  * Multi-layer validation: Schema validation + business logic validation
  * Fallback plan: Prepare simplified backup Schema
  * Logging: Record detailed error information


JSON mode requires AI to strictly output according to specified format, but in some complex scenarios it may affect the naturalness of responses. It’s recommended to find a balance between functionality and user experience.
When designing JSON Schema, it’s recommended to start with simple structures and gradually increase complexity. Also, providing detailed descriptions and examples for key fields helps AI better understand and generate JSON data that meets requirements.
Was this page helpful?
YesNo
[Context Caching](https://docs.z.ai/guides/capabilities/cache)[Web Search](https://docs.z.ai/guides/tools/web-search)
⌘I
[x](https://x.com/Zai_org)[github](https://github.com/zai-org)[discord](https://discord.gg/QR7SARHRxK)[linkedin](https://www.linkedin.com/company/zdotai/)
[Powered by Mintlify](https://mintlify.com?utm_campaign=poweredBy&utm_medium=referral&utm_source=zhipu-32152247)
Assistant
Responses are generated using AI and may contain mistakes.
