#!/bin/bash

cd /opt/KING-AO/modules/EPARVIER/docker

echo "🚀 Lancement EPARVIER PRO..."
docker compose down
docker compose up -d

echo ""
/opt/KING-AO/modules/EPARVIER/scripts/check-epavier.sh
#!/bin/bash

echo "🛫 EPARVIER — Pré‑vol"
/opt/KING-AO/modules/EPARVIER/scripts/check-epavier.sh

echo "🚀 EPARVIER — Lancement cockpitifié"
/usr/bin/docker compose -f /opt/KING-AO/modules/EPARVIER/docker/docker-compose.yml up -d
#!/bin/bash
echo "🚀 EPARVIER : lancement cockpitifié"
docker compose -f /opt/KING-AO/modules/EPARVIER/docker/docker-compose.yml up -d
