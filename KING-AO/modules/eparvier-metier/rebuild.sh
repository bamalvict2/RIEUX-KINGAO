#!/bin/bash

CONFIG="$ROOT/config/metier.conf"

NAME=$(grep NAME $CONFIG | cut -d '=' -f2)
IMAGE=$(grep IMAGE $CONFIG | cut -d '=' -f2)

echo "🔧 Reconstruction du module METIER : $NAME"
echo "➡ Image : $IMAGE"

cd "$(dirname "$0")"

docker build -t "$IMAGE" .

if [ $? -eq 0 ]; then
    echo "✔ Image METIER reconstruite avec succès."
else
    echo "❌ Échec de la reconstruction de l'image METIER."
fi
