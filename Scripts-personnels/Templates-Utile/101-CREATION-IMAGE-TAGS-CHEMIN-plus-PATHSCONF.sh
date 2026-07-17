#!/bin/bash

# Couleurs ANSI
BLUE="\e[34m"
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"

clear
echo -e "${BLUE}=============================================================="
echo -e "🟦 KING-AO — BUILDER AUTO + MANUEL (VERSION COLORÉE)"
echo -e "==============================================================${RESET}"

# --------------------------------------------------------------
# 1️⃣ CHOIX DU MODULE AUTO
# --------------------------------------------------------------
echo -e "${CYAN}👉 ENTRE LE NOM DU MODULE (EPARVIER, KINGDOMAINE)${RESET}"
read -p "Module AUTO : " MODULE_KEY

# --------------------------------------------------------------
# 2️⃣ LECTURE DE paths.conf
# --------------------------------------------------------------
PATHS_FILE="/opt/KING-AO/KING-AO/config/paths.conf"

if [[ ! -f "$PATHS_FILE" ]]; then
    echo -e "${RED}❌ paths.conf introuvable : $PATHS_FILE${RESET}"
    exit 1
fi

MODULE_PATH=$(grep "^$MODULE_KEY=" "$PATHS_FILE" | cut -d'=' -f2)

if [[ -z "$MODULE_PATH" ]]; then
    echo -e "${RED}❌ Module $MODULE_KEY introuvable dans paths.conf${RESET}"
    exit 1
fi

echo -e "${GREEN}📌 Module détecté : $MODULE_PATH${RESET}"

# --------------------------------------------------------------
# 3️⃣ LECTURE COMPLÈTE DES PATHS DU MODULE VIA paths.conf
# --------------------------------------------------------------

MODULE_PATH=$(grep "^${MODULE_KEY}=" "$PATHS_FILE" | cut -d'=' -f2)
API_PATH=$(grep "^${MODULE_KEY}_API=" "$PATHS_FILE" | cut -d'=' -f2)
COCKPIT_PATH=$(grep "^${MODULE_KEY}_COCKPIT=" "$PATHS_FILE" | cut -d'=' -f2)
SHARED_PATH=$(grep "^${MODULE_KEY}_SHARED=" "$PATHS_FILE" | cut -d'=' -f2)
DOCKER_PATH=$(grep "^${MODULE_KEY}_DOCKER=" "$PATHS_FILE" | cut -d'=' -f2)

# --- Vérifications ---
if [[ -z "$MODULE_PATH" ]]; then
    echo -e "${RED}❌ Aucun chemin MODULE trouvé dans paths.conf pour $MODULE_KEY${RESET}"
    exit 1
fi

if [[ -z "$API_PATH" ]]; then
    echo -e "${RED}❌ Aucun chemin API trouvé dans paths.conf pour $MODULE_KEY${RESET}"
    exit 1
fi

echo -e "${GREEN}📌 Module détecté : $MODULE_PATH${RESET}"
echo -e "${GREEN}📌 API détectée : $API_PATH${RESET}"
echo -e "${GREEN}📌 Cockpit détecté : $COCKPIT_PATH${RESET}"
echo -e "${GREEN}📌 Shared détecté : $SHARED_PATH${RESET}"
echo -e "${GREEN}📌 Docker détecté : $DOCKER_PATH${RESET}"

# --------------------------------------------------------------
# 4️⃣ DÉTECTION DOCKERFILE + COMPOSE
# --------------------------------------------------------------

DOCKERFILES=($(find "$API_PATH" -maxdepth 1 -name "Dockerfile*" 2>/dev/null))
COMPOSE_PATH=$(find "$DOCKER_PATH" -name "docker-compose.yml" | head -n 1)

if [[ ${#DOCKERFILES[@]} -eq 0 ]]; then
    echo -e "${RED}❌ Aucun Dockerfile trouvé dans $API_PATH${RESET}"
    exit 1
fi

echo -e "${GREEN}📌 Dockerfiles détectés :${RESET}"
for df in "${DOCKERFILES[@]}"; do
    echo -e "${GREEN}   ➤ $df${RESET}"
done


if [[ -z "$DOCKERFILE_PATH" ]]; then
    echo -e "${RED}❌ Aucun Dockerfile trouvé dans $API_PATH${RESET}"
    exit 1
fi

if [[ -z "$COMPOSE_PATH" ]]; then
    echo -e "${RED}❌ Aucun docker-compose.yml trouvé dans $DOCKER_PATH${RESET}"
    exit 1
fi

echo -e "${GREEN}📌 Dockerfile : $DOCKERFILE_PATH${RESET}"
echo -e "${GREEN}📌 Compose : $COMPOSE_PATH${RESET}"

# --------------------------------------------------------------
# 5️⃣ TAG MANUEL
# --------------------------------------------------------------
echo -e "${BLUE}=============================================================="
echo -e "🟦 TAG MANUEL — CHOISIS TON TAG"
echo -e "==============================================================${RESET}"

IMAGE_NAME=$(echo "$MODULE_KEY" | tr '[:upper:]' '[:lower:]')
echo -e "${CYAN}👉 Nom d'image : $IMAGE_NAME${RESET}"

read -p "👉 Entre ton TAG (ex: latest, dev, 1.0, 2026-07-13) : " MANUAL_TAG

if [[ -z "$MANUAL_TAG" ]]; then
    echo -e "${RED}❌ Aucun tag fourni — arrêt.${RESET}"
    exit 1
fi

FINAL_TAG="${IMAGE_NAME}:${MANUAL_TAG}"
echo -e "${GREEN}📌 Tag final choisi : $FINAL_TAG${RESET}"

# --------------------------------------------------------------
# 6️⃣ dotnet publish
# --------------------------------------------------------------
echo -e "${BLUE}=============================================================="
echo -e "🟦 dotnet publish"
echo -e "==============================================================${RESET}"

dotnet publish "$API_PATH" -c Release -o "$API_PATH/out"

# --------------------------------------------------------------
# 7️⃣ docker build
# --------------------------------------------------------------
echo -e "${BLUE}=============================================================="
echo -e "🟦 docker build"
echo -e "==============================================================${RESET}"

docker build -t "$FINAL_TAG" -f "$DOCKERFILE_PATH" "$MODULE_PATH"

echo -e "${GREEN}📦 Image créée : $FINAL_TAG${RESET}"

# --------------------------------------------------------------
# 8️⃣ MENU DOCKER COMPOSE
# --------------------------------------------------------------
echo -e "${BLUE}=============================================================="
echo -e "🟦 MENU DOCKER COMPOSE"
echo -e "==============================================================${RESET}"
echo -e "${YELLOW}1️⃣  docker compose down${RESET}"
echo -e "${YELLOW}2️⃣  docker compose up${RESET}"
echo -e "${YELLOW}3️⃣  down + up (redémarrage complet)${RESET}"
echo -e "${YELLOW}4️⃣  Annuler${RESET}"
read -p "👉 Choix : " CHOICE

case $CHOICE in
    1)
        echo -e "${RED}🟥 docker compose down${RESET}"
        docker compose -f "$COMPOSE_PATH" down
        exit 0
        ;;
    2)
        echo -e "${GREEN}🟩 docker compose up${RESET}"
        docker compose -f "$COMPOSE_PATH" up -d
        ;;
    3)
        echo -e "${RED}🟥 docker compose down${RESET}"
        docker compose -f "$COMPOSE_PATH" down
        echo -e "${GREEN}🟩 docker compose up${RESET}"
        docker compose -f "$COMPOSE_PATH" up -d
        ;;
    4)
        echo -e "${RED}❌ Annulé.${RESET}"
        exit 0
        ;;
    *)
        echo -e "${RED}❌ Choix invalide.${RESET}"
        exit 1
        ;;
esac

echo -e "${GREEN}=============================================================="
echo -e "🟩 AUTO BUILD TERMINÉ — IMAGE UTILISÉE : $FINAL_TAG"
echo -e "==============================================================${RESET}"
