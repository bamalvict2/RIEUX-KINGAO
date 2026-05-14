#!/bin/bash

# ============================
#   EPARVIER COCKPIT PRO
#   Navigation + Docker Ops
# ============================

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
NC="\e[0m"

ROOT="$HOME/EPARVIER"
API="$ROOT/SolaizeApi"
BLAZOR="$ROOT/SolaizeCockpit"

# ============================
#   FONCTIONS
# ============================

pause() {
    echo ""
    read -p "Appuyez sur Entrée pour continuer..."
}

header() {
    clear
    echo -e "${BLUE}=========================================${NC}"
    echo -e "${GREEN}          EPARVIER COCKPIT PRO           ${NC}"
    echo -e "${BLUE}=========================================${NC}"
    echo ""
}

docker_status() {
    echo -e "${CYAN}État des conteneurs :${NC}"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    pause
}

docker_logs() {
    echo -e "${CYAN}Logs en direct :${NC}"
    docker compose logs -f
}

docker_up() {
    echo -e "${GREEN}Démarrage du stack...${NC}"
    cd "$ROOT" && docker compose up -d
    pause
}

docker_down() {
    echo -e "${YELLOW}Arrêt du stack...${NC}"
    cd "$ROOT" && docker compose down
    pause
}

docker_rebuild() {
    echo -e "${RED}Reconstruction complète...${NC}"
    cd "$ROOT" && docker compose down -v && docker compose build --no-cache && docker compose up -d
    pause
}

docker_clean() {
    echo -e "${RED}Nettoyage profond Docker...${NC}"
    docker system prune -a --volumes -f
    pause
}

# ============================
#   MENU NAVIGATION
# ============================

menu_navigation() {
    header
    echo -e "${YELLOW}1) Aller dans EPARVIER${NC}"
    echo -e "${YELLOW}2) Aller dans SolaizeApi${NC}"
    echo -e "${YELLOW}3) Aller dans SolaizeCockpit${NC}"
    echo -e "${YELLOW}4) Choisir un dossier manuellement${NC}"
    echo -e "${YELLOW}5) Retour au menu principal${NC}"
    echo ""

    read -p "Votre choix : " NAV

    case $NAV in
        1) cd "$ROOT" && exec bash ;;
        2) cd "$API" && exec bash ;;
        3) cd "$BLAZOR" && exec bash ;;
        4) read -p "Chemin du dossier : " MANU ; cd "$MANU" && exec bash ;;
        5) return ;;
        *) echo -e "${RED}Choix invalide${NC}" ; pause ;;
    esac
}

# ============================
#   MENU DOCKER
# ============================

menu_docker() {
    header
    echo -e "${YELLOW}1) Docker UP${NC}"
    echo -e "${YELLOW}2) Docker DOWN${NC}"
    echo -e "${YELLOW}3) Docker REBUILD${NC}"
    echo -e "${YELLOW}4) Docker STATUS${NC}"
    echo -e "${YELLOW}5) Docker LOGS${NC}"
    echo -e "${YELLOW}6) Docker CLEAN (dangereux)${NC}"
    echo -e "${YELLOW}7) Retour au menu principal${NC}"
    echo ""

    read -p "Votre choix : " DCK

    case $DCK in
        1) docker_up ;;
        2) docker_down ;;
        3) docker_rebuild ;;
        4) docker_status ;;
        5) docker_logs ;;
        6) docker_clean ;;
        7) return ;;
        *) echo -e "${RED}Choix invalide${NC}" ; pause ;;
    esac
}

# ============================
#   MENU PRINCIPAL
# ============================

while true; do
    header
    echo -e "${YELLOW}1) Navigation (auto + manuelle)${NC}"
    echo -e "${YELLOW}2) Gestion Docker${NC}"
    echo -e "${YELLOW}3) Quitter${NC}"
    echo ""

    read -p "Votre choix : " MAIN

    case $MAIN in
        1) menu_navigation ;;
        2) menu_docker ;;
        3) echo -e "${GREEN}Au revoir Bernard !${NC}" ; exit ;;
        *) echo -e "${RED}Choix invalide${NC}" ; pause ;;
    esac
done
