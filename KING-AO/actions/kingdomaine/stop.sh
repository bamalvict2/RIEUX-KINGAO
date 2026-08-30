#!/bin/bash
echo "🛑 KINGDOMAINE — stop"

docker compose -f /opt/KING-AO/modules/KINGDOMAINE/docker/docker-compose-kingdomaine-api.yml down
docker compose -f /opt/KING-AO/modules/KINGDOMAINE/docker/docker-compose-kingdomaine-cockpit.yml down
