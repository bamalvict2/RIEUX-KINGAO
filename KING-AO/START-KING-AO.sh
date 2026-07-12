#!/bin/bash

echo -e "\e[33m============================================\e[0m"
echo -e "\e[33m        🚀 START — KING‑AO SYSTEM            \e[0m"
echo -e "\e[33m============================================\e[0m"
echo ""

# -------------------------------
# CHARGEMENT DES CHEMINS
# -------------------------------
ROOT="/opt/KING-AO/KING-AO"
ACTIONS=$(grep ACTIONS $ROOT/config/paths.conf | cut -d '=' -f2)
MODULES=$(grep MODULES $ROOT/config/paths.conf | cut -d '=' -f2)
CONFIG=$(grep CONFIG $ROOT/config/paths.conf | cut -d '=' -f2)

echo -e "\e[36m🔍 Chemins chargés :\e[0m"
echo "  ROOT     = $ROOT"
echo "  ACTIONS  = $ACTIONS"
echo "  MODULES  = $MODULES"
echo "  CONFIG   = $CONFIG"
echo ""

# -------------------------------
# LANCEMENT METIER + KINGDOMAINE
# -------------------------------
echo -e "\e[36m▶ Démarrage METIER + KINGDOMAINE (orchestrator)...\e[0m"
$ROOT/actions/orchestrator/orchestrator.sh start
echo ""

# -------------------------------
# START PORTAL (Docker)
# -------------------------------
echo -e "\e[36m▶ Démarrage PORTAL (Docker)...\e[0m"
cd $MODULES/portal
docker compose up -d
echo -e "  ✔ PORTAL lancé"
echo ""

# -------------------------------
# START MONITORING (Docker)
# -------------------------------
echo -e "\e[36m▶ Démarrage MONITORING...\e[0m"
cd $MODULES/monitoring
docker compose up -d
echo -e "  ✔ MONITORING lancé"
echo ""

# -------------------------------
# CHECK DOCKER
# -------------------------------
echo -e "\e[36m🔍 Vérification Docker...\e[0m"
docker ps | egrep 'portal|grafana|prometheus|cadvisor|loki'
echo ""

# -------------------------------
# CHECK NGINX
# -------------------------------
echo -e "\e[36m🔍 Vérification NGINX...\e[0m"
sudo nginx -t
echo ""

# -------------------------------
# LANCEMENT DU COCKPIT HUMAIN
# -------------------------------
echo -e "\e[32m🚀 Lancement du cockpit KING‑AO...\e[0m"
echo ""
$ROOT/STYLE-ORCH-KING-AO.sh

echo ""
echo -e "\e[32m🎉 KING‑AO est démarré et opérationnel.\e[0m"
echo -e "\e[33m============================================\e[0m"
