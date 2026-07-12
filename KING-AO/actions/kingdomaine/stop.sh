#!/bin/bash

CONFIG="$ROOT/config/kingdomaine.conf"
NAME=$(grep NAME $CONFIG | cut -d '=' -f2)

echo "🛑 Arrêt du module KINGDOMAINE : $NAME"

docker stop "$NAME" 2>/dev/null
docker rm "$NAME" 2>/dev/null

echo "✅ Module KINGDOMAINE arrêté."
