#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y mysql-server

sed -i "s/^bind-address.*/bind-address = ${DB_IP}/" /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql

mysql <<EOF
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'192.168.56.%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'192.168.56.%';
FLUSH PRIVILEGES;
EOF