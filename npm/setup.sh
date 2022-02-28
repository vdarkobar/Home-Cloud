#!/bin/bash
clear
echo -ne "${RED}Enter Time Zone: "; read TZONE; \
echo -ne "${RED}Enter NPM Port Number: "; read PORTN; \
echo | tr -dc A-Za-z0-9 </dev/urandom | head -c 32 > secrets/db_root_pwd.secret && \
echo | tr -dc A-Za-z0-9 </dev/urandom | head -c 32 > secrets/mysql_pwd.secret && \
sed -i "s|01|${TZONE}|" .env && \
sed -i "s|02|${PORTN}|" .env && \
rm README.md && \
rm data/mysql/tmp && \
rm letsencrypt/tmp && \
sudo rm -rf shared/ && \
sudo chown -R root:root secrets/ && \
sudo chmod -R 600 secrets/ && \
while true; do
    read -p "Execute 'docker-compose up -d' now? (y/n)" yn
    case $yn in
        [Yy]* ) sudo docker-compose up -d; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
