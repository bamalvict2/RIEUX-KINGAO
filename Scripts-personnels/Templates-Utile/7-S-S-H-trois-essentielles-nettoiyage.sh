# --- ssh-core.sh ---

# Détection de GNOME Keyring (agent parasite)
detecter_agent_parasite() {
    if echo "$SSH_AUTH_SOCK" | grep -q "keyring"; then
        echo -e "${ROUGE}[!] GNOME Keyring contrôle SSH (agent parasite détecté)${RESET}"
        return 1
    fi
    return 0
}

# Forcer un vrai ssh-agent
forcer_vrai_agent() {
    echo -e "${JAUNE}Arrêt des agents parasites...${RESET}"
    pkill ssh-agent 2>/dev/null
    pkill gpg-agent 2>/dev/null
    pkill -f keyring 2>/dev/null

    echo -e "${BLEU}Lancement d'un vrai ssh-agent...${RESET}"
    eval "$(ssh-agent -s)"
}

# Vérification intelligente de l’agent SSH
verifier_agent() {
    detecter_agent_parasite
    if [ $? -eq 1 ]; then
        echo -e "${JAUNE}Correction : bascule vers un vrai ssh-agent...${RESET}"
        forcer_vrai_agent
        return
    fi

    if ! pgrep -u "$USER" ssh-agent >/dev/null; then
        echo -e "${JAUNE}ssh-agent non lancé, démarrage...${RESET}"
        eval "$(ssh-agent -s)"
    fi
}
