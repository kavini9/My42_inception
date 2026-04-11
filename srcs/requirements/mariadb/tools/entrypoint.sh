#!/bin/sh

# 1. Reclaim ownership of the mounted volume
# This fixes the issue where Docker Compose mounts the host volume as 'root'
chown -R mysql:mysql /var/lib/mysql

# 2. Check if the database is already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "==> Initializing MariaDB database..."
    
    # Initialize the base database directory structure
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

    echo "==> Bootstrapping database and users..."
    
    # Use --bootstrap to run SQL commands without starting a background network daemon.
    # The << EOF is a "HereDoc" that feeds the text block directly into the command.
    /usr/bin/mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

-- Secure the root user using environment variables
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- Create the required WordPress Database
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8 COLLATE utf8_general_ci;

-- Create the WordPress database user and grant privileges
CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';

-- Apply changes
FLUSH PRIVILEGES;
EOF

    echo "==> Database initialization complete!"
else
    echo "==> MariaDB database already exists. Skipping initialization."
fi

echo "==> Starting MariaDB daemon in the foreground..."

# 3. Replace the shell with the MariaDB process in the foreground
# This ensures the container stays alive cleanly without 'tail -f' or infinite loops.
exec /usr/bin/mysqld --user=mysql --console