#!/bin/bash

# Charger les chemins
ROOT=$(grep ROOT $ROOT/config/paths.conf | cut -d '=' -f2)
ACTIONS=$(grep ACTIONS $ROOT/config/paths.conf | cut -d '=' -f2)
MODULES=$(grep MODULES $ROOT/config/paths.conf | cut -d '=' -f2)
CONFIG=$(grep CONFIG $ROOT/config/paths.conf | cut -d '=' -f2)

# Charger les modules actifs
METIER_ENABLED=$(grep EPARVIER_METIER $CONFIG/modules.conf | cut -d '=' -f2)
KINGDOMAINE_ENABLED=$(grep KINGDOMAINE $CONFIG/modules.conf | cut -d '=' -f2)

# Fonction pour lancer METIER
start_metier() {
    NAME=$(grep NAME $CONFIG/metier.conf | cut -d '=' -f2)
    IMAGE=$(grep IMAGE $CONFIG/metier.conf | cut -d '=' -f2)
    PORT=$(grep PORT $CONFIG/metier.conf | cut -d '=' -f2)

    bash $ACTIONS/metier/start.sh $NAME $IMAGE $PORT
}

# Fonction pour lancer KINGDOMAINE
start_kingdomaine() {
    NAME=$(grep NAME $CONFIG/kingdomaine.conf | cut -d '=' -f2)
    IMAGE=$(grep IMAGE $CONFIG/kingdomaine.conf | cut -d '=' -f2)
    PORT=$(grep PORT $CONFIG/kingdomaine.conf | cut -d '=' -f2)

    bash $ACTIONS/kingdomaine/start.sh $NAME $IMAGE $PORT
}

# Menu principal
case $1 in
    start)
        [ "$METIER_ENABLED" = "enabled" ] && start_metier
        [ "$KINGDOMAINE_ENABLED" = "enabled" ] && start_kingdomaine
        ;;
    stop)
        bash $ACTIONS/metier/stop.sh
        bash $ACTIONS/kingdomaine/stop.sh
        ;;
    status)
        bash $ACTIONS/metier/status.sh
        bash $ACTIONS/kingdomaine/status.sh
        ;;
    *)
        echo "Usage: orchestrator.sh {start|stop|status}"
        ;;
esac
