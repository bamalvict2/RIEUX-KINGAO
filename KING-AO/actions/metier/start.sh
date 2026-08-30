#!/bin/bash

echo "[KING-AO] Démarrage METIER (EPARVIER)..."

# API
docker compose -f /opt/KING-AO/modules/EPARVIER/docker-compose-eparvier-api.yml down
docker compose -f /opt/KING-AO/modules/EPARVIER/docker-compose-eparvier-api.yml up -d

# Cockpit
docker compose -f /opt/KING-AO/modules/EPARVIER/docker-compose-eparvier-cockpit.yml down
docker compose -f /opt/KING-AO/modules/EPARVIER/docker-compose-eparvier-cockpit.yml up -d

echo "[KING-AO] METIER (EPARVIER) démarré."
