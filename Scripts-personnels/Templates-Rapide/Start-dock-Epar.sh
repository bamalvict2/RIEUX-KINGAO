#!/bin/bash
echo "🔧 [EPARVIER] Arrêt des services..."
docker compose down

echo "🚀 [EPARVIER] Démarrage des services..."
docker compose up -d

echo "📡 [EPARVIER] Services actifs :"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

curl -I http://localhost:5010/health

