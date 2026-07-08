#!/bin/bash

CONFIG="$ROOT/config/kingdomaine.conf"
NAME=$(grep NAME $CONFIG | cut -d '=' -f2)

echo "📡 Status du module KINGDOMAINE : $NAME"
docker ps | grep "$NAME"
