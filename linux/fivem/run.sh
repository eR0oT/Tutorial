#!/bin/bash

#Colors
RED='\033[0;31m'
YELLOW='\e[93m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
RESET='\033[0m'

SERVER_CFG="https://raw.githubusercontent.com/privatehebergfr/Tutorial/master/linux/fivem/server-template.cfg"

clear
echo "-----------------------------------------------"
echo "Installation automatique d’un FXServer (FiveM) sous Debian"
echo "Par PrivateHeberg (privateheberg.com)"
echo -e "${GREEN}Lancement dans 5 secondes${RESET}"
echo "-----------------------------------------------"
sleep 5

if [ $(id -u) != 0 ]; then
    clear
    echo -e "${RED}Merci de lancer le script avec les droits d'administrateur (root)${RESET}"
    exit
fi

# Depencendy
echo -e "${GREEN}Installation des dépendances.${RESET}"
apt-get update
apt-get upgrade
apt-get install curl nano git screen sed mono-complete ca-certificates -y
apt-get autoremove avahi-daemon
clear

# Register folder
echo -e "${GREEN}Veuillez définir le nom du dossier où sera installé votre FXserver${RESET}"
read -p "Nom du dossier : " server_folder_name

if [ ! -d "$HOME/"$server_folder_name"" ]; then
    echo "${GREEN} Votre serveur est en cours d'installation dans le path suivant ${RESET}""$HOME/"$server_folder_name""
else
    echo "${RED}Nous ne pouvons pas exécuter le script le dossier "$server_folder_name" et déjà présent dans le path de suivant ""$HOME/"$server_folder_name"${RESET}"
    exit
fi

#Folder
mkdir "$HOME/"$server_folder_name""
mkdir "$HOME/"$server_folder_name"/download"
mkdir "$HOME/"$server_folder_name"/server"
mkdir "$HOME/"$server_folder_name"/server-data"
clear

#Artifacts build
LATEST_VERSION=`wget -q -O - https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/ | grep '<a href' | tail -1 | grep -Po '(?<=href=").{44}'`
echo -e "${GREEN}Artifacts Server version. (Veuillez patienter 5 secondes) : ${BLUE}"$LATEST_VERSION"${RESET} "
sleep 5
clear

# Download Artifacts build
echo -e "${GREEN}Lancement du téléchargement de artifacts FXServer${RESET}"
wget -q --show-progress "https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/$LATEST_VERSION/fx.tar.xz" -P "$HOME/"$server_folder_name"/download"
echo -e "${YELLOW}Veuillez ignorer les erreurs de décompression que vous pourrez trouver.${RESET}"
tar -xf "$HOME/"$server_folder_name"/download/fx.tar.xz" -C "$HOME/"$server_folder_name"/server"
echo -e "${GREEN}Décompression terminée. ""$HOME/"$server_folder_name"/server""${RESET}"
sleep 2
clear

# Download CFX Data
echo -e "${GREEN}Téléchargement des cfx-server-data${RESET}"
git clone https://github.com/citizenfx/cfx-server-data.git "$HOME/"$server_folder_name"/server-data"
wget -q --show-progress "https://image.noelshack.com/fichiers/2019/15/7/1555261743-ph-fivem-logo.png" -P "$HOME/"$server_folder_name"/server-data"
echo -e "${GREEN}Téléchargement des cfx-server-data terminé ""$HOME/"$server_folder_name"/server-data""${RESET}"
sleep 2
clear


# Download template cfg
echo -e "${GREEN}Téléchargement de la template serveur.cfg ${RESET}"
wget -q --show-progress "${SERVER_CFG}" -P "$HOME/"$server_folder_name"/server-data"
echo -e "${GREEN}Téléchargement du serveur.cfg terminer ${RESET}"
sleep 2
clear

echo "-----------------------------------------------"
echo "Vous allez maintenant passer à l'étape de configuration de votre serveur. "
echo "Vous pouvez cependant modifier les paramètres de votre serveur une fois l'installation terminée si vous vous êtes tromper pendant le paramétrage de celui-ci."
echo ""
echo "Voici ci-dessous le lien d'accès du fichier de configuration."
echo ""
echo "$HOME/"$server_folder_name"/server-data/server.cfg"
echo ""
echo -e "${GREEN}Lancement dans 10 secondes${RESET}"
echo "-----------------------------------------------"
sleep 10
clear

echo "-----------------------------------------------"
echo -e "${GREEN}Veuillez inscrire le nombre de jouer au maximum sur votre serveur. ${RESET}"
echo ""
echo -e "${YELLOW}Attention vous ne pouvez pas définir plus de 32 joueurs pour le moment si vous n'êtes pas contributeur ${RED}FiveM Element Club Argentum. ${RESET}"
echo ""
echo "Vous pouvez vous renseigner sur comment obtenir ce statut directement sur le site officiel de fivem "
echo ""
echo "https://fivem.net/"
echo "-----------------------------------------------"
read -p "Nombre de joueurs maximum sur votre serveur : " player_limite
sed -i 's/ph_max_player_replace/'$player_limite'/g' "$HOME/"$server_folder_name"/server-data/server.cfg"
sleep 1
clear

read -p "Veuillez inscrire le nom de votre serveur : " name_server
sed -i 's/ph_server_name_replace/'$name_server'/g' "$HOME/"$server_folder_name"/server-data/server.cfg"
sleep 1
clear

echo "-----------------------------------------------"
echo -e "${GREEN}Veuillez inscrire la clé de votre serveur fivem.${RESET}"
echo ""
echo -e "${YELLOW}Pour obtenir une clé rendez-vous à l'adresse suivante : ${RED}https://keymaster.fivem.net/${RESET}"
echo "-----------------------------------------------"
read -p "Clé de licence : " key_server
sed -i 's/ph_license_key_replace/'$key_server'/g' "$HOME/"$server_folder_name"/server-data/server.cfg"
sleep 1
clear

echo "-----------------------------------------------"
echo -e "${GREEN}Activer scripthook vous permettra d'utiliser des mod menu externe à GTA compatible sur fivem tel que le lambda menu ou autre${RESET}"
echo ""
echo -e "${YELLOW}Pour activer scripthook tapez 1 et appuyez sur entrée pour finaliser la procédure${RESET}"
echo -e "${YELLOW}Si vous ne souhaitez pas activer scripthook tapez 2 et appuyez sur Entrée pour finaliser la procédure${RESET}"
echo ""
echo "-----------------------------------------------"
read -p "0 ou 1 : " scripthook_status
sed -i 's/ph_scripthook_enabled_replace/'$scripthook_status'/g' "$HOME/"$server_folder_name"/server-data/server.cfg"
sleep 1
clear

rm -rf "$HOME/"$server_folder_name"/download"
rm "$HOME/run.sh"

read -p "Voulez-vous démarrer votre serveur ? Y/N" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
	cd $HOME/$server_folder_name/server-data
	screen -S bash $HOME/$server_folder_name/server/run.sh +exec server.cfg
then
	echo -e "${GREEN} Vous venez de terminer l'installation de votre serveur fivem.${RESET}"
	echo ""
	echo -e "${GREEN} Pour le démarrer il vous suffira d'exécuter la commande suivante.${RESET}"
	echo ""
	echo "cd $HOME/"server_folder_name"/server-data && screen -S bash $HOME/"$server_folder_name"/server/run.sh +exec server.cfg"
	echo ""
	echo -e "${GREEN} Retrouver toutes nos offres Linux sur notre site internet. ${YELLOW}https://privateheberg.com/${RESET}"
    exit
fi
