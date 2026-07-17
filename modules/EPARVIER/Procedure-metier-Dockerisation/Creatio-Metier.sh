#!/bin/bash

echo "==============================="
echo "🚀 KING-AO — Workflow complet"
echo "==============================="

# 1️⃣ Vérifier l'état Git
echo "🔍 Vérification Git..."
git status

# 2️⃣ Si modifications → commit automatique
if ! git diff-index --quiet HEAD --; then
    echo "📝 Modifications détectées → création du commit"
    git add -A
    git commit -m "METIER-API-COCKPIT"
else
    echo "✔ Aucun changement → pas de commit nécessaire"
fi

# 3️⃣ Récupérer le hash Git
GIT_TAG=$(git rev-parse --short HEAD)
echo "🔢 Hash Git récupéré : $GIT_TAG"

# 4️⃣ Build de l'image
echo "🏗 Build de l'image Docker..."
docker build -t eparvier-metier:build .

# 5️⃣ Tag avec le hash Git
echo "🏷 Tag de l'image : eparvier-metier:$GIT_TAG"
docker tag eparvier-metier:build eparvier-metier:$GIT_TAG

# 6️⃣ Mise à jour du compose
COMPOSE_FILE="/opt/KING-AO/modules/EPARVIER/compose/docker-compose.yml"
echo "🛠 Mise à jour du compose avec le tag $GIT_TAG"
sed -i "s|image: eparvier-metier:.*|image: eparvier-metier:$GIT_TAG|g" $COMPOSE_FILE

# 7️⃣ Lancement du module
echo "🚀 Lancement du module EPARVIER"
docker compose -f $COMPOSE_FILE up -d

echo "✔ EPARVIER lancé avec l'image taggée : $GIT_TAG"
echo "==============================="
