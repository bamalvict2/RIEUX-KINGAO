#!/bin/bash

# ==========================================================
# 🚀 BUILDER UNE IMAGE KING-AO (MODULE + TAG + PATH + DATE + JSON + GIT + DRY-RUN)
# ==========================================================

PATHS_CONF="/opt/KING-AO/KING-AO/config/paths.conf"
LOG_DIR="/opt/KING-AO/logs/builds"
mkdir -p "$LOG_DIR"

# ==========================================================
# 🔍 Vérification des dépendances essentielles
# ==========================================================
if ! command -v dotnet >/dev/null 2>&1; then
    echo "❌ dotnet n'est pas installé ou introuvable dans PATH."
    exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
    echo "❌ docker n'est pas installé ou introuvable dans PATH."
    exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
    echo "❌ jq n'est pas installé — requis pour l'export JSON."
    echo "👉 sudo apt install jq -y"
    exit 1
fi

echo "================================================================"
echo "🟦 CHOIX DES MODULES À BUILDER — Vérifier MODULE dans paths.conf"
echo "================================================================"
echo "1) EPARVIER_API"
echo "2) EPARVIER_COCKPIT"
echo "3) SHARED"
echo "4) KINGDOMAINE"
echo "5) PORTAL"
echo "6) METIER"
echo ""
read -p "👉 Sélectionne un module (1-6) : " CHOICE

case "$CHOICE" in
    1) KEY="EPARVIER_API" ;;
    2) KEY="EPARVIER_COCKPIT" ;;
    3) KEY="SHARED" ;;
    4) KEY="KINGDOMAINE" ;;
    5) KEY="PORTAL" ;;
    6) KEY="METIER" ;;
    *)
        echo "❌ Choix invalide."
        exit 1
        ;;
esac

MODULE_PATH=$(grep "^$KEY=" "$PATHS_CONF" | cut -d '=' -f2)

if [ -z "$MODULE_PATH" ]; then
    echo "❌ Le module $KEY n'existe pas dans paths.conf"
    exit 1
fi

echo ""
echo "🔎 MODULE SÉLECTIONNÉ : $KEY"
echo "📁 Chemin : $MODULE_PATH"
echo ""

# ==========================================================
# 🔍 Détection du bon .csproj (pas automatique : EXACT comme à la mano)
# ==========================================================
if [ "$KEY" = "EPARVIER_API" ]; then
    CSPROJ_PATH="$MODULE_PATH/SolaizeApi/SolaizeApi.csproj"
elif [ "$KEY" = "EPARVIER_COCKPIT" ]; then
    CSPROJ_PATH="$MODULE_PATH/SolaizeCockpit/SolaizeCockpit.csproj"
else
    CSPROJ_PATH=$(find "$MODULE_PATH" -maxdepth 3 -name "*.csproj" | head -n 1)
fi

if [ -z "$CSPROJ_PATH" ] || [ ! -f "$CSPROJ_PATH" ]; then
    echo "🟨 Aucun projet .NET détecté dans ce module."
    exit 0
fi

PROJECT_NAME=$(basename "$CSPROJ_PATH" .csproj)
IMAGE_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]')

echo "🟦 Projet C# détecté : $CSPROJ_PATH"
echo "🟦 Nom de l'image Docker : $IMAGE_NAME"
echo ""

# ==========================================================
# 🟦 CHOIX DU TAG
# ==========================================================
echo ""
echo "================================================================"
echo "🟦 CHOIX DU TAG — Ce tag sera gravé dans le marbre"
echo "================================================================"
read -p "👉 Entre ton tag (ex: prod, dev, test, 1.0, bernard) : " CUSTOM_TAG

CUSTOM_TAG=$(echo "$CUSTOM_TAG" | tr '[:upper:]' '[:lower:]')

if [ -z "$CUSTOM_TAG" ]; then
    echo "❌ Aucun tag fourni."
    exit 1
fi

DATE=$(date +"%Y-%m-%d")
FINAL_TAG="${CUSTOM_TAG}-${DATE}"

# ==========================================================
# 🔍 Informations Git
# ==========================================================
GIT_HASH=$(git -C "$MODULE_PATH" rev-parse --short HEAD 2>/dev/null)
GIT_AUTHOR=$(git -C "$MODULE_PATH" log -1 --pretty=format:'%an' 2>/dev/null)
GIT_DATE_COMMIT=$(git -C "$MODULE_PATH" log -1 --pretty=format:'%ad' 2>/dev/null)

[ -z "$GIT_HASH" ] && GIT_HASH="N/A"
[ -z "$GIT_AUTHOR" ] && GIT_AUTHOR="N/A"
[ -z "$GIT_DATE_COMMIT" ] && GIT_DATE_COMMIT="N/A"

# ==========================================================
# 🟨 DRY-RUN
# ==========================================================
echo ""
read -p "👉 Mode DRY-RUN (aucune compilation, aucun build) ? (y/n) : " DRY
if [ "$DRY" = "y" ]; then
    DRY_RUN=true
else
    DRY_RUN=false
fi

LOG_FILE="$LOG_DIR/build-${IMAGE_NAME}-${FINAL_TAG}.log"
JSON_FILE="$LOG_DIR/build-${IMAGE_NAME}-${FINAL_TAG}.json"

echo ""
echo "================================================================"
echo "🟩 RÉCAPITULATIF — GRAVÉ DANS LE MARBRE"
echo "MODULE : $KEY"
echo "PATH   : $MODULE_PATH"
echo "CSPROJ : $CSPROJ_PATH"
echo "IMAGE  : $IMAGE_NAME"
echo "TAG    : $CUSTOM_TAG"
echo "DATE   : $DATE"
echo "FINAL  : $FINAL_TAG"
echo "GIT    : $GIT_HASH"
echo "DRY    : $DRY_RUN"
echo "LOG    : $LOG_FILE"
echo "JSON   : $JSON_FILE"
echo "================================================================"

cd "$MODULE_PATH"

if [ "$DRY_RUN" = true ]; then
    echo "🟨 DRY-RUN ACTIVÉ — Aucun build exécuté."
    exit 0
fi

# ==========================================================
# 🔵 Compilation .NET
# ==========================================================
dotnet publish "$CSPROJ_PATH" -c Release -o out | tee -a "$LOG_FILE"

# ==========================================================
# 🐳 Build Docker — EXACTEMENT comme à la mano pour EPARVIER
# ==========================================================
if [ "$KEY" = "EPARVIER_API" ]; then
    docker build -t "$IMAGE_NAME:$FINAL_TAG" -f SolaizeApi/Dockerfile . | tee -a "$LOG_FILE"
    exit 0
fi

if [ "$KEY" = "EPARVIER_COCKPIT" ]; then
    docker build -t "$IMAGE_NAME:$FINAL_TAG" -f SolaizeCockpit/Dockerfile . | tee -a "$LOG_FILE"
    exit 0
fi

# 🔵 Modules normaux
docker build -t "$IMAGE_NAME:$FINAL_TAG" . | tee -a "$LOG_FILE"

echo ""
echo "================================================================"
echo "🟧 Image créée : $IMAGE_NAME:$FINAL_TAG"
echo "================================================================"
docker images | grep "$IMAGE_NAME"

echo ""
echo "📌 Containers actifs (docker ps)"
docker ps

echo ""
echo "📌 Tous les containers (docker ps -a)"
docker ps -a

echo ""
echo "📌 Images disponibles (docker images)"
docker images
