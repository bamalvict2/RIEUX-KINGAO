#!/bin/bash

CONFIG="$ROOT/config/metier.conf"

NAME=$(grep NAME $CONFIG | cut -d '=' -f2)
IMAGE=$(grep IMAGE $CONFIG | cut -d '=' -f2)
PORT=$(grep PORT $CONFIG | cut -d '=' -f2)

echo "🚀 Démarrage du module METIER : $NAME"
docker run -d --name "$NAME" -p "$PORT:$PORT" "$IMAGE"

echo "✔ Module METIER lancé."
