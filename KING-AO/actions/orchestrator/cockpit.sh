#!/bin/bash

# ============================================
#  🧠 COCKPIT ORCHESTRATOR KING-AO
#  nano /opt/KING-AO/KING-AO/actions/orchestrator/cockpit.sh
#  coller le script
#  chmod +x /opt/KING-AO/KING-AO/actions/orchestrator/cockpit.sh
# ============================================

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LOG_DIR="$BASE_DIR/logs"
mkdir -p "$LOG_DIR"

log() {
    echo "[COCKPIT][ORCHESTRATOR] $(date '+%Y-%m-%d %H:%M:%S') — $1" | tee -a "$LOG_DIR/orchestrator.log"
}

pause() {
    echo
    read -rp "Appuie sur Entrée pour revenir au menu... " _
}

header() {
    clear
    echo "==============================================="
    echo "        🧠 COCKPIT ORCHESTRATOR KING-AO"
    echo "==============================================="
    echo
}

# ============================
#  METIER
# ============================

metier_start() {
    log "Start METIER"
    bash "$BASE_DIR/actions/metier/start.sh"
    pause
}

metier_stop() {
    log "Stop METIER"
    bash "$BASE_DIR/actions/metier/stop.sh"
    pause
}

metier_status() {
    log "Status METIER"
    bash "$BASE_DIR/actions/metier/status.sh"
    pause
}

metier_logs() {
    log "Logs METIER"
    bash "$BASE_DIR/actions/metier/logs.sh"
    pause
}

metier_rebuild() {
    log "Rebuild METIER"
    bash "$BASE_DIR/actions/metier/rebuild.sh"
    pause
}

metier_sync() {
    log "Sync METIER"
    bash "$BASE_DIR/actions/metier/sync.sh"
    pause
}

# ============================
#  KINGDOMAINE
# ============================

kd_start() {
    log "Start KINGDOMAINE"
    bash "$BASE_DIR/actions/kingdomaine/start.sh"
    pause
}

kd_stop() {
    log "Stop KINGDOMAINE"
    bash "$BASE_DIR/actions/kingdomaine/stop.sh"
    pause
}

kd_status() {
    log "Status KINGDOMAINE"
    bash "$BASE_DIR/actions/kingdomaine/status.sh"
    pause
}

kd_logs() {
    log "Logs KINGDOMAINE"
    bash "$BASE_DIR/actions/kingdomaine/logs.sh"
    pause
}

kd_rebuild() {
    log "Rebuild KINGDOMAINE"
    bash "$BASE_DIR/actions/kingdomaine/rebuild.sh"
    pause
}

kd_sync() {
    log "Sync KINGDOMAINE"
    bash "$BASE_DIR/actions/kingdomaine/sync.sh"
    pause
}

kd_check() {
    log "Check KINGDOMAINE"
    bash "$BASE_DIR/actions/kingdomaine/check.sh"
    pause
}

kd_flux() {
    log "Flux KINGDOMAINE"
    bash "$BASE_DIR/actions/kingdomaine/flux.sh"
    pause
}

kd_admin() {
    log "Admin KINGDOMAINE"
    bash "$BASE_DIR/actions/kingdomaine/admin.sh"
    pause
}

# ============================
#  MENU PRINCIPAL
# ============================

menu() {
    while true; do
        header
        echo "🧩 METIER"
        echo "  1) Start"
        echo "  2) Stop"
        echo "  3) Status"
        echo "  4) Logs"
        echo "  5) Rebuild"
        echo "  6) Sync"
        echo
        echo "🏰 KINGDOMAINE"
        echo "  7) Start"
        echo "  8) Stop"
        echo "  9) Status"
        echo " 10) Logs"
        echo " 11) Rebuild"
        echo " 12) Sync"
        echo " 13) Check cohérence"
        echo " 14) Flux entrants/sortants"
        echo " 15) Admin"
        echo
        echo "0) Quitter"
        echo
        read -rp "Choix : " CH

        case "$CH" in
            1) metier_start ;;
            2) metier_stop ;;
            3) metier_status ;;
            4) metier_logs ;;
            5) metier_rebuild ;;
            6) metier_sync ;;
            7) kd_start ;;
            8) kd_stop ;;
            9) kd_status ;;
            10) kd_logs ;;
            11) kd_rebuild ;;
            12) kd_sync ;;
            13) kd_check ;;
            14) kd_flux ;;
            15) kd_admin ;;
            0) log "Sortie du cockpit orchestrateur"; exit 0 ;;
            *) echo "Choix invalide"; sleep 1 ;;
        esac
    done
}

menu
