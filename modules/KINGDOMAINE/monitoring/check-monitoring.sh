#!/bin/bash

##############################################
# KINGDOMAINE — CHECK MONITORING
# Vérifie tous les services + endpoints API
##############################################

GREEN="\\e[32m"
RED="\\e[31m"
YELLOW="\\e[33m"
NC="\\e[0m"

check_port() {
    local name=$1
    local port=$2

    if nc -z localhost $port 2>/dev/null; then
        echo -e "${GREEN}[OK]${NC} $name écoute sur le port $port"
    else
        echo -e "${RED}[FAIL]${NC} $name NE répond PAS sur le port $port"
    fi
}

check_http() {
    local name=$1
    local url=$2

    if curl -s --max-time 2 "$url" >/dev/null; then
        echo -e "${GREEN}[OK]${NC} $name répond : $url"
    else
        echo -e "${RED}[FAIL]${NC} $name NE répond PAS : $url"
    fi
}

echo "=============================================="
echo "     🟦 KINGDOMAINE — CHECK MONITORING"
echo "=============================================="
echo ""

echo "🔍 Vérification des ports des services Docker"
check_port "Prometheus" 9090
check_port "Grafana" 3000
check_port "Node Exporter" 9100
check_port "cAdvisor" 8080
check_port "MongoDB Exporter" 9216
check_port "Blackbox Exporter" 9115
echo ""

echo "🔍 Vérification des endpoints API"
check_http "API (.NET)" "http://localhost:5010/health"
check_http "Blazor Server" "http://localhost:5110"
echo ""

echo "🔍 Vérification MongoDB (port host)"
check_port "MongoDB (host)" 27017
echo ""

echo "🔍 Vérification Prometheus Targets"
if curl -s http://localhost:9090/api/v1/targets | grep -q "\"health\":\"up\""; then
    echo -e "${GREEN}[OK]${NC} Prometheus → targets UP"
else
    echo -e "${RED}[FAIL]${NC} Prometheus → targets DOWN ou partiels"
fi

echo ""
echo "=============================================="
echo "        ✔ Vérification terminée"
echo "=============================================="
