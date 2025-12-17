# Dockerfile N8N
FROM n8nio/n8n:latest

# Set working directory
USER root
WORKDIR /home/node/

# 1. Copy Workflow JSON
COPY Agent_Workflow.json /home/node/Agent_Workflow.json

# 2. Copy .env in the workdirectory
COPY ./Env/.env /home/node/.env 

# 3. Grant permissions
RUN chown node:node /home/node/Agent_Workflow.json
RUN chown node:node /home/node/.env

# Change the user for the container
USER node

# Allow ENV variables
ENV N8N_BLOCK_ENV_ACCESS_IN_NODE=false

# Stablish the N8N port
EXPOSE 5678

# Set up and start the workflow
ENTRYPOINT ["sh", "-c", "set -a; . /home/node/.env; set +a; n8n import:workflow --file /home/node/Agent_Workflow.json && n8n start"]
