#!/bin/sh

echo "==> Waiting for MariaDB to wake up..."

while ! mariadb -h mariadb -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SELECT 1;" >/dev/null 2>&1; do
    sleep 2
done
echo "==> MariaDB is awake and ready!"

if [ ! -f /var/www/html/wp-config.php ]; then
    echo "==> wp-config.php not found. Downloading and configuring WordPress..."
    
    wp core download --allow-root

    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb \
        --allow-root

    echo "==> Installing WordPress base..."
    wp core install \
        --url=https://$DOMAIN_NAME \
        --title="$WP_TITLE" \
        --admin_user=$WP_ADMIN \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email \
        --allow-root

    echo "==> Creating the second standard user..."
    wp user create $WP_USER $WP_USER_EMAIL \
        --role=author \
        --user_pass=$WP_USER_PASSWORD \
        --allow-root

    echo "==> Setting correct permissions for NGINX to read the files..."
    chown -R www-data:www-data /var/www/html
    
    echo "==> WordPress installation complete!"
else
    echo "==> WordPress is already installed. Skipping setup."
fi

echo "==> Handing over control to PHP-FPM..."

exec php-fpm83 -F