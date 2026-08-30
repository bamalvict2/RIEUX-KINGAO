#!/bin/bash
echo "🔧 KINGDOMAINE — rebuild"

cd /opt/KING-AO/modules/KINGDOMAINE/KINGDomaineApi
./build.sh

cd /opt/KING-AO/modules/KINGDOMAINE/KINGDomaineCockpit
./build.sh

echo "♻️ Restart compose"
docker compose -f /opt/KING-AO/modules/KINGDOMAINE/docker/docker-compose-kingdomaine-api.yml up -d
docker compose -f /opt/KING-AO/modules/KINGDOMAINE/docker/docker-compose-kingdomaine-cockpit.yml up -d
