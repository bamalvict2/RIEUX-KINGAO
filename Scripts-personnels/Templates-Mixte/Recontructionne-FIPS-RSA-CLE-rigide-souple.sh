#!/bin/bash

# === Couleurs ===
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

###############################################
# 🔍 COMMANDES GÉNÉRALES — VISU FIPS / SYSTEME #
###############################################
# cat /proc/sys/crypto/fips_enabled — État FIPS
# uname -r — Voir kernel FIPS
# dpkg -l | grep fips — Paquets FIPS
# openssl version -fips — OpenSSL FIPS
# ssh -Q key — Algorithmes SSH
# ls /etc/default/grub.d/*fips* — Fichiers GRUB FIPS
#
# 👉 SSH = protocole  
# 👉 OpenSSL = moteur crypto du système ---- OpenSSL → ne gère pas SSH directement
# 👉 Les clés RSA/ED25519 = algorithmes

           
   # Machine A (API banque Chicago)

   # Kernel FIPS

   # GRUB avec fips=1

   # Mode RIGIDE

   # RSA 2048/4096 uniquement
 #####################################

   # Machine B (dev, GitHub)

   # Kernel normal

   # GRUB sans FIPS

   # Mode SOUPLE

   # ED25519 OK

     👉 Deux machines dans le même domaine, deux comportements différents. 
     






###############################################
# 🔍 COMMANDES GÉNÉRALES — VISU FIPS / SYSTEME #
###############################################
# cat /proc/sys/crypto/fips_enabled — État FIPS
# uname -r — Voir kernel FIPS
# dpkg -l | grep fips — Paquets FIPS
# openssl version -fips — OpenSSL FIPS
# ssh -Q key — Algorithmes SSH
# ls /etc/default/grub.d/*fips* — Fichiers GRUB FIPS
#
# 👉 SSH = protocole  
# 👉 OpenSSL = moteur crypto du système
# 👉 Les clés RSA/ED25519 = algorithmes

###############################################
# === Fonctions ===
###############################################

gen_standard() {
    clear
    echo "=== 🔧 Génération clé standard (RSA 2048) ==="
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -C "standard-key"
    echo "🟩 Clé standard générée."
    read -p "ENTER..."
}

gen_kingsecure() {
    clear
    echo "=== 🟦 Génération clé KINGSECURE (SOUPLE — RSA 2048) ==="
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/KINGSECURE -C "KINGSECURE"
    echo "🟩 Clé KINGSECURE générée."
    read -p "ENTER..."
}

gen_kingpro() {
    clear
    echo "=== 🟥 Génération clé KING-PRO (RIGIDE — RSA 4096) ==="
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/KING-PRO -C "bamalvict@KING-PRO"
    echo "🟩 Clé KING-PRO générée."
    read -p "ENTER..."
}

check_kingpro_fips() {
    clear
    echo "=== 🔍 Vérification KING-PRO (FIPS) ==="

    KEY="$HOME/.ssh/KING-PRO.pub"

    if [ ! -f "$KEY" ]; then
        echo "❌ Aucune clé KING-PRO détectée."
        echo "➡️  Génère-la via l'option 3."
        read -p "ENTER..."
        return
    fi

    bits=$(ssh-keygen -lf "$KEY" | awk '{print $1}')

    echo "📄 Clé détectée : $KEY"
    echo "🔢 Taille : $bits bits"

    if [ "$bits" -ge 4096 ]; then
        echo "🟩 Conforme FIPS (RSA 4096 — mode RIGIDE)"
    elif [ "$bits" -ge 2048 ]; then
        echo "🟨 Conforme FIPS (RSA >= 2048) mais pas rigide"
    else
        echo "🟥 NON conforme FIPS"
    fi

    read -p "ENTER..."
}

show_pubkey() {
    clear
    echo "=== 🔑 Affichage clé publique ==="
    ls ~/.ssh/*.pub 2>/dev/null
    echo ""
    read -p "Nom du fichier .pub à afficher : " pub
    clear
    cat ~/.ssh/$pub 2>/dev/null || echo "❌ Fichier introuvable."
    echo ""
    read -p "ENTER..."
}

test_github() {
    clear
    echo "=== 🧪 Test SSH GitHub ==="
    ssh -T git@github.com
    echo ""
    read -p "ENTER..."
}

check_fips_system() {
    clear
    echo "=== 🔍 Vérification FIPS système (KINGDOMAINE) ==="

    fips=$(cat /proc/sys/crypto/fips_enabled)

    if [ "$fips" = "1" ]; then
        echo "🟥 KINGDOMAINE : MODE RIGIDE (FIPS ACTIVÉ)"
    else
        echo "🟩 KINGDOMAINE : MODE SOUPLE (FIPS DÉSACTIVÉ)"
    fi

    read -p "ENTER..."
}

disable_fips() {
    clear
    echo "=== ⚠️ Désactivation FIPS (KINGDOMAINE → SOUPLE) ==="
    echo "Modification de /etc/default/grub..."

    sudo sed -i 's/fips=1//g' /etc/default/grub
    sudo update-grub

    echo "🟩 FIPS désactivé. Redémarre la machine."
    read -p "ENTER..."
}

# 🔹 Option 9 : niveau de risque
risk_level() {
    clear
    echo "=== 🎚️ Définir niveau de risque ==="
    echo "1) SOUPLE (KINGSECURE)"
    echo "2) RIGIDE (KING-PRO)"
    echo "3) AUTO"
    read -p "Choix : " r
    echo "🟩 Niveau défini."
    read -p "ENTER..."
}

# 🔹 Option 10 : SSH config
gen_ssh_config() {
    clear
    echo "=== ⚙️ Génération SSH config ==="

    cat > ~/.ssh/config <<EOF
Host github.com
    HostName ssh.github.com
    Port 443
    IdentityFile ~/.ssh/KINGSECURE
    PubkeyAcceptedAlgorithms +ssh-rsa
    HostkeyAlgorithms +ssh-rsa

Host kingpro
    HostName 192.168.1.10
    IdentityFile ~/.ssh/KING-PRO
EOF

    chmod 600 ~/.ssh/config
    echo "🟩 SSH config généré."
    read -p "ENTER..."
}

###############################################
# === Nouvelle fonction : Sortie FIPS complète ===
###############################################

sortir_fips() {
    clear
    echo "=== ⚙️ Sortie du mode FIPS (KINGDOMAINE → SOUPLE) ==="
    echo "🔍 Recherche de l'entrée GRUB du kernel SOUPLE..."

    ENTRY_LINE=$(grep -n "menuentry 'Ubuntu'" /boot/grub/grub.cfg | head -n 1 | cut -d: -f1)

    if [ -z "$ENTRY_LINE" ]; then
        echo "🟥 Impossible de trouver l'entrée GRUB du kernel SOUPLE."
        read -p "ENTER..."
        return
    fi

    INDEX=$((ENTRY_LINE - 1))

    echo "🟦 Entrée GRUB SOUPLE trouvée : index $INDEX"
    echo "📝 Mise à jour de /etc/default/grub..."

    sudo sed -i "s/^GRUB_DEFAULT=.*/GRUB_DEFAULT=$INDEX/" /etc/default/grub
    sudo update-grub

    echo "🟩 FIPS désactivé dans GRUB."
    echo "🔄 Redémarre la machine pour appliquer le mode SOUPLE."
    read -p "ENTER..."
}

###############################################
# === MENU ===
###############################################

while true; do
clear
echo -e "=== 👑 KINGDOMAINE — SOUPLE / RIGIDE / AUTO ===\n"
echo "1) Générer clé standard"
echo "2) Générer clé KINGSECURE (SOUPLE)"
echo "3) Générer clé KING-PRO (RIGIDE)"
echo "4) Vérifier KING-PRO (FIPS)"
echo "5) Afficher clé publique"
echo "6) Tester SSH GitHub"
echo "7) Vérifier FIPS système"
echo "8) Désactiver FIPS (simple)"
echo "9) Définir niveau de risque"
echo "10) Générer fichier SSH config"
echo "11) Sortir du mode FIPS (forcer kernel SOUPLE)"
echo "12) —"
echo "13) Pense-bête Git"
echo "14) Pense-bête FIPS / Système"
echo "0) Quitter"
echo ""
read -p "👉 Choix : " choice

case $choice in
    1) gen_standard ;;
    2) gen_kingsecure ;;
    3) gen_kingpro ;;
    4) check_kingpro_fips ;;
    5) show_pubkey ;;
    6) test_github ;;
    7) check_fips_system ;;
    8) disable_fips ;;
    9) risk_level ;;
    10) gen_ssh_config ;;
    11) sortir_fips ;;

    13)
        clear
        echo "📘 Pense-bête Git :"
        echo "🔹 git status"
        echo "🔹 git add -A"
        echo "🔹 git commit -m"
        echo "🔹 git push"
        echo "🔹 git pull"
        echo "🔹 git branch"
        echo "🔹 git merge"
        echo "🔹 git log"
        echo ""
        read -p 'ENTER...'
    ;;

    14)
        clear
        echo "📘 Pense-bête FIPS / Système :"
        echo "🔹 cat /proc/sys/crypto/fips_enabled"
        echo "🔹 uname -r"
        echo "🔹 dpkg -l | grep fips"
        echo "🔹 openssl version -fips"
        echo "🔹 ssh -Q key"
        echo "🔹 ls /etc/default/grub.d/*fips*"
        echo "🔹 journalctl -b | grep -i fips"
        echo "🔹 update-grub"
        echo ""
        read -p 'ENTER...'
    ;;

    0) exit ;;
    *) echo "❌ Choix invalide" ; sleep 1 ;;
esac
done
