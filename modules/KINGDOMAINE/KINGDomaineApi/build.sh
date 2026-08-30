#!/bin/bash

echo "🔧 Build KINGDOMAINE API..."

# Aller dans le dossier de l'API
cd /opt/KING-AO/modules/KINGDOMAINE/KINGDomaineApi || exit

# Récupérer le hash Git pour le tag
GIT_HASH=$(git rev-parse --short HEAD)

# Construire l'image Docker
docker build -t kingdomaine-api:$GIT_HASH -f Dockerfile.Api .

# Tag latest
docker tag kingdomaine-api:$GIT_HASH kingdomaine-api:latest

echo "✅ Build terminé : kingdomaine-api:$GIT_HASH"
