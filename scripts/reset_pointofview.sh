#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="/opt/eshop_fiuni"
COMPOSE_FILE="docker-compose.prod.yml"
VOLUME_NAME="web_mysqldata_prod"

cd "$PROJECT_DIR"

echo "[$(date)] Deteniendo stack..."
docker compose -f "$COMPOSE_FILE" down

echo "[$(date)] Eliminando volumen de datos: $VOLUME_NAME"
docker volume rm "$VOLUME_NAME" || echo "Volumen $VOLUME_NAME no existe, continuando..."

echo "[$(date)] Actualizando código desde git..."
git pull --rebase || echo "git pull falló, revisa manualmente."

echo "[$(date)] Levantando stack limpio..."
docker compose -f "$COMPOSE_FILE" up -d --build

echo "[$(date)] Reset completado."