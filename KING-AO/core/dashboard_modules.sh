dashboard_modules() {
    echo -e "${BOLD}${WHITE}👑 MODULES — Status${RESET}"

    METIER_STATUS=$(docker ps --filter name=metier --format '{{.Status}}')
    KING_STATUS=$(docker ps --filter name=kingdomaine --format '{{.Status}}')
    PORTAL_STATUS=$(docker ps --filter name=portal --format '{{.Status}}')

    [[ "$METIER_STATUS" =~ "Up" ]] && METIER_COLOR=$GREEN || METIER_COLOR=$RED
    [[ "$KING_STATUS" =~ "Up" ]] && KING_COLOR=$GREEN || KING_COLOR=$RED
    [[ "$PORTAL_STATUS" =~ "Up" ]] && PORTAL_COLOR=$GREEN || PORTAL_COLOR=$RED

    printf "  %-15s : ${METIER_COLOR}%s${RESET}\n" "METIER" "$METIER_STATUS"
    printf "  %-15s : ${KING_COLOR}%s${RESET}\n" "KINGDOMAINE" "$KING_STATUS"
    printf "  %-15s : ${PORTAL_COLOR}%s${RESET}\n" "PORTAL" "$PORTAL_STATUS"
    echo

    echo -e "${BOLD}${BLUE}📜 LOGS METIER${RESET}"
    docker logs --tail 10 metier 2>/dev/null | sed 's/^/    /'
    echo

    echo -e "${BOLD}${BLUE}📜 LOGS KINGDOMAINE${RESET}"
    docker logs --tail 10 kingdomaine 2>/dev/null | sed 's/^/    /'
    echo

    echo -e "${BOLD}${BLUE}📜 LOGS PORTAL${RESET}"
    docker logs --tail 10 portal 2>/dev/null | sed 's/^/    /'
    echo
}
