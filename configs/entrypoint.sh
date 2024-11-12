#!/bin/bash

# Inicia o MySQL em segundo plano
service mysql start

# Espera até que o MySQL esteja disponível
while ! mysqladmin ping -h "localhost" --silent; do
    echo "Aguardando o MySQL iniciar..."
    sleep 2
done

# Configuração do banco de dados e permissões no MySQL
mysql -e "CREATE DATABASE IF NOT EXISTS radius_db;"
mysql -e "CREATE USER IF NOT EXISTS 'radius'@'localhost' IDENTIFIED BY 'radiuspassword';"
mysql -e "GRANT ALL PRIVILEGES ON radius_db.* TO 'radius'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"
mysql radius_db < /etc/freeradius/3.0/mods-config/sql/main/mysql/schema.sql

# Inicia o FreeRADIUS
freeradius -X