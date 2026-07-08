#!/bin/bash

# ============================================
#   🧠 MENU PRINCIPAL — ORCHESTRATOR KING-AO
# ============================================

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LOG_DIR="$BASE_DIR/logs"
mkdir -p "$LOG_DIR"

log() {
    echo "[ORCHESTRATOR][MENU] $(date '+%Y-%m-%d %H:%M:%S') — $1" | tee -a "$LOG_DIR/orchestrator-menu.log"
}

pause() {
    echo
    read -rp "Appuie sur Entrée pour revenir au menu... " _
}

header() {
    clear
    echo "==============================================="
    echo "           👑 KING-AO — MENU ORCHESTRATEUR"
    echo "==============================================="
    echo
}

open_cockpit() {
    log "Ouverture cockpit ORCHESTRATOR"
    bash "$BASE_DIR/actions/orchestrator/cockpit.sh"
}

open_metier() {
    log "Ouverture cockpit METIER (HTML)"
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$BASE_DIR/cockpit/metier.html"
    else
        echo "Ouvre manuellement : $BASE_DIR/cockpit/metier.html"
    fi
    pause
}

open_kingdomaine() {
    log "Ouverture cockpit KINGDOMAINE (HTML)"
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$BASE_DIR/cockpit/kingdomaine.html"
    else
        echo "Ouvre manuellement : $BASE_DIR/cockpit/kingdomaine.html"
    fi
    pause
}

open_global_html() {
    log "Ouverture cockpit global HTML"
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$BASE_DIR/cockpit/index.html"
    else
        echo "Ouvre manuellement : $BASE_DIR/cockpit/index.html"
    fi
    pause
}

menu() {
    while true; do
        header
        echo "🧩 METIER"
        echo "  1) Cockpit METIER (HTML)"
        echo
        echo "🏰 KINGDOMAINE"
        echo "  2) Cockpit KINGDOMAINE (HTML)"
        echo
        echo "🧠 ORCHESTRATOR"
        echo "  3) Cockpit ORCHESTRATOR (shell)"
        echo
        echo "🌐 Cockpit global HTML"
        echo "  4) Ouvrir index.html"
        echo
        echo "0) Quitter"
        echo
        read -rp "Choix : " CH

        case "$CH" in
            1) open_metier ;;
            2) open_kingdomaine ;;
            3) open_cockpit ;;
            4) open_global_html ;;
            0) log "Sortie du menu orchestrateur"; exit 0 ;;
            *) echo "Choix invalide"; sleep 1 ;;
        esac
    done
}

menu

