# ============================
# 🎛 Modes d'exécution KING-AO
# ============================

MODE="normal"

set_mode() {
    case "$1" in
        verbose)
            MODE="verbose"
            echo -e "${GREEN}[MODE] Verbose activé${RESET}"
            ;;
        debug)
            MODE="debug"
            echo -e "${YELLOW}[MODE] Debug activé${RESET}"
            ;;
        silent)
            MODE="silent"
            ;;
        dashboard)
            MODE="dashboard"
            ;;
        *)
            MODE="normal"
            ;;
    esac
}

is_verbose() {
    [[ "$MODE" == "verbose" ]]
}

is_debug() {
    [[ "$MODE" == "debug" ]]
}

is_silent() {
    [[ "$MODE" == "silent" ]]
}

is_dashboard() {
    [[ "$MODE" == "dashboard" ]]
}
