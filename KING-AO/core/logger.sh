# ============================
# 📝 Logger KING-AO PRO
# ============================

LOG_DIR="/opt/KING-AO/KING-AO/logs"
LOG_FILE="$LOG_DIR/king-ao.log"

mkdir -p "$LOG_DIR"

log() {
    local LEVEL="$1"
    local MESSAGE="$2"
    local COLOR="$WHITE"

    case "$LEVEL" in
        INFO) COLOR="$GREEN" ;;
        WARN) COLOR="$YELLOW" ;;
        ERROR) COLOR="$RED" ;;
        DEBUG) COLOR="$CYAN" ;;
    esac

    # Affichage console selon mode
    if ! is_silent; then
        if [[ "$LEVEL" == "DEBUG" && ! is_debug ]]; then
            return
        fi

        if [[ "$LEVEL" == "INFO" && is_verbose ]]; then
            echo -e "${COLOR}[${LEVEL}]${RESET} $MESSAGE"
        elif [[ "$LEVEL" != "INFO" ]]; then
            echo -e "${COLOR}[${LEVEL}]${RESET} $MESSAGE"
        fi
    fi

    # Écriture dans le fichier log
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$LEVEL] $MESSAGE" >> "$LOG_FILE"
}
