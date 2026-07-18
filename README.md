# KINGDOMAINE – Feuille de route profonde

## 1. Vision d’ensemble

**Objectif :** un domaine personnel stable, supervisé, réplicable, avec :
- un front métier (C#/Razor/Blazor),
- un front Ops (Grafana),
- une exposition via Cloudflare/DuckDNS,
- une utilisation possible depuis Android.

**Piliers :**
- Cœur métier : services C# (.NET), Razor/Blazor, logique EPARVIER.
- Exposition : Cloudflare Tunnel + DuckDNS (fallback / tests).
- Supervision : Prometheus + Grafana + exporters (app, système, blackbox).
- Réplicats : versions figées (Android / prod stable) vs versions évolutives (dev / lab).
- Sauvegardes : Git remote Travail + T3 (tampon FUSE) + archives tar.gz.

---

## 2. Couches de l’architecture KINGDOMAINE

### 2.1 Couche Infra & OS

- Machine hôte : Windows 11 (T3/T7), VMware, disques externes (T3/T7/T8/T9).
- VM : Ubuntu KINGDOMAINE (C# + Docker + Prometheus + Grafana).
- Partages : VMware FUSE `.host:/UBUNTUSAVEW11` → `/mnt/UBUNTUSAVEW11`.
- Objectif : infra reproductible, montée/descente sans douleur.

### 2.2 Couche Applicative C# / Razor / Blazor

- Services C# exposant API + Razor/Blazor pour le front web.
- Ports clairs (ex : 5000/5001 interne, reverse proxy éventuel).
- Logs structurés (JSON si possible) pour corrélation avec Prometheus/Grafana.

### 2.3 Couche Réseau & DNS (Cloudflare / DuckDNS)

- Cloudflare Tunnel : entrée principale (quand OK).
- DuckDNS : entrée alternative / de secours.
- Scripts de test : petit `.sh` qui vérifie Cloudflare KO / DuckDNS OK.
- À terme : ces tests deviennent des probes blackbox Prometheus.

### 2.4 Couche Supervision (Prometheus / Grafana)

- Prometheus : collecte métriques système, app, blackbox.
- Grafana : front Ops, dashboards par couche (infra, app, DNS, réplicats).
- Exporters : `node_exporter`, `blackbox_exporter`, métriques .NET.

### 2.5 Couche Réplicats & Versions

- Réplicat “Android stable” : version serveur figée, API stables.
- Réplicat “Prod stable” : version validée, peu de changements.
- Réplicat “Dev / Lab” : Razor, Grafana, exporters en évolution.

---

## 3. Supervision en profondeur (Prometheus / Grafana)

### 3.1 Stack de base monitoring

Créer un `docker-compose.monitoring.yml` avec :
- Prometheus
- Grafana
- node_exporter
- blackbox_exporter

Configurer Prometheus pour scrapper :
- la VM KINGDOMAINE (CPU, RAM, disque),
- les services C# (.NET metrics endpoint),
- les probes blackbox (Cloudflare, DuckDNS, endpoints HTTP).

### 3.2 Dashboards Grafana “double front”

- Dashboard Infra KINGDOMAINE : CPU, RAM, disque, uptime.
- Dashboard App C# : temps de réponse, erreurs HTTP, requêtes/s.
- Dashboard DNS / Tunnel : Cloudflare vs DuckDNS (probes blackbox).
- Dashboard Réplicats / Backups : succès/échecs, taille tar.gz, timestamps.

### 3.3 Intégration du petit `.sh` de test

- Option 1 : transformer le `.sh` en endpoint texte exposant des métriques.
- Option 2 : utiliser `blackbox_exporter` pour tester directement les URLs Cloudflare/DuckDNS.
- Objectif : voir dans Grafana l’historique des KO/OK, pas seulement l’instantané.

---

## 4. Réplicats & Android figé

### 4.1 Principe des réplicats

- Réplicat Android : API stables, pas de breaking changes.
- Réplicat Prod : version validée, utilisée au quotidien.
- Réplicat Dev : terrain de jeu pour Razor, Grafana, exporters.

### 4.2 Stratégie d’URL / routage

Exemples :
- `https://android.kingdomaine/` → réplicat Android figé.
- `https://prod.kingdomaine/` → réplicat Prod stable.
- `https://lab.kingdomaine/` → réplicat Dev.

Android pointe toujours vers le même host / même version.

### 4.3 Cycle de vie d’une évolution

1. Développer sur réplicat Dev (Razor, Grafana, exporters).
2. Superviser via Grafana (stabilité, erreurs, perf).
3. Promouvoir vers Prod si OK.
4. Décider si Android doit changer de version ou rester figé.

---

## 5. Flux opérationnels “au fil de l’eau”

### 5.1 Sauvegardes & FUSE

- Script universel de sauvegarde EPARVIER → `/mnt/UBUNTUSAVEW11/EPARVIER/...`
- Archives `BernardBackup-YYYYMMDD-HHMM.tar.gz` sur T3.
- Git remote Travail à jour pour le code.
- Possibilité de remonter FUSE “dans les deux sens” pour restaurer.

### 5.2 Routine quotidienne KINGDOMAINE

1. Vérifier Grafana (dashboards clés) en début de session.
2. Travailler sur EPARVIER / C# / Razor.
3. Sauvegarde Git + tar.gz (script universel).
4. Vérifier que les probes Cloudflare/DuckDNS sont OK.

---

## 6. Prochaines étapes concrètes

- Créer le docker-compose monitoring (Prometheus, Grafana, node_exporter, blackbox_exporter).
- Ajouter les premiers jobs Prometheus (KINGDOMAINE, C#, Cloudflare, DuckDNS).
- Construire un dashboard Grafana “Infra + DNS” pour voir la santé globale.
- Définir les 3 réplicats (Android, Prod, Dev) et leurs URLs.
- Documenter cette feuille de route comme référence KINGDOMAINE.



## Mémo express

    Build API → docker build -t solaizeapi -f Dockerfile.Api .

    Run API → docker compose -f compose-api.yml up -d

    Build KINGDOMAINE → docker build -t kingdomaine -f Dockerfile.Api .

    Run KINGDOMAINE → docker compose -f compose-kingdomaine.yml up -d

    Build PORTAL → docker build -t portal -f Dockerfile.Portal .

    Run PORTAL → docker compose -f compose-portal.yml up -d
