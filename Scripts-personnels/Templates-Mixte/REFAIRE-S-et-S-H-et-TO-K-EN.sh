#!/bin/bash

# ============================================================
#   COCKPIT SSH + TOKEN GITHUB – VERSION PRO BERNARDOPS V7
# ============================================================
# Ce cockpit permet de gérer facilement :
#   - La création de clés SSH
#   - L’ajout de la clé dans ssh-agent
#   - L’affichage de la clé publique
#   - La configuration du fichier ~/.ssh/config
#   - Le rappel pour enregistrer la clé dans GitHub
#   - Le test de connexion SSH
#   - La gestion du Token GitHub (PAT)
#   - La correction des permissions
#   - La suppression d’une ou de toutes les clés SSH
#
# -------------------------
#   🔐 RÔLE DE LA CLÉ SSH
# -------------------------
# Une clé SSH permet d’authentifier votre machine auprès de GitHub
# sans mot de passe. Elle remplace HTTPS et sécurise vos opérations.
#
# La clé privée reste sur votre machine.
# La clé publique doit être enregistrée dans :
#   GitHub → Settings → SSH and GPG keys → New SSH key
#
# ------------------------------
#   🔑 RÔLE DU TOKEN GITHUB (PAT)
# ------------------------------
# Le Token GitHub remplace votre mot de passe pour :
#   - Les accès HTTPS
#   - L’API GitHub
#   - Les scripts automatisés
#   - Les dépôts privés
#
# Ne jamais partager votre token.
# Ne jamais le mettre dans un dépôt Git.
#
# ============================================================
#   FIN DU HEADER — DÉBUT DU SCRIPT
# ============================================================

# Couleurs
VERT="\e[32m"
ROUGE="\e[31m"
BLEU="\e[34m"
JAUNE="\e[33m"
RESET="\e[0m"

# Vérification dossier ~/.ssh
verifier_dossier_ssh() {
    if [ ! -d ~/.ssh ]; then
        echo -e "${JAUNE}Dossier ~/.ssh absent, création...${RESET}"
        mkdir -p ~/.ssh
        chmod 700 ~/.ssh
    fi
}

# Vérification agent SSH
verifier_agent() {
    if ! pgrep -u "$USER" ssh-agent >/dev/null; then
        echo -e "${JAUNE}ssh-agent non lancé, démarrage...${RESET}"
        eval "$(ssh-agent -s)"
    fi
}

# 1) Générer une clé SSH
generer_cle() {
    verifier_dossier_ssh
    echo -e "${BLEU}--- Génération d'une nouvelle clé SSH ---${RESET}"
    read -p "Nom de la clé (ex: perso, travail) : " nom
    read -p "Email GitHub : " email

    if [ -f ~/.ssh/id_ed25519_$nom ]; then
        echo -e "${ROUGE}Erreur : une clé portant ce nom existe déjà.${RESET}"
        return
    fi

    ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519_$nom
    echo -e "${VERT}Clé générée : ~/.ssh/id_ed25519_${nom}${RESET}"
}

# 2) Ajouter une clé à l’agent
ajouter_agent() {
    verifier_agent
    echo -e "${BLEU}--- Ajout d'une clé à l'agent SSH ---${RESET}"
    read -p "Nom de la clé : " nom

    if [ ! -f ~/.ssh/id_ed25519_$nom ]; then
        echo -e "${ROUGE}Erreur : clé introuvable.${RESET}"
        return
    fi

    ssh-add ~/.ssh/id_ed25519_$nom
    echo -e "${VERT}Clé ajoutée à l'agent.${RESET}"
}

# 3) Afficher une clé publique
afficher_pub() {
    echo -e "${BLEU}--- Affichage de la clé publique ---${RESET}"
    read -p "Nom de la clé : " nom

    if [ ! -f ~/.ssh/id_ed25519_${nom}.pub ]; then
        echo -e "${ROUGE}Erreur : clé publique introuvable.${RESET}"
        return
    fi

    echo -e "${JAUNE}"
    cat ~/.ssh/id_ed25519_${nom}.pub
    echo -e "${RESET}"
}

# 4) Ajouter un bloc SSH config
configurer_ssh() {
    verifier_dossier_ssh
    echo -e "${BLEU}--- Configuration automatique du fichier ~/.ssh/config ---${RESET}"

    read -p "Nom de la clé : " nom
    read -p "Alias Host (ex: github-perso) : " alias
    read -p "HostName (ex: github.com) : " host
    read -p "Port (443 pour GitHub) : " port

    if [ ! -f ~/.ssh/id_ed25519_$nom ]; then
        echo -e "${ROUGE}Erreur : clé introuvable.${RESET}"
        return
    fi

    cat >> ~/.ssh/config <<EOF

Host $alias
    HostName $host
    User git
    Port $port
    IdentityFile ~/.ssh/id_ed25519_$nom
    IdentitiesOnly yes
    AddKeysToAgent yes
EOF

    echo -e "${VERT}Bloc ajouté dans ~/.ssh/config${RESET}"
}

# 5) Tester une connexion SSH
tester_connexion() {
    echo -e "${BLEU}--- Test de connexion SSH ---${RESET}"
    read -p "Alias Host à tester : " alias
    ssh -T $alias
}

# 6) Lister les clés
liste_cles() {
    echo -e "${BLEU}--- Liste des clés SSH disponibles ---${RESET}"
    ls -1 ~/.ssh/id_ed25519_* 2>/dev/null | sed 's/.pub//g'
}

# 7) Initialiser le token GitHub
initialiser_token() {
    echo -e "${BLEU}--- Initialisation du token GitHub (HTTPS) ---${RESET}"
    read -p "Colle ton token GitHub (PAT) : " token

    git config --global credential.helper store
    echo "https://$token:x-oauth-basic@github.com" > ~/.git-credentials

    echo -e "${VERT}Token enregistré.${RESET}"
}

# 8) Corriger permissions SSH
corriger_permissions() {
    echo -e "${BLEU}--- Correction des permissions SSH ---${RESET}"
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/id_ed25519_* 2>/dev/null
    chmod 644 ~/.ssh/id_ed25519_*.pub 2>/dev/null
    echo -e "${VERT}Permissions corrigées.${RESET}"
}

# 10) Supprimer une clé SSH
supprimer_une_cle() {
    echo -e "${BLEU}--- Suppression d'une clé SSH ---${RESET}"

    echo "Clés disponibles :"
    ls -1 ~/.ssh/id_ed25519_* 2>/dev/null | sed 's/.pub//g'

    echo ""
    read -p "Nom EXACT de la clé à supprimer (ex: id_ed25519_perso) : " cle

    if [ -f ~/.ssh/$cle ]; then
        rm -f ~/.ssh/$cle ~/.ssh/$cle.pub
        echo -e "${VERT}Clé $cle supprimée.${RESET}"
    else
        echo -e "${ROUGE}Erreur : clé introuvable.${RESET}"
    fi

    read -p "Appuie sur ENTER pour revenir au menu..."
}

# 11) Supprimer TOUTES les clés SSH
supprimer_toutes_cles() {
    echo -e "${BLEU}--- Suppression de TOUTES les clés SSH ---${RESET}"

    rm -f ~/.ssh/id_ed25519_* ~/.ssh/*git* ~/.ssh/*.pub 2>/dev/null

    echo -e "${VERT}Toutes les clés SSH ont été supprimées.${RESET}"

    mkdir -p ~/.ssh
    chmod 700 ~/.ssh

    read -p "Appuie sur ENTER pour revenir au menu..."
}

# MENU PRINCIPAL
menu_principal() {
    clear
    echo -e "${JAUNE}==============================================${RESET}"
    echo -e "${JAUNE}   COCKPIT SSH + TOKEN – BERNARDOPS V7 PRO    ${RESET}"
    echo -e "${JAUNE}==============================================${RESET}"

    echo -e "${BLEU}1) Générer une nouvelle clé SSH${RESET}"
    echo -e "${BLEU}2) Ajouter une clé à l'agent SSH${RESET}"
    echo -e "${BLEU}3) Afficher une clé publique${RESET}"
    echo -e "${BLEU}4) Ajouter un bloc dans ~/.ssh/config${RESET}"
    echo -e "${BLEU}5) Tester une connexion SSH${RESET}"
    echo -e "${BLEU}6) Lister les clés disponibles${RESET}"
    echo -e "${BLEU}7) Initialiser le token GitHub${RESET}"
    echo -e "${BLEU}8) Corriger les permissions SSH${RESET}"
    echo -e "${BLEU}10) Supprimer une clé SSH${RESET}"
    echo -e "${BLEU}11) Supprimer TOUTES les clés SSH${RESET}"
    echo -e "${BLEU}9) Quitter${RESET}"

    echo ""
    read -p "Choix : " choix

    case $choix in
        1) generer_cle ;;
        2) ajouter_agent ;;
        3) afficher_pub ;;
        4) configurer_ssh ;;
        5) tester_connexion ;;
        6) liste_cles ;;
        7) initialiser_token ;;
        8) corriger_permissions ;;
        10) supprimer_une_cle ;;
        11) supprimer_toutes_cles ;;
        9) exit 0 ;;
        *) echo -e "${ROUGE}Choix invalide.${RESET}" ;;
    esac

    echo ""
    read -p "Appuie sur ENTER pour revenir au menu..."
    menu_principal
}

menu_principal
