#!/bin/bash
set -e

MODULE="KINGDOMAINE"
APP="KINGDomaineApi"
ROOT="/opt/KING-AO/modules/$MODULE"
APPS="$ROOT/apps"
DOCKER="$ROOT/docker"

echo "=== BUILD $MODULE / $APP ==="

# 1. Récupération du hash Git
cd "$ROOT"
HASH=$(git rev-parse --short HEAD)
echo "Hash Git détecté : $HASH"

# 2. Build Shared
echo "=== Build Shared ==="
cd "$APPS/KINGDomaine.Shared"
dotnet build -c Release

# 3. Build métier
echo "=== Build metier ==="
cd "$ROOT/metier"
dotnet build -c Release

# 4. Build API
echo "=== Build API ==="
cd "$APPS/$APP"
dotnet publish -c Release -o out

# 5. Build Docker image
echo "=== Build Docker image ==="
cd "$DOCKER"
docker build -f Dockerfile.Api \
    -t kingdomaine-api:latest \
    -t kingdomaine-api:$HASH \
    "$APPS/$APP"

echo "=== BUILD TERMINÉ ==="
echo "Image générée : kingdomaine-api:$HASH"
echo "Image latest mise à jour."
