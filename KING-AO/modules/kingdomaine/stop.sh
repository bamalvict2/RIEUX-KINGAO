#!/bin/bash

CONFIG="$ROOT/config/kingdomaine.conf"
NAME=$(grep NAME $CONFIG | cut -d '=' -f2)

echo "🛑 Arrêt du module KINGDOMAINE : $NAME"
docker stop "$NAME"
docker rm "$NAME"

echo "✔ Module KINGDOMAINE arrêté."
