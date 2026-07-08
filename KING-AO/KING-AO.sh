#!/bin/bash

ROOT="/opt/KING-AO/KING-AO"
MODULES_CONF="/opt/KING-AO/config/paths.conf"

# Chargement du module NETWORKING
NETWORKING=$(grep NETWORKING $MODULES_CONF | cut -d '=' -f2)

header() {
    clear
    echo "==============================================="
    echo "              👑 KING-AO ORCHESTRATEUR"
    echo "==============================================="
    echo
}

menu() {
    while true; do
        header
        echo "🧩 METIER"
        echo "  1) Démarrer METIER"
        echo "  2) Arrêter METIER"
        echo "  3) Status METIER"
        echo
        echo "🏰 KINGDOMAINE"
        echo "  4) Démarrer KINGDOMAINE"
        echo "  5) Arrêter KINGDOMAINE"
        echo "  6) Status KINGDOMAINE"
        echo
        echo "🧠 ORCHESTRATOR"
        echo "  7) Démarrer tous les modules"
        echo "  8) Arrêter tous les modules"
        echo "  9) Status global"
        echo
        echo "🌐 NETWORKING"
        echo " 10) Diagnostic réseau complet"
        echo " 11) Test Tailscale"
        echo
        echo "0) Quitter"
        echo
        read -rp "Choix : " CH

        case "$CH" in
            1) bash "$ROOT/actions/metier/start.sh" ;;
            2) bash "$ROOT/actions/metier/stop.sh" ;;
            3) bash "$ROOT/actions/metier/status.sh" ;;
            4) bash "$ROOT/actions/kingdomaine/start.sh" ;;
            5) bash "$ROOT/actions/kingdomaine/stop.sh" ;;
            6) bash "$ROOT/actions/kingdomaine/status.sh" ;;
            7) bash "$ROOT/actions/orchestrator/orchestrator.sh" start ;;
            8) bash "$ROOT/actions/orchestrator/orchestrator.sh" stop ;;
            9) bash "$ROOT/actions/orchestrator/orchestrator.sh" status ;;
            10) bash "$NETWORKING/networking.sh" ;;
            11) bash "$NETWORKING/tailscale-check.sh" ;;
            0) exit 0 ;;
            *) echo "Choix invalide"; sleep 1 ;;
        esac
    done
}

menu
