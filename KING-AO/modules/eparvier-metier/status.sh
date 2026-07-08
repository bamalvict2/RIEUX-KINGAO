#!/bin/bash

CONFIG="$ROOT/config/metier.conf"
NAME=$(grep NAME $CONFIG | cut -d '=' -f2)

echo "📡 Status du module METIER : $NAME"
docker ps | grep "$NAME"
