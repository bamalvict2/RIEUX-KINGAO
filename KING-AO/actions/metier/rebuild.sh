#!/bin/bash

echo "[KING-AO] Rebuild METIER (EPARVIER)..."

# Build API
/opt/KING-AO/modules/EPARVIER/SolaizeApi/build.sh

# Build Cockpit
/opt/KING-AO/modules/EPARVIER/SolaizeCockpit/build.sh

# Restart METIER
./start.sh

echo "[KING-AO] METIER (EPARVIER) reconstruit et relancé."
