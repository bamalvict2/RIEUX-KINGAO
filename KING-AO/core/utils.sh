# ============================
# 🔧 Utils KING-AO PRO
# ============================

header() {
    clear
    echo -e "${BOLD}${CYAN}===============================================${RESET}"
    echo -e "${BOLD}${MAGENTA}              👑 KING-AO ORCHESTRATEUR${RESET}"
    echo -e "${BOLD}${CYAN}===============================================${RESET}"
    echo
}

pause() {
    read -rp "Appuyez sur Entrée pour continuer..."
}

check_root() {
    if [[ "$EUID" -ne 0 ]]; then
        echo -e "${RED}[ERROR]${RESET} Ce module doit être exécuté en root."
        exit 1
    fi
}

timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

line() {
    echo -e "${CYAN}-----------------------------------------------${RESET}"
}
