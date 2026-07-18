# ============================
#   EPARVIER MAKEFILE v2
#   Cockpit DevOps by Bernard
#   ex :FAIRE UN make stop-noise etc...
# ============================

GREEN=\033[0;32m
RED=\033[0;31m
YELLOW=\033[1;33m
BLUE=\033[0;34m
NC=\033[0m

# ============================
#   CONTENEURS EPARVIER
# ============================

stop-noise:
	@echo -e "$(YELLOW)[STOP] Arrêt des services inutiles...$(NC)"
	docker stop mongo-express || true
	docker stop mongodb-exporter || true
	docker stop prometheus || true
	docker stop grafana || true
	docker stop blazor || true
	docker stop solaizeapi || true

start-core:
	@echo -e "$(GREEN)[START] Démarrage du noyau EPARVIER...$(NC)"
	docker start mongo || true
	docker start solaizeapi || true
	docker start blazor || true

restart-core:
	@echo -e "$(BLUE)[RESTART] Redémarrage du noyau EPARVIER...$(NC)"
	docker stop solaizeapi || true
	docker stop blazor || true
	docker start solaizeapi || true
	docker start blazor || true

status:
	@echo -e "$(BLUE)[STATUS] Conteneurs actifs :$(NC)"
	docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

logs-api:
	@echo -e "$(GREEN)[LOGS] Logs SolaizeAPI...$(NC)"
	docker logs solaizeapi -f

ports:
	@echo -e "$(BLUE)[PORTS] Ports ouverts :$(NC)"
	sudo lsof -i -P -n | grep LISTEN

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

------------------------------------------------------------------------------

LANCEMENT DES MODULES EPARVIER-KINGDOMAINE-PORTAL

🟦 2 — Version propre du Makefile (EPARVIER + KINGDOMAINE + PORTAL)
🔵 EPARVIER
Code

build-eparvier-api:
    cd /opt/KING-AO/modules/EPARVIER/SolaizeApi && docker build -t solaizeapi .

build-eparvier-cockpit:
    cd /opt/KING-AO/modules/EPARVIER/cockpit && docker build -t solaizecockpit .

run-eparvier:
    cd /opt/KING-AO/modules/EPARVIER/docker && docker compose up -d

🟢 KINGDOMAINE
Code

build-kingdomaine-api:
    cd /opt/KING-AO/modules/KINGDOMAINE/api && docker build -t kingdomaine .

build-kingdomaine-cockpit:
    cd /opt/KING-AO/modules/KINGDOMAINE/cockpit && docker build -t kingdomaine-cockpit .

run-kingdomaine:
    cd /opt/KING-AO/modules/KINGDOMAINE/docker && docker compose up -d

🟣 PORTAL
Code

build-portal:
    cd /opt/KING-AO/modules/PORTAL && docker build -t portal .

build-portal-cockpit:
    cd /opt/KING-AO/modules/PORTAL/cockpit && docker build -t portal-cockpit .

run-portal:
    cd /opt/KING-AO/modules/PORTAL/docker && docker compose up -d


build-api:
    cd /opt/KING-AO/modules/EPARVIER/SolaizeApi && docker build -t solaizeapi .

build-cockpit:
    cd /opt/KING-AO/modules/EPARVIER/cockpit && docker build -t blazor .

run-eparvier:
    cd /opt/KING-AO/modules/EPARVIER/docker && docker compose up -d



build-kingdomaine:
    cd /opt/KING-AO/modules/KINGDOMAINE/api && docker build -t kingdomaine .

build-kingdomaine-cockpit:
    cd /opt/KING-AO/modules/KINGDOMAINE/cockpit && docker build -t kingdomaine-cockpit .

run-kingdomaine:
    cd /opt/KING-AO/modules/KINGDOMAINE/docker && docker compose up -d



build-portal:
    cd /opt/KING-AO/modules/PORTAL && docker build -t portal .

build-portal-cockpit:
    cd /opt/KING-AO/modules/PORTAL/cockpit && docker build -t portal-cockpit .

run-portal:
    cd /opt/KING-AO/modules/PORTAL/docker && docker compose up -d


🟦 2 — Lancement des modules (sans Makefile)

Tu vas dans chaque dossier docker/ et tu fais :
EPARVIER
Code

cd /opt/KING-AO/modules/EPARVIER/docker
docker compose up -d

KINGDOMAINE
Code

cd /opt/KING-AO/modules/KINGDOMAINE/docker
docker compose up -d

PORTAL
Code

cd /opt/KING-AO/modules/PORTAL/docker
docker compose up -d



#DANS   bamalvict@KING-AO:/opt/KING-AO/modules/EPARVIER$ ON CREE LES 

bamalvict@KING-AO:/opt/KING-AO/modules/EPARVIER$ docker images
                                                                                                                              i Info →   U  In Use
IMAGE                        ID             DISK USAGE   CONTENT SIZE   EXTRA
kingdomaine-cockpit:latest   f9dedcbae09b        321MB         90.5MB        
kingdomaine:latest           ed36f53385c3        371MB          108MB        
portal-cockpit:latest        2899f6c1c20a        321MB         90.5MB        
portal:latest                5ad14637318a        371MB          108MB        
solaizeapi:latest            c23ca867521f        371MB          108MB        
solaizecockpit:latest        e30a37b0990e        321MB         90.5MB        
bamalvict@KING-AO:/opt/KING-AO/modules/EPARVIER$ 

------------------------------------------------------------------

🔥 Commandes officielles KING‑AO
EPARVIER

    docker build -t solaizeapi -f Dockerfile.Api .

    docker build -t solaizecockpit -f Dockerfile.Cockpit .

KINGDOMAINE

    docker build -t kingdomaine -f Dockerfile.Api .

    docker build -t kingdomaine-cockpit -f Dockerfile.Cockpit .

PORTAL/

    docker build -t portal -f Dockerfile.Api .

    docker build -t portal-cockpit -f Dockerfile.Cockpit .

----------------------------------------------------------------

🟩 Pourquoi tu peux renommer tes compose sans rien changer dedans

Docker Compose ne regarde jamais le nom du fichier.
Il regarde uniquement ce que tu lui donnes avec -f.

Donc :

    docker-compose.yml

    compose-api.yml

    compose-cockpit.yml

    compose-kingdomaine.yml

    compose-portal.yml

👉 Pour Docker, c’est exactement la même chose.
👉 Le contenu interne ne change pas.
👉 Le comportement ne change pas.
👉 Les services ne changent pas.
👉 Les images ne changent pas.
👉 Les réseaux ne changent pas.

Tu changes juste le nom du fichier, pas son fonctionnement.
🟦 La seule chose qui change : la commande de lancement

Tu passes de :
Code

docker compose up -d

à :
Code

docker compose -f compose-api.yml up -d

Et pour KINGDOMAINE :
Code

docker compose -f compose-kingdomaine.yml up -d

Et pour PORTAL :
Code

docker compose -f compose-portal.yml up -d

👉 C’est la seule différence.
👉 Le reste ne bouge pas d’un millimètre.
🟩 Résultat cockpit-style

Tu obtiens une architecture propre, lisible, sans poupée russe, juste en renommant :

    compose-api.yml

    compose-cockpit.yml

    compose-kingdomaine.yml

    compose-portal.yml

Et tu les lances avec :

    EPARVIER API

    EPARVIER Cockpit

    KINGDOMAINE

    PORTAL

🟧 Résumé gravé dans le marbre
✔ Oui, tu peux renommer tes compose
✔ Oui, tu n’as rien à modifier dedans
✔ Oui, Docker s’en fiche du nom
✔ Oui, tu simplifies KING‑AO
✔ Oui, tu casses la poupée russe
✔ Oui, tu cockpitifies ton architecture

Tu veux que je te propose une nomenclature officielle KING‑AO pour nommer tous tes compose proprement ?

👉 nomenclature compose KING‑AO

ON PEUT AUSSI CHANGER LES NOM DE COMPOSE
docker compose -f compose-api.yml up -d
docker compose -f compose-cockpit.yml up -d
docker compose -f compose-kingdomaine.yml up -d
docker compose -f compose-portal.yml up -d



## Mémo express

    Build API → docker build -t solaizeapi -f Dockerfile.Api .

    Run API → docker compose -f compose-api.yml up -d

    Build KINGDOMAINE → docker build -t kingdomaine -f Dockerfile.Api .

    Run KINGDOMAINE → docker compose -f compose-kingdomaine.yml up -d

    Build PORTAL → docker build -t portal -f Dockerfile.Portal .

    Run PORTAL → docker compose -f compose-portal.yml up -d



ALAIS .bashrc AVEC NEW NOM 
alias eparvier-build='docker build -t solaizeapi -f Dockerfile.Api . && docker build -t solaizecockpit -f Dockerfile.Cockpit .'
alias eparvier-run='docker compose -f compose-eparvier.yml up -d'


























🟩 RÈGLE D’OR (à graver dans le marbre KING‑AO)
✔ Toujours builder depuis le dossier du module

EPARVIER → /opt/KING-AO/modules/EPARVIER  
KINGDOMAINE → /opt/KING-AO/modules/KINGDOMAINE  
PORTAL → /opt/KING-AO/modules/PORTAL
✔ Toujours préciser le Dockerfile si son nom n’est pas “Dockerfile”
Code

docker build -t NOM_IMAGE -f NOM_DOCKERFILE .

👉 C’est LA commande universelle KING‑AO
👉 Elle marche toujours  
👉 Elle évite toutes les erreurs
🟦 Les 3 commandes officielles KING‑AO (définitives)
🔵 EPARVIER

    API → docker build -t solaizeapi -f Dockerfile.Api .

    Cockpit → docker build -t solaizecockpit -f Dockerfile.Cockpit .

🟢 KINGDOMAINE

    API → docker build -t kingdomaine -f Dockerfile.Api .

    Cockpit → docker build -t kingdomaine-cockpit -f Dockerfile.Cockpit .

🟣 PORTAL

    HTML → docker build -t portal -f Dockerfile.Portal .

    Cockpit → docker build -t portal-cockpit -f Dockerfile.Cockpit .

