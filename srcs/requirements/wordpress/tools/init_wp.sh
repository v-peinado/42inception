#! /bin/sh

if [ ! -f wp-config.php ]; then
    wp core download --allow-root || { echo "Failed to download WordPress"; exit 1; }
    wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_USER_PWD --dbhost=$DB_HOSTNAME --allow-root || { echo "Failed to create wp-config.php"; exit 1; }
    wp core install --url=$DOMAIN_NAME --title="$WP_TITLE" --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PWD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root || { echo "Failed to install WordPress"; exit 1; }
    wp user create $WP_USER $WP_USER_EMAIL --role=author --user_pass=$WP_USER_PWD --allow-root || { echo "Failed to create user"; exit 1; }
    wp theme install astra --activate --allow-root || { echo "Failed to install theme"; exit 1; }
    
   # Update WordPress and Site URLs to use the correct domain
    wp option update home "https://$DOMAIN_NAME" --allow-root || { echo "Failed to update home URL"; exit 1; }
    wp option update siteurl "https://$DOMAIN_NAME" --allow-root || { echo "Failed to update site URL"; exit 1; } 

    echo "WordPress setup completed successfully."
else
    echo "wp-config.php already exists, skipping WordPress setup."
fi

/usr/sbin/php-fpm7.4 -F
