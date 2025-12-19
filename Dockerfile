# N8N image
FROM docker.n8n.io/n8nio/n8n:1.121.3


# Stablish permissions for the actions
USER root
RUN mkdir -p /home/node/.n8n && chown -R node:node /home/node/.n8n


# Copy the workflow inside the container
##########################################################
COPY ./n8n_workflows/Agent_Workflow.json /data/Agent_Workflow.json
RUN chown node:node /data/Agent_Workflow.json

# === Uncomment if there're more than one workflows ===
# COPY ./n8n_workflows/*.json /data/ 
# RUN chown node:node -R /data 
##########################################################


# Create start script
COPY --chown=node:node <<'EOF' /startup.sh
#!/bin/sh
set -e


# 1) Import Workflows to SQLite
##########################################################
echo "Importing Workflows from /data..."
n8n import:workflow --input=/data/Agent_Workflow.json

# === Uncomment if there're more than one workflows ===
# n8n import:workflow --separate --input=/data 
##########################################################

# 2) Launch all Workflows
echo "Activate all imported Workflows..."
n8n update:workflow --all --active=true

# 3) Launch the original n8n Entrypoint
echo "Starting n8n..."
exec /docker-entrypoint.sh
EOF


# Grant permissions to the script
RUN chmod +x /startup.sh


# N8N environment variables
##################################################
ENV N8N_PROTOCOL=https
ENV N8N_USER_MANAGEMENT_DISABLED=true
ENV N8N_BLOCK_ENV_ACCESS_IN_NODE=false
ENV N8N_BLOCK_FILE_ACCESS_TO_N8N_FILES=false
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false
##################################################


# Change permissions
USER node


# Overwrite the the entrypoint to use thw script
ENTRYPOINT ["/bin/sh", "/startup.sh"]


# === HOW TO RUN === 
# BUILD: sudo docker build --no-cache -t extract_agent:latest .
# RUN :sudo docker run -it --rm -p 5678:5678 --env-file Env/.env extract_agent:latest
