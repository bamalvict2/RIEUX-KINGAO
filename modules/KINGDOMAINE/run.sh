#!/bin/bash

echo "🛫 KINGDOMAINE — Pré‑vol (check monitoring)"
/opt/KING-AO/modules/KINGDOMAINE/scripts/check-monitoring.sh

echo "🌐 KINGDOMAINE — Lancement cockpitifié"
/usr/bin/docker compose -f /opt/KING-AO/modules/KINGDOMAINE/docker/docker-compose.yml up -d
#!/bin/bash
echo "🌐 KINGDOMAINE : lancement cockpitifié"
docker compose -f /opt/KING-AO/modules/KINGDOMAINE/docker/docker-compose.yml up -d
