#!/bin/sh

# 1. Iniciar n8n en segundo plano
n8n start &

# 2. Esperar a que el servidor web responda (Healthcheck)
echo "Esperando a que n8n despierte..."
until $(curl -s -f http://localhost:5678/healthz > /dev/null); do
    sleep 2
done

# 3. Pequeña pausa extra para asegurar que SQLite soltó el candado tras las migraciones
sleep 5

echo "n8n está listo. Importando workflow..."

# Intentamos importar con un bucle de reintento por si SQLite sigue ocupado
MAX_RETRIES=5
for i in $(seq 1 $MAX_RETRIES); do
    n8n import:workflow --input=/home/node/workflows/Agent_Workflow.json && break
    echo "Base de datos ocupada (intento $i/$MAX_RETRIES), reintentando en 3s..."
    sleep 3
done

echo "Activando flujos..."
# n8n ahora prefiere 'publish' o marcar como activo en el import, 
# pero esto asegura que los webhooks se registren.
n8n update:workflow --all --active=true || true

echo "Proceso completado. n8n está listo para recibir peticiones."
wait