#!/bin/sh

#Script PrivateHeberg - Edit : 05/06/19

RED='\033[0;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
RESET='\033[0m'

if [ $(id -u) != 0 ]; then
    clear
    echo "${RED}Vous ne possédez pas les permissions. Merci de lancer le script avce l'utilisateur administrateur (root)${RESET}"
    exit
fi

ip=$(LANG=c ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}' | tee /dev/tty)

if [ -z $ip ]; then
    ip=$(LANG=c ifconfig venet0:0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}' | tee /dev/tty)
fi

clear
echo "-----------------------------------------------"
echo " "
echo "Installation automatique d’un serveur Apache2, de PHP et d'un serveur MySQL sous Debian"
echo " "
echo "• Par Ryan M (${RED}Ryan Mrc#1478${RESET})"
echo " "
echo "${BLUE}Lancement dans 5 secondes${RESET}"
echo "-----------------------------------------------"
sleep 7

clear
echo "• Mise à jour des packets (${BLUE}apt-get update${RESET})"
sleep 2
apt-get update

clear
echo "• Installation d'Apache2 (${BLUE}apt-get upgrade${RESET})"
sleep 2
apt-get install apache2

clear
echo "• Installation de PHP (${BLUE}V.7.2${RESET})"
sleep 2
apt-get install apt-transport-https lsb-release ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" >> /etc/apt/sources.list.d/php.list
apt-get update
apt-get install php7.2 php7.2-opcache libapache2-mod-php7.2 php7.2-mysql php7.2-curl php7.2-json php7.2-gd  php7.2-intl php7.2-mbstring php7.2-xml php7.2-zip php7.2-fpm php7.2-readline

clear
echo "• Redémarrage d'Apache2 (${BLUE}service apache2 restart${RESET})"
sleep 2
service apache2 restart

rm /var/www/html/index.html
echo "<?php phpinfo();" >> /var/www/html/index.php

clear
echo "• Installation du serveur MySQL et de phpMyAdmin"
sleep 2
apt-get install mysql-server
sleep 7
echo "• Installation MYSQL réussi avec succès"
apt-get install phpmyadmin
sleep 7
echo " "
echo "• Installation de PHPMyAdmin réussi avec succès"
echo " "
echo "• Changement de répertoire PHPMyAdmin"
echo " "
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin

clear
echo "• Le lien de votre site est désormais disponible : http://$ip/"
echo " "
echo "• Le lien de phpMyadmin est désormais disponible : http://$ip/phpmyadmin"
echo " "
echo "• Le répertoire pour update votre site internet : /var/www/html/"
