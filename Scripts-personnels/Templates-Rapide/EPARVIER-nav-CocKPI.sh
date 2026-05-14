#!/bin/bash

# ============================
#   EPARVIER COCKPIT SCRIPT
#   Navigation Auto/Manu + Docker Ops
# ============================

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
NC="\e[0m"

ROOT="$HOME/EPARVIER"
API="$ROOT/SolaizeApi"
BLAZOR="$ROOT/SolaizeCockpit"

clear

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}      EPARVIER COCKPIT NAVIGATION        ${NC}"
echo -e "${BLUE}=========================================${NC}"

echo ""
echo -e "${YELLOW}1) Aller automatiquement dans EPARVIER${NC}"
echo -e "${YELLOW}2) Aller dans SolaizeApi${NC}"
echo -e "${YELLOW}3) Aller dans SolaizeCockpit${NC}"
echo -e "${YELLOW}4) Choisir un dossier manuellement${NC}"
echo -e "${YELLOW}5) Docker : UP${NC}"
echo -e "${YELLOW}6) Docker : DOWN${NC}"
echo -e "${YELLOW}7) Docker : REBUILD${NC}"
echo -e "${YELLOW}8) Docker : STATUS${NC}"
echo -e "${YELLOW}9) Quitter${NC}"
echo ""

read -p "Votre choix : " CHOICE

case $CHOICE in

  1)
    echo -e "${GREEN}→ Navigation automatique vers $ROOT${NC}"
    cd "$ROOT" || exit
    exec bash
    ;;

  2)
    echo -e "${GREEN}→ Navigation vers API : $API${NC}"
    cd "$API" || exit
    exec bash
    ;;

  3)
    echo -e "${GREEN}→ Navigation vers Blazor : $BLAZOR${NC}"
    cd "$BLAZOR" || exit
    exec bash
    ;;

  4)
    echo -e "${BLUE}→ Mode manuel${NC}"
    read -p "Chemin du dossier : " MANU
    cd "$MANU" || { echo -e "${RED}Dossier introuvable${NC}"; exit; }
    exec bash
    ;;

  5)
    echo -e "${GREEN}→ Docker compose UP${NC}"
    cd "$ROOT" && docker compose up -d
    ;;

  6)
    echo -e "${YELLOW}→ Docker compose DOWN${NC}"
    cd "$ROOT" && docker compose down
    ;;

  7)
    echo -e "${RED}→ Docker compose REBUILD${NC}"
    cd "$ROOT" && docker compose down -v && docker compose build --no-cache && docker compose up -d
    ;;

  8)
    echo -e "${BLUE}→ Docker STATUS${NC}"
    docker ps
    ;;

  9)
    echo -e "${GREEN}Au revoir Bernard !${NC}"
    exit
    ;;

  *)
    echo -e "${RED}Choix invalide${NC}"
    ;;
esac
