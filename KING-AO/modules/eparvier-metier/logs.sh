#!/bin/bash

CONFIG="$ROOT/config/metier.conf"
NAME=$(grep NAME $CONFIG | cut -d '=' -f2)

echo "📜 Logs du module METIER : $NAME"
docker logs "$NAME" --tail 200
