#!/bin/bash

CONFIG="$ROOT/config/kingdomaine.conf"

NAME=$(grep NAME $CONFIG | cut -d '=' -f2)
IMAGE=$(grep IMAGE $CONFIG | cut -d '=' -f2)

echo "🔧 Reconstruction du module KINGDOMAINE : $NAME"
echo "➡ Image : $IMAGE"

cd "$(dirname "$0")"

docker build -t "$IMAGE" .

if [ $? -eq 0 ]; then
    echo "✔ Image KINGDOMAINE reconstruite avec succès."
else
    echo "❌ Échec de la reconstruction de l'image KINGDOMAINE."
fi
