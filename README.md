# AI_Agent_For_Data_Extraction
n8n workflow with Dockerfile for auto deployment

## Configuration:

The Environment Variables must be configured prior any execution

### Environment Variables

|     Variable     |             Description             | Required |
|------------------|-------------------------------------|----------|
| `JWT_AUTH_URL`   | API Endpoint to check JWT           |    Yes   |
| `AI_CREDENTIALS` | URL to make requests                |    Yes   |
| `AI_TOKEN`       | Bearer Token to authorize the usage |    Yes   |
| `AI_MODEL`       | Example: "Llama-4, Gemini-2.0"      |    Yes   |


### Deployment

#### Build

```
sudo docker build --no-cache -t extract_agent:latest .
```

#### Execute
```
sudo docker run -it --rm -p 5678:5678 extract_agent:latest
```