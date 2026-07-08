#!/bin/bash

CONFIG="$ROOT/config/kingdomaine.conf"
NAME=$(grep NAME $CONFIG | cut -d '=' -f2)

echo "📜 Logs du module KINGDOMAINE : $NAME"
docker logs "$NAME" --tail 200
