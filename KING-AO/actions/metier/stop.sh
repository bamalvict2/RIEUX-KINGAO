#!/bin/bash

echo "[KING-AO] Arrêt METIER (EPARVIER)..."

docker compose -f /opt/KING-AO/modules/EPARVIER/docker-compose-eparvier-api.yml down
docker compose -f /opt/KING-AO/modules/EPARVIER/docker-compose-eparvier-cockpit.yml down

echo "[KING-AO] METIER arrêté."
