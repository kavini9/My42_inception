#!/bin/sh

echo "==> Setting up MariaDB directories..."
mkdir -p /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld
chmod 777 /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "==> Initializing MariaDB database..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

    echo "==> Bootstrapping database and users..."
    /usr/bin/mysqld --user=mysql --bootstrap << EOF

USE mysql;
FLUSH PRIVILEGES;

ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';
FLUSH PRIVILEGES;
EOF

#TODO:change the variable names in bove commands.
    echo "==> Database initialization complete!"
else
    echo "==> MariaDB database already exists. Skipping initialization."
fi

echo "==> Starting MariaDB daemon in the foreground..."

exec /usr/bin/mysqld --user=mysql --console