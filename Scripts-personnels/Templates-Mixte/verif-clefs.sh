#!/bin/bash

# ============================
#   COULEURS BERNARDOPS
# ============================
VERT="\e[32m"
ROUGE="\e[31m"
BLEU="\e[34m"
JAUNE="\e[33m"
RESET="\e[0m"

# ============================
#   FONCTIONS — CLÉS ACTIVES
# ============================

verifier_cles() {
    echo -e "${BLEU}=== Clés SSH actives ===${RESET}"
    ls -l ~/.ssh/id_* 2>/dev/null | grep -v archive
}

lister_cles() {
    echo -e "${BLEU}=== Contenu du dossier ~/.ssh ===${RESET}"
    ls -l ~/.ssh
}

tester_github() {
    echo -e "${BLEU}=== Test connexion GitHub ===${RESET}"
    ssh -T git@github.com
}

# ============================
#   FONCTIONS — MULTI-CLÉS
# ============================

generer_cle() {
    echo -e "${BLEU}--- Génération d'une nouvelle clé SSH ---${RESET}"
    read -p "Nom de la clé (ex: perso, travail, serveur) : " nom
    read -p "Email associé : " email

    ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519_$nom
    echo -e "${VERT}Clé générée : ~/.ssh/id_ed25519_${nom}${RESET}"
}

ajouter_agent() {
    echo -e "${BLEU}--- Ajout d'une clé à l'agent SSH ---${RESET}"
    read -p "Nom de la clé : " nom
    ssh-add ~/.ssh/id_ed25519_$nom
    echo -e "${VERT}Clé ajoutée à l'agent.${RESET}"
}

afficher_pub() {
    echo -e "${BLEU}--- Clé publique ---${RESET}"
    read -p "Nom de la clé : " nom
    echo -e "${JAUNE}"
    cat ~/.ssh/id_ed25519_${nom}.pub
    echo -e "${RESET}"
}

configurer_ssh() {
    echo -e "${BLEU}--- Ajout d'un bloc dans ~/.ssh/config ---${RESET}"
    read -p "Nom de la clé : " nom
    read -p "Alias Host (ex: github-perso) : " alias
    read -p "HostName (ex: ssh.github.com) : " host
    read -p "Port (443 pour GitHub) : " port

    cat >> ~/.ssh/config <<EOF

Host $alias
    HostName $host
    User git
    Port $port
    IdentityFile ~/.ssh/id_ed25519_$nom
    IdentitiesOnly yes
EOF

    echo -e "${VERT}Bloc ajouté.${RESET}"
}

# ============================
#   FONCTIONS — ARCHIVE
# ============================

archiver_cle() {
    echo -e "${BLEU}--- Archivage d'une clé SSH ---${RESET}"
    mkdir -p ~/.ssh/archive
    read -p "Nom de la clé : " nom

    if [[ -f ~/.ssh/id_ed25519_$nom ]]; then
        mv ~/.ssh/id_ed25519_$nom ~/.ssh/id_ed25519_${nom}.pub ~/.ssh/archive/
        echo -e "${VERT}Clé archivée.${RESET}"
    else
        echo -e "${ROUGE}Clé introuvable.${RESET}"
    fi
}

restaurer_cle() {
    echo -e "${BLEU}--- Restauration d'une clé SSH ---${RESET}"
    read -p "Nom de la clé : " nom

    if [[ -f ~/.ssh/archive/id_ed25519_$nom ]]; then
        mv ~/.ssh/archive/id_ed25519_$nom ~/.ssh/archive/id_ed25519_${nom}.pub ~/.ssh/
        echo -e "${VERT}Clé restaurée.${RESET}"
    else
        echo -e "${ROUGE}Clé archivée introuvable.${RESET}"
    fi
}

supprimer_cle() {
    echo -e "${ROUGE}--- SUPPRESSION DÉFINITIVE ---${RESET}"
    read -p "Nom de la clé : " nom

    if [[ -f ~/.ssh/id_ed25519_$nom ]]; then
        read -p "CONFIRMER suppression ? (o/n) : " rep
        if [[ "$rep" == "o" ]]; then
            rm ~/.ssh/id_ed25519_$nom ~/.ssh/id_ed25519_${nom}.pub
            echo -e "${VERT}Clé supprimée.${RESET}"
        else
            echo -e "${JAUNE}Annulé.${RESET}"
        fi
    else
        echo -e "${ROUGE}Clé introuvable.${RESET}"
    fi
}

lister_archive() {
    echo -e "${BLEU}=== Clés archivées ===${RESET}"
    ls -l ~/.ssh/archive 2>/dev/null || echo -e "${JAUNE}Aucune clé archivée.${RESET}"
}

# ============================
#   MENUS
# ============================

menu_principal() {
    clear
    echo -e "${JAUNE}=== 🔐 BernardOps — Gestion SSH complète ===${RESET}"
    echo -e "${BLEU}1) Vérifier clés SSH actives${RESET}"
    echo -e "${BLEU}2) Lister contenu ~/.ssh${RESET}"
    echo -e "${BLEU}3) Tester connexion GitHub${RESET}"
    echo -e "${BLEU}4) Multi‑clé : générer / agent / config / afficher${RESET}"
    echo -e "${BLEU}5) Anciennes clés : archiver / restaurer / supprimer / lister${RESET}"
    echo -e "${BLEU}q) Quitter${RESET}"

    read -p "Choix : " choix

    case $choix in
        1) verifier_cles ;;
        2) lister_cles ;;
        3) tester_github ;;
        4) menu_multicle ;;
        5) menu_archive ;;
        q) exit 0 ;;
        *) echo -e "${ROUGE}Choix invalide.${RESET}" ;;
    esac

    read -p "ENTER pour continuer..."
    menu_principal
}

menu_multicle() {
    clear
    echo -e "${JAUNE}=== Multi‑clé SSH ===${RESET}"
    echo -e "${BLEU}1) Générer une clé${RESET}"
    echo -e "${BLEU}2) Ajouter à l'agent${RESET}"
    echo -e "${BLEU}3) Afficher clé publique${RESET}"
    echo -e "${BLEU}4) Ajouter bloc dans ~/.ssh/config${RESET}"
    echo -e "${BLEU}q) Retour${RESET}"

    read -p "Choix : " choix

    case $choix in
        1) generer_cle ;;
        2) ajouter_agent ;;
        3) afficher_pub ;;
        4) configurer_ssh ;;
        q) return ;;
    esac

    read -p "ENTER..."
    menu_multicle
}

menu_archive() {
    clear
    echo -e "${JAUNE}=== Anciennes clés SSH ===${RESET}"
    echo -e "${BLEU}1) Archiver une clé${RESET}"
    echo -e "${BLEU}2) Restaurer une clé${RESET}"
    echo -e "${BLEU}3) Supprimer une clé${RESET}"
    echo -e "${BLEU}4) Lister les clés archivées${RESET}"
    echo -e "${BLEU}q) Retour${RESET}"

    read -p "Choix : " choix

    case $choix in
        1) archiver_cle ;;
        2) restaurer_cle ;;
        3) supprimer_cle ;;
        4) lister_archive ;;
        q) return ;;
    esac

    read -p "ENTER..."
    menu_archive
}

# Lancement
menu_principal