#!/bin/bash

echo "🛫 EPARVIER PRO — Pré‑vol"
bash /opt/KING-AO/modules/KINGDOMAINE/eparvierPro/check.sh

echo "🌐 EPARVIER PRO — Lancement cockpitifié"
/usr/bin/docker compose -f /opt/KING-AO/modules/KINGDOMAINE/eparvierPro/docker-compose.yml up -d

echo "✔ EPARVIER PRO lancé."
