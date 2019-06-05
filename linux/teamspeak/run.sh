#!/bin/bash

#Script by Ryan M - 05/06/2019

RED='\033[0;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
RESET='\033[0m'

if [ $(id -u) != 0 ]; then
    echo "${RED}Merci de lancer le script avec les droits d'administrateur (root)${RESET}"
    exit
fi

echo "-----------------------------------------------"
echo " "
echo " "
echo "${BLUE}Installation automatique d'un serveur TeamSpeak3${RESET}"
echo " "
echo " "
echo "• Par Ryan M (${BLUE}Ryan Mrc#1478${RESET})"
echo " "
echo " "
echo "${GREEN}Lancement dans 5 secondes${RESET}"
echo " "
echo " "
echo "-----------------------------------------------"

sleep 1
echo "${BLUE}Lancement dans 4 secondes${RESET}"
sleep 1
echo "${GREEN}Lancement dans 3 secondes${RESET}"
sleep 1
echo "${RED}Lancement dans 2 secondes${RESET}"
sleep 1
echo "${BLUE}Lancement dans 1 secondes${RESET}"

sleep 1

echo "Mise à jour des packets (${RED}apt-get update${RESET})"
apt-get update

echo "Mise à jour des packets (${RED}apt-get upgrade${RESET})"
apt-get update

echo "${BLUE}Création de l'utilisateur${RESET} (${RED}teamspeak${RESET})"
adduser teamspeak
sleep 2
su teamspeak
cd

echo "${BLUE}Installation des librairies du serveur${RESET}"
wget http://dl.4players.de/ts/releases/3.7.1/teamspeak3-server_linux_amd64-3.7.1.tar.bz2

echo "${BLUE}Décompression${RESET}"
tar jxvf teamspeak3-server_linux_amd64-3.5.0.tar.bz2

echo "${BLUE}Renommer & suppression de l'archive compressée${RESET}"
mv teamspeak3-server_linux_amd64/ ServeurTS/
rm teamspeak3-server_linux_amd64-3.5.0.tar.bz2
cd ServeurTS



ip=$(LANG=c ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}' | tee /dev/tty)

if [ -z $ip ]; then
    ip=$(LANG=c ifconfig venet0:0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}' | tee /dev/tty)
fi
