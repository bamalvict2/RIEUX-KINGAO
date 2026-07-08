#!/bin/bash

CONFIG="$ROOT/config/metier.conf"
NAME=$(grep NAME $CONFIG | cut -d '=' -f2)

echo "🛑 Arrêt du module METIER : $NAME"
docker stop "$NAME"
docker rm "$NAME"

echo "✔ Module METIER arrêté."
