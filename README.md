# AI_Agent_For_Data_Extraction
n8n workflow with Dockerfile for auto deployment

## Configuration:

The Environment Variables must be configured prior any execution

### Environment Variables

|     Variable         |             Description             | Required |
|----------------------|-------------------------------------|----------|
| `WEBHOOK_URL`        | URL to consume the webhook          |    Yes   |
| `JWT_AUTH_URL`       | API Endpoint to check JWT           |    Yes   |
| `AI_CREDENTIALS`     | URL to make requests                |    Yes   |
| `AI_TOKEN`           | Bearer Token to authorize the usage |    Yes   |
| `AI_MODEL`           | Example: "Llama-4, Gemini-2.0"      |    Yes   |
| `N8N_ENCRYPTION_KEY` | To encrypt values inside n8n        |    No    |

##### WEBHOOK_URL

Must have in mind the field 'webhook' inside the workflow `JSON` file, and must be written and consumed in this format: `https://{WEBHOOK_URL}/webhook/{webhookId}`

## Deployment:

#### Build

##### Build Image
```
sudo docker build --no-cache -t extract_agent:latest .
```

#### Execute

##### Run Interactive
```
sudo docker run -it --rm -p 5678:5678 --env-file Env/.env extract_agent:latest
```

##### Run on Background
```
sudo docker run -d --name extract_agent --env-file Env/.env -p 5678:5678 --restart unless-stopped extract_agent:latest
```

## Note:

This same Dockerfile can be used with more than one Workflow with minimal changes.