#!/bin/bash

ROOT="/opt/KING-AO/KING-AO"

# Chargement des modules CORE
source "$ROOT/core/dashboard_colors.sh"
source "$ROOT/core/utils.sh"
source "$ROOT/core/logger.sh"
source "$ROOT/core/modes.sh"
source "$ROOT/core/menu.sh"
source "$ROOT/core/dashboard.sh"

MODULES_CONF="$ROOT/config/paths.conf"

# Chargement du module NETWORKING
NETWORKING=$(grep NETWORKING $MODULES_CONF | cut -d '=' -f2)

# ============================
# 👑 CHEF D’ORCHESTRE KING-AO
# ============================

main() {
    # Mode dashboard
    if is_dashboard; then
        dashboard
        exit 0
    fi

    # Mode normal → menu
    menu
}

main "$@"
