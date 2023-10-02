#!/bin/sh
#
# Install the custom apps listed in NEXTCLOUD_CUSTOM_APPS.
#

run_as() {
    if [ "$(id -u)" = 0 ]; then
        su -p www-data -s /bin/sh -c "$1"
    else
        sh -c "$1"
    fi
}

echo "installing custom apps: $NEXTCLOUD_CUSTOM_APPS"
for app in $NEXTCLOUD_CUSTOM_APPS; do
  php /var/www/html/occ app:install "$app" || echo "Warning: Failed to install custom app '$app'!"
done



php /var/www/html/occ app:install "maps"