# ============================
#   EPARVIER MAKEFILE v2
#   Cockpit # ============================
#   EPARVIER MAKEFILE v3
#   DevOps Toolkit by Bernard & Copilot
# ============================

GREEN=\033[0;32m
RED=\033[0;31m
YELLOW=\033[1;33m
BLUE=\033[0;34m
CYAN=\033[0;36m
NC=\033[0m




# ============================
#   AIDE / MENU
# ============================

help:
    @echo -e "$(CYAN)===== EPARVIER DevOps Toolkit =====$(NC)"
    @echo -e "$(GREEN)make start-core$(NC)        → Démarre API + Cockpit + Mongo"
    @echo -e "$(GREEN)make stop-noise$(NC)        → Stoppe monitoring inutile"
    @echo -e "$(GREEN)make restart-core$(NC)      → Redémarre API + Cockpit"
    @echo -e "$(GREEN)make logs-api$(NC)          → Affiche logs API"
    @echo -e "$(GREEN)make logs-cockpit$(NC)      → Affiche logs Cockpit"
    @echo -e "$(GREEN)make build-dotnet$(NC)      → Build solution .NET"
    @echo -e "$(GREEN)make run-api$(NC)           → Lance API en local (dotnet run)"
    @echo -e "$(GREEN)make run-cockpit$(NC)       → Lance Cockpit en local"
    @echo -e "$(GREEN)make compose-up$(NC)        → docker compose up -d"
    @echo -e "$(GREEN)make compose-down$(NC)      → docker compose down"
    @echo -e "$(GREEN)make clean-all$(NC)         → Nettoyage total Docker"
    @echo -e "$(CYAN)====================================$(NC)"

# ============================
#   CONTENEURS EPARVIER
# ============================

stop-noise:
    @echo -e "$(YELLOW)[STOP] Arrêt des services inutiles...$(NC)"
    docker stop mongo-express || true
    docker stop mongodb-exporter || true
    docker stop prometheus || true
    docker stop grafana || true
    docker stop blackbox_exporter || true
    docker stop cadvisor || true
    docker stop node_exporter || true

start-core:
    @echo -e "$(GREEN)[START] Démarrage du noyau EPARVIER...$(NC)"
    docker start mongo || true
    docker start solaizeapi || true
    docker start solaizecockpit || true

restart-core:
    @echo -e "$(BLUE)[RESTART] Redémarrage du noyau EPARVIER...$(NC)"
    docker stop solaizeapi || true
    docker stop solaizecockpit || true
    docker start solaizeapi || true
    docker start solaizecockpit || true

status:
    @echo -e "$(BLUE)[STATUS] Conteneurs actifs :$(NC)"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

logs-api:
    @echo -e "$(GREEN)[LOGS] Logs SolaizeAPI...$(NC)"
    docker logs solaizeapi -f

logs-cockpit:
    @echo -e "$(GREEN)[LOGS] Logs SolaizeCockpit...$(NC)"
    docker logs solaizecockpit -f

ports:
    @echo -e "$(BLUE)[PORTS] Ports ouverts :$(NC)"
    sudo lsof -i -P -n | grep LISTEN

# ============================
#   DOCKER COMPOSE
# ============================

compose-up:
    @echo -e "$(GREEN)[COMPOSE] Lancement EPARVIER...$(NC)"
    docker compose up -d

compose-down:
    @echo -e "$(RED)[COMPOSE] Arrêt EPARVIER...$(NC)"
    docker compose down

compose-rebuild:
    @echo -e "$(BLUE)[COMPOSE] Rebuild complet...$(NC)"
    docker compose build --no-cache

# ============================
#   DOTNET COMMANDS
# ============================

build-dotnet:
    @echo -e "$(CYAN)[DOTNET] Build solution...$(NC)"
    dotnet build

run-api:
    @echo -e "$(CYAN)[DOTNET] Run API en local...$(NC)"
    cd SolaizeApi && dotnet run

run-cockpit:
    @echo -e "$(CYAN)[DOTNET] Run Cockpit en local...$(NC)"
    cd SolaizeCockpit && dotnet run

# ============================
#   NETTOYAGE PROFOND
# ============================

clean-containers:
    @echo -e "$(RED)[CLEAN] Suppression des conteneurs arrêtés...$(NC)"
    docker container prune -f

clean-images:
    @echo -e "$(RED)[CLEAN] Suppression des images inutilisées...$(NC)"
    docker image prune -f

clean-images-deep:
    @echo -e "$(RED)[CLEAN] Suppression TOTALE des images orphelines...$(NC)"
    docker image prune -a -f

clean-volumes:
    @echo -e "$(RED)[CLEAN] Suppression des volumes non utilisés...$(NC)"
    docker volume prune -f

clean-networks:
    @echo -e "$(RED)[CLEAN] Suppression des réseaux inutilisés...$(NC)"
    docker network prune -f

clean-all:
    @echo -e "$(RED)[CLEAN] Nettoyage complet : conteneurs + images + volumes + réseaux$(NC)"
    docker system prune -a --volumes -f

# ============================
#   HARD RESET (optionnel)
# ============================

hard-reset:
    @echo -e "$(RED)[DANGER] Hard reset complet du Docker Engine$(NC)"
    docker stop $$(docker ps -aq) || true
    docker system prune -a --volumes -f
