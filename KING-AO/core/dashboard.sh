dashboard() {
    clear
    echo -e "${BOLD}${CYAN}===============================================${RESET}"
    echo -e "${BOLD}${MAGENTA}            📊 DASHBOARD KING-AO${RESET}"
    echo -e "${BOLD}${CYAN}===============================================${RESET}"
    echo

    # Section modules (METIER / KINGDOMAINE / PORTAL)
    dashboard_modules

    echo -e "${BOLD}${CYAN}-----------------------------------------------${RESET}"
    echo

    # Section système (CPU / RAM / Réseau / TCP)
    dashboard_system

    echo -e "${BOLD}${CYAN}-----------------------------------------------${RESET}"
    echo

    echo -e "${BOLD}${WHITE}🔄 Rafraîchissement dans 3 secondes...${RESET}"
    sleep 3
    dashboard
}
