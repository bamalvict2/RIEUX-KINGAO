#!/bin/bash
echo "🚀 KINGDOMAINE — start"

docker compose -f /opt/KING-AO/modules/KINGDOMAINE/docker/docker-compose-kingdomaine-api.yml up -d
docker compose -f /opt/KING-AO/modules/KINGDOMAINE/docker/docker-compose-kingdomaine-cockpit.yml up -d
