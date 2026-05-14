#!/bin/bash

###############################################
# AUTO-LOCALISATION DU SCRIPT
###############################################
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
EPARVIER_DIR="$BASE_DIR/eparvier"
KING_DIR="$BASE_DIR/kingdomaine"

###############################################
# EPARVIER – Stack Applicative
###############################################

start_eparvier() {
    echo "🚀 Démarrage de la stack EPARVIER..."
    docker compose -f "$EPARVIER_DIR/docker-compose.yml" up -d
}

stop_eparvier() {
    echo "🛑 Arrêt de la stack EPARVIER..."
    docker compose -f "$EPARVIER_DIR/docker-compose.yml" down
}

logs_eparvier() {
    echo "📜 Logs EPARVIER..."
    docker compose -f "$EPARVIER_DIR/docker-compose.yml" logs -f
}

rebuild_api() {
    echo "🔧 Rebuild de l'API .NET..."
    docker compose -f "$EPARVIER_DIR/docker-compose.yml" build solaizeapi
    docker compose -f "$EPARVIER_DIR/docker-compose.yml" up -d solaizeapi
}

rebuild_blazor() {
    echo "🔧 Rebuild de Blazor..."
    docker compose -f "$EPARVIER_DIR/docker-compose.yml" build blazor
    docker compose -f "$EPARVIER_DIR/docker-compose.yml" up -d blazor
}

backup_mongo() {
    echo "💾 Backup MongoDB..."
    TIMESTAMP=$(date +"%Y%m%d_%H%M")
    docker exec mongo mongodump --out "/data/db/backup_$TIMESTAMP"
    echo "✔️ Backup créé : backup_$TIMESTAMP"
}

###############################################
# KINGDOMAINE – Monitoring complet
###############################################

start_monitoring() {
    echo "🚀 Démarrage du monitoring (KINGDOMAINE)..."
    docker compose -f "$KING_DIR/docker-compose.yml" up -d
}

stop_monitoring() {
    echo "🛑 Arrêt du monitoring (KINGDOMAINE)..."
    docker compose -f "$KING_DIR/docker-compose.yml" down
}

logs_monitoring() {
    echo "📜 Logs du monitoring..."
    docker compose -f "$KING_DIR/docker-compose.yml" logs -f
}

status_monitoring() {
    echo "📊 État des services de monitoring :"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" \
        | grep -E "prometheus|grafana|exporter|cadvisor|node"
}

test_monitoring() {
    echo "🔍 Tests rapides du monitoring :"

    echo "➡️  Prometheus :"
    curl -s http://localhost:9090/-/ready >/dev/null && echo "   ✔️ OK" || echo "   ❌ KO"

    echo "➡️  Grafana :"
    curl -s http://localhost:3000/login | grep -q "Grafana" && echo "   ✔️ OK" || echo "   ❌ KO"

    echo "➡️  Node Exporter :"
    curl -s http://localhost:9100/metrics >/dev/null && echo "   ✔️ OK" || echo "   ❌ KO"

    echo "➡️  cAdvisor :"
    curl -s http://localhost:8080/metrics >/dev/null && echo "   ✔️ OK" || echo "   ❌ KO"

    echo "➡️  MongoDB Exporter :"
    curl -s http://localhost:9216/metrics >/dev/null && echo "   ✔️ OK" || echo "   ❌ KO"

    echo "➡️  Blackbox Exporter :"
    curl -s http://localhost:9115/probe >/dev/null && echo "   ✔️ OK" || echo "   ❌ KO"
}

###############################################
# HEALTHCHECK GLOBAL
###############################################

healthcheck() {
    echo "🩺 Healthcheck global :"

    echo "➡️ API .NET :"
    curl -s http://localhost:5010/health >/dev/null && echo "   ✔️ OK" || echo "   ❌ KO"

    echo "➡️ Blazor :"
    curl -s http://localhost:5110 >/dev/null && echo "   ✔️ OK" || echo "   ❌ KO"

    echo "➡️ MongoDB :"
    nc -z localhost 27017 && echo "   ✔️ OK" || echo "   ❌ KO"

    echo "➡️ Loki :"
    curl -s http://localhost:3100/ready >/dev/null && echo "   ✔️ OK" || echo "   ❌ KO"
}

###############################################
# DOCKER UTILITAIRES
###############################################

status() {
    echo "📊 Conteneurs actifs :"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

clean() {
    echo "🧹 Nettoyage Docker..."
    docker container prune -f
    docker image prune -f
}

update_images() {
    echo "⬆️ Mise à jour des images Docker..."
    docker pull $(docker images --format "{{.Repository}}:{{.Tag}}")
}

###############################################
# MENU
###############################################

case "$1" in
    start-eparvier) start_eparvier ;;
    stop-eparvier) stop_eparvier ;;
    logs-eparvier) logs_eparvier ;;
    rebuild-api) rebuild_api ;;
    rebuild-blazor) rebuild_blazor ;;
    backup-mongo) backup_mongo ;;
    start-monitoring) start_monitoring ;;
    stop-monitoring) stop_monitoring ;;
    logs-monitoring) logs_monitoring ;;
    status-monitoring) status_monitoring ;;
    test-monitoring) test_monitoring ;;
    healthcheck) healthcheck ;;
    status) status ;;
    clean) clean ;;
    update-images) update_images ;;
    *)
        echo "Usage : $0 {start-eparvier|stop-eparvier|logs-eparvier|rebuild-api|rebuild-blazor|backup-mongo|start-monitoring|stop-monitoring|logs-monitoring|status-monitoring|test-monitoring|healthcheck|status|clean|update-images}"
        ;;
esac
