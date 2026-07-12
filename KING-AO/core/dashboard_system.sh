dashboard_system() {
    echo -e "${BOLD}${WHITE}🧠 CPU — Charge système${RESET}"
    top -bn1 | head -5 | sed 's/^/    /'
    echo

    echo -e "${BOLD}${WHITE}💾 RAM — Utilisation${RESET}"
    free -h | sed 's/^/    /'
    echo

    echo -e "${BOLD}${WHITE}🌐 Réseau — Interfaces${RESET}"
    ip -br addr | sed 's/^/    /'
    echo

    echo -e "${BOLD}${WHITE}🔌 Connexions TCP actives${RESET}"
    ss -tuna | head -20 | sed 's/^/    /'
    echo

    echo -e "${BOLD}${WHITE}⏱ Uptime${RESET}"
    uptime | sed 's/^/    /'
    echo

    echo -e "${BOLD}${WHITE}📊 Load Average${RESET}"
    cat /proc/loadavg | sed 's/^/    /'
    echo
}

