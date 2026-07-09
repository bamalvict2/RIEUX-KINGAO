menu() {
    clear
    echo -e "${BOLD}${CYAN}===============================================${RESET}"
    echo -e "${BOLD}${MAGENTA}              👑 KING-AO ORCHESTRATEUR${RESET}"
    echo -e "${BOLD}${CYAN}===============================================${RESET}"
    echo

    echo -e "${BOLD}${WHITE}🧩 METIER${RESET}"
    echo -e "  ${YELLOW}1)${RESET} Démarrer METIER"
    echo -e "  ${YELLOW}2)${RESET} Arrêter METIER"
    echo -e "  ${YELLOW}3)${RESET} Status METIER"
    echo

    echo -e "${BOLD}${WHITE}🏰 KINGDOMAINE${RESET}"
    echo -e "  ${YELLOW}4)${RESET} Démarrer KINGDOMAINE"
    echo -e "  ${YELLOW}5)${RESET} Arrêter KINGDOMAINE"
    echo -e "  ${YELLOW}6)${RESET} Status KINGDOMAINE"
    echo

    echo -e "${BOLD}${WHITE}🧠 ORCHESTRATOR${RESET}"
    echo -e "  ${YELLOW}7)${RESET} Démarrer tous les modules"
    echo -e "  ${YELLOW}8)${RESET} Arrêter tous les modules"
    echo -e "  ${YELLOW}9)${RESET} Status global"
    echo

    echo -e "${BOLD}${WHITE}🌐 NETWORKING${RESET}"
    echo -e " ${YELLOW}10)${RESET} Diagnostic réseau complet"
    echo -e " ${YELLOW}11)${RESET} Test Tailscale"
    echo

    echo -e "${YELLOW}0)${RESET} Quitter"
    echo
    read -rp "Choix : " CHOICE

    case "$CHOICE" in
        1) bash "$ROOT/actions/metier/start.sh" ;;
        2) bash "$ROOT/actions/metier/stop.sh" ;;
        3) bash "$ROOT/actions/metier/status.sh" ;;

        4) bash "$ROOT/actions/kingdomaine/start.sh" ;;
        5) bash "$ROOT/actions/kingdomaine/stop.sh" ;;
        6) bash "$ROOT/actions/kingdomaine/status.sh" ;;

        7) bash "$ROOT/actions/orchestrator/start.sh" ;;
        8) bash "$ROOT/actions/orchestrator/stop.sh" ;;
        9) bash "$ROOT/actions/orchestrator/status.sh" ;;

        10) bash "$ROOT/actions/networking/diagnostic.sh" ;;
        11) bash "$ROOT/actions/networking/tailscale.sh" ;;

        0) exit 0 ;;
    esac
}
