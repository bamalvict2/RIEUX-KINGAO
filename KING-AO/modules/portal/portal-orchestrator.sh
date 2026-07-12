#!/bin/bash

# Emplacement de l’orchestrateur principal (ancien, celui que tu préfères)
ORCH="/opt/KING-AO/KING-AO/STYLE-ORCH-KING-AO.sh"


case "$1" in

    start_all)
        $ORCH start
        exit $?
    ;;

    stop_all)
        $ORCH stop
        exit $?
    ;;

    restart_all)
        $ORCH restart
        exit $?
    ;;

    *)
        echo "Usage: $0 {start_all|stop_all|restart_all}"
        exit 1
    ;;
esac
